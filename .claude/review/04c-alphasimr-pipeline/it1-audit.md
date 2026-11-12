# 04c-alphasimr-pipeline -- iteration 1 audit (read-only)

Chapter `book/04c-alphasimr-pipeline.qmd` (2086 lines). Method: chapter code purled and run end to end
against the worktree `R/` (1.8 min, outputs compared with the committed `docs/04c-alphasimr-pipeline.html`:
every inline number checked agrees, so Steps 1-7 are reproducible through chunk order as the chapter says);
`R/13_alphasimr_bridge.R`, `R/14_cycles.R`, `R/15_response.R` read; stochastic assertions re-run over 20 seeds;
MaCS reproducibility probed directly. Scripts are in the session scratchpad, nothing in `R/` or `book/` was edited.

Rules that PASS: R/13, R/14, R/10 ASCII; chapter never reads `report/`, `data/`, `reference/` or `book/data`
(it reads no cached file); no `ctx$f` (the chapter builds no `ctx`); every `@sec-`/bib key it cites exists;
`set.seed()` sits before Steps 2 (101), 7 (202), 5 (55), 6 (500+r, 300+rep, 600), cycle1 (11) and each split
draw; `alphasimr_founder_pools()` calls `set.seed(cfg$seed)` itself (R/13:73) before `runMacs2`; the 48-draw
experiment branches both arms off ONE founder object with the same seed per arm and asserts the cycle-1 pairing
(1701-1704); unit of replication = founder draw, n = 48, paired t on 47 d.f., split contrast unpaired because
draws are independent. Only labelled figure chunk `fig-alphasimr-cycles` exists in `docs/..._files` and
`book/_freeze/...`; no `unnamed-chunk-*` orphan. `book/downloads/04c-alphasimr-pipeline.R` code lines equal
a fresh purl of the chapter.

Stochastic assertions re-run (20 seeds, fixed `pop` of Step 2): `which.max(transgressive)==which.min(gap)`
(571) holds 20/20; selfing `|z| < 4` (754) max over seeds 2.24, never >= 4 (margin 1.8). Both robust.
Step 6 max|z| 1.63, Step 5 max|z| 1.24 on the chapter seed. Identities asserted OK:
`varD < 1e-10`, eq-gv, eq-hij, eq-hbar, GCA formula, `gca_A`, SCA, mhw/inbreeding depression, genic var,
`GD_T == mean(h_s)`, `F_ST == GD_BS/GD_T`, GCA = add + dom, Smith-Hazel vs `optim` (1.1e-15).

## Findings

### 04c-R1 (HIGH) -- the MaCS non-reproducibility claim is stronger than what the chapter measures, and partly contradicted by a probe
`04c:154-165`, `04c:172-196`, `04c:234-252`, `04c:262-264`, `04c:1316-1320`, `04c:1562-1563`; same claim in
`R/13_alphasimr_bridge.R:47-60` roxygen and CLAUDE.md.
- The only evidence in the chapter is ONE pair of `runMacs(species="MAIZE", nChr=10)` calls (125-136). Line 178
  says the table "shows it is not `runMacs2`-specific but true of MaCS generally": the table never calls
  `runMacs2`, and the inference runs the wrong way. Step 8 (all of it declared "not reproducible from the seed")
  rests on a `runMacs2` property the chapter never tests.
