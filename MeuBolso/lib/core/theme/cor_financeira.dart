import 'package:flutter/material.dart';

/// Extensão do tema para as cores semânticas financeiras do MeuBolso.
///
/// Acessível via `CorFinanceira.of(context)`.
class CorFinanceira extends ThemeExtension<CorFinanceira> {
  const CorFinanceira({
    required this.positivo,
    required this.negativo,
  });

  final Color positivo;
  final Color negativo;

  static const Color _verdePadrao = Color(0xFF22C55E);
  static const Color _vermelhoPadrao = Color(0xFFEF4444);

  static const CorFinanceira padrao = CorFinanceira(
    positivo: _verdePadrao,
    negativo: _vermelhoPadrao,
  );

  static CorFinanceira of(BuildContext context) {
    return Theme.of(context).extension<CorFinanceira>() ?? padrao;
  }

  @override
  CorFinanceira copyWith({Color? positivo, Color? negativo}) {
    return CorFinanceira(
      positivo: positivo ?? this.positivo,
      negativo: negativo ?? this.negativo,
    );
  }

  @override
  CorFinanceira lerp(CorFinanceira? other, double t) {
    if (other == null) return this;
    return CorFinanceira(
      positivo: Color.lerp(positivo, other.positivo, t)!,
      negativo: Color.lerp(negativo, other.negativo, t)!,
    );
  }
}
