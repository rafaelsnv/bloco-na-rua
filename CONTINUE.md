# CONTINUE — retomando este trabalho em outra máquina

Guia completo para continuar a sessão de refactor do design system do **Bloco na Rua** em outra máquina. Todos os fatos abaixo são verificados — não re-investigue.

---

## 1. Estado do repo

- **Branch:** `refactor/design-system-fixes`
- **Commits feitos:**
  - `ac9c2bc` — `refactor(ui): canonicalize design tokens and core widgets`
  - `f7ceb50` — `chore: wip checkpoint...`
  - `f0ef1e8` — `Update userJourney.mmd`
- **NÃO commitado de propósito:** as ondas C+D (~50 arquivos modificados sob `lib/ui/**`, +1146/-1000). O usuário disse: *"when D2 is completed skip the commit for waves c+d, i'll do it later"* — quem comita é o usuário.
- **Arquivos untracked que devem entrar no commit do usuário:**
  - `test/ui/core/design_system_regression_test.dart`
  - `assets/logo/*.md`

## 2. Setup e validação

Projeto Flutter (UI pt-BR). Na última validação nesta máquina:

```bash
flutter analyze   # limpo
flutter test      # 34/34 passando
dart format       # limpo
```

- **Conta de teste:** `joao@teste.com` / `12345678` (verificada funcionando).
- ⚠️ O JWT da conta `teste@teste.com` foi deletado; senha desconhecida.

## 3. Reprodução de screenshots (se precisar reverificar visualmente)

