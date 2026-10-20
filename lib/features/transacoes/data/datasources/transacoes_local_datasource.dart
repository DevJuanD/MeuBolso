import 'package:sqflite/sqflite.dart';

import '../../../../core/database/banco_de_dados.dart';
import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../models/transacao_model.dart';

/// Data Source local para operações de persistência e consulta no SQLite.
class TransacoesLocalDataSource {
  final Future<Database> Function() _obterBanco;

  const TransacoesLocalDataSource([
    this._obterBanco = BancoDeDados.obterInstancia,
  ]);

  /// Insere uma nova transação no banco e retorna o ID gerado.
  Future<int> inserir(TransacaoModel model) async {
    final db = await _obterBanco();
    return db.insert(
      EsquemaBanco.tabelaTransacoes,
      model.paraMapa(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Atualiza os dados de uma transação existente.
  Future<int> atualizar(TransacaoModel model) async {
    final db = await _obterBanco();
    return db.update(
      EsquemaBanco.tabelaTransacoes,
      model.paraMapa(),
      where: '${EsquemaBanco.colTransacaoId} = ?',
      whereArgs: [model.id],
    );
  }

  /// Recupera uma transação por ID.
  Future<TransacaoModel?> obterPorId(int id) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaTransacoes,
      where: '${EsquemaBanco.colTransacaoId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (resultados.isEmpty) return null;
    return TransacaoModel.doMapa(resultados.first);
  }

  /// Lista transações aplicando filtros de tipo, competência e exclusão lógica.
  Future<List<TransacaoModel>> listar({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) async {
    final db = await _obterBanco();
    final clausulas = <String>[];
    final argumentos = <dynamic>[];

    if (!incluirExcluidas) {
      clausulas.add('${EsquemaBanco.colTransacaoExcluidaEm} IS NULL');
    }

    if (tipo != null) {
      clausulas.add('${EsquemaBanco.colTransacaoTipo} = ?');
      argumentos.add(tipo.valorBanco);
    }

    if (competencia != null && competencia.isNotEmpty) {
      clausulas.add('${EsquemaBanco.colTransacaoCompetencia} = ?');
      argumentos.add(competencia);
    }

    final where = clausulas.isNotEmpty ? clausulas.join(' AND ') : null;

    final resultados = await db.query(
      EsquemaBanco.tabelaTransacoes,
      where: where,
      whereArgs: argumentos.isNotEmpty ? argumentos : null,
      orderBy:
          '${EsquemaBanco.colTransacaoDataTransacao} DESC, ${EsquemaBanco.colTransacaoId} DESC',
    );

    return resultados.map((mapa) => TransacaoModel.doMapa(mapa)).toList();
  }

  /// Aplica a exclusão lógica registrando o timestamp em `excluida_em`.
  Future<void> marcarExclusaoLogica(int id, DateTime dataExclusao) async {
    final db = await _obterBanco();
    await db.update(
      EsquemaBanco.tabelaTransacoes,
      {
        EsquemaBanco.colTransacaoExcluidaEm: dataExclusao.toIso8601String(),
      },
      where: '${EsquemaBanco.colTransacaoId} = ?',
      whereArgs: [id],
    );
  }

  /// Restaura uma transação excluída logicamente, limpando `excluida_em`.
  Future<void> restaurarExclusaoLogica(int id) async {
    final db = await _obterBanco();
    await db.update(
      EsquemaBanco.tabelaTransacoes,
      {
        EsquemaBanco.colTransacaoExcluidaEm: null,
      },
      where: '${EsquemaBanco.colTransacaoId} = ?',
      whereArgs: [id],
    );
  }
}
