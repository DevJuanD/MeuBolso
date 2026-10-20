/// Modalidade de pagamento utilizada na transação.
enum ModalidadePagamento {
  pix,
  debito,
  credito,
  dinheiro;

  String get valorBanco => name;

  String get rotulo {
    switch (this) {
      case ModalidadePagamento.pix:
        return 'Pix';
      case ModalidadePagamento.debito:
        return 'Débito';
      case ModalidadePagamento.credito:
        return 'Crédito';
      case ModalidadePagamento.dinheiro:
        return 'Dinheiro';
    }
  }

  static ModalidadePagamento deTexto(String valor) {
    return ModalidadePagamento.values.firstWhere(
      (e) => e.name == valor.toLowerCase(),
      orElse: () => ModalidadePagamento.pix,
    );
  }
}
