import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/theme/app_colors.dart';
import 'package:meu_bolso/core/theme/app_theme.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/financas/presentation/pages/despesa_form_page.dart';
import 'package:meu_bolso/features/financas/presentation/pages/despesas_page.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';
import 'package:meu_bolso/features/transacoes/presentation/controllers/transacoes_controller.dart';

import '../../../helpers/fakes_financeiros.dart';

Widget _criarWidgetTeste(Widget child) {
  AppColors.aplicar(Brightness.light);
  return MaterialApp(
    theme: AppTheme.claro,
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: child,
  );
}

void main() {
  group('Fluxo Visual de Gerenciamento de Despesas (T03 e T04)', () {
    late FakeTransacoesRepository repositorio;
    late TransacoesController controller;
    late DateTime mesAtual;

    setUp(() {
      repositorio = FakeTransacoesRepository();
      controller = criarTransacoesController(
        transacoesRepositorio: repositorio,
      );

      mesAtual = DateTime.now();
      repositorio.dados.add(
        Transacao(
          id: 1,
          descricao: 'Supermercado',
          valorCentavos: 45000,
          tipo: TipoTransacao.despesa,
          categoria: 'Alimentação',
          categoriaId: 'padrao_desp_1',
          data: DateTime(mesAtual.year, mesAtual.month, 10),
          competencia:
              '${mesAtual.year}-${mesAtual.month.toString().padLeft(2, '0')}',
          criadoEm: DateTime.now(),
        ),
      );
    });

    testWidgets('DespesasPage exibe cabeçalho, total do mês e itens registrados',
        (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          DespesasPage(
            controller: controller,
            onAbaSelecionada: (_) {},
            onAbrirMovimentacoes: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Minhas despesas'), findsOneWidget);
      expect(find.text('Veja para onde seu dinheiro vai'), findsOneWidget);
      expect(find.text('Total gasto no mês'), findsOneWidget);
      expect(find.text('Despesas registradas'), findsOneWidget);
      expect(find.text('+ Adicionar despesa'), findsOneWidget);
      expect(find.text('Ver todas as despesas'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
    });

    testWidgets('DespesasPage abre diálogo de confirmação ao clicar em excluir',
        (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          DespesasPage(
            controller: controller,
            onAbaSelecionada: (_) {},
            onAbrirMovimentacoes: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconeMenu = find.byIcon(Icons.more_vert_rounded).first;
      await tester.tap(iconeMenu);
      await tester.pumpAndSettle();

      expect(find.text('Excluir despesa'), findsOneWidget);
      await tester.tap(find.text('Excluir despesa'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir despesa?'), findsOneWidget);
      expect(find.text('CANCELAR'), findsOneWidget);
      expect(find.text('EXCLUIR'), findsOneWidget);

      await tester.tap(find.text('CANCELAR'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir despesa?'), findsNothing);
    });

    testWidgets('DespesaFormPage valida valor obrigatório e categoria',
        (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          DespesaFormPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Adicionar despesa'), findsOneWidget);
      expect(find.text('Registre um gasto'), findsOneWidget);
      expect(find.text('Salvar despesa'), findsOneWidget);

      // Tenta salvar com valor 0,00
      await tester.tap(find.text('Salvar despesa'));
      await tester.pump();

      expect(find.text('Informe o valor da despesa.'), findsOneWidget);
    });

    testWidgets('DespesaFormPage exibe títulos de edição para despesa existente',
        (tester) async {
      final despesaExistente = Transacao(
        id: 101,
        descricao: 'Supermercado Mensal',
        categoria: 'Alimentação',
        valorCentavos: 45000,
        tipo: TipoTransacao.despesa,
        data: DateTime(2026, 10, 15),
        competencia: '2026-10',
        criadoEm: DateTime(2026, 10, 15),
      );

      await tester.pumpWidget(
        _criarWidgetTeste(
          DespesaFormPage(
            controller: controller,
            despesa: despesaExistente,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Editar despesa'), findsOneWidget);
      expect(find.text('Atualize os dados da despesa'), findsOneWidget);
      expect(find.text('SALVAR ALTERAÇÕES'), findsOneWidget);
    });
  });
}
