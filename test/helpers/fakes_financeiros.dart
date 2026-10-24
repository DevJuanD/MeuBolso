import 'package:flutter/widgets.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/evolucao_mensal.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/filtro_relatorio.dart'
    as dominio;
import 'package:meu_bolso/features/relatorios/domain/entities/gasto_por_categoria.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/totais_periodo.dart';
import 'package:meu_bolso/features/relatorios/domain/repositories/relatorio_repository.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_evolucao_mensal_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_gastos_por_categoria_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_totais_usecase.dart';
import 'package:meu_bolso/features/relatorios/presentation/controllers/relatorio_controller.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/repositories/transacoes_repository.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/excluir_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/listar_transacoes_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/restaurar_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/salvar_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/presentation/controllers/transacoes_controller.dart';

/// Repositório em memória para testes de apresentação.
class FakeTransacoesRepository implements TransacoesRepository {
  final List<Transacao> dados = [];
  int _proximoId = 1;

  @override
  Future<void> excluirTransacao(int id) async {
    final indice = dados.indexWhere((t) => t.id == id);
    if (indice != -1) {
      dados[indice] = dados[indice].copyWith(excluidaEm: DateTime.now());
    }
  }

  @override
  Future<List<Transacao>> listarTransacoes({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) async {
    final lista = dados.where((t) {
      if (!incluirExcluidas && t.isExcluida) return false;
      if (tipo != null && t.tipo != tipo) return false;
      if (competencia != null && t.competencia != competencia) return false;
      return true;
    }).toList();

    lista.sort((a, b) {
      final porData = b.data.compareTo(a.data);
      if (porData != 0) return porData;
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return lista;
  }

  @override
  Future<Transacao?> obterTransacaoPorId(int id) async {
    for (final transacao in dados) {
      if (transacao.id == id) return transacao;
    }
    return null;
  }

  @override
  Future<void> restaurarTransacao(int id) async {
    final indice = dados.indexWhere((t) => t.id == id);
    if (indice != -1) {
      dados[indice] = dados[indice].copyWith(excluidaEm: null);
    }
  }

  @override
  Future<Transacao> salvarTransacao(Transacao transacao) async {
    if (transacao.id == null) {
      final salva = transacao.copyWith(id: _proximoId++);
      dados.add(salva);
      return salva;
    }
    final indice = dados.indexWhere((t) => t.id == transacao.id);
    if (indice != -1) dados[indice] = transacao;
    return transacao;
  }
}

/// Repositório de categorias em memória para testes.
class FakeCategoriaRepository implements CategoriaRepository {
  final List<Categoria> dados = [];

  @override
  Future<Categoria?> buscarPorNomeETipo(
    String nome,
    TipoTransacao tipo,
  ) async {
    for (final categoria in dados) {
      if (categoria.nome == nome && categoria.tipo == tipo) return categoria;
    }
    return null;
  }

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    return dados.where((c) => c.tipo == tipo).toList();
  }

  @override
  Future<Categoria?> obterPorId(String id) async {
    for (final categoria in dados) {
      if (categoria.id == id) return categoria;
    }
    return null;
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    dados.add(categoria);
    return categoria;
  }
}

TransacoesController criarTransacoesController({
  FakeTransacoesRepository? transacoesRepositorio,
  FakeCategoriaRepository? categoriasRepositorio,
  GlobalKey<NavigatorState>? navigatorKey,
  Future<void> Function()? aoAlterarDados,
}) {
  final transacoes = transacoesRepositorio ?? FakeTransacoesRepository();
  final categorias = categoriasRepositorio ?? FakeCategoriaRepository();

  return TransacoesController(
    salvarTransacaoUseCase: SalvarTransacaoUseCase(transacoes),
    listarTransacoesUseCase: ListarTransacoesUseCase(transacoes),
    excluirTransacaoUseCase: ExcluirTransacaoUseCase(transacoes),
    restaurarTransacaoUseCase: RestaurarTransacaoUseCase(transacoes),
    criarCategoriaUseCase: CriarCategoriaUseCase(categorias),
    listarCategoriasPorTipoUseCase: ListarCategoriasPorTipoUseCase(
      categorias,
    ),
    navigatorKey: navigatorKey,
    aoAlterarDados: aoAlterarDados,
  );
}

/// Repositório de relatórios em memória que registra os filtros consultados.
///
/// Cada chamada a [obterTotais] consome a próxima resposta de
/// [respostasTotais] (a primeira é o período atual e a segunda, o anterior).
class FakeRelatorioRepository implements RelatorioRepository {
  FakeRelatorioRepository({List<TotaisPeriodo>? respostasTotais})
      : respostasTotais = respostasTotais ?? const [];

  final List<dominio.FiltroRelatorio> filtrosTotais = [];
  List<TotaisPeriodo> respostasTotais;
  List<GastoPorCategoria> gastos = const [];
  List<EvolucaoMensal> evolucao = const [];

  int _indiceTotais = 0;

  /// Reinicia o consumo das respostas para um novo carregamento.
  void reiniciarTotais() {
    _indiceTotais = 0;
  }

  @override
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    dominio.FiltroRelatorio filtro,
  ) async {
    return evolucao;
  }

  @override
  Future<List<GastoPorCategoria>> obterGastosPorCategoria(
    dominio.FiltroRelatorio filtro,
  ) async {
    return gastos;
  }

  @override
  Future<TotaisPeriodo> obterTotais(dominio.FiltroRelatorio filtro) async {
    filtrosTotais.add(filtro);
    if (respostasTotais.isEmpty) {
      return const TotaisPeriodo(
        totalReceitas: 0,
        totalDespesas: 0,
        saldo: 0,
      );
    }
    final indice = _indiceTotais < respostasTotais.length
        ? _indiceTotais
        : respostasTotais.length - 1;
    _indiceTotais++;
    return respostasTotais[indice];
  }
}

RelatorioController criarRelatorioController({
  FakeTransacoesRepository? transacoesRepositorio,
  FakeCategoriaRepository? categoriasRepositorio,
  FakeRelatorioRepository? relatorioRepositorio,
}) {
  final transacoes = transacoesRepositorio ?? FakeTransacoesRepository();
  final categorias = categoriasRepositorio ?? FakeCategoriaRepository();
  final relatorios = relatorioRepositorio ?? FakeRelatorioRepository();

  return RelatorioController(
    obterTotaisUseCase: ObterTotaisUseCase(relatorios),
    obterGastosPorCategoriaUseCase: ObterGastosPorCategoriaUseCase(relatorios),
    obterEvolucaoMensalUseCase: ObterEvolucaoMensalUseCase(relatorios),
    listarTransacoesUseCase: ListarTransacoesUseCase(transacoes),
    listarCategoriasPorTipoUseCase: ListarCategoriasPorTipoUseCase(categorias),
  );
}
