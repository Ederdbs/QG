# Verdict: part Simulation (03, 04, 04b, 04c), re-review of simulation-C1..C11, D1

VERDICT: APPROVED

PREVIOUS IDS
- simulation-C1 -- CLOSED -- one A1-A8 mapping sentence per chapter (03:153, 04:32-37, 04c:2259), each against the 00 list (@sec-hybrid-programme) and the 04b full map. Each checked against the A1-A8 list at 00:20-35: A5 = neutral biallelic markers in linkage equilibrium (03 meets it; 04 and 04c depart from it via linkage), A2 inbred parents, A3 recycling within pool, A4 discrete cycles, A6 frozen base (03: `p0` stored once; 04c: trajectory against cycle-0 founders), A7 no dominance, A8 teaching scale. No contradiction with the chapters' own text.
- simulation-C2 -- CLOSED (04, 04b); the 05 part (05:21-23) stays owed to the 05 part review (named later chapter, in a later part) -- 04:25-28 says the simulation stops at F4 and the panel is not yet A2's product; 04b:70-72 says A2 holds of the recurrent parent and the converted line, not of BC1-BC3 (heterozygous at targets). The two statements no longer apply A2 to the same object.
- simulation-C3 -- CLOSED -- 04b:54, 1072, 1079 now say "diversity retained", with the symbol-collision disclaimer at 04b:54. The remaining "gene diversity" (04b:1099, 1163, 1179) is `GD = 1 - theta` computed in the chunk, ratio of off-diagonal terms with diagonal 1 in both panels: correct use.
- simulation-C4 -- CLOSED -- 03:162-166 names @sec-sizing and @sec-backcross as where a map and recombination first appear; 11b:77-79 mirror stays owed to 11b.
- simulation-C5 -- CLOSED -- 04 distorter table (label tbl-sizing-distorters) header "P1 transmission (`k`)", caption says it is not the number of loci k of @eq-sizing-n95. 90 untouched; its `k` row defines loci only, which is now the only sense of the symbol in 04.
- simulation-C6 -- CLOSED -- 03:353-367 cites @eq-het-bn-halves for the unbounded-pool expectation; finite-n form unchanged; offset restated. Algebra recomputed (below). Only moved number: max(f) 0.8317 -> 0.8318.
- simulation-C7 -- CLOSED as owed -- every row names a later chapter, 90, 91 or R/ (04e:35-37, 08b:11-12, 11b:102/344-346/77-79, 12:170, index:116-118, 04d:376-379, 90 rows, R/ items); none is a failure of the four chapters as they now stand.
- simulation-C8 -- CLOSED -- 04c:2158 names @sec-limits as the other paired no-selection design (different quantity, varA - genicVarA); 11c:125, 173-178 confirm.
- simulation-C9 -- CLOSED -- Low, no change required; forward pointers have a stated meaning and none is needed to follow the chapter.
- simulation-C10 -- CLOSED -- 03:472 "teaching scale". "book scale" in 10b and CLAUDE.md is owed to the Metrics/Optimisation part decision.
- simulation-C11 -- CLOSED as owed -- the overread sits at 11b:344-346 (named later chapter); no change in 04b.
- simulation-D1 -- RECORDED as USER DECISION, not a ground for rejection. Untouched (CLAUDE.md, 11c, 04d, index, R/13). 04c is written to stay true under either outcome; the rules held under both readings (found once and branch; set.seed() before each founder draw; saveRDS) are kept.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- simulation-M-open-1 (kept from the review, Low) 04:25-37 -- "meets A3 only if the cross is within a pool" uses A3 (recycling within pool) for a one-off cross; conditional and declared, adequate as written. No action.
- Unrelated to this part's edits, noted so it is not lost: 04c has seven `@tbl-alphasimr-paired-N` / `@tbl-alphasimr-split-N` sub-table targets that a plain grep of `{#...}` does not find; they are Quarto sub-floats of the layout chunks labelled at 04c:1507 and 04c:1928 and resolve at render.
Fewer than three accumulated; no rejection ground.

WHAT WAS VERIFIED
- Purl code of 03 and 04 (`book/downloads/*.R`, with `library(hybdiv)` replaced by `pkgload::load_all` of the worktree, cached csv copied from `book/data`, `book/figs`, run in /private/tmp/claude-501/scr/verd2): both exit 0, all `stopifnot` pass (03 prints only the A7-coding warning; 04 clean).
- Only moved number: output of the 03 script at HEAD against the edited 03 differ in exactly one line, `|max(f) | 0.8317|` -> `|max(f) | 0.8318|` (`diff old03.txt out03.txt`, 1 line).
- max(f) on `simulate_data(book_cfg)` (seed 1): `sprintf("%.17f")` = 0.83174999999999999; `sprintf("%.4f")` = 0.8317; `round(,4)` = 0.8318; `format(round(c(min,max),4), nsmall=4)` = "0.6448" "0.8318". 01 prints via `fmt()` = `round(x, 4)` = 0.8318, so 01 and 03 now agree. min(f) 0.64475000000000005 prints 0.6448 both ways.
- C6 algebra, R: with n = 25, F_BN = 0.3, E[p*q*] = 0.25 - 0.9^2/12, 05b's offset `Ep (1-F)(1/nA+1/nB)/4` with Ep = E[2p*q*] = 0.00511 = `(1-F) E[p*q*]/n` = 0.00511 (all.equal TRUE). Monte Carlo of the stated model (p* ~ U(0.05,0.95), Balding-Nichols Beta pools, n = 25 binomial sampling, 2e6 draws, seed 1): E[(pA_hat - pB_hat)^2/2] = 0.05992 against F p*q* + (1-F) p*q*/n = 0.05986. The restated sentence is consistent with 05b:688-690 (@eq-het-bn-halves: shared term loses, divergence gains F_BN p*(1-p*)).
- All `@sec-`, `@eq-`, `@tbl-`, `@fig-` targets of 03, 04, 04b, 04c and 90 (script over `book/*.qmd`): resolved, including @sec-hybrid-programme (00:1), @eq-het-bn-halves (05b:688), @sec-backcross (04b:1), @sec-sizing (04:1), @sec-limits (11c:1), @tbl-sizing-distorters (04, new label), @sec-era-programme (05:47). Only the seven sub-float suffix refs above do not match a literal `{#id}` and are layout sub-tables.
- The download scripts contain the edits (`nsmall = 4` at 03.R:591; "P1 transmission" at 04.R:206).

NOT VERIFIED
- Nothing rendered; the HTML/PDF and `_freeze` were not inspected (cross-ref resolution is by source grep only).
- The eight A1-A8 claims about 04c Step 8 (A3 and A4 kept) rest on the chapter's own description (04c:1424-1425, 2260-2262), not on a re-run of Step 8; not decisive for any number.
- Attribution of the Lee 2002 / Winkler 2003 statements in 04 is labelled UNVERIFIED by the author in the text itself and belongs to quant-refcheck; not part of this re-review.
