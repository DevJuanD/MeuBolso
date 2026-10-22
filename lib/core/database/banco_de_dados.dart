import 'package:path/path.dart' as caminho;
import 'package:sqflite/sqflite.dart';

import 'esquema_banco.dart';

/// Ponto de acesso singleton ao banco de dados SQLite do MeuBolso.
class BancoDeDados {
  BancoDeDados._();

  static Database? _instancia;

  /// Retorna a instância aberta do banco, abrindo-a na primeira chamada.
  static Future<Database> obterInstancia() async {
    if (_instancia != null && _instancia!.isOpen) {
      return _instancia!;
    }
    _instancia = await _abrirBanco();
    return _instancia!;
  }

  static Future<Database> _abrirBanco() async {
    final diretorio = await getDatabasesPath();
    final caminhoCompleto = caminho.join(diretorio, EsquemaBanco.nomeArquivo);

    return openDatabase(
      caminhoCompleto,
      version: EsquemaBanco.versaoAtual,
      onCreate: _criarEsquema,
      onUpgrade: _executarMigracoes,
      onConfigure: _configurarPragmas,
    );
  }

  static Future<void> _configurarPragmas(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  static Future<void> _criarEsquema(Database db, int versao) async {
    await _migracaoV1(db);
    if (versao >= 2) {
      await _migracaoV2(db);
    }
  }

  static Future<void> _executarMigracoes(
    Database db,
    int versaoAntiga,
    int versaoNova,
  ) async {
    if (versaoAntiga < 1) await _migracaoV1(db);
    if (versaoAntiga < 2 && versaoNova >= 2) await _migracaoV2(db);
  }

  static Future<void> _migracaoV1(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${EsquemaBanco.tabelaPerfis} (
        ${EsquemaBanco.colPerfilId}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${EsquemaBanco.colPerfilNome}      TEXT    NOT NULL,
        ${EsquemaBanco.colPerfilEmail}     TEXT    NOT NULL UNIQUE,
        ${EsquemaBanco.colPerfilSalt}      TEXT    NOT NULL,
        ${EsquemaBanco.colPerfilCriadoEm}  TEXT    NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${EsquemaBanco.tabelaRecorrencias} (
        ${EsquemaBanco.colRecorrenciaId}                INTEGER PRIMARY KEY AUTOINCREMENT,
        ${EsquemaBanco.colRecorrenciaDescricao}         TEXT    NOT NULL,
        ${EsquemaBanco.colRecorrenciaValorCentavos}     INTEGER NOT NULL CHECK(${EsquemaBanco.colRecorrenciaValorCentavos} > 0),
        ${EsquemaBanco.colRecorrenciaDiaMes}            INTEGER NOT NULL CHECK(${EsquemaBanco.colRecorrenciaDiaMes} BETWEEN 1 AND 31),
        ${EsquemaBanco.colRecorrenciaCompetenciaInicio} TEXT    NOT NULL,
        ${EsquemaBanco.colRecorrenciaAtiva}             INTEGER NOT NULL DEFAULT 1,
        ${EsquemaBanco.colRecorrenciaCriadoEm}          TEXT    NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${EsquemaBanco.tabelaCategorias} (
        ${EsquemaBanco.colCategoriaId}       TEXT    PRIMARY KEY,
        ${EsquemaBanco.colCategoriaNome}     TEXT    NOT NULL,
        ${EsquemaBanco.colCategoriaTipo}     TEXT    NOT NULL CHECK(${EsquemaBanco.colCategoriaTipo} IN ('receita', 'despesa')),
        ${EsquemaBanco.colCategoriaIsPadrao} INTEGER NOT NULL DEFAULT 0,
        UNIQUE (${EsquemaBanco.colCategoriaNome}, ${EsquemaBanco.colCategoriaTipo})
      );
    ''');

    await popularCategoriasPadrao(db);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${EsquemaBanco.tabelaTransacoes} (
        ${EsquemaBanco.colTransacaoId}            INTEGER PRIMARY KEY AUTOINCREMENT,
        ${EsquemaBanco.colTransacaoDescricao}     TEXT    NOT NULL
                                                          CHECK(LENGTH(${EsquemaBanco.colTransacaoDescricao}) BETWEEN 1 AND 80),
        ${EsquemaBanco.colTransacaoValorCentavos} INTEGER NOT NULL CHECK(${EsquemaBanco.colTransacaoValorCentavos} > 0),
        ${EsquemaBanco.colTransacaoTipo}          TEXT    NOT NULL CHECK(${EsquemaBanco.colTransacaoTipo} IN ('receita', 'despesa')),
        ${EsquemaBanco.colTransacaoCategoria}     TEXT    NOT NULL,
        ${EsquemaBanco.colTransacaoCategoriaId}   TEXT REFERENCES ${EsquemaBanco.tabelaCategorias}(${EsquemaBanco.colCategoriaId}),
        ${EsquemaBanco.colTransacaoModalidade}    TEXT    NOT NULL CHECK(${EsquemaBanco.colTransacaoModalidade} IN ('pix', 'debito', 'credito', 'dinheiro')),
        ${EsquemaBanco.colTransacaoDataTransacao} TEXT    NOT NULL,
        ${EsquemaBanco.colTransacaoCompetencia}   TEXT    NOT NULL,
        ${EsquemaBanco.colTransacaoRecorrenciaId} INTEGER REFERENCES ${EsquemaBanco.tabelaRecorrencias}(${EsquemaBanco.colRecorrenciaId}),
        ${EsquemaBanco.colTransacaoExcluidaEm}    TEXT,
        ${EsquemaBanco.colTransacaoCriadoEm}      TEXT    NOT NULL,
        UNIQUE (${EsquemaBanco.colTransacaoRecorrenciaId}, ${EsquemaBanco.colTransacaoCompetencia})
      );
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transacoes_competencia
        ON ${EsquemaBanco.tabelaTransacoes} (
          ${EsquemaBanco.colTransacaoCompetencia},
          ${EsquemaBanco.colTransacaoExcluidaEm}
        );
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transacoes_recorrencia
        ON ${EsquemaBanco.tabelaTransacoes} (
          ${EsquemaBanco.colTransacaoRecorrenciaId}
        );
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transacoes_categoria_id
        ON ${EsquemaBanco.tabelaTransacoes} (
          ${EsquemaBanco.colTransacaoCategoriaId}
        );
    ''');
  }

  static Future<void> _migracaoV2(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${EsquemaBanco.tabelaCategorias} (
        ${EsquemaBanco.colCategoriaId}       TEXT    PRIMARY KEY,
        ${EsquemaBanco.colCategoriaNome}     TEXT    NOT NULL,
        ${EsquemaBanco.colCategoriaTipo}     TEXT    NOT NULL CHECK(${EsquemaBanco.colCategoriaTipo} IN ('receita', 'despesa')),
        ${EsquemaBanco.colCategoriaIsPadrao} INTEGER NOT NULL DEFAULT 0,
        UNIQUE (${EsquemaBanco.colCategoriaNome}, ${EsquemaBanco.colCategoriaTipo})
      );
    ''');

    await popularCategoriasPadrao(db);

    final infoColunas = await db.rawQuery(
      'PRAGMA table_info(${EsquemaBanco.tabelaTransacoes});',
    );
    final possuiColunaCategoriaId = infoColunas.any(
      (coluna) => coluna['name'] == EsquemaBanco.colTransacaoCategoriaId,
    );

    if (!possuiColunaCategoriaId) {
      await db.execute('''
        ALTER TABLE ${EsquemaBanco.tabelaTransacoes}
        ADD COLUMN ${EsquemaBanco.colTransacaoCategoriaId} TEXT REFERENCES ${EsquemaBanco.tabelaCategorias}(${EsquemaBanco.colCategoriaId});
      ''');
    }

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transacoes_categoria_id
        ON ${EsquemaBanco.tabelaTransacoes} (
          ${EsquemaBanco.colTransacaoCategoriaId}
        );
    ''');
  }

  /// Popula as categorias padrão do projeto de forma idempotente.
  static Future<void> popularCategoriasPadrao(DatabaseExecutor db) async {
    const categoriasPadrao = [
      // Receitas padrão
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_salario',
        EsquemaBanco.colCategoriaNome: 'Salário',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_freelance',
        EsquemaBanco.colCategoriaNome: 'Freelance',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_vendas',
        EsquemaBanco.colCategoriaNome: 'Vendas',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_rendimentos',
        EsquemaBanco.colCategoriaNome: 'Rendimentos',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_presente',
        EsquemaBanco.colCategoriaNome: 'Presente',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_receita_outros',
        EsquemaBanco.colCategoriaNome: 'Outros',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      // Despesas padrão
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_alimentacao',
        EsquemaBanco.colCategoriaNome: 'Alimentação',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_transporte',
        EsquemaBanco.colCategoriaNome: 'Transporte',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_moradia',
        EsquemaBanco.colCategoriaNome: 'Moradia',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_contas_e_servicos',
        EsquemaBanco.colCategoriaNome: 'Contas e serviços',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_saude',
        EsquemaBanco.colCategoriaNome: 'Saúde',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_lazer',
        EsquemaBanco.colCategoriaNome: 'Lazer',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_compras',
        EsquemaBanco.colCategoriaNome: 'Compras',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
      {
        EsquemaBanco.colCategoriaId: 'padrao_despesa_outros',
        EsquemaBanco.colCategoriaNome: 'Outros',
        EsquemaBanco.colCategoriaTipo: 'despesa',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      },
    ];

    for (final categoria in categoriasPadrao) {
      await db.insert(
        EsquemaBanco.tabelaCategorias,
        categoria,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}

/// Apelido para manter conformidade com a nomenclatura técnica da especificação.
typedef ServicoBancoDados = BancoDeDados;
