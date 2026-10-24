import 'package:sqflite/sqflite.dart';

import '../../../../core/database/banco_de_dados.dart';
import '../../../../core/database/esquema_banco.dart';
import '../../domain/entities/evolucao_mensal.dart';
import '../../domain/entities/filtro_relatorio.dart';
import '../models/gasto_categoria_bruto.dart';
import '../models/totais_periodo_bruto.dart';

/// Data Source das consultas agregadas de relatórios (T05).
///
/// Todas as consultas são executadas diretamente no SQLite via [Database.rawQuery]
/// para aproveitar `SUM`, `GROUP BY` e `JOIN` sem carregar registros para a
/// memória. Registros com exclusão lógica são sempre ignorados.
class RelatorioLocalDataSource {
  final Future<Database> Function() _obterBanco;

  const RelatorioLocalDataSource([
    this._obterBanco = BancoDeDados.obterInstancia,
  ]);

  /// Totaliza receitas e despesas do período em uma única consulta.
  Future<TotaisPeriodoBruto> obterTotais(FiltroRelatorio filtro) async {
    final db = await _obterBanco();
    final filtros = _montarFiltros(filtro);

    final resultado = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = 'receita'
            THEN ${EsquemaBanco.colTransacaoValorCentavos} ELSE 0 END), 0) AS receitas,
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = 'despesa'
            THEN ${EsquemaBanco.colTransacaoValorCentavos} ELSE 0 END), 0) AS despesas
      FROM ${EsquemaBanco.tabelaTransacoes}
      WHERE ${filtros.condicoes}
      ''',
      filtros.argumentos,
    );

    final linha = resultado.first;
    return TotaisPeriodoBruto(
      totalReceitas: (linha['receitas'] as num?)?.toInt() ?? 0,
      totalDespesas: (linha['despesas'] as num?)?.toInt() ?? 0,
    );
  }

  /// Soma as despesas agrupadas por categoria no período, em ordem decrescente.
  Future<List<GastoCategoriaBruto>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  ) async {
    final db = await _obterBanco();
    final filtros = _montarFiltros(filtro, alias: 't');

    final resultado = await db.rawQuery(
      '''
      SELECT
        c.${EsquemaBanco.colCategoriaNome} AS categoria_nome,
        COALESCE(SUM(t.${EsquemaBanco.colTransacaoValorCentavos}), 0) AS total_centavos
      FROM ${EsquemaBanco.tabelaTransacoes} t
      INNER JOIN ${EsquemaBanco.tabelaCategorias} c
        ON c.${EsquemaBanco.colCategoriaId} = t.${EsquemaBanco.colTransacaoCategoriaId}
      WHERE ${filtros.condicoes}
        AND t.${EsquemaBanco.colTransacaoTipo} = 'despesa'
      GROUP BY c.${EsquemaBanco.colCategoriaId}
      ORDER BY total_centavos DESC
      ''',
      filtros.argumentos,
    );

    return resultado
        .map(
          (linha) => GastoCategoriaBruto(
            categoriaNome: linha['categoria_nome'] as String,
            totalCentavos: (linha['total_centavos'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList();
  }

  /// Agrupa receitas e despesas por competência (AAAA-MM), em ordem cronológica.
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    FiltroRelatorio filtro,
  ) async {
    final db = await _obterBanco();
    final filtros = _montarFiltros(filtro);

    final resultado = await db.rawQuery(
      '''
      SELECT
        ${EsquemaBanco.colTransacaoCompetencia} AS competencia,
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = 'receita'
            THEN ${EsquemaBanco.colTransacaoValorCentavos} ELSE 0 END), 0) AS receitas,
        COALESCE(SUM(CASE WHEN ${EsquemaBanco.colTransacaoTipo} = 'despesa'
            THEN ${EsquemaBanco.colTransacaoValorCentavos} ELSE 0 END), 0) AS despesas
      FROM ${EsquemaBanco.tabelaTransacoes}
      WHERE ${filtros.condicoes}
      GROUP BY ${EsquemaBanco.colTransacaoCompetencia}
      ORDER BY ${EsquemaBanco.colTransacaoCompetencia} ASC
      ''',
      filtros.argumentos,
    );

    return resultado
        .map(
          (linha) => EvolucaoMensal(
            competencia: linha['competencia'] as String,
            totalReceitas: (linha['receitas'] as num?)?.toInt() ?? 0,
            totalDespesas: (linha['despesas'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList();
  }

  /// Monta as condições dinâmicas comuns a todas as consultas.
  ///
  /// A cláusula de exclusão lógica é sempre incluída, conforme a regra padrão.
  /// O período é inclusivo: a data inicial é normalizada para o início do dia
  /// e a final para o fim do dia (23:59:59.999), pois o banco armazena datas
  /// em texto ISO8601.
  ({String condicoes, List<Object?> argumentos}) _montarFiltros(
    FiltroRelatorio filtro, {
    String alias = '',
  }) {
    final prefixo = alias.isEmpty ? '' : '$alias.';
    final condicoes = <String>[
      '$prefixo${EsquemaBanco.colTransacaoExcluidaEm} IS NULL',
    ];
    final argumentos = <Object?>[];

    if (filtro.dataInicial != null) {
      condicoes.add('$prefixo${EsquemaBanco.colTransacaoDataTransacao} >= ?');
      argumentos.add(_inicioDoDia(filtro.dataInicial!));
    }
    if (filtro.dataFinal != null) {
      condicoes.add('$prefixo${EsquemaBanco.colTransacaoDataTransacao} <= ?');
      argumentos.add(_fimDoDia(filtro.dataFinal!));
    }
    if (filtro.tipo != null) {
      condicoes.add('$prefixo${EsquemaBanco.colTransacaoTipo} = ?');
      argumentos.add(filtro.tipo!.valorBanco);
    }
    if (filtro.categoriaId != null) {
      condicoes.add('$prefixo${EsquemaBanco.colTransacaoCategoriaId} = ?');
      argumentos.add(filtro.categoriaId);
    }

    return (condicoes: condicoes.join(' AND '), argumentos: argumentos);
  }

  static String _inicioDoDia(DateTime data) {
    return DateTime(data.year, data.month, data.day).toIso8601String();
  }

  static String _fimDoDia(DateTime data) {
    return DateTime(data.year, data.month, data.day, 23, 59, 59, 999)
        .toIso8601String();
  }
}
