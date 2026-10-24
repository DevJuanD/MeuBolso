import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/enums/tipo_transacao.dart';

part 'filtro_relatorio.freezed.dart';

/// Filtros dinâmicos aceitos pelas consultas de relatórios (T05).
///
/// Todos os parâmetros são opcionais: quando omitidos, a consulta não aplica
/// a restrição correspondente. O período é inclusivo em ambas as datas.
@freezed
abstract class FiltroRelatorio with _$FiltroRelatorio {
  const FiltroRelatorio._();

  const factory FiltroRelatorio({
    DateTime? dataInicial,
    DateTime? dataFinal,
    TipoTransacao? tipo,
    String? categoriaId,
  }) = _FiltroRelatorio;

  /// Indica se há restrição de período parcial ou total.
  bool get possuiFiltroDePeriodo => dataInicial != null || dataFinal != null;

  /// Indica se há qualquer filtro ativo.
  bool get estaVazio =>
      dataInicial == null &&
      dataFinal == null &&
      tipo == null &&
      categoriaId == null;

  /// Verifica se o período informado é válido (inicial menor ou igual à final).
  ///
  /// Retorna `true` quando apenas uma das datas está preenchida, pois não há
  /// como comparar um intervalo incompleto.
  bool get periodoValido {
    if (dataInicial == null || dataFinal == null) return true;
    return !dataInicial!.isAfter(dataFinal!);
  }
}
