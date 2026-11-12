# 04b-backcross-introgression -- verdict, iteration 2

Text: `book/04b-backcross-introgression.qmd` (1193 lines), `book/index.qmd` Preface item 5, `book/downloads/04b-backcross-introgression.R`. Read with it1-verdict, it1-response, it1-refs, THREAD.md and the diff against origin/main. Every decisive number was recomputed (package loaded with `pkgload::load_all` from the worktree).

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 04b-D1 -- CLOSED -- donor now shared by descent with probability s per marker (qmd:1112); "already in the draw" removed; table carries s = 0.60, s = 0 and unrelated rows; headline 0.117 is stated as the s = 0 value only. Recomputed on chunk execution: 200-seed ratio mean 0.0470 (s.d. 0.0037) at s = 0.6 against 2D(1-D)(1-s) = 0.0469; mean 0.1172 (s.d. 0.0057) at s = 0 against 0.1172. The expectation derivation in the prose (donor differs from recurrent parent with probability (1-s)/2) is correct for the generator.
- 04b-D2 -- CLOSED -- 47 is stated as per generation; lineage survival (1-(15/16)^47)^3 = 0.862 and 64 plants per generation for 0.95 over three generations reproduced (chunk output 47, 64, 0.8624); scan p_lost 0.193 (N = 40, 300 reps) and 0.050 (N = 60, 200 reps) reproduced from the CSV; independence assumptions declared (qmd:314-315). "Whole foreground problem" removed.
- 04b-D3 -- CLOSED -- section title, the three statements and the "Where this connects" paragraph are scoped to s = 0.60; tbl-bc-s0 measures s = 0 (500 replicates per row, own seeds, Clopper-Pearson, unpaired, stated) and the text states that the IBD criterion binds at s = 0 under rec_drag in this range of N and lists what was not run (N > 400, background-priority stage, joint criterion, other k, ceiling, target, grid). "Not of maize" replaced by "not of the cross simulated". One-value-of-each-criterion limit added (qmd:964-971). My independent run agrees in direction (see Verified). Residual overreach at qmd:1062-1063 is recorded as M9, not disqualifying.
- 04b-D4 -- CLOSED -- the 1000-fold figure is attributed to the authors' Abstract/Significance as background; their measurement is stated as about 136 000 breakpoints and hotspots threefold to over 100-fold, which is what it1-refs found in the full text. I did not re-read the paper (see Not verified).
- 04b-M1 -- CLOSED -- the mean is stated as conditional on kept targets, p_lost at the smallest N printed (0.603 at N = 20), caption reworded.
- 04b-M2 -- CLOSED -- the cap is now the `max_use` of 07/10 and the continuous `upper` cap of 09 (09:362-366 calls it the continuous analogue of the usage cap that 10 enforces); not claimed tested. Residual inaccuracy recorded as M11.
- 04b-M3 -- CLOSED -- re-pointed to @sec-hp-ibd and @sec-coancestry; both labels exist (00, 01).
- 04b-M4 -- CLOSED -- qmd:61-76 states the position against A1-A8 and S1-S4. Checked against the A-list in 00:18-34 and 05:46-106: A2 (inbred), A3 (recycling within pool), A5 (neutral, linkage equilibrium), A7 (no dominance) are described consistently.
- 04b-M5 -- CLOSED -- "exact for the marker chain", cancelled double crossovers within an interval, 5 cM drag floor and lattice, 30 cM = six cells, all stated; direction for drag stated as not shown.
- 04b-M6 -- CLOSED -- cross-reference to @eq-sizing-n95, "no segregation distortion", 04's k = 5 understatement named; caption states the assumptions.
- 04b-M7 -- CLOSED -- alpha is stated against a same-candidate-set reference; "cannot distinguish" replaced by the measured ratio against 0 for eight copies of one line.
- 04b-M8 -- CLOSED -- the Preface says the measurement is a ratio and that no optimiser is run or bounded; the chapter says the same (qmd:1073-1078); Hospital (2001) is context only and the different problem is named.
- 04b-B2, B3, B4, R3, R4, R5, C2, C11, C12, C14 -- CLOSED -- gametophytic factors now sourced (lu2002, abstract level, as in 04); endosperm paragraph marked as a deduction with no source checked; Haldane function asserted by a chunk and page attribution marked unverified; MB asserted against `mabc_opt` (stopifnot passes); `fig-alt` and `fmt_sci()` in place (not rendered, see Not verified); C14 annotation computed.
- 04b-C9, C13 -- owed to 11b and 90 respectively, not 04b failures; 04b does not depend on them. Continuity gate: C1 (the only H finding) is closed with D1.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS (count 2 failures plus 1 note; below the threshold of three)
- 04b-M9 qmd:1060-1063 -- "at s = 0 ... it is not satisfied, and the objective that binds is a different one". The chapter itself says the joint drag-and-IBD criterion at s = 0 was not run (qmd:427). My run (rec_drag, k = 4, 300 replicates per cell, one seed) gives at s = 0, N = 200: P(drag <= 120 cM) 0.87, P(IBD >= 0.90) 0.81, P(both) 0.71; N = 400: 0.99, 0.82, 0.82. At N = 200 drag still binds at s = 0 as at s = 0.6 (0.87), so IBD is an additional binding criterion there, not a replacement. At N = 400 the claim holds. The sentence goes beyond tbl-bc-s0 (IBD criterion only) and under rec_drag only (background is a tie-break there; a background-priority stage was not run, as the chapter says). The surrounding scoping makes the chapter's thesis honest; this one sentence is looser than the table.
- 04b-M10 qmd:1159-1162 -- note, not a failure: s is defined as donor-elite sharing by descent, but the unrelated comparator panel is drawn with no sharing among its lines. The limit is declared at qmd:1161-1162; "smaller the larger s" is therefore a statement about that comparator.
- 04b-M11 qmd:1172-1173 -- "the per-line usage cap `max_use` of @sec-choosing, @sec-ocs and @sec-combinatorial": `max_use` appears in 07 and 10 only; 09 has the continuous `upper` cap (09:362-366), not `max_use`. Minor cross-reference imprecision.
- Open owed items outside 04b: 11b:345 ("@sec-backcross is the machinery that performs [injection] ... how new material enters an elite pool") is not contradicted outright by the rewritten 04b, but 04b now says conversion adds k loci and entry to a pool is a decision outside the chapter; 11b:344-346 should say so (C9). 90:414-420 local-symbol note lacks q, d, r, P (C13). Preface item 5 (the rewording) is consistent with 04b (ratio of gene diversities, no optimiser run); its first clause cites @sec-sizing and is unchanged.

