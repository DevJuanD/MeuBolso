import '../entities/dados_dashboard.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso que orquestra a busca do resumo mensal e das últimas
/// transações exibidas na tela T02 (Início).
class ObterResumoDashboardUseCase {
  final DashboardRepository _repositorio;

  const ObterResumoDashboardUseCase(this._repositorio);

  Future<DadosDashboard> call(
    DateTime mesReferencia, {
    int limiteUltimasTransacoes = 5,
  }) async {
    final resumoFuturo = _repositorio.obterResumoMensal(mesReferencia);
    final ultimasFuturas = _repositorio.obterUltimasTransacoes(
      mesReferencia,
      limiteUltimasTransacoes,
    );

    return DadosDashboard(
      resumo: await resumoFuturo,
      ultimasTransacoes: await ultimasFuturas,
    );
  }
}
