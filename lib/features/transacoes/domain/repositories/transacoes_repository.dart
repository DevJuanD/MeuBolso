import '../../../core/domain/enums/tipo_transacao.dart';
import '../entities/transacao.dart';

/// Contrato para operações de repositório de transações financeiras.
abstract class TransacoesRepository {
  /// Salva ou atualiza uma transação.
  Future<Transacao> salvarTransacao(Transacao transacao);

  /// Lista transações com filtros opcionais de tipo, competência e exclusão lógica.
  Future<List<Transacao>> listarTransacoes({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  });

  /// Realiza a exclusão lógica de uma transação pelo id.
  Future<void> excluirTransacao(int id);

  /// Restaura uma transação excluída logicamente (desfazer).
  Future<void> restaurarTransacao(int id);

  /// Busca uma transação específica pelo id.
  Future<Transacao?> obterTransacaoPorId(int id);
}
