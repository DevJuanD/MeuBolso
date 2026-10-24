import '../../../transacoes/domain/entities/transacao.dart';
import '../entities/resumo_mensal.dart';

/// Contrato de leitura dos dados agregados da dashboard (T02).
abstract class DashboardRepository {
  /// Retorna o resumo de totais e variações do mês informado.
  Future<ResumoMensal> obterResumoMensal(DateTime mesReferencia);

  /// Retorna as transações mais recentes do mês, limitadas a [limite].
  Future<List<Transacao>> obterUltimasTransacoes(
    DateTime mesReferencia,
    int limite,
  );
}
