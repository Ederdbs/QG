# 00-hybrid-programme -- iteration 2 verdict

Chapter: `book/00-hybrid-programme.qmd`, with `book/index.qmd`, `book/_common.R`, `book/references.bib`. `00:n` and `index:n` are lines of the working tree. `docs/` and `_freeze/` were not judged. Severity in brackets is mine.

```
VERDICT: REJECTED
```

Three independent grounds: 00-D24 stays open, 00-D25 and 00-D26 are new, and four M findings are open against a limit of two.

## PREVIOUS IDS

Disqualifying
- 00-D1 -- CLOSED -- 00:700-706: head-count reading gone; $N_s \in [1/2, 1]$ follows from @eq-hp-gd, consistent with `06:151-157`.
- 00-D2 -- CLOSED -- 00:602-614: $\Delta F$ defined on $H_t$, the DH case stated as $0/0$ and as the rise of $\theta_t$. Derived: $E[H_{t+1} \mid H_t] = H_t(1 - 1/n)$ gives $(E[\theta_{t+1}] - \theta_t)/(1 - \theta_t) = 1/n$.
- 00-D3 -- CLOSED -- 00:163-170: "maximises" gone; the replacement matches the iteration-1 draws; s.d. printed 5.90, 5.84.
- 00-D4 -- CLOSED -- 00:72-74, 00:201-204 condition on dominance. Reach into the index: 00-M16.
- 00-D5 -- CLOSED -- 00:463-465.
- 00-D6 -- CLOSED -- 00:37-42, 00:127-130; `R/00_data.R:129` confirms effects at every marker.
- 00-D7 -- CLOSED -- 00:22-35 checked item by item against `05:46-110`.
- 00-D8 -- CLOSED -- `hp-drift` now simulates individuals; copy counts are no longer inputs; selfing declared. See WHAT WAS VERIFIED.
- 00-D9 -- CLOSED -- 00:326-332; ledger recomputed: UC only S2 77.46, S4 19.99; UC + div S2 35.51, S4 35.49. Conditions are at `08:381, 08:403-406`.
- 00-D10 -- CLOSED -- 00:695-699: causal clause and "measures that" removed; the level difference is stated.
- 00-D11 -- CLOSED -- knit output prints $3.7 \times 10^{-13}$, s.e. 0.00013, s.e. 0.00039.
- 00-D12 -- CLOSED -- 00:214-220, caption and drawing agree; dashed arrows leave S4 (PNG from my knit viewed).
- 00-D13 -- CLOSED -- @sec-sizing out of the S2 row (00:181).
- 00-D14 -- CLOSED -- 00:575-581 true as the book stands: `02:219, 02:232`, `08:91-96`, Caballero & Toro Eq. 8 read in the PDF.
- 00-D15 -- CLOSED -- completeness claim withdrawn (00:364, 00:752-753).
- 00-D16 -- CLOSED -- 00:457-465: IBD coancestry is $A_{ij}/2$, $f_{ij}$ molecular only.
- 00-D17 -- CLOSED -- S4 scoping, S2 exclusion and the unmeasured within-pool case stated (00:271-273, 00:318-320). Vocabulary residue: 00-M14.
- 00-D18 -- CLOSED -- 00:399-404.
- 00-D19 -- CLOSED -- 00:566-574.
- 00-D20 -- CLOSED -- 00:316-317.
- 00-D21 -- CLOSED -- 00:334-342 matches `02:354-359`; $GD_{BS}$ rises first to last in 15 of 15 runs.
- 00-D22 -- CLOSED -- 00:344-357 checked against the full text: 0.178 to 0.223, 0.430 to 0.420 (Table 3), -2.33%, He(NSS) 0.371 to 0.279, the merger as main cause, "can only speculate".
- 00-D23 -- CLOSED -- 00:357-359; `11:15` gives 2017-2026.
- 00-D24 -- **OPEN** -- the unread paper no longer blocks, but the disclaimer that replaced the identity is false as the book stands. See DISQUALIFYING FAILURES.

