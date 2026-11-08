# 00-hybrid-programme -- iteration 1 verdict

Chapter: `book/00-hybrid-programme.qmd`. All `00:n` locations are lines of that file. Severity in brackets (H, M, L) is mine.

```
VERDICT: REJECTED
```

## DISQUALIFYING FAILURES

Criterion 1 (theoretical correctness)

- 00-D1 (H) [criterion 1, 5] 00:534-536, closing paragraph of "Drift and effective size" -- $N_s = 1/(2\theta_S)$ is said to have "the dimension of a count of individuals". $\theta_S$ in this chapter is molecular group coancestry (00:222-226, 00:315, 00:438-440). On it, $\theta_S = m^{-1}\sum_k(\bar p_k^2 + \bar q_k^2) \in [1/2, 1]$ at biallelic loci, so $N_s \in [1/2, 1]$ for every set, whatever its size. It is a monotone rescaling of $\theta_S$ and counts nobody. Measured on the chapter's own data: 0.744 for the 625 hybrids, 0.611 for one hybrid, 0.710 for pool A's 25 lines, and 0.671 to 0.745 over 2000 random subsets of 2 to 624 hybrids. The sentence contradicts the section it cites (`06-metric-catalogue.qmd:151-157`: "not a number of individuals") and `90-notation.qmd:627-630`. The head-count reading belongs to coancestry measured against a base, and the chapter has just said that $\mathbf{f}$ is not that (00:429-432). None of the three reports found this.

- 00-D2 (M) [criterion 1, 5] 00:489-501, 00:530, against 00:461-462 -- $\Delta F$ is called "the per-generation rate of inbreeding", and $\Delta F = 1/n$ is assigned to a pool re-derived as $n$ DH lines. The chapter has defined $F_i$ as a property of an individual (00:444) and states it is 1 for every line by construction (00:461-462). With $F_t \equiv 1$ the rate $(F_t - F_{t-1})/(1 - F_{t-1})$ is $0/0$. What decays at $1/n$ in the DH case is the expected heterozygosity of the set, that is, the rate of rise of group coancestry. The chapter never says that $\Delta F$ has changed object, in the section whose purpose is to keep the $F$ quantities apart.

- 00-D3 (M) [criterion 1] 00:141-144 -- "the case shown is the one that maximises the disagreement" is false as stated (00-R2). On the chapter's 25 lines the realised additive part is not orthogonal to $g_1 - g_2$. With $a_k \sim N(0, s^2)$, $s = 0.05$, 35.1% of draws fall below the 0.859 shown, and the minimum over 1000 draws is 0.833. At $s = 0.25$ the mean is 0.905 and the minimum 0.792. The mean does rise with $s$, so "pulls towards 1" holds as an expectation over $a_k$; "maximises" does not, and that expectation is not what the sentence claims. It also needs $\mathrm{Var}(g_1) \approx \mathrm{Var}(g_2)$, which is not stated.

- 00-D4 (M) [criterion 1, 5] 00:53-55, 00:167-168 -- "that complementarity depends on the two pools' allele frequencies differing (@sec-heterosis)" and "the divergence the product depends on" are unconditional. The chapter cited derives the opposite reading: under neutral divergence expected heterosis does not move (`05b-heterosis-dominance.qmd:25-28`). The condition appears only at 00:552-554, some 500 lines later, and does not reach these two statements (00-C11).

- 00-D5 (L) [criterion 1, 5] 00:371-373 -- "the matrix $\mathbf{f}$ every diversity metric in the book is computed on". False inside this chapter: $F_{drift}$ and $F_{hom}$ (00:466-470) are computed on allele frequencies against $p_0$ (`R/01_metrics.R:224-225`), and `05-genomic-era.qmd:76-77` says so (00-B5, 00-C26).

Criterion 2 (explicit assumptions)

- 00-D6 (H) [criterion 2] 00:27, 00:107-116 -- A5 is restated as "markers neutral", and the chapter says the examples use it (00:19). `hp-gca-tester` then gives every marker a dominance deviation (`rgamma(ncol(GL), 2, 4)`), so all 2000 markers are QTL there; the prose calls the draw illustrative but never says the marker set is the QTL set. The chapter also declares the programme of the whole book to be A1--A8 (00:18), while the book's traits have effects at every marker (`R/00_data.R:129-130`, `03-simulating-crosses.qmd:16-18`). A declared assumption is silently violated in one chunk and, by adoption, across the later chapters (00-C6).

