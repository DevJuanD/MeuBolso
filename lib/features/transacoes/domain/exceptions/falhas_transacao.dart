/// Falhas e exceções de regras de negócio para transações.
sealed class FalhaTransacao implements Exception {
  final String mensagem;
  const FalhaTransacao(this.mensagem);

  @override
  String toString() => mensagem;
}

class ValorInvalidoException extends FalhaTransacao {
  const ValorInvalidoException([
    super.mensagem = 'O valor da transação deve ser maior que zero.',
  ]);
}

class CategoriaObrigatoriaException extends FalhaTransacao {
  const CategoriaObrigatoriaException([
    super.mensagem = 'A categoria ou tipo de receita é obrigatória.',
  ]);
}

class DescricaoInvalidaException extends FalhaTransacao {
  const DescricaoInvalidaException([
    super.mensagem = 'A descrição deve conter no máximo 80 caracteres.',
  ]);
}

class TransacaoNaoEncontradaException extends FalhaTransacao {
  const TransacaoNaoEncontradaException([
    super.mensagem = 'Transação não encontrada para a operação solicitada.',
  ]);
}
