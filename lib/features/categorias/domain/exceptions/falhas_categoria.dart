/// Falhas e exceções de regras de negócio para categorias financeiras.
sealed class FalhaCategoria implements Exception {
  final String mensagem;
  const FalhaCategoria(this.mensagem);

  @override
  String toString() => mensagem;
}

class NomeCategoriaInvalidoException extends FalhaCategoria {
  const NomeCategoriaInvalidoException([
    super.mensagem = 'O nome da categoria não pode ser vazio.',
  ]);
}

class CategoriaDuplicadaException extends FalhaCategoria {
  const CategoriaDuplicadaException([
    super.mensagem = 'Já existe uma categoria cadastrada com este nome e tipo.',
  ]);
}

class CategoriaNaoEncontradaException extends FalhaCategoria {
  const CategoriaNaoEncontradaException([
    super.mensagem = 'Categoria não encontrada para a operação solicitada.',
  ]);
}
