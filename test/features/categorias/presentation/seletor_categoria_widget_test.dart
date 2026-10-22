import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/theme/app_colors.dart';
import 'package:meu_bolso/core/theme/app_theme.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'package:meu_bolso/features/categorias/presentation/widgets/seletor_categoria_widget.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';

class _FakeCategoriaRepository implements CategoriaRepository {
  final List<Categoria> itens = [];

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    return itens.where((c) => c.tipo == tipo).toList();
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    itens.add(categoria);
    return categoria;
  }

  @override
  Future<Categoria?> obterPorId(String id) async => null;

  @override
  Future<Categoria?> buscarPorNomeETipo(String nome, TipoTransacao tipo) async => null;
}

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
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
  );
}

void main() {
  group('SeletorCategoriaWidget Tests', () {
    late _FakeCategoriaRepository repositorio;
    late CriarCategoriaUseCase criarUseCase;

    setUp(() {
      repositorio = _FakeCategoriaRepository();
      criarUseCase = CriarCategoriaUseCase(repositorio);
    });

    testWidgets('exibe categorias iniciais e seleciona opcao ao tocar', (tester) async {
      Categoria? selecionada;
      final iniciais = [
        const Categoria(
          id: '1',
          nome: 'Alimentação',
          tipo: TipoTransacao.despesa,
          isPadrao: true,
        ),
        const Categoria(
          id: '2',
          nome: 'Transporte',
          tipo: TipoTransacao.despesa,
          isPadrao: true,
        ),
      ];

      await tester.pumpWidget(
        _criarWidgetTeste(
          SeletorCategoriaWidget(
            tipo: TipoTransacao.despesa,
            categoriasIniciais: iniciais,
            aoSelecionar: (c) => selecionada = c,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Selecione o tipo de despesa'), findsOneWidget);

      await tester.tap(find.text('Selecione o tipo de despesa'));
      await tester.pumpAndSettle();

      expect(find.text('Alimentação'), findsOneWidget);
      expect(find.text('Transporte'), findsOneWidget);
      expect(find.text('+ Criar novo tipo'), findsOneWidget);

      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();

      expect(selecionada, isNotNull);
      expect(selecionada!.nome, 'Alimentação');
      expect(find.text('Alimentação'), findsOneWidget);
    });

    testWidgets('abre modal ao clicar em Criar novo tipo e exibe chips de confirmacao', (tester) async {
      Categoria? selecionada;
      final iniciais = [
        const Categoria(
          id: '1',
          nome: 'Salário',
          tipo: TipoTransacao.receita,
          isPadrao: true,
        ),
      ];

      await tester.pumpWidget(
        _criarWidgetTeste(
          SeletorCategoriaWidget(
            tipo: TipoTransacao.receita,
            categoriasIniciais: iniciais,
            criarUseCase: criarUseCase,
            aoSelecionar: (c) => selecionada = c,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Selecione o tipo de receita'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Criar novo tipo'));
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de receita'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'dividendos');
      await tester.tap(find.text('Salvar tipo'));
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de receita'), findsNothing);
      expect(selecionada, isNotNull);
      expect(selecionada!.nome, 'Dividendos');

      expect(find.text('Tipo criado! Agora disponível na sua lista:'), findsOneWidget);
      expect(find.text('Dividendos'), findsWidgets);
    });
  });
}
