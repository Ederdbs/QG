# 02-subdivided -- editor report (form review, step 5)

File: book/02-subdivided.qmd. Worktree review-01-05. No figures in this chapter (no plot chunks, no static images). No footnotes. book/Rplots.pdf: absent, nothing to delete. No callout-caution. Headings and callout titles already sentence case. All 11 displayed equations carry #eq- labels; all 5 tables carry tbl- labels and captions.

## (a) Mechanical fixes applied

Tables
- Two raw console vectors converted to labelled tables (same standard as 01): chunk `ct-identities` -> `tbl-toy-partition` (G_meta, G_wmean, GD_T/WI/BI/WS/BS); chunk `keystone-check` -> `tbl-keystone-check` (gd_partition output). Each has tbl-cap (data, seed, scale, dimensionless), values through fmt(), row labels in math via a name-indexed lookup (no positional mapping). Display code only was added at the end of each chunk (fmt + kable); no analysis line touched. Each is cited with @tbl- before it appears (lead-in sentences at the chunk introductions).
- Chunk code check: purl of the edited chapter sourced end to end with pkgload::load_all, no error, both tables print as intended.
- `tbl-ct-loss` was first cited after the table; added the lead-in sentence "@tbl-ct-loss gives the effect on $GD_T$ of removing each subpopulation in turn." before the chunk.
- `tbl-gd-partition`: column headers did not match the caption/contents ("Definition" held the verbal name, "Biologically"); added col.names = c("Component, defined in coancestries", "Name", "Biological reading").
- Comments in chunks `fst-two-forms` and `tbl-keystone-check` and one prose mention (Ns paragraph) updated to the renamed label `tbl-keystone-check`.

Cross-references ("above/below/Notation" replaced by @ references)
- Added heading ids: `## Notation {#sec-ct-notation}`, `### f_ij, between subpopulations {#sec-ct-fij}`, `### Why the partition changes the strategy by species {#sec-ct-species}`.
- "(above)" -> @sec-ct-fij (F_i callout); "its baseline below" -> @eq-alpha-baseline; three bare "Notation" -> @sec-ct-notation; "the drift paragraph above" / "(above)" / "the drift accounting above" -> @sec-ct-species (3 places); "@eq-ne-meta below" -> "@eq-ne-meta".

Text
- Acronym: "the $GD$ terms" (Notation, first use) -> "the gene diversity ($GD$) terms".
- Citation syntax: "(...; @toro2005 [§2])" -> "[@toro2005, §2]".

Totals: 2 console->table conversions, 4 other table edits, 3 heading ids, 11 reference replacements, 1 acronym, 1 citation fix.
Prose/caption wording changed: yes, mechanically only: two new lead-in sentences (tbl-ct-loss; the tbl-toy-partition / tbl-keystone-check citations inserted in existing sentences), the "gene diversity ($GD$)" expansion, "above/below/Notation" -> @refs, and the new captions of the two new tables (written from the code). No number, claim, equation or chunk logic changed.

## (b) Findings for quant-writer (wording / bibliography)

- 02-E1 -- :358, :746, :1019 -- Hand-typed author-year citations "Wright's (1969)", "Laval et al. (2000)", "Wright (1969)". Neither has a key in book/references.bib (only wright1922, wright1951), so I cannot convert them. Either add entries (wright1969, laval2000) and cite with @key, or recast as "as cited in [@caballero2002]" without author-year text.
- 02-E2 -- :746-751 (pig-breed paragraph), :999-1003 -- Breed codes FRBA and DESH are used without definition (acronym rule). Expand at first use, from the source table.
- 02-E3 -- chapter-wide -- Symbols used here and absent from book/90-notation.qmd: $\tilde p_{k,i}$ (the chapter defines it in its own Notation), $c_i$ (only bold $\mathbf{c}$ is listed in the OCS table), $\theta_w$ (:409, local to the F_ST paragraph). Add to 90-notation or keep local and say so. $H_T$, $H_S$ are listed in 90-notation (Nei partition table, :208) with H_T = H_S + D_G; consistent with their use in :364.
- 02-E4 -- :1022-1028 (`tbl-keystone`) -- Pipe table whose third column holds paragraph-length cells (rows 1-3, up to ~90 words). It will print as a very tall narrow column in Typst and may be hard to read at A4. Consider moving the conditions of the rows into prose after the table and keeping a short cell. Interacts with the already-logged 00-E8 (cell justification), which I did not touch.
- 02-E5 -- :747-755 -- `callout-note` "What this does and does not license" holds a practical recommendation (regenerate rather than discard) and a trap (do not discard). Under the style guide a note is a definition/clarification; consider callout-warning (trap that leads to a wrong decision) or callout-tip. Left as is, as the choice carries a content judgement.
- 02-E6 -- :44-66 -- Notation bullets and the F_i callout refer to "the chunk below"/"the chunk above" for checks (:210, :476, :576-581, :876-889). They are not numbered references; acceptable, but if the writer prefers, label those chunks' outputs as tables (as done for the two above) so the claim can be cited with @tbl-.

## (c) Findings for quant-Rwrite (code)

None. The display code added (fmt + kable at the end of two chunks) is within the 01 precedent; if quant-Rwrite prefers these tables built outside the analysis chunks, they can be split into separate chunks, which changes nothing in the output.

## (d) Figures/files the render at close may orphan

- No figures in this chapter; no docs/02-subdivided_files/ and no book/_freeze/02-subdivided/figure-* exist, so nothing is orphaned.
- Chunk renames `ct-identities` -> `tbl-toy-partition` and `keystone-check` -> `tbl-keystone-check` force re-execution of the chapter at render (stale freeze entry replaced in place: book/_freeze/02-subdivided/execute-results/html.json and typ.json both need regenerating).
- book/downloads/02-subdivided.R must be regenerated with `Rscript book/scripts/make_downloads.R` (it still carries the old chunk labels `ct-identities` and `keystone-check` and the old prints); I did not run it.
- Sweep macOS " N" duplicate files after the final render per CLAUDE.md.
