<!-- Context: project-intelligence/mcp-tools-figma | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Figma MCP Tools — BlocoNaRua

**Purpose**: Design-to-code workflow for mobile UI. Notes project-specific to BlocoNaRua's actual theme structure.

## Quick Reference

| Tool | Purpose |
|------|---------|
| `figma_mcp_get_screenshot` | Capture design screenshot for review |
| `figma_mcp_get_design_context` | Get code reference + metadata for widget creation |
| `figma_mcp_get_metadata` | Get node structure (ID, type, name, position) |
| `figma_mcp_get_variable_defs` | Extract design tokens (colors, fonts, spacing) |
| `figma_mcp_create_design_system_rules` | Generate design system rules |
| `figma_mcp_get_figjam` | Generate UI code from FigJam nodes |

## Project-Specific Paths

When extracting design tokens, map to BlocoNaRua's actual theme files:

| Pattern | Path |
|---------|------|
| Theme colors / typography | `lib/ui/core/theme/bloco_na_rua_theme.dart` |
| Light theme             | `BlocoNaRuaTheme.lightTheme` (in same file) |
| Dark theme              | `BlocoNaRuaTheme.darkTheme` (in same file) |
| Custom colors           | `lib/ui/core/colors/`                  |
| Shared widgets          | `lib/ui/core/widgets/`                 |
| Per-feature widgets      | `lib/ui/{feature}/widgets/`             |

**Important**: This project uses a SINGLE theme class (`BlocoNaRuaTheme`), NOT separate `light_theme.dart` / `dark_theme.dart` files like the generic template assumes.

## Design-to-Code Workflow

```
1. figma_mcp_get_design_context → get code + screenshot
2. figma_mcp_get_variable_defs → extract design tokens
3. Map tokens → BlocoNaRuaTheme.lightTheme
4. Adapt code to Cubit pattern (see examples/state-pattern.md)
5. Place widget in lib/ui/{feature}/widgets/
```

## Codebase References (actual paths)

| Pattern | File |
|---------|------|
| Theme | `lib/ui/core/theme/bloco_na_rua_theme.dart` |
| Light theme | `BlocoNaRuaTheme.lightTheme` |
| Dark theme  | `BlocoNaRuaTheme.darkTheme` |
| Custom colors | `lib/ui/core/colors/` |
| Shared widgets | `lib/ui/core/widgets/` |
| Per-feature widgets | `lib/ui/{feature}/widgets/{feature}_screen.dart` |

## Mobile vs Desktop

- All Figma references must be `artifactType: "WEB_PAGE_OR_APP_SCREEN"` with mobile dimensions
- Mobile-first means: take phone viewport screenshots (e.g., 375x812, 412x915)
- Comparison runs against Android emulator or iOS simulator (see `mcp-tools-dart.md`)

## Common Errors

| Error | Fix |
|-------|-----|
| "Node not found" | Check `nodeId` format (`XXX:YYY`) |
| "Invalid file" | Ensure URL is Figma design, not FigJam |
| "Framework mismatch" | Set `clientFrameworks: "flutter"`, `clientLanguages: "dart"` |
| "Empty result" | Try `contentsOnly: true` for sub-nodes |

## Usage

AI agents should use these when:
- User asks to "implement from Figma" or "create from design"
- User provides a Figma URL for a screen/component
- User asks to "verify design implementation"
- User asks to "extract design tokens" or "update theme"

**Note**: BlocoNaRua-specific paths override any generic Flutter references.
