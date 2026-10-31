# Part continuity review: Simulation

Scope: book/03-simulating-crosses.qmd, 04-population-sizing.qmd,
04b-backcross-introgression.qmd, 04c-alphasimr-pipeline.qmd (in `_quarto.yml` order),
plus their links to 00, 01, 02, 02b, 05b, 90-notation and to every chapter that cites
into or is cited from the part. Paths are relative to the worktree
/Users/ederdbs/Documents/SB_quanti_gen-review. All four chapters were approved one at a
time; this report covers only what shows up when the part is read as a whole.

Severity: H = a reader is misled or a promise points at nothing; M = an inconsistency
a careful reader will notice; L = tidy-up.

## Findings

### C1 [H] Promise to @sec-sizing about inbreeding depression points at a chapter that excludes it
- book/05b-heterosis-dominance.qmd:402-405: "inbreeding depression **is** the live
  quantity wherever the population is only partially inbred: F2, F3 and F4 in
  @sec-sizing ... That is the chapter it belongs to, not this one."
- book/04-population-sizing.qmd:164-166 (P9): "What is not modelled ...
  phenotypic inbreeding depression". 04 has no trait, no $d$ and no genetic value.
- The quantity is actually computed in book/04c-alphasimr-pipeline.qmd:704-778
  (@eq-alphasimr-selfing, @tbl-alphasimr-selfing: heterosis falling by
  $(1/2)^{t-1}$ through F2 to F7) and :494-535 (@eq-alphasimr-mhw, inbreeding
  depression at $F = 1$).
- Problem: the forward promise is not kept. The target chapter explicitly disclaims
  the topic.
- Proposed change: point the 05b sentence at @sec-alphasimr Step 5 (or Step 3), or
  have 04 take on the claim. The first is far cheaper.
- Owner: 05b.

### C2 [H] What @sec-sizing sizes does not match what the rest of the book says it sizes
- book/04-population-sizing.qmd:15-18, 27-31: the chapter sizes "a wide cross between
  two divergent parents" from "two divergent heterotic groups", carried F1 to F4 by SSD,
  bulk or Syn. DH lines are never mentioned (grep: no "DH" or "doubled" in 04).
- book/00-hybrid-programme.qmd:153 (@tbl-hp-stages) maps S2, "choosing parents and
  crosses for DH induction", to @sec-sizing.
- book/04c-alphasimr-pipeline.qmd:661-664: "It is also why @sec-sizing is a chapter:
  the number of DH lines you pull from a cross is the number of tickets you buy."