- 00-D7 (M) [criterion 2, 5] 00:18-28 -- The list misstates what it restates. "Closed breeding units" is given as A1 and is not in A1 (`05:46-52`) (00-B14). A5 is restated without its linkage-equilibrium clause (`05:91-94`), on which `simulate_data()` rests. "Four of them" omits A8, which the next paragraph uses, and the frozen base of A6 (00:290, 00:467-468). A7 and A8 are scoped to "this chapter" in 05 but adopted here for the whole programme, and 00:100-116 uses dominance (00-C21).

- 00-D8 (M) [criterion 2, 3] 00:497-502, 00:507-513, 00:523-530 -- "The chunk checks both against @eq-hp-drift", and the Result reports what "the crossing block" and "the DH pool" retain. Neither object is simulated. `rbinom(m_dr, n_gam, p) / n_gam` iterates the equation's own binomial with $n_{gam}$ supplied, so the two claims under test ($2n$ copies, $n$ copies) are inputs and the check confirms the algebra only (00-R6). $N_e = n$ also needs selfing allowed, which "intermated at random" does not declare. In my individual-level oracle ($n = 10$, 10 generations) the retained fraction is 0.565 (s.e. 0.006) with selfing allowed and 0.590 (s.e. 0.006) with it excluded. A maize crossing block is the case where this assumption matters.

Criterion 3 (empirical support) and 6 (limitations)

- 00-D9 (M) [criterion 3, 6] 00:270-273 -- "the largest share of the loss falls at S2, not at S4" is unconditional, and the condition that decides it is omitted. From `book/data/pipeline_loss_ledger.csv`, paired over 8 founder seeds: under `UC only`, S2 77.46%, S4 19.99%, paired S2 - S4 57.48 (s.e. 3.66), S2 > S4 in 8/8. Under `UC + div`, S2 35.51%, S4 35.49%, paired 0.02 (s.e. 4.12), S2 > S4 in 4/8, a tie. Deferring to @sec-stages for "its conditions" does not cover a claim that fails in one of the two arms. The ledger omits recycling, which 00:269-270 has just listed as a loss step (00-R4, 00-C15).

Criterion 4 (result and interpretation) and 7 (citations)

- 00-D10 (H) [criterion 4, 7] 00:530-532 -- "Selection makes the realised rate larger, because selected parents contribute unequally; @sec-cycles measures that across cycles". 11b has no neutral arm (no such term in the file; the rate section `11b:232-254` compares budgets only) and does not measure contribution inequality, so neither the comparison nor the cause is measured there. Its rates ($\Delta F$ = 0.0292, 0.0358, 0.0265 from `cycles_trajectory.csv`) read directly against @eq-hp-drift with 25 DH lines per pool ($\Delta F$ = 0.04) point the other way, because `F_drift` is taken on merged hybrid frequencies, a different level from @eq-hp-drift. The causal clause has no source (00-R3, 00-C5, 00-B6).

Criterion 5 (internal consistency)

- 00-D11 (H) [criterion 5] 00:132, 00:254, 00:419 -- Three numbers in the published book are not the computed ones. HTML (`docs/00-hybrid-programme.html:747, 876, 956`) prints "to within 4^{-13}" (computed 3.7e-13), "s.e. 10^{-4}" (1.3e-4), "s.e. 4^{-4}" (3.9e-4). Read as written, the third is ten times the real s.e. It is the only s.e. the prose gives for that estimate (00-R1).

- 00-D12 (H) [criterion 5] 00:164-170, 00:174, 00:196-214 -- The cycle drawn is not the cycle the book studies, and the chapter does not connect its central problem to the next cycle. In @fig-hp-cycle S4 is a dead end: S4 leads only to "commercial F1", and both recycling arrows leave the trials box (frozen PNG viewed; `fig-alt` says the same). Yet 00:170 says `run_cycles()` implements this scheme, and there recycling is driven by the selected hybrids: `line_weights(idx, ctx)` then `next_pool()` (`R/14_cycles.R:158-162`). On the drawn cycle the S4 budget $\alpha_{\max}$ cannot touch the next cycle's pools, and the red triangle on S4 cannot be what the caption says, a step where "within-pool diversity is lost". The caption's "is lost" at S3 and S4 also contradicts 00:258-260, where no loss is guaranteed under selection and the chunk shows a selected set above the pool. "Implements it" further omits that `run_cycles()` has no trials, no S3, and an index known without error (`11b` C7, C8). Extends 00-C10.

