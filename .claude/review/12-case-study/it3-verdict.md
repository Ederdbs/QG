# 12-case-study -- iteration 3 verdict

Text judged: `book/12-case-study.qmd` (working tree of branch `review-pending-chapters`), specifically the changed passages at 12:87-99 (ceiling, warning behaviour, muffled advice), 12:208-228 (`z_GD` at alpha = 0), 12:417-422 (truncation margin) and 12:429-441 (scoped interpretation). Also judged: `book/90-notation.qmd:158-163`, the 12 entry of `.claude/review/THREAD.md` (676-685) and `book/downloads/12-case-study.R`. Line numbers are the current files. The author's response was used as a pointer only. Every new inline value was recomputed. The chapter was knitted in full against `pkgload::load_all()` of this checkout, in the scratch directory `v12c/knit`. Every `stopifnot()` passed and no error was raised.

VERDICT: APPROVED

PREVIOUS IDS
- 12-M12 -- CLOSED -- 12:96-99 now names the muffled advice and says it is raised "once per DE run, 5 times in this call" (inline value; the knit prints 5). "Every other warning, the inoperative-budget one included, would surface" now has an explicit referent. Live counts:
  - with a recording handler, one `stage2_select()` call at the chapter settings raised exactly 5 warnings, all the `'NP'` advice, for 5 `DE_` scenarios;
  - a call with `alphas = c(0.02, 0.06)` under the chapter's handler surfaced the inoperative-alphas warning.
- 12-M13 -- CLOSED for 12 -- 12:92-94 now matches R/11_stage2.R:99-118: the function warns, then still runs `sel_de()` and returns the plan under its `DE_alpha_*` label. Observed: `alphas = c(0.02, 0.06)` warned "inoperative alphas (above the 3.94% ceiling): 6%" and returned `DE_alpha_6.00` (alpha 0.0357, index 1.960). 12:95-96 is consistent with the code: the automatic grid ends at the ceiling, and the test is `alphas > alpha_max + 1e-9`. The same wrong description survives in 09; see 12-M18.
- 12-M14 -- CLOSED -- The result paragraph (12:417-422) gives the margin inline: 0.0057 to 0.0102 index units over 20 (seed, budget) pairs, recomputed independently from the CSV. The interpretation (12:432-436) is scoped to the two budgets run, the 30-fold nominal NP x itermax increase (100 x 200 against 300 x 2000), and states that "no larger budget was run". The warm-start question is left as not run.
- 12-M15 -- CLOSED -- 12:211-218 replaces "by construction / the same null" with the correct account:
  - `gd_ref` is the mean of the `B_null` = 500 cheap draws, and `z_GD` is centred and scaled on the separate `B_full` = 80 draws (R/02_benchmark.R:17-22, 60-62).
  - Both assumptions are declared. "Independent draws" holds: the two sets are consecutive draws from one RNG stream, with no overlap. "s.d. taken as exact" is stated as an approximation.
  - The 0.12 value checks out: sqrt(1/80 + 1/500) = 0.1204. Monte Carlo over 400 independent (500, 80) null pairs gave s.d. 0.116 and mean -0.004.
  - "Its GD sits at gd_ref" holds to within the achieved alpha of `DE_alpha_0.00`, which is -8.3e-6.
- 12-M16 -- CLOSED -- 90:161-162 no longer lists @sec-case-study among the chapters that write the Balding-Nichols setting as $F_{ST}$. `grep case-study book/90-notation.qmd` finds no other mention. 12's only `F_ST` is the statistic (12:162, 165-166).
- 12-M17 -- CLOSED -- THREAD:676-685 has been updated:
  - the heading carries the it2 verdict and the pending it3;
  - the 90 item is marked done;
  - the code pass is recorded as done, with its optional remainder;
  - the `case_study` target and the two untracked CSVs are recorded, with the push requirement for the purled script;
  - the three orphan `unnamed-chunk-13-1` files are listed for deletion at render, and all three are present.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 12-M18 book/09-optimal-contributions.qmd:443-445 (dependency of the 12-M13 fix) -- 09 still says that `stage2_select()` "warns about any requested $\alpha$ above this ceiling rather than return an unconstrained plan that looks constrained".
  - This is the description of the function that 12-M13 found wrong. The code warns and then returns the plan (R/11_stage2.R:99-118, observed above).
  - 12:92-94 now states the correct behaviour, so the two chapters describe the same function differently.
  - The THREAD 12 entry does not record this as owed to 09.
  - It is outside 12's file and alone does not reject.

Count of open non-disqualifying failures: 1 (12-M18), below the threshold of three.

WHAT WAS VERIFIED
- Full knit of the chapter: `v12c/knit/ch12.Rmd`, a copy of 12-case-study.qmd with `_common.R` and the two cached CSVs, run with `knitr::knit` after `pkgload::load_all()` of the checkout. It completed with no error and every `stopifnot()` passed. The four new inline values rendered as:
  - 5 at 12:98;
  - 0.12 at 12:216;
  - 0.0057 / 0.0102 / 20 at 12:420-422;
  - 30 at 12:434.
  Unchanged inline values: z_GD 0, z_Ne_parents -5.6 and z_F_drift 7.7 at `DE_alpha_0.00`; secants 0.32, 0.23, 0.16, 0.12 (default-budget means).
- Truncation margin, recomputed from `book/data/case_study_frontier.csv` with my own merge of the k = 5 DE rows against `ref_truncation` by (budget, seed): 20 pairs, 10 per budget, range 0.00568-0.01018. It matches the chapter's `top`: 0.005681407-0.010177675.
- Fold factor: `np_it("chapter")` = (100, 200) and `np_it("default")` = (300, 2000), from the CSV. The product ratio is 30.
- Warning behaviour (`v12c/chk.R`, simulation seed 1, n = 62, B_null 500, B_full 80, NP 100, itermax 200):
  - the automatic grid gave 5 warnings, all the `'NP'` advice, with 5 `DE_` scenarios;
  - `alphas = c(0.02, 0.06)` surfaced the inoperative warning under the chapter's handler, and returned both DE plans.
- `z_GD` null error (`v12c/sdz.R`, `set.seed(99)`, 400 replicates of 500 + 80 random 62-subsets, `gene_diversity()`): s.d. of (mean_500 - mean_80)/sd_80 = 0.116, mean -0.004, against the stated 0.120.
- Achieved alpha of `DE_alpha_0.00` = -8.3e-6. Its GD is 0.3259873, against gd_ref 0.3259845.
- Code read:
  - R/02_benchmark.R:17-22 (cheap and full draws are consecutive and non-overlapping);
  - R/02_benchmark.R:60-62 (z uses `null$full`);
  - R/11_stage2.R:93-118 (warning, then DE for every alpha);
  - R/03_de_select.R:272 (one `DEoptim()` call per `sel_de()`).
- The cache is unchanged since it2. The CSVs and regenerate.R predate the it2 verdict, whose independent regeneration of both CSVs matched to 0.
- `book/downloads/12-case-study.R` carries the it3 wording (lines 162 and 497).
- Dependents searched:
  - `grep "looks constrained|inoperative"` over book/*.qmd and README.md found 09:445, recorded as 12-M18, and 06:936, which is unaffected;
  - `grep "same null|by construction"` in 12 leaves no residue of the 12-M15 wording;
  - 90:158-163 was read.

NOT VERIFIED
- That `run_benchmark.R` produces "the numbers quoted in `README.md`" (12 callout). Carried from it2; non-decisive, and the chapter quotes none of them.
- 07's A-NE/E-NE residual fractions behind the checklist wording. Carried from it2; non-decisive.
