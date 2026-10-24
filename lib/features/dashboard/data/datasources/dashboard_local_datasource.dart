import 'package:sqflite/sqflite.dart';

import '../../../../core/database/banco_de_dados.dart';
import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../../transacoes/data/models/transacao_model.dart';
import '../models/totais_do_mes.dart';

/// Data Source com as consultas de agregação da dashboard (T02).
///
/// As totalizações são executadas no SQLite via `SUM(valor_centavos)` para
/// evitar carregar os registros para a memória (RNF06), mesmo com milhares
/// de transações. Registros com exclusão lógica são sempre ignorados.
class DashboardLocalDataSource {
  final Future<Database> Function() _obterBanco;

  const DashboardLocalDataSource([
    this._obterBanco = BancoDeDados.obterInstancia,
  ]);

  /// Totaliza receitas e despesas da competência em uma única passada no banco.
  Future<TotaisDoMes> obterTotaisPorCompetencia(String competencia) async {
    final db = await _obterBanco();
    final resultados = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = ?
            THEN ${EsquemaBanco.colTransacaoValorCentavos} END), 0) AS receitas,
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = ?
            THEN ${EsquemaBanco.colTransacaoValorCentavos} END), 0) AS despesas
      FROM ${EsquemaBanco.tabelaTransacoes}
      WHERE ${EsquemaBanco.colTransacaoCompetencia} = ?
        AND ${EsquemaBanco.colTransacaoExcluidaEm} IS NULL
      ''',
      [
        TipoTransacao.receita.valorBanco,
        TipoTransacao.despesa.valorBanco,
        competencia,
      ],
    );

    final linha = resultados.first;
    return TotaisDoMes(
      receitasCentavos: (linha['receitas'] as num?)?.toInt() ?? 0,
      despesasCentavos: (linha['despesas'] as num?)?.toInt() ?? 0,
    );
  }

  /// Lista as transações mais recentes da competência, limitadas a [limite].
  Future<List<TransacaoModel>> listarUltimas(
    String competencia,
    int limite,
  ) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaTransacoes,
      where:
          '${EsquemaBanco.colTransacaoCompetencia} = ? '
          'AND ${EsquemaBanco.colTransacaoExcluidaEm} IS NULL',
      whereArgs: [competencia],
      orderBy:
          '${EsquemaBanco.colTransacaoDataTransacao} DESC, '
          '${EsquemaBanco.colTransacaoId} DESC',
      limit: limite,
    );

    return resultados.map((mapa) => TransacaoModel.doMapa(mapa)).toList();
  }
}