- 00-D13 (H) [criterion 5] 00:153 -- @sec-sizing is listed as where S2, "choosing parents and crosses for DH induction", is treated. That chapter sizes one already chosen "wide biparental cross between two divergent heterotic groups" by SSD (`04-population-sizing.qmd:15-18, 27-31`); 04 has zero occurrences of DH or doubled. The cross is of the kind 00:167-169 rules out (00-C2).

- 00-D14 (H) [criterion 5] 00:471-473 -- "$F_{ST}$ ... in this book $GD_{BS}/GD_T$". `08-pipeline-stages.qmd:91-96` calls that form $G_{ST}$ and gives $F_{ST}$ to $(\theta_w - \theta_B)/(1 - \theta_B)$, near twice as large, and 08's monitoring advice rests on that one (`08:131-140`). With two equal pools the forms are $(H_b - H_w)/(H_b + H_w)$ and $(H_b - H_w)/H_b$, so they are different quantities. `02-subdivided.qmd:219-222` and 08 attribute the two forms to Wright in opposite ways. "In this book" is false as the book stands (00-C1).

- 00-D15 (H) [criterion 5] 00:287, 00:582-583 -- @sec-notation "collects every symbol used above, with the function that computes it". Absent from 90: $\bar y_{ij}$, $\bar e_{ij}$, $q_{0,k}$, $A_{ij}$ (the last not in 00-C8), and $H_t$ in the sense of 00:488 (the only row is the sizing-local one); $GD_S$, $GD_{\text{ref}}$ occur only inside other rows. Many Function cells are "-" (00-C8).

- 00-D16 (M) [criterion 5] 00:367 against 00:381 -- $f_{ij}$ is defined as the probability that two alleles are IBD, and 14 lines later @eq-hp-ibs-ibd uses $f_{ij}$ for the IBS molecular quantity, whose very point is that it differs from pedigree coancestry. The IBD coancestry is then renamed $A_{ij}/2$. One symbol carries both sides of the relation the section exists to separate. Not in any report.

- 00-D17 (M) [criterion 5] 00:219-229, 00:236-241, 00:257, 00:261 -- "Pool" means a heterotic pool (00:49) and then the 625 hybrids ("above the pool"). 00:218-219 says every marked step "samples or selects a subset of $n_{sel}$ of the $N$ members of a pool"; at S2 each DH is a new gamete (00:267-268), not a member. The subset formula and the chunk measure a merged hybrid set at S4 only, and the Interpretation (00:258) extends them to every step of a figure whose caption speaks of within-pool diversity. Within-pool diversity is not measured there (00-C13).

- 00-D18 (M) [criterion 5] 00:14, 00:351, 00:355, 00:472, 00:548 -- "Each is defined once", yet $GD_T$, $GD_{BS}$, $GD_{WI}$ are used undefined, $F_{ST}$ is defined through two of them, and the chapter never says that $GD_T$ of a set is its $GD_S$ (00-C12).

- 00-D19 (M) [criterion 5] 00:466-470 -- $F_{drift}$ is "a property of a pool through time" and $F_{hom}$ a "loss of heterozygosity". Both are computed on the merged hybrid frequencies, a notional pool, "not the heterozygosity of the product" (`05:208-218`), and are applied to one-cycle selections. The chapter separated $H_e$ from $H_o$ 150 lines earlier (00-C14).

- 00-D20 (L) [criterion 5] 00:263-264 -- $GD_{\text{ref}}$ is "the gene diversity of a random subset". It is the mean over random subsets (`90:290`, `run_cycles()` via `null_distribution()`). This is the denominator of $\alpha$ (00-C27).

Criterion 7 (citations)

- 00-D21 (H) [criterion 7, 1] 00:274-276 -- "within-pool selection and drift push the two pools' frequencies apart ... (@sec-subdivided)". The chapter cited derives drift alone and ends "Selection is not covered by this argument" (`02-subdivided.qmd:354-359`). With a common selection target in both pools, as in `run_cycles()` (one $\beta$), no argument is given in the chapter that selection pushes frequencies apart. The rise under selection is a simulation result located elsewhere (00-C3, 00-R5).

