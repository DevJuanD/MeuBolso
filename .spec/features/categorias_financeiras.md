# Especificação de Funcionalidade: Categorias Financeiras (Customizáveis)
**Caminho do Arquivo:** `.spec/features/categorias_financeiras.md`

## 1. Contexto e Objetivo
Implementar a lógica e a persistência local para **Categorias de Receitas e Despesas**. Embora existam categorias predefinidas (ex: Alimentação, Salário), as telas de alta fidelidade exigem a funcionalidade de **"+ Criar novo tipo"**[cite: 20, 31]. Portanto, a arquitetura deve evoluir de simples `Enums` estáticos para entidades gerenciáveis no banco de dados, permitindo que o usuário cadastre, liste e utilize categorias customizadas (ex: "Consultoria", "Educação")[cite: 22, 33].

---

## 2. Regras de Negócio e Comportamentos
- **Tipagem (RN05):** Cada categoria pertence estritamente a um tipo: `Receita` ou `Despesa`[cite: 5]. O formulário de despesas só pode listar categorias do tipo despesa, e o de receitas, do tipo receita.
- **Categorias Padrão (Seed):** Ao inicializar o banco de dados pela primeira vez, o sistema deve injetar as categorias padrão. 
  - *Receitas padrão:* Salário, Freelance, Vendas, Rendimentos, Presente, Outros[cite: 20].
  - *Despesas padrão:* Alimentação, Transporte, Moradia, Contas e serviços, Saúde, Lazer, Compras, Outros[cite: 31].
- **Criação Dinâmica:** O usuário pode criar novos tipos informando apenas o nome (ex: "Consultoria")[cite: 21]. Ao salvar, a nova categoria já deve aparecer selecionada no formulário de transação[cite: 22].
- **Prevenção de Duplicidade:** O sistema não deve permitir a criação de uma categoria com o mesmo nome e tipo de uma já existente.

---

## 3. Mapeamento de Telas Correspondentes
*   **Seleção de Categoria (Telas de Formulário):** Um componente visual (lista, dropdown ou *bottom sheet*) que exibe as opções disponíveis e um botão persistente ao final da lista com o texto `+ Criar novo tipo` destacado na cor primária (`#7C3AED`)[cite: 20, 31].
*   **Criação de Novo Tipo (Modal/Tela Aninhada):** 
    *   Título: *"Novo tipo de receita"* ou *"Novo tipo de despesa"* com a instrução *"Dê um nome para identificar..."*[cite: 21, 32].
    *   Campo de texto: *"Nome da categoria"*.
    *   Botões: `Cancelar` (secundário) e `Salvar tipo` (primário).
*   **Feedback Visual:** Após criar, exibir uma mensagem (ex: *"Tipo criado! Agora disponível na sua lista:"*) e atualizar os chips/lista imediatamente[cite: 22, 33].

---

## 4. Estrutura de Arquivos Esperada

### Camada de Dados - Ajuste Estrutural (`lib/features/core/data/database/`)
1. **`servico_banco_dados.dart`:**
   - Adicionar a criação da tabela `categorias`: 
     `id` (TEXT PK), `nome` (TEXT NOT NULL), `tipo` (TEXT NOT NULL - 'receita' ou 'despesa'), `is_padrao` (INTEGER DEFAULT 0).
   - Ajustar a tabela `transacoes` para salvar o `categoria_id` (FOREIGN KEY) ao invés da string solta.
   - Criar uma rotina de *seed* (inserção inicial) para popular as categorias padrão no `onCreate` do banco.

### Camada de Domínio (`lib/features/categorias/domain/`)
1. **Entidade (`entities/categoria.dart`):**
   - `@freezed` contendo: `id` (String), `nome` (String), `tipo` (Enum TipoTransacao), `isPadrao` (bool).
2. **Contrato do Repositório (`repositories/categoria_repository.dart`):**
   - `Future<List<Categoria>> listarPorTipo(TipoTransacao tipo);`
   - `Future<Categoria> salvar(Categoria categoria);`
3. **Casos de Uso (`usecases/`):**
   - `listar_categorias_por_tipo_usecase.dart`
   - `criar_categoria_usecase.dart` (Deve conter a validação de nome não vazio e formatação, como capitalizar a primeira letra).

### Camada de Apresentação (`lib/features/categorias/presentation/`)
1. **Componente de UI (`widgets/seletor_categoria_widget.dart`):**
   - Um widget reutilizável que consome o caso de uso de listagem e exibe a grade/lista de categorias, integrando a opção de chamar o modal de criação.
2. **Diálogo/Modal (`widgets/modal_nova_categoria.dart`):**
   - Modal com o campo de texto para cadastrar a nova categoria, retornando o objeto recém-criado para a tela pai preencher o formulário automaticamente.

---

## 5. Instruções de Execução para o Agente
1. Execute a migração/atualização do `ServicoBancoDados` para criar a tabela de categorias e alterar a tabela de transações. Caso o app esteja em desenvolvimento inicial, recrie o banco do zero (`drop table` ou apague o app no emulador).
2. Implemente a rotina que injeta as categorias originais do projeto durante o `onCreate` do SQLite.
3. Desenvolva os UseCases garantindo a validação de strings vazias ou em branco na criação de categorias.
4. Conecte o `modal_nova_categoria.dart` ao gerador de estado do formulário (`form_receita_page.dart` e `form_despesa_page.dart`) para que, ao fechar o modal com sucesso, a nova categoria seja selecionada instantaneamente.