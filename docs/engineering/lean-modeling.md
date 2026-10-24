## What it does

`lean-modeling` builds and sharpens a project's **Lean spec** while you design. It challenges a name that conflicts with the spec, asks for a precise word where you used a vague one, and tests a rule against a concrete scenario until the boundaries are exact. Then it gets each decision into Lean **the moment it settles**, by handing it to a background **Lean writer** subagent.

The spec models the product's **core**: its vocabulary as types, its behaviour as total functions, its promises as **claims** (`theorem`s) that the kernel checks. The **shell** (UI, IO, storage, network) stays out of the model, and is built and tested as ordinary code against the core.

## When to reach for it

Type `/lean-modeling`, or the agent reaches for it when you discuss the codebase's terminology, edit the Lean spec, or record a design decision. Most of the time it runs underneath [grill-with-lean](https://aihero.dev/skills-grill-with-lean), which loads it alongside [grilling](https://aihero.dev/skills-grilling).

| The situation | The move |
| --- | --- |
| You want the whole plan interrogated before you build | [grill-with-lean](https://aihero.dev/skills-grill-with-lean), which drives this skill |
| One rule or name needs settling mid-task | `lean-modeling` directly |
| The words are the problem and you want prose, not Lean | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| The module's *shape* is the problem: where the seam goes, how deep the interface is | [codebase-design](https://aihero.dev/skills-codebase-design) |

## Prerequisites

None up front, but the Lean writer needs `lake`. If the repo has no Lean project, the skill asks two questions before the first decision goes to the writer: where the spec lives (`spec/` at the repo root unless you say otherwise), and whether it depends on Mathlib. The writer then runs `lake init` there. `docs/adr/` is created with the first ADR.

## Core or shell

The test is one sentence: **a rule is core when it can be stated without naming a screen, a file, or a clock.**

| | Core | Shell |
| --- | --- | --- |
| Lives in | The Lean spec, or the Lean code's scaffold | Ordinary code |
| A decision is recorded as | A definition and its claims, with the rejected alternative in the docstring | An ADR, only if it is hard to reverse, surprising, and a real trade-off |
| Reaches the other side by | Being run by the shell, or being the **oracle** the shell's tests compare against | Calling the core, or being checked against it |

When the code itself is Lean, a decision about that code goes into the code: the Lean writer writes its **scaffold** where the code will live, types and signatures in full, with each unsettled body left as a `sorry`. That `sorry` is an **unbuilt definition**. Claims sit right after the definitions they are about, so they exist before any body does. Only decisions about the core model go to `spec/`.

## Claims, open and proved

A claim has an English name a reader of the spec must understand (`Order.refund_neverExceedsTheCharge`). The writer tries cheap proofs (`decide`, `simp`, `omega`) and leaves the rest as `sorry`, an **open claim**. [to-tickets](https://aihero.dev/skills-to-tickets) turns each open claim into its own ticket, and no `sorry` reaches `main`. A claim weakened to get a proof through is a different claim, so the weaker statement goes back to you first.

## Forced questions

The writer never decides anything. When the model needs a decision you haven't made, it reports a **forced question**, and the skill puts it to you. Writing the Lean is how the gaps in a design come to light: a type that won't close, a function with no answer for an edge case.

## Common questions

**Why not a `GLOSSARY.md`?**
A glossary is checked by nobody. A name in the spec is used by every claim about it, so a term that drifts breaks the build. If you want the plain-English glossary anyway, [domain-modeling](https://aihero.dev/skills-domain-modeling) still builds one.

## It's working if

- `lake build` passes, and every `sorry` is an open claim or an unbuilt definition.
- The writer's reports list names and statements, not Lean source, and each is marked proved, open, or unbuilt.
- Forced questions come back to you rather than being answered silently.
- ADRs only ever describe shell decisions, and a core decision's rejected alternative is in a docstring.
- The project `README.md` lists the spec files in reading order.

## Where it fits

`lean-modeling` is a **model-invoked reference** that runs underneath [grill-with-lean](https://aihero.dev/skills-grill-with-lean), the head of the main build chain. Its output feeds the rest of the chain: [to-tickets](https://aihero.dev/skills-to-tickets) turns open claims into tickets, [implement](https://aihero.dev/skills-implement) builds against the claims, and [code-review](https://aihero.dev/skills-code-review) checks the diff keeps them. Its prose sibling is [domain-modeling](https://aihero.dev/skills-domain-modeling). For which skill fits a situation, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
