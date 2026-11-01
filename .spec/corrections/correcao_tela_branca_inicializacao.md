# Especificação de Correção: Erro Crítico de Tela Branca na Inicialização
**Caminho do Arquivo:** `.spec/corrections/correcao_tela_branca_inicializacao.md`

## 1. Contexto e Diagnóstico do Problema
Após a implementação da funcionalidade "Gerenciamento de Categorias e Ícones", a compilação do aplicativo (APK) resultou em uma "tela branca" (White Screen of Death) contínua, não carregando a interface. 

**Causa Mais Provável:** Este erro em Flutter, especialmente ao abrir o app pela primeira vez após uma alteração estrutural, geralmente indica uma **exceção não tratada antes ou durante o `runApp()`**. Como a última *task* exigiu a adição da coluna `icone_id` na tabela `categorias`, se o banco de dados já existia no aparelho do usuário (ou emulador), o SQLite lançou um erro de *Schema/Column not found* ao tentar ler ou inserir os dados, travando a inicialização.

## 2. Objetivos de Correção
O Agente deve inspecionar e corrigir o fluxo de inicialização assíncrona (`main.dart`) e a estratégia de migração do banco de dados local para garantir que o aplicativo inicie em qualquer cenário.

## 3. Plano de Ação e Modificações

### A. Correção da Migração do Banco de Dados (`servico_banco_dados.dart`)
O agente deve verificar a versão do banco de dados e implementar o método de migração:
1. **Aumentar a Versão:** Incrementar o número da versão do banco de dados no método `openDatabase` (ex: de `1` para `2`).
2. **Implementar `onUpgrade`:** Adicionar o parâmetro `onUpgrade` e escrever a lógica para adicionar a nova coluna sem deletar os dados antigos.
   - *Exemplo SQL:* `ALTER TABLE categorias ADD COLUMN icone_id TEXT DEFAULT 'default';`
3. **Fallback Seguro:** Caso o projeto ainda esteja em fase embrionária e não necessite guardar dados de teste, o agente pode (opcionalmente) configurar o `onUpgrade` para realizar um `DROP TABLE` e recriar o banco inteiro, garantindo que o esquema suba perfeitamente.

### B. Tratamento de Exceções na Inicialização (`main.dart` e Controladores)
1. **Try-Catch Global:** Envolver os processos assíncronos que rodam antes do `runApp` (como inicialização do SQLite ou do Storage) em um bloco `try-catch`.
2. **Tratamento no FutureBuilder/Estado Raiz:** Se o app usa um `FutureBuilder` ou escuta um estado inicial para mostrar uma tela de "Splash/Carregamento" enquanto o banco conecta, certifique-se de que a condição de falha (`snapshot.hasError` ou estado `Erro`) retorne uma UI visível (um `MaterialApp` com um `Scaffold` exibindo a mensagem de erro) em vez de retornar `null` ou um `Container` vazio, que causa a tela branca.

### C. Verificação de Dependências e Assets
1. **Ícones Nativos:** A última *task* envolveu `IconData`. Garantir que nenhum ícone inválido esteja sendo mapeado.
2. **Widgets Binding:** Assegurar que `WidgetsFlutterBinding.ensureInitialized();` seja a primeiríssima linha do método `main()`, antes de qualquer chamada assíncrona.

## 4. Instruções de Execução para o Agente
1. **Inspecione o método `main()`:** Verifique se há código assíncrono falhando silenciosamente. Garanta o uso de `WidgetsFlutterBinding.ensureInitialized()`.
2. **Atualize o SQLite (`sqflite`):** Resolva o conflito do esquema atualizando a versão do banco e criando a instrução de migração (`onUpgrade`) para a coluna `icone_id` e a tabela `categorias`.
3. **Adicione UI de Falha:** Implemente um fallback visual na tela de inicialização (Splash) caso os serviços locais falhem ao conectar, permitindo que o desenvolvedor/usuário leia o erro na tela (ex: "Falha ao iniciar o banco de dados").
4. Se o problema persistir após o ajuste do banco, aplique *logs* (`debugPrint` ou `log` do pacote `dart:developer`) em cada etapa do `main` para identificar o ponto exato da quebra no terminal (Logcat).