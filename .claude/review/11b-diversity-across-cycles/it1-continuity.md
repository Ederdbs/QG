# 11b-diversity-across-cycles -- continuity, iteration 1 (chapter mode, read-only)

Chapter: `book/11b-diversity-across-cycles.qmd` (423 lines), `@sec-cycles`. Worktree `SB_quanti_gen-review-04-06`.
Read: CLAUDE.md, `_quarto.yml`, `90-notation.qmd`, THREAD.md (00-09, 10 provisional, 10b final; grep of every `11b` line, then the quoted entries), verdict files of 04d, 11, 04f, 04e, 04g, and the chapters named below at the cited lines. `it1-audit.md` and `it1-refs.md` read for context only; I judge continuity. Recomputed from `book/data/cycles_trajectory.csv` and by running the 11b:117-135 chunk (scratch under the session scratchpad: `xref.R`, `th.R`).
Part order (`_quarto.yml`): Evidence and practice = 11, 04d, **11b**, 11c, 12. 11b comes after the whole Mating and testing design part (04e, 04f, 04g) and after 04d.
Severity: H = contradiction in notation, definition, number or assumption, or broken promise. Owner = the chapter that must change: `11b` (this chapter), `earlier: <ch>` (fix now in a closed chapter), `later: <ch>` (Owed, to keep true or to correct once 11b is fixed).

## Summary

| ID | Sev | Owner | One line |
|---|---|---|---|
| 11b-C1 | H | 11b; earlier: 04c | alpha is a per-cycle loss against the CURRENT pool's random subset; 11b never says so, and 04c:2171 says "against the frozen founding base" |
| 11b-C2 | H | 11b | N_s (in [1/2, 1] by 06 definition) set beside N_e of 14-19 as "the size of the discrepancy" |
| 11b-C3 | H | 11b; later: 11c | a rate-based N_e is printed for managed runs and called "realised effective size", against 07/11/12; level of F_drift (00) not stated; a neutral arm already in 11b is unused |
| 11b-C4 | H | 11b; later: 11c | "fitted dF is the lowest of the three": it is the middle value; 11c:79-80 repeats the error; R^2 thresholds of 05 and 11c differ and 11b states none |
| 11b-C5 | H | 11b; earlier: 06 (one line) | `GD` is `GD_T`, called "within"; within-pool columns never read; 06:499-505 says so; GD_BS "rises in every run" is computed nowhere in 11b but relied on by 00, 02, 11 |
| 11b-C6 | H | 11b | GD_BS pointer to heterosis, "as they should" / "this chapter is that process running", under an additive index (05b, 00, 08b) |
| 11b-C7 | H | 11b | closing paragraph: "the four things" misquotes 12's checklist and claims a per-stage ledger consequence that C8 excludes |
| 11b-C8 | M | 11b; later: 12 | C7 "optimistic ceiling": 03 no longer supports it, 07 Finding 5 qualifiers, no @sec-genomic-prediction link (THREAD owed) |
| 11b-C9 | M | 11b; later: 11c | C1 ("no Bulmer effect") is corrected in 11c; 11b carries no pointer; 04b also models linkage |
| 11b-C10 | M | 11b | injection: 04b adds loci to one elite line, 11b replaces whole founder lines |
| 11b-C11 | M | 11b | undeclared: complete 25 x 25 factorial and no crossing design (04e cited zero times, 04e/04f/04g point here), additive index |
| 11b-C12 | M | 11b | discrete, non-overlapping cycles (05 A4) vs overlapping cycles of 04d; per-cycle rate vs 11 row 7 / 12 checklist |
| 11b-C13 | M | 11b | dF = -slope against 05's 1 - exp(slope); cycle 0 dropped unsaid; no cycle-by-cycle audit (05 says none exists) |
| 11b-C14 | M | 11b | "re-anchoring" defined on the candidate pool in 11b, on the selected set in 05; "approximately zero" / "exactly zero" / "one assignment" vs 05 |
| 11b-C15 | M | 11b | DE check: evaluation budget unstated, 10/10b qualifiers not cited (owed 11b:201) |
| 11b-C16 | M | 11b | cap: 05:1809 promises "paid back or not"; 11b answers for other caps and a different problem, and does not say "not repaid in index" |
| 11b-C17 | M | 11b; later: 11c, 12 | "eight cycles" is the alpha 0.02 budget only; "tighter budget always ends higher" is false on 11b's own data; 11c and 12 inherit the wording |
| 11b-C18 | M | 11b | opening: no statement of why it follows 04d; "the last item" of 12's list is the fifth of six |
| 11b-C19 | M | 11b | "something narrower" vs the eleven-row table of 11; "nobody has published" vs "not in the retrieved set"; 11 is conditional on 11b |
| 11b-C20 | M | 11b | no back-citation of @sec-response (02b-C14); "taken on faith" against 02b/05b/index item 3; DH-blend attributed to @sec-heterosis |
| 11b-C21 | M | 11b | notation: alpha for the budget (90: alpha_max), `\text{}` form of F_drift, alpha 0.0200 vs realised 0.0198 |
| 11b-C22 | L | 11b | "a substantial block" of the corpus: no count, and 93's seven themes contain none on recurrent selection or long-term gain |

