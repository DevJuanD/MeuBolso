import 'package:sqflite/sqflite.dart';

import '../../../../core/database/banco_de_dados.dart';
import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../models/categoria_model.dart';

/// Data Source local para operações com a tabela de categorias no SQLite.
class CategoriasLocalDataSource {
  final Future<Database> Function() _obterBanco;

  const CategoriasLocalDataSource([
    this._obterBanco = BancoDeDados.obterInstancia,
  ]);

  /// Insere uma nova categoria no banco.
  Future<void> inserir(CategoriaModel model) async {
    final db = await _obterBanco();
    await db.insert(
      EsquemaBanco.tabelaCategorias,
      model.paraMapa(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Lista categorias filtradas por tipo ('receita' ou 'despesa').
  Future<List<CategoriaModel>> listarPorTipo(TipoTransacao tipo) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaCategorias,
      where: '${EsquemaBanco.colCategoriaTipo} = ?',
      whereArgs: [tipo.valorBanco],
      orderBy:
          '${EsquemaBanco.colCategoriaIsPadrao} DESC, ${EsquemaBanco.colCategoriaNome} ASC',
    );
    return resultados.map((mapa) => CategoriaModel.doMapa(mapa)).toList();
  }

  /// Obtém uma categoria pelo ID.
  Future<CategoriaModel?> obterPorId(String id) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaCategorias,
      where: '${EsquemaBanco.colCategoriaId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (resultados.isEmpty) return null;
    return CategoriaModel.doMapa(resultados.first);
  }

  /// Busca uma categoria pelo nome e tipo.
  Future<CategoriaModel?> buscarPorNomeETipo(
    String nome,
    TipoTransacao tipo,
  ) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaCategorias,
      where:
          'LOWER(${EsquemaBanco.colCategoriaNome}) = LOWER(?) AND ${EsquemaBanco.colCategoriaTipo} = ?',
      whereArgs: [nome.trim(), tipo.valorBanco],
      limit: 1,
    );
    if (resultados.isEmpty) return null;
    return CategoriaModel.doMapa(resultados.first);
  }
}
