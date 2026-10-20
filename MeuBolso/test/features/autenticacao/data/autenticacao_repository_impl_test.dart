import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/autenticacao/data/datasources/autenticacao_local_datasource.dart';
import 'package:meu_bolso/features/autenticacao/data/models/perfil_local_model.dart';
import 'package:meu_bolso/features/autenticacao/data/repositories/autenticacao_repository_impl.dart';
import 'package:meu_bolso/features/autenticacao/domain/exceptions/falhas_autenticacao.dart';

class FakeAutenticacaoLocalDataSource implements AutenticacaoLocalDataSource {
  PerfilLocalModel? perfilArmazenado;

  @override
  Future<void> salvarPerfil(PerfilLocalModel perfil) async {
    perfilArmazenado = perfil;
  }

  @override
  Future<PerfilLocalModel?> obterPerfil() async {
    return perfilArmazenado;
  }

  @override
  Future<void> deletarPerfil() async {
    perfilArmazenado = null;
  }
}

void main() {
  group('AutenticacaoRepositoryImpl', () {
    late FakeAutenticacaoLocalDataSource fakeDataSource;
    late AutenticacaoRepositoryImpl repositorio;

    setUp(() {
      fakeDataSource = FakeAutenticacaoLocalDataSource();
      repositorio = AutenticacaoRepositoryImpl(fakeDataSource);
    });

    test('verificarExistenciaPerfil retorna false quando vazio e true quando cadastrado', () async {
      expect(await repositorio.verificarExistenciaPerfil(), isFalse);

      await repositorio.cadastrarPerfil('Maria Silva', 'maria@exemplo.com', 'senha123');

      expect(await repositorio.verificarExistenciaPerfil(), isTrue);
    });

    test('cadastrarPerfil salva nome, email, salt e hash sem texto limpo da senha', () async {
      await repositorio.cadastrarPerfil('Maria Silva', 'maria@exemplo.com', 'senha123');

      final perfilSalvo = fakeDataSource.perfilArmazenado;
      expect(perfilSalvo, isNotNull);
      expect(perfilSalvo!.nome, 'Maria Silva');
      expect(perfilSalvo.email, 'maria@exemplo.com');
      expect(perfilSalvo.salt.isNotEmpty, isTrue);
      expect(perfilSalvo.verificadorSenha.isNotEmpty, isTrue);
      expect(perfilSalvo.verificadorSenha, isNot('senha123'));
    });

    test('cadastrarPerfil lanca PerfilJaCadastradoException se perfil ja existir', () async {
      await repositorio.cadastrarPerfil('Maria', 'maria@email.com', '123456');

      expect(
        () => repositorio.cadastrarPerfil('Outro', 'outro@email.com', '654321'),
        throwsA(isA<PerfilJaCadastradoException>()),
      );
    });

    test('realizarLogin autentica com sucesso quando senha informada for correta', () async {
      await repositorio.cadastrarPerfil('Maria Silva', 'maria@exemplo.com', 'senhaCorreta');

      final resultado = await repositorio.realizarLogin('senhaCorreta');

      expect(resultado.nome, 'Maria Silva');
      expect(resultado.email, 'maria@exemplo.com');
    });

    test('realizarLogin lanca SenhaIncorretaException quando a senha for errada', () async {
      await repositorio.cadastrarPerfil('Maria Silva', 'maria@exemplo.com', 'senhaCorreta');

      expect(
        () => repositorio.realizarLogin('senhaIncorreta'),
        throwsA(isA<SenhaIncorretaException>()),
      );
    });

    test('realizarLogin lanca PerfilNaoEncontradoException quando perfil nao existir', () async {
      expect(
        () => repositorio.realizarLogin('qualquerSenha'),
        throwsA(isA<PerfilNaoEncontradoException>()),
      );
    });
  });
}