## Findings

**11b-C1 (H) -- alpha is re-referenced every cycle; 11b never says it; 04c says the opposite.**
11b:30-106 (C1-C8) and 11b:152 declare p0 frozen (C5, 11b:95) and say nothing of the reference of alpha. `R/14_cycles.R:125-131` takes `gd_ref` from `null_distribution()` on the current cycle's candidate set each cycle, and `selector(ctx, n_sel, alpha_max, gd_ref, max_use)`. Recomputed from `cycles_trajectory.csv` (mean of 5 seeds): `gd_ref` 0.3288 (cycle 0) -> 0.2101 (cycle 15) under alpha <= 0.02; GD of the selection 0.3237 -> 0.2065, i.e. -36% in absolute terms, with realised alpha 0.0157 and 0.0170. The unconstrained arm: realised alpha 0.039 at cycle 0, 0.0029 at cycle 15 (its GD 0.1813 against `gd_ref` 0.1819). So the "budget" is a per-cycle relative loss against a random subset of the eroding pool, and a budget of 0.005 stops binding on a truncation plan by cycle 15. Two bases are in use in one loop (frozen `p0` for F_hom/F_drift, moving `gd_ref` for alpha) and the chapter states one.
- Earlier chapters: index.qmd item 4 and 12:213-218 define alpha as the loss against a same-size random subset (consistent with the code, not with a founding base). 12:215 "attainable alpha ceiling computed before choosing alpha_max": at cycle 15 the ceiling of the unconstrained arm is 0.003, which 11b does not mention.
- `04c-alphasimr-pipeline.qmd:2171-2172` (THREAD 04c entry, line 372) describes @sec-cycles as "a budget `alpha` against the frozen founding base". That is inaccurate: only F_hom/F_drift use the frozen base. Owner **earlier: 04c** (one clause) and **11b** (declare, as an assumption beside C5, and read the horizon table in that light).
- Owner 11b also for the injection section: realised alpha at cycle 8 is slack because the reference moved up with the pool (it1-audit R6); the section does not say the constraint stopped binding.

**11b-C2 (H) -- N_s compared with N_e as if both were head counts.**
11b:256-267: "N_s computed on the selected hybrids averages 0.67 ... while the realised effective size ... is between 14 and 19 ... Here is the size of the discrepancy ... not off by a constant". `06-metric-catalogue.qmd:176-199` (@sec-ns): on molecular `f`, theta_S is in [1/2, 1] and N_s is in [1/2, 1] for every set, "not a number of individuals"; five individuals give N_s = 1. `90-notation.qmd:84-92` defines N_s = 1/(2 theta) and N_e = 1/(2 dF). In `cycles_trajectory.csv` N_s ranges 0.607 to 0.747 (mean 0.6706). The comparison is of different units, and "the size of the discrepancy" has no meaning. 11b is right that N_s is a static descriptor (06:215-224) and wrong to measure its distance from a rate-based N_e. Owner **11b**.

**11b-C3 (H) -- N_e reported for managed runs, "realised effective size"; level and neutral arm.**
11b:238-244 prints `Ne` for three managed runs and 11b:262 calls it "the realised effective size implied by the drift they actually accumulated".
- Against `12-case-study.qmd:241` ("N_s is reported; a rate-based N_e is **not**, under active management"), `07-choosing-metrics.qmd:982-1006` (THREAD 07), and `11-plant-literature.qmd:596-608`, which reconciles the rule with 11b only by saying that 11b measures Delta F from the trajectory "with a diagnostic for a saturating series" -- not an effective size.
- THREAD 00 (00-C5, entry lines 72-75): `F_drift` here is on merged hybrid frequencies, "a different level from @eq-hp-drift" (`00:696-704`), so a rate or N_e read off it is not on the scale of 00's N_e = n/2. The chapter's own neutral arm shows it: running 11b:117-135 (equal usage, five generations, no selection, seed 1/7) gives F_drift = 0.0869, i.e. 0.0180 per generation and N_e = 27.7 on this estimator, against the managed 0.0265-0.0358 (N_e 14-19). That chunk is a neutral reference arm (00-C5, 02-C9) that 11b does not use. It is also the chunk the 11b text calls a demonstration of re-anchoring (C14).
- Owner **11b** (report Delta F and its R^2, state the level, drop or qualify "effective size", use the neutral value if wanted). **Later: 11c** `11c:33-46`, `11c:79-82` builds Robertson's limit 2 N_e R_1 on this N_e (same level issue and -slope convention, THREAD 00 lines 75, 408); Owed: 11c must be re-judged after 11b changes.

