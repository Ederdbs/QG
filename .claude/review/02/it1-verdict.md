# 02-subdivided -- verdict, iteration 1

VERDICT: REJECTED

DISQUALIFYING FAILURES

- 02-D1 [criterion 1] book/02-subdivided.qmd:77 and table :187-188 -- `1 - s_i = H_{o,i}` is off by a factor 2. With the chapter's own `F_i = 2 s_i - 1`, `1 - F_i = 2(1 - s_i)`, and `1 - F_i` is the observed heterozygosity. So `1 - s_i = H_o/2` (diploid self-coancestry of a heterozygote is 1/2; Falconer & Mackay ch. 5, Cockerham 1969). The error carries into the partition table: GD_WI = 1 - s_til is labelled "heterozygosity carried inside each plant", which is half of it. The same reading reaches :379 (`GD_WI-hyb` "carries signal" as heterozygosity) and the `gd_partition()` comment at R/01_metrics.R:146-148. Consumes 02-R1, whose toy set gives 1 - s = (0.169, 0.156, 0) against H_o = (0.338, 0.312, 0).
- 02-D2 [criterion 1] book/02-subdivided.qmd:76,79 -- `p_{k,l,i}` is called "the dosage of allele k in individual l". On a 0/1/2 dosage scale `s_i = sum p^2 / N_i` reaches 4, and `F_i = 2 s_i - 1` leaves [−1, 1]. The formula holds only for the within-individual allele frequency (0, 0.5, 1). That is what `ct_partition()` uses after `P <- G / 2` (R/07_caballero_toro.R:45, :60-62). This is a marker-coding-scale error in a defining equation (02-R4).
- 02-D3 [criterion 1, 5] book/02-subdivided.qmd:140-142 vs :128 -- The tip calls `D_ij = (s_i + s_j)/2 - f_ij` "exact" for the same `D_ij` defined at :128 as Nei's minimum distance `(f_ii + f_jj)/2 - f_ij`. The two differ by `[(s_i - f_ii) + (s_j - f_jj)]/2`, which is ≥ 0 and is zero only when every individual's self-coancestry equals the subpopulation coancestry. Under HWE `s_i = (1 + f_ii)/2`, so they are not equal. The diagonal of the tip's expression is not zero. It is the mean distance between *individuals*, which is a different quantity under the same symbol. The O(Nm) cost point survives, but the identity as written is false (02-R2, 02-B2; toy check D_nei = 0.045 vs 0.197).
- 02-D4 [criterion 5] book/02-subdivided.qmd:198-201 -- The ratio identities use an unsubscripted `G` that the chapter never defines. The only G defined is `G_i` (:96). The natural reading, the weighted mean `sum_i w_i G_i`, makes the first two identities false whenever `f_ii` varies across subpopulations. They hold only for the metapopulation `G = (s_til - f_til)/(1 - f_til)`, checked algebraically: `(1-G)(1-F_ST) = (1-s_til)/(1-f_bar)` (02-R10).
- 02-D5 [criterion 5] book/02-subdivided.qmd:193 (also 05-genomic-era.qmd:198, :1225; 04c-alphasimr-pipeline.qmd:1206; 91-package.qmd:289; R/07_caballero_toro.R:15, :91) vs 91-package.qmd:144 and CLAUDE.md -- The same partition GD_T = GD_WI + GD_BI + GD_BS is called "Eq. 7" in one set of places and "Eq. 8" in the other. Refcheck could not confirm either number (02-B1, 02-R9). Whichever number is right, the book contradicts itself, so the failure is book-wide and not confined to this chapter.
- 02-D6 [criteria 1, 3, 7] book/02-subdivided.qmd:57-60 -- The text says f_ij between SS and NSS pools is "typically low" and that between elite lines of one family it "can exceed 0.6", so "the cross generates nothing new". On the biallelic molecular scale the book uses, unrelated lines from *opposite* heterotic pools already exceed 0.6: fL between pools averages 0.638 (min 0.608) at book_cfg (02-R3). The threshold therefore does not separate redundant from complementary material, and the chapter's own callout at :84-86 says the molecular scale is panel-dependent. The number has no source (02-B11).
- 02-D7 [criterion 1, 5] book/02-subdivided.qmd:380 -- The table says $GD_{BI}$ is "the quantity α budgets (@sec-ocs)". α is defined on `1 - theta`, and that is GD_T, not GD_BI. Measured at book_cfg on a 30-hybrid random selection: 1 - theta = 0.32666 = gd_partition GD_T, while GD_BI = 0.28939 and GD_BS = 0.03727. The `f_bar` in R/01_metrics.R:154 is exactly the hybrid mean coancestry, so with inbred parents α budgets GD_BI + GD_BS jointly. The keystone table misassigns the managed quantity.
- 02-D8 [criteria 1, 5, 7] book/02-subdivided.qmd:316-322 -- `N_s = 1/(2 f_bar)` is a status number, a static function of current coancestry. N_e is defined from the rate of change of inbreeding or coancestry. The heading and the sentence "minimising group coancestry and maximising effective size are the same operation" equate the two with no stated condition. The Eq. 14 form `N_e ≈ 2Nn/(1 - F_IT)` has three problems. It uses `N`, `S_W^2` and `S_B^2`, none of which is defined (only `N_i` and `n` are in the Notation). The authors' own restatement (Toro & Caballero 2005, §4a) has `(1 - F_ST)` and V_W/V_B (02-B3). And :366 cites "Eq. 15" for the same conclusion. The doubling claim itself is supported.
- 02-D9 [criterion 2] book/02-subdivided.qmd:304-305 -- The text says c_i "maximises long-term additive variance". The QP maximises neutral-marker GD_T = 1 - c'fc. That equals additive or genic variance only if all of the following hold: additive gene action, effects of equal size across loci, and markers that represent the QTL frequencies. None of these is declared here. The chapter itself says at :396-397 that the two differ by squared-effect weighting.
- 02-D10 [criteria 3, 4] book/02-subdivided.qmd:242, :252, :298-300, :359-363 -- Several claims say more was verified than the chapter computes.
  - "Every value reproduces exactly" (:252) covers GD_WI and GD_BI, which are derived from `s_til <- 0.7056`, a value typed in from the publication. Those rows cannot fail (02-R6).
  - "The numbers above were checked against the published tables" and "Every other value in Tables 2 and 3 reproduces exactly" (:359-363) have no supporting chunk. s_i, F_i, alpha_i and G_i need individual genotypes the chapter does not have. The F_2 erratum relies on s_2 = 0.9167, which is not reproduced.
  - The Weitzman 65.5% (:266) is not computed and has no table reference.
