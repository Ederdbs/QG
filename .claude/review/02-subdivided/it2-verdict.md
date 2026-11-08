# 02-subdivided -- iteration 2 verdict (quant-judge)

Chapter: book/02-subdivided.qmd (1099 lines, uncommitted), worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Read in full. it1 verdict, it1 response (writer and Rwrite parts), audit, refs and continuity re-read; Caballero & Toro 2002 (reference/papers PDF) re-read at Eq. 3-8, Eq. 14-15, Tables 1, 2, 3, 5 and the "imaginary example" sentence. Toro & Caballero 2005, Wright 1969, Cockerham 1967/1969, Nei 1973, Falconer & Mackay: not in the repository, not read by me. docs/ and _freeze/ not judged (stale until close).

VERDICT: APPROVED

Counts: iteration-1 IDs closed 47 of 47 (D1-D6, M1-M8, C1-C18, R1-R9, B1-B6); reopened 0; new disqualifying 0; new non-disqualifying 3 (M9, M10, M11), of which one is an established failure (M9), one is an unverified locator (M10) and one is a paraphrase I rule inside fair reading (M11). Below the threshold of three established non-disqualifying failures.

## PREVIOUS IDS

- 02-D1 -- CLOSED -- :94-103 and :159-168 now say f is identity in state, equal to pedigree coancestry only for a base with all alleles different (C&T 2002 p. 292, "if all alleles are distinct ... f-bar = 1/2N_T", read), floor m^-1 sum(p_b^2+q_b^2) >= 1/2, pointer to @sec-f-molecular / @tbl-panel-floor (both exist in 01 and say the same); F_i = 1 - H_o stated without a base. The false "so" is gone.
- 02-D2 -- CLOSED -- the five constraints are met (see "RULING ON THE F_ST PARAGRAPH" below).
- 02-D3 -- CLOSED -- :614-620 and :998-1011 give one coherent provenance: example is the authors' imaginary one (quote checked word for word against p. 292), matrix typed from Table 2a, Table 1 genotypes not reproduced, 2002 full text compared, 2005 consulted in excerpts, unread sources listed, the -6.92/-6.94 against -6.8/-7.0 difference stated as open. Every comparison claimed is one I made in it1 and re-checked now (Table 3 col. 4 = -6.8, +6.5, -7.0, -3.6; col. 5 = -65.5, -63.3). The text does not claim "rebuilt from Table 1".
- 02-D4 -- CLOSED -- conditions declared at the keystone row (:1026: flat dominance d_k = 1, inbred parents, complete A x B factorial, "outside those conditions it is not an identity") and in the closing paragraph (:1070-1083: plus equal pool weights; "shared" defined as 2 p-bar q-bar = GD_T, divergence y^2/2 = GD_BS; neutral redraws from one ancestral frequency vector; not GD_WS; not non-flat or aligned dominance). Verified (below).
- 02-D5 -- CLOSED -- :729-745 separates the arithmetic (D_2j contains f_22/2, f_22 = 0.875) from the cause, which it declines to infer; example called imaginary at :26-30 and :614; FRBA +0.67 % scoped to Table 5 col. 3 with col. 6 (-0.0) and the authors' weighting argument.
- 02-D6 -- CLOSED -- @eq-alpha-baseline :187-212 derived by hand (checked line by line, below), stated exact for the ratio of expectations and first-order for the expectation of the ratio, with its assumptions; @tbl-mating-meter first row changed; chunk `alpha-baseline-check` checks it exactly and by simulation.
- 02-M1 -- CLOSED -- Notation :50-56 declares ratio of locus means; chunk gives 0.2836 against 0.2715 on the toy, read inline at :570-574.
- 02-M2 -- CLOSED -- Weitzman losses (Reynolds distance, -65.5 / -63.3, Table 3 col. 5) and the weighted column scoped at :716-745.
- 02-M3 -- CLOSED -- (a) literal gene-dropping oracle `ne-gene-dropping` replaces the tautology (algebra line demoted and labelled); (b), (c) scope of @eq-ne-meta stated at :841-859 (F_IT versus F_IS = 0, migration, asymptote, closed pools, inbred/DH pools).
- 02-M4 -- CLOSED -- theta_S throughout; the N_s paragraph :819-833 warns that [1/2, 1] is a biallelic property and that N_s = 1.54 in the multiallelic example; neither is a head count.
- 02-M5 -- CLOSED -- keystone row 2 reworded: drift argument, selection not separated, "the one" removed.
- 02-M6 -- CLOSED -- assertions present and true: rounded c identical to (0.522, 0, 0.270, 0.208), c_2 == 0, delta_pct signs for both columns, F_ST < 0.2, which.max(diag(f)) == 2, mean(molecular_coancestry) == f_bar (all pass in my run).
- 02-M7 -- CLOSED -- toro2005 section locators moved to 5a, Eq. 14 added, the 2N/(2N-1) factor derived, three bullets marked as the book's reading, allelic diversity cited to C&T p. 297. Falconer chapter locators: see M10.
- 02-M8 -- CLOSED -- each sub-item re-read (see C-IDs). One piece stays (genic-variance derivation kept in 02): carried as M9.
- 02-C1 -- CLOSED (02 side) -- = D1. Owed to 90 (90:179 still says "against a base with all alleles distinct"); chapter 02 is true without it.
- 02-C2 -- CLOSED (02 side) -- = D2. Owed to 08 (Trap 2, 08:86-106), 90, 00; 02 does not use any 08 label and cites only @sec-hp-inbreeding for the existence of the second statistic. True without them.
- 02-C3 -- CLOSED -- opening :8-24 follows 01, cites 00 and the second departure; alpha defined at first use by @eq-catalogue-alpha.
- 02-C4 -- CLOSED (02 side) -- theta_S in 02. Bare theta at index:101, 90:569, 90:627 owed elsewhere.
- 02-C5 -- CLOSED -- = M4.
- 02-C6 -- CLOSED -- :1030-1043 states individuals = line slots, subpopulations = pools, usage weights equal across pools, GD_WI against GD_WI-hyb; the Rwrite correction is right (see below).
- 02-C7 -- CLOSED -- Notation :57-63.
- 02-C8 -- CLOSED -- k declared at :64-67 and at the OCS bullet.
- 02-C9 -- CLOSED (02 side) -- = M5. Owed to 11b and 90:118.
- 02-C10 -- CLOSED -- = D4.
- 02-C11 -- CLOSED -- = M3(b),(c).
- 02-C12 -- CLOSED -- = D3.
- 02-C13 -- CLOSED -- f_AA/f_BB/f_AB = theta_A/theta_B/theta_AB at :598-601.
- 02-C14 -- CLOSED (02 side) -- tilde, bar, D-bar, I/S/T declared. Owed to 90 (rows for F_IS, F_IT, D-bar).
- 02-C15 -- CLOSED -- :798-799.
- 02-C16 -- CLOSED -- @eq-hp-gd / @sec-identity cited at :77-78; derivation retained, ownership stated at :795 (carried as M9).
- 02-C17 -- CLOSED -- @tbl-hp-stages cited with S1 at :1066.
- 02-C18 -- CLOSED -- c, f change object, :804-807.
- 02-R1 -- CLOSED -- = D3.
- 02-R2 -- CLOSED -- = D2.
- 02-R3 -- CLOSED -- = D4, M5; the GD_WS (twice) and GD_T (unit for unit) accountings are separated at :1079-1081.
- 02-R4 -- CLOSED -- = M6.
- 02-R5 -- CLOSED -- = M3(a); the oracle holds (below).
- 02-R6 -- CLOSED -- = C3, C4.
- 02-R7 -- CLOSED (Info) -- typed external values labelled "quoted from the tables, not recomputed" with table and column.
- 02-R8 -- CLOSED -- `tol <- 1e-12` on every exact identity of `ct-identities`; negative control kept at the default tolerance, on purpose, commented.
- 02-R9 -- CLOSED as OUT OF SCOPE (typst-style / quant-editor); not a content failure of this chapter.
- 02-B1 -- CLOSED -- §5a, Eq. 14 of C&T 2002 added. Section locator rests on refcheck's PMC route (not re-read by me).
- 02-B2 -- CLOSED -- = D3.
- 02-B3 -- CLOSED -- derived: E[1 - f_ii] = H (2N-1)/(2N) (checked: ratio of expectations in @eq-alpha-baseline uses it and the enumeration confirms it).
- 02-B4 -- CLOSED -- bullets marked as the book's reading (:578-583).
- 02-B5 -- CLOSED -- C&T 2002 p. 297 cited for allelic diversity and bottlenecks.
- 02-B6 -- CLOSED -- wright1951 absent from 02 (grep: no occurrence); Wright (1969) and Cockerham (1969) reported as attributions made by C&T 2002 Eq. 6 and Toro & Caballero 2005 §3a, with "the original papers were not read for it" (:357-361).