- 00-D22 (H) [criterion 7, 4] 00:276-281 -- @kadoumi2025 is used as support for the mechanism of the preceding sentence, and what the source says against it is left out. Read directly (Europe PMC, PMC12397178): the rise is in $F_{ST}$ (0.178 to 0.223); between-group SS-NSS Hamming distance "sustained a small decrease", 0.430 to 0.420, -2.33%. Between inbred parents that distance is the heterozygosity of their hybrid, the $H_o$ of 00:349-357, so the omitted number is the one nearest the product. The decline is concentrated in NSS (He 0.371 to 0.279, Hamming -16.1%, against -1.4% in SS, He stable). The main cause of loss is "the merging and genetic homogenization" of Iodent and Lancaster, with gene flow between groups, in pools that are not the closed pools of 00:22; on selection the authors "can only speculate". The selection caveat is given for van Heerwaarden only, and "both trends" over-reads that paper too (00-B1).

- 00-D23 (H) [criterion 7, 5] 00:281-282 -- "@sec-plant-literature places these results among the rest of the plant literature". @vanheerwaarden2012 occurs nowhere in the book but 00:280, and the corpus of 11 is 2017-2026 (00-C4).

- 00-D24 (M) [criterion 7] 00:169-170 -- "This is reciprocal recurrent selection [@comstock1949]" for a scheme of fixed inbred lines tested in cross with DH re-derivation. Unverified by `quant-refcheck` (00-B2). The one source read in full, Kadoumi's Introduction, names the inbred tester form differently ("tester-based reciprocal recurrent selection ... conceptualized by Hull (1945)", "modified reciprocal recurrent selection"). The identity is stated without qualification and the book builds on it (`05:81`, `05b:825, 855`, `04c:22`, `R/14_cycles.R:8`). It is decisive and cannot stand unverified; see NOT VERIFIED.

## NON-DISQUALIFYING OBSERVATIONS

- 00-M1 (L) 00:15, 00:437, 00:315, 00:547-548, 00:555-556 -- "checked numerically" is not met for identities the prose asserts with no assertion: $s_i = (1 + F_i)/2$, $GD_{WI} = 0$ "exactly", @eq-hp-gd on a proper subset, the quadratic form (00-R7). All hold.
- 00-M2 (L) 00:525-528, 00:254-255 -- paired values at different precision: "0.6 (expected 0.599)", "0.35 (expected 0.349)", "expected 0.321" beside "0.3209" (00-R8).
- 00-M3 (L) 00:30, 00:114, 00:328, 00:512-513, 00:590 -- scale sentence wider than the chunks; code hygiene, footer boilerplate (00-R9, 00-R10).
- 00-M4 (L) `references.bib` `comstock1948`, `griffing1956` -- incomplete entries (00-B3, 00-B4).
- 00-M5 (M) 00:18-19, 00:577 -- the reading map presents @sec-programme as "a whole programme" under a chapter that has just said the programme is A1--A8; `04d` is an inbred-line scheme, which A1 excludes (00-C9).
- 00-M6 (M) 00:76-78, 00:146, 00:154 -- "not worth what it yields on its own" beside S3 selecting lines per se, with no statement of why both occur; the trials box and recycling belong to no stage although the stages "divide a cycle" (00-C10, remainder after 00-D12).
- 00-M7 (M) 00:60-64 -- $F_t$ is the inbreeding coefficient after $t$ selfings; elsewhere it is the filial generation, one generation apart, and 00:69 uses F1 in the filial sense (00-C16).
- 00-M8 (M) 00:581-582 -- "forward pointers are marked as such" is a universal claim that the continuity count does not support (00-C17).
- 00-M9 (L) 00:147, 00:155, 00:161 -- S4 row omits @sec-advanced and @sec-genomic-prediction; three systems of "stage" with no warning (00-C23, 00-C24).
- 00-M10 (L) 00:290, 00:374-376 -- two bases under $p_{0,k}$ (00-C32).
- 00-M11 (L) 00:560-561 -- "assumptions of the animal-breeding results": `05:1804-1808` covers the simulation of one paper (00-C34).
- 00-M12 (L) 00:437, 00:442, 00:463-470 -- $F_i$ is used before it is defined; "three quantities" and the list carries four symbols, without $\Delta F$. New.
- 00-M13 (L) 00:271-272 -- "where optimisation effort usually goes" has no source. New.

