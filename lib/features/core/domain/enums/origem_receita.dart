/// Origens ou tipos predefinidos para transações de receita.
enum OrigemReceita {
  salario,
  freelance,
  vendas,
  rendimentos,
  presente,
  outros;

  String get rotulo {
    switch (this) {
      case OrigemReceita.salario:
        return 'Salário';
      case OrigemReceita.freelance:
        return 'Freelance';
      case OrigemReceita.vendas:
        return 'Vendas';
      case OrigemReceita.rendimentos:
        return 'Rendimentos';
      case OrigemReceita.presente:
        return 'Presente';
      case OrigemReceita.outros:
        return 'Outros';
    }
  }

  static OrigemReceita? deTexto(String valor) {
    for (final item in OrigemReceita.values) {
      if (item.rotulo.toLowerCase() == valor.toLowerCase() ||
          item.name.toLowerCase() == valor.toLowerCase()) {
        return item;
      }
    }
    return null;
  }
}
