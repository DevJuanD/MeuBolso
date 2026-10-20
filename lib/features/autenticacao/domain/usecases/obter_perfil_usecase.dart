import '../entities/perfil_local.dart';
import '../repositories/autenticacao_repository.dart';

/// Caso de uso para recuperar os dados do perfil salvo (nome e e-mail).
class ObterPerfilUseCase {
  final AutenticacaoRepository _repositorio;

  const ObterPerfilUseCase(this._repositorio);

  Future<PerfilLocal?> call() => _repositorio.obterPerfil();
}
