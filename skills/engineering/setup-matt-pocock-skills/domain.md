# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

The project's shared language is its **Lean spec**: types, functions, and claims whose names are the domain's terms. There is no `GLOSSARY.md`.

## Before exploring, read these

- **The project `README.md`'s spec reading order**: it lists the spec files under `<spec-dir>/`, each with one line on what it holds. Read the ones relevant to the topic: their definitions, docstrings, and claim statements. Skip the proofs.
- **Docstrings first**: every public definition, type, constructor, and field opens with a plain-English sentence saying what it means. That sentence is the glossary.
- **Lean code's scaffold**: when the code itself is Lean, its definitions and the claims after them are part of the spec too.
- **`docs/adr/`**: read ADRs that touch the area you're about to work in. They hold shell decisions only (a screen, a file, a clock, a vendor); core decisions live in the docstrings of the definitions they shaped.

If any of these don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The `/lean-modeling` skill (reached via `/grill-with-lean`, `/wayfinder`, `/triage` and `/improve-codebase-architecture`) creates them lazily when names or decisions actually get settled.

## Spec setup

- **Location**: `<spec-dir>/`
- **Mathlib**: <yes or no>

These answer `/lean-modeling`'s two setup questions, so the first Lean writer sets the project up without asking again.

## File structure

```
/
├── README.md              ← lists the spec files in reading order
├── <spec-dir>/
│   ├── lakefile.toml
│   ├── lean-toolchain
│   └── Spec/
│       ├── Session.lean
│       └── Order.lean
├── docs/
│   └── adr/               ← shell decisions only
└── src/
```

## Use the spec's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the concept the spec defines, in the words of its docstring. Give the identifier as well where the reader works in the code. Don't drift to synonyms the spec's docstrings reject.

If a name is opaque, or its docstring doesn't say what it means, don't paper over it with your own paraphrase: flag it as a rename for `/lean-modeling`.

If the concept you need isn't in the spec yet, that's a signal: either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/lean-modeling`).

## Flag spec and ADR conflicts

If your output contradicts a claim in the spec or an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts `Order.cancel_keepsOtherLines`, but worth reopening because…_

> _Contradicts ADR-0007 (Postgres for the write model), but worth reopening because…_
