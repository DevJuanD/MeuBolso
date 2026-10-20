import '../repositories/autenticacao_repository.dart';

/// Caso de uso para cadastrar o perfil único do usuário.
class CadastrarPerfilUseCase {
  final AutenticacaoRepository _repositorio;

  const CadastrarPerfilUseCase(this._repositorio);

  Future<void> call({
    required String nome,
    required String email,
    required String senhaClara,
  }) =>
      _repositorio.cadastrarPerfil(nome, email, senhaClara);
}
