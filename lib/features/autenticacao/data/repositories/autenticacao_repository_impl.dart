import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import '../../domain/entities/perfil_local.dart';
import '../../domain/exceptions/falhas_autenticacao.dart';
import '../../domain/repositories/autenticacao_repository.dart';
import '../datasources/autenticacao_local_datasource.dart';
import '../models/perfil_local_model.dart';

/// Implementação do repositório de autenticação local com criptografia SHA-256 e Salt.
class AutenticacaoRepositoryImpl implements AutenticacaoRepository {
  final AutenticacaoLocalDataSource _dataSource;

  const AutenticacaoRepositoryImpl(this._dataSource);

  @override
  Future<bool> verificarExistenciaPerfil() async {
    final perfil = await _dataSource.obterPerfil();
    return perfil != null;
  }

  @override
  Future<void> cadastrarPerfil(
    String nome,
    String email,
    String senhaClara,
  ) async {
    final perfilExistente = await _dataSource.obterPerfil();
    if (perfilExistente != null) {
      throw const PerfilJaCadastradoException();
    }

    final salt = _gerarSalt();
    final verificadorSenha = _gerarHash(senhaClara, salt);

    final novoPerfil = PerfilLocalModel(
      nome: nome.trim(),
      email: email.trim(),
      salt: salt,
      verificadorSenha: verificadorSenha,
    );

    await _dataSource.salvarPerfil(novoPerfil);
  }

  @override
  Future<PerfilLocal> realizarLogin(String senhaClara) async {
    final perfil = await _dataSource.obterPerfil();
    if (perfil == null) {
      throw const PerfilNaoEncontradoException();
    }

    final hashCalculado = _gerarHash(senhaClara, perfil.salt);
    if (hashCalculado != perfil.verificadorSenha) {
      throw const SenhaIncorretaException();
    }

    return perfil.paraEntidade();
  }

  @override
  Future<PerfilLocal?> obterPerfil() async {
    final perfil = await _dataSource.obterPerfil();
    return perfil?.paraEntidade();
  }

  @override
  Future<void> realizarLogout() async {
    await _dataSource.deletarPerfil();
  }

  String _gerarSalt([int tamanhoBytes = 16]) {
    final geradorAleatorio = Random.secure();
    final bytes = List<int>.generate(
      tamanhoBytes,
      (_) => geradorAleatorio.nextInt(256),
    );
    return base64Url.encode(bytes);
  }

  String _gerarHash(String senha, String salt) {
    final bytes = utf8.encode('$senha:$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