- **Emulador:** `gphone16k x86_64`, package `br.com.bloconarua.app`, tela lógica 411x899.
- **Captura (binário-seguro, PowerShell):**
  ```powershell
  $adb = "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe"
  Start-Sleep -Seconds 1.5
  cmd /c "`"$adb`" exec-out screencap -p > <saida>.png"
  ```
- **Dirigir a UI:** Marionette/dart MCP. Builds debug standalone ficam pausados (`PauseStart`) até `adb forward tcp:<port> tcp:<port>` + resume do VM service.
- **Trocar tema:** Perfil → Aparência → Modo escuro.
- **Fluxo de telas + coordenadas de tap:** `app_screenshots/SCREENSHOTS.md`.

## 4. Trabalho pendente

### 4.1 Comparação BEFORE→AFTER incompleta

A análise AFTER (light+dark, 21 telas) está completa. A comparação BEFORE→AFTER foi feita para os chunks **01-03, 04-06, 10-12**. Faltam:

| Chunk | Telas AFTER | Baselines BEFORE (light) | Baselines BEFORE (dark) |
|---|---|---|---|
| C3-retry | 07, 08, 09 | 05-bloco-detalhes, 12-bloco-detalhes-encontro-criado, 13-encontro-detalhes | 10-bloco-detalhes, 14-bloco-detalhes-com-encontro, 15-encontro-detalhes |
| C5 | 13, 14, 15 | 10-time-picker, 06-editar-bloco, 07-adicionar-membro | 13-time-picker, 17-editar-bloco, 18-adicionar-membro |
| C6 | 16, 17, 18 | 14-encontros-tab, 15-perfil, 16-perfil-conta | 20-encontros-tab, 21-perfil, 22-perfil-conta |
| C7 | 19, 20, 21 | 01-login, 18-signup, 02-recuperar-senha | 01-login, 02-signup-validacao (não há baseline dark de recuperar-senha) |

Notas: 07/08 não têm baseline exata (são sub-estados rolados de bloco-detalhes — compare qualitativamente). 16 usa dados de `joao@teste.com` (diferença de dados, não bug). 19-21 são telas deslogadas. 13-time-picker é dialog stock do Flutter.

**⚠️ Bloqueio conhecido (última sessão):** o modelo que backinga os subagents nesta sessão (`combo/glm-5-3-flash-cheap`) **não suporta input de imagem** — os 4 chunks falharam e o `ImageSpecialist` também não conseguiu (usa o mesmo modelo por baixo). Os agentes recusaram corretamente fabricar findings. Na máquina nova, confirme que o subagent tem visão antes de disparar os chunks (probe: pedir para ler 1 PNG e descrever).

### 4.2 Receita de delegação (aprendizados críticos)

- `OpenFrontendSpecialist` funciona, mas **falha com HTTP 413 "Payload Too Large" se receber muitas imagens de uma vez** — chunks de ~10-12 PNGs por delegação funcionam (provado repetidamente).
- Um probe trivial sem tools confirma se o agente está saudável; um probe de leitura de 1 PNG confirma se tem visão.
- A config do agente fica em `C:\Users\rafae\.config\opencode\agent\subagents\development\frontend-specialist.md` — a dependência `skill:ui-ux-pro-max` foi removida (skill de 3.6MB estourava o payload). Backup do original: `C:\Users\rafae\AppData\Local\Temp\opencode\frontend-specialist.md.bak`. **Configs de agente são snapshotadas no início da sessão — edições só valem em sessão NOVA.**
- Já visto uma vez: `Token Plan usage limit reached (2056)` — espace lotes grandes de imagens.
- Padrão de prompt que funcionou: ANALYSIS ONLY, sem plan files, sem ContextScout; veredito por tela IMPROVED/UNCHANGED/REGRESSION + caçar regressões ativamente; fixes só com nomes reais de tokens.

### 4.3 Consolidar o relatório

Consolidar TODOS os findings (das delegações concluídas + resumo abaixo) em `app_screenshots/ANALYSIS_REPORT.md`, no formato do brief (`ANALYSIS_BRIEF.md`): severidades Critical/High/Medium/Low, vereditos por tela, paridade dark, seção "o que melhorou", exceções conhecidas (pickers stock, dados do 16, 19-21 deslogado, persistência de tema separada).

**Findings já consolidados (dos chunks concluídos — base para o relatório):**

Recurrentes High/Critical:
- **CTA desabilitado parece habilitado** (11-criar-encontro, 14-editar-bloco, 19-login, 20-cadastro, 04-criar-bloco): `AppButton._disabledFill` = `surfaceContainerHigh` + `_disabledInk` via `AppColors.inkFor` → contraste ~14.7:1 light / ~9.4:1 dark, elemento mais brilhante da tela. **TENSÃO:** o ink derivado do fill é invariante conhecida-boa (corrigiu uma falha real de 2.0:1); os analistas preferem ink `textDisabled/textDisabledDark`. **Decisão de design para o USUÁRIO — não mudar unilateralmente; o teste de regressão pinia parte desse comportamento.**
- **Barras do speed-dial cortadas na borda esquerda + sobrepõem o último card** (03-blocos-fab-expandido, ambos os temas): barras full-width do `AppButton` no `AddBlockFab` passam do viewport; a borda superior da barra 1 corta o card "Bloco 13". Direção do fix: largura de conteúdo (`MainAxisSize.min`) alinhado à direita acima do FAB + bottom padding `Spacing.space_2xl` na lista. Antes do refactor eram pills alinhadas à direita (**REGRESSION vs baseline**).
- **Truncamento do título do app bar "Detalhes do …"** (06/07/08, ambos os temas): título `headlineMedium` + 2 actions não deixam espaço. Fix: `headlineSmall`/`titleLarge` para o título do appBar ou overflow menu.
- **Badge de lápis do avatar invisível** (17-perfil): badge light 2.1:1, dark 1.6:1 vs fill do avatar; ink do lápis 3.3:1. Fix: fill de superfície + anel primário 1.5px, ink via `AppColors.inkFor(badgeFill)`.
- **Contraste de texto accent no dark** (01-home): "Ver todos" `AppColors.primary` sobre `backgroundDark` ≈3.1-4.2:1 → usar `AppColors.primaryLight` (6.5:1). "Olá!" mesmo problema (Low).
- **Contraste do glifo do hero-circle** (04/05): branco sobre `primaryLight` 2.7:1 light; `primaryLight` sobre `primary` 2.1:1 dark.
- **Contraste do floating label** (04/05/14): label `primaryLight` 2.7:1 no branco → `AppColors.primary` (5.5:1). No 14-editar-bloco o label colide com a borda superior do input.
- **Chip de status / ink de info**: chip "Realizada" branco-sobre-success ≈3.3:1 (09); "Moderadores" `AppColors.info` no branco 2.8:1 (07/08) → `AppColors.infoHeadingLight` #0369A1.
- **16-encontros**: borda/fill do campo de busca off-token (`textSecondary`/`surfaceContainerHighest` — analistas suspeitam que a captura é anterior a uma mudança no inputDecorationTheme; **VERIFICAR contra o `app_theme.dart` atual antes de reportar**); cards de encontro sem chip de confirmação + nome do bloco (limitação de dados/entidade); `AddBlockFab` (speed-dial de bloco) aparece na tab de encontros — FAB errado para aquela tela.
- **17-perfil**: switch OFF invisível no light (track vs card 1.06:1 — o tema não tem switchTheme); 17 light rolado ~85px vs dark 17 (artefato de captura); "Sair da conta" cortado pela bottom nav no dark (falta bottom padding).
- **18-perfil-conta**: o AlertDialog de logout está AUSENTE nas duas capturas — a captura não tocou no botão (ou `AppDialog.confirm` não é alcançado). Re-capturar antes de acreditar em bug de dialog. Ação destrutiva estilizada como secondary positiva (violeta) em vez de `AppColors.error`.
- **19-21 (auth)**: link de cancelar no dark `primaryLight` sobre `surfaceContainerHighDark` 3.47:1 (21); superfície do modal dark é um bloco cinza chapado (`surfaceContainerHighDark`) → sugerir `surfaceDark` + `AppElevation.lg`; "Enviar" dark usa `accentLight` #FBBF24 (o bloco mais barulhento); superfície do modal light `surfaceContainerHighLight` (tinta violeta) destoa dos cards brancos; barrier é o default `Colors.black54`, não `AppColors.scrim`; título do login centralizado vs signup alinhado à esquerda. VERIFICADO BOM: sem validação prematura no primeiro frame, erros por campo só após toque, wording de esqueci-senha correto.
- **Pickers stock (12/13)**: hora selecionada no time-picker dark com ink `primaryLight`-ish sobre `primary` saturado ≈2.1:1 (13) — theming stock do Flutter, prioridade baixa; só tematizável via `datePickerTheme`/`timePickerTheme`.
- **Nota de token de um agente** (verificar antes de agir): alega que `inkFor(primaryLight #A78BFA)` retorna branco (luminance 0.336 < 0.4) → branco sobre #A78BFA 2.7:1. **NÃO abaixar o threshold 0.4 (invariante)** — se for real, corrigir nos call sites.
- **Claim não verificado**: um agente reportou um "botão circular near-black de hambúrguer no canto inferior direito" nas capturas 04/05 AFTER, ausente no BEFORE. Não casou com nenhum código — inspecionar uma captura antes de tratar como real (pode ser overlay do emulador).

O que está bom agora (seção positiva do relatório): app bar flat unificado + hairline 1.5px + `headlineMedium`; elevação única de card (`AppElevation.sm`) + gutters consistentes de 16px; superfícies dark devidamente escalonadas (#111827→#1F2937→#475569), containers muted (#3B1220/#0E3540) lendo 8-11:1; ink near-black do CTA accent 5.44:1/9.53:1; pares da paleta de avatares AA-compliant; FAB diamond corrigido (rotação só no ícone, alvo 48px, ações colapsadas com IgnorePointer); primeiro frame do auth limpo.

## 5. Mapa de design tokens

- **`AppColors`** — `lib/ui/core/tokens/app_colors.dart` (único lugar com literais `Color(0x`).
- **`AppColors.inkFor(fill)`** — regra única de luminância, threshold `0.4` (`inkLuminanceThreshold`).
- **`AppElevation`** — `lib/ui/core/tokens/app_elevation.dart` (none/sm/md/lg/xl/xxl).
- **`Radii`** — `lib/ui/core/tokens/app_radius.dart` (`outlineWidth` 1.5).
- **`Spacing` + `AppIconSizes`** (14/16/20/24/28/32/40/44/48) — **ambos vivem em `lib/ui/core/tokens/app_spacing.dart`** (não existe `app_icon_sizes.dart` — um agente procurou errado).
- **Tipografia** — `lib/ui/core/tokens/app_typography.dart` (Sora + DM Sans).
- **`AppTextColors`** — extension em `lib/ui/core/theme/app_text_colors.dart`.

## 6. Invariantes que NÃO devem ser desfeitos

- `AppElevation` é a única escala de elevação.
- `AppColors.inkFor` (threshold 0.4) é a única regra de luminância.
- `Radii.outlineWidth = 1.5`.
- `AppIconTile` é o único icon-tile.
- `AppStateView` respalda `AppEmpty`/`AppError`.
- `AppSpinner` respalda todos os spinners.
- Ink da variante accent = `AppColors.textPrimary` nos dois modos.
- Ink desabilitado (filled) derivado do fill desabilitado via `inkFor` — corrigiu falha real de 2.0:1 (ver tensão do CTA desabilitado na seção 4.3).

**Grep invariants** (devem continuar passando):
- `Color(0x` só em `app_colors.dart`
- nenhum `import '..` (relativo) em `lib/ui/`
- nenhum `AppCardElevation`/`AppMotion`/`Colors.white`
- nenhum `AlertDialog(`/`showDialog(`/`SnackBar(` raw fora dos core widgets
- `computeLuminance` só em `app_colors.dart`

## 7. Issues abertos

1. **Bug de persistência de tema (aberto, NÃO corrigido):** a pref `THEME_MODE` armazenada não é respeitada no startup; o app cai no tema do sistema. `ThemeCubit.load()` existe (`lib/ui/core/theme/theme_cubit.dart`); suspeita é ordem de carga vs build do MaterialApp. Na última sessão o app ficou em tema light, emulador com `ui_night_mode=1`.
2. **Decisão de design pendente (usuário):** ink do CTA desabilitado — derivado do fill (atual, invariante) vs `textDisabled` (preferência dos analistas). Ver seção 4.3.
3. **Claim não verificado:** "botão circular near-black de hambúrguer" nas capturas 04/05 AFTER — inspecionar antes de tratar como real.

## 8. Ordem de trabalho sugerida na máquina nova

1. `git status` + confirmar branch `refactor/design-system-fixes` e as ~50 modificações não commitadas sob `lib/ui/**`.
2. `flutter analyze && flutter test` — esperar limpo/34 passando.
3. Probe de visão do subagent (1 PNG). Se tiver visão: rodar os 4 chunks pendentes (C3-retry, C5, C6, C7) com a receita da seção 4.2, em paralelo (~4 por vez), retry serial se 413/Token-limit.
4. Consolidar `app_screenshots/ANALYSIS_REPORT.md` (formato do `ANALYSIS_BRIEF.md`) com os findings da seção 4.3 + resultados dos chunks.
5. **Nenhuma mudança de código sem perguntar o usuário antes** — esta fase é análise + docs. Não commitar nada (ondas C+D são do usuário).

## 9. Estrutura de `app_screenshots/`

- `ANALYSIS_BRIEF.md` — brief da análise (formato do relatório)
- `SCREENSHOTS.md` — fluxo de telas, coordenadas de tap, armadilhas
- `screenshots-refactor\{light,dark}\` — 21 capturas cada (AFTER)
- `screenshots-light\` — 22 capturas (BEFORE)
- `screenshots-dark\` — 22 capturas (BEFORE)
