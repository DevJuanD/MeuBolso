import '../../../core/domain/enums/tipo_transacao.dart';
import '../entities/categoria.dart';

/// Contrato do repositório para persistência e consulta de categorias financeiras.
abstract class CategoriaRepository {
  /// Lista todas as categorias cadastradas para o tipo especificado (receita ou despesa).
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo);

  /// Salva uma nova categoria ou atualiza uma existente.
  Future<Categoria> salvar(Categoria categoria);

  /// Obtém uma categoria pelo seu identificador único.
  Future<Categoria?> obterPorId(String id);

  /// Busca uma categoria pelo nome exato e tipo.
  Future<Categoria?> buscarPorNomeETipo(String nome, TipoTransacao tipo);
}
