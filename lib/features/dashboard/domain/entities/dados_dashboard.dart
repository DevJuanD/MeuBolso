import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../transacoes/domain/entities/transacao.dart';
import 'resumo_mensal.dart';

part 'dados_dashboard.freezed.dart';

/// Resultado agregado consumido pela tela T02: resumo do mês + últimas movimentações.
@freezed
abstract class DadosDashboard with _$DadosDashboard {
  const factory DadosDashboard({
    required ResumoMensal resumo,
    required List<Transacao> ultimasTransacoes,
  }) = _DadosDashboard;
}
