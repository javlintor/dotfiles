# General rules

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

# Code specific style

## Python

### Naming

- **No abbreviations.** Use full, descriptive names for all variables, functions, and classes.
  - ✅ `data_access_manager = DataAccessManager()`
  - ❌ `dam = DataAccessManager()`

### Functions and Methods

- Split code into small, focused functions or methods.
- Type all function arguments and return values.
- **Maximum 3 parameters per function or method.** If more are needed, define an input DTO or dataclass using Pydantic.
- **No boolean-typed positional arguments** in function definitions.
- **Never define functions or methods inside other functions or methods**, except for lambda expressions.
- **No side effects** in any function or method.

### Variables

- **Only create variables at global/module level** — never inside nested scopes unless they are local to a function.
- **Assign complex expressions to a named variable** before using them as keyword arguments. Never inline expressions directly in keyword arguments.
  - ✅ `file_name = f"report_{date}.csv"` then `save(file_name=file_name)`
  - ❌ `save(file_name=f"report_{date}.csv")`

### Calling Functions

- **Always use explicit keyword arguments** when calling a function (unless passing a default value).
  - ✅ `f(arg_1=foo, arg_2=bar)`
  - ❌ `f(foo, bar)`
- **Do not explicitly pass default values.** If a parameter has a default, omit it from the call unless you are overriding it.
  - Given `def f(a: int = 1): ...`
  - ✅ `f()`
  - ❌ `f(a=1)`

### Type Annotations

- **Never use bare `dict` as a type annotation.** Always specify key and value types.
  - ✅ `dict[str, DomainModel]`
  - ❌ `dict`
- **Do not quote type annotations** unless strictly necessary (e.g., forward references that cannot be resolved at runtime).
- **Do not use `from __future__ import annotations`** if the project is on Python ≥ 3.13.

### Imports

- **Always sort imports.**
- Place imports only used for type annotations (not at runtime) inside a `TYPE_CHECKING` block, after all runtime imports.

```python
from dataclasses import dataclass
from typing import TYPE_CHECKING
import streamlit as st
from component_commons.jira_support_button import jira_floating_button
from apps.ops_washing.page.administration_panel.access_manager import (
    AdministrationPanelAccessManager,
)
from apps.ops_washing.page.administration_panel.tabs import (
    BudgetTab,
    ClosureTab,
    MachinesTab,
    ShiftsTab,
    ShiftTargetsTab,
    WashLinesTab,
)

if TYPE_CHECKING:
    from collections.abc import Callable
    from streamlit.elements.lib.mutable_tab_container import TabContainer
```

### Dates and Times

- **Never use `datetime.date.today()`** (violates ruff rule DTZ011).
- Use timezone-aware alternatives instead:

```python
from datetime import datetime, UTC

datetime.now(tz=UTC).date()
```