**11b-C4 (H) -- "its fitted dF is the *lowest* of the three".**
11b:250-253. Recomputed (`-slope`): unconstrained 0.02921, alpha 0.02 0.03575, alpha 0.005 0.02647; R^2 0.853, 0.993, 0.998; F_drift at cycle 15 0.457, 0.431, 0.343. The unconstrained value is the middle one, and "exactly backwards" is false as written (THREAD 00, line 72 owed this to 11b). The order of dF (0.02 highest) and of the F_drift reached (unconstrained highest) differ, which is the actual point and what a saturating series does.
- 05:1473-1482 sets a threshold "R^2 < 0.995 on an averaged series ... at this scale only" and says of @sec-cycles "there the diagnostic fires on the unconstrained run". By 05's own number the alpha 0.02 series (0.9931) fires too. 11b states no threshold and does not cite 05's; 11c:86-88 uses "about 0.99". Three readings of one diagnostic across 05, 11b, 11c. Owner **11b** (cite 05's threshold or say why not) and **later: 11c** (`11c:79-80` "its fitted dF comes out lowest for the run that is actually losing diversity fastest" inherits the false order; also, which run loses diversity "fastest" depends on the lens: dF or F_drift at 15). 05:1482 may stay if 11b keeps "most strongly"; no change owed to 05.

**11b-C5 (H) -- `GD` is `GD_T`, but the chapter says "within"; GD_BS is asserted, not computed.**
11b:409-411 "The GD_BS column ... rises in every run -- the pools do separate ... while GD within them falls, which is the trade @sec-catalogue's partition was built to expose." The CSV `GD` equals `GD_T` to 1e-15 (column check, it1-audit R8); the left panel of `cycles_diversity.png` is titled "Within" (`regenerate.R:518`, seen in the image; y label "gene diversity of the selection"). `90-notation.qmd:116-129` defines GD_T = GD_WI + GD_BI + GD_BS and GD_WS separately; index.qmd item 4 (index:108-110) says the budget "does not isolate the within-pool loss ... which is why the pools are monitored separately". The within-pool quantity (GD_WS = GD_T - GD_BS) is computable from columns 11b already loads and is never shown.
- `06-metric-catalogue.qmd:499-505` states that @sec-cycles "aggregates and plots only a subset (index, `GD`, `GD_BS`, `F_hom`, `F_drift`, `max_line`) and never reads the within-pool columns, so this book states that within-pool diversity is the fuel and does not demonstrate it". 11b:411 reads "GD" as within-pool, contradicting 06. Also 06's list is not what 11b does: the two figures plot `index` (gain), `GD` and `F_drift`; `avg()` (11b:11-14) aggregates six columns but `GD_BS`, `F_hom`, `max_line` appear in no table or figure (`max_line` appears only in the cap table via a second `aggregate`). The 06:502 parenthesis needs "aggregates six and plots three", or 11b makes it true. THREAD 06 (line 445) closed this as "06 states it does not demonstrate"; that remains the position unless 11b changes.
- "Rises in every run" (11b:409) is relied on by `00:342` ("rises in every run of @sec-cycles"), `11:292` ("the rise of GD_BS under run_cycles() is a simulation result (@sec-cycles)") and `02:1039` ("within-pool diversity also falls in the simulated cycles of @sec-cycles"). No chunk of 11b computes it. From the CSV, GD_BS(15) > GD_BS(0) in 15 of 15 runs, monotone in 14 of 15 (it1-audit R8, not re-run by me). Owner **11b** (compute GD_BS and GD_WS as a column or table and state the sense of "every run"); **earlier: 06** one clause only if 11b does not plot more.

**11b-C6 (H) -- the GD_BS / heterosis pointer is derived under dominance and reused in an additive simulation.**
11b:404-411: "@sec-heterosis argued that what builds a heterotic pattern is divergence aligned with dominance ... This chapter is that process running ... the pools do separate under reciprocal selection, as they should". `run_cycles()` has no dominance (`R/14_cycles.R:54`, index = X beta; 02b:96-99 `d_k = 0`; 08b:136, 08b:763-768; THREAD 05b line 241). 05b states the opposite of 11b's reading: `05b:512-518` ("@sec-cycles runs selection under the budget on an additive index") and `05b:2181-2187` ("so does not test the inference"). `00:338-342` and `11:288-292` say divergence rising under drift alone in closed pools is derived (@sec-hp-cycle) and the rise under selection is a simulation result with drift and selection acting together; 11b has no neutral-selection arm to separate them (02-C9; but the 11b:117-135 chunk is such an arm for F_drift, not for GD_BS). `02:1039` keystone row: the GD_BS = heterosis divergence term identity holds only for inbred parents, flat dominance and the complete A x B factorial; 11b's GD_BS is that of 60 hybrids of unequal line usage (see C11). Sentence to restrict (THREAD 05b owed): GD_BS rises in a simulation with an additive index, drift and selection together; "as they should" and "that process running" go. Owner **11b**.

**11b-C7 (H) -- the closing checklist reading is wrong against 12 and against C8.**
11b:413-416: "read its final checklist -- freeze p0, keep the per-stage ledger, check log(1 - F) for curvature, plan germplasm injection -- as the four things this chapter has now shown the consequences of skipping."
- `12-case-study.qmd:244-252`: the "Across cycles" list is (1) per-stage loss ledger, (2) log(1 - F) linearity, (3) periodic injection, (4) "the diversity cost per cycle is reported when cycle time is shortened". "Freeze p0" is the first bullet of "Setting up" (12:205), not of the final list. 11b substitutes p0 for item 4 and omits item 4, which 11b does not touch (see C12).
- 11b C8 (11b:105-106) says "no stage structure"; the per-stage ledger is 04d's (and 08's). 11b cannot have shown the consequences of skipping it. The sentence claims a result the chapter has no instrument for.
- 11b:413 "Read [12] as cycle 0 of this chapter": 12 runs `stage1_simulate()` + `stage2_select()` with `n_sel = round(0.10 * N)` (12:17-26; R rounds 62.5 to 62) on markers that all carry effects; 11b runs `simulate_pools()` with 300 QTL and `n_sel = 60` (05:125 says `run_cycles()` does not use `simulate_data()`). Different simulator, `n_sel` and index; "cycle 0 of this chapter" is a pointer, not an identity.
- 12:191-199 and 12:271-273 tell the reader 11b shows "five generations of real drift reported as exactly none" and "concentration is what erodes the programme's future": see C14 (exactly none vs approximately zero) and C20 (mechanism not shown). Owner **11b** (reword the closing paragraph to what 11b shows: p0, curvature, injection); **12** needs no change if 11b does.

