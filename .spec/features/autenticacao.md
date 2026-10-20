# Especificação de Funcionalidade: Autenticação e Perfil Local (T01)
**Caminho do Arquivo:** `.spec/features/autenticacao.md`

## 1. Contexto e Objetivo
Implementar o fluxo completo de "Autenticação e Perfil Local" garantindo o isolamento da camada de dados e o cumprimento estrito das regras de segurança estabelecidas (RNF04). O design deve consumir os tokens estabelecidos no `core_ui.md`, garantindo a identidade visual moderna da aplicação.

## 2. Regras de Negócio e Segurança
- **Segurança (RNF04):** É estritamente proibido salvar a senha do usuário em texto limpo.
  - O `AutenticacaoLocalDataSource` deve usar o pacote `flutter_secure_storage`.
  - A senha deve ser combinada a um `salt` randômico e hasheada (ex: via pacote `crypto` usando SHA-256). O `salt` e o `hash` (verificador) são salvos no storage local, junto com nome e e-mail.
- **Perfil Único:** A aplicação aceita apenas um perfil.
  - Se o perfil não existir: a tela T01 exibe o formulário de "Primeiro Acesso" (Nome, E-mail, Senha e Confirmação de Senha).
  - Se o perfil existir: a tela T01 exibe o "Login", mostrando uma mensagem de boas-vindas com o nome do usuário e pedindo apenas a senha.
- **Validações de UI:** E-mail com regex válido, senha mínima de 6 caracteres, validação de igualdade na confirmação de senha. Impedir submissões duplicadas durante o carregamento.

## 3. Estrutura de Arquivos

### Camada de Domínio (`lib/features/autenticacao/domain/`)
1. **Entidade (`entities/perfil_local.dart`):**
   - `@freezed` contendo: `nome` (String) e `email` (String).
   - *Nota:* O domínio não deve expor o salt ou o hash da senha.
2. **Contrato do Repositório (`repositories/autenticacao_repository.dart`):**
   - `Future<bool> verificarExistenciaPerfil();`
   - `Future<void> cadastrarPerfil(String nome, String email, String senhaClara);`
   - `Future<PerfilLocal> realizarLogin(String senhaClara);`
3. **Casos de Uso (`usecases/`):**
   - `verificar_perfil_usecase.dart`
   - `cadastrar_perfil_usecase.dart`
   - `login_usecase.dart`

### Camada de Dados (`lib/features/autenticacao/data/`)
1. **Modelo DTO (`models/perfil_local_model.dart`):**
   - Atributos: `nome`, `email`, `salt`, `verificadorSenha`.
   - Inclui os métodos `toJson` e `fromJson` para serialização.
2. **Data Source (`datasources/autenticacao_local_datasource.dart`):**
   - Injeta `FlutterSecureStorage` no construtor.
   - Constante de chave: `_chavePerfilStorage`.
   - Métodos: `salvarPerfil(PerfilLocalModel perfil)`, `obterPerfil()`, `deletarPerfil()`.
3. **Repositório Impl (`repositories/autenticacao_repository_impl.dart`):**
   - Implementa a geração do Salt e o Hash Criptográfico para o cadastro.
   - Compara o Hash gerado na tentativa de login com o `verificadorSenha` salvo.

### Camada de Apresentação (`lib/features/autenticacao/presentation/`)
1. **Tela T01 (`pages/login_page.dart`):**
   - Utiliza um `StatefulWidget` ou integração com a gerência de estado (Bloc/Controller) para alternar entre "Cadastro" e "Login" dependendo da existência prévia do perfil.
   - **Integração com Design System (`core_ui.md`):**
     - Botão principal "Entrar" / "Criar Perfil": `ElevatedButton` com cor `Primary` (#7C3AED) e bordas arredondadas (Radius 12-16px).
     - Campos de texto (`TextFormField`): Bordas delineadas sutis, assumindo a cor `Primary` no foco. Incluir ícone (trailing) para exibir/ocultar a senha.
     - Tipografia: Usar `HeadlineSmall` para o título de boas-vindas.
     - Cores de fundo adaptáveis (`Theme.of(context).colorScheme.background`).

## 4. Instruções ao Agente de IA
1. Garanta que as dependências `flutter_secure_storage`, `crypto` e `freezed_annotation` estão no `pubspec.yaml`.
2. Gere os arquivos de domínio puros sem referências a pacotes de terceiros (exceto freezed).
3. Implemente a lógica de hashing de maneira estrita na camada de dados (`autenticacao_repository_impl.dart`).
4. Construa a tela T01 respeitando os tokens visuais base já definidos. Trate estados de carregamento (desabilitando o botão para evitar duplos cliques) e exiba mensagens de erro no `SnackBar` caso a senha esteja incorreta.
