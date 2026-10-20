import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/theme/app_theme.dart';
import 'package:meu_bolso/features/autenticacao/domain/entities/perfil_local.dart';
import 'package:meu_bolso/features/autenticacao/domain/exceptions/falhas_autenticacao.dart';
import 'package:meu_bolso/features/autenticacao/domain/repositories/autenticacao_repository.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/login_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/presentation/controllers/autenticacao_controller.dart';
import 'package:meu_bolso/features/autenticacao/presentation/pages/login_page.dart';

class FakeAutenticacaoRepository implements AutenticacaoRepository {
  PerfilLocal? perfilArmazenado;
  String? senhaArmazenada;

  @override
  Future<bool> verificarExistenciaPerfil() async => perfilArmazenado != null;

  @override
  Future<void> cadastrarPerfil(String nome, String email, String senhaClara) async {
    perfilArmazenado = PerfilLocal(nome: nome, email: email);
    senhaArmazenada = senhaClara;
  }

  @override
  Future<PerfilLocal> realizarLogin(String senhaClara) async {
    if (senhaArmazenada != senhaClara) throw const SenhaIncorretaException();
    return perfilArmazenado!;
  }

  @override
  Future<PerfilLocal?> obterPerfil() async => perfilArmazenado;
}

void main() {
  Widget criarAppTeste(AutenticacaoController controller) {
    return MaterialApp(
      theme: AppTheme.claro,
      darkTheme: AppTheme.escuro,
      home: LoginPage(controller: controller),
    );
  }

  group('LoginPage (T01)', () {
    testWidgets('exibe formulario de primeiro acesso quando nao houver perfil', (tester) async {
      final fakeRepo = FakeAutenticacaoRepository();
      final controller = AutenticacaoController(
        verificarPerfilUseCase: VerificarPerfilUseCase(fakeRepo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(fakeRepo),
        loginUseCase: LoginUseCase(fakeRepo),
        obterPerfilUseCase: ObterPerfilUseCase(fakeRepo),
      );

      await tester.pumpWidget(criarAppTeste(controller));
      await tester.pumpAndSettle();

      expect(find.text('Crie seu perfil local'), findsOneWidget);
      expect(find.text('Nome completo'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsOneWidget);
      expect(find.text('Criar Perfil'), findsOneWidget);
    });

    testWidgets('valida campos obrigatorios no cadastro', (tester) async {
      final fakeRepo = FakeAutenticacaoRepository();
      final controller = AutenticacaoController(
        verificarPerfilUseCase: VerificarPerfilUseCase(fakeRepo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(fakeRepo),
        loginUseCase: LoginUseCase(fakeRepo),
        obterPerfilUseCase: ObterPerfilUseCase(fakeRepo),
      );

      await tester.pumpWidget(criarAppTeste(controller));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Criar Perfil'));
      await tester.tap(find.text('Criar Perfil'));
      await tester.pumpAndSettle();

      expect(find.text('Por favor, informe seu nome'), findsOneWidget);
      expect(find.text('Por favor, informe seu e-mail'), findsOneWidget);
      expect(find.text('Por favor, informe a senha'), findsOneWidget);
    });

    testWidgets('exibe modo de login quando perfil ja existir', (tester) async {
      final fakeRepo = FakeAutenticacaoRepository();
      await fakeRepo.cadastrarPerfil('Juliana', 'juliana@email.com', '123456');

      final controller = AutenticacaoController(
        verificarPerfilUseCase: VerificarPerfilUseCase(fakeRepo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(fakeRepo),
        loginUseCase: LoginUseCase(fakeRepo),
        obterPerfilUseCase: ObterPerfilUseCase(fakeRepo),
      );

      await tester.pumpWidget(criarAppTeste(controller));
      await tester.pumpAndSettle();

      expect(find.text('Olá, Juliana!'), findsOneWidget);
      expect(find.text('Nome completo'), findsNothing);
      expect(find.text('E-mail'), findsNothing);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsNothing);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('exibe SnackBar de erro ao digitar senha incorreta', (tester) async {
      final fakeRepo = FakeAutenticacaoRepository();
      await fakeRepo.cadastrarPerfil('Juliana', 'juliana@email.com', '123456');

      final controller = AutenticacaoController(
        verificarPerfilUseCase: VerificarPerfilUseCase(fakeRepo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(fakeRepo),
        loginUseCase: LoginUseCase(fakeRepo),
        obterPerfilUseCase: ObterPerfilUseCase(fakeRepo),
      );

      await tester.pumpWidget(criarAppTeste(controller));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'senhaErrada');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Senha incorreta. Verifique e tente novamente.'), findsOneWidget);
    });
  });
}