## DISQUALIFYING FAILURES

None.

## RULING ON THE F_ST PARAGRAPH AND @eq-f-stats-het (the five constraints of it1)

1. F_ST kept as its formula and as GD_BS/GD_T, plus its heterozygosity form (@eq-f-stats-het, :363-372): (H_T - H_S)/H_T, F_IS = 1 - H_o/H_S, F_IT = 1 - H_o/H_T, plug-in H, locus-averaged numerator and denominator. SATISFIED. I derived it: 1 - f-bar = H_T (census-pooled frequencies), 1 - f-tilde = H_S, F-tilde = 1 - H_o; F_IS = (F-tilde - f-tilde)/(1 - f-tilde) = 1 - H_o/H_S. The chunk asserts all five at 1e-12 and passes.
2. The other statistic written F_ST is named, its value on the same data is given, and the one-locus ratio is correct (:408-427). SATISFIED. Hand algebra: with p-bar = (pA+pB)/2, dp = pA - pB, H_S = 2 p-bar q-bar - dp^2/2, H_T = 2 p-bar q-bar, H_AB = pA qB + pB qA = 2 p-bar q-bar + dp^2/2; this = dp^2/(4 p-bar q-bar); between = dp^2/(2 p-bar q-bar + dp^2/2); ratio = 4 p-bar q-bar/(2 p-bar q-bar + dp^2/2). Range: 4 p-bar q-bar - dp^2 = 2[pA(1-pA) + pB(1-pB)] >= 0, so ratio >= 1, and <= 2 because dp^2 >= 0, with limit 2 as dp -> 0; (0.2, 0.6) gives 1/6 and 2/7. Independent check (my own script, not the chapter's): 5000 loci, three draws, locus-averaged ratio 1.664, 1.674, 1.670 (inside [1,2]) and "this" equal to (H_T - H_S)/H_T to 4 dp. Book's 30 hybrids (seed 7): this 0.1262791, between 0.2242413, ratio 1.7757587 (chapter prints 0.126 / 0.224 / 1.78). The chapter says it is one draw. It also states that it cites no external source for the second usage, which is honest; the claim "is also written F_ST" is scoped by the pointer to @sec-hp-inbreeding, whose text (00:575-581) says the book logs both under that name, and I confirmed that text.
3. wright1951 withdrawn, attributions limited. SATISFIED. Eq. 6 of C&T 2002 reads "Wright's (1969) F-statistics are obtained as ..." (p. 291), and the reference list gives Wright 1969, Evolution and the Genetics of Populations, Vol. 2; the chapter reports exactly that, plus the Cockerham 1969 credit as attributed by Toro & Caballero 2005 §3a (refcheck: full text via PMC fragments), and says the originals were not read.
4. No Nei G_ST, no nei1973 for it. SATISFIED. nei1973 appears only for gene diversity 1 - sum p^2 (:74, :1010); C&T 2002 itself credits Nei (1973) with that definition in its Discussion.
5. No 08 label or 08 section depended on. SATISFIED. "G_ST" does not occur; the only cross-reference is @sec-hp-inbreeding.

## RULINGS ON CONTESTED AND OPEN ITEMS

- 02-R9 (typst-style): out of scope; closed here, left to quant-editor.
- Falconer & Mackay "ch. 4": the prose no longer carries a locator (ch. 8 removed); "ch. 4" survives only in the code comment of chunk `ne-equal-seed` (:863), hence also in the downloadable script. I cannot confirm it (book not available). Non-decisive: the N_e = 4N/(2+V_k) claim is independently checked by the gene-dropping oracle. Recorded as M10, not a rejection.
- Toro & Caballero 2005 locators (§2, §3a, §3d, §3e, §5a, Table 4 footnote a): rest on refcheck's PMC full-text fragments. Accepted as supported by a secondary reading; none carries a claim I could not check against C&T 2002 (Eq. 14, Table 5), except the Cockerham credit, which the chapter reports as an attribution by that review. Non-decisive.

## NON-DISQUALIFYING OBSERVATIONS

- 02-M9 (Low) book/02-subdivided.qmd:781-799 -- the genic-variance derivation for the mixture base is kept in 02 while the same bullet says it belongs to @sec-response. Redundancy with 02b; no false statement. This is the only established non-disqualifying failure.
- 02-M10 (Low, unverified) :863 -- "Falconer & Mackay, ch. 4" in a code comment (and the shipped script), and :937 attributes "N_e = 4N/(2 + V_k)" to @falconer1996 without locator. My recollection is that the Falconer & Mackay expression is (4N - 2)/(V_k + 2), the large-N form being 4N/(V_k + 2); that is memory, not a check. At N = 100 the difference is 0.5 %, below the oracle's resolution (s.e. 1.6-2.5 %). Not a failure I can establish.
- 02-M11 (Info) :743 -- "the authors argue that weighting by size is desirable"; C&T 2002 p. 295 say a weighting "might be desirable" and call the unweighted conclusion "dubious". Inside fair paraphrase; recorded so the wording is not strengthened further.

Established non-disqualifying failures: 1. Threshold (three) not reached.

## WHAT WAS VERIFIED

- Whole chapter: R CMD INSTALL of the worktree into a scratch library, knitr::purl of the chapter, sourced from book/: every stopifnot passes, 4.1 s. No book/Rplots.pdf exists in the worktree.
- @eq-alpha-baseline by hand: E[F_i] = sum p^2; E[f_ii] = sum p^2 + (1 - sum p^2)/(2N); E[F - f] = -(1 - sum p^2)/(2N); E[1 - f] = (1 - sum p^2)(2N-1)/(2N); ratio -1/(2N-1) per locus and therefore for the locus-averaged ratio; G = (N-1)/(2N-1); -1/7 (N=4), -1/23 (N=12). The paper's own G_i = (1 + alpha_i)/2 relation ("(1 - alpha_i) = 2(1 - G_i)", p. 290) agrees.
- `alpha-baseline-check`, exact part: enumeration over all genotype counts, N = 4, 12, 50, p in {0.05, 0.2, 0.5, 0.7, 0.95}: max deviation from -1/(2N-1) and (N-1)/(2N-1) = 4.05e-15 (asserted < 1e-12). Simulation part (seed 5, 60 samples, 3000 loci, through ct_partition): mean alpha_i = -0.14215, -0.04327, -0.01046 against -0.14286, -0.04348, -0.01010; mean G_i = 0.42893, 0.47836, 0.49477 against 0.42857, 0.47826, 0.49495; z = 0.61, 0.28, -1.04 (asserted |z| < 4). The replicate is the random-mating sample (independent), the s.e. is over the 60. At N = 50 the baseline is separated from 0.5 by about 30 s.e. (0.5 - 0.4948 = 0.0052, s.e. about 0.00017).
- D4 conditions: Balding-Nichols Monte Carlo (own script, seed 99, p0 = 0.3, 2e6 draws): F_BN = 0.05 / 0.20 / 0.40: E[pA + pB - 2 pA pB] = 0.41999 / 0.42014 / 0.42013 = GD_T + GD_BS to 5 dp, against 2 p0 q0 = 0.42; changes in GD_T -0.01051 / -0.04190 / -0.08403, GD_BS +0.01049 / +0.04204 / +0.08416, GD_WS -0.02100 / -0.08393 / -0.16819. So GD_BS gained is paid unit for unit by GD_T and GD_WS falls by twice what GD_BS gains, as :1070-1083 and :598-608 state. Algebra by hand: with equal pool weights and inbred parents, mean F1 heterozygosity = pA qB + pB qA = 1 - f_AB and GD_T + GD_BS = 1 + f-tilde - 2 f-bar = 1 - f_AB (f-bar = (f-tilde + f_AB)/2). Matches 05b:205-235 (@eq-het-split, y = pA - pB).
- Rwrite correction "census and usage weights coincide" is false and its replacement (:1030-1043) is true: `keystone-check` asserts unequal line usage in the 30-hybrid sample, identical(idx_h, idx_f), 1 - theta_S == GD_T, GD_T == GD_BI + GD_BS and GD_WI_hyb == H_hyb/2 at 1e-12; all pass. The drift-paragraph clause "equal when the usage weights equal the census weights" (:600) is a conditional and is true as written.
- `ne-gene-dropping` (seeds 101-103 set before each scheme, N = 100, L = 500, T = 25, R = 30 pedigrees): N_e = 98.19 (s.e. 1.57), 133.90 (1.70), 199.03 (2.54) against 100, 133.33, 200; z = -1.13, 0.33, -0.38; ne_gain = 1.3333, 2. The unit of replication is the pedigree and the s.e. is over pedigrees. Tolerance 3 s.e. is not a thin pass: my own 40 further seed sets (seeds 10000-49000, same code): mean z = -0.03, -0.18, -0.28, sd 0.89, 0.98, 0.98, no |z| > 3, |z| > 2 in 2, 3, 3 of 40; in a separate set of six, one both_once draw reached z = -3.23, a 1-in-18 event consistent with chance given the 40-set record. The chunk claims the n = 1, F_IS = 0 case "and nothing more", which is the scope the oracle supports.
- Worked example and tables: ct_glob computed against published to 4 dp; census delta_pct (-6.65, +1.84, -3.91, -0.81), equal (-6.92, +6.47, -6.94, -3.56); c = (0.522398, 0, 0.269890, 0.207711); N_s = 1/(2 f-bar) = 1.54 for 30 individuals; F_ST 0.1897 < 0.2; mean of f entries equals f_bar. Paper's Table 3 col. 3 (-6.6, +1.8, -3.9, -0.8) agrees with the census column; col. 4 (-6.8, +6.5, -7.0, -3.6) differs from the equal column at subpopulations 1 and 3, as the chapter says.
- `fst-two-forms`, `ct-identities` (@eq-f-stats-het at 1e-12; ratio of means 0.2836 against mean of ratios 0.2715), `keystone-check`, `fl-ranges` (0.6075-0.6635 between, 0.668-0.719 within): run and match the inline values.
- C&T 2002 re-read: Eq. 3-4, 6, 7, 8, 14, 15 (Eq. 14 has (1 - F_IT); Eq. 15 and its S_W, S_B form), Table 1-2 (F-tilde 0.4111, f-tilde 0.4535, s-tilde 0.7056, D-bar 0.1279, f-bar 0.3256, F_IS -0.0775, F_ST 0.1897, F_IT 0.1268, GD terms), Table 3, Table 5 (FRBA +0.67 in col. 3, -0.0 in col. 6, Weitzman -15.2), "any constant degree of migration", the "imaginary example" quotation.
- Cross-references of the changed text exist in source: sec-hp-inbreeding, sec-hp-popgen, sec-hp-ibd, sec-hp-not-animal, eq-hp-gd, tbl-hp-stages (00), sec-f-molecular, tbl-panel-floor (01), eq-het-split, tbl-het-partition-identity, sec-heterosis-flat, sec-heterosis-alignment (05b), eq-catalogue-alpha, sec-identity, sec-catalogue (06), sec-cycles (11b), sec-limits (11c), sec-response, eq-response-genic (02b). Quarto resolution not tested (render deferred).
- Downloadable script book/downloads/02-subdivided.R contains the three new chunks (grep count 4 over the labels).

## OWED ROWS (check that each names its chapter and that 02 is true today without it)

- -> 08 (Trap 2, 08:86-106): adopt 02's name for GD_BS/GD_T or state the rename; attach no unverified Wright label. Named. 02 is true without it: it neither uses nor cites 08's labels.
- -> 90: 90:179 "against a base with all alleles distinct" (contradicts 02:159-165 and 01); 90:118 "the term recurrent selection erodes (@tbl-keystone)" (the table now says drift, selection not separated); rows for F_IS, F_IT, D-bar and the second F_ST-named statistic; bare theta at 90:569, 90:627, index:101. Named. 02 true without it.
- -> 11b: no GD_BI column, no arm without selection. Named; 02 now claims only that within-pool diversity falls in the simulated cycles with drift and selection together. True without it.
- -> 00 re-read: 00:575-581 describes 08's G_ST naming; re-read when 08 changes. Named. 02 points to that passage only for the fact that two statistics exist and differ; that fact is true in 00 today.
- -> 05 wright1951: NOT written in it1-response as a row of its own (only mentioned inside B6, "still cited by 05-genomic-era.qmd"). 05:360-364 attributes the standardised-variance form of F_ST to "the form @wright1951 introduced" and calls the book's F_ST column the Nei G_ST of gd_partition(), the opposite naming to 02 and 00. It must be recorded in THREAD at close as a row owed to 05 (with the bib entry's 1949 DOI against year 1951, 00-B13). 02 is true without it: it no longer cites wright1951.

## NOT VERIFIED

- Attributions to Wright (1969), Cockerham (1969), Cockerham (1967), Nei (1973) beyond its abstract, Lindgren et al. (1997), Falconer & Mackay (any chapter), Meuwissen et al. (1997) beyond its abstract: sources absent. None is decisive: the chapter reports each as attributed by C&T 2002 (read) or by Toro & Caballero 2005 (PMC fragments via refcheck), says the originals were not read, and no number depends on them. Gene diversity as Nei's definition is also stated in C&T 2002's Discussion (read).
- Toro & Caballero 2005 section and table locators: refcheck's PMC route, not re-read. Non-decisive.
- Falconer & Mackay "ch. 4" and the exact form of the variance-of-family-size formula: M10. Non-decisive.
- Rendered HTML / Typst production of the new chunks and inline values (fmt_sci output, quarto cross-reference resolution): render deferred to batch end.
