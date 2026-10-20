import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/perfil_local_model.dart';

/// Data Source para persistência encriptada do perfil no FlutterSecureStorage.
class AutenticacaoLocalDataSource {
  static const String _chavePerfilStorage = 'perfil_usuario_meubolso';

  final FlutterSecureStorage _storage;

  const AutenticacaoLocalDataSource(this._storage);

  /// Salva o modelo do perfil serializado no armazenamento seguro.
  Future<void> salvarPerfil(PerfilLocalModel perfil) async {
    final jsonString = jsonEncode(perfil.toJson());
    await _storage.write(key: _chavePerfilStorage, value: jsonString);
  }

  /// Recupera o modelo do perfil do armazenamento seguro, ou nulo se não existir.
  Future<PerfilLocalModel?> obterPerfil() async {
    final jsonString = await _storage.read(key: _chavePerfilStorage);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return PerfilLocalModel.fromJson(jsonMap);
  }

  /// Remove o perfil do armazenamento seguro.
  Future<void> deletarPerfil() async {
    await _storage.delete(key: _chavePerfilStorage);
  }
}
