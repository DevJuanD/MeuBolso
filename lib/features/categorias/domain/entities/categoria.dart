import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/enums/tipo_transacao.dart';

part 'categoria.freezed.dart';

/// Entidade de domínio pura que representa uma categoria financeira customizável.
@freezed
abstract class Categoria with _$Categoria {
  const Categoria._();

  const factory Categoria({
    required String id,
    required String nome,
    required TipoTransacao tipo,
    @Default(false) bool isPadrao,
  }) = _Categoria;
}
