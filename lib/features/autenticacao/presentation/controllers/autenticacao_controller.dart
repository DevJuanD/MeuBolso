import 'package:flutter/foundation.dart';

import '../../domain/entities/perfil_local.dart';
import '../../domain/exceptions/falhas_autenticacao.dart';
import '../../domain/usecases/cadastrar_perfil_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/obter_perfil_usecase.dart';
import '../../domain/usecases/verificar_perfil_usecase.dart';

/// Modos da tela de autenticação.
enum ModoAutenticacao {
  carregando,
  cadastro,
  login,
}

/// Controlador de apresentação para o fluxo de autenticação e perfil local.
class AutenticacaoController extends ChangeNotifier {
  final VerificarPerfilUseCase _verificarPerfilUseCase;
  final CadastrarPerfilUseCase _cadastrarPerfilUseCase;
  final LoginUseCase _loginUseCase;
  final ObterPerfilUseCase _obterPerfilUseCase;

  AutenticacaoController({
    required VerificarPerfilUseCase verificarPerfilUseCase,
    required CadastrarPerfilUseCase cadastrarPerfilUseCase,
    required LoginUseCase loginUseCase,
    required ObterPerfilUseCase obterPerfilUseCase,
  })  : _verificarPerfilUseCase = verificarPerfilUseCase,
        _cadastrarPerfilUseCase = cadastrarPerfilUseCase,
        _loginUseCase = loginUseCase,
        _obterPerfilUseCase = obterPerfilUseCase;

  ModoAutenticacao _modo = ModoAutenticacao.carregando;
  ModoAutenticacao get modo => _modo;

  bool _estaCarregando = false;
  bool get estaCarregando => _estaCarregando;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  PerfilLocal? _perfilAtual;
  PerfilLocal? get perfilAtual => _perfilAtual;

  /// Inicializa verificando se já existe um perfil cadastrado no dispositivo.
  Future<void> inicializar() async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final existe = await _verificarPerfilUseCase();
      if (existe) {
        _perfilAtual = await _obterPerfilUseCase();
        _modo = ModoAutenticacao.login;
      } else {
        _perfilAtual = null;
        _modo = ModoAutenticacao.cadastro;
      }
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar os dados de autenticação.';
      _modo = ModoAutenticacao.cadastro;
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  /// Realiza o cadastro do perfil local com nome, e-mail e senha.
  Future<PerfilLocal?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _cadastrarPerfilUseCase(
        nome: nome,
        email: email,
        senhaClara: senha,
      );
      final perfil = await _obterPerfilUseCase();
      _perfilAtual = perfil;
      _modo = ModoAutenticacao.login;
      return perfil;
    } on FalhaAutenticacao catch (e) {
      _mensagemErro = e.mensagem;
      return null;
    } catch (_) {
      _mensagemErro = 'Ocorreu um erro ao cadastrar o perfil.';
      return null;
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  /// Realiza o login comparando a senha informada com o verificador gravado.
  Future<PerfilLocal?> entrar({required String senha}) async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final perfil = await _loginUseCase(senha);
      _perfilAtual = perfil;
      return perfil;
    } on FalhaAutenticacao catch (e) {
      _mensagemErro = e.mensagem;
      return null;
    } catch (_) {
      _mensagemErro = 'Ocorreu um erro ao realizar login.';
      return null;
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  void limparErro() {
    if (_mensagemErro != null) {
      _mensagemErro = null;
      notifyListeners();
    }
  }
}
