---
name: quant-full-review
description: Use when the user asks for a deep review of a chapter of the book in book/ (or "the next chapter"), one chapter at a time, with the quant-* review agents -- content, code, references, figures, tables and formatting -- up to three iterations until the chapter is approved.
---

# quant-full-review

Orchestrates the six `quant-*` agents over **one chapter per invocation**. You (the main
session) are the orchestrator: you dispatch, pass reports between agents by file path,
and decide when to stop. You do not review or edit the chapter yourself.

Argument: a chapter file or stem (`04g`, `book/04g-joint-allocation.qmd`) or `next`.
Optional: `iter=N` (max iterations, default 3).

## Team

| Agent | Role here | Writes | Report ID prefix |
|---|---|---|---|
| `quant-Rwrite` | chapter audit mode; later fixes code | chunks, `R/` | `<ch>-R<n>` |
| `quant-refcheck` | citations of this chapter | nothing | `<ch>-B<n>` |
| `quant-advice` | verdict APPROVED / REJECTED | nothing | `<ch>-D<n>`, `<ch>-M<n>` |
| `quant-writer` | fixes content (D, M, B) | prose | `ID -> fixed/contested` table |
| `quant-editor` | form: figures, tables, eq, callouts | chunk options, captions | `<ch>-E<n>` |
| `quant-continuity` | once per finished **part** | nothing | `C<n>` |

## State

All reports live in `.claude/review/<ch>/` (tracked, build-ignored):
`it<k>-audit.md`, `it<k>-refs.md`, `it<k>-verdict.md`, `it<k>-response.md`,
`it<k>-editor.md`. The ledger `.claude/review/STATUS.md` (create it if absent) has one
row per chapter:
`| ch | status (APPROVED / OPEN after N / in progress) | iterations | commit | date |`.
`next` = first chapter in `book/_quarto.yml` order (chapters, then appendices; skip
`index` and `99-references`) without an APPROVED row.

Every agent prompt names: the worktree path, the chapter file, the iteration number,
the file it must write its report to, and the paths of the reports it must read. Agents
start cold; pass paths, not pasted reports.

## Procedure

0. **Setup.** Work in a git worktree (several sessions share the main tree): reuse
   `../SB_quanti_gen-review` on branch `review` if it exists, else create it from
   `main`. Resolve the chapter; read its row in STATUS.md and any existing reports
   (resume, don't restart). Mark it `in progress`.
1. **Audit (parallel, read-only).** `quant-Rwrite` in chapter audit mode ->
   `it1-audit.md`; `quant-refcheck` on this chapter -> `it1-refs.md`.
2. **Verdict.** `quant-advice` reads the chapter + both reports -> `it<k>-verdict.md`.
   APPROVED with no open R/B findings -> go to 6.
3. **Fix content, then code (sequential, same file).** `quant-writer` addresses every
   D, M and B ID; `quant-Rwrite` addresses every R ID; both append their
   `ID -> fixed | contested` rows to `it<k>-response.md`.
4. **Form.** `quant-editor` applies its checklist -> `it<k>-editor.md`. Any E finding
   it hands back goes to `quant-writer` in the same iteration.
5. **Re-review.** k = k + 1. `quant-advice` gets the previous verdict and the response
   file, closes/reopens old IDs first, then judges only changed text. Loop to 3 while
   REJECTED and k <= iter.
6. **Close.**
   - `Rscript book/scripts/make_downloads.R`.
   - If `R/` changed: `devtools::document()`, `devtools::test()`, `devtools::install()`.
   - `quarto render book/<chapter>.qmd --to html`; then run the duplicate sweep from
     `CLAUDE.md`; list orphaned figures the editor reported.
   - Update STATUS.md.
   - If this chapter is the last of its part in `_quarto.yml`: run `quant-continuity`
     on that part -> `.claude/review/part-<name>.md`, and report its findings.
7. **Report and stop.** One chapter per invocation. Tell the user: verdict, iterations
   used, IDs fixed / contested / still open, files changed, render result. Ask before
   committing, merging to `main` or pushing.

**Not approved after `iter` iterations:** stop, mark `OPEN after N`, list the open IDs
with both sides' evidence, and ask the user to arbitrate. Do not run a 4th iteration
on your own.

## Rules that fail silently if skipped

- `quant-advice` judges contested IDs; you never close an ID yourself.
- Never two writing agents on the same file at once (steps 3 and 4 are sequential).
- Cached external data (`mating_*`, `sparse_*`) is never re-labelled reproducible.
- `devtools::install()` before rendering whenever `R/` changed, or the render runs
  stale package code.
- Sweep duplicates last, after the render returns.