WHAT WAS VERIFIED
- Chapter code runs end to end: `knitr::purl` then `pkgload::load_all(".")`, sourced from `book/` (12 s); all `stopifnot` pass (MB vs mabc_opt, f2 replicate counts, n_for_count survival, s0 upper limits < 0.95, conversion-ratio asserts, sizing_table == csv, identities of IBD_E).
- tbl-bc-s0 values from that run: s = 0: P(IBD) 0.532 [0.487, 0.576] (N = 60), 0.782 [0.743, 0.817] (200), 0.822 [0.786, 0.855] (400); s = 0.6: 0.932, 1.000, 1.000; p_lost 0.088 / 0 / 0 and 0.068 / 0 / 0. At N = 60 and s = 0.6, P(IBD) = 1 - P(lost) exactly, as the text says.
- tbl-bc-conversion-cost: seed 11 draw GD 0.0231 (s = 0.6), 0.0548 (s = 0), 0.4383 (unrelated); ratios 0.053 and 0.125; 200-draw replicate means as in D1.
- Independent run (scratch `j.R`, seed 1, rec_drag, k = 4, 300 replicates per cell): P(IBD) s = 0: 0.807 (N = 200), 0.823 (400); s = 0.6: 1.000, 1.000. Consistent with the chapter's table within Monte Carlo error. Drag and joint values in M9.
- Lineage survival and 64 plants per generation (chunk output); caption claim "P(IBD) reached 0.95 in 41 of 44 cells, shortfall from lost targets, at most 0.003": 41, 44, 11 sizes, max 0.0033 recomputed from `mabc_uniform.csv`.
- `mabc_uniform.csv` strategy by s table: rec_bg at 0.5/0.6/0.7, other policies at 0.6 only (132 rows each), as qmd:365-368 states.
- Labels cited in the new text exist (sec-hp-ibd, sec-coancestry, sec-baseline, sec-choosing, sec-ocs, sec-combinatorial, sec-sizing-verify, eq-sizing-n95, sec-era-programme, tbl-hp-stages).
- Downloads script regenerated (contains tbl-bc-s0).

NOT VERIFIED
- Rodgers-Melnick et al. (2015) attribution (1000-fold as background; 136 000 breakpoints; hotspots threefold to over 100-fold) and Lu et al. (2002): rest on it1-refs.md full-text and abstract readings; papers are not in `reference/`. The claim sits in the limitations paragraph and no result depends on it; not decisive.
- Haldane (1919) pages: the chapter says so itself.
- `fig-alt: !expr alt_siz` and the HTML/Typst render: no render was run; the chunk-level values were computed but the YAML `!expr` for `fig-alt` was not exercised.
- tbl-bc-s0 at N > 400, other k, other drag ceilings, a background-priority stage, and the joint criterion at s = 0: not run by the chapter; the chapter says so.
- Provenance of `mabc_uniform.csv`, `mabc_allocation.csv`, `mabc_bcnf2.csv`: labelled by the chapter as produced by the predecessor driver; not checkable from history.
