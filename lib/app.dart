import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/autenticacao/domain/entities/perfil_local.dart';
import 'features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/login_usecase.dart';
import 'features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'features/autenticacao/presentation/controllers/autenticacao_controller.dart';
import 'features/autenticacao/presentation/pages/login_page.dart';
import 'features/financas/presentation/pages/root_shell.dart';

class MeuBolsoApp extends StatefulWidget {
  final VerificarPerfilUseCase verificarPerfilUseCase;
  final CadastrarPerfilUseCase cadastrarPerfilUseCase;
  final LoginUseCase loginUseCase;
  final ObterPerfilUseCase obterPerfilUseCase;

  const MeuBolsoApp({
    super.key,
    required this.verificarPerfilUseCase,
    required this.cadastrarPerfilUseCase,
    required this.loginUseCase,
    required this.obterPerfilUseCase,
  });

  @override
  State<MeuBolsoApp> createState() => _MeuBolsoAppState();
}

class _MeuBolsoAppState extends State<MeuBolsoApp> {
  late final AutenticacaoController _autenticacaoController;
  ThemeMode _tema = ThemeMode.system;
  bool _autenticado = false;

  @override
  void initState() {
    super.initState();
    _autenticacaoController = AutenticacaoController(
      verificarPerfilUseCase: widget.verificarPerfilUseCase,
      cadastrarPerfilUseCase: widget.cadastrarPerfilUseCase,
      loginUseCase: widget.loginUseCase,
      obterPerfilUseCase: widget.obterPerfilUseCase,
    );
  }

  @override
  void dispose() {
    _autenticacaoController.dispose();
    super.dispose();
  }

  void _aoAutenticar(PerfilLocal _) {
    setState(() => _autenticado = true);
  }

  void _alterarTema(ThemeMode tema) {
    setState(() => _tema = tema);
  }

  @override
  Widget build(BuildContext context) {
    // Os dois temas precisam ser construídos para o MaterialApp. Cada um
    // atualiza a paleta global; o Builder abaixo restaura o brilho ativo.
    final temaClaro = AppTheme.claro;
    final temaEscuro = AppTheme.escuro;

    return MaterialApp(
      title: 'MeuBolso',
      debugShowCheckedModeBanner: false,
      theme: temaClaro,
      darkTheme: temaEscuro,
      themeMode: _tema,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          AppColors.aplicar(Theme.of(context).brightness);

          if (_autenticado) {
            return RootShell(
              themeMode: _tema,
              onThemeModeChanged: _alterarTema,
            );
          }

          return LoginPage(
            controller: _autenticacaoController,
            onAutenticado: _aoAutenticar,
          );
        },
      ),
    );
  }
}
