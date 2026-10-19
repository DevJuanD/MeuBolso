# Especificação de Funcionalidade: Estrutura Base de Dados (SQLite)

## 1. Contexto e Objetivo

Implementar a base do banco de dados local utilizando `sqflite` e estabelecer os `Enums` de domínio que serão utilizados em todo o aplicativo. Esta base é vital para o funcionamento offline e persistência das `transacoes` e `recorrencias`, seguindo as regras de negócio de arquitetura e armazenamento seguro.

## 2. Regras de Negócio e Restrições (MeuBolso Core)

- **Idioma:** Todo o código (variáveis, métodos, classes) em português (`pt_BR`).
- **Valores Monetários (RN01):** Colunas no banco devem ser `INTEGER` e nomeadas como `valor_centavos`.
- **Exclusão Lógica (RN09):** O banco deve ter a coluna `excluida_em` (TEXT) em transações. NUNCA utilizar `DELETE` físico em transações na aplicação.
- **Relacionamentos e Unicidade (RN08):** Garantir que a tabela de transações tenha `FOREIGN KEY` para recorrências (com `ON DELETE CASCADE`) e restrição `UNIQUE(recorrencia_id, competencia)` para evitar duplicidade de salários mensais.
- **Enums Nativos:** Categorias, tipos, origens e modalidades não terão tabelas no banco de dados. Serão salvos como `TEXT` no SQLite e mapeados para `Enums` no Dart.

## 3. Estrutura de Arquivos Esperada

Crie os seguintes arquivos:

### Enums de Domínio (`lib/features/core/domain/enums/`)

1. **`tipo_transacao.dart`**: `enum TipoTransacao { receita, despesa }`
2. **`categoria_despesa.dart`**: `enum CategoriaDespesa { alimentacao, transporte, moradia, contas, saude, lazer, outros }`
3. **`origem_receita.dart`**: `enum OrigemReceita { venda, presente, salario, servico_avulso }`
4. **`modalidade_pagamento.dart`**: `enum ModalidadePagamento { dinheiro, pix, cartao_credito, cartao_debito }`

### Camada de Dados - Banco Local (`lib/features/core/data/database/`)

1. **`servico_banco_dados.dart`**:
   - Classe `ServicoBancoDados` utilizando o padrão Singleton (construtor privado).
   - Nome do banco: `meubolso.db`, versão: `1`.
   - Método `_configurarBanco` com execução de `PRAGMA foreign_keys = ON;`.
   - Método `_criarTabelas` com as seguintes tabelas via raw SQL (`db.execute`):

   **Tabela: recorrencias**
   - `id` (TEXT PRIMARY KEY)
   - `descricao` (TEXT NOT NULL)
   - `valor_centavos` (INTEGER NOT NULL)
   - `modalidade` (TEXT NOT NULL)
   - `dia_mes` (INTEGER NOT NULL CHECK(dia_mes >= 1 AND dia_mes <= 31))
   - `competencia_inicio` (TEXT NOT NULL)
   - `ativa` (INTEGER NOT NULL DEFAULT 1)
   - `criado_em` (TEXT NOT NULL)
   - `atualizado_em` (TEXT NOT NULL)

   **Tabela: transacoes**
   - `id` (TEXT PRIMARY KEY)
   - `recorrencia_id` (TEXT)
   - `descricao` (TEXT NOT NULL)
   - `valor_centavos` (INTEGER NOT NULL)
   - `tipo` (TEXT NOT NULL)
   - `categoria` (TEXT)
   - `origem` (TEXT)
   - `modalidade` (TEXT NOT NULL)
   - `data` (TEXT NOT NULL)
   - `competencia` (TEXT)
   - `excluida_em` (TEXT)
   - `criado_em` (TEXT NOT NULL)
   - `atualizado_em` (TEXT NOT NULL)
   - Constraints: `FOREIGN KEY (recorrencia_id) REFERENCES recorrencias (id) ON DELETE CASCADE` e `UNIQUE(recorrencia_id, competencia)`.

   **Índices:**
   - Criar índices (INDEX) nas tabelas transacoes (`data`, `tipo`, `competencia`) e recorrencias (`ativa`) para otimizar queries futuras.

## 4. Instruções de Execução para o Agente

1. Crie todos os Enums solicitados na pasta `lib/features/core/domain/enums/`.
2. Adicione as dependências `sqflite` e `path` no `pubspec.yaml` (se ainda não existirem).
3. Crie a classe `ServicoBancoDados` exatamente como descrito, garantindo a sintaxe SQL correta com as constraints exigidas.
4. Certifique-se de não adicionar bibliotecas de UI (como `material.dart`) no serviço de banco de dados.
