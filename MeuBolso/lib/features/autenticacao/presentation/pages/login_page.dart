import 'package:flutter/material.dart';

import '../../domain/entities/perfil_local.dart';
import '../controllers/autenticacao_controller.dart';

/// Tela T01: Login e Cadastro de Perfil Local.
class LoginPage extends StatefulWidget {
  final AutenticacaoController controller;
  final void Function(PerfilLocal perfil)? onAutenticado;

  const LoginPage({
    super.key,
    required this.controller,
    this.onAutenticado,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoSenhaController = TextEditingController();

  bool _senhaOculta = true;
  bool _confirmacaoSenhaOculta = true;

  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  void initState() {
    super.initState();
    widget.controller.inicializar();
    widget.controller.addListener(_aoMudarEstado);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_aoMudarEstado);
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmacaoSenhaController.dispose();
    super.dispose();
  }

  void _aoMudarEstado() {
    if (!mounted) return;
    final erro = widget.controller.mensagemErro;
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      widget.controller.limparErro();
    }
  }

  Future<void> _submeter() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = widget.controller;
    if (controller.estaCarregando) return;

    if (controller.modo == ModoAutenticacao.cadastro) {
      final perfil = await controller.cadastrar(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      if (perfil != null && mounted) {
        widget.onAutenticado?.call(perfil);
      }
    } else {
      final perfil = await controller.entrar(
        senha: _senhaController.text,
      );

      if (perfil != null && mounted) {
        widget.onAutenticado?.call(perfil);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) {
            if (widget.controller.modo == ModoAutenticacao.carregando) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final ehCadastro =
                widget.controller.modo == ModoAutenticacao.cadastro;
            final nomePerfil = widget.controller.perfilAtual?.nome ?? '';

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _construirCabecalho(
                          tema: tema,
                          cores: cores,
                          ehCadastro: ehCadastro,
                          nomePerfil: nomePerfil,
                        ),
                        const SizedBox(height: 32),
                        if (ehCadastro) ...[
                          _construirCampoNome(),
                          const SizedBox(height: 16),
                          _construirCampoEmail(),
                          const SizedBox(height: 16),
                        ],
                        _construirCampoSenha(),
                        if (ehCadastro) ...[
                          const SizedBox(height: 16),
                          _construirCampoConfirmacaoSenha(),
                        ],
                        const SizedBox(height: 28),
                        _construirBotaoAcao(
                          ehCadastro: ehCadastro,
                          estaCarregando: widget.controller.estaCarregando,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _construirCabecalho({
    required ThemeData tema,
    required ColorScheme cores,
    required bool ehCadastro,
    required String nomePerfil,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: cores.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            size: 34,
            color: cores.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'MeuBolso',
          style: tema.textTheme.titleMedium?.copyWith(
            color: cores.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ehCadastro
              ? 'Crie seu perfil local'
              : 'Olá, $nomePerfil!',
          textAlign: TextAlign.center,
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ehCadastro
              ? 'Seus dados financeiros protegidos e salvos exclusivamente no aparelho.'
              : 'Digite sua senha para desbloquear seu acesso.',
          textAlign: TextAlign.center,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: cores.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _construirCampoNome() {
    return TextFormField(
      controller: _nomeController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nome completo',
        hintText: 'Como quer ser chamado',
        prefixIcon: Icon(Icons.person_outline_rounded),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Por favor, informe seu nome';
        }
        if (valor.trim().length < 2) {
          return 'O nome deve ter pelo menos 2 caracteres';
        }
        return null;
      },
    );
  }

  Widget _construirCampoEmail() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        hintText: 'seu.email@exemplo.com',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Por favor, informe seu e-mail';
        }
        if (!_emailRegex.hasMatch(valor.trim())) {
          return 'Informe um e-mail com formato válido';
        }
        return null;
      },
    );
  }

  Widget _construirCampoSenha() {
    return TextFormField(
      controller: _senhaController,
      obscureText: _senhaOculta,
      textInputAction: widget.controller.modo == ModoAutenticacao.cadastro
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (widget.controller.modo == ModoAutenticacao.login) {
          _submeter();
        }
      },
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: 'Digite sua senha',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _senhaOculta
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _senhaOculta = !_senhaOculta;
            });
          },
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Por favor, informe a senha';
        }
        if (valor.length < 6) {
          return 'A senha deve conter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _construirCampoConfirmacaoSenha() {
    return TextFormField(
      controller: _confirmacaoSenhaController,
      obscureText: _confirmacaoSenhaOculta,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submeter(),
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        hintText: 'Repita sua senha',
        prefixIcon: const Icon(Icons.lock_reset_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _confirmacaoSenhaOculta
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _confirmacaoSenhaOculta = !_confirmacaoSenhaOculta;
            });
          },
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Confirme sua senha';
        }
        if (valor != _senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _construirBotaoAcao({
    required bool ehCadastro,
    required bool estaCarregando,
  }) {
    return ElevatedButton(
      onPressed: estaCarregando ? null : _submeter,
      child: estaCarregando
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(ehCadastro ? 'Criar Perfil' : 'Entrar'),
    );
  }
}
