# CONSTITUIÇÃO DO PROJETO: MeuBolso (Flutter / SDD)

Este documento estabelece as diretrizes arquiteturais, convenções de código, regras de negócio centrais e fluxos de trabalho obrigatórios para o Agente neste repositório, em conformidade com a Especificação de Requisitos do MeuBolso (v0.1).

---

## 1. Idioma e Nomenclatura no Código

- **Código em Português (`pt_BR`):** Todos os métodos, variáveis, parâmetros, funções, atributos de classes, comentários e mensagens de log/erro devem ser escritos em **português**.
  - _Exemplos de métodos:_ `obterTransacoes()`, `calcularSaldoTotal()`, `processarSalariosVencidos()`, `salvarPerfilLocal()`.
  - _Exemplos de variáveis:_ `saldoAtualCentavos`, `listaDeDespesas`, `recorrenciaId`, `excluidaEm`.
- **Exceção Única (Termos Técnicos/Sintaxe do Framework):** Palavras-chave da linguagem/framework, termos Clean Architecture ou anotações de pacotes mantêm a nomenclatura original em inglês (ex: `Widget`, `StatefulWidget`, `BuildContext`, `@freezed`, `fromJson`, `override`, `UseCase`, `Repository`).

## 1.5. Comentários e Documentação no Código

- **Comentários somente quando necessários:** Escreva comentários apenas quando agregarem valor real à compreensão, manutenção ou segurança do código. Priorize código limpo, legível e autoexplicativo.
- **Explique o motivo, não o óbvio:** Quando necessário, o comentário deve esclarecer decisões de implementação, regras de negócio não evidentes, limitações técnicas, comportamentos inesperados ou soluções alternativas adotadas.
- **Evite comentários redundantes:** Não escreva comentários para explicar operações triviais, nomes de variáveis, chamadas de funções, estruturas condicionais simples ou trechos cujo propósito seja evidente pelo próprio código.
- **Não comente por obrigação:** Não adicione comentários apenas para preencher espaço, demonstrar o funcionamento do código ou fazer com que cada função, classe ou método tenha um comentário.
- **Documentação proporcional à complexidade:** Utilize documentação, como docstrings, quando realmente ajudar a esclarecer contratos de funções públicas, parâmetros complexos, efeitos colaterais, restrições importantes ou comportamentos que não possam ser compreendidos facilmente pela assinatura e implementação.
- **Manutenção dos comentários existentes:** Ao modificar um trecho de código, revise os comentários relacionados. Atualize ou remova aqueles que estejam incorretos, desatualizados ou que tenham se tornado redundantes.
- **Idioma:** Todos os comentários e textos de documentação escritos pelo agente devem estar em português (`pt_BR`), respeitando a Seção 1. Nomes e identificadores técnicos de APIs externas permanecem inalterados.
- **Regra principal:** Antes de adicionar um comentário, avalie se ele fornece uma informação relevante que não pode ser compreendida facilmente pelo próprio código. Se não fornecer, não o escreva.

---

## 2. Arquitetura e Injeção de Dependências

### Clean Architecture (Feature-First)

A aplicação deve ser estruturada por funcionalidades em `lib/features/`, contendo as três camadas bem delimitadas (RNF08):

1. **Domain (Domínio):**
   - Entidades puras (`PerfilLocal`, `Transacao`, `Recorrencia`), Casos de Uso (`AcessarApp`, `CadastrarTransacao`, `ProgramarSalario`), contratos de repositórios e falhas.
   - Totalmente isento de dependências de framework ou bibliotecas de UI.
2. **Data (Dados):**
   - Implementação dos repositórios, Data Sources (SQLite via `sqflite` e `flutter_secure_storage`) e DTOs.
   - Mapeamento bidirecional entre DTOs e Entidades de Domínio.
3. **Presentation (Apresentação):**
   - As 5 telas funcionais (`T01 Login`, `T02 Início`, `T03 Transações`, `T04 Form`, `T05 Resumo`) e gerenciamento de estado reativo simples.