Non-disqualifying
- 00-M1 -- CLOSED -- the four assertions are in `hp-heterozygosity`, `hp-f-hybrid` and pass.
- 00-M2 -- CLOSED -- paired precision through `sprintf`.
- 00-M3 -- CLOSED -- scale sentence limited (00:44-49); hygiene done; both contested items upheld below.
- 00-M4 -- CLOSED -- `comstock1948`, `griffing1956` complete. A third incomplete entry enters with this iteration: 00-M17.
- 00-M5 -- CLOSED -- 00:747, index:135.
- 00-M6 -- CLOSED -- 00:193-196.
- 00-M7 -- CLOSED -- the selfing/filial clash is resolved at 00:79-85. The renaming opens a new one: 00-D26.
- 00-M8 -- CLOSED -- removed from 00 and index.
- 00-M9 -- CLOSED -- 00:174-176, 00:183, 00:188-190.
- 00-M10 -- CLOSED -- $p_{b,k}$ against $p_{0,k}$.
- 00-M11 -- CLOSED -- 00:730-731.
- 00-M12 -- CLOSED -- 00:529, 00:535.
- 00-M13 -- CLOSED -- deleted.

Audit, references, continuity (those carried by a D or M close or stay open with it)
- 00-R1 to 00-R9 -- CLOSED -- with 00-D11, D3, D10, D9, D21, D8, M1, M2, M3.
- 00-R10 -- CLOSED -- both contested sub-items upheld, below.
- 00-B1, B5, B6, B14 -- CLOSED -- with 00-D22, D5, D10, D7.
- 00-B2 -- OPEN -- with 00-D24.
- 00-B3, B4 -- CLOSED -- with 00-M4.
- 00-B13 -- CLOSED -- @wright1951 removed; Eq. 8 confirmed.
- 00-B7, B8 (at 00:459), B9, B10, B11, B12 -- remain UNVERIFIED, non-decisive. See NOT VERIFIED.
- 00-C7 -- CLOSED -- index:158-162 true; `08:32` is 30 + 30, 3000 markers. Residue in `_common.R`: 00-M15.
- 00-C4, C9, C10, C11, C12, C14, C16, C17, C20, C21, C23, C24, C27, C29, C30, C31, C34 -- CLOSED -- in 00 or index, with their D or M where one exists.
- 00-C1, C2, C3, C5, C6, C8, C13, C15, C26, C32 -- CLOSED in 00; remainder owed, see OWED ROWS.
- 00-C18, C19, C22, C25, C28, C33, C35 -- routed to their owners, not charged here.

## RULINGS

**00-R10, GCA tolerance at 1e-10: contest upheld.** Reproduced: max|H1| = 391.4, $m\,\varepsilon\,\max|H_1|$ = 1.74e-10, `gca_err` 3.70e-13. Against the magnitude summed, 1e-10 is 2.6e-13 relative, tighter than `tol_id` (8.9e-13). A wrong GCA would miss by orders of magnitude. No defect.

