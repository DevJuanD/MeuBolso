# Especificação de Correção: Ações e Layout da Tela de Gerenciar Categorias
**Caminho do Arquivo:** `.spec/corrections/correcao_gerenciar_categorias.md`

## 1. Contexto e Diagnóstico dos Problemas
A tela de "Gerenciar Categorias" apresenta duas inconsistências de usabilidade e integração[cite: 4]:
1. **Botão de Ação Inativo:** O *Floating Action Button* (FAB) com o ícone de `+` no canto inferior direito não executa nenhuma ação ao ser clicado[cite: 4].
2. **Sobreposição de UI (Obstrução de Clique):** A listagem de categorias rola por trás do FAB. Quando o usuário chega ao final da lista (ex: categoria "Transporte"), o botão de `+` fica exatamente sobre o botão de opções (três pontinhos), impedindo que o usuário edite ou exclua o último item[cite: 4].

## 2. Objetivos de Correção
O Agente deve conectar o FAB ao mesmo modal de criação utilizado nos formulários de transação, respeitando a aba ativa (Receita ou Despesa). Além disso, deve ajustar o preenchimento (*padding*) inferior da listagem para que o último item possa ser rolado para cima, ficando totalmente visível e acessível acima do botão flutuante.

## 3. Estrutura de Arquivos e Modificações Esperadas

### Camada de Apresentação (`lib/features/categorias/presentation/pages/gerenciar_categorias_page.dart`)
1. **Ativação do FAB (Ação de Criar):**
   - No `onPressed` do `FloatingActionButton`, implementar a chamada para abrir o modal de nova categoria (ex: `showModalBottomSheet` ou `showDialog` chamando o componente `modal_form_categoria.dart`).
   - **Lógica de Abas:** Como a tela possui um `TabBar` para Receitas e Despesas[cite: 4], o agente deve identificar qual é a aba ativa no momento do clique (usando o `TabController` ou estado local) para passar o `TipoTransacao` correto (Receita ou Despesa) para o modal. Assim, se o usuário estiver na aba "Despesas" e clicar no `+`, a nova categoria será salva como despesa.
2. **Correção do Scroll (Padding Inferior):**
   - Adicionar a propriedade `padding` ao `ListView` (ou `ListView.builder`) que renderiza as categorias.
   - *Implementação:* `padding: const EdgeInsets.only(bottom: 80.0)` (ou um valor suficiente, em torno de 80 a 100 pixels) na lista. Isso garante que o *scroll* tenha um "espaço extra" no final, permitindo que o último item suba e não fique escondido sob o FAB[cite: 4].

### Modal de Criação (`lib/features/categorias/presentation/widgets/modal_form_categoria.dart` ou similar)
- Garantir que este componente esteja genérico e independente o suficiente para ser chamado tanto pelos formulários de transação (dropdown) quanto pela tela de gerenciar categorias, sem duplicar código.
- Após o modal salvar a nova categoria, a lista da tela de "Gerenciar Categorias" deve ser atualizada para exibir o novo item.

## 4. Instruções de Execução para o Agente
1. Localize a página `gerenciar_categorias_page.dart`.
2. Adicione `padding: EdgeInsets.only(bottom: 100.0)` na sua `ListView` para resolver o problema da sobreposição visual com o FAB. Teste garantindo que a última categoria alcance uma área clicável acima do botão.
3. No `FloatingActionButton`, invoque o modal de criação de categoria já existente. 
4. Garanta que a função acionada pelo botão leia o índice atual do `TabController` (ex: `DefaultTabController.of(context).index`) para saber se o modal criará uma Receita ou uma Despesa.
5. Após o fechamento do modal com sucesso (`Navigator.pop` retornando *true* ou a entidade salva), recarregue a lista de categorias do controlador para que a nova opção apareça na tela imediatamente.