/// Falhas e exceções de regras de negócio para relatórios.
sealed class FalhaRelatorio implements Exception {
  final String mensagem;
  const FalhaRelatorio(this.mensagem);

  @override
  String toString() => mensagem;
}

/// Lançada quando a data inicial do filtro é posterior à data final.
class PeriodoInvalidoException extends FalhaRelatorio {
  const PeriodoInvalidoException([
    super.mensagem = 'A data inicial não pode ser posterior à data final.',
  ]);
}