- My probes (AlphaSimR 2.1.0, same machine, `set.seed(7)` before each call, `identical(@geno)` against the first call):
  `runMacs` MAIZE 20x10x50 default threading: 11/11 and 29/29 differ; **same call with `nThreads = 1`: 0/11 and
  0/29 differ**; `runMacs` GENERIC default 0/11. `runMacs2` at the Step 8 config (24x5x150), splits 0/10/100/1000,
  default and `nThreads = 1`: 0/39 differ in all eight cells (quiet machine) and 0/24 under 24 busy processes.
  But `set.seed(1); runMacs2(...)` (the chapter's own `rrs_cfg$seed`) gave 2 distinct outputs in 4 default-thread
  calls (seeds 2, 3, 7, 11: 1 distinct), and 3 early short probes on a loaded machine showed differing `runMacs2`
  output even at `nThreads = 1`. So: non-determinism is real, intermittent, seed- and thread-dependent, and
  `nThreads = 1` removed it in every quiet-machine test. The mechanism "MaCS output is not a deterministic function
  of the seed" is not established; "default multithreaded `runMacs` is not reproducible" is.
- Consequence: `bridge` returns founders that differ between calls for some seeds, but in the Step 8 config
  for most seeds the founders ARE the same object (tbl-alphasimr-founders, cycle1, `arms[[1]]`, `res` all use
  seed 1); the chapter calls `res` "one further founder draw" (1978) -- whether that is true is not known.
- Fix (decision for the parent, CLAUDE.md records the unseeded-MaCS rule): add to `tbl-alphasimr-engines` a
  `runMacs2` row at the Step 8 config and a `nThreads = 1` row, each over >= 20 seeds including seed 1 (count of
  calls differing from the first, reported as k/n); reword 154-165 and 178 to what that table shows; if
  `nThreads = 1` holds, expose `nThreads` in `alphasimr_founder_pools()` (default `NULL` = unchanged numbers) and
  say so; if it does not, report the counts as the evidence. Until then change 178 to "measured here for
  `runMacs`; `runMacs2` per the help page of the bridge, not measured in this chapter".

### 04c-R2 (HIGH) -- Comstock et al. (1949) attributed content, unread (THREAD owed, 04c:20-23 and 04c:916)
05b settled it: cited for existence and title only (05b:1035-1039, 05b:1071). 04c still says RRS is
"improved by reciprocal recurrent selection (RRS) [@comstock1949]" (22-23) and "The reciprocal recurrent
selection of @comstock1949 is built on using the opposite pool as the tester so that selection captures both"
(915-917), the second beyond the title ("...both general and specific combining ability"). `R/13:101-104` repeats
"-- Comstock, Robinson & Harvey (1949)". Fix: define RRS in the book's own words (opposite pool as tester),
cite the paper as "the procedure introduced under that name; its content is not reported here beyond its
title", drop "is built on ... so that selection captures both" or mark it the book's reading.

### 04c-R3 (HIGH) -- Kempthorne as "classical ancestor of `alpha`" and "exactly zero" (THREAD 02b-E8, 04c:1239-1243)
"That is the construction of @kempthorne1959 and, as @sec-response argues, the classical ancestor of this book's
`alpha` constraint" contradicts 02b:754-758 (paper not read; matrix form is the book's own) and 02b:~775-785 /
`R/15_response.R:97-101` (the lineage of constraining a group coancestry is Meuwissen 1997/2020; "the restricted
direction here is a trait combination, not a coancestry"). 02b never says ancestor. Also "holds trait 2 at exactly
zero" (1239): the chunk shows the EXPECTED gain `G b / sqrt(b'Pb)`, 6.6e-17 here, asserted `< 1e-10 * max|dG|`
(1201); it is not a realised response. Fix: "holds trait 2's expected gain at zero (here `r fmt_sci(...)`)";
replace the ancestor sentence by 02b's statement (a restricted direction; the Meuwissen lineage constrains a
coancestry; neither paper read for the claim) and cite @sec-response for that.

### 04c-R4 (MED-HIGH) -- Step 7 "examines the `weights = NULL` default" with phenotypic criteria (THREAD 02b-C10, 04c:1176-1178)
02b:640-650 and 02b:735-738: the pipeline's criteria are predicted values (BLUP), for which equal weight on
standardised predictions is the index of `a`; the Smith-Hazel gap "is a property of an index on phenotypes; it is
not a defect of `weights = NULL`". 04c uses `P` = phenotypic covariance (1164), so the 4.1x trait-1 gain and the
0.2 % loss at 1229-1238 are about phenotype indices; 1176-1177 says the default "gets examined" here and
1225-1226 "(1,1) is not an eigenvector of P^-1 G" is presented as bearing on it. Step 8 itself ranks on the
raw testcross phenotype of trait 1 only. Fix: state the phenotypic-versus-predicted distinction in one paragraph
and say what the AlphaSimR instance adds (realised `G`, `P` from a simulated population with `corA`/`setVarE`,
and the numerical Smith-Hazel optimum check, 1248-1252); reword 1176-1178.

### 04c-R5 (MED) -- `r` against the breeding value vs `r` of @eq-response-breeders (THREAD 02b-C8, 04c:849-851)
04c defines `r` as the correlation with `bv()` and says only the additive part is transmitted; it does not say that
@eq-response-breeders (02b:93-98) defines `r` as the accuracy "as a predictor of genetic value", which differs
from this `r` unless `d = 0`. Add one sentence after 851 and name the book's equation. Data: `R_S_h2` and
`R_i_r_sdA` agree to 0.5 % (0.657 vs 0.653 at q = 0.05), so the numerical check is unaffected.

### 04c-R6 (LOW) -- "dominance deviation" (THREAD 05b, 04c:333)
05b:148-155 reserves "dominance deviation" for Fisher's statistical object and calls `d_k` the dominance effect.
Change 333 to "the dominance effect". THREAD 01-C13 (04c:318-322) is SETTLED: 326-328 and 90-notation:553 now say
the 0/1/2 dosage is an entry of M^H, not of X. THREAD 05b "keep true" items (04c:272-357, 505, 12-15, 1993-2002,
1280, 105) still hold.

### 04c-R7 (MED) -- Step 7: realised heritability far from the requested value, unexplained (1152, 1171-1174, 1182)
Captions say "h^2 = 0.6 and 0.1"; the table shows 0.47 and 0.072 (and the prose "differ ... sharply in
heritability -- the ordinary situation"). Cause (Step 3, already measured): `setVarE(h2)` is set from the
founders' genetic variance, which three rounds of random mating roughly halve (varA 1.00 -> 0.45 in Step 3).
Say so in one sentence with the two requested and two realised values inline; as written a reader sees a
requested/realised mismatch of 22 % and 28 % with no reason.

### 04c-R8 (LOW-MED) -- hand-typed numbers and verdicts that depend on a draw
- 675-677: "about a third", "two DH standard deviations", "a few percent" for 0.32 / 0.025, 0.010 / gap 1.95, 2.19
  (values on this render; 20-seed range of the 2 low crosses 0.5-6 %). Make them inline from `lottery`.
- 970-973 "nearly vanishes"/"almost perfectly" (0.997, mean|1-2pB| 0.144), 1113 "small", 1129 "agree" (max|z| 1.63),
  1171 "near the requested -0.4" (-0.416): inline-compute or tie to a stated threshold.
- Table captions carry configuration numbers typed by hand (48 draws, 47 d.f., 20 draws, 12+12, 6 x 6, 36
  hybrids, 8 of 36, 5 chromosomes x 150): 1286, 1344, 1427, 1596, 1715, 1734, 1780, 1964. The figure caption is
  built from `n_rep`/`rrs_cfg` (1789); use `#| tbl-cap: !expr` the same way.
- 1239 "exactly zero" -> see R3. 484-486 "varD ... exactly zero" is `9.6e-33` (assertion `< 1e-10`): write
  "zero to rounding (`r fmt_sci(vtab$varD[1])`)".

### 04c-R9 (LOW) -- `fmt(10)` hides near-zero differences (884, 1251)
`optim` vs Smith-Hazel difference is 1.1e-15 and prints `0.0000000000`; use `fmt_sci` (`_common.R:48`) or print
with `signif`. `sel_intensity` vs `selInt` is exactly 0 on this render, so state "identical" from `identical()`
or use a tolerance and `fmt_sci` of the residual.

### 04c-R10 (LOW) -- a partition identity stated, not asserted (1327-1328)
`GD_T = GD_WI + GD_BI + GD_BS` is stated for `ct_partition()`; the chunk asserts only `F_ST = GD_BS/GD_T` and
`GD_T = mean(h_s)` (1373-1375). Verified here: residual 0 on a pool pair. Add
`stopifnot(isTRUE(all.equal(ct$diversity[["GD_T"]], ct$diversity[["GD_WI"]] + ct$diversity[["GD_BI"]] + ct$diversity[["GD_BS"]])))`.

### 04c-R11 (INFO) -- cost and fragility, no defect
Live cost: 1.8 min for the whole chapter (Step 1 `runMacs` 2.6 s, 48 draws x 2 arms, 80 split draws); the
`arms` chunk (1668-1705) and 80 `split_draw` calls dominate. Unlabelled chunks (80, 96, 289, 337, 881, 1248,
1668) draw no figure, so none orphans; label 1668 (`run-rrs`) since it is the one a later `plot()` would hit.
`arms` is rebound in 1741 (non-idempotent re-run is harmless). Tied draws: split seeds `100*s + r`
(1..20, 1001.., 10001.., 100001..) are distinct and all unrelated to `arms` seeds 1..48.

## Owed items from THREAD.md
| item | status |
|---|---|
| Comstock 04c:20-23, 916 | OPEN -> R2 |
| 01-C13 04c:318-322 (0/1/2 vs 0/0.5/1) | SETTLED (326-328; 90-notation:553) |
| 02b-E8 04c:1242, 1239 | OPEN -> R3 |
| 02b-C8 04c:850-856 | OPEN -> R5 |
| 02b-C10 04c:1178 | OPEN -> R4 |
| 05b "dominance deviation" 04c:333 | OPEN -> R6 |
| 05b/03 "keep true" (272-357, 505, 12-15, 1993-2002, 1280, 105) | still true |

Side effect to know: my end-to-end run wrote `book/Rplots.pdf` (untracked; it was already untracked before the
run); delete it if it is not another session's file.
