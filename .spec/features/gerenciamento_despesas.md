# Especificação de Funcionalidade: Cadastro e Gerenciamento de Despesas (Adequação Visual)
**Caminho do Arquivo:** `.spec/features/gerenciamento_despesas.md`

## 1. Contexto e Objetivo
Implementar o fluxo completo de cadastro, edição, exclusão e consulta de **Despesas** em total conformidade com as telas de alta fidelidade do projeto. Esta especificação une as regras de negócio de saídas financeiras às telas estruturais do aplicativo (`T03 Transações` e `T04 Nova transação e edição`), garantindo que o agente de IA construa componentes visuais idênticos ao design aprovado.

---

## 2. Regras de Negócio e Comportamentos (MeuBolso Core)
- **Representação Monetária (RN01):** Os valores devem ser salvos em inteiros (`valorCentavos`) e exibidos formatados em Reais (`R$`) via pacote `intl` para `pt_BR`. Despesas são exibidas com valor negativo ou destaque semântico.
- **Cores Semânticas (`core_ui.md`):** Despesas e saídas financeiras utilizam obrigatoriamente a cor **Vermelha (`#EF4444`)** ou a cor primária de destaque em cartões (`#7C3AED` para cards de saldo/totais do topo).
- **Campos Obrigatórios:** Valor, Data e **Tipo/Categoria** da despesa (Alimentação, Transporte, Moradia, Contas, Saúde, Lazer, Outros ou tipos customizados). A descrição é opcional (assumindo a categoria se não informada, com limite máximo de 80 caracteres).
- **Exclusão Lógica (RN09):** A exclusão remove o item dos cálculos e listagens ativas sem apagá-lo fisicamente da tabela base (preenchendo `excluida_em`), permitindo a funcionalidade de desfazer exclusão via notificação (SnackBar).

---

## 3. Mapeamento de Telas Correspondentes (Conforme PDF do Sistema)

### A. Listagem de Despesas (`Minhas despesas` / Tela T03)
*   **Visual do Topo:** Card estilizado com a cor primária (`#7C3AED`) exibindo o título *"Total gasto no mês"* em destaque (ex: `R$ 1.850,00`) e um ícone de saída/upload no canto superior direito.
*   **Lista de Movimentações:** Cada item exibe o ícone correspondente à categoria da despesa, a descrição/nome (ex: *Supermercado*, *Transporte*), a data abreviada (ex: `12 out.`) alinhada à esquerda e o valor em vermelho à direita (ex: `-R$ 150,00`).
*   **Ações na Lista:** Opções contextuais de cada item para **Editar despesa** ou **Excluir despesa** (com destaque visual em tom negativo/vermelho).
*   **Navegação e Botão de Ação:** 
    *   Link/atalho para *"Ver todas as despesas"*.
    *   Botão fixo ou de destaque com o texto `+ Adicionar despesa`.

### B. Formulário de Cadastro e Edição (`Adicionar despesa` / `Editar despesa` / Tela T04)
*   **Cabeçalho:** Botão de navegação para voltar (`<`), título principal (*"Adicionar despesa"* ou *"Editar despesa"*) e subtítulo informativo (*"Registre um gasto"* ou *"Atualize os dados da despesa"*).
*   **Campo de Valor:** Campo numérico de destaque para o "Valor da despesa" (ex: `R$ 0,00`), com formatação dinâmica e conversão para centavos.
*   **Seleção de Tipo/Categoria:** 
    *   Opções predefinidas da regra de negócio: *Alimentação, Transporte, Moradia, Contas, Saúde, Lazer, Outros*.
    *   Ação de criação dinâmica **`+ Criar novo tipo`**, abrindo diálogo/modal para inclusão de categoria personalizada (ex: *Educação*).
*   **Campos Complementares:** 
    *   *Descrição (opcional)* com placeholder explicativo (ex: *"Ex.: compra no supermercado"*).
    *   *Data da despesa* com seletor de calendário formatado no padrão nacional `dd/MM/aaaa`.
*   **Botões de Submissão:** Botão primário na parte inferior com rótulo `Salvar despesa` (para novas entradas) ou `SALVAR ALTERAÇÕES` (em modo edição).

### C. Diálogo de Exclusão (`Excluir despesa?` - Modal)
*   **Layout:** Diálogo centralizado (Pop-up/Modal).
*   **Mensagem:** *"Tem certeza de que deseja excluir esta despesa?"*.
*   **Botões:** Ação secundária `Cancelar` e ação destrutiva `Excluir` destacada na cor vermelha (`#EF4444`).

---

## 4. Estrutura de Arquivos Esperada

Crie ou atualize os arquivos na seguinte estrutura:

### Camada de Domínio e Dados (`lib/features/transacoes/`)
1. Garantir que o repositório e Casos de Uso suportem consultas e persistência com `TipoTransacao.despesa`.
2. Assegurar integridade dos dados (valores estritamente positivos em centavos, categoria obrigatória e preenchimento de `excluida_em` na exclusão lógica).

### Camada de Apresentação (`lib/features/financas/presentation/` ou módulo dedicado)
1. **`pages/despesas_page.dart`**: Tela de listagem baseada na UI *"Minhas despesas"*.
2. **`pages/despesa_form_page.dart`**: Formulário unificado de cadastro e edição de despesas com criação de categorias dinâmicas.
3. Diálogo de confirmação de exclusão com ação de desfazer via SnackBar.

---

## 5. Instruções de Execução para o Agente
1. Respeite com precisão a paleta semântica (`#7C3AED` primária, `#EF4444` para despesas e ações destrutivas, `#22C55E` para receitas).
2. Assegure a formatação correta de moeda (`R$`) e datas (`dd/MM/aaaa`), preservando o idioma Português (`pt_BR`) em todos os nomes de métodos, variáveis e mensagens do sistema.
3. Garanta que o fluxo de salvamento e edição valide que o valor seja superior a zero e que a categoria esteja definida antes de persistir.
