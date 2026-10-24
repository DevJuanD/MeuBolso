# Especificação de Funcionalidade: Consultas e Agregações de Relatórios (Backend/Data Layer)
**Caminho do Arquivo:** `.spec/features/relatorios_backend.md`

## 1. Contexto e Objetivo
Estruturar exclusivamente as camadas de **Domain** e **Data** para suportar a futura tela de Relatórios Financeiros (T05). O foco desta especificação é a construção de consultas SQL complexas no SQLite (`sqflite`) para filtragem dinâmica, agrupamento de dados e agregações matemáticas. A interface de usuário (UI) não faz parte deste escopo e será implementada em uma tarefa futura.

## 2. Regras de Negócio e Filtros de Consulta
- **Filtros Dinâmicos:** As consultas devem aceitar parâmetros opcionais de período (`dataInicial` e `dataFinal`), `tipo` da movimentação (Receita/Despesa) e `categoriaId`[cite: 42].
- **Agrupamento por Categoria:** Para alimentar o gráfico "Onde você mais gastou", o banco deve retornar a soma das despesas agrupadas por categoria dentro do período especificado[cite: 40].
- **Evolução Temporal:** Para alimentar o gráfico de barras, a consulta deve agrupar as receitas e despesas por mês/ano (ex: `strftime('%Y-%m', data)` no SQLite)[cite: 41].
- **Comparativo Financeiro:** O repositório deve ser capaz de calcular os totais do período atual e do período imediatamente anterior para o cálculo de variação percentual[cite: 40, 41].
- **Restrição Padrão:** Todas as consultas devem obrigatoriamente incluir `WHERE transacoes.excluida_em IS NULL`[cite: 5].

## 3. Estrutura de Arquivos Esperada

### Camada de Domínio (`lib/features/relatorios/domain/`)
1. **Entidades e DTOs (`entities/`):**
   - `filtro_relatorio.dart`: Classe de parâmetros (data inicial, data final, tipo, categoria_id).
   - `totais_periodo.dart`: `totalReceitas` (int), `totalDespesas` (int), `saldo` (int).
   - `gasto_por_categoria.dart`: `categoriaNome` (String), `totalCentavos` (int), `percentual` (double).
   - `evolucao_mensal.dart`: `competencia` (String), `totalReceitas` (int), `totalDespesas` (int).
2. **Contrato de Repositório (`repositories/relatorio_repository.dart`):**
   - `Future<TotaisPeriodo> obterTotais(FiltroRelatorio filtro);`
   - `Future<List<GastoPorCategoria>> obterGastosPorCategoria(FiltroRelatorio filtro);`
   - `Future<List<EvolucaoMensal>> obterEvolucaoMensal(FiltroRelatorio filtro);`
3. **Casos de Uso (`usecases/`):**
   - Implementar um caso de uso para cada método do repositório, validando se `dataInicial` é anterior ou igual a `dataFinal`.

### Camada de Dados (`lib/features/relatorios/data/`)
1. **Data Source Local (`datasources/relatorio_local_datasource.dart`):**
   - Implementar o construtor recebendo o `ServicoBancoDados`.
   - **Query de Totais:** Utilizar `SUM(CASE WHEN tipo = 'receita' THEN valor_centavos ELSE 0 END) as receitas` para resolver tudo em uma única ida ao banco.
   - **Query de Gastos por Categoria:** Realizar um `INNER JOIN` com a tabela `categorias` para obter o nome. Utilizar `GROUP BY categorias.id`.
   - **Query de Evolução:** Agrupar pela coluna `competencia` (formato AAAA-MM). 
   - *Nota:* As datas no SQLite estão em formato texto ISO8601, então filtros de período devem usar `>=` e `<=`.
2. **Implementação do Repositório (`repositories/relatorio_repository_impl.dart`):**
   - Faz a chamada ao DataSource.
   - Realiza o cálculo do `percentual` (regra de três simples) para os gastos por categoria antes de devolver para o domínio, pois o SQLite nativo tem limitações com aritmética de ponto flutuante em agrupamentos.

## 4. Instruções de Execução para o Agente
1. **Foco Estrito no Backend:** Não crie diretórios `presentation`, `pages`, `widgets` ou `controllers` nesta execução.
2. Escreva as instruções SQL brutas (`db.rawQuery`) para garantir performance e precisão nos agrupamentos (`GROUP BY`, `SUM`, `JOIN`).
3. Retorne sempre os valores monetários em inteiros (`valor_centavos`), convertendo mapas SQL para as respectivas entidades de domínio.