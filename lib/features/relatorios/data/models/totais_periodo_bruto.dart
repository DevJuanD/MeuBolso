/// Totais brutos de um período retornados pelo SQLite, em centavos.
class TotaisPeriodoBruto {
  final int totalReceitas;
  final int totalDespesas;

  const TotaisPeriodoBruto({
    required this.totalReceitas,
    required this.totalDespesas,
  });
}
