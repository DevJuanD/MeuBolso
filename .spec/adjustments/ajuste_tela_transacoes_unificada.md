# Especificação de Ajuste: Tela de Transações Unificada e Menu "Mais"
**Caminho do Arquivo:** `.spec/adjustments/ajuste_tela_transacoes_unificada.md`

## 1. Contexto e Objetivo
Atualmente, a aba "Transações" na barra de navegação inferior está direcionando o usuário para a tela específica de "Minhas Despesas", limitando a ação principal de cadastro apenas para gastos. O objetivo deste ajuste é alinhar a navegação ao requisito original da tela **T03 (Transações)**, transformando-a em uma listagem unificada que engloba tanto receitas quanto despesas, e oferecendo a opção de cadastrar ambos os tipos. As telas isoladas ("Minhas Receitas" e "Minhas Despesas") passarão a ser acessadas exclusivamente através da aba "Mais" (três pontinhos).

## 2. Regras de Negócio e Comportamentos da Interface
- **Aba "Transações" (Listagem Geral):**
  - A tela principal de Transações deve consultar o repositório sem o filtro estrito de tipo, trazendo a listagem combinada de Receitas (valores em verde positivo) e Despesas (valores em vermelho negativo) ordenadas pela data.
  - O topo da tela pode exibir o Saldo do mês ou simplesmente os totais combinados, no lugar do "Total gasto no mês" exclusivo de despesas.
  - **Botão de Adicionar:** O botão flutuante (FAB) ou botão inferior deve ser genérico (ex: `+ ADICIONAR TRANSAÇÃO`). Ao ser clicado, ele deve:
    - Abrir um *Bottom Sheet* perguntando ao usuário se ele deseja adicionar uma **Receita** ou uma **Despesa**.
    - Ou direcionar para o formulário unificado (T04) contendo um seletor de "Tipo" (Receita/Despesa) logo no início.
- **Aba "Mais" (Menu de Opções):**
  - A tela referente ao ícone de reticências (três pontinhos) deve funcionar como um menu de navegação secundária.
  - Incluir duas opções claras em formato de lista (ListTile):
    - **"Minhas Receitas"**: Redireciona para a listagem isolada de receitas (com o botão de adicionar receita).
    - **"Minhas Despesas"**: Redireciona para a listagem isolada de despesas (com o botão de adicionar despesa).

## 3. Estrutura de Arquivos e Modificações

### Camada de Apresentação (`lib/features/transacoes/presentation/`)
1. **`pages/transacoes_page.dart` (Refatoração):**
   - Alterar a consulta do *Controller* para buscar todas as movimentações do mês (sem restringir a despesas).
   - Atualizar a interface para refletir a listagem mista, exibindo corretamente os ícones e as cores de acordo com o `tipo` de cada entidade.
   - Modificar o botão principal para a ação de Adicionar Transação (genérica).
2. **`widgets/modal_tipo_transacao.dart` (Novo - Opcional):**
   - Criar um *Bottom Sheet* simples com duas opções: "Adicionar Receita" e "Adicionar Despesa", que direcionam para os respectivos formulários, caso o formulário unificado não possua a troca de tipo (toggle).
3. **`pages/mais_opcoes_page.dart` (Refatoração):**
   - Construir o menu contendo as opções para navegação via `Navigator.push` para as rotas `/minhas-receitas` e `/minhas-despesas`.

### Camada de Roteamento / Scaffold Principal (`lib/core/navigation/` ou equivalente)
1. **`app_scaffold.dart` / `bottom_navigation`:**
   - Garantir que o índice referente a "Transações" aponte para `TransacoesPage` (unificada) e não para a `ListaDespesasPage`.

## 4. Instruções de Execução para o Agente
1. Remova o vínculo direto da aba "Transações" com a tela de "Minhas Despesas" no controlador do `BottomNavigationBar`.
2. Refatore a tela `transacoes_page.dart` para consumir o `listar_transacoes_usecase.dart` de forma geral.
3. Configure o botão inferior na tela de Transações para permitir o fluxo de cadastro bidirecional (receitas e despesas).
4. Implemente a tela "Mais" contendo a navegação para as *views* específicas que já foram construídas anteriormente.
5. Utilize as cores definidas no `core_ui.md` (`#22C55E` para receitas e `#EF4444` para despesas) para diferenciar visualmente os itens na listagem mista.