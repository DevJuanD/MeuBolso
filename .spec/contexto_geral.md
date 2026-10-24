# Contexto Geral do Projeto: MeuBolso
**Caminho do Arquivo:** `.spec/contexto_geral.md`

## 1. Visão Arquitetural e Tecnológica
O **MeuBolso** é um aplicativo móvel de controle financeiro pessoal *offline-first*. A arquitetura segue o padrão **Clean Architecture (Feature-First)**, separando rigidamente as camadas de Domínio, Dados e Apresentação, sem dependência de back-end externo.

*   **Tecnologias Base:** Flutter, Dart.
*   **Persistência Local:** SQLite (via pacote `sqflite`) para dados transacionais e `flutter_secure_storage` para dados sensíveis do perfil.
*   **Gerenciamento de Estado e Injeção:** Injeção de dependências nativa via construtores (sem locators globais acoplados).
*   **Imutabilidade:** Utilização de `freezed` e `json_serializable` para Entidades e DTOs.

## 2. Padrões de Código e Versionamento
*   **Idioma do Código:** Todos os métodos, variáveis, parâmetros e atributos de classes são escritos em português (`pt_BR`). Apenas termos nativos do framework (ex: `Widget`, `BuildContext`) mantêm o inglês original.
*   **Versionamento:** As mensagens de commit no Git utilizam obrigatoriamente verbos no infinitivo (ex: *adicionar tela de login*, *corrigir calculo de saldo*).
*   **Fluxo SDD (Spec-Driven Development):** O desenvolvimento é estritamente guiado por arquivos `.md` na pasta `.spec/`. Modificações estruturais exigem atualização prévia da especificação.

## 3. Regras de Negócio Globais (MeuBolso Core)
*   **Representação Monetária:** Todo valor financeiro é processado, armazenado e transitado estritamente como número inteiro (`valor_centavos`). Proibido o uso de ponto flutuante (`double`) na camada de dados. A divisão por 100 e formatação ocorrem exclusivamente na camada de Apresentação via pacote `intl`.
*   **Exclusão Lógica:** Registros financeiros nunca sofrem `DELETE` físico. A exclusão é feita preenchendo o campo `excluida_em` com a data atual. Consultas de listas e agregações ignoram sumariamente registros excluídos.
*   **Segurança de Credenciais:** A senha do perfil local nunca é salva em texto limpo. Utiliza-se um `salt` randômico combinado a um hash criptográfico protegido no storage seguro do dispositivo.

## 4. Funcionalidades Especificadas e Estruturadas
Até o presente momento, a fundação e as seguintes funcionalidades foram mapeadas para implementação:

1.  **Infraestrutura de Banco de Dados (`core_database.md`):** Modelagem das tabelas `transacoes`, `recorrencias` e `categorias`, garantindo integridade referencial e chaves únicas para evitar duplicidade de competências.
2.  **Design System (`core_ui.md`):** Mapeamento do `ThemeData` Material 3, definindo a paleta semântica (Roxo Primário, Verde Positivo, Vermelho Negativo) e tipografia padronizada (fonte Inter).
3.  **Autenticação Local (T01):** Criação de perfil único por instalação e validação de login na inicialização do aplicativo.
4.  **Gestão de Entradas e Saídas (T03 e T04):** Fluxo unificado, porém segregado visualmente, para cadastro, edição e exclusão de Receitas e Despesas.
5.  **Categorias Dinâmicas:** Transição do modelo estático para um modelo dinâmico no SQLite, permitindo a criação de novos tipos de receitas e despesas pela interface.
6.  **Motor de Agregação e Dashboard (T02 e T05):** Estruturação das consultas SQL (`SUM`, `GROUP BY`, `JOIN`) executadas diretamente no banco para consolidação de saldos, evolução mensal e despesas por categoria de forma otimizada.