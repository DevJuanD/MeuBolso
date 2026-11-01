# Especificação de Ajuste: Refatoração do Seletor de Tipo e Persistência de Categorias Padrão
**Caminho do Arquivo:** `.spec/adjustments/ajuste_dropdown_e_seed_categorias.md`

## 1. Contexto e Objetivo
Esta especificação consolida a refatoração visual do componente de seleção de tipos de transação (limitando a rolagem a 3 itens e fixando o botão de criação) e implementa a migração das categorias estáticas para o banco de dados. O sistema deixará de depender de listas em memória e passará a injetar os tipos padrão diretamente no SQLite na primeira inicialização (processo de *seed*), permitindo consulta dinâmica e integração com a interface.

## 2. Regras de Negócio e Persistência (Database Seeding)
- **Criação da Tabela:** O banco de dados deve possuir a tabela `categorias` (ex: `id`, `nome`, `tipo`, `is_padrao`, `icone_id`).
- **Injeção Inicial (Seed):** No momento de criação do banco (`onCreate` do `sqflite`), o sistema deve executar rotinas de `INSERT` para gravar as categorias padrão que antes ficavam isoladas no código.
  - *Exemplos de inserção:* 'Salário', 'Freelance', 'Alimentação', 'Transporte', 'Moradia', 'Contas e serviços', etc.
- **Tratamento de Ícones:** A função `iconeParaCategoria(String categoria)` pode ser mantida exclusivamente na camada de Apresentação (UI) como um *Helper* visual. Ela receberá o nome da categoria vindo do banco de dados e retornará o `IconData` correspondente. Caso o nome retornado pelo banco não esteja no mapeamento, retornará o `Icons.more_horiz_rounded`.

## 3. Regras de Comportamento e Interface (Seletor de Tipo)
- **Consulta Dinâmica:** O dropdown ou menu de seleção não deve mais utilizar opções hardcoded. Ele deve ser preenchido a partir do resultado de uma consulta ao banco (`listarCategoriasPorTipoUsecase`).
- **Altura Limitada e Scroll (Escopo Estrito):**
  - O contêiner da lista deve exibir **exatamente 3 itens** simultaneamente.
  - Se houver mais de 3 itens cadastrados (o que ocorrerá devido ao seed do banco), a área da lista possuirá *scroll* vertical.
- **Botão Fixo no Rodapé:**
  - O botão `+ Criar novo tipo` deve estar fixado na parte inferior do componente de seleção e fora do `ListView` rolável. O *scroll* da lista de tipos **não deve afetar o botão**.
- **Correção do Bug de Renderização:**
  - Ao criar e salvar um novo tipo, a interface pai não deve renderizar listas soltas. O fluxo deve apenas fechar o modal de criação, atualizar o estado interno do seletor e exibir o novo tipo como ativo/selecionado no campo.

### Adendo: Filtragem Estrita por Tipo de Transação
- **Regra de Exibição no Seletor:** O componente de seleção (`seletor_tipo_widget.dart`) nunca deve carregar a lista global de categorias. Ele deve ser alimentado exclusivamente por uma consulta filtrada (`listarCategoriasPorTipoUsecase(TipoTransacao tipo)`).
- **Injeção na Tela de Receitas (`form_receita_page.dart`):** Ao inicializar a tela, o controlador deve buscar no banco apenas as categorias onde `tipo == 'receita'` (ex: Salário, Freelance, Vendas).
- **Injeção na Tela de Despesas (`form_despesa_page.dart`):** Ao inicializar a tela, o controlador deve buscar no banco apenas as categorias onde `tipo == 'despesa'` (ex: Alimentação, Moradia, Transporte).
- **Herança na Criação de Novo Tipo:** Quando o usuário tocar no botão "+ Criar novo tipo", o modal deve herdar silenciosamente o tipo da tela atual. O usuário digitará apenas o nome, e o sistema salvará no banco de dados vinculando automaticamente ao tipo correto (se estiver na tela de despesa, a nova categoria será salva como `tipo: 'despesa'`).

## 4. Estrutura de Arquivos e Modificações Esperadas
### Camada de Dados (`lib/features/core/data/database/`)
1. **`servico_banco_dados.dart`:**
   - Adicionar o bloco de criação da tabela `categorias`.
   - Adicionar os comandos `db.insert` (ou `batch.insert`) dentro do método `onCreate` para popular a tabela com todos os casos presentes anteriormente no `switch`.

### Camada de Apresentação (`lib/features/transacoes/presentation/`)
1. **`widgets/seletor_tipo_widget.dart` (Refatoração Visual):**
   - Utilizar a abordagem de `showModalBottomSheet` ou `Overlay` para criar um seletor customizado que permita fixar o rodapé e limitar a altura do `ListView`.
   - O construtor deste widget passará a receber `List<Categoria> categorias` recuperadas do banco via Controller.
   - Envolver o `ListView.builder` em um `SizedBox` com altura estática correspondente a 3 itens (ex: `height: 150.0`).
2. **`helpers/icone_helper.dart`:**
   - Manter a função `iconeParaCategoria` neste arquivo, utilizando-a no `ListTile` do seletor para renderizar a representação visual da categoria recuperada do banco.

## 5. Instruções de Execução para o Agente
1. Modifique a inicialização do SQLite para incluir o script de inserção em massa (Seed) das categorias baseadas no antigo *switch case*. Se o banco já estiver criado no dispositivo, instrua uma rotina de migração (`onUpgrade`) ou recrie o banco durante os testes.
2. Refatore o componente visual do seletor, removendo dependências nativas restritas como `DropdownButton` caso este não permita rodapé fixo. Adote a estratégia de lista flutuante (Bottom Sheet/Dialog customizado) com altura fixada e rolável internamente.
3. Certifique-se de que a variável de estado que guarda o "tipo selecionado" na tela de formulário não engatilhe renderizações desnecessárias no corpo principal da página (correção do bug da lista duplicada).
4. Ao adicionar a nova categoria, insira-a no banco de dados e recarregue a lista baseada no novo estado atualizado do banco.