**11b-C8 (M) -- C7 "optimistic ceiling".** (THREAD 03 line 293, 07 line 480, 08b line 547; 12:170 is the same wording.)
11b:100-104 cites only @sec-choosing Finding 5 and calls every gain "an optimistic ceiling, for all budgets equally". 03's callout (03:452-477) no longer supports a ceiling reading (a feasible selection is not a bound; a gain in `ctx$index` does not bound the gain of a selection on estimates); 07:885, 911-913 establishes Finding 5 only at the teaching scale, nominal accuracy, correlated against independent error, the realised-gain difference declared not a result; "for all budgets equally" is untested. `08b:1272-1276` already states 11b's side correctly ("a fixed, perfect index"), and `08b:1182-1235` is where a fitted accuracy per CV scheme is measured; 11b, 11c and 12 cite @sec-genomic-prediction nowhere. Owner **11b**; **later: 12** (12:164-172, "optimistic ceiling", same fix).

**11b-C9 (M) -- C1 says "no Bulmer effect"; 11c corrects it; 11b gives no pointer.**
11b:77-81. `11c-limits.qmd:111-120` quotes C1 and tests it ("too strong", 11c:151-165, Bulmer covers unlinked loci); `R/14_cycles.R` logs `var_g` and `var_genic` "to test rather than to assume", and its roxygen points to "the note on assumption C1 in the book", which is in 11c. 11b:78-79 "@sec-sizing is where linkage is modelled properly": 04b also models linkage (Haldane, no interference; THREAD 04b line 346), and @sec-alphasimr is the real-meiosis arm (04c:2343-2347, Step 8). 11b:79 "the same abstraction @sec-simulating-crosses already makes" is true (03:141-176; THREAD line 293). Owner **11b** (one forward pointer to @sec-limits, name 04b/04c); **later: 11c** (keep the C1 quotation of 11c:111-113 identical to whatever 11b ends with). Escalates to H if the text "no Bulmer effect" stays unqualified.

**11b-C10 (M) -- injection overreads 04b.** (THREAD 04b line 346.)
11b:342-346 "@sec-backcross is the machinery that performs [injection] ... introgression is how new material enters an elite pool without dragging the rest of the genome". 04b models the transfer of k <= 4 loci into one elite line; its product is a near-copy of the recurrent parent (04b:1084-1090, "a breeding decision outside this chapter"). 11b's experiment (`R/14_cycles.R`, injection branch; regenerate.R) replaces six of 25 lines of the new pool with founder lines of the same programme (11b:348-349, 372-374): no conversion, no drag, no genebank. `11:426-436` (Sanchez 2023: bridging populations) is the literature side and says "not an operating programme"; 11b does not say which of the two it simulates. Owner **11b**.

