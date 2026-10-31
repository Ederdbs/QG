# Part-level continuity review, round 2: Foundations (01, 02, 02b, 05b) + Introduction (00), index, 90-notation

Scope: book/00-hybrid-programme.qmd, 01-coancestry.qmd, 02-subdivided.qmd, 02b-response.qmd,
05b-heterosis-dominance.qmd, with index.qmd, 90-notation.qmd and the seam into
03-simulating-crosses.qmd. Paths are relative to /Users/ederdbs/Documents/SB_quanti_gen-review/.
The worktree diff against main touches 00, 05b, 90, 11 and references.bib. The round-1 fixes to
01, 02, 02b and index are already on main.

Counts: 13 findings (3 high, 5 medium, 5 low). Broken @sec- targets: 0.

## Status of round-1 findings (part-foundations.md)

| ID | Status now | Evidence |
|---|---|---|
| C1 | resolved | 01:236-243 states the flat heterozygous fraction; 03:195-220 measures it. |
| C2 | resolved | index:88-96, 02:499-516, 02:681-688 agree with 02b:199-236. |
| C3 | resolved in index/02; **contradicted in 05b** | index:97-103 and 02:647 say alpha budgets GD_T. 05b:372 (now inside Foundations) says alpha "budgets a loss of within-pool gene diversity". See new C4. |
| C4 | **regressed** | 03 now uses F_BN and p*_k throughout (03:59-75). But 90:218 (new F*_k row) writes the BN parameter as F_ST inside the appendix that defines F_ST as the statistic (90:111, 139). 05b mixes both symbols for the parameter. See new C1. |
| C5 | partly open (09, outside the part) | The meaning conflict is fixed (02b:434-440). The duplicate Kempthorne derivation is still in 09:48-56. |
| C6 | open (09, outside the part) | 09:56 still has G = [2.0, 0.9; 0.9, 0.3], which is not positive definite. |
| C7 | resolved | xi is used only in 02b:330-341 and 90:498. |
| C8 | resolved for 02b/03; **new instance in 05b** | 03 uses p*_k. 05b uses unstarred p/p_k for the ancestral frequency. See new C2. |
| C9 | resolved | 02:533-539; 90:69. |
| C10 | resolved | 01:166-171; 00:444-447 agrees. |
| C11 | resolved | 02b:464-467; 03:8-21. |
| C12 | resolved | 02b:24-33; 03:8-21 also reconciles the two generators. |
| C13 | resolved | 02:12. |
| C14 | resolved | 03:195-220: GD_T loses what GD_BS gains, deferral to @sec-heterosis stated. |
| C15 | resolved | 90:106, 02:647. |
| C16 | resolved | 90:205, 90:267, 90:417-418. |
| C17 | resolved | 02:521-526. |

## High

**C1 -- The Balding-Nichols parameter has two symbols inside 05b, and F_ST has two meanings inside 90 (C4 regression).**
- 00:471-477 introduces the parameter as F_BN and says it is not the statistic F_ST.
- 03:59-75 uses F_BN consistently.
- 05b:479-488 declares that F_ST means the parameter "in every expectation below".
- 05b itself then writes the same parameter as F_BN at 05b:1015-1024 (F_eff derivation), on both figure axes (05b:563, 1065) and in the fig-heterosis-relocation caption (05b:1061). That caption names the parameter F_BN on the axis and F_ST a sentence later ("vanish at F_ST = 1").
- 05b keeps F_ST in eq-het-bn-halves (05b:535-544), eq-het-var-bn (959-966), eq-het-gca-peak and its text (979-1001), and eq-het-sca-gca-ratio (1030).
- Meaning problem: 05b:621, 1147, 1163, 1473 and 1698-1713 ("maximises F_ST", "hold F_ST in a band", "Decide the F_ST band") describe a statistic a programme monitors. Under 05b's own convention, F_ST there means the simulation parameter.
- 90:218 (F*_k row, added this round) reads "divergence F_ST (Balding-Nichols expectation)". This is the same defect the round-1 verdict reopened at the old 90:185.

Change: 05b should write F_BN wherever it means the parameter and keep F_ST for the statistic (the protocol and "band" sentences). The convention paragraph at 05b:479-488 then becomes a one-line pointer. 90:218 should use F_BN. 90:142-145 should drop @sec-heterosis from its list of chapters that write the parameter as F_ST. Owner: 05b, then 90.