Thirteen observations: the accumulation rule (three or more) rejects independently of the D list.

## DISPOSITION OF R, B, C FINDINGS

Accepted means the finding stands. "On report" means accepted without my rechecking the cited text.

Audit
| ID | Disposition |
|---|---|
| 00-R1 | Accepted, H -> 00-D11. HTML rechecked; PDF column on report |
| 00-R2 | Accepted -> 00-D3, recomputed |
| 00-R3 | Accepted, raised to H -> 00-D10 |
| 00-R4 | Accepted -> 00-D9, recomputed |
| 00-R5 | Accepted, raised to H with 00-C3 -> 00-D21 |
| 00-R6 | Accepted, raised to disqualifying -> 00-D8, oracle rerun independently |
| 00-R7 | Accepted -> 00-M1 |
| 00-R8 | Accepted -> 00-M2 |
| 00-R9, 00-R10 | Accepted -> 00-M3 |

References
| ID | Disposition |
|---|---|
| 00-B1 | Accepted, raised to H -> 00-D22; source read directly. The subscripts the report inferred are confirmed: He(NSS) falls, He(SS) is stable |
| 00-B2 | Accepted -> 00-D24, open and decisive |
| 00-B3, 00-B4 | Accepted -> 00-M4. Absence of volume and pages rechecked |
| 00-B5 | Accepted -> 00-D5 |
| 00-B6 | Accepted -> part of 00-D10 |
| 00-B7 to 00-B13 | Accepted as UNVERIFIED, non-decisive; see NOT VERIFIED. They do not block on their own |
| 00-B14 | Accepted -> 00-D7 |

Continuity. Every open H rejects, whatever the owner.
| ID | Disposition |
|---|---|
| 00-C1 | Accepted, H -> 00-D14. Owner 08 and 02; the sentence at 00:472 is false until it closes |
| 00-C2 | Accepted, H -> 00-D13 |
| 00-C3 | Accepted, H -> 00-D21 |
| 00-C4 | Accepted, H -> 00-D23 |
| 00-C5 | Accepted, H -> 00-D10. Owner 11b/11c for the level of `F_drift` and the reference arm; 00:531-532 fails until closed |
| 00-C6 | Accepted, H -> 00-D6. Owner 05 for A5; the chunk at 00:116 is this chapter's own |
| 00-C7 | Accepted, H, open. Owner index (`index.qmd:157-159`). Checked against `08:32`; other lines on report. 00:30-33 is itself correct, but the finding blocks under the rule for open H |
| 00-C8 | Accepted, H -> 00-D15, with $A_{ij}$ added |
| 00-C9, C10, C16, C17 | Accepted -> 00-M5, 00-M6 and 00-D12, 00-M7, 00-M8 |
| 00-C11 to 00-C15 | Accepted -> 00-D4, D18, D17, D19, D9 |
| 00-C21 | Accepted -> 00-D7 |
| 00-C23, C24, C32, C34 | Accepted -> 00-M9, 00-M10, 00-M11. C23, C24, C32 on report |
| 00-C26, 00-C27 | Accepted -> 00-D5, 00-D20 |
| 00-C18, C19, C20, C22, C25, C28, C29, C30, C31, C33, C35 | Accepted, routed to their owners, not blocking this chapter (M or L, later or earlier owner). C25's four uncited labels and C30 rechecked; C19's `11b:241-242` rechecked; the rest on report |

Passed on to other chapters' reviews, not charged here:
- `11b:252` says the unconstrained fitted $\Delta F$ is "the *lowest* of the three"; the data give 0.0292 against 0.0265 at budget 0.005, so it is the middle one.
- `book/data/pipeline_loss_ledger.csv` has no producer under `R/`, `inst/` or `book/scripts/` (grep). The provenance of the result behind 00:271 is to be settled in 08's review.

## OPEN ITEMS

The chapter cannot be approved with any of these open:
- All D findings: 00-D1 to 00-D24.
- 00-C7 (index).
- The decisive attribution in 00-D24 (00-B2): unresolved until the 1949 paper is read, or the user arbitrates.
- 00-M1 to 00-M13 as an accumulation: fewer than three may remain.

## WHAT WAS VERIFIED

All runs: chapter chunks by `knitr::purl`, sourced from `book/` against `pkgload::load_all()` of the worktree, chapter seeds. Scripts in the session scratchpad.

