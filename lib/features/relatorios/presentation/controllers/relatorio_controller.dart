import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../categorias/domain/entities/categoria.dart';
import '../../../categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../../financas/domain/models/movimentacao.dart';
import '../../../financas/domain/models/relatorio.dart';
import '../../../transacoes/domain/entities/transacao.dart';
import '../../../transacoes/domain/usecases/listar_transacoes_usecase.dart';
import '../../domain/entities/evolucao_mensal.dart';
import '../../domain/entities/filtro_relatorio.dart' as dominio;
import '../../domain/entities/gasto_por_categoria.dart';
import '../../domain/entities/totais_periodo.dart';
import '../../domain/usecases/obter_evolucao_mensal_usecase.dart';
import '../../domain/usecases/obter_gastos_por_categoria_usecase.dart';
import '../../domain/usecases/obter_totais_usecase.dart';

/// Controlador de apresentação da tela T05 (Relatórios).
///
/// Converte os filtros visuais em consultas agregadas no SQLite e monta o
/// modelo exibido pela página, sempre recarregando após alterações no período.
class RelatorioController extends ChangeNotifier {
  final ObterTotaisUseCase _obterTotaisUseCase;
  final ObterGastosPorCategoriaUseCase _obterGastosPorCategoriaUseCase;
  final ObterEvolucaoMensalUseCase _obterEvolucaoMensalUseCase;
  final ListarTransacoesUseCase _listarTransacoesUseCase;
  final ListarCategoriasPorTipoUseCase _listarCategoriasPorTipoUseCase;

  RelatorioController({
    required ObterTotaisUseCase obterTotaisUseCase,
    required ObterGastosPorCategoriaUseCase obterGastosPorCategoriaUseCase,
    required ObterEvolucaoMensalUseCase obterEvolucaoMensalUseCase,
    required ListarTransacoesUseCase listarTransacoesUseCase,
    required ListarCategoriasPorTipoUseCase listarCategoriasPorTipoUseCase,
  })  : _obterTotaisUseCase = obterTotaisUseCase,
        _obterGastosPorCategoriaUseCase = obterGastosPorCategoriaUseCase,
        _obterEvolucaoMensalUseCase = obterEvolucaoMensalUseCase,
        _listarTransacoesUseCase = listarTransacoesUseCase,
        _listarCategoriasPorTipoUseCase = listarCategoriasPorTipoUseCase;

  bool _carregando = false;
  String? _mensagemErro;

  TotaisPeriodo? _totais;
  List<GastoPorCategoria> _gastos = const [];
  List<EvolucaoMensal> _evolucao = const [];
  List<Transacao> _movimentacoes = const [];
  List<Categoria> _categorias = const [];

  TotaisPeriodo _totaisAnteriores = const TotaisPeriodo(
    totalReceitas: 0,
    totalDespesas: 0,
    saldo: 0,
  );

  FiltroRelatorio _filtro = _filtroDoMes(DateTime.now());

  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  FiltroRelatorio get filtro => _filtro;

  TotaisPeriodo? get totais => _totais;
  List<GastoPorCategoria> get gastos => List.unmodifiable(_gastos);
  List<EvolucaoMensal> get evolucao => List.unmodifiable(_evolucao);
  List<Transacao> get movimentacoes => List.unmodifiable(_movimentacoes);

  int get totalReceitasCentavos => _totais?.totalReceitas ?? 0;
  int get totalDespesasCentavos => _totais?.totalDespesas ?? 0;
  int get saldoCentavos => _totais?.saldo ?? 0;

  /// Categorias reais do banco, usadas pelos filtros da página.
  List<String> get categoriasDisponiveis {
    final nomes = _categorias.map((c) => c.nome).toSet().toList()..sort();
    return ['Todas as categorias', ...nomes];
  }

  /// Carrega os dados referentes ao mês informado (período "Este mês").
  Future<void> carregarMes(DateTime mes) async {
    _filtro = _filtroDoMes(mes);
    await carregar();
  }

  /// Aplica filtros escolhidos na tela e recarrega todos os indicadores.
  Future<void> aplicarFiltros(FiltroRelatorio filtro) async {
    _filtro = filtro;
    await carregar();
  }

  /// Restaura o filtro padrão (mês atual) e recarrega.
  Future<void> limparFiltros() async {
    _filtro = _filtroDoMes(DateTime.now());
    await carregar();
  }

