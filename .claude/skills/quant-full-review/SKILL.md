---
name: quant-full-review
description: Use when the user asks for a deep review of the book in book/, of one chapter or of "the next chapter", for scientific rigour or for whether its ideas hold together from chapter to chapter.
---

# quant-full-review

Orchestrates the six `quant-*` agents over **one chapter per invocation**. You (the main
session) are the orchestrator: you dispatch, pass reports between agents by file path,
and decide when to stop. You do not review or edit the chapter yourself.

The review has two goals, in this order:

1. **Scientific rigour.** Every claim in the chapter is correct, supported and honestly
   scoped, by the criteria in `.claude/agents/quant-advice.md`.
2. **Continuity of ideas.** The chapter follows from the ones before it: it uses what
   they established, under the assumptions they established it, and it keeps what they
   promised. A chapter that is right alone and wrong in the book is not approved.

Form is a third concern: it runs once, after both goals are met.

Argument: a chapter file or stem (`04g`, `book/04g-joint-allocation.qmd`) or `next`.
Optional: `iter=N` (max iterations, default 3).

## Team

| Agent | Role here | Writes | Report ID prefix |
|---|---|---|---|
| `quant-Rwrite` | chapter audit mode; later fixes code | chunks, `R/` | `<ch>-R<n>` |
| `quant-refcheck` | citations of this chapter | nothing | `<ch>-B<n>` |
| `quant-continuity` | chapter mode against the earlier chapters; part and book closes | `THREAD.md` entry | `<ch>-C<n>`, `<part>-C<n>` |
| `quant-advice` | verdict APPROVED / REJECTED | nothing | `<ch>-D<n>`, `<ch>-M<n>` |
| `quant-writer` | fixes content (D, M, B, C) | prose | `ID -> fixed/contested` table |
| `quant-editor` | form, once content is approved | chunk options, captions | `<ch>-E<n>` |

## State

All reports live in `.claude/review/<ch>/` (tracked, build-ignored):
`it<k>-audit.md`, `it<k>-refs.md`, `it<k>-continuity.md`, `it<k>-verdict.md`,
`it<k>-response.md`, `editor.md`.

`.claude/review/STATUS.md` (create it if absent) has one row per chapter and per part:
`| ch | status (APPROVED / OPEN after N / in progress) | iterations | commit | date |`.
`next` = first chapter in `book/_quarto.yml` order (chapters, then appendices; skip
`index` and `99-references`) without an APPROVED row.

`.claude/review/THREAD.md` (create it if absent) is the book's argument so far, one entry
per approved chapter in book order. Each entry has exactly these fields:

```
## <ch> -- <chapter title>
- Question: what the chapter answers, and why it follows the previous chapter
- Establishes: definitions, symbols and results later chapters may use (`file:line`)
- Assumes: the assumptions under which those results hold
- Takes from: earlier results it uses (`<ch>`: item)
- Owed: promises and findings a later chapter must settle (-> `<ch>`: item)
```

Every agent prompt names: the worktree path, the chapter file, the iteration number,
the file it must write its report to, and the paths of the reports it must read. Agents
start cold; pass paths, not pasted reports. Never lower an agent's effort: its definition
sets `effort: high`, and that is the review standard.

## Procedure

