import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/autenticacao/domain/entities/perfil_local.dart';
import 'package:meu_bolso/features/autenticacao/domain/repositories/autenticacao_repository.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/login_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'package:meu_bolso/main.dart';

class FakeAutenticacaoRepository implements AutenticacaoRepository {
  PerfilLocal? perfilArmazenado;

  @override
  Future<bool> verificarExistenciaPerfil() async => perfilArmazenado != null;

  @override
  Future<void> cadastrarPerfil(String nome, String email, String senhaClara) async {
    perfilArmazenado = PerfilLocal(nome: nome, email: email);
  }

  @override
  Future<PerfilLocal> realizarLogin(String senhaClara) async => perfilArmazenado!;

  @override
  Future<PerfilLocal?> obterPerfil() async => perfilArmazenado;
}

void main() {
  testWidgets('MeuBolsoApp carrega tela inicial com sucesso', (tester) async {
    final repo = FakeAutenticacaoRepository();

    await tester.pumpWidget(
      MeuBolsoApp(
        verificarPerfilUseCase: VerificarPerfilUseCase(repo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(repo),
        loginUseCase: LoginUseCase(repo),
        obterPerfilUseCase: ObterPerfilUseCase(repo),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MeuBolso'), findsOneWidget);
    expect(find.text('Crie seu perfil local'), findsOneWidget);
  });
}
