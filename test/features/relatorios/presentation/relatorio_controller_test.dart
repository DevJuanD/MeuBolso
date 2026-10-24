import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/financas/domain/models/relatorio.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/evolucao_mensal.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/filtro_relatorio.dart'
    as dominio;
import 'package:meu_bolso/features/relatorios/domain/entities/gasto_por_categoria.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/totais_periodo.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';

import '../../../helpers/fakes_financeiros.dart';

const _alimentacao = Categoria(
  id: 'padrao_desp_1',
  nome: 'Alimentação',
  tipo: TipoTransacao.despesa,
);

const _lazer = Categoria(
  id: 'padrao_desp_2',
  nome: 'Lazer',
  tipo: TipoTransacao.despesa,
);

const _salario = Categoria(
  id: 'padrao_rec_1',
  nome: 'Salário',
  tipo: TipoTransacao.receita,
);

Transacao _movimentacao({
  required int id,
  required DateTime data,
  TipoTransacao tipo = TipoTransacao.despesa,
  required String categoria,
}) {
  final competencia =
      '${data.year}-${data.month.toString().padLeft(2, '0')}';
  return Transacao(
    id: id,
    descricao: 'Movimentação $id',
    valorCentavos: 10000,
    tipo: tipo,
    categoria: categoria,
    categoriaId: tipo.isReceita ? _salario.id : _alimentacao.id,
    data: data,
    competencia: competencia,
    criadoEm: data,
  );
}

class _RelatorioComFalha extends FakeRelatorioRepository {
  @override
  Future<TotaisPeriodo> obterTotais(dominio.FiltroRelatorio filtro) async {
    throw Exception('falha simulada');
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('RelatorioController', () {
    late FakeTransacoesRepository transacoesRepositorio;
    late FakeCategoriaRepository categoriasRepositorio;

    setUp(() {
      transacoesRepositorio = FakeTransacoesRepository();
      categoriasRepositorio = FakeCategoriaRepository()
        ..dados.addAll([_alimentacao, _lazer, _salario]);
    });

    test('carregarMes define o período mensal e consulta o mês anterior',
        () async {
      final relatorios = FakeRelatorioRepository();
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );

      await controller.carregarMes(DateTime(2026, 10, 15));

      expect(controller.filtro.dataInicial, DateTime(2026, 10, 1));
      expect(controller.filtro.dataFinal, DateTime(2026, 10, 31));
      expect(controller.carregando, isFalse);
      expect(controller.mensagemErro, isNull);

      expect(relatorios.filtrosTotais, hasLength(2));
      final atual = relatorios.filtrosTotais.first;
      expect(atual.dataInicial, DateTime(2026, 10, 1));
      expect(atual.dataFinal, DateTime(2026, 10, 31, 23, 59, 59, 999));
      expect(atual.tipo, isNull);
      expect(atual.categoriaId, isNull);

      final anterior = relatorios.filtrosTotais.last;
      expect(
        anterior.dataFinal,
        DateTime(2026, 9, 30, 23, 59, 59, 999),
      );
    });

    test('aplicarFiltros converte tipo e categoria para o domínio', () async {
      transacoesRepositorio.dados.addAll([
        _movimentacao(
          id: 1,
          data: DateTime(2026, 10, 5),
          categoria: 'Alimentação',
        ),
        _movimentacao(
          id: 2,
          data: DateTime(2026, 10, 6),
          tipo: TipoTransacao.receita,
          categoria: 'Salário',
        ),
        _movimentacao(
          id: 3,
          data: DateTime(2026, 10, 7),
          categoria: 'Lazer',
        ),
        _movimentacao(
          id: 4,
          data: DateTime(2026, 9, 30),
          categoria: 'Alimentação',
        ),
      ]);
      final relatorios = FakeRelatorioRepository();
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );

      await controller.aplicarFiltros(
        FiltroRelatorio(
          periodo: PeriodoRelatorio.personalizado,
          dataInicial: DateTime(2026, 10, 1),
          dataFinal: DateTime(2026, 10, 31),
          tipo: TipoFiltroRelatorio.despesas,
          categoria: 'Alimentação',
        ),
      );

      final filtroConsulta = relatorios.filtrosTotais.first;
      expect(filtroConsulta.tipo, TipoTransacao.despesa);
      expect(filtroConsulta.categoriaId, _alimentacao.id);
      expect(
        filtroConsulta.dataFinal,
        DateTime(2026, 10, 31, 23, 59, 59, 999),
      );

      expect(controller.movimentacoes, hasLength(1));
      expect(controller.movimentacoes.single.id, 1);
    });

    test('carrega totais, gastos, evolução e comparativo do período',
        () async {
      final relatorios = FakeRelatorioRepository(
        respostasTotais: const [
          TotaisPeriodo(
            totalReceitas: 100000,
            totalDespesas: 40000,
            saldo: 60000,
          ),
          TotaisPeriodo(
            totalReceitas: 80000,
            totalDespesas: 50000,
            saldo: 30000,
          ),
        ],
      )
        ..gastos = const [
          GastoPorCategoria(
            categoriaNome: 'Alimentação',
            totalCentavos: 40000,
            percentual: 100,
          ),
        ]
        ..evolucao = const [
          EvolucaoMensal(
            competencia: '2026-10',
            totalReceitas: 100000,
            totalDespesas: 40000,
          ),
        ];
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );

      await controller.carregarMes(DateTime(2026, 10));

      expect(controller.totais?.saldo, 60000);
      expect(controller.totalReceitasCentavos, 100000);
      expect(controller.totalDespesasCentavos, 40000);
      expect(controller.saldoCentavos, 60000);
      expect(controller.gastos, hasLength(1));
      expect(controller.evolucao.single.competencia, '2026-10');

      final conteudo = controller.conteudoRelatorio;
      expect(conteudo.totalReceitasCentavos, 100000);
      expect(conteudo.totalDespesasCentavos, 40000);
      expect(conteudo.saldoCentavos, 60000);
      expect(conteudo.categorias, hasLength(1));
      expect(conteudo.categorias.single.nome, 'Alimentação');
      expect(conteudo.categorias.single.valorCentavos, 40000);
      expect(conteudo.categorias.single.percentual, 100);
      expect(conteudo.maiorCategoria?.nome, 'Alimentação');
      expect(conteudo.pontos, hasLength(1));
      expect(conteudo.pontos.single.rotulo, 'Outubro 2026');
      expect(conteudo.comparativo.percentualReceitas, '+25,00%');
      expect(conteudo.comparativo.percentualDespesas, '−20,00%');
      expect(
        conteudo.resumoComparativo,
        'Receitas maiores e despesas menores no período.',
      );
    });

