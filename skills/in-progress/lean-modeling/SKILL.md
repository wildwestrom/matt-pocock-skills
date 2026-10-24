---
name: lean-modeling
description: Build and sharpen a project's Lean spec. Use when discussing codebase terminology, writing or editing the Lean spec, or recording a design decision.
---

# Lean Modeling

Actively build and sharpen the project's Lean spec as you design: challenging names, inventing edge-case scenarios, and getting each decision into the spec the moment it settles. [LEAN.md](./LEAN.md) is how the spec is written.

## File structure

```
/
├── README.md              ← lists the spec files in reading order
├── spec/
│   ├── lakefile.toml
│   ├── lean-toolchain
│   └── Spec/
│       ├── Session.lean
│       └── Order.lean
├── docs/
│   └── adr/               ← shell decisions only
└── src/
```

Create files lazily: only when you have something to write. If no Lean project exists, ask the user two questions before the first decision goes to the Lean writer: where the spec lives (`spec/` at the repo root unless they say otherwise), and whether it depends on Mathlib. The Lean writer sets it up from there. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the spec

When the user uses a term that conflicts with a name in the spec, call it out immediately. "The spec's `Order.cancel` cancels the whole order, but you seem to mean one line of it. Which is it?" Read the spec's definitions, docstrings, and claim statements; the proofs are the Lean writer's.

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical name. "You're saying 'account': do you mean the `Customer` or the `User`? Those are different types."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts. A scenario the user settles goes to the Lean writer with its decision, as an example to pin.

### Cross-reference with code

When the user states how something works, check whether the code agrees, and whether the code keeps the spec's claims. If you find a contradiction, surface it: "Your code cancels entire Orders, but `Order.cancel_keepsOtherLines` says partial cancellation is possible. Which is right?"

### Hand decisions to the Lean writer

When a decision settles, dispatch a **Lean writer** subagent in the background with the decision in English, the names agreed for it, and the full path of [LEAN.md](./LEAN.md). Don't batch these up: dispatch as they happen. The Lean stays out of your context: you hold the decisions, the Lean writer fights the type checker.

The Lean writer:

- sets up the Lean project, if there is none, as `LEAN.md` says;
- adds the definitions and claims the decision implies;
- tries cheap proofs (`decide`, `simp`, `omega`) and leaves the rest as `sorry`;
- stops when `lake build` passes with every statement typechecking;
- reports only the names and statements it added, each marked proved or open, and every **forced question**: a decision the model needed that the user has not made. It never answers one itself.

Put each forced question to the user.

### Record rejected alternatives sparingly

Only record a rejected alternative when all three are true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

A core decision's alternative goes to the Lean writer with the decision, for the definition's docstring. A shell decision (one that names a screen, a file, a clock, or a vendor) has no definition to carry it: offer an ADR, using the format in [ADR-FORMAT.md](./ADR-FORMAT.md).