**C2 -- The definitions in 00's population-genetics section are repeated in 01 and 02, which never point back to it (00:14 says "Each is defined once").**
- Molecular coancestry as Malecot with IBD replaced by IBS (same citations): 00:367-372 and 01:149-153.
- Group coancestry, diagonal included, after @cockerham1967: 00:435-440, 01:91-94 and 02:41-46.
- s_i = (1 + F_i)/2, with F_i the molecular fraction homozygous: 00:435-438 and 00:444-450, 01:166-171, 02:101-115.
- N_s = 1/(2 theta) as a static quantity versus N_e as a rate: 00:533-536 and 02:540-543. N_s itself is also at 01:98 and in @sec-ns.
- H_o: 00:321-322 and 02:113-115.
- GD = 1 - theta = H_e: 00:309-321 (eq-hp-gd), 02:94 (eq-fii-he) and @sec-identity.
- @sec-hp-popgen has 3 inbound citations, all from 90. No Foundations chapter cites it.

Change: 00 should own the definitions, as it declares. 01 (sec-f-molecular, the theta paragraph at 01:91-98) and 02 (the callout at 02:38-47, 02:101-115, 02:533-543) should keep their derivations and cite @sec-hp-popgen for the definitions instead of restating them. Owner: 01 and 02. If the restatements stay, 00:14-16 should drop "defined once".

**C3 -- The same word, "expected heterozygosity", names two different quantities in adjacent chapters.**
- 00:309-357 and 90:65-77: "expected heterozygosity" is H_e = GD_T (the Hardy-Weinberg reference). The chunk hp-heterozygosity shows that the hybrids' mean heterozygosity, H_o, exceeds it by exactly GD_BS.
- 05b uses "expected F1 heterozygosity" for that H_o: 05b:241-242 ("Expected F1 heterozygosity is therefore GD_BI + 2 GD_BS") and 05b:299-300 (bold: "expected F1 heterozygosity is one minus between-pool coancestry"). It is "expected" over random A x B crosses, which is not 00's sense.
- 05b never uses the symbol H_o. It names the quantity variously "per-locus F1 heterozygosity" (211), "2 GD_WI_hyb" (309-311) and "1 - theta_AB".
- 00:355 cites @sec-heterosis-identity for H_o = GD_T + GD_BS.

A reader arriving from 00 reads 05b's sentence as "H_e = GD_BI + 2 GD_BS", which contradicts 00. Change: 05b should name the quantity H_o or "mean F1 heterozygosity", and tie eq-het-wi-hyb to 00's H_o once. Owner: 05b.

## Medium

**C4 -- 05b restates the round-1 C3 error: alpha "budgets a loss of within-pool gene diversity".**
- 05b:372-376 opens the "tempting argument" with that premise. The paragraph then refutes only the inbreeding-depression step and never corrects the premise.
- index:97-103 and the 02 keystone table (02:647, keystone-check 02:655-667) say alpha budgets GD_T = GD_BI + GD_BS and does not isolate the within-pool loss.

Change: 05b should state the premise in the book's terms (alpha bounds the selected hybrids' GD_T) or flag it as part of what is wrong. Owner: 05b.

**C5 -- Ancestral versus pool frequency: one symbol for two quantities in 05b, and two symbols for one quantity across the part.**
- 03:59-70 and 90:490 write the Balding-Nichols ancestral frequency as p*_k.
- 05b writes the same quantity as unstarred p (05b:523-546, eq-het-bn-total, eq-het-bn-halves, 959-966) and p_k (987-999, eq-het-gca-peak). 90:218 copies "(p_k q_k)^2".
- In the same chapter, p_k at eq-het-id (05b:338-346) is a pool's current frequency.
- 90:19-29 defines p_k as "allele frequency" of a stated set, which is closer to the eq-het-id reading.

Change: 05b should use p*_k in the Balding-Nichols sections, and 90:218 should follow. Owner: 05b.

