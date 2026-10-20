import '../repositories/autenticacao_repository.dart';

/// Caso de uso para verificar se o usuário já possui um perfil cadastrado.
class VerificarPerfilUseCase {
  final AutenticacaoRepository _repositorio;

  const VerificarPerfilUseCase(this._repositorio);

  Future<bool> call() => _repositorio.verificarExistenciaPerfil();
}