**11b-C11 (M) -- assumptions missing from C1-C8: complete factorial, no crossing design, additive index.**
- Every A x B cross is a candidate (`cycle_ctx`, `expand.grid`, 25 x 25 = 625; `R/14_cycles.R:52`) and 60 are selected and used; there is no crossing design, tester set or sparse factorial. 11b cites @sec-mating (04e) zero times (graph below: 11b cites no chapter of the Mating and testing design part). Four later-or-earlier chapters state the gap and point here: `04e:1499-1500`, `04e:1642-1645` ("how a design chosen once behaves while the pools drift is not tested there, and not in this book"), `04g:1501-1502`, `04f:1832-1834`. They stay true; 11b should say so itself, and index.qmd:~118 ("the crossing plan decides which candidates are seen at all") makes 11b's all-625 assumption a departure from the book's own pipeline. Owner **11b** (add the assumption; one pointer to @sec-mating).
- The index is additive (`gv = X %*% beta`, 05 A7, 02b:96-99, 08b:136): not a C-item of 11b (C4 says only "marker effects fixed"). This is what C6 turns on.
- The complete-factorial identity for GD_BS requires equal pool weights; 11b's selection has unequal usage (11b C2 draws parents proportional to usage). State that GD_BS here is the partition of the selection (02:1039, 06:497-499), not the heterosis-engine identity. Owner **11b**.

**11b-C12 (M) -- discrete cycles (05 A4) against overlapping programme (04d); per-cycle rate.**
`05:102-107` (A4): cycles discrete, no overlap, "a cycle index a poor clock for any Delta F read off it ... no later chapter treats it; a limit of every rate reported here". 11b C3 (11b:88-89) mentions constant pool size only; 11b reports `dF_per_cycle` (11b:241) without A4. `04d:7-14`: 04d reports a stock, "not a rate per cycle, because the cycles of the programme overlap"; `11:660-688` row 7 "a stock, not a per-cycle or per-year rate", conditional on 04d and 11b (11:670-672: "had no final review record"); `12:252` "The diversity cost per cycle is reported when cycle time is shortened". 11b gives a per-cycle rate in a discrete-cycle model with no cycle length, so it supplies nothing for 11 row 7 / 12:252 and should say it does not. 11:679's "per-unit-of-cycle-time" reading is therefore not owed by 11b; keep it that way (no 11b sentence may be read as a per-year rate). Owner **11b** (declare discrete cycles beside C3, and that dF is per generation of the model).

**11b-C13 (M) -- Delta F convention; cycle 0; audit.** (THREAD lines 74, 408, 409.)
11b:238-243: `dF_per_cycle = -slope`, `Ne = 1/(-2 slope)`. `05:1462-1466`: Delta F = 1 - e^slope, "-slope errs by about Delta F/2"; "@sec-cycles fits the same regression"; the fit is on cycles 1..t, so 11b's `d[-1, ]` matches 05, unsaid. Recomputed with 1 - exp(slope): 0.0288, 0.0351, 0.0261 (N_e 17.4, 14.2, 19.1) against 0.0292, 0.0358, 0.0265. A 1.5% difference, and 05 says so; the book has two conventions for one quantity. 05:1637-1639 ("no cycle-by-cycle version of this audit is run anywhere in this book") and 05:105-107 remain true; 11b adds neither. Owner **11b** (use 1 - exp(slope) or cite 05's approximation; say why cycle 0 is dropped); **later: 11c:41** same.

**11b-C14 (M) -- "re-anchoring" is defined differently in 05 and 11b; wording.**
`05:178-188` and `05:900-960`: the failure is rebuilding the context from the *selected* hybrids, "identically zero, both lenses", "the commonest error in plant applications"; fix = `ctx$p0 <- p0` AND `ctx$maf_pop <- pmin(p0, 1 - p0)` (05:957-960), "`run_cycles()` does exactly this in its internal `cycle_ctx()`" (`R/14_cycles.R:64-65`: two assignments).
11b:110-113 re-anchors on `colMeans(X)` of the candidate pool ("approximately zero loss forever"), 11b:137 "zero by construction", 12:198 "exactly none"; the 11b:117-135 chunk tests `drift(X5, colMeans(X5))`, the pool against itself, an identity, with a reimplemented `drift()` (CLAUDE.md: `freq_metrics()` is the single sweep). 11b:143 says 05 "named it as the single most frequent error in applying F_hom and F_drift" (05 says "commonest error in plant applications"; 12:197 repeats the 11b phrase); 11b:145-146 "It is one assignment" (05: two). For the selected set the value is exactly 0 (05); for the pool it is 0 by identity; per cycle in `run_cycles()` it is small but not zero. State which. Owner **11b**.

