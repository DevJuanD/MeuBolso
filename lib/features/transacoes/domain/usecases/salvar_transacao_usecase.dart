import '../entities/transacao.dart';
import '../exceptions/falhas_transacao.dart';
import '../repositories/transacoes_repository.dart';

/// Caso de uso para validação e persistência (criação ou edição) de transações.
class SalvarTransacaoUseCase {
  final TransacoesRepository _repositorio;

  const SalvarTransacaoUseCase(this._repositorio);

  Future<Transacao> call(Transacao transacao) async {
    if (transacao.valorCentavos <= 0) {
      throw const ValorInvalidoException();
    }

    final categoriaLimpa = transacao.categoria.trim();
    if (categoriaLimpa.isEmpty) {
      throw const CategoriaObrigatoriaException();
    }

    final descricaoLimpa = transacao.descricao.trim().isEmpty
        ? categoriaLimpa
        : transacao.descricao.trim();

    if (descricaoLimpa.length > 80) {
      throw const DescricaoInvalidaException();
    }

    final mesFormatado = transacao.data.month.toString().padLeft(2, '0');
    final competenciaCalculada = transacao.competencia.isNotEmpty
        ? transacao.competencia
        : '${transacao.data.year}-$mesFormatado';

    final transacaoPronta = transacao.copyWith(
      descricao: descricaoLimpa,
      categoria: categoriaLimpa,
      competencia: competenciaCalculada,
    );

    return _repositorio.salvarTransacao(transacaoPronta);
  }
}