**C6 -- 05b depends without warning on chapters that now come after it (a leftover from when 05b sat after 06).**
- 05b:281-282 defines theta_AB as "the between-pool coancestry of @sec-catalogue" and computes it with theta_pools() before that chapter is read.
- 05b:305 "@sec-catalogue reports GD_WI_hyb" is in the present tense and a derivation is built on it.
- 05b:395 "GD_WI exactly zero in @sec-catalogue's partition": the preceding chapter already shows this (02 @tbl-keystone, keystone-check), so the citation points forward when a backward one exists.
- 05b:1523-1526 says rho_k "is the least-squares accuracy rho of @sec-mating-tester", a symbol defined in the Mating part. 05b:1482 marks it as later; the sentence itself does not.
- 05b:1754-1757: "@sec-catalogue leaves a weight lambda undetermined ... This chapter can now say" presupposes that 06 has been read.
- 05b:1788-1791 "@sec-genomic-prediction ... lists specific combining ability first among what it does not model" is written as if already read; 05b:1135 marks the same link as "will".
- Elsewhere 05b marks these links correctly ("will", "later", "in the Metrics and prediction part": 05b:21-22, 44, 100, 330, 624, 1309, 1318), so the lines above are inconsistent with the chapter's own convention.

Change: 05b. Smaller instances of the same pattern:
- 00 uses @eq-x-freq (00:28), @eq-hybrid-dosage (00:72) and @eq-f-molecular (00:371) from 01 as definitions without marking them forward, while 00:581-582 says forward pointers are marked.
- 02:507 cites @eq-response-genic (02b) as established.

Owners: 00, 02.

**C7 -- The claim "GCA depends on the tester pool" is developed in three chapters, with different dominance draws and without cross-reference.**
- 00:76-144 defines eq-hp-gca-sca (the same model as 04e:160-165) and measures the claim (chunk hp-gca-tester: GCA against two halves of pool B, d ~ gamma(2, 4), seed 4, "the draw @sec-heterosis uses").
- 02b:257-309 runs heterosis_gca_sca() again with d ~ N(0.3, 0.1^2), seed 7, and says the split is "used here ahead of that derivation" (02b:263-264), ignoring that 00 has already introduced and used it.
- 05b:829-866 states the claim with no number ("Change the tester pool and every number changes", 05b:840) and does not cite 00's measurement. 05b:1512-1606 adds the tester-number scan.

Ownership: 05b owns the derivation; 00 keeps the measured demonstration; 02b should cite eq-hp-gca-sca and @sec-heterosis-gca-sca and say why its d differs from 00/05b, or use the same draw. 05b:837-840 should cite hp-gca-tester for the number. Owner: 02b (primary), 05b.

**C8 -- 90 gives the frozen base two symbols, and 00 reuses the base symbol for a different base.**
- 90:19 and 90:30 write the frozen candidate-pool base as p_{0,k} (`ctx$p0`).
- 90:191 and 90:207 write the same `ctx$p0` as p_0^{(0)}. No chapter uses p_0^{(0)}.
- 00:290 defines p_{0,k} as the frozen candidate-pool base. 00:374-383 (eq-hp-ibs-ibd, chunk hp-ibs-ibd) then uses p_{0,k} for the base of a pedigree, drawn from U(0.05, 0.95), which is not ctx$p0.

Change: 90 should drop p_0^{(0)}. 00 should either say that eq-hp-ibs-ibd's base is the IBD reference population, or give it its own symbol. Owner: 90, 00.

## Low

**C9 -- The alpha reference has two names, and the selected set's diversity two symbols.**
- 00:262-264 and 90:262 write alpha = (GD_ref - GD_S)/GD_ref.
- 06:341-345 (the owner, @sec-baseline) writes GD_random(n).
- index:97-100 and 02:647 call the selected set's quantity GD_T, while 00 and 90 call it GD_S.

Also, 00:218-265 reproduces 06's random-subset bias formula and check (06:327-339), with a greedy comparison added. It cites @sec-baseline, so this is tolerable, but it is the same example twice. Change: 06 owns the formula, and 00 or 06 should pick one name for the reference. Owner: 00 (align with 06).

**C10 -- Unflagged letter collisions inside the part.**
- k: 05b uses k for locus throughout, and for the number of testers in eq-het-rho-k (05b:1512-1527) and tbl-het-step6-testers. 90's heterosis table carries both senses in one table (d_k, F*_k at 90:189-195 versus rho_k at 90:195, 219) and has no note, unlike the sizing, backcross and sparse tables (90:355-360, 389-395, 439).
- s: s_i (self-coancestry) and s_ij (SCA) both appear in 00 (00:93 versus 00:435). 90:74 and 90:203 do not cross-note them; only the backcross note (90:389-390) distinguishes them.
- d-bar: d-bar_ij (mean distance, 02:185-192, 90:172) versus d-bar (mean dominance deviation, 05b:645-659).
- H: H_t, H_0 (heterozygosity, 00:488) versus H_i (heterosis, 05b:151, 90:199), next to t (cycle index, 90:206).

