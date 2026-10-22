import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/enums/modalidade_pagamento.dart';
import '../../../core/domain/enums/tipo_transacao.dart';

part 'transacao.freezed.dart';

/// Entidade de domínio pura que representa uma transação (receita ou despesa).
@freezed
abstract class Transacao with _$Transacao {
  const Transacao._();

  const factory Transacao({
    int? id,
    required String descricao,
    required int valorCentavos,
    required TipoTransacao tipo,
    required String categoria,
    String? categoriaId,
    @Default(ModalidadePagamento.pix) ModalidadePagamento modalidade,
    required DateTime data,
    required String competencia,
    int? recorrenciaId,
    DateTime? excluidaEm,
    required DateTime criadoEm,
  }) = _Transacao;

  bool get isExcluida => excluidaEm != null;
  bool get isReceita => tipo.isReceita;
  bool get isDespesa => tipo.isDespesa;
}
