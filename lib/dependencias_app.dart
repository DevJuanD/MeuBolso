import 'features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/login_usecase.dart';
import 'features/autenticacao/domain/usecases/logout_usecase.dart';
import 'features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'features/categorias/domain/repositories/categoria_repository.dart';
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
  final VerificarPerfilUseCase? verificarPerfilUseCase;
  final CadastrarPerfilUseCase? cadastrarPerfilUseCase;
  final LoginUseCase? loginUseCase;
  final ObterPerfilUseCase? obterPerfilUseCase;
  final LogoutUseCase? logoutUseCase;
  final ObterResumoDashboardUseCase? obterResumoDashboardUseCase;
  final SalvarTransacaoUseCase? salvarTransacaoUseCase;
  final ListarTransacoesUseCase? listarTransacoesUseCase;
  final ExcluirTransacaoUseCase? excluirTransacaoUseCase;
  final RestaurarTransacaoUseCase? restaurarTransacaoUseCase;
  final CriarCategoriaUseCase? criarCategoriaUseCase;
  final ListarCategoriasPorTipoUseCase? listarCategoriasPorTipoUseCase;
  final CategoriaRepository? categoriaRepository;
  final ObterTotaisUseCase? obterTotaisUseCase;
  final ObterGastosPorCategoriaUseCase? obterGastosPorCategoriaUseCase;
  final ObterEvolucaoMensalUseCase? obterEvolucaoMensalUseCase;

  const DependenciasApp({
    this.verificarPerfilUseCase,
    this.cadastrarPerfilUseCase,
    this.loginUseCase,
    this.obterPerfilUseCase,
    this.logoutUseCase,
    this.obterResumoDashboardUseCase,
    this.salvarTransacaoUseCase,
    this.listarTransacoesUseCase,
    this.excluirTransacaoUseCase,
    this.restaurarTransacaoUseCase,
    this.criarCategoriaUseCase,
    this.listarCategoriasPorTipoUseCase,
    this.categoriaRepository,
    this.obterTotaisUseCase,
    this.obterGastosPorCategoriaUseCase,
    this.obterEvolucaoMensalUseCase,
  });

  /// Construtor de fallback usado quando a inicialização falha.
  /// Todas as dependências são nulas; o aplicativo exibe apenas a tela de erro.
  const DependenciasApp.vazia()
      : verificarPerfilUseCase = null,
        cadastrarPerfilUseCase = null,
        loginUseCase = null,
        obterPerfilUseCase = null,
        logoutUseCase = null,
        obterResumoDashboardUseCase = null,
        salvarTransacaoUseCase = null,
        listarTransacoesUseCase = null,
        excluirTransacaoUseCase = null,
        restaurarTransacaoUseCase = null,
        criarCategoriaUseCase = null,
        listarCategoriasPorTipoUseCase = null,
        categoriaRepository = null,
        obterTotaisUseCase = null,
        obterGastosPorCategoriaUseCase = null,
        obterEvolucaoMensalUseCase = null;
}