  /// Executa as consultas agregadas do período atual.
  Future<void> carregar() async {
    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      if (_categorias.isEmpty) {
        await _carregarCategorias();
      }

      final filtroConsulta = _paraDominio(_filtro);

      final totais = await _obterTotaisUseCase(filtroConsulta);
      final gastos = await _obterGastosPorCategoriaUseCase(filtroConsulta);
      final evolucao = await _obterEvolucaoMensalUseCase(filtroConsulta);
      final transacoes = await _listarTransacoesUseCase();
      final anteriores = await _obterTotaisUseCase(
        _filtroPeriodoAnterior(filtroConsulta),
      );

      _totais = totais;
      _gastos = gastos;
      _evolucao = evolucao;
      _totaisAnteriores = anteriores;
      _movimentacoes = transacoes.where(_pertenceAoFiltro).toList();
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar o relatório.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Modelo pronto para consumo pelos widgets da tela de relatórios.
  ConteudoRelatorio get conteudoRelatorio {
    final inicio = _filtro.dataInicial;
    final fim = _filtro.dataFinal;
    final referencia = _referencia(inicio, fim);

    final categorias = <CategoriaRelatorio>[
      for (var i = 0; i < _gastos.length; i++)
        CategoriaRelatorio(
          nome: _gastos[i].categoriaNome,
          valorCentavos: _gastos[i].totalCentavos,
          percentual: _gastos[i].percentual,
          cor: AppColors.categoryPalette[i % AppColors.categoryPalette.length],
        ),
    ];

    final pontos = _montarPontos();
    final comparativo = ComparativoPeriodo(
      descricao: '$referencia em relação ao período anterior',
      receitasAnteriorCentavos: _totaisAnteriores.totalReceitas,
      receitasAtualCentavos: totalReceitasCentavos,
      despesasAnteriorCentavos: _totaisAnteriores.totalDespesas,
      despesasAtualCentavos: totalDespesasCentavos,
      saldoAnteriorCentavos: _totaisAnteriores.saldo,
      saldoAtualCentavos: saldoCentavos,
      percentualReceitas: _percentual(
        totalReceitasCentavos,
        _totaisAnteriores.totalReceitas,
      ),
      percentualDespesas: _percentual(
        totalDespesasCentavos,
        _totaisAnteriores.totalDespesas,
      ),
    );

    final movimentacoes = _movimentacoes
        .map(
          (t) => Movimentacao(
            id: t.id ?? 0,
            descricao: t.descricao,
            categoria: t.categoria,
            valorCentavos: t.valorCentavos,
            data: t.data,
            tipo: t.isReceita
                ? TipoMovimentacao.receita
                : TipoMovimentacao.despesa,
          ),
        )
        .toList(growable: false);

    final mesUnico = inicio.year == fim.year && inicio.month == fim.month;

    return ConteudoRelatorio(
      tituloPeriodo: '${_filtro.periodo.rotulo} • $referencia',
      referencia: referencia,
      intervalo:
          '${FormatadorMoeda.formatarDataCurta(inicio)} a ${FormatadorMoeda.formatarDataCurta(fim)}',
      totalReceitasCentavos: totalReceitasCentavos,
      totalDespesasCentavos: totalDespesasCentavos,
      pontos: pontos,
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: mesUnico
          ? 'Totais do mês • $referencia'
          : 'Evolução mensal • $referencia',
      rodapeGrafico: mesUnico
          ? 'Um único mês selecionado, sem projeção de evolução.'
          : 'Valores agrupados por competência mensal.',
      categorias: categorias,
      movimentacoes: movimentacoes,
      totalMovimentacoes: movimentacoes.length,
      movimentacoesResumo: movimentacoes.length > 4 ? 4 : movimentacoes.length,
      comparativo: comparativo,
      resumoComparativo: _resumoComparativo(comparativo),
    );
  }

  List<PontoGrafico> _montarPontos() {
    if (_evolucao.isNotEmpty) {
      return _evolucao
          .map(
            (e) => PontoGrafico(
              rotulo: _rotuloCompetencia(e.competencia),
              receitasCentavos: e.totalReceitas,
              despesasCentavos: e.totalDespesas,
            ),
          )
          .toList(growable: false);
    }

    if (totalReceitasCentavos == 0 && totalDespesasCentavos == 0) {
      return const [];
    }

    return [
      PontoGrafico(
        rotulo: FormatadorMoeda.formatarMesAno(_filtro.dataInicial),
        receitasCentavos: totalReceitasCentavos,
        despesasCentavos: totalDespesasCentavos,
      ),
    ];
  }

  bool _pertenceAoFiltro(Transacao transacao) {
    final data = DateTime(
      transacao.data.year,
      transacao.data.month,
      transacao.data.day,
    );
    final inicio = DateTime(
      _filtro.dataInicial.year,
      _filtro.dataInicial.month,
      _filtro.dataInicial.day,
    );
    final fim = DateTime(
      _filtro.dataFinal.year,
      _filtro.dataFinal.month,
      _filtro.dataFinal.day,
    );

    if (data.isBefore(inicio) || data.isAfter(fim)) return false;

    switch (_filtro.tipo) {
      case TipoFiltroRelatorio.receitas:
        if (!transacao.isReceita) return false;
      case TipoFiltroRelatorio.despesas:
        if (!transacao.isDespesa) return false;
      case TipoFiltroRelatorio.todas:
        break;
    }

    if (_filtro.categoria != 'Todas as categorias' &&
        transacao.categoria != _filtro.categoria) {
      return false;
    }

    return true;
  }

  dominio.FiltroRelatorio _paraDominio(FiltroRelatorio filtro) {
    final tipo = switch (filtro.tipo) {
      TipoFiltroRelatorio.receitas => TipoTransacao.receita,
      TipoFiltroRelatorio.despesas => TipoTransacao.despesa,
      TipoFiltroRelatorio.todas => null,
    };

    return dominio.FiltroRelatorio(
      dataInicial: DateTime(
        filtro.dataInicial.year,
        filtro.dataInicial.month,
        filtro.dataInicial.day,
      ),
      dataFinal: DateTime(
        filtro.dataFinal.year,
        filtro.dataFinal.month,
        filtro.dataFinal.day,
        23,
        59,
        59,
        999,
      ),
      tipo: tipo,
      categoriaId: _categoriaId(filtro.categoria),
    );
  }

  dominio.FiltroRelatorio _filtroPeriodoAnterior(
    dominio.FiltroRelatorio filtro,
  ) {
    final inicio = filtro.dataInicial!;
    final fim = filtro.dataFinal!;
    final dias = fim.difference(inicio).inDays + 1;
    final fimAnterior = inicio.subtract(const Duration(days: 1));
    final inicioAnterior =
        fimAnterior.subtract(Duration(days: dias > 0 ? dias - 1 : 0));

    return dominio.FiltroRelatorio(
      dataInicial: DateTime(
        inicioAnterior.year,
        inicioAnterior.month,
        inicioAnterior.day,
      ),
      dataFinal: DateTime(
        fimAnterior.year,
        fimAnterior.month,
        fimAnterior.day,
        23,
        59,
        59,
        999,
      ),
      tipo: filtro.tipo,
      categoriaId: filtro.categoriaId,
    );
  }

  String? _categoriaId(String nome) {
    if (nome == 'Todas as categorias') return null;
    for (final categoria in _categorias) {
      if (categoria.nome == nome) return categoria.id;
    }
    return null;
  }

  Future<void> _carregarCategorias() async {
    final receitas = await _listarCategoriasPorTipoUseCase(
      TipoTransacao.receita,
    );
    final despesas = await _listarCategoriasPorTipoUseCase(
      TipoTransacao.despesa,
    );
    _categorias = [...receitas, ...despesas];
  }

  static FiltroRelatorio _filtroDoMes(DateTime mes) {
    final inicio = DateTime(mes.year, mes.month);
    final fim = DateTime(mes.year, mes.month + 1, 0);
    return FiltroRelatorio(dataInicial: inicio, dataFinal: fim);
  }

  static String _referencia(DateTime inicio, DateTime fim) {
    final mesUnico = inicio.year == fim.year && inicio.month == fim.month;
    if (mesUnico) {
      return FormatadorMoeda.formatarMesAno(inicio);
    }
    return '${FormatadorMoeda.formatarMesAno(inicio)} a '
        '${FormatadorMoeda.formatarMesAno(fim)}';
  }

  static String _rotuloCompetencia(String competencia) {
    final partes = competencia.split('-');
    if (partes.length != 2) return competencia;
    final ano = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    if (ano == null || mes == null) return competencia;
    return FormatadorMoeda.formatarMesAno(DateTime(ano, mes));
  }

  static String _percentual(int atual, int anterior) {
    if (anterior == 0) {
      return atual == 0 ? '0,00%' : '+100,00%';
    }
    final variacao = ((atual - anterior) / anterior) * 100;
    final sinal = variacao >= 0 ? '+' : '−';
    final valor = variacao.abs().toStringAsFixed(2).replaceAll('.', ',');
    return '$sinal$valor%';
  }

  static String _resumoComparativo(ComparativoPeriodo comparativo) {
    final receitasAtuais = comparativo.receitasAtualCentavos;
    final receitasAnteriores = comparativo.receitasAnteriorCentavos;
    final despesasAtuais = comparativo.despesasAtualCentavos;
    final despesasAnteriores = comparativo.despesasAnteriorCentavos;

    if (receitasAtuais == receitasAnteriores &&
        despesasAtuais == despesasAnteriores) {
      return 'Período estável em relação ao anterior.';
    }
    if (receitasAtuais >= receitasAnteriores &&
        despesasAtuais <= despesasAnteriores) {
      return 'Receitas maiores e despesas menores no período.';
    }
    if (receitasAtuais <= receitasAnteriores &&
        despesasAtuais >= despesasAnteriores) {
      return 'Receitas menores e despesas maiores no período.';
    }
    return 'Houve variação nas receitas e despesas do período.';
  }
}
