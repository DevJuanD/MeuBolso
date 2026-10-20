import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/financas/domain/models/relatorio.dart';
import 'package:meu_bolso/features/financas/presentation/controllers/financas_controller.dart';

void main() {
  group('FinancasController', () {
    late FinancasController controller;

    setUp(() {
      controller = FinancasController();
    });

    test('inicia com os totais do dashboard', () {
      expect(controller.totalReceitasCentavos, 325000);
      expect(controller.totalDespesasCentavos, 132000);
      expect(controller.saldoCentavos, 193000);
    });

    test('adiciona, edita, exclui e desfaz receita recalculando totais', () {
      controller.adicionarReceita(
        descricao: '',
        categoria: 'Consultoria',
        valorCentavos: 35000,
        data: DateTime(2026, 10, 18),
      );

      expect(controller.totalReceitasCentavos, 360000);
      final receita = controller.receitas
          .firstWhere((m) => m.categoria == 'Consultoria');
      expect(receita.descricao, 'Consultoria');

      controller.editarReceita(
        receita,
        descricao: 'Projeto',
        categoria: 'Consultoria',
        valorCentavos: 50000,
        data: DateTime(2026, 10, 18),
      );

      expect(controller.totalReceitasCentavos, 375000);
      final editada = controller.receitas
          .firstWhere((m) => m.descricao == 'Projeto');
      expect(editada.valorCentavos, 50000);

      controller.excluirReceita(editada);
      expect(controller.totalReceitasCentavos, 325000);
      expect(controller.receitas.any((m) => m.id == editada.id), isFalse);

      controller.desfazerExclusaoReceita();
      expect(controller.totalReceitasCentavos, 375000);
      expect(controller.receitas.any((m) => m.id == editada.id), isTrue);
    });

    test('adiciona, edita, exclui e desfaz despesa recalculando totais', () {
      controller.adicionarDespesa(
        descricao: 'Curso',
        categoria: 'Educação',
        valorCentavos: 12000,
        data: DateTime(2026, 10, 18),
      );

      expect(controller.totalDespesasCentavos, 144000);
      final despesa =
          controller.despesas.firstWhere((m) => m.categoria == 'Educação');

      controller.editarDespesa(
        despesa,
        descricao: 'Curso de Flutter',
        categoria: 'Educação',
        valorCentavos: 20000,
        data: DateTime(2026, 10, 18),
      );

      expect(controller.totalDespesasCentavos, 152000);

      controller.excluirDespesa(
        controller.despesas.firstWhere((m) => m.descricao == 'Curso de Flutter'),
      );
      expect(controller.totalDespesasCentavos, 132000);

      controller.desfazerExclusaoDespesa();
      expect(controller.totalDespesasCentavos, 152000);
    });

    test('cria categorias sem duplicar nomes existentes', () {
      final totalReceita = controller.categoriasReceita.length;
      controller.adicionarCategoriaReceita('Salário');
      expect(controller.categoriasReceita.length, totalReceita);

      controller.adicionarCategoriaReceita('Aluguel de equipamento');
      expect(
        controller.categoriasReceita.last.nome,
        'Aluguel de equipamento',
      );

      final totalDespesa = controller.categoriasDespesa.length;
      controller.adicionarCategoriaDespesa('Alimentação');
      expect(controller.categoriasDespesa.length, totalDespesa);

      controller.adicionarCategoriaDespesa('Pets');
      expect(controller.categoriasDespesa.last.nome, 'Pets');
    });

    test('aplica e limpa filtros do relatório', () {
      final filtro = FiltroRelatorio(
        periodo: PeriodoRelatorio.ultimos3Meses,
        dataInicial: DateTime(2025, 8, 1),
        dataFinal: DateTime(2025, 10, 31),
        tipo: TipoFiltroRelatorio.despesas,
        categoria: 'Moradia',
      );

      controller.aplicarFiltro(filtro);

      expect(controller.filtro.periodo, PeriodoRelatorio.ultimos3Meses);
      expect(controller.filtro.tipo, TipoFiltroRelatorio.despesas);
      expect(controller.filtro.categoria, 'Moradia');
      expect(controller.relatorio.pontos, hasLength(3));

      controller.limparFiltros();

      expect(controller.filtro.periodo, PeriodoRelatorio.esteMes);
      expect(controller.filtro.tipo, TipoFiltroRelatorio.todas);
      expect(controller.filtro.categoria, 'Todas as categorias');
      expect(controller.filtro.dataInicial, DateTime(2025, 10, 1));
      expect(controller.filtro.dataFinal, DateTime(2025, 10, 31));
    });
  });
}
