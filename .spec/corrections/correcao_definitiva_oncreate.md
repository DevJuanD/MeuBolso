# Especificação de Correção Definitiva: Schema de Categorias no onCreate
**Caminho do Arquivo:** `.spec/corrections/correcao_definitiva_oncreate.md`

## 1. Avaliação do Estado Atual
A infraestrutura de tratamento de erros na inicialização (`main.dart`, `app.dart`, `dependencias_app.dart`) foi implementada com excelência. A captura da exceção funcionou perfeitamente e renderizou a `_TelaErroInicializacao`, evitando a "tela branca". A lógica de migração (`_migracaoV3`) também está correta para usuários com bancos existentes.

## 2. Diagnóstico da Causa Raiz (Crash em Instalação Limpa)
O erro exibido (`table categorias has no column named icone_id`) está ocorrendo em **instalações limpas** (quando o app é desinstalado e reinstalado). 
Neste cenário, o SQLite não passa pelo `onUpgrade` (onde a migração V3 atua), mas sim pelo `onCreate`. O erro acontece porque a string SQL de `CREATE TABLE categorias` dentro do `onCreate` está defasada e não possui a coluna `icone_id`. Quando o sistema tenta fazer o *seed* (inserir as categorias padrão) logo em seguida, o banco quebra.

## 3. Instruções de Execução para o Agente
1. Acesse o arquivo de gerenciamento do banco de dados (ex: `banco_de_dados.dart` ou `servico_banco_dados.dart`).
2. Localize o método `onCreate` (ou a função que inicializa as tabelas do zero).
3. Inspecione a instrução SQL responsável por criar a tabela `categorias`.
4. Atualize a instrução adicionando a coluna `icone_id`. Exemplo do resultado final esperado:
   ```sql
   CREATE TABLE categorias (
     id TEXT PRIMARY KEY,
     nome TEXT NOT NULL,
     tipo TEXT NOT NULL,
     is_padrao INTEGER DEFAULT 0,
     icone_id TEXT DEFAULT 'default' -- Coluna adicionada aqui
   )