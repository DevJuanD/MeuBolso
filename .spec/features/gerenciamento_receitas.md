# Especificação de Funcionalidade: Cadastro e Gerenciamento de Receitas (Adequação Visual)
**Caminho do Arquivo:** `.spec/features/gerenciamento_receitas.md`

## 1. Contexto e Objetivo
Implementar o fluxo completo de cadastro, edição, exclusão e consulta de **Receitas** em total conformidade com as telas de alta fidelidade do projeto. Esta especificação une as regras de negócio de entradas financeiras às telas estruturais do aplicativo (`T03 Transações` e `T04 Nova transação e edição`), garantindo que o agente de IA construa componentes visuais idênticos ao design aprovado.

---

## 2. Regras de Negócio e Comportamentos (MeuBolso Core)
- **Representação Monetária (RN01):** Os valores devem ser salvos em inteiros (`valorCentavos`) e exibidos formatados em Reais (`R$`) via pacote `intl` para `pt_BR`[cite: 1, 4].
- **Cores Semânticas (`core_ui.md`):** Receitas e totais positivos utilizam obrigatoriamente a cor **Verde (`#22C55E`)** ou a cor primária de destaque em cartões[cite: 13].
- **Campos Obrigatórios:** Valor, Data, Descrição e **Tipo/Origem** da receita (Salário, Freelance, Vendas, Rendimentos, Presente, Outros ou tipos customizados)[cite: 20].
- **Exclusão Lógica (RN09):** A exclusão remove o item dos cálculos e listagens ativas sem apagá-lo fisicamente da tabela base (preenchendo `excluida_em`)[cite: 5].

---

## 3. Mapeamento de Telas Correspondentes (Conforme PDF do Sistema)

### A. Listagem de Receitas (`Minhas receitas` / Tela T03)
*   **Visual do Topo:** Card estilizado com a cor primária (`#7C3AED`) exibindo o título *"Total recebido no mês"* em destaque (ex: `R$ 3.250,00`) e um ícone de atalho/download no canto superior direito[cite: 18, 24].
*   **Lista de Movimentações:** Cada item exibe o ícone do tipo de receita, a descrição/nome (ex: *Salário*, *Freelance*), a data abreviada (ex: `05 out.`) alinhada à esquerda e o valor em verde à direita (ex: `R$ 2.500,00`)[cite: 18].
*   **Ações na Lista:** Tocar em um item abre as opções rápidas ou a tela de detalhes para **Editar receita** ou **Excluir receita**[cite: 24, 26].
*   **Botão de Ação:** Botão fixo na parte inferior com o texto `+ ADICIONAR RECEITA`[cite: 24].

### B. Formulário de Cadastro e Edição (`Adicionar receita` / `Editar receita` / Tela T04)
*   **Cabeçalho:** Botão de voltar (`<`) seguido do título *"Adicionar receita"* ou *"Editar receita"* e a descrição de apoio *"Registre o dinheiro que entrou"*[cite: 19, 25].
*   **Campo de Valor:** Campo numérico de destaque para o "Valor recebido" (ex: `R$ 0,00`), formatado em tempo real[cite: 19].
*   **Seleção de Tipo/Origem:** 
    *   Exibe os chips ou a lista de opções predefinidas: *Salário, Freelance, Vendas, Rendimentos, Presente, Outros*[cite: 20].
    *   Inclui a opção interativa **`+ Criar novo tipo`**, que abre um modal ou campo dedicado para inserir um novo nome de categoria/origem customizada (ex: *Consultoria*)[cite: 21, 22].
*   **Campos Complementares:** 
    *   *Descrição (opcional)* com placeholder (ex: *"Ex.: salário do mês"* ou *"Consultoria de projeto"*)[cite: 19, 22].
    *   *Data do recebimento* com seletor de calendário formatado como `dd/MM/aaaa`[cite: 19].
*   **Botões de Submissão:** Botão primário inferior com texto `Salvar receita` ou `SALVAR ALTERAÇÕES`[cite: 19, 25].

### C. Diálogo de Exclusão (`Excluir receita?` - Modal)
*   **Layout:** Diálogo centralizado (Pop-up).
*   **Mensagem:** *"Tem certeza de que deseja excluir esta receita?"*[cite: 26].
*   **Botões:** Ações de `Cancelar` (secundário) e `Excluir` (com cor vermelha de destaque para indicar ação destrutiva)[cite: 26].

---

## 4. Estrutura de Arquivos Esperada

Crie ou atualize os arquivos na seguinte estrutura:

### Camada de Domínio e Dados (`lib/features/transacoes/`)
1. Garantir que o repositório suporte filtragem por `TipoTransacao.receita`.
2. Assegurar que os Casos de Uso (`salvar`, `listar`, `excluir`) validem e persistam corretamente os dados mapeados.

### Camada de Apresentação (`lib/features/receitas/presentation/`)
1. **`pages/lista_receitas_page.dart`**: Tela de listagem baseada na UI *"Minhas receitas"*[cite: 18].
2. **`pages/form_receita_page.dart`**: Tela unificada para Adicionar e Editar, contendo o fluxo de criação de novos tipos dinâmicos[cite: 19, 21].
3. **`widgets/modal_exclusao_receita.dart`**: Diálogo de confirmação de exclusão[cite: 26].

---

## 5. Instruções de Execução para o Agente
1. Desenvolva as telas respeitando rigorosamente os textos, rótulos e espaçamentos descritos nas telas do sistema do projeto.
2. Utilize o `Theme.of(context)` em conjunto com as cores do `core_ui.md` (`#7C3AED` para fundos de destaque/botões, `#22C55E` para valores monetários e `#EF4444` para exclusão).
3. Implemente a validação estrita no formulário: impedir o salvamento se o valor for zero ou se o tipo de receita não estiver selecionado.