import 'package:sqflite/sqflite.dart';

import '../../../../core/database/banco_de_dados.dart';
import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/exceptions/falhas_categoria.dart';
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

  /// Atualiza uma categoria existente no banco.
  Future<void> atualizar(CategoriaModel model) async {
    final db = await _obterBanco();
    final linhasAfetadas = await db.update(
      EsquemaBanco.tabelaCategorias,
      model.paraMapa(),
      where: '${EsquemaBanco.colCategoriaId} = ?',
      whereArgs: [model.id],
    );
    if (linhasAfetadas == 0) {
      throw const CategoriaNaoEncontradaException();
    }
  }

  /// Exclui logicamente uma categoria preenchendo `excluida_em`.
  Future<void> excluir(String id) async {
    final db = await _obterBanco();
    await db.update(
      EsquemaBanco.tabelaCategorias,
      {EsquemaBanco.colCategoriaExcluidaEm: DateTime.now().toIso8601String()},
      where: '${EsquemaBanco.colCategoriaId} = ?',
      whereArgs: [id],
    );
  }

  /// Lista todas as categorias não excluídas, opcionalmente filtradas por tipo.
  Future<List<CategoriaModel>> listarTodas({TipoTransacao? tipo}) async {
    final db = await _obterBanco();
    final resultados = await db.query(
      EsquemaBanco.tabelaCategorias,
      where:
          tipo != null
              ? '${EsquemaBanco.colCategoriaTipo} = ? AND ${EsquemaBanco.colCategoriaExcluidaEm} IS NULL'
              : '${EsquemaBanco.colCategoriaExcluidaEm} IS NULL',
      whereArgs: tipo != null ? [tipo.valorBanco] : null,
      orderBy:
          '${EsquemaBanco.colCategoriaIsPadrao} DESC, ${EsquemaBanco.colCategoriaNome} ASC',
    );
    return resultados.map((mapa) => CategoriaModel.doMapa(mapa)).toList();
  }

  /// Lista categorias filtradas por tipo ('receita' ou 'despesa').
  Future<List<CategoriaModel>> listarPorTipo(TipoTransacao tipo) async {
    return listarTodas(tipo: tipo);
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