**00-R10, footer sentence: contest upheld, on narrower grounds.** `make_downloads.R` cuts each chapter at the marker and rewrites the footer from one template (`make_downloads.R:43` and `:71-77`; the response's 77-81 is off by a few lines). What decides it is that the sentence is vacuously true for a chapter with no cached read, and that the script ran standalone in an empty directory, printing the `hp-drift` table. That is no failure under any criterion. The re-execution argument is a maintenance reason and I do not rule on it.

**index:165-175, reproducibility: the text breaks the rule.** Issued as 00-D25.

**00-D24 / 00-B2, Comstock et al. (1949): the scoped wording is not sufficient, but the block has moved.** Every claim 00 now makes about the 1949 paper is a claim about what Kadoumi et al. write, and I confirmed those in the full text. The unread paper is therefore no longer decisive for a positive statement of this chapter, and arbitration of its content is not needed for 00. The block is the sentence that speaks for the book, 00:210-212. See the failure below.

## DISQUALIFYING FAILURES

- 00-D24 (H) [criterion 5, 7] 00:210-212 -- "This book ... does not assert that the procedure of @comstock1949 is this scheme on inbred lines rather than on source populations." A universal negative about the book, and it is false today. `05-genomic-era.qmd:80-81` declares, as assumption A3: "Lines are chosen on hybrid performance against the opposite pool (@comstock1949)". `04c-alphasimr-pipeline.qmd:20-23` writes inbred DH lines judged by testcrosses, "pools improved by reciprocal recurrent selection (RRS) [@comstock1949]". `05b-heterosis-dominance.qmd:855-860` calls it "the exact sense in which @comstock1949's scheme is built on the decomposition", a decomposition over lines. The response lists these as owed "once 00-D24 is arbitrated", so 00's sentence depends on repairs not yet made. This is the defect of 00-D14 ("in this book") again. The owed row fails the test of being true today without the later chapter.

- 00-D25 (H) [criterion 3 provenance, 5] index:168-175, and index:176-177 -- "`book/scripts/regenerate.R` regenerates all of them" and "everything reported here is reproducible output from a simulated dataset". Both are false.
  - Cached external results. `regenerate.R:24-39` lists `mating_scenarios_summary`, `mating_optimizer_frontier`, `mating_validation`, `mating_core_findings`, `figs/mating_*.png` and six `sparse_*` files under "Not regenerated here", and `92-verification.qmd:340, 342` marks them "**not regenerable here**". The headline results of @sec-mating and @sec-sparse are thereby labelled reproducible, which the provenance rule forbids.
  - The sentence fails on items it names. "The differential-evolution sweeps": `book/data/de_constraints.csv` has no writer in `book/scripts/`, `inst/` or `R/` (grep). "The cost benchmark": `book/data/cost_per_eval.csv` is the production-scale table (`92`: L = 300, N = 22500, m = 10000), whereas `regenerate.R` writes `report/cost_per_eval_book.csv` and `run_benchmark.R` writes `report/cost_per_eval.csv`.
  - Also without a writer: `metric_redundancy`, `fst_definitions`, `dist_vs_variance`, `theta_identity_check`, `pipeline_loss_ledger`. `mabc_*` comes from `run_mabc.R`, not `regenerate.R`.
  - "From a simulated dataset" is false for `bibliography_*`, `plant_metric_usage` and the hand-extracted `sparse_primary_studies`, `sparse_literature_parameters`. "Reproducible" is contradicted by `04c:1596`, "Not reproducible from the seed (MaCS founders)".
  - The pointer to @sec-verification does not cure this: the appendix contradicts the sentence that cites it.
  - index:176-177 closes the same note with "which metric dominates which ... do not" move under a change of configuration or seed. No evidence is cited, and `92` ("Everything is verified on simulated data") says that the redundancy of metrics was derived at $F_{ST} = 0.15$ and is to be re-derived. An unscoped robustness claim.

- 00-D26 (L) [criterion 5] 00:83-85 against 00:609-610, 00:663 -- 00:83 fixes the superscript: "The superscript counts selfings, not filial generations". 00:609-610 then writes $\bar F^{(t)}$ with $t$ counting generations of random mating, in the drift section, where no selfing is meant. The chunk comment at 00:663 uses a third form, $F_t$, for the plant-level coefficient relative to $p = 0.5$, which can be $-1$, the same letter and subscript that the 00-M7 fix removed from the selfing series. Introduced by the fixes to 00-D2 and 00-M7.

## NON-DISQUALIFYING OBSERVATIONS

- 00-M14 (L) 00:368, index:36 -- 00-D17 and 00-C13 reserved "pool" for heterotic pools and named the hybrids the candidate set. "The founding candidate pool" (00:368) and "a pool of 2500" (index:36, one line after "full candidate set") remain.
- 00-M15 (L) `book/_common.R:17` -- "Every live example in the book runs at this size" is the sentence 00-C7 removed from index:158-162. It stands in the file the index now cites as the place the scale is set, and it contradicts the index. `make_downloads.R` copies `_common.R` from `set.seed()` on, so the sentence also reaches every download.
- 00-M16 (L) index:83-85 -- "Diversity between the pools is what makes the hybrid worth selling" keeps the unconditional form that 00-D4 removed from 00. The same file bounds it at index:60-62, hence not disqualifying.
- 00-M17 (L) `references.bib` `hull1945` -- newly cited by 00:209, with no volume or pages and a stray footnote mark in the title ("Corn1"). Kadoumi's list gives 37(2):134-145.

Four observations: the accumulation rule (three or more) rejects independently of the D list.

## OWED ROWS

Every owed row names a later chapter (02, 04, 04c, 04e, 04g, 05, 05b, 06, 07, 08, 11, 11b, 11c, 12, 90, 92; `R/14_cycles.R:8` is code, and asserts no attribution). Wording in 00 tested against the later text as it stands today:
- True today: C1 (00:577-581 against `08:91-96`), C2, C3, C5 (00:696-698), C6 (00:217-220), C8 (00:364, 00:752), C13, C15 (00:331-332: "reported there with its conditions" holds at `08:381, 08:403-406`), C26, C32.
- **Not true today: the RRS row.** See 00-D24.
- Missing from the owed list, for 08's review, not charged here: `08:167` ("This is where the largest share of pipeline diversity is lost") is unconditional like `08:376, 451-452`; `08:160-163` says Kadoumi "found exactly the two opposite trends", against 00:344-351. `92` ("The script is the single place where the expensive computations live") shares the defect of 00-D25.

## WHAT WAS VERIFIED

Chapter purled and sourced from `book/` against `pkgload::load_all()` of the worktree, chapter seeds; prose knit to scratch with `knitr::knit`. `R/` and `tests/` have no diff against `origin/main`. Scripts in the session scratchpad.

- All chunks run, all `stopifnot()` pass, 1.55 s. `gca_err` 3.70e-13, correlation 0.8587, top-5 overlap 3, s.d. 5.90 and 5.84. `sub_gd`, `het`, `ibs` unchanged from iteration 1. $H_o$ = 0.36169 = $GD_T$ 0.32809 + $GD_{BS}$ 0.03360.
- `hp-drift` output: 0.59706 (s.e. 0.00137) against 0.59874; 0.61160 (0.00120) against 0.61312; 0.34583 (0.00184) against 0.34868; z = -1.22, -1.27, -1.55.
- No-selfing recursion, derived line by line. Let $c_t$ be the coancestry of distinct plants on the scale $2P(\text{IBS}) - 1$ at $p = 0.5$. Two alleles of distinct offspring come from independent uniform parents: the same plant with probability $1/n$, giving $(1 + F_t)/2$, otherwise $c_t$. So $c_{t+1} = (1 - 1/n)c_t + (1 + F_t)/(2n)$. Parents of one plant are distinct, so $F_{t+1} = c_t$. Group coancestry with the diagonal is $\varphi_t = (1 + F_t)/(2n) + (1 - 1/n)c_t = c_{t+1}$, and $p^2 + q^2 = (1 + \varphi)/2$ gives $H_t/H_0 = 1 - c_{t+1}$. Founders $F_0 = -1$, $c_0 = 0$; the loop runs $t_{gen} + 1$ steps as it must. Correct.
- Independent two-lineage Markov chain, written by me (states coalesced, within plant, between plants): 0.613115772; the recursion gives 0.613115772.
- Code of the arms read: `b` is uniform over the others; the selfing arm is exact Wright-Fisher with $2n$ copies per locus; the DH arm is exact with $n$, each new allele being uniform over lines and independent across lines. Founders do not affect those two.
- Bias check on the chapter's own functions: 20,000 pedigrees per arm, seed 777: 0.59811, 0.61342, 0.34791. Further 40,000 on the selfing and DH arms, seed 4242: z = -2.42, -0.57. The selfing arm stayed low, so I ran 4 x 150,000 pedigrees (seeds 101, 202, 303, 404): z = -0.48, -0.22, -0.25, -1.12, about -1.0 pooled. No bias.
- Scope of the claims. "Twice as fast" (00:692) is algebra of @eq-hp-drift and holds for every $n$ under the stated scheme. "Far less than that" (00:693) holds beyond $n = 10$: dominant root of the recursion, no-selfing $\Delta F$ over selfing $\Delta F$ = 0.764, 0.901, 0.950, 0.990, 0.998 at $n$ = 2, 5, 10, 50, 200, against 2 for DH; $N_e$ = 10.52 at $n = 10$. Both are scoped to neutrality; the Result carries $n$, $t$ and the replicate.
- Founder dependence of the no-selfing expected value: 0.6131 with heterozygous founders ($F_0 = -1$), 0.6147 with $F_0 = 0$, 0.6165 with $F_0 = 1$, each on its own $H_0$. The state used is declared in the chunk (00:643, 00:664), which is echoed, not in the prose at 00:623-624. Not a failure, and the conclusion does not depend on it.
- Pedigree as replicate: correct for loci sharing parents. s.e. in the echoed table.
- $F_{ST}$ forms on book data: 0.1858 and 0.1024, ratio 1.81, consistent with "near twice".
- `cycles_trajectory.csv`: $GD_{BS}$ last above first in 15 of 15 runs (3 budgets x 5 seeds). `pipeline_loss_ledger.csv`: shares as in 00-D9.
- Kadoumi et al., full text, Europe PMC PMC12397178, fetched again: Introduction ("tester-based reciprocal recurrent selection ... conceptualized by Hull (1945)", "modified reciprocal recurrent selection", "Each group of inbreds serves as source material", heterotic structure cited to Comstock et al. 1949), Tables 2 and 3, "can only speculate", the Abstract on the merger.
- van Heerwaarden et al. (2012), abstract from Europe PMC, read by me: "increasing genetic separation of breeding pools"; "selection has had limited impact on genome-wide patterns of diversity and ancestry". Matches 00:354-357.
- Caballero & Toro (2002), PDF in `reference/papers`: Eq. 8, $GD_{BS}/GD_T = F_{ST}$.
- Labels at 00 resolve: `sec-era-step4`, `sec-era-transposition`, `sec-heterosis-identity`, `sec-mating-estimation`, `sec-heterosis-gca-sca`, `sec-f-molecular`, `sec-ns`, `sec-baseline`, `sec-collapse`, `eq-gd-partition`, `eq-x-freq`, `eq-hybrid-dosage`, `eq-f-molecular`. Reading-map order checked against `_quarto.yml`.
- `book/downloads/00-hybrid-programme.R` run in an empty directory with the installed `hybdiv`: completes, prints the `hp-drift` table.
- 00-D25: writers listed from `write.csv` calls and header of `regenerate.R`, `run_benchmark.R:73`, grep of each `book/data` basename over `book/scripts`, `inst`, `R`; `92:274-342, 349-410` read.

## NOT VERIFIED

- 00-B2, Comstock, Robinson & Harvey (1949): UNVERIFIED, not reached (paywalled, not in `reference/`). Not decisive for what 00 claims positively. It becomes decisive for `05:80-81`, `04c:20-23` and `05b:855-860`, in those chapters' reviews.
- @hull1945: not read. 00 reports only what Kadoumi et al. say of it, which is verified.
- 00-B7 Falconer & Mackay chapter pins, 00-B8 Malecot at 00:459, 00-B9 Cockerham, 00-B10 Sprague & Tatum, 00-B11 Design II in the 1948 paper, 00-B12 Griffing's notation: UNVERIFIED, primary texts not reached. Non-decisive: standard definitions or attributions of notation, no identity depends on them.
- van Heerwaarden et al. (2012): abstract level only. Non-decisive; 00 now makes only two statements, both in the abstract.
- The author's 60-seed z summary was not rerun; replaced by the 600,000-pedigree check above.
- No `quarto render`, so the Typst output of 00-D11 and the cross-references as resolved by Quarto are not checked. Non-decisive; the render at close covers them.
