# 02-subdivided -- chapter audit, iteration 1

Scope: book/02-subdivided.qmd (406 lines), book/_common.R, R/07_caballero_toro.R
(ct_partition, ct_loss_gain, optimal_contributions), R/01_metrics.R gd_partition,
frozen outputs book/_freeze/02-subdivided/execute-results/html.json (identical code to
the .qmd; outputs reproduced exactly with pkgload::load_all). Verification script:
scratchpad a02.R (session scratchpad). Genotype-level checks use ct_partition on a toy
3-subpopulation set (two outcrossing, one inbred; m = 400, set.seed(1)); book-scale
checks use simulate_data(book_cfg).

Verified TRUE (all.equal): f_bar decomposition :149-151; F_ST = D_bar/(1 - f_bar) :168;
(1-F_IT) = (1-F_IS)(1-F_ST) :171; partition GD_T = GD_WI + GD_BI + GD_BS :175-177 (toy and
book scale); ratio identities :198-201 (with G = (s_til - f_til)/(1 - f_til));
G_i = (1 + alpha_i)/2 :96; f_bar <= f_til <= s_til :31 (s_i - f_ii = sum_k Var_l(p_kl) >= 0);
worked example :252 (max |computed - published| = 3.9e-5, all equal at 4 dp); OC solution
:300 rounds to (0.522, 0, 0.270, 0.208); with inbred lines at book scale
gd_partition(...)[["GD_WI"]] = -4.4e-16 (zero to rounding) :379.

## Findings

