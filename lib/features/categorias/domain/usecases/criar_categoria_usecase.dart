import '../../../core/domain/enums/tipo_transacao.dart';
import '../entities/categoria.dart';
import '../exceptions/falhas_categoria.dart';
import '../repositories/categoria_repository.dart';

/// Caso de uso para cadastrar uma nova categoria customizada pelo usuário.
class CriarCategoriaUseCase {
  final CategoriaRepository _repositorio;

  const CriarCategoriaUseCase(this._repositorio);

  Future<Categoria> call({
    required String nome,
    required TipoTransacao tipo,
  }) async {
    final nomeLimpo = nome.trim();
    if (nomeLimpo.isEmpty) {
      throw const NomeCategoriaInvalidoException();
    }

    final nomeFormatado = _capitalizarPrimeiraLetra(nomeLimpo);

    final existentes = await _repositorio.listarPorTipo(tipo);
    final jaExiste = existentes.any(
      (c) => c.nome.trim().toLowerCase() == nomeFormatado.toLowerCase(),
    );

    if (jaExiste) {
      throw const CategoriaDuplicadaException();
    }

    final id = 'cat_${tipo.name}_${DateTime.now().microsecondsSinceEpoch}';
    final novaCategoria = Categoria(
      id: id,
      nome: nomeFormatado,
      tipo: tipo,
      isPadrao: false,
    );

    return _repositorio.salvar(novaCategoria);
  }

  static String _capitalizarPrimeiraLetra(String texto) {
    if (texto.isEmpty) return texto;
    if (texto.length == 1) return texto.toUpperCase();
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}