Change: notes in 90 (owner 90), and possibly a different letter for testers in 05b step 6.

**C11 -- 01's opening does not acknowledge the Introduction.**
01:8-15 still presents itself as the book's start ("derives the matrix used for the rest of the book"). 00 has already introduced IBS/IBD, f, theta_S and s_i, and points to 01 for the derivation (00:371, 432). The only link from 01 back to 00 is @sec-hp-cycle at 01:25. Change: 01's opening should say what it adds to 00 (the G-vs-f failure and the computable form). Owner: 01.

**C12 -- The index makes a stronger claim than the chapters it cites.**
index:85-87: "every plan that raises one lowers the other" (within- versus between-pool diversity). The supporting text is weaker:
- 02:354-359 covers drift only and says "Selection is not covered by this argument".
- 00:274-276 says "tends to".
- 05b:1413-1423 shows a truncation plan that moves both terms against the full set.

Change: index. Owner: index.

**C13 -- The subpopulation frequency has two symbols inside 02.**
02:43, 54, 91 and 169 write tilde-p_{k,i} (allele k, subpopulation i). 02:502-503 (the round-1 C2 fix) writes p_{ik} with the index order reversed. Change: 02.

## Cross-reference graph

Every target resolves: each `@sec-` citation has a matching `{#sec-...}`.

Inbound `@sec-` citations from other files (self-citations excluded; exact-label matching, so `@sec-heterosis` does not count `@sec-heterosis-flat`):

| Chapter | Inbound (files) |
|---|---|
| index | 0 (0) -- preface, expected |
| 00-hybrid-programme | 9 (7) -- @sec-hp-popgen only from 90; no Foundations chapter cites it (see C2) |
| 01-coancestry | 25 (14) |
| 02-subdivided | 37 (14) |
| 02b-response | 28 (14) |
| 05b-heterosis-dominance | 78 (21) |
| 03-simulating-crosses | 25 (15) |
| 04-population-sizing | 18 (10) |
| 04b-backcross-introgression | 7 (7) |
| 04c-alphasimr-pipeline | 19 (10) |
| 05-genomic-era | 35 (16) |
| 06-metric-catalogue | 40 (18) |
| 07-choosing-metrics | 45 (20) |
| 08-pipeline-stages | 37 (18) |
| 08b-genomic-prediction | 24 (14) |
| 09-optimal-contributions | 37 (16) |
| 10-combinatorial-selection | 30 (13) |
| 10b-advanced-selection | 24 (8) |
| 04e-mating-design | 57 (8) |
| 04f-sparse-testing | 36 (6) |
| 04g-joint-allocation | 11 (4) |
| 11-plant-literature | 15 (8) |
| 04d-breeding-programme | 17 (6) |
| 11b-diversity-across-cycles | 48 (20) |
| 11c-limits | 17 (9) |
| 12-case-study | 21 (15) |
| 90-notation | 11 (5) |
| 91-package | **0** (outside scope; never cited) |
| 92-verification | 5 (5) |
| 93-corpora | 2 (2) |
| 99-references | 0 (expected) |

No Foundations chapter is under-cited. 00 is cited enough overall, but its population-genetics section has no inbound citation from a chapter body.

## Promises checked

Kept:
- 00 -> @sec-mating-estimation (GCA with a_k, 04e:173-184)
- 00 -> @sec-heterosis-gca-sca (dominance part)
- 00 -> @sec-era-programme (A1, A2, A3, A5 match 05:46-90)
- 00 -> @sec-baseline (06:327)
- 00 -> @sec-identity (06:60)
- 00 -> @sec-ns (06:109)
- 00 -> @sec-era-step4 (n_gam = n for DH, 05:900)
- 00 -> @sec-stages (largest loss at S2, 08:167; S1-S4 names identical to 08:18-21)
- 05b -> @sec-era-fhom (four 60-hybrid subsets, 05:241)
- 05b -> @sec-stages Trap 1 / Trap 3 (08:53, 117)
- 05b -> @sec-catalogue lambda (06:297-317)
- 05b -> @sec-genomic-prediction SCA (08b:123-137)
- 05b -> @sec-alphasimr dominance trait (04c:258-294)
- 02b -> @sec-alphasimr replicated breeder's equation (04c:731-790)

Partly kept:
- 00:355 -> @sec-heterosis-identity: the identity is derived there under another name (C3).
