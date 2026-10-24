# Lean spec

The spec is a Lean model of the product's **core**: its vocabulary as types, its behaviour as total functions, its promises as theorems the kernel checks. Lean specs are preferable over prose as a source of truth. The **shell** (UI, IO, storage, network) stays out of the model: a smooth UI does not fall out of the types, so the shell is built and tested as ordinary code against the core.

## Core and shell

A rule is core when it can be stated without naming a screen, a file, or a clock. Everything else is shell.

Where the model cannot run the real thing (a hash, a clock, a network), it uses a stand-in that keeps the property the real thing is trusted for, and says so in its docstring.

The shell reaches the core one of two ways:

- **It runs the core.** The Lean is compiled, or run in the browser, and the shell calls it.
- **It is checked against the core.** The model is the **oracle**: tests at the shell's seam compare its answers with the model's on generated inputs.

## Claims

A **claim** is a promise the spec makes. It is a `theorem` with an English name that a reader of the spec must understand: `Session.logout_revokesEveryToken`, `Order.refund_neverExceedsTheCharge`, `Player.takeDamage_neverRaisesHealth`. **Plumbing** exists so the next line typechecks: it is a `lemma` and keeps Lean's naming convention (`sortBy_perm`, `nodup_eraseDups`). Without Mathlib, `lemma` is one macro:

```lean
open Lean.Parser.Command in
macro (name := lemmaCmd) mods:declModifiers "lemma " id:declId sig:declSig val:declVal :
    command => `(command| $mods:declModifiers theorem $id $sig $val)
```

Put each claim directly after the definition it is about. The definition's docstring names the alternative that was rejected and why.

Evidence climbs a ladder:

1. **`#guard` / `example … := by decide`** pins one concrete case.
2. **A theorem** states the general rule.

We generally want to promote examples to more general theorems. This helps us catch bugs we otherwise would not have. This does not apply to integration tests.

Two ways to turn checks into claims:

- **Guard to theorem.** A runtime check for a case that "cannot happen" (a deleted user still holding a session, an item in two inventories) becomes a theorem that proves it does not.
- **By construction.** An invariant every value must satisfy becomes a field of its structure (`fits : items.length ≤ capacity` on an `Inventory`), so no value without it can exist and no function has to re-check it.

A claim is proved or it is open. An open claim is a `sorry`, and `to-tickets` turns each one into a ticket that proves it; `sorry` never reaches `main`. A claim weakened to get a proof through is a different claim: put the weaker statement to the user before proving it.

## Lean code

When the code is Lean, the shell runs the core directly, and a claim can sit on the code itself. Write the **scaffold** of each agreed piece where the code will live: its types and signatures in full, and every body the decisions do not settle as `sorry`. That `sorry` is an **unbuilt definition**, not a claim: the ticket that builds the behaviour fills it in. State each claim against the scaffold straight away, so the claims are red before any body exists.

## Names

The spec is worth something only when everyone is sure what it says, and names carry most of that. An unclear name is a forced question: propose the rename to the user, and expect several rounds.

A distinction drawn only in names (`UserId` and `OrderId` as two `abbrev`s over `Nat`, two constructors one branch handles alike) is **semantic but not behavioural**: the compiler and every proof treat both the same. List it in the project's spec gaps until the user decides whether it gets teeth.

## Reading order

The project `README.md` lists the spec files in reading order, each importing the one above, with one line on what each holds. Adding, splitting, or renaming a spec file updates that list.

## Setup

When the project has no Lean spec yet, the user has already said where it lives and whether it depends on Mathlib.

1. Run `lake --version`. If `lake` is missing, stop and report it: installing a toolchain is the user's call.
2. In the agreed directory, run `lake init Spec lib`, or `lake init Spec math` with Mathlib.
3. Without Mathlib, put the `lemma` macro in its own file, imported by every spec file.
4. Start the reading order in the project `README.md`.

## Done

- `lake build` passes, and every `sorry` is an open claim or an unbuilt definition.
- Every new rule has a claim, or is in the spec gaps as open.
- The project's spec lint, if it has one, passes.
- The reading order in `README.md` is current.
