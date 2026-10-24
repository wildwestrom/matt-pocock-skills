## What it does

`grill-with-lean` is a relentless interview about a plan or design that **writes each decision into Lean the moment it settles**. It runs the same rounds as [grilling](https://aihero.dev/skills-grilling): every question whose prerequisites you have answered, nothing that depends on an answer it hasn't heard. Underneath, [lean-modeling](https://aihero.dev/skills-lean-modeling) turns each settled answer into definitions and claims that a background **Lean writer** gets building.

The output is not a summary written at the end. It is a [Lean spec](https://aihero.dev/skills-lean-modeling) (or, when the code is Lean, a scaffold of the code itself) that builds with `lake build`, and every promise in it is either proved or visibly open.

## When to reach for it

You invoke this by typing `/grill-with-lean`. The [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own.

| Where you are | What to run |
| --- | --- |
| An idea about code in this repo, settled in one sitting | `/grill-with-lean` |
| No repo, or the subject isn't code | [grill-me](https://aihero.dev/skills-grill-me) |
| Too big for one [session](https://www.aihero.dev/ai-coding-dictionary/session), the route still unclear | [wayfinder](https://aihero.dev/skills-wayfinder) |
| The answers are in someone else's head | [to-questionnaire](https://aihero.dev/skills-to-questionnaire) |
| You only want the words in a plain-English `GLOSSARY.md` | [domain-modeling](https://aihero.dev/skills-domain-modeling) |

It is the head of the main build flow. When the frontier is empty, hand the same conversation to [to-tickets](https://aihero.dev/skills-to-tickets) without [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing).

## Prerequisites

- **A Lean toolchain.** The Lean writer runs `lake`. If `lake` is missing it stops and reports it, since installing a toolchain is your call.
- **Two answers on the first decision**, if the repo has no Lean project yet: where the spec lives (`spec/` at the repo root unless you say otherwise), and whether it depends on Mathlib. The Lean writer sets the project up from there.
- **The [grilling](https://aihero.dev/skills-grilling) and [lean-modeling](https://aihero.dev/skills-lean-modeling) skills installed.** This skill's whole body is "load those two".

## Where the decisions go

Each decision lands in one of four places, and the line between them is the point of the skill:

| The decision | Where it goes |
| --- | --- |
| A rule about the **core** (statable without naming a screen, a file, or a clock) | A definition and a **claim** (`theorem`) in `spec/`, with the rejected alternative in the docstring |
| A decision about **Lean code**, even code not written yet | The **scaffold**: types and signatures where the code will live, with claims stated against them |
| A body the decisions don't settle | An **unbuilt definition**: a `sorry` in the scaffold, filled in by the ticket that builds it |
| A **shell** decision (UI, storage, a vendor) that is hard to reverse and surprising | An ADR in `docs/adr/` |

A claim the Lean writer can't prove cheaply stays a `sorry` too, but it is an **open claim**, not an unbuilt definition. `to-tickets` treats the two differently: an open claim becomes its own ticket, and an unbuilt definition is filled in by an ordinary slice.

## The Lean writer runs in the background

You never wait on the type checker. The interviewer hands each decision, in English, to a Lean writer subagent and carries on asking. Only the questions downstream of a running writer wait. The Lean stays out of the interview's [context window](https://www.aihero.dev/ai-coding-dictionary/context-window): the interviewer holds the decisions, the writer fights the proofs.

The writer reports back the names and statements it added, each marked proved, open, or unbuilt, plus every **forced question**: a decision the model needed that you haven't made. It never answers one itself. Forced questions join the next round, so writing the Lean is how the interview finds the gaps you skipped.

## Common questions

**It finished, but nothing was written.**
That means the Lean writer never ran. Usually `lean-modeling` wasn't loaded, so the session was a plain grilling session. Ask the agent whether it loaded both `grilling` and `lean-modeling`, then have it dispatch the settled decisions. When the code is Lean, the decisions belong in the scaffold where the code will live, not in a separate `spec/`.

**There are `sorry`s left. Is the session done?**
It can be. The bar is that every `sorry` is an open claim or an unbuilt definition and you have seen it. [to-tickets](https://aihero.dev/skills-to-tickets) turns each open claim into a ticket of its own, and `sorry` never reaches `main`.

## It's working if

- `lake build` passes by the end, and you have seen every `sorry` and know whether it is an open claim or an unbuilt definition.
- Some rounds contain questions you didn't see coming, raised by the Lean writer rather than the interviewer.
- The names in the Lean are the words you used in the conversation, or words you agreed to switch to.
- A shell decision you made shows up as an ADR, and a core decision shows up as a claim, not the other way round.
- When the code is Lean, the claims sit next to the code's scaffold, and `spec/` holds only the core model.

## Where it fits

`grill-with-lean` is the first step of the main build chain:

```txt
grill-with-lean → to-tickets → implement → code-review → retro
```

It is the user-invoked front door to [lean-modeling](https://aihero.dev/skills-lean-modeling), the way [grill-me](https://aihero.dev/skills-grill-me) is the stateless front door to [grilling](https://aihero.dev/skills-grilling). Downstream, [to-tickets](https://aihero.dev/skills-to-tickets) slices the settled thread in the same context window, and [implement](https://aihero.dev/skills-implement) builds against the claims. For which skill fits a situation, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
