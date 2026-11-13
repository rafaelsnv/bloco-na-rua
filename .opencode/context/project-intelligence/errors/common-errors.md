<!-- Context: project-intelligence/errors/common-errors | Priority: medium | Version: 1.0 | Updated: 2026-05-04 -->

# Common Errors

**Quick Reference**: Error → Fix mappings.

---

## Errors

| Error | Fix |
|-------|-----|
| `undefined_getter` on model field | Update to new field name |
| `missing_required_argument` | Add missing constructor arguments |
| `non_exhaustive_switch_statement` | Add all enum cases |
| Type mismatch in `.g.dart` | Regenerate with build_runner |
| `unawaited_futures` | Add `await` or suppress with `// ignore:` |