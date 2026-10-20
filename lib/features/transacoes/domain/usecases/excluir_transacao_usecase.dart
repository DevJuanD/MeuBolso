import '../exceptions/falhas_transacao.dart';
import '../repositories/transacoes_repository.dart';

/// Caso de uso para exclusão lógica de uma transação pelo identificador.
class ExcluirTransacaoUseCase {
  final TransacoesRepository _repositorio;

  const ExcluirTransacaoUseCase(this._repositorio);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw const TransacaoNaoEncontradaException();
    }
    await _repositorio.excluirTransacao(id);
  }
}
