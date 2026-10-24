import 'package:freezed_annotation/freezed_annotation.dart';

part 'totais_periodo.freezed.dart';

/// Totais financeiros agregados de um período, em centavos.
@freezed
abstract class TotaisPeriodo with _$TotaisPeriodo {
  const factory TotaisPeriodo({
    required int totalReceitas,
    required int totalDespesas,
    required int saldo,
  }) = _TotaisPeriodo;
}
