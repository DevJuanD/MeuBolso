# Especificação de Design System: Tema e Componentes (Core UI)

## 1. Contexto e Objetivo

Esta especificação define o **Design System** do aplicativo "MeuBolso", traduzindo as diretrizes visuais e as telas de alta fidelidade em configurações nativas do Flutter (`ThemeData`, `ColorScheme` e Componentes do Material 3). O objetivo é garantir consistência visual, hierarquia clara ("Dados primeiro") e suporte nativo aos temas Claro e Escuro, reduzindo a carga cognitiva do usuário.

## 2. Cores e Semântica (Material 3 ColorScheme)

O aplicativo utiliza uma paleta focada em legibilidade e feedback financeiro rápido. Nunca utilize Verde e Vermelho apenas para decoração.

**Cores Base:**

- **Primary (Accent):** `#7C3AED` (Roxo) - Usado em botões principais, abas ativas, floating action buttons e ícones de destaque.
- **Positive (Verde):** `#22C55E` - Usado exclusivamente para receitas, saldo positivo e progresso.
- **Negative/Alert (Vermelho):** `#EF4444` - Usado exclusivamente para despesas, saldo negativo e ações destrutivas (ex: exclusão).

**Cores de Fundo (Dark Mode - Conforme Guia Original):**

- **Background:** `#0D0F12` (Fundo principal das telas)
- **Surface:** `#15181D` (Fundos de cards, modais e bottom sheets)
- **Textos:** `#F5F5F5` (Principal/Títulos) e `#8B919A` (Secundário/Legendas).

**Cores de Fundo (Light Mode - Conforme Telas Anexadas):**

- **Background:** `#FFFFFF` (Fundo principal)
- **Surface:** `#F8F9FA` ou `#F3F4F6` (Cards levemente destacados do fundo)
- **Textos:** `#1F2937` (Principal/Títulos) e `#6B7280` (Secundário/Legendas).

## 3. Tipografia (`TextTheme`)

A fonte padrão do aplicativo é a **Inter** (via pacote `google_fonts`). A hierarquia foca em destacar os números e totais.

- **Display / Saldo (DisplayLarge/Medium):** 32px a 40px, Peso: Bold.
- **Títulos de Tela (HeadlineSmall / TitleLarge):** 22px a 28px, Peso: Semibold.
- **Títulos de Cards/Itens (TitleMedium):** 15px a 17px, Peso: Semibold.
- **Corpo de Texto (BodyMedium):** 14px a 16px, Peso: Regular.
- **Legendas e Datas (LabelSmall):** 11px a 13px, Peso: Regular.

## 4. Estilos de Componentes (`ThemeData`)

### Botões (`ElevatedButtonTheme` e `TextButtonTheme`)

- **Formato:** Bordas arredondadas (Radius 12px a 16px).
- **Tamanho:** Altura mínima de `48px` a `56px` para facilitar o toque (área de clique).
- **Cores:** `ElevatedButton` com fundo Primary (`#7C3AED`) e texto branco. Botões de exclusão devem ter cor de fundo ou texto Negative (`#EF4444`).

### Cards e Superfícies (`CardTheme`)

- **Formato:** Bordas arredondadas (Radius 16px).
- **Elevação:** Zero ou muito sutil (0 a 2). O destaque deve ser feito pela cor `Surface` contrastando levemente com o `Background`, ou com uma borda extremamente sutil (ex: `#E5E7EB` no modo claro).
- **Padding Interno:** Geralmente `16px` a `20px`.

### Entradas de Texto (`InputDecorationTheme`)

- **Estilo:** Fundos preenchidos levemente ou bordas delineadas sutis (OutlineInputBorder com Radius 12px).
- **Foco:** Borda na cor Primary (`#7C3AED`) quando em foco.

### Bottom Navigation Bar (`BottomNavigationBarTheme`)

- **Ícones:** Tamanho padrão (24px).
- **Cores:** Ícone/Texto ativo na cor Primary (`#7C3AED`), inativos na cor Secundária/Cinza.
- **Itens:** Início, Transações, Resumo (Relatório).

## 5. Instruções de Execução para o Agente

1. Crie o arquivo `lib/core/theme/app_theme.dart` (ou ajuste no diretório principal equivalente estabelecido).
2. Adicione a dependência `google_fonts` no `pubspec.yaml`.
3. Defina duas constantes ou métodos geradores para `lightTheme` e `darkTheme` utilizando o `ThemeData` e `ColorScheme` do Material 3.
4. Mapeie as cores verdes e vermelhas em extensões do tema (`ThemeExtension`) ou diretamente na UI utilizando `const Color(0xFF22C55E)` e `const Color(0xFFEF4444)` para garantir que as cores de finanças não sejam distorcidas pela paleta primária.
5. Em toda a UI, **nunca faça hardcode de cores** para os textos e fundos. Utilize sempre `Theme.of(context).colorScheme.surface`, etc., para garantir o funcionamento automático da inversão claro/escuro.
