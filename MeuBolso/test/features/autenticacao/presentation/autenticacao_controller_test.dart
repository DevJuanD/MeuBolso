import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/autenticacao/domain/entities/perfil_local.dart';
import 'package:meu_bolso/features/autenticacao/domain/exceptions/falhas_autenticacao.dart';
import 'package:meu_bolso/features/autenticacao/domain/repositories/autenticacao_repository.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/login_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/presentation/controllers/autenticacao_controller.dart';

class FakeAutenticacaoRepository implements AutenticacaoRepository {
  PerfilLocal? perfilArmazenado;
  String? senhaArmazenada;

  @override
  Future<bool> verificarExistenciaPerfil() async => perfilArmazenado != null;

  @override
  Future<void> cadastrarPerfil(String nome, String email, String senhaClara) async {
    if (perfilArmazenado != null) throw const PerfilJaCadastradoException();
    perfilArmazenado = PerfilLocal(nome: nome, email: email);
    senhaArmazenada = senhaClara;
  }

  @override
  Future<PerfilLocal> realizarLogin(String senhaClara) async {
    if (perfilArmazenado == null) throw const PerfilNaoEncontradoException();
    if (senhaArmazenada != senhaClara) throw const SenhaIncorretaException();
    return perfilArmazenado!;
  }

  @override
  Future<PerfilLocal?> obterPerfil() async => perfilArmazenado;
}

void main() {
  group('AutenticacaoController', () {
    late FakeAutenticacaoRepository fakeRepo;
    late AutenticacaoController controller;

    setUp(() {
      fakeRepo = FakeAutenticacaoRepository();
      controller = AutenticacaoController(
        verificarPerfilUseCase: VerificarPerfilUseCase(fakeRepo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(fakeRepo),
        loginUseCase: LoginUseCase(fakeRepo),
        obterPerfilUseCase: ObterPerfilUseCase(fakeRepo),
      );
    });

    test('inicializar define modo cadastro quando nenhum perfil existe', () async {
      await controller.inicializar();

      expect(controller.modo, ModoAutenticacao.cadastro);
      expect(controller.perfilAtual, isNull);
    });

    test('inicializar define modo login quando perfil ja existe', () async {
      await fakeRepo.cadastrarPerfil('Carlos', 'carlos@email.com', '123456');

      await controller.inicializar();

      expect(controller.modo, ModoAutenticacao.login);
      expect(controller.perfilAtual?.nome, 'Carlos');
    });

    test('cadastrar cria perfil e atualiza perfilAtual', () async {
      await controller.inicializar();

      final resultado = await controller.cadastrar(
        nome: 'Carlos',
        email: 'carlos@email.com',
        senha: 'senhaSecreta',
      );

      expect(resultado, isNotNull);
      expect(resultado!.nome, 'Carlos');
      expect(controller.perfilAtual?.nome, 'Carlos');
      expect(controller.modo, ModoAutenticacao.login);
    });

    test('entrar com senha correta retorna perfil', () async {
      await fakeRepo.cadastrarPerfil('Carlos', 'carlos@email.com', '123456');
      await controller.inicializar();

      final perfil = await controller.entrar(senha: '123456');

      expect(perfil, isNotNull);
      expect(perfil!.nome, 'Carlos');
      expect(controller.mensagemErro, isNull);
    });

    test('entrar com senha incorreta define mensagemErro amigável', () async {
      await fakeRepo.cadastrarPerfil('Carlos', 'carlos@email.com', '123456');
      await controller.inicializar();

      final perfil = await controller.entrar(senha: 'senhaErrada');

      expect(perfil, isNull);
      expect(controller.mensagemErro, 'Senha incorreta. Verifique e tente novamente.');
    });
  });
}
