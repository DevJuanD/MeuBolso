import '../../domain/entities/perfil_local.dart';

/// DTO de transferência para persistência segura do perfil.
class PerfilLocalModel {
  final String nome;
  final String email;
  final String salt;
  final String verificadorSenha;

  const PerfilLocalModel({
    required this.nome,
    required this.email,
    required this.salt,
    required this.verificadorSenha,
  });

  factory PerfilLocalModel.fromJson(Map<String, dynamic> json) {
    return PerfilLocalModel(
      nome: json['nome'] as String,
      email: json['email'] as String,
      salt: json['salt'] as String,
      verificadorSenha:
          (json['verificadorSenha'] ?? json['verificador_senha']) as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'salt': salt,
      'verificadorSenha': verificadorSenha,
    };
  }

  PerfilLocal paraEntidade() {
    return PerfilLocal(
      nome: nome,
      email: email,
    );
  }
}