- Chunks run, all `stopifnot()` pass. `gca_err` 3.70e-13; `cor(g1, g2)` 0.8587; top-5 overlap 3; sd(g1), sd(g2) 5.90, 5.84.
- `hp-subset-gd`: pool 0.32809, random mean 0.32087, s.e. 1.32e-4, expected 0.32095, max 0.32512, greedy 0.32962. Subset formula derived by hand; $\bar f_d/N + (N-1)\bar f_o/N$ = 0.671907 = 1 - GD.
- `hp-heterozygosity`: He_A 0.29533, Ho 0.36169, He = GD = GD_T 0.32809, GD_BS 0.03360, GD_WI -4.4e-16. $\overline{(p_A - p_B)^2}/2$ = 0.0335968 = GD_BS, so $H_o - H_e = GD_{BS}$ also by hand algebra. $F_{ST}$ live 0.1024.
- @eq-hp-gd, @eq-hp-ibs-ibd (including $i = j$: $p^2 + q^2 + pq$), @eq-hp-drift, the GCA weight $a + d(1 - 2p_B)$ from $a(u + v - 1) + d(u + v - 2uv)$, the $(1 - b)/4$ gap: derived by hand, correct.
- `hp-ibs-ibd`: full sib 0.72642 (s.e. 3.87e-4), expected 0.72637; unrelated 0.63509 (s.e. 4.08e-4), expected 0.63516.
- `hp-drift`: 0.59969 (s.e. 0.00259) against 0.59874; 0.34960 (s.e. 0.00286) against 0.34868. Loci there are independent chains and are declared so; acceptable as replicates. They do not test what 00-D8 says.
- $s_i$: mean($F_i$) 0.63831, $(1 + F)/2$ = 0.81916 = mean diag f.
- 00-D1: `status_number()` values above; 2000 random subsets, seed 1.
- 00-D3: 1000 draws per $s$, seed 99: $s$ = 0.05, 0.10, 0.25, 0.50 give mean 0.862, 0.869, 0.905, 0.955; share below 0.8587 0.351, 0.237, 0.032, 0.000; min 0.833, 0.811, 0.792, 0.902.
- 00-D8: individual-level oracle, $n$ = 10, 10 generations, 25 pedigrees x 4000 loci per arm, seeds 2026, 2027: 0.5651 (s.e. 0.0063) selfing allowed, 0.5904 (s.e. 0.0056) excluded; closed forms 0.5688 and 0.5832.
- 00-D9: ledger means and paired differences as stated; S3 2.55 and 28.99.
- 00-D10: `11b:238-243` regression on `cycles_trajectory.csv`: $\Delta F$ 0.02921, 0.03575, 0.02647; $N_e$ 17.1, 14.0, 18.9. Grep of 11b for neutral, unmanaged, no selection, random arm: empty.
- 00-D11: `docs/00-hybrid-programme.html:747, 876, 956` read.
- 00-D12: `R/14_cycles.R:158-162`, `11b` C7 and C8, frozen `fig-hp-cycle-1.png` viewed.
- 00-D22: full text of PMC12397178 fetched from the Europe PMC REST service; passages and Table 3 read.
- `F_drift`, `F_hom`: `R/01_metrics.R:224-225`. Meuwissen et al. (2020), PDF in `reference/papers`: "can be negative", "never negative". Caballero & Toro (2002), PDF: "(Cockerham 1967)" on all $N_i \times N_j$ pairs, and $GD_{BS}/GD_T = F_{ST}$.

## NOT VERIFIED

- 00-D24 / 00-B2: whether Comstock, Robinson & Harvey (1949) describe a scheme on inbred lines or on source populations. **Decisive; blocks APPROVED.** Paywalled and not in `reference/`. Needs the paper, or the user's arbitration.
- 00-B7 Falconer & Mackay chapter pins; 00-B8 Malecot; 00-B9 Cockerham (secondary support read); 00-B10 Sprague & Tatum; 00-B11 Design II in the 1948 paper; 00-B12 Griffing's notation; 00-B13 Wright 1951. Primary texts not reached. Non-decisive: each is a standard definition or an attribution of notation, and no identity depends on it. A copy in `reference/` would close them.
- van Heerwaarden et al. (2012): abstract level only, by report; not read by me.
- No `quarto render` run; the PDF form of the 00-D11 values is on the audit's report.
