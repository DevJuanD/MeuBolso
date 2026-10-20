/// Falhas e exceções de domínio para o fluxo de autenticação.
sealed class FalhaAutenticacao implements Exception {
  final String mensagem;
  const FalhaAutenticacao(this.mensagem);

  @override
  String toString() => mensagem;
}

/// Lançada quando a senha informada não coincide com o hash verificado.
class SenhaIncorretaException extends FalhaAutenticacao {
  const SenhaIncorretaException([
    super.mensagem = 'Senha incorreta. Verifique e tente novamente.',
  ]);
}

/// Lançada quando nenhuma conta/perfil local existe no dispositivo.
class PerfilNaoEncontradoException extends FalhaAutenticacao {
  const PerfilNaoEncontradoException([
    super.mensagem = 'Perfil local não encontrado neste dispositivo.',
  ]);
}

/// Lançada ao tentar cadastrar mais de um perfil no mesmo dispositivo.
class PerfilJaCadastradoException extends FalhaAutenticacao {
  const PerfilJaCadastradoException([
    super.mensagem = 'Já existe um perfil cadastrado neste dispositivo.',
  ]);
}

/// Lançada quando os campos não atendem aos critérios de validação de domínio.
class ValidacaoAutenticacaoException extends FalhaAutenticacao {
  const ValidacaoAutenticacaoException(super.mensagem);
}
