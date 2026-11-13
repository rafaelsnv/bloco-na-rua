<!-- Context: project-intelligence/mcp-tools-figma | Priority: high | Version: 1.1 | Updated: 2026-05-06 -->

# Figma MCP Tools

**Purpose**: Design-to-code workflow, design review, QA verification
**Audience**: AI agents implementing UI from designs, performing design review

## Quick Reference

| Tool | Purpose |
|------|---------|
| `figma_mcp_get_screenshot` | Capture design screenshot for review |
| `figma_mcp_get_design_context` | Get code reference + metadata for widget creation |
| `figma_mcp_get_metadata` | Get node structure (ID, type, name, position) |
| `figma_mcp_get_variable_defs` | Extract design tokens (colors, fonts, spacing) |
| `figma_mcp_create_design_system_rules` | Generate design system rules |
| `figma_mcp_get_figjam` | Generate UI code from FigJam nodes |

## Screenshot

```javascript
// Generate screenshot of a node or full page
figma_mcp_get_screenshot({
  nodeId: "123:456",      // From Figma URL ?node-id=XXX:YYY
  contentsOnly: false     // true=node only, false=full page
})
```

**Figma URL format**: `https://figma.com/design/:fileKey/:fileName?node-id=123:456`

**Use cases**:
- Design review: Compare implementation with expected design
- QA verification: Confirm visual output matches design
- Bug comparison: Before/after screenshot comparison

## Design Context (Code Generation)

```javascript
// Get code reference, screenshot, and metadata for design-to-code
figma_mcp_get_design_context({
  nodeId: "123:456",
  artifactType: "WEB_PAGE_OR_APP_SCREEN",
  // Options: WEB_PAGE_OR_APP_SCREEN | COMPONENT_WITHIN_A_WEB_PAGE | REUSABLE_COMPONENT | DESIGN_SYSTEM
  clientFrameworks: "flutter",
  clientLanguages: "dart",
  forceCode: false  // true=always return code, false=return metadata if too large
})
```

**artifactType options**:
| Value | Use |
|-------|-----|
| `WEB_PAGE_OR_APP_SCREEN` | Full screen/page |
| `COMPONENT_WITHIN_A_WEB_PAGE` | Component on a page |
| `REUSABLE_COMPONENT` | Standalone reusable component |
| `DESIGN_SYSTEM` | Design system tokens and rules |

**clientFrameworks**: flutter, react, vue, django, unknown, etc.
**clientLanguages**: dart, typescript, javascript, etc.

## Metadata (Node Structure)

```javascript
// Get node overview (ID, type, name, position, size)
figma_mcp_get_metadata({
  nodeId: "123:456",
  clientFrameworks: "flutter",
  clientLanguages: "dart"
})
// Returns: Node ID, layer type, name, position, size
```

**Use**: Understand component hierarchy before code generation.

## Variable Definitions (Design Tokens)

```javascript
// Get design tokens (colors, fonts, spacing)
figma_mcp_get_variable_defs({
  nodeId: "123:456",
  clientFrameworks: "flutter",
  clientLanguages: "dart"
})
// Returns: { "color/primary": "#FF5733", "spacing/md": "16px" }
```

**Use**:
- Extract design tokens for theme implementation
- Map Figma variables to Flutter theme
- Update theme files with design values

## Design System Rules

```javascript
// Generate design system rules for this repo
figma_mcp_create_design_system_rules({
  clientFrameworks: "flutter",
  clientLanguages: "dart"
})
```

## FigJam (Whiteboard to Code)

```javascript
// Generate UI code from FigJam whiteboard nodes
figma_mcp_get_figjam({
  nodeId: "123:456",
  includeImagesOfNodes: true  // Include rendered images
})
```

**Use**: Convert whiteboard ideas and wireframes to code.

## Workflow Sequences

### Design Review
```
1. figma_mcp_get_screenshot → capture expected design
2. dart_mcp_launch_app → run app
3. Compare visual output with design screenshot
```

### Design-to-Code (Widget Creation)
```
1. figma_mcp_get_design_context → get code reference + screenshot
2. figma_mcp_get_variable_defs → extract design tokens
3. Adapt generated code to Flutter/Cubit patterns
4. Update theme files with design tokens
```

### Design Token Extraction
```
1. figma_mcp_get_variable_defs → get all design tokens
2. Map to Flutter theme:
   - Colors → lib/ui/core/colors/app_colors.dart
   - Typography → lib/ui/core/theme/light_theme.dart
   - Spacing → lib/ui/core/theme/app_theme.dart
```

### QA Verification
```
1. figma_mcp_get_screenshot → capture design
2. Implement feature
3. Run app (dart_mcp_launch_app)
4. Compare visual output with design
```

## Common Errors

| Error | Fix |
|-------|-----|
| "Node not found" | Check nodeId format (must be `XXX:YYY`) |
| "Invalid file" | Ensure URL is Figma design, not FigJam (use figma_mcp_get_figjam) |
| "Framework mismatch" | Set correct clientFrameworks/clientLanguages |
| "Empty result" | Try with contentsOnly: true for smaller nodes |

## Figma URL Reference

```
https://figma.com/design/:fileKey/:fileName?node-id=123:456
                                       └── nodeId: 123:456
```

**Extract nodeId**: From URL `?node-id=XXX:YYY` → use `XXX:YYY`

## Codebase References

| Pattern | File |
|---------|------|
| Theme | `lib/ui/core/theme/light_theme.dart`, `lib/ui/core/theme/dark_theme.dart` |
| Colors | `lib/ui/core/colors/app_colors.dart` |
| Widgets | `lib/ui/core/widgets/` |

## Usage

AI agents should use these tools when:
- User asks to "implement from Figma" or "create from design"
- User provides a Figma URL for a screen/component
- User asks to "verify design implementation" or "compare with design"
- User asks to "extract design tokens" or "update theme"
- QA: confirming visual output matches expected design

**Note**: Project-specific context overrides these generic patterns.
