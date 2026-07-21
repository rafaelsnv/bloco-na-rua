"""Builds task.json and 28 subtask JSONs for fix-review feature."""
import json
import os

BASE = r"C:\Repos\bloco-na-rua\.tmp\tasks\fix-review"

CONTEXT_FILES = [
    ".opencode/context/paths.json",
    ".opencode/context/standards/overrides.md",
    ".opencode/context/standards/references.md",
    ".opencode/context/project-intelligence/concepts/bloc-state-pattern.md",
    ".opencode/context/project-intelligence/concepts/freezed-entity.md",
    ".opencode/context/project-intelligence/concepts/dio-pipeline.md",
    ".opencode/context/project-intelligence/concepts/result-handling.md",
    ".opencode/context/project-intelligence/guides/adding-feature.md",
    ".opencode/context/project-intelligence/technical-component-pattern.md",
    ".opencode/context/project-intelligence/decisions-log.md",
    ".opencode/context/project-intelligence/lookup/naming-conventions.md",
    ".opencode/context/standards/flutter-state-management.md",
    ".opencode/context/standards/flutter-ui-patterns.md",
    "~/.config/opencode/context/core/standards/code-quality.md",
    "~/.config/opencode/context/core/standards/dart.md",
    "~/.config/opencode/context/core/standards/security-patterns.md",
    "~/.config/opencode/context/core/development/principles/clean-code.md",
]

def write(name, data):
    path = os.path.join(BASE, name)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"wrote {name}")

# stub
print("loaded builder module")