| ID | Severity | file:line | Problem | Evidence |
|---|---|---|---|---|
| 02-R1 | high | book/02-subdivided.qmd:77, :187 | `1 - s_i = H_{o,i}` is off by a factor 2: for a diploid, self-coancestry of a heterozygote is 0.5, so `1 - s_i = H_o/2` and `H_o = 1 - F_i = 2(1 - s_i)`. Propagates to the partition table (:187): GD_WI = 1 - s_til is *half* the heterozygosity carried inside each plant (the within-individual gene diversity), not "heterozygosity". The error is inherited from the annotated source notes (reference/caballero_toro, line 16/64). | Toy set: 1 - s = (0.16875, 0.15575, 0); H_o = (0.3375, 0.3115, 0); 1 - F_i = H_o exactly. Paper's own Sub1 (notes table): F_1 = 0.3056, s_1 = 0.6528 -> 1 - s_1 = 0.347 = (1 - F_1)/2. |
| 02-R2 | high | book/02-subdivided.qmd:137-145 | The tip's "exact identity" `D_ij = (s_i + s_j)/2 - f_ij` is not Nei's minimum distance defined at :128 (`(f_ii + f_jj)/2 - f_ij`). `(s_i + s_j)/2 - f_ij` is the mean distance between *individuals* of i and j (what the Eq. 13 double sum computes), and it differs from Nei's D by `[(s_i - f_ii) + (s_j - f_jj)]/2`; its diagonal is not zero. Same symbol for two quantities; the claimed equivalence is false. The cost point survives (both are O(Nm) via frequencies), but the identity must be `d_bar_ij = (s_i + s_j)/2 - f_ij`, and Nei's `D_ij = d_bar_ij - (d_bar_ii + d_bar_jj)/2`. | Toy set: D_nei[a,b] = 0.0449, (s_a+s_b)/2 - f_ab = 0.1970; diag of the latter = (0.160, 0.144, 0.303). Double sum of individual distances == (s_i+s_j)/2 - f_ij: all.equal TRUE. |
| 02-R3 | medium | book/02-subdivided.qmd:57-60 | "Between two elite lines of the same family [f_ij] can exceed 0.6, and the cross generates nothing new"; SS x NSS f_ij "typically low". On the molecular biallelic-SNP scale this book uses, unrelated lines from *opposite* heterotic pools already exceed 0.6, so 0.6 does not mark redundancy. The threshold is panel-dependent (the chapter's own callout :84-86 says so) and hand-typed. | simulate_data(book_cfg): fL between pools mean 0.638, min 0.6075; within pool A off-diagonal mean 0.692. |
| 02-R4 | medium | book/02-subdivided.qmd:76, :79 | "p_{k,l,i} the dosage of allele k in individual l" -- with dosage 0/1/2 the formula gives s up to 4. It is the within-individual allele frequency (1, 0.5, 0); ct_partition rescales `P <- G / 2` (R/07_caballero_toro.R:46). Marker-coding ambiguity, exactly the 0/1/2 vs 0/0.5/1 trap. | R/07_caballero_toro.R:46, :57-60. |
| 02-R5 | medium | book/02-subdivided.qmd (whole chapter) | Check 3: no `stopifnot()` anywhere. Identities asserted in prose and unchecked in any chunk: f_bar decomposition :149-151; F_ST = D_bar/(1-f_bar) :168; F_IT product :171; the partition :175-177; ratio identities :198-201; G_i = (1+alpha_i)/2 :96; "Every value reproduces exactly" :252 (compared by eye in a printed data.frame); OC solution "exactly" :300. All hold numerically (see header), so the fix is assertions, plus a small genotype-level chunk with ct_partition for the ones the 4x4 f cannot reach (partition, ratios, F_IT, G_i, and 02-R1/02-R2). | a02.R. |
| 02-R6 | medium | book/02-subdivided.qmd:242, :246-252 | `s_til <- 0.7056` is the published value typed in, so the "computed" GD_WI (= 1 - 0.7056) and GD_BI rows cannot fail; "Every value reproduces exactly" overstates what is verified for 2 of 7 rows. The comment says so in code; the prose should too, or the rows should be labelled as published-input. | :242 comment "published; needs individual genotypes". |
| 02-R7 | low | book/02-subdivided.qmd:235, :252, :266, :268, :274, :298-300, :362 | Check 1: hand-typed numbers. Match chunk output but typed: 0.875/0.125 (:235, = f[2,2], 1 - f[2,2]); "19%" (:252, = F_ST 0.1897); "1.8%"/"6.5%" (:268, = 1.844/6.473); "0.6744 to 0.6874" (:298-299). Not computed at all: "65.5%" Weitzman loss (:266, no Weitzman implementation, not attributed to the paper's Table 3 in the sentence); "0.67%" pig breeds (:274, attributed); F_2 = 0.8383, s_2 = 0.9167 (:362, s_2 needs genotypes; not reproduced in a chunk). Inline `r` for the first group; mark the second as quoted from the paper with table number. | html.json outputs vs prose. |
| 02-R8 | low | book/02-subdivided.qmd:142-144 | "For a 50k-SNP panel and 5000 accessions this is the difference between hours and seconds": unmeasured cost claim (check 1). The double sum over all pairs is one tcrossprod of a 5000 x 100000 matrix (~2.5e12 flops), minutes with BLAS, not hours; the gain is real only against an R loop. Also the title "O(N^2) saving" vs body "O(N_i N_j m) -> O(Nm)" -- state the measured cost or drop the figure. | Algebra; no timing in chapter or book/data. |
| 02-R9 | low | book/02-subdivided.qmd:193 vs CLAUDE.md | Equation number: chapter caption and R/07_caballero_toro.R:15,:96 call the partition "Eq. 7" (ratio identities Eq. 8, per the source notes); CLAUDE.md ("Caballero & Toro 2002 Eq. 8" for gd_partition) says Eq. 8. Chapter is consistent with the package; one of the two is wrong -- refcheck against the paper. | reference notes: "particao da diversidade (Eq. 7)", "identidades limpas (Eq. 8)". |
| 02-R10 | low | book/02-subdivided.qmd:198-201 | `G` in the ratio identities is unsubscripted and undefined; it is the metapopulation `G = (s_til - f_til)/(1 - f_til)`, not a weighted mean of G_i (the two differ when f_ii varies). Define it. | Ratio identities TRUE only with G = (s_til - f_til)/(1 - f_til) (a02.R). |
| 02-R11 | info | book/_freeze/02-subdivided/execute-results/html 2.json; docs/02-subdivided 2.html; docs/02-subdivided 4.html | Tracked macOS duplicates for this chapter (part of the 64 already tracked; removal is a deliberate `git rm`, per CLAUDE.md). | git ls-files. |

## Checks with no finding

2. Seeds: the chapter makes no random draw and no AlphaSimR call; _common.R:15 set.seed(2026) is irrelevant here.
4. Data sources: reads nothing from disk; no report/, data/, reference/ or R/ paths.
5. ct_loss_gain, optimal_contributions exported (NAMESPACE:29, :135), present in installed hybdiv 0.1.0; quadprog installed.
6. No chunk changes in this iteration; chapter has no figures (docs/02-subdivided_files/ does not exist, _freeze holds only execute-results), so nothing to orphan. Listed in book/_quarto.yml:23; book/downloads/02-subdivided.R exists.
Not checked: Eq. 14 form and "roughly double" Ne under Poisson (:319-322), the two errata against the paper's text (:362-368), Weitzman 65.5% and pig 0.67% (refcheck's job; the paper PDF is not in reference/, only annotated notes).
