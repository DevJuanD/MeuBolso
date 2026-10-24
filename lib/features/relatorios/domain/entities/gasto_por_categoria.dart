import 'package:freezed_annotation/freezed_annotation.dart';

part 'gasto_por_categoria.freezed.dart';

/// Total de despesas de uma categoria no período consultado.
///
/// [percentual] representa a participação da categoria no total de despesas
/// (de 0 a 100) e é calculado na camada de dados.
@freezed
abstract class GastoPorCategoria with _$GastoPorCategoria {
  const factory GastoPorCategoria({
    required String categoriaNome,
    required int totalCentavos,
    required double percentual,
  }) = _GastoPorCategoria;
}
