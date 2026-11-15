# Verdict -- Part "Metrics and prediction" (05, 06, 07, 08, 08b), iteration 3

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-04-06. Read: part-metrics-and-prediction-verdict.md
(REJECTED: metrics-D1, M1-M4 open), the "Iteration 2" rows of part-metrics-and-prediction-response.md, and the
changed text of 06 (499-505, 315-330), 07 (355-366, 668-686, item 3 "At validation", 1076-1090), 90:97,
08b:1180-1196, 11b (chunk head), R/14_cycles.R:130-150, R/01_metrics.R:195-236, the `cycles_*.csv` headers.
Chapter 09 not judged.

VERDICT: APPROVED

No H finding is open. Every disqualifying criterion holds on the text of this part as it now stands. The
part closes. What remains owed to other chapters is listed below and does not belong to this verdict.

PREVIOUS IDS
- metrics-D1 -- CLOSED -- 06:499-505 now says `run_cycles()` logs `theta_A`, `theta_B`, `GD_T`, `GD_BS` every cycle and that
  the cached `cycles_*.csv` carry them (R/14_cycles.R:139-146: `GD_BS`, `GD_T`, `theta_A`, `theta_B` in the logged
  data.frame; headers of cycles_injection, cycles_maxuse, cycles_selector, cycles_trajectory all contain
  "GD_BS","GD_T","theta_A","theta_B"; cycles_crossover.csv has a different schema and is not claimed). It says that
  @sec-cycles aggregates and plots only index, GD, GD_BS, F_hom, F_drift, max_line: the `avg()` of 11b's setup chunk
  uses exactly those six columns, and grep of 11b finds no `theta_A`, `theta_B`, `GD_T`, `var_g`, `var_genic`,
  `Ns`, `alpha`, `GD_pool` read. The conclusion "states, does not demonstrate" follows. The false "logs only" is gone.
- metrics-M1 -- CLOSED -- 06:315-330 scope is now @sec-choosing and @sec-stages (with the 90 row) and names the other
  senses (02, allelic diversity of Caballero & Toro 2002; 11, values reported by reviewed studies); both labels exist
  (02-subdivided {#sec-subdivided}, 11-plant-literature {#sec-plant-literature}). The R/01_metrics.R:232 residue is
  closed too, see below. 08:867/877 stays on the owed list.
- metrics-M2 -- CLOSED -- 07:361-364 and 90:97 state that `alleles_retained` (07) and `alleles` (08) are identified with
  @eq-catalogue-alleles-retained by inference only, that the producer and set are not available, and that 08 records no
  set. The limit is now declared where the identification is used.
- metrics-M3 -- CLOSED -- 07, item 3 of "At validation" (line ~970): `alleles_retained_fast(idx, ctx)` takes hybrid indices,
  S_L = the lines used as parents of the plan, same count as the equation on the {0, 0.5, 1} hybrid matrix under A2, "not
  computed in a chunk here". Mapping and limit both stated. Consistent with my previous check (hybrid-index route = equation
  on the parent set = count on the F1 matrix).
- metrics-M4 -- CLOSED -- 07:675-681: the garbled quantity is gone; the text says the accuracies are against one trait, not the
  three-trait index, so the comparison is of orders of magnitude only (08b:1186-1188, same caveat); CV2 mean "about 0.9, at
  the lower edge of the 0.9 to 1 values explored here", CV1 "between 0.5 and 0.7". CV2 mean 0.905 and CV1 0.665 (previous
  recomputation, 08b chunk unchanged) agree.
- R/01_metrics.R comment edit -- CLOSED -- the inline comment above `rare_retained` (not roxygen; man/ untouched, no `document()`
  needed) now says: share of the pool's rare markers (`maf_pop` in [rare_lo, maf)) still segregating in the selection
  (minor allele frequency > 0); a marker share, not the 2m alleles carried (A_ret, ch. 06). I compared it with the code
  line: `rare <- ctx$maf_pop >= rare_lo & ctx$maf_pop < maf` and `mean(pmin(p[rare], 1 - p[rare]) > 0)`. Exact. It no longer
  contradicts 06's use of "allelic richness" for A_ret.
- Earlier closed IDs (C1-C7, C12, C13, C15, C16) -- unchanged, stay CLOSED; C8 is closed by D1 above. C9, C10, C11, C14,
  C17-C21 -- not judged here, owed (see below).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- metrics-M5 R/01_metrics.R:235 -- the retained clause "More sensitive to bottlenecks than He (Caballero & Toro 2002, sec. 11)"
  is an attribution that I cannot confirm from the repository; it predates this review and was not changed. Not decisive,
  inline comment. Goes to quant-refcheck.
