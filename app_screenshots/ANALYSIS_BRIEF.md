# UI/UX analysis brief — design-system refactor (Bloco na Rua)

Repo: `C:\repos\bloco-na-rua` (Flutter, pt-BR UI, Android captures at 411x899 logical).
Branch: `refactor/design-system-fixes` (refactor is uncommitted in the working tree).
Task: ANALYSIS ONLY. Do not modify code, do not edit files, do not run migrations.
Produce a concise, ranked findings report in markdown.

## Image sets

AFTER the refactor (read every file in both dirs):
- `C:\repos\bloco-na-rua\.tmp\app_screenshots\screenshots-refactor\light\*.png` (21 files)
- `C:\repos\bloco-na-rua\.tmp\app_screenshots\screenshots-refactor\dark\*.png` (21 files)

File names (identical in both dirs):
`01-home, 02-blocos, 03-blocos-fab-expandido, 04-criar-bloco, 05-entrar-em-bloco,
06-bloco-detalhes, 07-bloco-detalhes-membros, 08-bloco-detalhes-avatares,
09-encontro-detalhes, 10-encontro-presencas, 11-criar-encontro, 12-date-picker,
13-time-picker, 14-editar-bloco, 15-adicionar-membro, 16-encontros, 17-perfil,
18-perfil-conta, 19-login, 20-cadastro, 21-esqueci-senha`

BEFORE the refactor (baselines):
- `C:\repos\bloco-na-rua\.tmp\app_screenshots\screenshots-light\*.png`
- `C:\repos\bloco-na-rua\.tmp\app_screenshots\screenshots-dark\*.png`

Context file: `C:\repos\bloco-na-rua\.tmp\app_screenshots\SCREENSHOTS.md` (flows).

## What the refactor claimed (verify visually, do not trust it)

- Single elevation scale (`AppElevation`: none/sm/md/lg/xl/xxl); AppCard defaults to `sm`.
- Single luminance rule for ink on coloured fills (`AppColors.inkFor`, threshold 0.4).
- Accent CTA ink: white → near-black `AppColors.textPrimary` on amber `#D97706` (claimed 5.44:1 vs 3.19:1).
- Avatar initials ink: was white on every palette fill; now paired per fill (white on violet/magenta, near-black on gold/green/cyan) to clear WCAG AA 4.5:1.
- App bar unified: surface + 1.5px hairline bottom border, elevation 0, canonical `headlineMedium` title.
- Dark containers de-saturated (`#3B1220`, `#0E3540`).
- AppSectionHeader no longer adds its own padding; meeting-details unified to one 16px left edge (was 3).
- FAB: 45° rotation applies to the ICON only (was rotating the whole FAB into a diamond), diameter ≥ 48px, shared elevation; dead `AppFabColor` accent/tertiary variants deleted (FAB is always theme-primary).
- Collapsed speed-dial buttons are `IgnorePointer` (no longer swallow FAB taps).
- Status chip ("Realizada"/"Próxima") moved into the same Row as the title (no overlap).
- Auth forms: no errors on first frame; per-field errors after touch/submit; forgot-password wording fixed.
- Secondary button ink = `colorScheme.primary`; outline width 1.5px; disabled buttons use a neutral fill + readable ink.
- Raw `SnackBar`/`AlertDialog` replaced by `AppSnackbar`/`AppDialog`; double-`Material` removed; dead motion tokens deleted; relative imports replaced.
- `AppIconTile` is the only icon-tile component; `AppStateView` backs `AppEmpty`/`AppError`; `AppSpinner` backs all spinners.

## Deliverables

1) Per-screen walkthrough of the AFTER captures (light + dark): clipped/overlapping text, misaligned rows, inconsistent left edges, contrast failures (estimate text vs background luminance), inconsistent radii, inconsistent icon sizes, unbalanced padding, chip/badge collisions, FAB overlap, unreadable muted text, muddy or too-bright dark surfaces, wrong disabled/focus states.
2) BEFORE → AFTER per screen: improved / unchanged / REGRESSION. Actively hunt for regressions.
3) Dark-mode parity: same layout, spacing, hierarchy, component structure across every screen pair; flag structural differences.
4) Ranked findings (Critical / High / Medium / Low). Each: file name, what is wrong, why it matters, concrete fix using the app's own tokens — AppColors (primary #7C3AED, secondary #E11D74, accent #D97706, tertiary #0E7490, success #16A34A, warning #F59E0B, error #DC2626, info #0EA5E9 + light/dark surface & text scales), AppTextColors, AppElevation (none/sm/md/lg/xl/xxl), Radii (none/xs/sm/md/lg/xl/full, outlineWidth 1.5), Spacing (2/4/8/12/16/24/32/48/64/80/96), AppIconSizes (14/16/20/24/28/32/40/44/48). Do not invent token names that do not exist.
5) Short "what is now good" section (2-5 bullets).

## Known exceptions (not defects)

- `12-date-picker` / `13-time-picker` are STOCK Flutter DatePicker/TimePicker dialogs, not the app's design system — captured for completeness; only note if they clash badly with the app dialog style.
- `16-encontros` (both dirs) shows `joao@teste.com` data (2 meetings) while 01-15/17-18 show `teste@teste.com` data — data difference, not a UI bug; compare light/16 only with dark/16.
- 19-21 are logged-out screens in both themes.
- Known open issue already reported separately: theme persistence is unreliable (stored `THEME_MODE` not honoured at startup; app falls back to the system theme). Mention only if it shows up visually (a capture in the wrong theme).

## Output format

Markdown, concise, findings-first, no essays.
`[Severity] screen-file — problem → recommended fix`