0. **Setup.** Follow the git workflow in `CLAUDE.md`: a worktree on a branch cut from an
   up-to-date `origin/main`. Reuse an existing review branch only while its PR is open;
   once it is merged, start a new one. `reference/` is gitignored and absent from the
   worktree: pass its path in the main checkout to `quant-refcheck`, `quant-advice` and
   `quant-writer`. Resolve the chapter; read its row in STATUS.md and any existing
   reports (resume, don't restart). Mark it `in progress`. If an earlier chapter has no
   APPROVED row, tell the user the chapter is being judged against unreviewed text.
1. **Audit (parallel, read-only).** `quant-Rwrite` in chapter audit mode ->
   `it1-audit.md`; `quant-refcheck` on this chapter -> `it1-refs.md`;
   `quant-continuity` in chapter mode, with `THREAD.md` -> `it1-continuity.md`. `Owed`
   items naming this chapter and open `part-*.md` findings are input to all three.
2. **Verdict.** `quant-advice` reads the chapter, the three reports and `THREAD.md` ->
   `it<k>-verdict.md`. Update the iteration count in STATUS.md after every verdict.
   APPROVED with no open R, B or H-severity C finding -> go to 5.
3. **Fix content, then code (sequential, same file).** `quant-writer` addresses every
   D, M, B and C ID; `quant-Rwrite` addresses every R ID; both append their
   `ID -> fixed | contested` rows to `it<k>-response.md`. Where a C finding points:
   - **This chapter:** fix it here.
   - **An earlier chapter:** fix it there now, minimally, in the same iteration. The
     diff goes to the re-review, and `THREAD.md` is corrected if the fix changes what
     that chapter establishes.
   - **A later chapter:** add it to `Owed` at close.
4. **Re-review.** k = k + 1. `quant-advice` gets the previous verdict and the response
   file, closes/reopens old IDs first, then judges changed text and what depends on it.
   Loop to 3 while REJECTED and k <= iter.
5. **Form.** `quant-editor` applies its checklist -> `editor.md`. E findings go to
   `quant-writer`. If any prose or caption wording changed, `quant-advice` checks that
   diff -> `it<k>-verdict.md` with k + 1; a rejection returns to 3.
6. **Close.**
   - `Rscript book/scripts/make_downloads.R`.
   - If `R/` changed: `devtools::document()`, `devtools::test()`, `devtools::install()`.
   - `Rscript inst/scripts/render_book.R` (full book, both formats; a single-file
     render in the worktree has no crossref index and breaks every `@sec-` link).
     Then run the duplicate sweep from `CLAUDE.md`; list orphaned figures the editor
     reported.
   - Before staging: no `book/*.html` may exist, and every chapter in `_quarto.yml`
     must have its `docs/<chapter>.html`. Quarto once left a re-executed chapter's
     HTML in `book/` and `git add -A` committed the move, unpublishing the chapter.
   - Re-executed chapters with unseeded draws (`runMacs`/`runMacs2`, see
     `CLAUDE.md`): have `quant-advice` re-check every hand-written qualitative
     claim against the new render.
   - `quant-continuity` writes the chapter's `THREAD.md` entry from the approved text
     and strikes the `Owed` items this chapter settled.
   - Update STATUS.md.
   - If every chapter of its part in `_quarto.yml` is now APPROVED: run
     `quant-continuity` on that part -> `.claude/review/part-<name>.md`. Its fixes follow
     steps 3-4, and the part closes only on an APPROVED `quant-advice` verdict with no
     H finding open. Keep a `part-<name>` row in STATUS.md.
   - If this was the last chapter: run `quant-continuity` on the whole book and
     `quant-refcheck` in whole-book mode. The book closes only with no `Owed` item left.
7. **Report and stop.** One chapter per invocation. Tell the user: verdict, iterations
   used, IDs fixed / contested / still open, every item left UNVERIFIED or NOT VERIFIED,
   earlier chapters changed, `Owed` items added, files changed, render result. Commit on
   the branch and push to its PR against `main`, as `CLAUDE.md` says; merging is the
   user's decision.

**Not approved after `iter` iterations:** stop, mark `OPEN after N`, list the open IDs
with both sides' evidence, and ask the user to arbitrate. Do not run a 4th iteration
on your own.

## Rules that fail silently if skipped

- `quant-advice` judges contested IDs; you never close an ID yourself.
- A cross-chapter finding always has an owner: this chapter, an earlier chapter fixed
  now, or an `Owed` line naming a later one.
- Never two writing agents on the same file at once (steps 3 and 5 are sequential).
- Cached external data (`mating_*`, `sparse_*`) is never re-labelled reproducible.
- `devtools::install()` before rendering whenever `R/` changed, or the render runs
  stale package code.
- Sweep duplicates last, after the render returns.
