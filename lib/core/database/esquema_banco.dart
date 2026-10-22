/// Centraliza os nomes de tabelas e colunas do banco de dados SQLite.
abstract final class EsquemaBanco {
  static const int versaoAtual = 2;
  static const String nomeArquivo = 'meu_bolso.db';

  // categorias
  static const String tabelaCategorias = 'categorias';
  static const String colCategoriaId = 'id';
  static const String colCategoriaNome = 'nome';
  static const String colCategoriaTipo = 'tipo';
  static const String colCategoriaIsPadrao = 'is_padrao';

  // perfis
  static const String tabelaPerfis = 'perfis';
  static const String colPerfilId = 'id';
  static const String colPerfilNome = 'nome';
  static const String colPerfilEmail = 'email';
  static const String colPerfilSalt = 'salt';
  static const String colPerfilCriadoEm = 'criado_em';

  // transacoes
  static const String tabelaTransacoes = 'transacoes';
  static const String colTransacaoId = 'id';
  static const String colTransacaoDescricao = 'descricao';
  static const String colTransacaoValorCentavos = 'valor_centavos';
  static const String colTransacaoTipo = 'tipo';
  static const String colTransacaoCategoria = 'categoria';
  static const String colTransacaoCategoriaId = 'categoria_id';
  static const String colTransacaoModalidade = 'modalidade';
  static const String colTransacaoDataTransacao = 'data_transacao';
  static const String colTransacaoCompetencia = 'competencia';
  static const String colTransacaoRecorrenciaId = 'recorrencia_id';
  static const String colTransacaoExcluidaEm = 'excluida_em';
  static const String colTransacaoCriadoEm = 'criado_em';

  // recorrencias
  static const String tabelaRecorrencias = 'recorrencias';
  static const String colRecorrenciaId = 'id';
  static const String colRecorrenciaDescricao = 'descricao';
  static const String colRecorrenciaValorCentavos = 'valor_centavos';
  static const String colRecorrenciaDiaMes = 'dia_mes';
  static const String colRecorrenciaCompetenciaInicio = 'competencia_inicio';
  static const String colRecorrenciaAtiva = 'ativa';
  static const String colRecorrenciaCriadoEm = 'criado_em';

  /// Chave do verificador de senha no flutter_secure_storage.
  static const String chaveVerificadorSenha = 'verificador_senha';
}