- metrics-M6 07:679 -- "the 0.9 to 1 values explored here" refers to Finding 5's grid r in {0.5, 0.7, 0.9, 1}; the 0.9-1 span is
  a reading of the grid by the author, and CV2 across replicates ranges 0.866-0.941 (previous recomputation), so a single
  replicate can fall outside it. The statement concerns the mean and says "about"; recorded, not rejecting.
- Accumulated count: two, below the threshold of three.

WHAT WAS VERIFIED
- D1: `sed` of R/14_cycles.R:130-150 (fields GD_BS, GD_T, theta_A, theta_B in the per-cycle data.frame); `head -1` of
  book/data/cycles_*.csv (four files carry the four columns); grep of 11b-diversity-across-cycles.qmd for the within-pool
  and other columns: no hit; 11b head shows `avg()` over index, GD, GD_BS, F_hom, F_drift, max_line.
- A_ret equation = literal count = `alleles_retained()`: scratchpad/aret2.R, `pkgload::load_all` of the worktree,
  `simulate_pools(25, 25, m = 2000)` (default seed), set.seed(11), line sets of size 1, 5, 25: equation 2000 / 3327 / 3847,
  `alleles_retained()` 2000 / 3327 / 3847; size 1 equals m. `git diff R/05_pipeline_metrics.R` has no hunk touching
  `alleles_retained`; `git diff R/04_fast_metrics.R` touches only roxygen of the line-encoded DE (no change to the bitset
  route), so the previous check of `alleles_retained_fast` on hybrid indices still stands.
- R/01_metrics.R comment against the code of `rare` and `rare_retained` (read, lines 195-236).
- 90:97 row text and 07:355-366 wording read; labels `sec-subdivided`, `sec-plant-literature` exist by grep.

NOT VERIFIED
- `@`-references resolve by grep only, no Quarto render; `docs/` and `book/_freeze/` of 04d, 04e, 05, 06, 07, 08, 08b, 90, 92
  are stale (process; the response says so).
- That `metric_redundancy.csv` `alleles_retained` and 08's ledger `alleles` are computed as @eq-catalogue-alleles-retained
  (external producers); the text now says so itself.
- Not re-run in this iteration: the CV numbers of 08b (previous iteration: CV2 0.905, CV1 0.665, CV0 0.144; chunk unchanged) and the
  redundancy fractions of 06 (unchanged text).
- The Caballero & Toro 2002 sec. 11 attribution in the R comment (M5).

OWED TO LATER CHAPTERS (does not block this part; the part is closed on its own text)
- 09: C9 (09:382-386); C14(c) (09:11-14). Under its own review; not judged here.
- 10: C10 (10:455, caption 10:475, circular definition of the four restrictions); C14(b) (10:43-46, re-point to @sec-simulating-crosses).
- 10b: 10b:1245 "@sec-catalogue's rule applies" (06 states no such rule); 10b:1273 (C20).
- 11: C11 (11:23, 11:306); 11 and 12: "the encoding, not the algorithm, decides" / "minimal non-redundant" (12:222).
- 12: C17 (12:35, "production scale of sim_config"); 12:164-172; 12:264 and 04e:176 "dominance deviation" for d_k.
- 11b: C14(a) cross-link to @sec-genomic-prediction; the within-pool diversity (theta_A, theta_B) is already logged and cached but
  not read: 06 now says so, and whether 11b should read it is its own decision; 11b:77-79 (simulation-C4) and 11b:344-346 (simulation-C11).
- 11c: cross-link to @sec-genomic-prediction (C14a).
- 90: rows for G_VR1, G_VR2, G_i(p), G_LA, G_ROH (05-C19); u / u-hat roles (90:283, 301 against 90:341) and the truth called u in 07, g in
  08b; sigma^2_u against sigma^2_G (04f:278, 684); n_DH row citing `n_per` (90:331).
- 04b: 04b:1195 cites @sec-choosing for `max_use` (owned by @sec-combinatorial).
- 04f, 04g: sigma^2_G vs sigma^2_u.
- 08:867 and 08:877 ("marker alleles retained" for the ledger column `alleles`): the 08 text names the quantity without the
  A_ret label or a pointer to @eq-catalogue-alleles-retained; 90:97 and 07 declare the identification by inference, so no
  contradiction arises, but the ledger table is where the label is used and 08 was not edited. Owed to the ledger-column pass.
- 07 (own, L, not touched): C17, C18, C19, C20, C21.
- Render batch: freeze and docs of the chapters above; Typst widths of the 08b tables (08b-E4) and of 90's function column.
