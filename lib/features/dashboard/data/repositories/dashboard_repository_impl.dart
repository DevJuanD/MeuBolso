import '../../../transacoes/domain/entities/transacao.dart';
import '../../domain/entities/resumo_mensal.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

/// Implementação do repositório da dashboard sobre o SQLite local.
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _dataSource;

  const DashboardRepositoryImpl(this._dataSource);

  @override
  Future<ResumoMensal> obterResumoMensal(DateTime mesReferencia) async {
    final mesAtual = _iniciarMes(mesReferencia);
    final mesAnterior = DateTime(mesAtual.year, mesAtual.month - 1);

    final totais = await Future.wait([
      _dataSource.obterTotaisPorCompetencia(_competenciaDe(mesAtual)),
      _dataSource.obterTotaisPorCompetencia(_competenciaDe(mesAnterior)),
    ]);

    final atual = totais[0];
    final anterior = totais[1];

    return ResumoMensal(
      mesAtual: mesAtual,
      totalReceitas: atual.receitasCentavos,
      totalDespesas: atual.despesasCentavos,
      saldo: atual.saldoCentavos,
      variacaoSaldo: _calcularVariacao(
        atual.saldoCentavos,
        anterior.saldoCentavos,
      ),
      variacaoReceitas: _calcularVariacao(
        atual.receitasCentavos,
        anterior.receitasCentavos,
      ),
      variacaoDespesas: _calcularVariacao(
        atual.despesasCentavos,
        anterior.despesasCentavos,
      ),
    );
  }

  @override
  Future<List<Transacao>> obterUltimasTransacoes(
    DateTime mesReferencia,
    int limite,
  ) async {
    final modelos = await _dataSource.listarUltimas(
      _competenciaDe(_iniciarMes(mesReferencia)),
      limite,
    );
    return modelos.map((modelo) => modelo.paraEntidade()).toList();
  }

  static DateTime _iniciarMes(DateTime data) => DateTime(data.year, data.month);

  static String _competenciaDe(DateTime data) {
    final mes = data.month.toString().padLeft(2, '0');
    return '${data.year}-$mes';
  }

  // Sem registros no mês anterior não há base de comparação; a variação é
  // exibida como 0% para não sugerir crescimento/queda inexistente.
  static double _calcularVariacao(int totalAtual, int totalAnterior) {
    if (totalAnterior == 0) return 0;
    return ((totalAtual - totalAnterior) / totalAnterior) * 100;
  }
}
