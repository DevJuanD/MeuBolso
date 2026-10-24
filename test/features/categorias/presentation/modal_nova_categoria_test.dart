import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/theme/app_colors.dart';
import 'package:meu_bolso/core/theme/app_theme.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'package:meu_bolso/features/categorias/presentation/widgets/modal_nova_categoria.dart';
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
    home: Scaffold(body: child),
  );
}

void main() {
  group('ModalNovaCategoria Widget Tests', () {
    late _FakeCategoriaRepository repositorio;
    late CriarCategoriaUseCase useCase;

    setUp(() {
      repositorio = _FakeCategoriaRepository();
      useCase = CriarCategoriaUseCase(repositorio);
    });

    testWidgets('exibe títulos e textos corretos para receita', (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          ModalNovaCategoria(
            tipo: TipoTransacao.receita,
            criarCategoriaUseCase: useCase,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de receita'), findsOneWidget);
      expect(find.text('Dê um nome para identificar suas entradas.'), findsOneWidget);
      expect(find.text('Nome da categoria'), findsWidgets);
      expect(find.text('Salvar tipo'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('exibe títulos e textos corretos para despesa', (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          ModalNovaCategoria(
            tipo: TipoTransacao.despesa,
            criarCategoriaUseCase: useCase,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de despesa'), findsOneWidget);
      expect(find.text('Dê um nome para identificar seus gastos.'), findsOneWidget);
    });

    testWidgets('valida campo vazio e exibe mensagem de erro', (tester) async {
      await tester.pumpWidget(
        _criarWidgetTeste(
          ModalNovaCategoria(
            tipo: TipoTransacao.despesa,
            criarCategoriaUseCase: useCase,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar tipo'));
      await tester.pumpAndSettle();

      expect(find.text('O nome da categoria não pode ser vazio.'), findsOneWidget);
    });

    testWidgets('salva categoria e fecha o modal retornando a entidade', (tester) async {
      Categoria? categoriaCriada;

      await tester.pumpWidget(
        _criarWidgetTeste(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  categoriaCriada = await mostrarModalNovaCategoria(
                    context,
                    tipo: TipoTransacao.receita,
                    criarCategoriaUseCase: useCase,
                  );
                },
                child: const Text('Abrir'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de receita'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'consultoria');
      await tester.tap(find.text('Salvar tipo'));
      await tester.pumpAndSettle();

      expect(find.text('Novo tipo de receita'), findsNothing);
      expect(categoriaCriada, isNotNull);
      expect(categoriaCriada!.nome, 'Consultoria');
      expect(categoriaCriada!.tipo, TipoTransacao.receita);
    });

    testWidgets('exibe mensagem amigável quando categoria duplicada for informada', (tester) async {
      await useCase(nome: 'Freelance', tipo: TipoTransacao.receita);

      await tester.pumpWidget(
        _criarWidgetTeste(
          ModalNovaCategoria(
            tipo: TipoTransacao.receita,
            criarCategoriaUseCase: useCase,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'freelance');
      await tester.tap(find.text('Salvar tipo'));
      await tester.pumpAndSettle();

      expect(
        find.text('Já existe uma categoria cadastrada com este nome e tipo.'),
        findsOneWidget,
      );
    });
  });
}
