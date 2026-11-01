# Especificação de Correção: Renderização de Ícones no Dropdown
**Caminho do Arquivo:** `.spec/corrections/correcao_icones_dropdown.md`

## 1. Contexto e Diagnóstico do Erro
Analisando a interface atual, o seletor de "Tipo de receita" exibe corretamente a lista com opções como "Freelance", "Outros" e "Presente", porém todas estão apresentando o ícone padrão de três pontinhos (`...`)[cite: 3]. 

**Causa Raiz:** O comportamento de exibir os "três pontinhos" indica que o mapeamento de ícones caiu no bloco `default` da função auxiliar (Helper). Isso ocorre porque a lógica antiga verificava o `nome` da categoria (ex: "Freelance"), mas com a nova arquitetura do banco de dados, a interface precisa ler o campo `icone_id` (a chave em texto, como `'trabalho'`, `'presente'`) que vem do objeto `Categoria` e mapeá-lo para o respectivo `IconData`. Se a função não foi atualizada para ler o ID, ou se as chaves não batem, ela devolve o ícone genérico.

## 2. Objetivos de Correção
O Agente deve refatorar a função de mapeamento de ícones (`icone_helper.dart`) para trabalhar com o `icone_id` vindo do banco de dados e garantir que o componente visual do seletor repasse essa propriedade corretamente.

## 3. Estrutura de Arquivos e Modificações Esperadas

### Camada de Apresentação (`lib/features/categorias/presentation/helpers/icone_helper.dart` ou similar)
1. **Atualizar o Helper:**
   - O agente deve substituir (ou criar) a função para mapear a string do `icone_id` (salva no banco) para os ícones reais.
   - *Exemplo de implementação:*
     ```dart
     static IconData obterIconePorId(String? iconeId) {
       switch (iconeId) {
         case 'trabalho': return Icons.work_outline_rounded;
         case 'freelance': return Icons.laptop_mac_rounded;
         case 'presente': return Icons.card_giftcard_rounded;
         case 'vendas': return Icons.shopping_bag_outlined;
         case 'outros': return Icons.more_horiz_rounded;
         // ... adicionar demais mapeamentos do pool de ícones
         default: return Icons.more_horiz_rounded;
       }
     }
     ```

### Componente do Seletor (`lib/features/transacoes/presentation/widgets/seletor_tipo_widget.dart`)
1. **Corrigir a Chamada do Ícone:**
   - No `ListView.builder` que renderiza as opções do dropdown, o `Icon` do `ListTile` deve consumir o método atualizado passando o `iconeId` da entidade.
   - *Exemplo de correção:* Alterar de `Icon(IconeHelper.obterIcone(categoria.nome))` para `Icon(IconeHelper.obterIconePorId(categoria.iconeId))`.

### Camada de Dados (`lib/features/core/data/database/servico_banco_dados.dart`)
1. **Validar os IDs do Seed (Inserção Inicial):**
   - Garantir que as *strings* passadas no momento da inserção (ex: o 5º parâmetro do `INSERT`, que é o `icone_id`) correspondam exatamente aos *cases* mapeados no `icone_helper.dart`. Se inseriu `'freelance'` no banco, o helper tem que ter `case 'freelance':`.

## 4. Instruções de Execução para o Agente
1. Acesse a classe/arquivo responsável por converter as strings em `IconData` (provavelmente `icone_helper.dart`).
2. Modifique o método para receber o `icone_id` e crie o mapeamento (Dicionário/Switch) que conecte as strings salvas no banco de dados aos ícones corretos.
3. No arquivo do Dropdown (`seletor_tipo_widget`), localize onde o ícone é renderizado (atualmente mostrando os 3 pontinhos) e altere o parâmetro repassado para o Helper para usar `categoria.iconeId`.
4. Faça uma validação cruzada rápida: veja se as strings de `icone_id` usadas no `onCreate` do SQLite batem com as strings verificadas no Helper.