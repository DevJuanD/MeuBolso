import '../repositories/autenticacao_repository.dart';

/// Caso de uso para atualizar os dados do perfil local (nome, e-mail e senha opcional).
class AtualizarPerfilUseCase {
  final AutenticacaoRepository _repositorio;

  const AtualizarPerfilUseCase(this._repositorio);

  /// Atualiza o perfil com os novos dados informados.
  ///
  /// [senhaClara] é opcional: quando nula ou vazia, a senha atual é mantida.
  Future<void> call({
    required String nome,
    required String email,
    String? senhaClara,
  }) =>
      _repositorio.atualizarPerfil(
        nome: nome,
        email: email,
        senhaClara: senhaClara,
      );
}
