---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

If the project has a Lean spec, call the Skill tool with "lean-modeling" and work core first: an unproved claim is red, its proof is green. The ticket is not done while a claim or definition it covers is still `sorry`, and a claim that will not prove as stated goes back to the user rather than being weakened.

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, call the Skill tool with "code-review" to review the work.

Commit your work to the current branch.