**11b-C15 (M) -- DE check (owed 11b:201; THREAD 632).**
11b:198-230 "@sec-combinatorial's differential evolution finds slightly better plans per cycle". The DE is `sel_de(NP = 300, itermax = 1000)` (`regenerate.R:489-491`, about 3e5 evaluations), unstated in 11b. `10-combinatorial-selection.qmd:1240-1259, 1450-1460, 1553-1591` and `10b:105-116`: at the 1% budget the mean DE index is below the best fine greedy plan at 30,000 evaluations and above it at 120,000, "a property of the evaluation budget"; 10b says its "DE below greedy" is the 30,000 reading. 11b states no budget, cites @sec-combinatorial, not @sec-combinatorial-budget or @sec-advanced, and reads one seed from a trajectory difference (it1-audit R4 measured DE below the fine greedy sweep in 8 of 13 same-context cycles at alpha 0.02, margin difference inside the run-to-run noise of the DE stream). `11:306` and `12:222` ("the encoding, not the algorithm, decides") are the other lines of that owed item and are not 11b's. Owner **11b** (state NP, itermax, evaluations; cite 10's budget table; say one seed). **11/12** unchanged by 11b.

**11b-C16 (M) -- the per-line cap, 05's promise.**
`05:1800-1809`: with `max_use = 4` and no budget, "that index difference is the price, and @sec-cycles is where it is paid back or not". 11b:306-338 tests `max_use` = 6 and 3 (plus none) under alpha <= 0.02, not the 05 cap of 4 and not without a budget; it finds the cap costs 5% of cycle-15 gain (it1-audit R14: -0.61, s.e. 0.28, 4 of 5 seeds) and holds F_drift lower. That answers "not paid back in index, bought F_drift" but 11b never says "not repaid", and "max_use = 3 ... is not compensated" (11b:327) implies that 6 is. 11b:308-309 "because within a single cycle a usage cap only costs index" is stated for `@sec-combinatorial`; 09/10 say what they measure. Owner **11b**; 05 stays true.

