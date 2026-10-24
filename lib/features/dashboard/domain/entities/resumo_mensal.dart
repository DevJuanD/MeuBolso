import 'package:freezed_annotation/freezed_annotation.dart';

part 'resumo_mensal.freezed.dart';

/// Agregação financeira do mês de referência que alimenta a tela T02.
/// Valores em centavos; variações percentuais em relação ao mês anterior.
@freezed
abstract class ResumoMensal with _$ResumoMensal {
  const factory ResumoMensal({
    required DateTime mesAtual,
    required int totalReceitas,
    required int totalDespesas,
    required int saldo,
    required double variacaoSaldo,
    required double variacaoReceitas,
    required double variacaoDespesas,
  }) = _ResumoMensal;
}
