# 04d-breeding-programme -- iteration 1 audit (read-only)

Chapter: `book/04d-breeding-programme.qmd` (443 lines), worktree `SB_quanti_gen-review-04-06`, branch `review-04-06`.
Nothing under `book/`, `R/`, `docs/` or `CLAUDE.md` was edited. Scratch scripts and outputs are in the session scratchpad only.

## What was run

- Whole chapter purled (`knitr::purl`) and run live, installed `hybdiv`, AlphaSimR 2.1.0: **37 s wall** (96 programme runs, 0.38 s per run).
- Every number in the chapter's tables reproduces the frozen numbers in `book/_freeze/04d-breeding-programme/execute-results/html.json` AND `typ.json` digit for digit (`-2.831`, `0.0285`, `0.2131`, `5.5676`, `0.3404`, `4.1209`): the chapter is deterministic across sessions and across the two format executions.
- `book/_freeze` hash (md5 of the .qmd, `cd6248c9...`) matches the source; `book/downloads/04d-breeding-programme.R` equals `docs/downloads/...`; docs figures = `fig-programme-arms-1.png`, `unnamed-chunk-2-1.png`, and the frozen HTML/typst figures are the same two; no ` N` duplicates tracked.
- Probes (my scripts, not chapter code): determinism of `run_programme` (identical on repeat), years 1-5 identical between arms over seeds 1:6, five fresh batches of 24 seeds (120 seeds), a lever decomposition over 48 seeds (arms checked to reproduce the chapter's two arms with `identical()`), an AlphaSimR GxE mechanics probe, neutral vs QTL loci, sizes of each stage.

## Provenance: cached vs live

All code is live at render. The chapter reads no `book/data`, no `book/figs`, no `report/`, `data/` or `reference/` (no `book_data()`/`book_fig()`/`read.csv` call). No csv belongs to 04d, so no producer in `book/scripts/regenerate.R` is expected and none exists (grep `04d|programme` in `regenerate.R`: nothing). Nothing in the chapter is external or cached; the Scale paragraph (04d:414-416) says "all live at render" and that is true. The `book/data/cycles_*.csv` files are 11b's, not read here.

## Findings

Severity: H = a claim the code does not support or contradicts; M = a claim that rests on one seed set, an undeclared design choice, or a number not tied to code; L = wording, form, guard.

### 04d-R1 (H) "two levers ... separated so their effects can be told apart" is not what the code does (04d:250-261, 263-268, 398-399)

`run_programme(genomic = TRUE)` switches both levers together (`gs <- genomic && year >= gs_from` drives both the `ebv` PYT -> AYT step, 177, and the PYT recycling, 194). No arm runs one lever alone. The Assumptions paragraph says "two distinct genomic-selection levers separated so their effects can be told apart" (398-399); the section title says "two levers, not one"; and the claim that the second "is normally the larger" is cited to the literature (253) and is never measured here.

Decomposition I ran (48 seeds, paired, same chapter code with one switch each, `genomic` arm reproduced with `identical()`):

| arm | gain/yr (ps 0.0569) | t vs ps | GD_PYT yr 15 (ps 0.364) | diff / t | GD parents diff / t |
|---|---|---|---|---|---|
| lever 1 only (ebv at PYT -> AYT) | 0.0667 | 5.3 | 0.3609 | -0.0031 / -0.77 | -0.0113 / -2.58 |
| lever 2 only (parents by ebv from c(EYT,AYT,PYT)) | 0.0821 | 12.6 | 0.3440 | -0.0200 / -3.93 | -0.0260 / -5.61 |
| both (chapter's GS arm) | 0.0864 | 12.9 | 0.3456 | -0.0184 / -3.03 | -0.0274 / -4.75 |

Two things follow. (a) The literature statement "second is the larger" is supported here (0.025 vs 0.010 per year), but the chapter must say it was measured by an extra run, or drop "so their effects can be told apart". (b) See R2: lever 2 is confounded with a selection step the phenotypic arm does not have.

### 04d-R2 (H) The "generation interval" lever is confounded with parent selection intensity; the mechanism in 337-344 is untested (and the data point elsewhere)

The phenotypic arm sets `Parents <- c(EYT, AYT)` (202): all 16 lines, **no truncation**. The genomic arm sets `Parents <- selectInd(c(EYT, AYT, PYT), nInd = 16, use = "ebv")` (199): the top 16 of 76. So the arms differ in (i) criterion accuracy, (ii) cohort age (the recycling a year sooner), and (iii) whether parents are truncated from a wider candidate set. Control I ran, "lever 2 with plain phenotype" (parents = top 16 by `pheno` from c(EYT,AYT,PYT), no ebv anywhere): gain 0.0715/yr (t = 6.7 vs ps), and the **largest** diversity loss of all arms (GD_PYT yr 15 = 0.3322, diff -0.0318, t = -5.76; parents -0.0290, t = -5.75). So the loss of diversity in the lever-2 arms is produced by truncating parents out of a larger candidate set, with or without genomic information. The text (337-344) says it is "structural": recycling a year before "the trial data could have distinguished full sibs, so the parents chosen are more closely related". No coancestry between chosen parents is measured anywhere in the chapter; the claim is an assertion. Either measure it (mean `f` among parents is already computed as `gd_parents`) or restate as a hypothesis, and name the extra truncation as a difference between arms.

### 04d-R3 (M) "gene diversity ... is significantly lower under genomic selection at year 15" holds on the printed seed set only marginally (04d:337-339, table 301-303)

Printed: mean difference -0.0280, t = -2.83, df = 23 (critical 2.07). Five fresh batches of 24 seeds (seeds 1:24, 25:48, ... 97:120): t = -2.83, -1.31, -4.77, -1.72, -4.34; mean differences -0.028, -0.009, -0.028, -0.011, -0.035. So the sentence is true in 3 of 5 batches of the size the chapter uses; pooled over 120 seeds t = -6.4, difference -0.0222, and the GS arm ended lower in 69% of seeds. The sign is robust, the "significantly" is not at n = 24. Gain per year: t = 8.1, 10.3, 12.4, 8.7, 8.7 (GS higher in 119/120 seeds), ratio of mean rates 1.49, 1.55, 1.58, 1.52, 1.43 -- "roughly half" (333) holds on every batch. The parent-set loss (the ledger's second pair of columns) is the stronger contrast (pooled t = -8.1) and is the one the chapter says is "the population that actually transmits" (349), yet it is never tested; test it, or enlarge the seed set, or write "lower in most seeds" with the proportion. The table reports no standard error, only `t`.

### 04d-R4 (M) Hand-typed numbers in prose and figure that should come from `sch` (criterion 1; 04d:36-76, 333)

Typed in prose: "Four hundred ... sixty ... twelve ... four ... at four ... eight locations" (71-75), "roughly half" (333, value 1.49 here). The figure (49-52) hardcodes "20 crosses", "400 lines", "400, 1/4 rep", "60, 1 loc", "12, 4 loc", "4, 8 loc". I checked they agree with `sch` and with the objects the run produces (F1 20, DH 400, HDRW 400, PYT 60, AYT 12, EYT 4, parents 16, 20 families; GS and PS arms identical sizes), so nothing is wrong today; they will go stale if `sch` changes. Compute the labels from `sch`, with `stopifnot(sch$n_crosses * sch$n_dh == 400)`-style asserts, and make the 1.49 an inline value.

### 04d-R5 (M) Prose asserts an identity with no `stopifnot` (criterion 3; 04d:275-278, also 242-247)

"Years 1 to 5 are identical to the phenotypic arm, digit for digit" is the whole justification of the pairing and is only visible by eye in four printed rows. I verified it over seeds 1:6 (`identical(a[1:5,], b[1:5,])` TRUE for every seed), the run is deterministic and reproduces across sessions. Put `stopifnot(identical(ps[seq_len(5), ], gs[seq_len(5), ]))` in the chunk at 271 and in the replicate loop (cheap). It also guards the case where `quickHaplo()` is swapped for `runMacs2()` (see R9).

### 04d-R6 (M) The GxE model is described in a way AlphaSimR does not implement (04d:74-76, 91-93, 405-408; continuity with 04f:2101-2105)

Measured on AlphaSimR 2.1.0 (`setPheno()`/`calcPheno()` source and a probe):
- `reps` divides only the plot error `varE` (resid var reps=1 vs 8: 0.314 vs 0.039, ratio 8.0, with the GxE term removed exactly). It does not average the GxE term.
- GxE enters as `gxe_i * qnorm(p)`, with ONE scalar `p ~ runif(1)` per `setPheno()` call, shared by every individual of the call. There is no per-entry, per-location draw; "eight locations" at EYT (`rep_eyt = 8`) is one environmental deviate, not eight. Each call (each stage, each year) draws its own `p`; the `onlyPheno` call for `ebv` draws a different one from the phenotype's.
- Consequence: the realised GxE variance among entries in a call is `0.2 * z^2` (mean 0.20, i.e. twice `var = 0.1`), a random per-call scale of a second set of effects at the same loci. Accuracy `cor(gv, pheno)` for 40 founders, 300 calls: reps 1: 0.38 (sd 0.20); reps 8: 0.60 (sd 0.26); with `varGxE` ~ 0, reps 1: 0.46, reps 8: 0.82. So eight "locations" lift accuracy from 0.38 to 0.60, not 0.82, and the accuracy at any stage-year varies widely with `p` (seed 1's `acc_pyt` in the printed rows ranges 0.18-0.49).

Therefore: line 74-76 "because the error variance has been divided by eight locations" is true of the error term only; 405-408 "a 'location' here is an independent draw rather than a place" is not what the code does -- a location is a call, its GxE draw is shared across entries and not reduced by replication. This is the continuity note: 04f:2101-2105 repeats "models locations as independent draws" and inherits the same inexactness; 04f's result 6 uses the correlation `Vg/(Vg+VgxE)` = 2/3 between locations (R/17:54). The honest statement for 04d is: replication shrinks plot error only; the GxE component is one environment draw per trial, identical for all entries and not averaged by `reps`; the staged-trial trade-off here therefore is entries versus plot-error precision, not entries versus environments sampled. Edit 04d (and the 04f sentence) together; also say how large the GxE draw is against `varG` since it is not stated anywhere.

### 04d-R7 (M) Burn-in prose is off by one pass (04d:122-125) and `n_burn` is not what the loop reads

The code `if (year < 3) EYT <- ...` runs the elite trial on passes 1 AND 2 and skips it from pass 3. Prose: "On the first pass every stage runs ... On the second pass the elite trial is skipped". Wrong by one: EYT is skipped on the third pass, AYT on the fourth, PYT on the fifth, HDRW on the sixth, DH on the seventh (matches the thresholds 3,4,5,6,7). The end state is the staggered one the prose describes (traced by hand: EYT from the year-2 cohort, AYT year 3, PYT year 4, HDRW year 5, DH year 6, F1 year 7), so the code is right and the sentence is wrong. Also 103-104 "this year's elite trial entered the programme six years ago": the cohort in EYT at advancing year 1 was crossed five years before the crossing block (year 2 vs year 7), reaching the variety one year later (six years from cross to `Variety`); reword to say what is meant. The thresholds `7, 6, 5, 4, 3` are literals while `cfg$n_burn = 7` is a parameter: add `stopifnot(cfg$n_burn == 7)` or derive them. The `Variety <- selectInd(EYT, 1)` (173) is computed and never used or reported while the chapter says the product is a variety (17): either report it or say it is a placeholder.

### 04d-R8 (M) Diversity "ledger": starting point, comparability across columns, no dispersion (04d:346-371)

- The reference for the "loss" (361) is year 1 of the advancing loop, i.e. after the 7-year burn-in, not the founders. Seed 1: `gd` of the 40 founders 0.4862; year-1 PYT 0.4647 (4.4% already spent), year-1 parents 0.4353 (10.5% already spent). The chapter says "the programme's own starting point" (367): say it is the end of the burn-in and give the burn-in loss, or the 21%/27% figures understate the programme's total loss. (From the printed 24-seed means: PYT 0.2131 / 0.2729, parents 0.1788 / 0.2470.)
- "Those four numbers are exactly the quantity this book calls `alpha`" (366) is then qualified in the same sentence as not against a same-size random baseline. Per CLAUDE.md `alpha` is relative to `gd_ref`, a random-subset baseline. Rephrase: these are proportional losses against the programme's own year-1 value, not `alpha`.
- No random/no-selection arm exists in 04d; the confound with drift is flagged only in a parenthesis. I measured how much of the loss is plausibly not selection: with 600 neutral loci added beside the 600 QTL (quickHaplo no LD), 24 seeds, PYT loss 0.226 at QTL loci vs 0.221 at neutral loci (ps), 0.275 vs 0.262 (gs). The neutral loci lose ~98% of what the QTL lose: the loss is dominated by the bottleneck (16 parents, 20 crosses), not by direct selection on the diversity-measuring loci, and the GS-minus-PS difference at neutral loci is t = 1.83 (QTL: t = 2.18) on that run. Two consequences: the "markers = QTL" choice (all 600 segregating sites are QTL, `segSites = nQtlPerChr = 60`; `pullSegSiteGeno` returns the 600 QTL) is not declared in Assumptions (04d:393-412) and should be, as 05/08b do; and the chapter's ledger cannot separate selection from drift without the random-parents arm that 04c Step 8 builds (04c:2168-2176 explicitly says 04d lacks one; keep that true, or add the arm and then 04c's sentence becomes false -- THREAD 04c item).
- `gd_pyt` is on n = 60 lines and `gd_parents` on n = 16: `theta` includes the diagonal `1/n` (here 0.017 vs 0.0625), so the two columns' levels are not like-for-like (off-diagonal GD year 1, seed 24-mean: PYT 0.476, parents 0.471; the printed gap 0.468 vs 0.442 is mostly the diagonal). Within a column across arms n is fixed, so the loss ratios are fine; say so, or do not compare levels across columns.
- The four loss numbers and the ledger rows are means over seeds with no dispersion (criterion 8); the figure shows the mean of 24 paired runs only, no band, though the caption says "Twenty-four paired runs".

### 04d-R9 (L, owed: MaCS wording, USER DECISION) 04d:242-247 vs what 04c measured

04d:244: "unlike @sec-alphasimr's Step 8, whose `runMacs2()` founders are not reproducible". 04c (Step 1 callout, 04c:222-231 and 1480-1482) states: one pair of `runMacs()` calls per render, stream identical, **nothing established for `runMacs2()`**, "not established ... the help page, @sec-limits and @sec-programme treat as not reproducible". So 04d is the unqualified statement 04c explicitly names. Report only, not edited (CLAUDE.md and 11c:193-205, index:188/216, R/13:47-64 carry the same wording; reconcile all or none per the THREAD item). What 04d needs under either outcome: the sentence "same seed, same founders" for `quickHaplo()`, which I verified (determinism, identical years 1-5 over 6 seeds, identical across the HTML and typst executions). Note what the chapter's design is: it does NOT found once and branch; it re-calls `quickHaplo()` after `set.seed(seed)` for each arm (141-143), which 04c's rule 1 admits is safe only because `quickHaplo()` is pure R sampling. `set.seed()` is immediately before the only stochastic draw sequence (`run_programme` line 141), once per arm per seed; there is no MaCS call, so CLAUDE.md's "poisons everything downstream" is not engaged here. The `stopifnot` of R5 is what would catch a later swap to MaCS.

### 04d-R10 (L, owed: 04-C3/M20) 04d:373-383 status-number note says the old diagonal argument

"a homozygous line has self-coancestry `f_ii = 1` and the diagonal dominates the mean. That is the same arithmetic @sec-sizing explains for a biparental cross". 04 now (04:1157-1172) explains `N_s = 1/(2 - D)` in `[1/2, 1]` for every set of lines as a monotone rescaling of `theta`, "not a head count", and says explicitly it is not a pooling/diagonal effect. Numerically here the diagonal does not dominate: at n = 60 its share of mean `f` is 0.0167/0.53 = 3%, at n = 16 it is 0.0625/0.56 = 11%. The value is "at most 1" because `theta >= 1/2`, whichever the n. Rewrite the callout to cite 04's `[1/2, 1]` statement; the conclusion (use `GD`, not `N_s`) stays. The chapter computes no `N_s`, so no number moves.

### 04d-R11 (L, owed: 02b-C8) 04d:259-261 "the breeder's equation of @sec-response is a rate per unit time"

`@eq-response-breeders` is `R = i r sigma_A` for one round (02b:93; grep for "per unit time", "interval", "annual", "per generation" in 02b: nothing). The rate form `Delta G / T` is not in 02b. Either 04d writes the rate form itself (`i r sigma_A / L`, with a source) or 02b gains it. Same for the closing reference at 424-425 ("@sec-response is where the breeder's equation says why a shorter generation interval raises gain per year"). No cycle length in years is stated for either arm in 04d, so the claim "cutting years off the cycle" is not quantified; 04d never says how many years lever 2 saves (the chapter's own scheme: parents from PYT vs EYT/AYT, i.e. two to three years earlier by the figure).

### 04d-R12 (L, owed: marker-vs-QTL, 04d:423-429) -- kept true after the 05 review; no residue

Current text (426-430) attributes the finite accuracy to "training size, noise and the rank bound, not because of a marker-versus-QTL gap. This book does not measure that gap, and @sec-genomic-era (assumption A5) states its collapse as a limit." This agrees with 08b:55-60, 1236-1246 and 05:128-133. The owed item in the THREAD (08b entry "04d:425-428") is therefore settled in the text; the line numbers are now 426-430. The item as named ("04b marker-vs-QTL promise ~426-429") has no 04b origin: `grep` in 04b finds no marker-QTL promise and no 04d reference; the promise is 04c:434-436, also reworded. What remains is R8's point that 04d itself uses the marker = causal set (all 600 segregating sites are QTL) and does not declare it.

### 04d-R13 (L, owed: 04e/04f/04g not cited) The chapter is silent on the Mating and testing design part

04d cites none of `@sec-mating`, `@sec-sparse`, `@sec-joint` (grep: none). It sits after that part in `_quarto.yml` (04d is in "Evidence and practice") and its staged-trial trade-off (24-27, 76) is exactly the problem 04f/04g study with a different (REML/known-component, correlated-location) model. Minimum: one sentence in "Where this connects" (420-436) or in Assumptions that 04d's staged-trial trade-off uses plot-error replication only (R6) while @sec-sparse and @sec-joint treat the choice of locations with a genetic correlation between them; 04f:2101-2105 already points back to 04d as "an analogy to result 6, not a replication" (that sentence stays true if R6 is fixed in both).

### 04d-R14 (L, owed: 04d vs 11b / 11 cycle-cost) the "diversity cost per cycle" promise (04d:9-11) and 11:669, 11:707-708

04d:9-10: "The seventh consequence ... is to report the diversity cost per cycle explicitly whenever cycles are shortened. This chapter measures that cost". The chapter reports cost at year 15, and per-seed paired differences, not per cycle and not per unit of cycle-time saved; no cycle length is stated for either arm (R11). 11:669 ("Diversity cost per unit of cycle-time reduction ... Gene diversity at year 15 in an inbred-line, wheat-type programme (@sec-programme); not hybrid maize") inherits that gap. To be true as written, 04d needs a per-cycle rate (loss per year or per recycling cycle, e.g. from the ledger's slope) and the cycle-length change; or 04d:9-11 and 11:669/707 are softened to "cost at year 15 in a simulation". 11b has no random arm (grep: nothing), so 04c's sentence about 11b stays true; 04d vs 11b: 11b follows a budgeted `alpha` against a frozen base across cycles, 04d an unconstrained programme against its own year-1 value -- the two are not on the same baseline and the chapter says only "the same tension" (432-434); say which baseline each uses.

### 04d-R15 (L) Guards, references, form

- `library(AlphaSimR)` is unguarded in the `include: false` chunk (6) and in the download script; AlphaSimR is `Suggests`. Same convention as 04c (04c:111 declares the two chapters need it); no `requireNamespace()` guard or `eval:` condition, so a render without it fails at line 6. Acceptable if declared; the chapter does not declare it.
- "the course" (29, 108) is never cited: add `[@gorjanc2022]` (in `references.bib`; 04c cites it). Also "wheat programme of @gaynor2017 ... an order of magnitude larger in every dimension" (21, 416): not verifiable from the repo; the stage sizes (400/60/12/4) are the course's, not shown to be Gaynor's.
- Both figures: `unnamed-chunk-2-1` (stage diagram, has a `fig-cap` but no `#| label:`) will orphan on any chunk added or removed above it; label it. `fig-programme-arms` is never cited with `@fig-programme-arms` in the text.
- Cost: `reps` (284-295) and `traj` (313-314) both run the same 48 programme runs; compute once and keep the trajectories (halves the 37 s). Complexity per run is `O(n_years * n_dh * n_crosses * n_loci)` for the genotype pulls dominated by `pullSegSiteGeno` and `molecular_coancestry` on 60 x 600; measured 0.38 s per run at this scale (40 founders, 600 loci, 15 years); no profile taken.
- `gd_of()` passes `pullSegSiteGeno()/2`, i.e. 0/1/0.5 coding into `molecular_coancestry()` (expects 0/0.5/1): correct for DH lines (0/1) and for outbred F1 (0.5); marker coding is fine.
- `stats::coef(...)[2]` in `rate()` returns a named element; harmless.
- Rate regression window `year >= 6` (289-290) includes the three years before the first GS-derived parent reaches the PYT (about year 9): it understates the steady-state GS rate; say the window is chosen from the switch-on year and that the effect lags.

## Seeds (criterion 2), Monte Carlo margins (7), comparisons (8)

- `set.seed(seed)` at `run_programme` line 141, immediately before `quickHaplo()`, per arm per seed; no draw outside `run_programme`; no AlphaSimR founder from MaCS. PASS. (`_common.R` sets `set.seed(2026)` once at the top; nothing stochastic runs before the seeded function.)
- Stochastic assertions and margins over 120 seeds (5 batches of 24): gain sign and size robust (margin: t >= 8 in every batch; ratio 1.43-1.58). Diversity sign robust at 120 seeds, "significant" at n = 24 in 3/5 batches (R3). Lever decomposition on 48 seeds (R1/R2).
- Comparison unit = seed (founders + burn-in + years 1-5 shared); n = 24; pairing correct (`paired()` on the seed-wise differences); dispersion: only `t`, no s.e., no CI, no p; figure shows means only.

## Owed items from THREAD naming 04d, disposition

| Owed | Status in this audit |
|---|---|
| 04d:244 MaCS wording vs CLAUDE.md (USER DECISION) | R9. Not edited. 04d says "not reproducible" unqualified for `runMacs2()`; 04c measured one `runMacs()` pair and no `runMacs2()`. Needs the user's all-or-none decision; the `quickHaplo()` half is verified true here. |
| 04d:423-428 marker-QTL gap | R12. Reworded; consistent with 05 and 08b; the 08b entry's Owed line number is stale (now 426-430). |
| 04d does not cite 04e/04f/04g; locations as independent draws vs 04f result 6 correlation 2/3 | R13 and R6. The "independent draws" phrase is also not accurate for AlphaSimR (shared p per call, GxE not averaged by `reps`); 04f:2101-2105 should be edited with 04d. |
| 04d vs 11b / 11 cycle-cost | R14. |
| 04b marker-vs-QTL promise ~426-429 | R12: not a 04b item; the promise was 04c:434-436. |
| 04d:260 (02b-C8), 04d:376-379 (04-C3) | R11, R10: still open as listed. |
| keep-true items about 04c (04d:366-370 quoted verbatim; no random arm) | Confirmed true at 04d:366-371; if R8's random-parents arm is added, 04c:2168-2176 and 04c:2316-2324 become false. |

## Verdict for this iteration

Numerically the chapter is sound and reproducible (deterministic, freeze equals a fresh run, sizes match the figure, arms identical through year 5). Disqualifying content findings: R1 and R2 (the two-lever claim and the mechanism of the diversity cost are not supported by the arms as built; the lever-2 loss is produced by truncating parents, with or without genomic information), and R6 (the description of replication and locations does not match AlphaSimR's GxE). R3 is a margin problem (significance holds in 3 of 5 seed batches). Everything else is M/L.
