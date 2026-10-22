import '../../../core/domain/enums/tipo_transacao.dart';
import '../entities/categoria.dart';
import '../repositories/categoria_repository.dart';

/// Caso de uso para listar categorias financeiras filtradas por tipo (receita ou despesa).
class ListarCategoriasPorTipoUseCase {
  final CategoriaRepository _repositorio;

  const ListarCategoriasPorTipoUseCase(this._repositorio);

  Future<List<Categoria>> call(TipoTransacao tipo) async {
    return _repositorio.listarPorTipo(tipo);
  }
}
