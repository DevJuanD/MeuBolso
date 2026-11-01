# Especificação de Funcionalidade: Gerenciamento de Categorias e Ícones
**Caminho do Arquivo:** `.spec/features/gerenciamento_categorias.md`

## 1. Contexto e Objetivo
Expandir o controle do usuário sobre as classificações financeiras do aplicativo. A funcionalidade adiciona a opção **"Gerenciar Categorias"** (nome mais amigável para "Tipos de Operações") no menu "Mais Opções". Nesta nova tela, o usuário poderá visualizar, editar e excluir as categorias de Receitas e Despesas. Além disso, o fluxo de criação e edição passa a suportar a escolha visual de um ícone a partir de um *pool* (lista predefinida) de ícones padronizados.

## 2. Regras de Negócio e Comportamentos
- **Proteção de Categorias Padrão:** As categorias nativas do sistema (aquelas injetadas no *seed* do banco, com `is_padrao = 1`) **não podem ser excluídas**, para garantir a integridade mínima do sistema. O botão de exclusão deve ficar oculto ou desabilitado para elas. O usuário pode apenas editar seus nomes ou ícones.
- **Exclusão de Categorias Customizadas:** Para categorias criadas pelo usuário (`is_padrao = 0`), a exclusão deve ser lógica (`excluida_em`) ou o sistema deve verificar se há transações vinculadas. Se houver, exibir um alerta: *"Não é possível excluir uma categoria que já possui transações. Edite-a ou exclua as transações primeiro."*
- **Persistência do Ícone:** A tabela `categorias` no banco de dados deve possuir a coluna `icone_id` (TEXT). O sistema salvará uma chave em texto (ex: `'home'`, `'car'`, `'food'`) que será mapeada de volta para um `IconData` do Flutter na camada de Apresentação.
- **Pool de Ícones (Sugestão de Catálogo):** O seletor deve oferecer uma grade (Grid) com ícones recorrentes do `Icons` do Material Design, tais como:
  - *Despesas:* Casa, Carro/Ônibus, Carrinho de Mercado, Restaurante, Saúde/Coração, Computador/Celular, Lazer/Ingresso, Roupas, Educação/Livro, Raio/Energia, Água.
  - *Receitas:* Maleta (Trabalho), Cifrão/Dinheiro, Gráfico de Alta (Rendimentos), Presente, Pix/Transferência.

## 3. Estrutura e Interface (UI)

### A. Menu "Mais Opções"
- Adicionar um `ListTile` com o título **"Gerenciar Categorias"** e um ícone sugestivo (ex: `Icons.category_outlined` ou `Icons.label_outline`).

### B. Tela "Gerenciar Categorias" (`gerenciar_categorias_page.dart`)
- **Layout:** Utilizar o padrão do app com AppBar. Logo abaixo, um `TabBar` (Abas) separando as visões: **Receitas** e **Despesas**.
- **Listagem:** Um `ListView` contendo as categorias. Cada item (`ListTile`) exibe:
  - À esquerda: O ícone escolhido em um círculo com a cor correspondente (Verde para receita, Vermelho para despesa).
  - Centro: Nome da categoria.
  - À direita: Um `PopupMenuButton` (três pontinhos verticais) com as opções "Editar" e "Excluir" (excluir visível apenas se `is_padrao == 0`).
- **Ação Principal:** Um `FloatingActionButton` (FAB) com o ícone de `+` para cadastrar uma nova categoria diretamente por esta tela.

### C. Modal de Criação / Edição (`modal_form_categoria.dart`)
- **Campo de Nome:** `TextField` para o nome da categoria.
- **Seletor de Ícone:** Um componente visual exibindo o ícone atualmente selecionado. Ao clicar, abre-se um *Bottom Sheet* (`modal_seletor_icone.dart`) contendo um `GridView` com o *pool* de ícones disponíveis. O ícone selecionado ganha destaque (borda ou cor de fundo).
- **Botões:** "Cancelar" e "Salvar".

## 4. Modificações e Arquivos Esperados

### Camada de Domínio e Dados
1. **`categoria_model.dart` / `categoria.dart`:**
   - Adicionar a propriedade `String iconeId`.
2. **`categoria_repository.dart`:**
   - Adicionar assinaturas para `atualizar(Categoria)` e `excluir(String id)`.
3. **`servico_banco_dados.dart`:**
   - Garantir que a criação da tabela inclua `icone_id TEXT DEFAULT 'default'`.

### Camada de Apresentação
1. **`helpers/icone_helper.dart`:**
   - Atualizar para um `Map<String, IconData>` definitivo que relacione a chave string do banco (ex: `'restaurante'`) com o `Icons.restaurant`.
2. **`features/categorias/presentation/pages/gerenciar_categorias_page.dart`:**
   - Nova tela com a estrutura de abas.
3. **`features/categorias/presentation/widgets/modal_seletor_icone.dart`:**
   - O Grid interativo para a seleção visual dos ícones.

## 5. Instruções de Execução para o Agente
1. Modifique a tabela `categorias` no SQLite para incluir a coluna `icone_id`. Ajuste a rotina de *seed* inicial para inserir identificadores de ícones válidos para as categorias padrão.
2. Crie o catálogo de mapeamento no front-end (`icone_helper.dart`) para transformar as strings do banco nos respectivos `IconData`.
3. Construa a tela `gerenciar_categorias_page.dart` utilizando `DefaultTabController` para gerenciar as abas de Receitas e Despesas.
4. Refatore o modal de criação (que já existe nos formulários de transação) para incluir a nova funcionalidade de escolha de ícones. Certifique-se de que a mesma lógica de criação/edição seja reutilizada tanto nos formulários de transação quanto na tela de gerenciamento.
5. Aplique as restrições de exclusão: categorias padrão (`is_padrao == 1`) não podem ser deletadas.