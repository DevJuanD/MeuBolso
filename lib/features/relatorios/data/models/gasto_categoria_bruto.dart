/// Agrupamento bruto de despesas por categoria retornado pelo SQLite.
class GastoCategoriaBruto {
  final String categoriaNome;
  final int totalCentavos;

  const GastoCategoriaBruto({
    required this.categoriaNome,
    required this.totalCentavos,
  });
}
