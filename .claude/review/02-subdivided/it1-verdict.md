# 02-subdivided -- iteration 1 verdict (quant-judge)

Chapter: book/02-subdivided.qmd (695 lines), worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05.
Read in full by me; audit (R), refs (B), continuity (C) and THREAD (entries 00, 01) read. Source: Caballero & Toro 2002 PDF (reference/papers) read for Eq. 6, Eq. 14-15, Tables 1-5. Toro & Caballero 2005, Wright 1951/1969, Cockerham 1969, Nei 1973, Falconer & Mackay: not in the repo, not read by me.

VERDICT: REJECTED

Counts: disqualifying 6 (High 2, Medium 4); non-disqualifying 8 (Medium 5, Low 3). Eight non-disqualifying observations exceed the three that reject on accumulation by themselves.

## DISPOSITION OF EVERY R, B AND C FINDING

IDs kept. "Subsumed" means the finding is accepted and carried by the D or M named.

| ID | Their severity | Disposition |
|---|---|---|
| 02-C1 | H | ACCEPTED, disqualifying. -> 02-D1 |
| 02-C2 | H | ACCEPTED, disqualifying; the 02 side is 02-D2, the 08 side is outside this chapter. |
| 02-C3 | M | ACCEPTED -> 02-M8 |
| 02-C4 | M | ACCEPTED -> 02-M4 |
| 02-C5 | M | ACCEPTED -> 02-M4 (kept non-disqualifying: 02 never reads N_s as a head count; see M4 for why it is on the edge) |
| 02-C6 | M | ACCEPTED -> 02-M8 |
| 02-C7 | M | ACCEPTED -> 02-M8 |
| 02-C8 | M | ACCEPTED -> 02-M8 |
| 02-C9 | M | ACCEPTED -> 02-M5 |
| 02-C10 | M | RAISED to disqualifying -> 02-D4 (assumption used and not declared, criterion 2) |
| 02-C11 | M | ACCEPTED -> 02-M3 |
| 02-C12 | M | RAISED to disqualifying -> 02-D3 (with 02-R1 and 02-B2) |
| 02-C13 | L | ACCEPTED -> 02-M8 |
| 02-C14 | L | ACCEPTED -> 02-M8 |
| 02-C15 | L | ACCEPTED -> 02-M8 |
| 02-C16 | L | ACCEPTED -> 02-M8 |
| 02-C17 | L | ACCEPTED -> 02-M8 |
| 02-C18 | L | ACCEPTED -> 02-M8 |
| 02-R1 | M | ACCEPTED, RAISED -> 02-D3 |
| 02-R2 | M | ACCEPTED, RAISED -> 02-D2 |
| 02-R3 | M | ACCEPTED IN PART -> 02-M5. The audit's reading ("two units of within-pool diversity lost per unit of GD_BS gained, not unit for unit") is correct for GD_WS but is not the clash it claims. See WHAT WAS VERIFIED: under flat dominance 05b's "shared" term is exactly GD_T, and the GD_BS gain is paid unit for unit by GD_T. 02:676-679 is therefore arithmetically right; what fails is that 02 never says "shared term = GD_T" and omits the conditions (02-D4, 02-M5). |
| 02-R4 | L | ACCEPTED (a), (b) -> 02-M6; (c), (d) stay Info. |
| 02-R5 | L | ACCEPTED -> 02-M3; the N_e numbers themselves are right (my own gene-dropping run). |
| 02-R6 | L | ACCEPTED (= C3, C4) -> 02-M8, 02-M4 |
| 02-R7 | Info | ACCEPTED; UNVERIFIED values listed under NOT VERIFIED. |
| 02-R8 | Info | ACCEPTED |
| 02-R9 | Info | ACCEPTED (out of scope: form / typst-style). |
| 02-B1 | MEDIUM | ACCEPTED (rests on PMC fragments, not re-read by me) -> 02-M7 |
| 02-B2 | LOW/MEDIUM | RAISED -> 02-D3 |
| 02-B3 | LOW | ACCEPTED -> 02-M7 |
| 02-B4 | LOW | ACCEPTED -> 02-M7 |
| 02-B5 | LOW | ACCEPTED -> 02-M7 |
| 02-B6 | LOW | ACCEPTED; the wright1951 line is decisive for 02-D2 and is therefore a blocker, not a low item. |

