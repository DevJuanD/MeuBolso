import 'package:sqflite/sqflite.dart';

import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/exceptions/falhas_categoria.dart';
import '../../domain/repositories/categoria_repository.dart';
import '../datasources/categorias_local_datasource.dart';
import '../models/categoria_model.dart';

/// Implementação do repositório de categorias financeiras utilizando SQLite.
class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriasLocalDataSource _dataSource;

  const CategoriaRepositoryImpl(this._dataSource);

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    final modelos = await _dataSource.listarPorTipo(tipo);
    return modelos.map((m) => m.paraEntidade()).toList();
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    final model = CategoriaModel.deEntidade(categoria);
    try {
      await _dataSource.inserir(model);
      return categoria;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const CategoriaDuplicadaException();
      }
      rethrow;
    }
  }

  @override
  Future<Categoria?> obterPorId(String id) async {
    final model = await _dataSource.obterPorId(id);
    return model?.paraEntidade();
  }

  @override
  Future<Categoria?> buscarPorNomeETipo(String nome, TipoTransacao tipo) async {
    final model = await _dataSource.buscarPorNomeETipo(nome, tipo);
    return model?.paraEntidade();
  }
}
