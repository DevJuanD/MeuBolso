# Especificação de Funcionalidade: Dados e Agregações da Dashboard (T02)
**Caminho do Arquivo:** `.spec/features/dashboard_dados.md`

## 1. Contexto e Objetivo
Implementar a lógica de agregação e as consultas otimizadas no banco de dados para alimentar a tela **T02 Início (Dashboard)**. Esta tela atua como o painel central financeiro do usuário, exigindo cálculos rápidos de totais mensais, comparações com o mês anterior e a listagem das movimentações mais recentes[cite: 17].

---

## 2. Regras de Negócio e Cálculos
- **Cálculo de Saldo (RN02):** O "Saldo disponível" é estritamente a diferença entre a soma das receitas e a soma das despesas do período selecionado (`Saldo = Receitas - Despesas`)[cite: 5]. O valor pode ser negativo.
- **Comparativo Mensal:** A dashboard exibe a variação percentual em relação ao mês anterior (ex: `↑ +12,5% em relação ao mês anterior`)[cite: 17].
  - *Fórmula:* `((Total Atual - Total Anterior) / Total Anterior) * 100`. (Tratar divisão por zero caso o mês anterior não tenha registros).
- **Filtro de Período (RN10):** Todas as agregações (Receitas, Despesas e Saldo) devem ser filtradas pelo mês calendário selecionado (do dia 1 ao último dia do mês)[cite: 5].
- **Últimas Transações:** A lista "Movimentações recentes" deve exibir no máximo as **5 transações mais recentes** do mês atual, ordenadas de forma decrescente pela data[cite: 3, 17].
- **Registros Excluídos:** Transações com `excluida_em IS NOT NULL` devem ser sumariamente ignoradas em todos os cálculos e listagens[cite: 5].

---

## 3. Mapeamento da Interface (Tela T02 Início)
*   **Saudação:** "Olá, [Nome]!" seguido do subtítulo "Aqui está um resumo das suas finanças."[cite: 17]. (O nome deve ser recuperado do `PerfilLocal`).
*   **Cards de Indicadores:** 
    *   Card principal para **Saldo disponível** com valor em destaque e badge de variação percentual[cite: 17].
    *   Cards secundários dispostos lado a lado para **Receitas** (verde) e **Despesas** (vermelho), também exibindo as variações percentuais[cite: 17].
*   **Gráfico de Barras:** Seção "Receitas x Despesas" exibindo barras comparativas simples do mês selecionado[cite: 17].
*   **Lista Recente:** Seção "Últimas transações" com os 5 itens mais recentes e um atalho "Ver todas >" que redireciona para a aba de Transações (T03)[cite: 17].

---

## 4. Estrutura de Arquivos Esperada

### Camada de Domínio (`lib/features/dashboard/domain/`)
1. **Entidade de Agregação (`entities/resumo_mensal.dart`):**
   - `@freezed` contendo: `mesAtual` (DateTime), `totalReceitas` (int), `totalDespesas` (int), `saldo` (int), `variacaoSaldo` (double), `variacaoReceitas` (double), `variacaoDespesas` (double).
2. **Contrato de Repositório (`repositories/dashboard_repository.dart`):**
   - `Future<ResumoMensal> obterResumoMensal(DateTime mesReferencia);`
   - `Future<List<Transacao>> obterUltimasTransacoes(DateTime mesReferencia, int limite);`
3. **Casos de Uso (`usecases/`):**
   - `obter_resumo_dashboard_usecase.dart` (Orquestra a busca do resumo e das últimas transações).

### Camada de Dados (`lib/features/dashboard/data/`)
1. **Data Source Otimizado (`datasources/dashboard_local_datasource.dart`):**
   - **Proibido carregar todos os dados para a memória.** As totalizações devem ser feitas diretamente em SQL usando a função `SUM(valor_centavos)`.
   - *Exemplo de Query SQL:* `SELECT SUM(valor_centavos) as total FROM transacoes WHERE tipo = 'receita' AND excluida_em IS NULL AND competencia = ?`.
   - O DataSource deve executar as queries tanto para o `mesReferencia` quanto para o `mesAnterior` para permitir o cálculo das variações.

### Camada de Apresentação (`lib/features/dashboard/presentation/`)
1. **`pages/dashboard_page.dart` (T02):** Tela principal consumindo o estado.
2. **`widgets/card_indicador_widget.dart`:** Widget reutilizável para os cartões de Saldo, Receitas e Despesas, que adapta a cor (Positivo/Negativo) dependendo do tipo.
3. **`widgets/grafico_resumo_widget.dart`:** Implementação do gráfico de barras (pode utilizar o pacote `fl_chart`).
4. **Gerenciamento de Estado (`controllers/dashboard_controller.dart`):** Gerencia o carregamento simultâneo do perfil (para o nome), resumo e ultimas transações.

---

## 5. Instruções de Execução para o Agente
1. Desenvolva as queries SQL de agregação (`SUM`) no DataSource para garantir performance (RNF06) ao carregar a tela Inicial, mesmo com milhares de registros.
2. Adicione o pacote `fl_chart` ao `pubspec.yaml` para renderizar o gráfico comparativo de barras.
3. Garanta que a formatação monetária respeite a divisão por 100, já que o banco retorna `valor_centavos` em inteiros.
4. Na listagem de "Últimas transações", utilize o componente de item de lista já construído nas especificações de Receitas/Despesas, limitando a query SQL com `LIMIT 5`.