**11b-C17 (M) -- crossover statements and what later chapters take from them.**
- "Eight cycles" (11b:174, fig caption 11b:158, 11b:171 "between cycle 5 and cycle 12") is the alpha 0.02 crossover against the unconstrained arm (mean crosses at 8); the alpha 0.005 arm crosses the mean at cycle 11. `11c:11-12` ("a constrained programme trails ... for about eight cycles") and `12:191-193` ("ahead for eight cycles and behind for the rest") drop the budget; true for 0.02 only. **Later: 11c, 12** (Owed: keep true or qualify).
- 11b:282 "The tighter budget always crosses later and always ends higher": crosses later 5 of 5 seeds; "ends higher" than alpha <= 0.02 is false at cycle 15 in 5 of 5 seeds (mean 11.14 against 11.88; it1-audit R1, cycle-15 values re-checkable from the CSV). 11c:90-100 and `11c:11` build on "where the trajectories cross". Owner **11b**; later 11c only if its wording follows.
- 02b:36-45 promise ("@sec-cycles will report a constrained programme overtaking an unconstrained one after several cycles, at a crossover cycle that varies with the simulation seed ... the book can report that because it simulated it") is kept (11b's crossover table by seed). Keep true.
- Also 11b:301-304 ("the crossover arrives sooner the harder the selection is") is a prediction with one `n_sel = 60` run; not a result.

**11b-C18 (M) -- opening and part order.**
- 11b:18-20: "@sec-case-study will end with a list of things its numbers cannot tell you, and the last item on it is the one that matters most: one cycle, not a trajectory." `12:161-199`: the list is GEBVs, additive, symmetric pools, N_s, **one cycle not a trajectory (fifth)**, p_0 frozen (sixth). "The last item" is wrong and "the one that matters most" is 11b's own ranking, not 12's. The opening also quotes forward to a chapter two places later in the part (11c, 12); declared ("will end"), so no part-structure finding, but 11b is the chapter that 12:191-199 and 12:271-273 point to as the answer, so the sentence should match 12 exactly. Owner **11b**.
- 11b:22-24 cites @sec-alphasimr Step 8 and @sec-programme as the earlier trajectories; it does not say why it comes after 04d (inbred-line, overlapping, stock not rate, no alpha budget, `04d:1015-1024` calling the alpha budget on parents "a proposal" and sending the reader to 11b and 11c) nor that 04d's closing paragraph (`04d:1089-1093`: "@sec-cycles shows the same tension -- faster response, faster erosion -- ... over a longer horizon, for the hybrid programme") hands over to it. Nothing contradicts; 11b should say in one sentence what it adds to 04d. Owner **11b**.
- Nothing in 11b depends on a later chapter without saying so apart from the forward references to 12 (declared) and the absent pointer to 11c (C9). No dependence on 04e/04f/04g or 04d numbers.

**11b-C19 (M) -- the literature statement and 11's table.**
11b:398-402: "What @sec-plant-literature listed as unestablished was something narrower and remains so: nobody has published the crossover for a theta-constrained hybrid maize programme measured against a same-size resampling baseline." `11:660-690`: eleven rows of "items not in the retrieved set"; row 3 reads "Proportional diversity loss against a same-size resampling baseline in an operating maize programme -- None from a programme. @sec-cycles simulates the multi-cycle consequence and finds a gain crossover"; the claim in 11 is "unestablished in the retrieved set", not "nobody has published" (it1-refs B8), and 11:670-672 makes rows 3 and 7 conditional on the unreviewed 11b/04d. 11b's sentence is not row 3 (a crossover is not a proportional loss), speaks as if there were one item, and loses the corpus scope. Owner **11b** (quote or cite row 3 and its limit); **11** needs no change if 11b does (the "gain crossover" answer holds for alpha <= 0.02 against the unconstrained arm; see C17).

**11b-C20 (M) -- @sec-response not cited; mechanism; DH-blend attribution.** (THREAD 02b line 196: "decided at 11b's review".)
- 11b cites neither 02b nor `@sec-response`/`@sec-response-genic`. 11b:26-28 "that argument has so far been taken on faith" disagrees with `02b:30-33` (the conditional link GD_WS -> genic variance is stated and carried by @sec-response-genic), `05b:512-518` (only through GD_WS, not what alpha budgets, and only if effects are unrelated to which loci lose diversity; not tested) and index.qmd item 3. 11b's mechanism ("out of material", 11b:191-196) is read on F_drift and GD_T; the genic variance that 02b says carries the argument is logged (`var_genic`) and not read. 02b:36-45 says this chapter's crossover is "not predicted by the preceding chapters". Owner **11b** (cite @sec-response, say that the mechanism is not shown, or read `var_genic`).
- 11b:32-37: the DH-from-hybrid blend and "merge its heterotic groups within a few cycles" is attributed to @sec-heterosis. The blend statement is `05:96-98` (A3) and 00's @sec-hp-cycle; 05b has no such sentence (grep). "Within a few cycles" is run nowhere. Owner **11b** (cite 05 A3 / 00, drop the time-scale).

**11b-C21 (M) -- notation.**
- 90-notation.qmd:289-306 defines alpha as the diversity-loss of a plan and alpha_max as the budget. 11b writes "the $\alpha$ budget" (11b:22), "$\alpha \le 0.02$ programme" (11b:175), "same budget ($\alpha \le 0.02$)" (11b:311) and "$\alpha = 0.0200$ against greedy's $0.0177$" (11b:227): the budget and the realised loss under one symbol; the CSV realised alpha for the DE arm is 0.0198 (it1-audit R4). Table headers and the horizon table use "alpha <= 0.02". 11b:283 does write alpha_max. Owner **11b**.
- `$F_{\text{drift}}$` at 11b:192, 322, 333, 361 against `90-notation.qmd:266, 273` (`F_{drift}`, `F_{hom}`), the form of 05, 11:94/603; the last `\text{}` left in 11 is 11:604 (11 verdict M17). Owner **11b**.
- 90:226 gives `t` as the cycle index; 11b uses the word "cycle" and `t` only inside code; no clash. "GD" is `GD = 1 - theta` (90:84-90) used for the selection's total, as in 90:240; the only defect is "within" (C5). "the diversity panel" (11b:182) collides with the S1 panel of 08:297-300; 08's statement that 11b logs a different set of columns stays true.

**11b-C22 (L) -- corpus paragraph.**
11b:376-383 "a substantial block concerns recurrent selection and long-term gain": the record counts 687 / 324 are right, but no count backs "substantial block", and `93-corpora.qmd:132-143` tabulates the seven themes of the animal relevance-3 records (OCS 68, coancestry 61, algorithms 27, rare alleles 20, effective size 18, heterozygosity 15, core collections 9) -- none is recurrent selection or long-term gain. 11b cites @sec-corpora as the owner of the corpora, which then do not contain the category. Attribution findings of it1-refs (B1-B5) are the other side of this paragraph. Owner **11b**.

## Owed items, one by one

| Owed (THREAD / task) | Status |
|---|---|
| 11b:12-13 "time series" promise | no promise in 11b; 08:297-300 true; nothing owed. 11b plots index, GD, F_drift only (C5) |
| 11b:77-79 and 11b:344-346 (04b overread) | open: C9, C10 |
| 11b:100-104 only Finding 5 | open: C8 |
| 11b:201 / 11:306 / 12:222 (DE budget, encoding) | open for 11b: C15; 11:306 and 12:222 are those chapters' lines, not changed by 11b |
| 11b:263-267 trajectory vs static status number (reconciled in 11) | 11:596-608 reconciles with a trajectory dF and a saturation diagnostic; 11b's own text still compares N_s with N_e and calls N_e "effective size": open, C2, C3 |
| 11b:398 "two items" framing of 11 | open in a different form: C19 |
| cycle-by-cycle audit; dF = -slope vs 1 - exp(slope) | no audit exists (05:1637-1639 stays true); -slope open: C13 |
| 06:499-505 (six columns; plots index, GD, F_drift only) | open: C5 (11b or one clause in 06) |
| 04c:372 "against the frozen base" | open: C1 (inaccurate in 04c; 11b silent) |
| GD = GD_T, not GD_WS | open: C5 |
| 05 A4 discrete vs 04d overlapping | open: C12 |
| complete-factorial assumption; 04e cited zero times | open: C11 |
| F_hom / F_drift `\text{}` | open: C21 |
| 11:679 per-unit-of-cycle-time reading | not owed by 11b; keep it so: C12 |
| 05b-M6 / THREAD 241 pointer at 11b:404-409 | open: C6 |
| 00-C5 (neutral arm, level of F_drift), 02-C9 (no GD_BI arm) | open: C3, C6; the 11b:117-135 neutral arm exists and is unused |
| 02b-C14 no back-citation of @sec-response | open: C20 |
| 08b-C16 cross-link to @sec-genomic-prediction | open: C8 |
| 02b:36 crossover-by-seed promise; 05:1809 "paid back or not" | 02b kept (C17); 05:1809 answered by a different cap and not stated as not repaid (C16) |
| 04d:1001, 04d:1089 hand-over to 11b | consistent; 11b does not acknowledge 04d (C18) |

## Inbound `@sec-` citations of 11b (`sec-cycles`; self-citations discarded; no other label in the chapter)

Method: every `{#sec-...}` in `book/*.qmd` mapped to its file, every `@sec-...` resolved, citations from a file to itself discarded, one count per occurrence (a row of a table counts once per occurrence). Broken `@sec-` targets over the whole book: none.

| Citing file | Lines | n |
|---|---|---|
| 00-hybrid-programme | 218, 342, 700, 751 (x2) | 5 |
| 02-subdivided | 1039 | 1 |
| 02b-response | 36 | 1 |
| 04c-alphasimr-pipeline | 1435, 2171, 2343 | 3 |
| 04d-breeding-programme | 1001, 1089 | 2 |
| 04e-mating-design | 1499, 1642 | 2 |
| 04f-sparse-testing | 1832, 1967, 2109 | 3 |
| 04g-joint-allocation | 1501 | 1 |
| 05-genomic-era | 97, 100, 125, 1090, 1166, 1466, 1482, 1809 | 8 |
| 05b-heterosis-dominance | 517, 2184 | 2 |
| 06-metric-catalogue | 502 | 1 |
| 08-pipeline-stages | 302 | 1 |
| 08b-genomic-prediction | 1272 | 1 |
| 11-plant-literature | 292, 435, 606, 670, 679 | 5 |
| 11c-limits | 11, 33, 34, 67, 79, 90, 111, 151, 160, 231 | 10 |
| 12-case-study | 191, 198, 271, 273 | 4 |
| 90-notation | 722 | 1 |
| 91-package | 68 | 1 |
| 92-verification | 197, 205, 239 | 3 |
| index | 128, 145 | 2 |
| **Total** | 20 files | **57** (50 from chapters, 7 from index and appendices) |

11b has a job in the book (every chapter of the book has at least 5 inbound occurrences, `sec-corpora` 5 and `sec-backcross` 16 the lowest; no chapter at 0 or 1). Outbound, 11b cites 21 times across 14 owners (03, 04, 04b, 04c, 04d, 05 x2, 05b x2, 06 x2, 07, 08, 10 x2, 11 x2, 12 x5, 93) and **never** 00, 01, 02, 02b, 04e, 04f, 04g, 08b, 09, 10b, 11c: the absences that matter are 04e (C11), 02b/@sec-response (C20), 08b (C8), 11c (C9), 10b (C15).

## What I did not do

No render, no Typst. Did not re-run the producer or the DE same-context check (relied on it1-audit R4 for the 8 of 13 figure); did re-derive the dF/N_e/R^2, N_s range, alpha/gd_ref, GD/GD_BS means and the neutral-arm drift (0.0869) from `book/data` and the chunk. The verdicts for 04d, 11, 04f were taken as approved; 04e and 04g (open) were used only for what they say about 11b (04e:1499, 1642; 04g:1501; 04f:1832).
