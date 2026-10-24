import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/navegacao/rotas_app.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'dependencias_app.dart';
import 'features/autenticacao/presentation/controllers/autenticacao_controller.dart';
import 'features/autenticacao/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'features/financas/presentation/pages/despesa_form_page.dart';
import 'features/financas/presentation/pages/movimentacoes_page.dart';
import 'features/financas/presentation/pages/receita_form_page.dart';
import 'features/financas/presentation/pages/receitas_page.dart';
import 'features/financas/presentation/pages/root_shell.dart';
import 'features/relatorios/presentation/controllers/relatorio_controller.dart';
import 'features/transacoes/domain/entities/transacao.dart';
import 'features/transacoes/presentation/controllers/transacoes_controller.dart';

class MeuBolsoApp extends StatefulWidget {
  final DependenciasApp dependencias;

  const MeuBolsoApp({
    super.key,
    required this.dependencias,
  });

  @override
  State<MeuBolsoApp> createState() => _MeuBolsoAppState();
}

class _MeuBolsoAppState extends State<MeuBolsoApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final AutenticacaoController _autenticacaoController;
  late final DashboardController _dashboardController;
  late final RelatorioController _relatorioController;
  late final TransacoesController _transacoesController;

  ThemeMode _tema = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    final dependencias = widget.dependencias;

    _autenticacaoController = AutenticacaoController(
      verificarPerfilUseCase: dependencias.verificarPerfilUseCase,
      cadastrarPerfilUseCase: dependencias.cadastrarPerfilUseCase,
      loginUseCase: dependencias.loginUseCase,
      obterPerfilUseCase: dependencias.obterPerfilUseCase,
    );

    _dashboardController = DashboardController(
      obterResumoDashboardUseCase: dependencias.obterResumoDashboardUseCase,
      obterPerfilUseCase: dependencias.obterPerfilUseCase,
    );

    _relatorioController = RelatorioController(
      obterTotaisUseCase: dependencias.obterTotaisUseCase,
      obterGastosPorCategoriaUseCase: dependencias.obterGastosPorCategoriaUseCase,
      obterEvolucaoMensalUseCase: dependencias.obterEvolucaoMensalUseCase,
      listarTransacoesUseCase: dependencias.listarTransacoesUseCase,
      listarCategoriasPorTipoUseCase:
          dependencias.listarCategoriasPorTipoUseCase,
    );

    _transacoesController = TransacoesController(
      salvarTransacaoUseCase: dependencias.salvarTransacaoUseCase,
      listarTransacoesUseCase: dependencias.listarTransacoesUseCase,
      excluirTransacaoUseCase: dependencias.excluirTransacaoUseCase,
      restaurarTransacaoUseCase: dependencias.restaurarTransacaoUseCase,
      criarCategoriaUseCase: dependencias.criarCategoriaUseCase,
      listarCategoriasPorTipoUseCase:
          dependencias.listarCategoriasPorTipoUseCase,
      navigatorKey: _navigatorKey,
      aoAlterarDados: _recarregarAposAlteracao,
    );
  }

  @override
  void dispose() {
    _autenticacaoController.dispose();
    _dashboardController.dispose();
    _relatorioController.dispose();
    _transacoesController.dispose();
    super.dispose();
  }

  /// Após salvar/excluir, dashboard e relatórios recarregam do SQLite.
  Future<void> _recarregarAposAlteracao() async {
    await Future.wait([
      _dashboardController.carregar(),
      _relatorioController.carregar(),
    ]);
  }

  void _alterarTema(ThemeMode tema) {
    setState(() => _tema = tema);
  }

  void _navegarAba(int indice) {
    final rota = switch (indice) {
      1 => RotasApp.transacoes,
      2 => RotasApp.relatorios,
      _ => RotasApp.inicio,
    };
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      rota,
      (route) => false,
    );
  }

  RootShell _shell(int abaInicial) {
    return RootShell(
      themeMode: _tema,
      onThemeModeChanged: _alterarTema,
      dashboardController: _dashboardController,
      transacoesController: _transacoesController,
      relatorioController: _relatorioController,
      abaInicial: abaInicial,
    );
  }

  Route<dynamic>? _gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case RotasApp.receitas:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ReceitasPage(
            controller: _transacoesController,
            onAbaSelecionada: _navegarAba,
          ),
        );
      case RotasApp.movimentacoes:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MovimentacoesPage(
            controller: _transacoesController,
            onAbaSelecionada: _navegarAba,
          ),
        );
      case RotasApp.receitaForm:
        final transacao = settings.arguments as Transacao?;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ReceitaFormPage(
            controller: _transacoesController,
            receita: transacao,
          ),
        );
      case RotasApp.despesaForm:
        final transacao = settings.arguments as Transacao?;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => DespesaFormPage(
            controller: _transacoesController,
            despesa: transacao,
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final temaClaro = AppTheme.claro;
    final temaEscuro = AppTheme.escuro;

    return MaterialApp(
      navigatorKey: _navigatorKey,
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
      initialRoute: RotasApp.login,
      builder: (context, child) {
        AppColors.aplicar(Theme.of(context).brightness);
        return child ?? const SizedBox.shrink();
      },
      routes: {
        RotasApp.login: (context) => LoginPage(
              controller: _autenticacaoController,
              onAutenticado: (_) {
                Navigator.of(context)
                    .pushReplacementNamed(RotasApp.inicio);
              },
            ),
        RotasApp.inicio: (_) => _shell(0),
        RotasApp.transacoes: (_) => _shell(1),
        RotasApp.relatorios: (_) => _shell(2),
      },
      onGenerateRoute: _gerarRota,
    );
  }
}
