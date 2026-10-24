/// Totais em centavos de um mês calculados diretamente no SQL.
class TotaisDoMes {
  final int receitasCentavos;
  final int despesasCentavos;

  const TotaisDoMes({
    required this.receitasCentavos,
    required this.despesasCentavos,
  });

  int get saldoCentavos => receitasCentavos - despesasCentavos;
}
