import '../entities/perfil_local.dart';

/// Contrato para operações de persistência e validação de autenticação local.
abstract class AutenticacaoRepository {
  /// Verifica se já existe um perfil cadastrado localmente.
  Future<bool> verificarExistenciaPerfil();

  /// Cadastra o perfil único gerando salt e verificador criptográfico.
  Future<void> cadastrarPerfil(String nome, String email, String senhaClara);

  /// Valida a senha contra o verificador criptográfico e retorna o perfil autenticado.
  Future<PerfilLocal> realizarLogin(String senhaClara);

  /// Retorna o perfil existente sem dados de credenciais, ou nulo se não houver.
  Future<PerfilLocal?> obterPerfil();

  /// Remove o perfil atual do dispositivo, desvinculando as credenciais locais.
  Future<void> realizarLogout();
}
