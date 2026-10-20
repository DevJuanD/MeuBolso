import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/theme/app_colors.dart';
import 'package:meu_bolso/core/theme/app_theme.dart';
import 'package:meu_bolso/features/financas/domain/models/movimentacao.dart';
import 'package:meu_bolso/features/financas/presentation/controllers/financas_controller.dart';
import 'package:meu_bolso/features/financas/presentation/pages/despesa_form_page.dart';
import 'package:meu_bolso/features/financas/presentation/pages/despesas_page.dart';

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
    late FinancasController controller;

    setUp(() {
      controller = FinancasController();
    });

    testWidgets('DespesasPage exibe cabeçalho, total do mês e itens registrados', (tester) async {
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
    });

    testWidgets('DespesasPage abre diálogo de confirmação ao clicar em excluir', (tester) async {
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

    testWidgets('DespesaFormPage valida valor obrigatório e categoria', (tester) async {
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

    testWidgets('DespesaFormPage exibe títulos de edição para despesa existente', (tester) async {
      final despesaExistente = Movimentacao(
        id: 101,
        descricao: 'Supermercado Mensal',
        categoria: 'Alimentação',
        valorCentavos: 45000,
        data: DateTime(2026, 10, 15),
        tipo: TipoMovimentacao.despesa,
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
