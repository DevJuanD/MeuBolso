import 'features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/login_usecase.dart';
import 'features/autenticacao/domain/usecases/logout_usecase.dart';
import 'features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'features/categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'features/dashboard/domain/usecases/obter_resumo_dashboard_usecase.dart';
import 'features/relatorios/domain/usecases/obter_evolucao_mensal_usecase.dart';
import 'features/relatorios/domain/usecases/obter_gastos_por_categoria_usecase.dart';
import 'features/relatorios/domain/usecases/obter_totais_usecase.dart';
import 'features/transacoes/domain/usecases/excluir_transacao_usecase.dart';
import 'features/transacoes/domain/usecases/listar_transacoes_usecase.dart';
import 'features/transacoes/domain/usecases/restaurar_transacao_usecase.dart';
import 'features/transacoes/domain/usecases/salvar_transacao_usecase.dart';

/// Agregado com todos os casos de uso necessários para compor a aplicação.
///
/// É montado exclusivamente na raiz (`main.dart`) e entregue ao `MeuBolsoApp`
/// por construtor, evitando service locators globais.
class DependenciasApp {
  final VerificarPerfilUseCase verificarPerfilUseCase;
  final CadastrarPerfilUseCase cadastrarPerfilUseCase;
  final LoginUseCase loginUseCase;
  final ObterPerfilUseCase obterPerfilUseCase;
  final LogoutUseCase logoutUseCase;
  final ObterResumoDashboardUseCase obterResumoDashboardUseCase;
  final SalvarTransacaoUseCase salvarTransacaoUseCase;
  final ListarTransacoesUseCase listarTransacoesUseCase;
  final ExcluirTransacaoUseCase excluirTransacaoUseCase;
  final RestaurarTransacaoUseCase restaurarTransacaoUseCase;
  final CriarCategoriaUseCase criarCategoriaUseCase;
  final ListarCategoriasPorTipoUseCase listarCategoriasPorTipoUseCase;
  final ObterTotaisUseCase obterTotaisUseCase;
  final ObterGastosPorCategoriaUseCase obterGastosPorCategoriaUseCase;
  final ObterEvolucaoMensalUseCase obterEvolucaoMensalUseCase;

  const DependenciasApp({
    required this.verificarPerfilUseCase,
    required this.cadastrarPerfilUseCase,
    required this.loginUseCase,
    required this.obterPerfilUseCase,
    required this.logoutUseCase,
    required this.obterResumoDashboardUseCase,
    required this.salvarTransacaoUseCase,
    required this.listarTransacoesUseCase,
    required this.excluirTransacaoUseCase,
    required this.restaurarTransacaoUseCase,
    required this.criarCategoriaUseCase,
    required this.listarCategoriasPorTipoUseCase,
    required this.obterTotaisUseCase,
    required this.obterGastosPorCategoriaUseCase,
    required this.obterEvolucaoMensalUseCase,
  });
}
