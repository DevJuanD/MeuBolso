/// Categorias predefinidas para transações de despesa.
enum CategoriaDespesa {
  alimentacao,
  transporte,
  moradia,
  contas,
  saude,
  lazer,
  outros;

  String get rotulo {
    switch (this) {
      case CategoriaDespesa.alimentacao:
        return 'Alimentação';
      case CategoriaDespesa.transporte:
        return 'Transporte';
      case CategoriaDespesa.moradia:
        return 'Moradia';
      case CategoriaDespesa.contas:
        return 'Contas';
      case CategoriaDespesa.saude:
        return 'Saúde';
      case CategoriaDespesa.lazer:
        return 'Lazer';
      case CategoriaDespesa.outros:
        return 'Outros';
    }
  }

  static CategoriaDespesa? deTexto(String valor) {
    for (final item in CategoriaDespesa.values) {
      if (item.rotulo.toLowerCase() == valor.toLowerCase() ||
          item.name.toLowerCase() == valor.toLowerCase()) {
        return item;
      }
    }
    return null;
  }
}
