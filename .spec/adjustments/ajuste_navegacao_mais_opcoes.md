# Especificação de Ajuste: Navegação para "Minhas Despesas" no Menu "Mais"
**Caminho do Arquivo:** `.spec/adjustments/ajuste_navegacao_mais_opcoes.md`

## 1. Contexto e Objetivo
Como reflexo do ajuste anterior que transformou a aba "Transações" em uma listagem unificada, a tela específica e isolada de despesas foi realocada. O objetivo deste ajuste é garantir que a tela de "Mais Opções" (acessada pelo menu de três pontinhos na barra inferior) contenha o atalho correto e funcional para a tela de "Minhas Despesas", executando o roteamento exato que existia antes.

## 2. Comportamento e Interface
- **Opção no Menu:** A tela "Mais Opções" deve exibir um item de lista (ex: `ListTile` ou um Card de atalho).
- **Identificação Visual:** 
  - Título: "Minhas Despesas".
  - Ícone: Um ícone representativo de saída de dinheiro (ex: seta para baixo ou carteira).
- **Ação de Roteamento:** Ao tocar nesta opção, o aplicativo deve empilhar a rota (via `Navigator.push` ou equivalente) direcionando o usuário exatamente para a tela `ListaDespesasPage` (a mesma que exibe os totais gastos, lista de saídas e o botão exclusivo de adicionar despesa).
- É importante que, quando abrir a tela de "Minhas Despesas" também seja possível usar o menun de "Mais Opções" normalmente novamente.

## 3. Estrutura de Arquivos e Modificações

### Camada de Apresentação (`lib/features/mais_opcoes/presentation/`)
1. **`pages/mais_opcoes_page.dart` (ou equivalente da aba 'Mais'):**
   - Adicionar ou localizar o componente visual de "Minhas Despesas".
   - Implementar a função `onTap` no item.
   - O código do `onTap` deve executar a navegação para a página de despesas. Exemplo: `Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListaDespesasPage()));` (ou usar a rota nomeada correspondente, caso o projeto utilize rotas nomeadas como `'/minhas-despesas'`).

### Camada de Roteamento (`lib/core/navigation/` - Se aplicável)
1. **`app_routes.dart` ou `app_router.dart`:**
   - Validar se a rota para a tela de despesas isoladas está corretamente mapeada, caso o sistema de navegação exija.

## 4. Instruções de Execução para o Agente
1. Acesse o arquivo que renderiza a aba "Mais" (os 3 pontinhos da `BottomNavigationBar`).
2. Localize ou crie o botão/ListTile "Minhas Despesas".
3. Conecte o evento de clique (`onTap` / `onPressed`) à ação de navegação que carrega a view `ListaDespesasPage` que já foi implementada e testada no repositório.
4. Teste a integridade do botão de voltar (`<` na AppBar) da tela de "Minhas Despesas", garantindo que ele retorne corretamente para o menu "Mais Opções" sem quebrar a pilha de telas.