### Injeção de Dependências

- **Apenas Construtores Nativos:** Não utilizar service locators (ex: `get_it`). As dependências devem ser injetadas de forma explícita via construtores, garantindo baixo acoplamento e facilidade de substituição em testes.

---

## 3. Diretrizes de Dados e Segurança

- **Representação Monetária (RNF07 / RN01):** Todos os valores financeiros devem ser manipulados e persistidos **exclusivamente como inteiros em centavos** (`valor_centavos`). Proibido o uso de `double` para valores de moeda.
- **Segurança de Autenticação (RNF04 / Perfil Local):**
  - O perfil é único por instalação (nome, e-mail, salt, parâmetros e verificador de senha).
  - A senha em texto limpo **nunca deve ser armazenada**. Utilizar derivação de senha com `salt` e armazenar o verificador no `flutter_secure_storage`.
- **Persistência Local Offline (RNF01 / RNF02):**
  - O banco de dados principal é SQLite (`sqflite`).
  - Suporte total a funcionamento offline sem dependência de internet/servidores externos.

---

## 4. Regras de Negócio Fundamentais (MeuBolso Core)

1. **Categorias e Origens (RN03 / RN05):**
   - Categorias predefinidas para Despesas: _Alimentação, Transporte, Moradia, Contas, Saúde, Lazer e Outros_.
   - Origens predefinidas para Receitas: _Venda, Presente, Salário e Serviço Avulso_.
2. **Recorrência de Salário (RN06 / RN07 / RN08):**
   - Receita de origem _Salário_ permite agendamento mensal com `dia_mes` (1 a 31) e `competencia_inicio` (AAAA-MM).
   - Ao abrir/retomar o app, processar ocorrências vencidas respeitando a restrição `UNIQUE(recorrencia_id, competencia)`.
   - Se o mês não tiver o dia escolhido (ex: dia 31 em fevereiro), utilizar o último dia do mês.
3. **Exclusão Lógica e Consistência (RN09):**
   - A exclusão de transações deve utilizar **exclusão lógica** (`excluida_em`) para manter a chave da competência e evitar que salários apagados sejam regenerados automaticamente pela recorrência.

---

## 5. UI, Tema e Qualidade de Código

- **Telas Funcionais do Escopo:**
  - `T01 Login`: Login e cadastro de perfil local.
  - `T02 Início`: Dashboard com totais, seletor de mês e 5 últimas movimentações.
  - `T03 Transações`: Listagem completa com filtros por mês, tipo e modalidade.
  - `T04 Nova Transação / Edição`: Form com validações estritas (descrição de 1 a 80 caracteres).
  - `T05 Resumo`: Totais do mês e distribuição de despesas por categoria/modalidade.
- **Suporte Obligatório Dark/Light Mode:** Utilização de `Theme.of(context)` com `ColorScheme` do Material 3. Nenhuma cor _hardcoded_.
- **Formatação e Idioma:** Datas no padrão `dd/MM/aaaa` e moeda em `R$` via pacote `intl` pré-configurado para `pt_BR`.
- **Análise Estática e DTOs:** Respeito rigoroso às regras do `flutter_lints` e geração de código para imutabilidade com `freezed` + `json_serializable`.

---

## 6. Governança e Paradigma SDD (Spec-Driven Development)

### Estrutura de Especificações

- As especificações de cada funcionalidade e caso de uso residem no diretório `.spec/features/` (ex: `autenticacao.md`, `transacoes.md`, `recorrencia_salario.md`).

### Fluxo de Trabalho e Economia de Tokens

1. **Consumo Eficiente:** O Agente não reescreve a especificação inteira ao registrar progresso. Ele apenas lê a spec e foca nas alterações necessárias nos arquivos de código.
2. **Execução Focada:** Alterações em arquivos de especificação só ocorrem quando explicitamente solicitadas pelo usuário.