- book/08-pipeline-stages.qmd:165, 381-386: S2 is within-pool crosses ("20 crosses out
  of 1770 possible within-pool combinations"), 40 DH lines each.
- Problem: 00 and 04c send the reader to 04 for DH-line sizing of within-pool crosses.
  04 actually sizes an SSD F4 panel ($H = 0.125$) from a cross *between* heterotic
  groups. 04 also never says how its identities carry over to DH ($H = 0$, the F-infinity
  case it mentions only in the @tbl-sizing-f4-identities caption), nor why a
  between-group cross is the right model for line development inside a pool.
- Proposed change: 04 should state the scope it covers relative to S2 (within- vs
  between-pool cross; DH as the $H = 0$ limit of @eq-sizing-div). Alternatively, 00:153
  and 04c:661-664 should stop describing 04 as DH sizing.
- Owner: 04 (primary); 00 and 04c (pointers).

### C3 [H] Germplasm injection attributed to a chapter that argues the opposite
- book/11b-diversity-across-cycles.qmd:343-346: "@sec-backcross is the machinery that
  performs [germplasm injection] -- introgression is how new material enters an elite
  pool".
- book/04b-backcross-introgression.qmd:41-45 and 868-872: MABC moves $k$ Mendelian
  targets and throws "the rest of the donor away". "A conversion programme ... reduces
  diversity by construction." @tbl-bc-conversion-cost then measures a GD ratio of
  $2D(1-D)$.
- Problem: 11b gives 04b a job, adding diversity, that 04b explicitly does not do. This
  is also one of only three substantive inbound citations to 04b (see C9).
- Proposed change: 11b should cite 04b for the cost of conversion and not for injection.
  If injection by backcross is meant (a donor-heavy, low-BC scheme), 04b should state
  that it does not model it.
- Owner: 11b.

### C4 [M] Wrong citation targets out of the part
- book/04b-backcross-introgression.qmd:929-932: "@sec-stages' per-line usage cap is the
  mechanism that already handles this". 08 has no per-line cap: grep finds no "cap",
  "max_use" or "usage" in 08. The cap is in @sec-combinatorial
  (book/10-combinatorial-selection.qmd:88, 148-170) and in 07's `max_use` (07:281-297).
  The same mechanism is correctly attributed in
  book/04c-alphasimr-pipeline.qmd:898-900 ("the `max_use` parental cap of
  @sec-combinatorial"), so the part names two different owners for one mechanism.
- book/04b-backcross-introgression.qmd:939-941: "@sec-choosing's recommendation to
  compute $\theta$ on markers rather than on pedigree". 07 contains no such
  recommendation and does not use the word "pedigree". The closest match is the IBS/IBD
  and pedigree-$\mathbf{A}$ discussion in book/05-genomic-era.qmd:500-520, 624-626.
- book/04c-alphasimr-pipeline.qmd:1989-1990: "`GD_BS`, the between-pool divergence that
  carries the heterosis signal (@sec-choosing)". 07 never discusses $GD_{BS}$ or
  heterosis. The claim belongs to @sec-heterosis (05b:235-237), and see C5 on its
  wording.
- book/04c-alphasimr-pipeline.qmd:2008-2010: "a random-subset null of the same size,
  which is the reference @sec-combinatorial's `alpha` uses". The baseline is defined in
  @sec-baseline (06:321), which index.qmd:99 and 03:436 cite for the same thing.
- Proposed change: re-target to @sec-combinatorial, @sec-genomic-era (or remove),
  @sec-heterosis and @sec-baseline.
- Owners: 04b (first two), 04c (last two).

### C5 [M] "Carries the heterosis signal" contradicts the part's own result on divergence
- book/04c-alphasimr-pipeline.qmd:1989-1990: $GD_{BS}$ "carries the heterosis signal".
- book/03-simulating-crosses.qmd:214-218: "Neutral divergence relocates diversity; it
  does not create heterosis". book/05b-heterosis-dominance.qmd:235-237, 467-470: the
  divergence half of heterosis is $GD_{BS}$ *weighted by $d$*, and under neutral
  divergence the total does not move. book/90-notation.qmd:107, 577-578: "maintain, do
  not maximise", and only divergence coinciding with dominance counts.
- Problem: 04c is the only place in the part that describes $GD_{BS}$ itself as a
  heterosis signal, without the dominance-alignment qualifier that 03, 05b and 90 all
  insist on.
- Proposed change: align with the 02 @tbl-keystone / 90 wording ("the heterosis engine,
  to be maintained") and cite @sec-heterosis-alignment.
- Owner: 04c.

### C6 [M] Transitions: 04 and 04c do not say why they follow their predecessor
- book/04-population-sizing.qmd:15-18: "The previous chapters took the candidate pool
  as given. This one asks where it comes from". The immediately previous chapter, 03,
  *built* the candidate pool (03:29-32, 412-415: "the candidate pool the rest of the
  book selects from"). There "candidate pool" means the N hybrids; 04 uses it for a
  line panel from one cross. 03 has no closing section and no pointer to 04, so the
  hand-off is missing on both sides.
- book/04c-alphasimr-pipeline.qmd:12-17 opens against @sec-simulating-crosses only
  ("Balding-Nichols ... no recombination, no dominance"). It never mentions the two
  chapters between, 04 and 04b, both of which already run a genetic map with Haldane
  meiosis (04:45-71; 04b:150-162). Its closing section
  book/04c-alphasimr-pipeline.qmd:1993-1998, "What is more realistic here. Actual
  recombination and linkage", reads as new to the book, while 11b:79-80 says
  "@sec-sizing is where linkage is modelled properly".
- Proposed change: the 04 opening should start from 03's pool of lines (the lines 03
  drew have to come from somewhere). The 04c opening should acknowledge that 04/04b
  already model meiosis on a map, and say that what 04c adds is a founder history,
  dominance and a selection loop.
- Owners: 04 (opening), 04c (opening and the Assumptions heading).

### C7 [M] Neutral-divergence sweep developed in full twice
- book/03-simulating-crosses.qmd:101-218 (@fig-divergence-het, @tbl-divergence-grid,
  @tbl-divergence-trade, 200-replicate ratios, finite-$n$ expectation): $F_{BN}$ swept
  0.02 to 0.40, heterozygous fraction flat, $GD_{BS}$ gain = $GD_T$ loss.
- book/05b-heterosis-dominance.qmd:467-540 (@tbl-het-sweep, @eq-het-bn-total and the
  term-by-term algebra): $F_{BN}$ swept 0.02 to 0.45, shared + divergence flat. At
  $d \equiv 1$ these are the same two quantities as 03's $GD_T$ and $GD_{BS}$ (05b's own
  @tbl-het-split, 05b:225-233).
- Also stated at book/01-coancestry.qmd:235-242 and book/90-notation.qmd:139-155. Both
  of those are short pointers, which is fine.
- Problem: two independent sweeps with different grids and seeds make the same point.
  05b comes first in reading order (Foundations) and owns the derivation. 03's
  additions are the finite-$n$ correction $(1 - 1/n)$ and the replicated ratios, which
  check 02's drift ratios 1 and 2.
- Proposed change: one sweep. 05b keeps the algebra and the heterosis reading. 03 keeps
  either its grid (as the measurement 01:240-242 already promises) or only the
  finite-$n$ correction plus a cross-reference. Whichever sweep stays, the other
  chapter cites it.
- Owner: 03 or 05b, an editorial call. 01:240-242 currently promises 03's grid, so
  keeping the grid in 03 means no other chapter has to change.

### C8 [M] Tester-accuracy formula derived twice, with no link between the two
- book/04c-alphasimr-pipeline.qmd:978-1141: @eq-alphasimr-accuracy, $\rho(t, r)$, with
  finite-pool and sample-variance corrections. The "textbook form"
  (`predicted_infinite`, 04c:1010-1013, 1060) is computed by hand.
- book/04e-mating-design.qmd:218, 387-405: the same textbook form
  $\rho = \sqrt{\sigma^2_g/(\sigma^2_g + \sigma^2_s/c + \sigma^2_e/(c r))}$ as
  `gca_accuracy_theory()`.
- book/90-notation.qmd:535 is the only place that says the two are the same ($t, r,
  \rho$ = "the $k$, $r$, $\rho$ of the mating-design table").
- Problem: 04c never cites @sec-mating or `gca_accuracy_theory()`, and 04e never cites
  @eq-alphasimr-accuracy. A reader of 04e does not learn that the formula was validated
  by simulation and corrected for a finite tester pool two parts earlier. A reader of
  04c does not learn that the package exports the textbook form.
- Proposed change: 04e owns the design formula and the package function. 04c keeps the
  finite-pool correction, computes `predicted_infinite` with `gca_accuracy_theory()`
  and adds a forward pointer to @sec-mating. 04e cites @eq-alphasimr-accuracy for the
  finite-pool case.
- Owners: 04c and 04e.

### C9 [M] Cross-reference graph: 04b has almost no inbound job
- Inbound citations to @sec-backcross (all ids): 7, from 7 files. Of those, 90 (local
  notation), 91 (function index), 92 (verification) and 00:573 (reading-map row) are
  bookkeeping. The substantive ones are index.qmd:106-107 (Preface item 5),
  04c:2036 (in passing: "unlike the MABC scans") and 11b:345, which mischaracterises
  the chapter (C3).
- 04b gives itself two downstream jobs that the targets never take up:
  04b:926-928, "A conversion programme must be counted against the diversity budget of
  @sec-ocs", has no matching citation in 09. 04b:929-932 assigns the per-line cap to
  @sec-stages (wrong target, C4), and neither 08 nor 10 cites 04b.
- Problem: this is the "one inbound citation" pattern that CLAUDE.md calls a maintenance
  signal. Measured near-copy cost (@tbl-bc-conversion-cost) is the chapter's one result
  that bears on the rest of the book, and no optimisation or metrics chapter uses it.
- Proposed change: 10 (where the per-line cap lives) or 09 (the budget) should cite
  @tbl-bc-conversion-cost when it discusses near-duplicate parents. Otherwise 04b's
  closing claims should be cut back to what the book actually uses.
- Owners: 10 or 09 (citation); 04b (claims).

### C10 [L] Map and meiosis assumptions written out twice
- Haldane map function: book/04-population-sizing.qmd:67-71 (P4, inline, no label) and
  book/04b-backcross-introgression.qmd:156-162 (@eq-bc-haldane).
- Crossover interference after @falque2009: 04:73-80 (non-interfering fraction 15%, 6 to
  23%; effect described as a longer block-length tail) and 04b:778-796 (gamma shape 4.2
  to 6.2; effect described as an over-supply of tight double recombinants).
- IBM map expansion after @lee2002: 04:47-59 in full, 04b:810-811 by reference
  ("exactly as in @sec-sizing").
- Problem: the part says it shares one map and one meiosis model (04b:859-862), yet the
  equation is labelled only in the second chapter, and the interference limitation is
  described twice with different statistics. They are not contradictory, but a reader
  has to reconcile them.
- Proposed change: label the Haldane equation in 04 (P4) and have 04b cite it, as it
  already does for IBM. Each chapter keeps its own consequence of interference but
  cites one shared statement of the evidence.
- Owner: 04 (label); 04b (cite).

### C11 [L] Notation: $n$ for lines per pool in 03
- book/03-simulating-crosses.qmd:206-213: "$n$ lines per pool", "$(1 - 1/n)$", "With
  $n$ = 25".
- book/03-simulating-crosses.qmd:275: the same chapter writes $(n_A - 1) + (n_B - 1)$.
- book/90-notation.qmd:17-21: $n$ is hybrids selected. 90:537, 451 and 04c:993-994 use
  $n_A$, $n_B$ for pool sizes.
- Proposed change: $n_A$ (equal pools) in 03:206-213.
- Owner: 03.

### C12 [L] Notation: $n$ in 04b's z statistic; $H$ across 04 and 04c
- book/04b-backcross-introgression.qmd:526-530: $n$ = replicates per schedule.
  book/90-notation.qmd:378 defines 04b's $n$ as "plants genotyped in one generation or
  step", which is also its use at 04b:221.
- book/04-population-sizing.qmd:111, 127-130, 141-158: $H$ = panel heterozygosity
  (0.125). book/04c-alphasimr-pipeline.qmd:585, 617 and book/90-notation.qmd:199, 516
  use $H_i$, $H_{ij}$, $\bar H$ for heterosis. 90's list of 04-local clashes
  (90:355-360) names $N$, $n$, $L$, $k$, $\beta$, $p$ but not $H$, although the two
  meanings sit two chapters apart within one part.
- Proposed change: a different symbol for the replicate count in 04b, and add $H$ to the
  90:355-360 clash list.
- Owners: 04b, 90.

### C13 [L] Per-hybrid identity written with the factorial mean
- book/03-simulating-crosses.qmd:201-202: "The heterozygous fraction of an A x B hybrid
  of inbred parents is exactly `1 - theta_AB`". For one hybrid it is
  $1 - f^L_{ab}$ (03:301, code comment, and 90:82, $F_{(ab)} = f^L_{ab}$). $\theta_{AB}$
  (90:212) is the factorial mean, which gives the *mean* heterozygous fraction. The
  symbol is also set in code font, where the rest of the book sets it in math.
- Owner: 03.

### C14 [L] Linked arm: who supplies it to whom
- book/04c-alphasimr-pipeline.qmd:186-188: "@sec-limits' linked arm is built this way"
  (found once, then branch).
- book/04c-alphasimr-pipeline.qmd:2072-2073: "@sec-limits uses this chapter's linked arm".
- book/11c-limits.qmd:171-174, 232-234: "@sec-alphasimr supplies the linked arm". The
  arm is actually run in `book/scripts/regenerate.R` (11c:206-208) with 04c's bridge
  functions, not by any chunk of 04c.
- Problem: the two 04c sentences disagree about whether 04c contains the arm.
- Proposed change: say that 11c's linked arm uses 04c's founder and RRS machinery.
- Owner: 04c (both sentences); 11c:232-234 follows.

### C15 [L] Falconer reconciliation repeated almost word for word
- book/04c-alphasimr-pipeline.qmd:649-657 and book/05b-heterosis-dominance.qmd:239-246
  both state $H_{F1} = \sum_k d_k y_k^2$ [@falconer1996, ch. 14], "twice the divergence
  term", "they use different mid-parents". 04c already defers ("@sec-heterosis works
  the reconciliation through").
- Proposed change: 04c keeps the one-line pointer and drops the restatement. Its
  verification role (Steps 3, 4 and 6 against AlphaSimR) is not redundant and should
  stay.
- Owner: 04c.

## Checked and consistent (no finding)
- Balding-Nichols parameter: 03 writes $F_{BN}$ throughout (03:62-76, 106, 134, 142,
  173). 90:142-145 rightly no longer lists 03 among the chapters that write the parameter
  as $F_{ST}$. 04c uses $F_{ST}$ only as the statistic (04c:1324-1326).
- 03's drift ratios 1 and 2 (03:190-191) match 02:352-357.
- 03 keeps the promises of 02b:465-469 (build `simulate_pools()` step by step; identity
  of lines and X asserted at 03:89-92) and of 01:240-242 (heterozygous fraction flat
  over `fst`).
- 04b:874 "item 5 of the Preface's chain of argument" matches index.qmd:105-108.
- 04 $GD = D/2$ bridge (04:811-840) is consistent with $GD = 1 - \theta$ (90:70) and
  with 06 @sec-ns, which 04:850 cites correctly.
- 04c local symbols ($x_{ik}$ as 0/1/2, $G_i$, $\mu_0$, $\delta_k$, $\alpha_k$, $t$,
  $v_g$/$v_s$/$v_e$, $n_A$/$n_B$) are all documented in 90:519-541. The clashes with the
  global table are declared in both places.
- Closing transition 04c:2075-2077 to @sec-genomic-era is answered by 05:10-12.
- Equation and section targets: every `@eq-` used in the four chapters resolves, and the
  whole book has no broken `@sec-` target.
- Within the part, forward dependencies are marked. 04c's heavy use of @sec-programme
  is flagged as "later in the Evidence and practice part" (04c:40). 03's @sec-collapse,
  @sec-baseline and @sec-genomic-era are explicit forward pointers.

## Inbound `@sec-` citations

Counted from other files only (self-citations excluded). "main" = citations of the
chapter's own id; "all ids" adds its subsection anchors; "files" = distinct citing
files. Simulation-part chapters are in bold.

| chapter | id | main | all ids | files |
|---|---|---|---|---|
| 00 | sec-hybrid-programme | 3 | 9 | 7 |
| 01 | sec-coancestry | 19 | 25 | 14 |
| 02 | sec-subdivided | 38 | 38 | 14 |
| 02b | sec-response | 28 | 28 | 14 |
| 05b | sec-heterosis | 78 | 105 | 21 |
| **03** | **sec-simulating-crosses** | **25** | **25** | **15** |
| **04** | **sec-sizing** | **18** | **18** | **10** |
| **04b** | **sec-backcross** | **6** | **7** | **7** (3 substantive; see C9) |
| **04c** | **sec-alphasimr** | **20** | **20** | **11** |
| 05 | sec-genomic-era | 21 | 35 | 16 |
| 06 | sec-catalogue | 23 | 40 | 18 |
| 07 | sec-choosing | 33 | 45 | 20 |
| 08 | sec-stages | 37 | 37 | 18 |
| 08b | sec-genomic-prediction | 19 | 24 | 14 |
| 09 | sec-ocs | 33 | 37 | 16 |
| 10 | sec-combinatorial | 30 | 30 | 13 |
| 10b | sec-advanced | 19 | 24 | 8 |
| 04e | sec-mating | 57 | 84 | 8 |
| 04f | sec-sparse | 36 | 51 | 6 |
| 04g | sec-joint | 11 | 15 | 4 |
| 11 | sec-plant-literature | 15 | 15 | 8 |
| 04d | sec-programme | 17 | 17 | 6 (12 of them from 04c) |
| 11b | sec-cycles | 48 | 48 | 20 |
| 11c | sec-limits | 17 | 17 | 9 |
| 12 | sec-case-study | 21 | 21 | 15 |
| 90 | sec-notation | 17 | 17 | 6 |
| 91 | sec-package | 0 | 0 | 0 (out of scope; zero inbound) |
| 92 | sec-verification | 5 | 5 | 5 |
| 93 | sec-corpora | 2 | 2 | 2 |

No chapter in the part has zero or one inbound citation by raw count. 04b is the
functional exception (C9): after removing appendix, index and reading-map rows, it has
three citations, and one of them (11b:345) assigns it the wrong job.
Broken `@sec-` targets: none.
