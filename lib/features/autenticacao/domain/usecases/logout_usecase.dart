import '../repositories/autenticacao_repository.dart';

/// Caso de uso para desvincular o perfil atual do dispositivo.
///
/// Delega a remoção das credenciais ao repositório, mantendo a camada de
/// domínio independente dos detalhes de armazenamento.
class LogoutUseCase {
  final AutenticacaoRepository _repositorio;

  const LogoutUseCase(this._repositorio);

  Future<void> call() {
    return _repositorio.realizarLogout();
  }
}
