import 'package:freezed_annotation/freezed_annotation.dart';

part 'evolucao_mensal.freezed.dart';

/// Receitas e despesas de um mês, usadas no gráfico de evolução temporal.
///
/// [competencia] está no formato AAAA-MM.
@freezed
abstract class EvolucaoMensal with _$EvolucaoMensal {
  const factory EvolucaoMensal({
    required String competencia,
    required int totalReceitas,
    required int totalDespesas,
  }) = _EvolucaoMensal;
}