- 02-D11 [criterion 7] book/02-subdivided.qmd:364-368 -- Two phrases are presented as direct quotations of an error in the paper's Discussion: "to minimise effective size" and "maximise mean coancestry". The full text could not be reached, so the quotation is unsupported (not shown false). The authors' 2005 restatement says the opposite (02-B5). The section is titled as errata found while verifying, yet it omits the authors' own published correction to the 2002 pig analysis (Toro & Caballero 2005, Table 4, footnote a; 02-B4).
- 02-D12 [criterion 7] book/02-subdivided.qmd:39-41, :67, :126-129, :165-171, :266, :310-312, :318, :346-347 -- Results are attributed to named authors or frameworks with no reference:
  - Cockerham group coancestry (02-B8);
  - Nei's gene diversity and minimum distance (02-B9);
  - Wright's F statistics and F_ST = D_bar/(1 - f_bar) (02-B10);
  - "Weitzman-style" analysis;
  - "Meuwissen's framework", where the penalised form is the Lagrangian of a constrained programme and not the paper's stated formulation (02-B7);
  - N_s = 1/(2 f_bar) (02-B12);
  - effective number of alleles as the inverse of mean coancestry (02-B13).
  `@caballero2002` is the only key in the chapter.

NON-DISQUALIFYING OBSERVATIONS

- 02-M1 book/02-subdivided.qmd:138-144 -- "Hours versus seconds" for 50k SNPs and 5000 accessions is not measured. The pairwise double sum is a single BLAS cross-product of about 2.5e12 flops, so minutes rather than hours. The tip's title says "O(N^2) saving" while its body says O(N_i N_j m) to O(Nm) (02-R8).
- 02-M2 book/02-subdivided.qmd:216-218 -- "GD_WS defended and GD_BS held ... pull in opposite directions under selection" is presented as fact with no support in this chapter and no forward reference.
- 02-M3 book/02-subdivided.qmd:235, :252, :268, :298-299 -- Numbers that match the chunk output are hand-typed (0.875/0.125, 19%, 1.8%/6.5%, 0.6744 to 0.6874). No identity the prose calls "exact" is asserted in code (02-R5, 02-R7).
- 02-M4 book/02-subdivided.qmd:40-41, :67 -- "Exactly Nei's expected heterozygosity" applies to the population or plug-in form 1 - sum p^2. Nei's gene diversity estimator carries the 2n/(2n-1) correction, and the chapter does not say which one it means.

Four non-disqualifying observations: this alone meets the threshold of three.

WHAT WAS VERIFIED

- 1 - s_i vs H_o -- algebra from F_i = 2 s_i - 1 gives 1 - s_i = (1 - F_i)/2, which agrees with the 02-R1 toy numbers and the notes' Sub1 (1 - s_1 = 0.347 = (1 - 0.3056)/2). Defect confirmed.
- (s_i + s_j)/2 - f_ij vs Nei D -- algebra: difference = [(s_i - f_ii) + (s_j - f_jj)]/2 ≥ 0, with s_i - f_ii = sum_k Var_l(p) ≥ 0. Defect confirmed.
- G_i = (s_i - f_ii)/(1 - f_ii) = (1 + alpha_i)/2 -- algebra, true; G_i = 1/2 under HWE (s = (1 + f)/2), true.
- f_bar = f_til - D_bar, hence the :149-151 decomposition and f_bar ≤ f_til -- algebra, true.
- Ratio identities -- true with G = (s_til - f_til)/(1 - f_til), false in general with the weighted mean of G_i.
- 1 - theta vs partition terms -- R, book_cfg, `gd_partition()` on 30 random hybrids: 1 - theta = GD_T = 0.32666; GD_BI = 0.28939; GD_BS = 0.03727; GD_WI = -6.7e-16.
- Worked example, OC solution, loss/gain percentages -- not redone; consumed from 02-R header and 02-B6 (all reproduce the chunk; published values UNVERIFIED).
- Equation numbers (Eq. 7/8, 13, 14, 15), table numbers, Discussion quotations -- UNVERIFIED (Caballero & Toro 2002 full text unreachable); judged only on internal consistency and against Toro & Caballero 2005.
