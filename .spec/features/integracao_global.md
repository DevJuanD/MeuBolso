# Especificação de Funcionalidade: Integração Global Front-end e Back-end
**Caminho do Arquivo:** `.spec/features/integracao_global.md`

## 1. Contexto e Objetivo
Conectar todas as telas da camada de Apresentação (T01 a T05) aos Casos de Uso da camada de Domínio e à persistência no SQLite (Camada de Dados). O objetivo é garantir um fluxo reativo, onde as ações do usuário atualizem o banco de dados local e reflitam imediatamente na interface, respeitando a injeção de dependências estrita via construtores.

---

## 2. Regras de Injeção de Dependências e Roteamento
- **Proibição de Service Locators Globais:** É proibido o uso de pacotes como `get_it`. Todas as dependências (DataSources, Repositórios, UseCases e Controllers) devem ser instanciadas na raiz da aplicação (`main.dart` ou em um roteador central) e passadas via construtor para as respectivas telas.
- **Ciclo de Vida do Banco:** O `ServicoBancoDados.instancia` deve ser inicializado antes do `runApp`, garantindo que o SQLite esteja pronto antes da primeira tela ser renderizada.
- **Roteamento:** Configurar o `MaterialApp` com rotas nomeadas (`/login`, `/inicio`, `/transacoes`, `/relatorios`). A passagem de argumentos (ex: transação a ser editada) deve ocorrer pelos parâmetros da rota.

---

## 3. Gerenciamento de Estado (Controladores)
Cada fluxo principal deve possuir um gerenciador de estado (Controller, Cubit, ou ChangeNotifier) reativo.

### 3.1. Autenticação (`autenticacao_controller.dart`)
- **Dependências:** `VerificarPerfilUsecase`, `LoginUsecase`, `CadastrarPerfilUsecase`.
- **Estados:** `Carregando`, `NãoAutenticado` (exibe T01), `Autenticado` (redireciona para T02).
- **Ações:** `inicializar()`, `cadastrar(nome, email, senha)`, `entrar(senha)`.

### 3.2. Transações e Categorias (`transacoes_controller.dart`)
- **Dependências:** `SalvarTransacaoUsecase`, `ExcluirTransacaoUsecase`, `CriarCategoriaUsecase`.
- **Ações:** 
  - `salvarReceita(dto)` e `salvarDespesa(dto)`: Devem capturar o retorno de sucesso e emitir um evento de navegação (`Navigator.pop()`).
  - `criarCategoria(nome, tipo)`: Atualiza a lista de categorias disponíveis no formulário em tempo real.
- **Tratamento Monetário:** O Controller deve receber a `String` formatada da UI (ex: "R$ 1.250,00"), remover a formatação e multiplicar por 100 para passar o `valor_centavos` (inteiro) para o Domínio.

### 3.3. Dashboard e Relatórios (`dashboard_controller.dart` / `relatorio_controller.dart`)
- **Dependências:** Casos de uso de consolidação (Totais, Evolução Mensal, Gastos por Categoria).
- **Ações:** `carregarMes(DateTime mes)` e `aplicarFiltros(FiltroRelatorio)`.
- **Vinculação de UI:** O estado emitido deve converter automaticamente `valor_centavos` para representação decimal formatada via pacote `intl` (`pt_BR`) antes de exibir na T02 e T05.

---

## 4. Vinculação da Interface (UI Binding)
- **T01 (Login/Cadastro):** Vincular os campos de texto aos métodos do `AutenticacaoController`. Desabilitar os botões de submissão enquanto o estado for `Carregando`.
- **T02 (Início):** Envolver a tela em um `Builder` reativo ao `DashboardController`. No `initState`, disparar o carregamento do mês atual. Utilizar `CircularProgressIndicator` nas áreas dos cartões numéricos e gráficos enquanto os dados não retornam do SQLite.
- **T03 e T04 (Listagem e Formulários):** Ao deletar ou salvar uma movimentação, o controller deve instruir o `DashboardController` e o controlador da listagem a buscarem os dados atualizados no banco, garantindo que o saldo e as listas não fiquem defasados.

---

## 5. Instruções de Execução para o Agente
1. Desenvolva as instâncias de injeção de dependência na raiz do projeto (`main.dart`), criando a árvore de repositórios e casos de uso.
2. Implemente os controladores garantindo tratamento de exceções (try/catch) para falhas de persistência, exibindo `SnackBar` com a mensagem de erro apropriada para o usuário.
3. Substitua todos os valores estáticos (mock) nas telas T01 a T05 pelas variáveis observáveis dos controladores.
4. Lembre-se da regra de versionamento: ao realizar os commits destas integrações, os verbos nas mensagens do Git devem estar no infinitivo (ex: *conectar tela de inicio ao sqlite*, *integrar controller de transacoes*).