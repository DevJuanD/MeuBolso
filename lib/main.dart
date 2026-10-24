import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'features/autenticacao/data/datasources/autenticacao_local_datasource.dart';
import 'features/autenticacao/data/repositories/autenticacao_repository_impl.dart';
import 'features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/login_usecase.dart';
import 'features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/usecases/obter_resumo_dashboard_usecase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  const dataSource = AutenticacaoLocalDataSource(storage);
  const repositorio = AutenticacaoRepositoryImpl(dataSource);

  final verificarPerfilUseCase = VerificarPerfilUseCase(repositorio);
  final cadastrarPerfilUseCase = CadastrarPerfilUseCase(repositorio);
  final loginUseCase = LoginUseCase(repositorio);
  final obterPerfilUseCase = ObterPerfilUseCase(repositorio);

  const dashboardDataSource = DashboardLocalDataSource();
  const dashboardRepositorio = DashboardRepositoryImpl(dashboardDataSource);
  final obterResumoDashboardUseCase = ObterResumoDashboardUseCase(
    dashboardRepositorio,
  );

  runApp(
    MeuBolsoApp(
      verificarPerfilUseCase: verificarPerfilUseCase,
      cadastrarPerfilUseCase: cadastrarPerfilUseCase,
      loginUseCase: loginUseCase,
      obterPerfilUseCase: obterPerfilUseCase,
      obterResumoDashboardUseCase: obterResumoDashboardUseCase,
    ),
  );
}
