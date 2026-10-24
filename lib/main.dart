import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'core/database/banco_de_dados.dart';
import 'dependencias_app.dart';
import 'features/autenticacao/data/datasources/autenticacao_local_datasource.dart';
import 'features/autenticacao/data/repositories/autenticacao_repository_impl.dart';
import 'features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/login_usecase.dart';
import 'features/autenticacao/domain/usecases/logout_usecase.dart';
import 'features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'features/categorias/data/datasources/categorias_local_datasource.dart';
import 'features/categorias/data/repositories/categoria_repository_impl.dart';
import 'features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'features/categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/usecases/obter_resumo_dashboard_usecase.dart';
import 'features/relatorios/data/datasources/relatorio_local_datasource.dart';
import 'features/relatorios/data/repositories/relatorio_repository_impl.dart';
import 'features/relatorios/domain/usecases/obter_evolucao_mensal_usecase.dart';
import 'features/relatorios/domain/usecases/obter_gastos_por_categoria_usecase.dart';
import 'features/relatorios/domain/usecases/obter_totais_usecase.dart';
import 'features/transacoes/data/datasources/transacoes_local_datasource.dart';
import 'features/transacoes/data/repositories/transacoes_repository_impl.dart';
import 'features/transacoes/domain/usecases/excluir_transacao_usecase.dart';
import 'features/transacoes/domain/usecases/listar_transacoes_usecase.dart';
import 'features/transacoes/domain/usecases/restaurar_transacao_usecase.dart';
import 'features/transacoes/domain/usecases/salvar_transacao_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Garante que o SQLite esteja pronto antes da primeira tela ser renderizada.
  await BancoDeDados.obterInstancia();

  const storage = FlutterSecureStorage();
  const autenticacaoDataSource = AutenticacaoLocalDataSource(storage);
  const autenticacaoRepositorio = AutenticacaoRepositoryImpl(
    autenticacaoDataSource,
  );

  const transacoesDataSource = TransacoesLocalDataSource();
  const transacoesRepositorio = TransacoesRepositoryImpl(transacoesDataSource);

  const categoriasDataSource = CategoriasLocalDataSource();
  const categoriasRepositorio = CategoriaRepositoryImpl(categoriasDataSource);

  const relatorioDataSource = RelatorioLocalDataSource();
  const relatorioRepositorio = RelatorioRepositoryImpl(relatorioDataSource);

  const dashboardDataSource = DashboardLocalDataSource();
  const dashboardRepositorio = DashboardRepositoryImpl(dashboardDataSource);

  runApp(
    MeuBolsoApp(
      dependencias: DependenciasApp(
        verificarPerfilUseCase: VerificarPerfilUseCase(autenticacaoRepositorio),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(autenticacaoRepositorio),
        loginUseCase: LoginUseCase(autenticacaoRepositorio),
        obterPerfilUseCase: ObterPerfilUseCase(autenticacaoRepositorio),
        logoutUseCase: LogoutUseCase(autenticacaoRepositorio),
        obterResumoDashboardUseCase: ObterResumoDashboardUseCase(
          dashboardRepositorio,
        ),
        salvarTransacaoUseCase: SalvarTransacaoUseCase(transacoesRepositorio),
        listarTransacoesUseCase: ListarTransacoesUseCase(transacoesRepositorio),
        excluirTransacaoUseCase: ExcluirTransacaoUseCase(transacoesRepositorio),
        restaurarTransacaoUseCase:
            RestaurarTransacaoUseCase(transacoesRepositorio),
        criarCategoriaUseCase: CriarCategoriaUseCase(categoriasRepositorio),
        listarCategoriasPorTipoUseCase: ListarCategoriasPorTipoUseCase(
          categoriasRepositorio,
        ),
        obterTotaisUseCase: ObterTotaisUseCase(relatorioRepositorio),
        obterGastosPorCategoriaUseCase: ObterGastosPorCategoriaUseCase(
          relatorioRepositorio,
        ),
        obterEvolucaoMensalUseCase: ObterEvolucaoMensalUseCase(
          relatorioRepositorio,
        ),
      ),
    ),
  );
}