    test('percentual é +100% quando o período anterior não tem valor',
        () async {
      final relatorios = FakeRelatorioRepository(
        respostasTotais: const [
          TotaisPeriodo(
            totalReceitas: 50000,
            totalDespesas: 0,
            saldo: 50000,
          ),
          TotaisPeriodo(
            totalReceitas: 0,
            totalDespesas: 0,
            saldo: 0,
          ),
        ],
      );
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );

      await controller.carregarMes(DateTime(2026, 10));

      final comparativo = controller.conteudoRelatorio.comparativo;
      expect(comparativo.percentualReceitas, '+100,00%');
      expect(comparativo.percentualDespesas, '0,00%');
    });

    test('categoriasDisponiveis reflete as categorias persistidas', () async {
      final relatorios = FakeRelatorioRepository();
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );
      expect(controller.categoriasDisponiveis, ['Todas as categorias']);

      await controller.carregarMes(DateTime(2026, 10));

      expect(controller.categoriasDisponiveis, [
        'Todas as categorias',
        'Alimentação',
        'Lazer',
        'Salário',
      ]);
    });

    test('limparFiltros restaura o mês atual e os filtros padrão', () async {
      final relatorios = FakeRelatorioRepository();
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );
      await controller.aplicarFiltros(
        FiltroRelatorio(
          periodo: PeriodoRelatorio.ultimos3Meses,
          dataInicial: DateTime(2026, 1, 1),
          dataFinal: DateTime(2026, 3, 31),
          tipo: TipoFiltroRelatorio.receitas,
          categoria: 'Salário',
        ),
      );

      await controller.limparFiltros();

      final agora = DateTime.now();
      expect(controller.filtro.periodo, PeriodoRelatorio.esteMes);
      expect(
        controller.filtro.dataInicial,
        DateTime(agora.year, agora.month),
      );
      expect(
        controller.filtro.dataFinal,
        DateTime(agora.year, agora.month + 1, 0),
      );
      expect(controller.filtro.tipo, TipoFiltroRelatorio.todas);
      expect(controller.filtro.categoria, 'Todas as categorias');
    });

    test('falha ao consultar expõe mensagem de erro sem quebrar o estado',
        () async {
      final relatorios = _RelatorioComFalha();
      final controller = criarRelatorioController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        relatorioRepositorio: relatorios,
      );

      await controller.carregarMes(DateTime(2026, 10));

      expect(controller.carregando, isFalse);
      expect(
        controller.mensagemErro,
        'Não foi possível carregar o relatório.',
      );
      expect(controller.totais, isNull);
    });
  });
}
