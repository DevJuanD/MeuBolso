import '../entities/perfil_local.dart';
import '../repositories/autenticacao_repository.dart';

/// Caso de uso para autenticar o usuário por meio de sua senha.
class LoginUseCase {
  final AutenticacaoRepository _repositorio;

  const LoginUseCase(this._repositorio);

  Future<PerfilLocal> call(String senhaClara) =>
      _repositorio.realizarLogin(senhaClara);
}