## DISQUALIFYING FAILURES

- 02-D1 [criteria 1, 5; High] 02-subdivided.qmd:61-64 and :119-121 (same phrase at 90-notation.qmd:179) -- subsumes 02-C1. The chapter states the reference of the molecular scale: "the reference is a base in which all alleles are distinct, so f_ij between unrelated lines is already high on a biallelic panel" (:61-63) and "F_i ... measured against a hypothetical base in which all alleles are distinct" (:120). The "so" does not follow: on a base of all-distinct alleles unrelated pairs would sit at 0 (Caballero & Toro 2002 p. 291, below Eq. 7: with all alleles distinct f-bar = 1/2N_T). What makes f_ij high is the opposite condition: Caballero & Toro 2002 p. 292 state that molecular and pedigree coancestry agree only if the base has all alleles different, which biallelic markers cannot satisfy, and chapter 01 (01:238-256, @tbl-panel-floor) derives the consequence: the expected level for unrelated pairs is the base-population floor m^-1 sum(p_b^2+q_b^2) >= 1/2, a property of the panel. 02 names the mechanism that 01 rules out, names neither the floor nor @tbl-panel-floor, which is the direct evidence for its own sentence (:84-87), and at :120 describes F_i = 2 s_i - 1 = 1 - H_o (eq. at :104, which is the observed homozygous fraction and has no base) as a quantity relative to a pedigree base. The conclusion (no threshold carried across panels) is right; the stated reason contradicts 01. A reader of 02 leaves with the pedigree reading of f that 01 spent a section removing. Criterion 1 (what the quantity is) and criterion 5 (definition differs between chapters).

