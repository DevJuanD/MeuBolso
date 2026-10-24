# Especificação de Ajuste: Logout e Troca de Perfil na Tela Inicial (T01)

**Caminho do arquivo:** `.spec/adjustments/ajuste_logout_t01.md`

## 1. Contexto e Objetivo

Atualmente, quando um perfil já existe no dispositivo, a tela T01 (Login) exibe apenas o campo de senha e o botão **Entrar**, impedindo que o usuário existente acesse outras opções de autenticação.

Este ajuste implementa a funcionalidade de **Sair (Logout)**, permitindo desvincular o perfil atual do dispositivo para que a tela retorne ao estado de **Primeiro Acesso (Cadastro)**. Dessa forma, será possível cadastrar um novo usuário ou iniciar o acesso com outro perfil.

## 2. Regras de Negócio e Interface do Usuário

### 2.1. Condição de Exibição

- O botão **Sair** deve ser renderizado somente quando a tela T01 estiver no modo **Login**, ou seja, quando o `VerificarPerfilUsecase` retornar `true`.
- Quando não existir um perfil no dispositivo, o botão não deve ser exibido.

### 2.2. Posicionamento e Design

Seguir as diretrizes definidas em `core_ui.md`.

- **Componente:** `TextButton`, sem fundo preenchido.
- **Posicionamento:** imediatamente abaixo do botão principal **Entrar**.
- **Texto:** `Sair deste perfil` ou `Entrar com outra conta`.
- **Espaçamento:** utilizar um espaçamento adequado entre os botões, como `SizedBox(height: 16)`.

### 2.3. Ação Destrutiva e Confirmação

Como o aplicativo segue a abordagem *offline-first* e permite apenas um perfil por instalação, remover o perfil implica apagar a chave de acesso armazenada localmente.

Antes de executar o logout, o aplicativo deve exibir um modal de confirmação (`AlertDialog`) com a seguinte mensagem:

> Tem certeza de que deseja sair? O perfil atual será desvinculado deste dispositivo.

O modal deve disponibilizar as seguintes ações:

- **Cancelar:** ação secundária que fecha o modal sem modificar o perfil atual.
- **Sair:** ação destrutiva, utilizando a cor vermelha `#EF4444` (Negative).

O logout somente deve ser executado após a confirmação explícita do usuário.

### 2.4. Comportamento Pós-Logout

Após a confirmação da ação:

1. O `flutter_secure_storage` deve ser limpo quanto à chave de armazenamento do perfil atual.
2. O estado local da autenticação deve ser atualizado imediatamente.
3. O fluxo da tela T01 deve mudar para `RequerCadastro`.
4. A interface deve exibir o formulário completo de cadastro, contendo os campos:
   - Nome;
   - E-mail;
   - Senha;
   - Confirmação de senha.

A transição deve ocorrer sem exigir que o usuário reinicie o aplicativo.

## 3. Arquivos Afetados e Modificações

### 3.1. Camada de Apresentação

**Diretório:** `lib/features/autenticacao/presentation/`

#### `pages/login_page.dart`

- Adicionar um `TextButton` secundário, condicionado ao estado `PerfilExistente`.
- Posicionar o botão imediatamente abaixo do botão principal **Entrar**, respeitando o espaçamento definido nas diretrizes de interface.
- Implementar o modal de confirmação utilizando `AlertDialog`.
- Garantir que a ação de logout seja executada somente após a confirmação do usuário.

#### `controllers/autenticacao_controller.dart`

- Adicionar o método `realizarLogout()`.
- Invocar o caso de uso responsável pelo logout.
- Limpar ou atualizar o estado local da autenticação.
- Alterar o fluxo da tela para `RequerCadastro` após a conclusão da operação.
- Garantir que a interface reaja imediatamente à mudança de estado.

### 3.2. Camada de Domínio e Dados

**Diretório:** `lib/features/autenticacao/`

#### `domain/usecases/logout_usecase.dart` — Novo arquivo

- Criar um caso de uso dedicado à operação de logout.
- Delegar a exclusão do perfil ao repositório de autenticação.
- Manter as responsabilidades da camada de domínio separadas das implementações de armazenamento.

#### `domain/repositories/autenticacao_repository.dart`

- Garantir a declaração do método:

  ```dart
  Future<void> realizarLogout();
  ```

- Assegurar que a implementação do repositório respeite o contrato definido pela camada de domínio.

#### `data/datasources/autenticacao_local_datasource.dart`

- Garantir que a operação de exclusão remova completamente a chave `_chavePerfilStorage`.
- Utilizar o método `secureStorage.delete(key: ...)` para excluir a chave correspondente.
- Evitar que dados residuais do perfil removido façam o aplicativo continuar identificando o dispositivo como já cadastrado.

## 4. Instruções de Execução para o Agente

1. Modificar `login_page.dart` para inserir o `TextButton` abaixo do `ElevatedButton` de **Entrar**, utilizando um espaçamento adequado, como `SizedBox(height: 16)`.
2. Condicionar a exibição do botão ao estado `PerfilExistente`.
3. Implementar o `AlertDialog` com as ações **Cancelar** e **Sair**, respeitando as diretrizes visuais do projeto.
4. Atualizar `autenticacao_controller.dart` para gerenciar o evento de logout e coordenar a execução do caso de uso.
5. Criar `logout_usecase.dart` e integrar o caso de uso ao repositório de autenticação.
6. Atualizar o contrato do repositório e a implementação do datasource para garantir a exclusão correta da chave armazenada.
7. Garantir que, após o logout, o estado da autenticação seja alterado para `RequerCadastro` e o formulário completo de cadastro seja exibido imediatamente.
8. Seguir os padrões de nomenclatura já adotados no projeto, mantendo os nomes de métodos em português.
9. Reutilizar a arquitetura, os componentes e os padrões existentes sempre que possível, evitando duplicação de código e alterações fora do escopo desta especificação.

## 5. Critérios de Aceitação

- [ ] O botão **Sair deste perfil** é exibido somente quando existe um perfil armazenado no dispositivo.
- [ ] O botão é posicionado abaixo do botão **Entrar**, respeitando as diretrizes de `core_ui.md`.
- [ ] Ao tocar em **Sair**, o aplicativo solicita confirmação antes de excluir o perfil.
- [ ] Ao selecionar **Cancelar**, o modal é fechado e o perfil permanece intacto.
- [ ] Ao confirmar o logout, a chave `_chavePerfilStorage` é removida do `flutter_secure_storage`.
- [ ] O estado da autenticação é atualizado para `RequerCadastro`.
- [ ] O formulário completo de cadastro é exibido sem a necessidade de reiniciar o aplicativo.
- [ ] O fluxo de login continua funcionando normalmente quando o usuário opta por não sair do perfil.
- [ ] A implementação respeita a arquitetura existente e os padrões de nomenclatura do projeto.

## 6. Padrão de Commit

Para os commits relacionados a esta alteração, utilizar verbos no infinitivo, com mensagens curtas e descritivas.

Exemplos:

- `Adicionar botão de logout na tela de login`
- `Implementar caso de uso de logout`
- `Atualizar estado de autenticação após logout`
- `Garantir exclusão do perfil no armazenamento seguro`