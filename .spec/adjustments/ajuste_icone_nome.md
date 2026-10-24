# Especificação de Ajuste: Nome e Ícone do Aplicativo
**Caminho do Arquivo:** `.spec/adjustments/ajuste_icone_nome.md`

## 1. Contexto e Objetivo
O aplicativo atualmente utiliza a marca e a nomenclatura padrão geradas pelo Flutter (`meu_bolso` e o ícone do Flutter). Este ajuste tem como objetivo alterar o nome de exibição (display name) do aplicativo para **"Meu Bolso"** e configurar a logomarca oficial, presente em `assets/logomarca_meu_bolso.png` como ícone nativo nas plataformas Android e iOS, adequando as dimensões ao ideal de ícones.

## 2. Alteração do Nome do Aplicativo
O nome que aparece abaixo do ícone na tela inicial do celular deve ser alterado nativamente.

*   **Android:**
    *   Arquivo: `android/app/src/main/AndroidManifest.xml`.
    *   Ação: Alterar a propriedade `android:label` da tag `<application>` de `"meu_bolso"` para `"Meu Bolso"`.
*   **iOS:**
    *   Arquivo: `ios/Runner/Info.plist`.
    *   Ação: Alterar o valor das chaves `CFBundleDisplayName` e `CFBundleName` para `Meu Bolso`.

## 3. Alteração do Ícone do Aplicativo
Para garantir que os ícones sejam gerados em todas as resoluções necessárias para Android e iOS sem intervenção manual, a implementação deve utilizar o pacote `flutter_launcher_icons`.

*   **Configuração Inicial:**
    *   Adicionar a imagem da logomarca oficial do aplicativo na pasta de assets (exemplo: `assets/icons/app_icon.png`).
*   **Dependências:**
    *   Adicionar o pacote `flutter_launcher_icons` na seção `dev_dependencies` do `pubspec.yaml`.
*   **Configuração no `pubspec.yaml`:**
    *   Adicionar o bloco de configuração do `flutter_launcher_icons` informando o caminho do asset criado:
      ```yaml
      flutter_launcher_icons:
        android: "launcher_icon"
        ios: true
        image_path: "assets/icons/app_icon.png"
      ```

## 4. Instruções de Execução para o Agente
1. Modifique os arquivos nativos (`AndroidManifest.xml` e `Info.plist`) para ajustar o nome do aplicativo.
2. Certifique-se de que a imagem oficial do ícone (no formato PNG, preferencialmente 1024x1024) esteja posicionada no diretório correto de assets.
3. Adicione e configure o `flutter_launcher_icons` no `pubspec.yaml`.
4. Execute o comando de geração de ícones no terminal: `dart run flutter_launcher_icons`.
5. Utilize o padrão de verbos no infinitivo para o commit (ex: *atualizar nome e icone do aplicativo*).

## 6. Padrão de Commit

Para os commits relacionados a esta alteração, utilizar verbos no infinitivo, com mensagens curtas e descritivas.

Exemplos:

- `Ajustar nome do aplicativo para "Meu Bolso"`
- `Configurar icone do aplicativo`