- 02-D2 [criteria 5, 7, 1; High at book level, Medium for this chapter's own text] 02-subdivided.qmd:218-225 and :255-258 -- subsumes 02-C2, 02-R2, the wright1951 line of 02-B6. The chapter calls F_ST = (f-tilde - f-bar)/(1 - f-bar) "Wright's fixation indices [@wright1951]". Three defects:
  (i) What it computes. With the plug-in H of :43-44, 1 - f-bar = H_T and 1 - f-tilde = H_S, so this F_ST is (H_T - H_S)/H_T (and F_IS = 1 - H_o/H_S, F_IT = 1 - H_o/H_T), with numerator and denominator averaged over loci separately. That is the Nei G_ST form. It is a different statistic from (theta_w - theta_B)/(1 - theta_B), which is referenced to between-population coancestry and also circulates under the name F_ST (and is what 08-pipeline-stages.qmd:86-95 calls F_ST^(W)). I ran both on the same data: 30 random hybrids of the book's simulated pools, seed 7, gd_partition()$F_ST = 0.126279 = (theta_w - theta_T)/(1 - theta_T), while (theta_w - theta_AB)/(1 - theta_AB) = 0.224241 (ratio 1.78). At one biallelic locus (p = 0.2, 0.6): var(p)/(pbar qbar) = 0.1667 = (H_T - H_S)/H_T, the between-referenced form = 0.2857. The chapter that defines GD_BS/GD_T as F_ST (and on which 00, 05b and 90 lean) does not tell the reader that the name is shared by two numbers that differ by ~2x. 00:575-581 does say so from its side; 02 does not.
  (ii) Attribution. The only verified source is Caballero & Toro 2002 Eq. 6 (p. 291), which writes exactly these formulas and credits "Wright's (1969) F-statistics" (Evolution and the Genetics of Populations, vol. 2). 02 cites wright1951 (Ann. Eugen. 15:323-354), not the work the source credits; I could not confirm that this paper contains the coancestry form, and neither did refcheck. The sentence is therefore a decisive attribution that is UNVERIFIED (criterion 7).
  (iii) The statement is true or false depending on the reader's convention, and the book carries two. A name that denotes two statistics in different chapters is a renamed metric (criterion 5).
  The chapter's own algebra (identities :255-258, the chunk at :304-319) is correct; the failure is the name, the unscoped claim and the citation. See "RULING ON 02-C2" below for what is required and which chapter owns what.

- 02-D3 [criteria 5, 3 (provenance), 6; Medium] 02-subdivided.qmd:363-365 against :630-633 -- subsumes 02-R1, 02-B2, 02-C12. Line 363-365: the coancestry matrix is "transcribed from the paper" (@caballero2002). Lines 630-633: "Only the 2005 review was accessible when this chapter was checked; values attributed to the 2002 paper ... (the worked example's matrix, s-tilde and contributions) are transcribed from it [the 2005 review] and were not re-checked against its full text." These cannot both hold, and the second is false as of this review: the 2002 PDF is in reference/papers/ and was read by continuity, by refcheck and by me. I rebuilt the whole matrix from the 36+12+24+18 genotypes printed in Table 1 of the 2002 paper: all ten distinct entries agree with the chapter's matrix to four decimals, f-bar = 0.32556, f-tilde = 0.45347, s-tilde = 0.70556 (published 0.3256, 0.4535, 0.7056). So the numbers are right, but the chapter's statement of what was checked is wrong in the direction of understating the checks, and it contradicts line 363 about where the data come from. For a worked example that carries the chapter's headline claim, "which text was the source and was it compared" is the provenance statement, and it is incoherent. Also, the chapter nowhere tells the reader that the 2002 example is declared imaginary by its authors ("an imaginary example based on allele frequencies of neutral genetic markers that could resemble allozyme data", p. 292), see D5.

- 02-D4 [criterion 2; Medium] 02-subdivided.qmd:648 (@tbl-keystone row 3) and :676-679 -- subsumes 02-C10, part of 02-R3. "GD_BS ... the heterosis engine, to be preserved not minimised -- derived as an exact identity in @sec-heterosis" and "under neutral drift every unit of GD_BS gained is paid for out of the shared term, so pushing the pools apart buys nothing". The identity in 05b (@eq-het-split, @tbl-het-partition-identity, 05b:215-235) is: heterosis per locus = GD_T + GD_BS exactly, when dominance is flat (d_k = 1), the parents are inbred lines, the A x B factorial is complete, the pools have equal weight, and (for the neutral-drift statement) in expectation over Balding-Nichols draws. None of these conditions is stated in 02, and "shared term" is not defined in 02 (it is 05b's name for GD_T). The row and the closing paragraph are the unconditional form of a conditional result. The keystone table is what the rest of the book "refers back to" (:640-642), so the omission propagates. I checked the arithmetic and it is correct under those conditions (WHAT WAS VERIFIED); the failure is the undeclared assumption, not the maths.

- 02-D5 [criteria 4, 3, 6; Medium] 02-subdivided.qmd:462-463 (and :16-20, :363-364) -- not raised by R, B or C. "It is distant because it is fixed. Alleles fixed in a sample of four individuals are not a genetic resource; they are the result of drift." The first sentence is arithmetic (D_2j contains f_22/2 with f_22 = 0.875). The second is a causal and a normative claim about a data set that its authors call imaginary; nothing in the chapter or in the source says why the four plants are fixed, and the chapter's own caveats contradict the normative half ("A fixed accession may carry the only resistance allele", :605-607; the callout at :469-477 says it does not mean discard it). Result (removal raises GD_T by 1.84 % / 6.47 %) and interpretation (drift, not a resource) are not separated, and the cause is inferred from a deterministic toy matrix. The chapter should not present the origin of the fixation as known.

- 02-D6 [criterion 1; Medium] 02-subdivided.qmd:134-139, :141-143, :145-157 (@tbl-mating-meter), :159-162 -- not raised by R, B or C. The chapter declares at :43-44 that its diversities are the plug-in form without the 2N_i/(2N_i - 1) correction, then reads alpha_i and G_i as if the plug-in baseline under random mating were alpha_i = 0 and G_i = 0.5: "negative means an excess of heterozygotes", "G_i ~ 0.5 perfect panmixia". With f_ii including self-pairs, E[alpha_i] = -1/(2N_i - 1) under exact random mating, so a negative alpha_i is the null for the small N_i that are this chapter's subject (genebank accessions of 4 to 12 plants; the worked example has N = 12, 4, 8, 6). I checked it: ct_partition() on random-mating samples from HWE, 3000 loci, 60 replicates, seed 5: mean alpha_i = -0.1404 (N = 4; -1/7 = -0.1429), -0.0436 (N = 12; -0.0435), -0.0104 (N = 50; -0.0101); mean G_i = 0.430, 0.478, 0.495. The "He with its small-sample correction" confusion the standard names is therefore carried from the declaration (:44) into the interpretation without the consequence. The sampling-design advice at :159-162 ("a few plants already capture half") uses the same meter.

## RULING ON 02-C2 (F_ST versus G_ST, owner 08)

Facts fixed by my runs (see WHAT WAS VERIFIED): 02's F_ST = GD_BS/GD_T = (H_T - H_S)/H_T; 08's F_ST^(W) = (theta_w - theta_B)/(1 - theta_B) is a different quantity; neither is the Balding-Nichols F_BN. The historical labelling (which of Wright 1951/1969, Cockerham 1969, Nei 1973 "owns" which formula) is UNVERIFIED by me and cannot be settled from the repository.

What chapter 02 must say today for the text to be true whatever 08 does (content constraints, not wording):
1. Keep F_ST defined by its formula and by GD_BS/GD_T, and say what that formula equals in heterozygosity terms, (H_T - H_S)/H_T with plug-in H and locus-averaged numerator and denominator.
2. Say that the symbol F_ST is also used in the literature for a statistic referenced to between-population coancestry, which takes a different value on the same data (give the order of magnitude, ~2x in the book's pools), so that the reader cannot take 02's F_ST for that one. 02 may not say how 08 names either of the two, because 08 is not yet corrected.
3. Withdraw the unconditional "These are Wright's fixation indices" and the wright1951 citation unless the 1951 paper is checked. What is verified is: Caballero & Toro 2002 Eq. 6 write these formulas and credit Wright (1969); Toro & Caballero 2005 §3a (as read by refcheck through PMC fragments) credit the D-bar form to Cockerham (1969). Attributions can be limited to what those sources say.
4. Not assert "equals Nei's G_ST" with a citation to nei1973 unless it is checked: refcheck saw only the abstract of Nei 1973 and I could not confirm the G_ST definition there. The algebraic statement (H_T - H_S)/H_T needs no citation.
5. Not depend on any 08 label (G_ST, F_ST^(W)); a cross-reference is acceptable only to a place that states the comparison without relying on 08's naming (00:575-581 is such a place today).

Who fixes what:
- 02 (this chapter): items 1-5 above. This is sufficient to make 02 correct independently of 08; 02 does not have to wait for 08.
- 08 (pipeline-stages, Trap 2, 08:86-106): owns the larger part. It attaches "Wright" to (theta_w - theta_B)/(1 - theta_B) and renames 02's statistic G_ST, so the same number appears under two names in the book and "Wright" is attached to two formulas. 08 must either adopt 02's name for GD_BS/GD_T or state that it is renaming it, and must not attach a historical label it has not verified. I did not review 08's claims ("G_ST < F_ST always", the sweep), which are 08's.
- 00 (00:575-581): correct today; it describes 08's labels as 08 stands, so it must be re-read when 08 changes.
- 90-notation: no row for G_ST or for the second statistic; owed from 00 (THREAD). Not a gate for 02.
- Approval of 02 does not require 08's fix once item 1-5 are done; the book-level contradiction closes only when 08 is approved.

## NON-DISQUALIFYING OBSERVATIONS

- 02-M1 [Medium] 02-subdivided.qmd:35, :218-220, :255-258 -- own finding. The Notation states "Everything is computed per locus and then averaged over loci." F_ST, F_IS, F_IT, G, alpha_i and G_i are ratios, and the identities of @eq-ratio-identities (GD_BS/GD_T = F_ST, etc.) hold only when numerator and denominator are averaged over loci separately (ratio of means), not when the per-locus ratios are averaged. Not declared. Measured (1000 loci, two pools, seed 2): ratio of means 0.043205 = GD_BS/GD_T; mean of per-locus ratios 0.041508. The convention matters for how this F_ST relates to estimators of F_ST in the literature (D2).

- 02-M2 [Medium] 02-subdivided.qmd:454-467, :625-628 -- own finding (touches 02-B2). (a) The 0.67 % for FRBA is the equal-weights column of the 2002 Table 5 (and 2005 Table 4); the same paper argues that weighting by effective size is desirable and in its column 6, which weights by breed effective size, FRBA is "-0.0" (p. 295). The chapter quotes the one number that fits "the same pattern appears" without the weighting scheme and without the column that does not. (b) The chapter ranks by the mean Nei distance to the pool (last column of @tbl-ct-loss) and asserts that the Weitzman approach "ranks it first"; the Weitzman losses are not reproduced or cited (2002 Table 3, column 5: -65.5 for subpopulation 2, -63.3 for subpopulation 3, close to tied). The result is true as stated in the source; the scope is not.

- 02-M3 [Medium] 02-subdivided.qmd:545-594 -- accepts 02-R5, 02-C11. (a) The chunk ne-equal-seed (:559-568) checks an algebraic substitution (4N/(2+V_k) = 2N/(V_W+1) at V_W = V_k/2) and cannot fail; it is not evidence for 4/3 and 2. (The claims are nevertheless right: my gene-dropping run, N = 100 monoecious, 2000 unlinked biallelic loci at p = 0.5, 20 generations, 6 independent pedigrees per scheme, seed 11, slope of log H_t: N_e = 97.8 +/- 2.4 (random), 132.6 +/- 2.9 (mothers once, father random; 4N/3 = 133.3), 199 +/- 2 (both once; 2N = 200).) (b) :556-557 "double" compares two N_e at the same F_ST; the F_ST in Eq. 14 is the asymptotic one and itself depends on the contribution variances and on migration; the source models "any constant degree of migration" (2002 p. 295-296) and the chapter lists neither migration nor F_ST-held-fixed among its assumptions, while its own drift paragraph (:354-359) uses closed pools, for which F_ST tends to 1 and the formula has no meaning. (c) The formula's (1 - F_ST) is the F_IS = 0 case of Eq. 14's (1 - F_IT); the book's pools are inbred lines (G_i -> 1, :160-162) and doubled-haploid collections for which 00:616-640 shows a factor of two in the sampling unit; :344-347 gives no guidance for them. Scope is not wrong in-chapter (random mating is stated), but the chapter does not say it does not apply to the pools this book works with.

- 02-M4 [Medium] 02-subdivided.qmd:533-539, :647, :650, :660 -- accepts 02-C4, 02-C5. Bare theta for the group coancestry (01 and 90 write theta_S). "This N_s is then the 1/(2 theta) of that chapter" imports the scale of 01 (on molecular f at biallelic loci theta_S and N_s lie in [1/2, 1], not a head count) into a chapter whose own example is multiallelic and gives N_s = 1/(2 x 0.32557) = 1.536 for 30 individuals; the chapter does not warn that N_s on molecular f is not a count. It is not read as a head count in the text, which is why it stays non-disqualifying; it would reject if it were.

- 02-M5 [Medium] 02-subdivided.qmd:647, :676-679 -- accepts 02-C9 and the "shared term undefined" part of 02-R3. Row 2 of @tbl-keystone: GD_BI is "the one recurrent selection erodes (@sec-cycles)". The chapter's own argument (:354-359) is for drift and says "Selection is not covered by this argument"; 11b reports within-pool GD falling and GD_BS rising under selection but has no GD_BI column and no arm without selection (continuity), so what it shows is co-occurrence with selection, not that selection is what erodes GD_BI; and "the one" is exclusive while drift erodes it too (:354-357). In :676-679 "the shared term" is undefined in 02 (see D4).

- 02-M6 [Low] 02-subdivided.qmd:487, :493-495, :459-460 -- accepts 02-R4 (a), (b). The prose says "the chunk asserts" the rounded solution equals the published c; the chunk asserts max |c_i - published| < 5e-4 (not the same statement; the rounded identity does hold: I got 0.522398, 0, 0.269890, 0.207711), and "weight zero" is tested to 5e-4 although the value is exactly 0. "Raises" (:458) is a hand-typed sign: nothing asserts delta_pct[2] > 0. Both are true on the data; the stated verification is stronger than the code.

- 02-M7 [Low] -- accepts 02-B1, 02-B3, 02-B4, 02-B5. :546 and :630 locate Eq. 14 / the doubling at toro2005 §4a; refcheck found it in §5(a) (PMC fragments; I did not re-read it). :43-44 the correction 2N_i/(2N_i - 1) has no source. :339-350 the three reproductive-system bullets and the regeneration advice are the book's reading, not content of the 2002 paper (refcheck read it in full) and are not marked as such. :608-611 "allelic richness more sensitive to bottlenecks than heterozygosity" has no citation (the 2002 paper, p. 297, says it of allelic diversity). :507 falconer1996 "ch. 8" for the additive variance of a 0/0.5/1 genotype: I could not confirm the chapter number and have not read the book; my recollection is that variance partition sits earlier, but that is memory, not a check.

- 02-M8 [Low/Medium, accumulated] -- accepts 02-C3, C6, C7, C8, C13, C14, C15, C16, C17, C18. Opening does not say it follows 01 (01:531-533 hands over exactly this) or cite 00's three departures (02:8-20). The bridge from subpopulations of individuals to hybrids partitioned over parent lines (usage weights, equal across pools) is not stated, and the keystone-check passes through 00:537-559 without citing it. f_ii, s_i, F_i mean subpopulation quantities here and individual quantities in 01/00; k is an allele (:54, :91, :103), a locus (:502-510) and a marker (01, 90); f_AB/f_AA/f_BB in :354 against theta_AB/theta_A/theta_B elsewhere; D-bar and F-tilde used before definition; "frequency-based" used for GD_T and genic variance in a third sense (:515-516); c, u, f change object in the OCS bullet (:481-495 against :521-529); S1 named at :673 without @tbl-hp-stages. Redundancy with 00:385-406 / 06:80 and the genic-variance derivation that belongs to 02b.

## WHAT WAS VERIFIED

- Chapter chunks run end to end against the worktree package (R CMD INSTALL of the worktree into a scratch library, knitr::purl of the chapter, source from book/): all stopifnot pass, 0.205 s; fl_rng = (0.6075, 0.6635, 0.63831, 0.668, 0.719, 0.69323); ct_glob computed = published to 4 decimals; G_meta, G_wmean = 0.6441, 0.6490; ne_gain = 1.3333, 2.
- Worked example reconstructed from Table 1 of the 2002 PDF (genotypes parsed from pdftotext output by hand-typed rows, then per-locus allele frequencies): matrix identical to the chapter's matrix to 4 dp; f-bar 0.32556, f-tilde 0.45347, s-tilde 0.70556; s_i = (0.6528, 0.9167, 0.6458, 0.7500) = Table 2b.
- Chapter matrix, my run: F_ST = 0.189661; ct_loss_gain census delta_pct (-6.65, +1.84, -3.91, -0.81), equal (-6.92, +6.47, -6.94, -3.56); optimal_contributions c = (0.522398, 0, 0.269890, 0.207711), GD_max 0.6873675 (gain 1.92 %, as the paper); N_s = 1/(2 f-bar) = 1.5358. The paper's own equal-weight column (-6.8, +6.5, -7.0, -3.6) differs from mine (-6.92, -6.95 for subpopulations 1 and 3, from the paper's own genotypes) by more than rounding of the matrix could produce; unexplained, not quoted by the chapter, not a chapter error.
- F_ST naming (seed 7, 30 hybrids, book_cfg 25+25 lines, 2000 markers): gd_partition F_ST 0.126279 = (theta_w - theta_T)/(1 - theta_T); (theta_w - theta_AB)/(1 - theta_AB) = 0.224241. Single locus (p = 0.2, 0.6): var-form 0.1667 = (H_T - H_S)/H_T; between-coancestry form 0.2857.
- Balding-Nichols Monte Carlo (p = 0.3, F_BN = 0.2, 2e6 draws, seed 3): heterosis at d = 1, E[p_A + p_B - 2 p_A p_B] = 0.420082 = GD_T + GD_BS = 0.420082; changes against 2pq = 0.42: GD_T -0.04194, GD_BS +0.04202, GD_WS -0.08397. Confirms 02:354-359 (GD_WS -Delta, GD_BS +Delta/2, GD_T -Delta/2 with Delta = 0.08397) and that 05b's shared term is GD_T, so the 02:676-679 statement is arithmetically right (it is not the unit-clash the audit describes).
- Plug-in alpha_i/G_i baseline (D6): see D6, seed 5.
- Ratio of means versus mean of ratios (M1): seed 2, 0.043205 / 0.041508.
- N_e gene dropping (M3): seed 11, 97.8, 132.6, 199 (se 2.4, 2.9, 2).
- Algebra by hand, line by line: @eq-fbar-decomp sums to f-bar; @eq-ratio-identities from 1 - F_ST = (1-f-tilde)/(1-f-bar) and G = sum N_i(1-f_ii)G_i/sum N_i(1-f_ii); (1 - F_IT) = (1-F_IS)(1-F_ST); d_ll' = (p_l - p_l')^2 at a biallelic locus; f-bar <= f-tilde <= s-tilde; the mixture-base identities :501-510 (GD_T = mean 2 pbar qbar; variance of 0/0.5/1 genotype pbar qbar/2; m beta^2 GD_T/4); the N_e mapping V_W = V_k/2 (agrees with the 2002 relation V_WS = S_W^2 (1+3F_IS)/(2(1-F_IS)) at F_IS = 0).
- Consistency with 02b (@eq-response-hybrid-var, 02b:160-232) of the closing paragraph :681-688.
- Source readings (2002 PDF, my own): Eq. 6, Eq. 7-8, Eq. 14-15, Table 2, Table 3, Table 5 (FRBA +0.67 in the column labelled loss/gain GD_T; -0.0 in the effective-size-weighted column), "imaginary example" (p. 292).

## NOT VERIFIED

- Every attribution to Wright 1951/1969, Cockerham 1967/1969, Nei 1973, Lindgren 1997, Falconer & Mackay (ch. 4, ch. 8): sources absent. The wright1951 and nei1973 lines are decisive for D2 and block approval until checked or withdrawn. Cockerham 1969 is carried by Toro & Caballero 2005 §3a, itself read only through PMC fragments by refcheck.
- toro2005 §5(a) locator, Table 4 FRBA/DESH figures: depend on refcheck's PMC route; not re-read.
- meuwissen1997 content beyond the abstract (the Lagrangian rewrite at :526 is the chapter's).
- The chapter's own 20-seed behaviour, tolerances (R8), and the Typst PDF production (R9): taken from the audit, not rerun by me.
- 08's claims (G_ST < F_ST always, the sweep table): outside this chapter, not judged.

## OPEN ITEMS WITHOUT WHICH 02 CANNOT BE APPROVED

1. 02-D1: restate the reference of f_ij and F_i consistently with 01 (and 90:179 follows).
2. 02-D2: the five content constraints of the ruling; the wright1951 and nei1973 attributions either checked or withdrawn.
3. 02-D3: one coherent, true statement of which text the worked example was taken from and checked against.
4. 02-D4: the conditions of the heterosis identity declared where the keystone row and :676-679 use it; "shared term" defined.
5. 02-D5: separate the result (removal raises GD_T) from the interpretation of the fixation, and say the example is the authors' imaginary data.
6. 02-D6: carry the plug-in baseline into the reading of alpha_i and G_i.
7. The accumulated non-disqualifying set (M1-M8) exceeds the threshold of three on its own; at re-review, those not closed must be justified individually. Outside this chapter and not a gate: 08 Trap 2, 90 rows, 00:575-581 after 08.
