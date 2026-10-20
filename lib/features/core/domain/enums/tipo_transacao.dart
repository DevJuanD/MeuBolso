/// Define a natureza financeira da transação (entrada ou saída).
enum TipoTransacao {
  receita,
  despesa;

  bool get isReceita => this == TipoTransacao.receita;
  bool get isDespesa => this == TipoTransacao.despesa;

  String get valorBanco => name;

  static TipoTransacao deTexto(String valor) {
    return TipoTransacao.values.firstWhere(
      (e) => e.name == valor.toLowerCase(),
      orElse: () => TipoTransacao.receita,
    );
  }
}
