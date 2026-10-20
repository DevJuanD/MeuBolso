import '../entities/transacao.dart';
import '../exceptions/falhas_transacao.dart';
import '../repositories/transacoes_repository.dart';

/// Caso de uso para obter uma transação específica pelo identificador.
class ObterTransacaoPorIdUseCase {
  final TransacoesRepository _repositorio;

  const ObterTransacaoPorIdUseCase(this._repositorio);

  Future<Transacao> call(int id) async {
    if (id <= 0) {
      throw const TransacaoNaoEncontradaException();
    }
    final transacao = await _repositorio.obterTransacaoPorId(id);
    if (transacao == null) {
      throw const TransacaoNaoEncontradaException();
    }
    return transacao;
  }
}
