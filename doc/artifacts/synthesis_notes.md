# Page-anchored extraction notes from the four attached papers


---

# [corehunter3] Core Hunter 3: flexible core subset selection (De Beukelaer, Davenport, Fack 2018, BMC Bioinformatics)

## Identification

De Beukelaer, H., Davenport, G.F., Fack, V. (2018). "Core Hunter 3: flexible core subset selection." *BMC Bioinformatics* 19:203. DOI: https://doi.org/10.1186/s12859-018-2209-z (page 1).

## Metrics defined

- **Modified Roger's Distance** — no symbol given, no explicit formula reproduced in text (cited to Wright 1978 via Thachuk et al. [18, 21]); used "to assess the dissimilarity of accessions based on genetic marker data" (page 3). Inputs: genetic marker (allele) data.
- **Gower's distance** — no symbol/formula given in text (cited to Gower 1971 [22]); "simultaneously takes into account qualitative and quantitative traits" (page 3). Inputs: phenotypic trait data (qualitative + quantitative).
- **Entry-to-nearest-entry (E-NE)** — described in words only, no LaTeX formula given: "the average distance between each selected accession and the closest other core entry" (page 3). Inputs: pairwise distance matrix restricted to selected core entries.
- **Accession-to-nearest-entry (A-NE)** — described in words only, no LaTeX formula given: "the mean distance between each accession from the entire collection and the most similar core entry, including itself in case the accession has been selected" (page 3). Inputs: full pairwise distance matrix (all accessions × selected core).
- **Minimum distance (DMIN)** — no formula given; "the minimum distance ... between selected accessions" — used only for comparison with CH2, "not an objective that can be directly optimized by CH3" (page 3). Inputs: pairwise distance matrix over selected core.
- **Expected heterozygosity (HE)**, symbol $H_E$: 
$0 \le H_E = \frac{1}{L}\sum_{l=1}^{L}\left(1-\sum_{a=1}^{n_l}\hat p_{la}^2\right) \le 1$ 
(page 3). Inputs: $L$ = number of loci, $n_l$ = observed alleles at locus $l$, $\hat p_{la}$ = frequency of allele $a$ at locus $l$ **in the selected core collection** (marker matrix required; allele frequencies computed on the core, not the base population).
- **Weighted index**, symbol $F(c)$: $F(c)=\sum_{i=1}^{k}\alpha_i F_i(c)$, with $0<\alpha_i<1$, $\sum_{i=1}^k \alpha_i =1$ (page 3–4). Inputs: any combination of the above metrics, each normalized to $[0,1]$ via a "Pareto minimum based upper-lower-bound approach" [24] (page 4).

## Coancestry / relationship matrices compared

Not addressed. The paper is built entirely on pairwise **distance** matrices (Modified Roger's distance for markers, Gower's distance for phenotypes) and an allele-frequency-based heterozygosity statistic, not on coancestry or additive-relationship matrices. There is no discussion of a marker-based relationship/coancestry matrix (e.g., VanRaden-style $G$), no pedigree-based $A$ matrix, and no discussion of centring allele frequencies at sample $p$, at $0.5$, or at a base-population $p$ for constructing such a matrix. The only allele-frequency use is $\hat p_{la}$, defined as the frequency **within the selected core** for the HE calculation (page 3) — the paper does not compare this against a base-population-frequency-centred alternative.

## Recommendations made

- Use **E-NE** rather than average pairwise distance or DMIN to build diverse cores: "in Core Hunter 3, the minimum distance measure was replaced with the newly proposed E-NE criterion" (page 9).
- E-NE is judged the better diversity summary than DMIN: "we believe that the latter criterion better reflects within-core diversity" (page 10).
- Use **A-NE** (minimized) when the goal is representativeness of the whole collection, not diversity: Odong et al. "recommend to minimize the average distance between each accession in the full collection and the most similar accession contained in the core" (page 2).
- Algorithm choice: default to parallel tempering, not genetic algorithm or plain hill-climbing: "parallel tempering is preferred, and that more complex algorithms are not needed to optimize E-NE" (page 10).
- On representativeness specifically, GDOpt remains well suited: "GDOpt is especially suited to construct cores that optimally represent all accessions" (page 10).
- On fixed vs. variable-size core sampling: "fixed and variable size core sampling should be treated as separate problems, using specific evaluation measures" (page 11).

## Documented failure modes

- **Average pairwise distance** overrepresents extremes: "it is known that maximizing this criterion overrepresents extreme values" (page 2); "Maximizing this criterion tends to overrepresent the extremes of the distribution in the full collection" (page 9).
- **Minimum distance (DMIN)** is pathological for local search: "very different cores may have a similar or even the same minimum distance," making it "difficult for a local search to find its way from a randomly generated selection to a high-quality core" (page 9); "many possible modifications may not affect the minimum distance" (page 9–10).
- **CH2 on the pea dataset**, under the 10 s stop condition, achieved **DMIN = 0.000 ± 0.00e‑0** (Table 2, page 7) — complete collapse of the minimum-distance objective when the constructive LR replica does not finish in time.
- The **LR replica** in CH2's MixRep "did not always complete before CH2 was terminated" (page 7); "the LR algorithm becomes slow for large datasets, because it builds the core bottom-up" (page 9), attributed explicitly to its "quadratic time complexity" (page 10).
- Even with LR forced to completion (CH2L), differences vs. CH3 in DMIN were "not larger than 4%," statistically significant for coconut/maize (p = 0.000097) but **not significant for pea** (p = 0.3064) (page 7).
- **GDOpt** fails on allelic richness: "GDOpt yields cores with significantly lower HE than any of the other methods" (page 8).
- **SimEli** fails on representativeness: "all cores sampled by SimEli have a worse A-NE value than those obtained by GDOpt and CH3" (page 8).

## Optimisation / algorithmic content

- **Objective**: $C^* = \arg\max_{C\in\Omega} F(C)$ over $\Omega=\{C\mid C\subset A \wedge |C|=k\}$, fixed core size $k$ only (page 3); minimization done via maximizing $-F(C)$ (page 3).
- **Weighted multi-objective index** with per-objective $[0,1]$ normalization (Pareto min/max bound method) (pages 3–4).
- **Algorithms compared**: random descent (single-swap neighbourhood hill-climber, Algorithm 1, page 4); parallel tempering / REMC (Algorithm 2, page 4–5) with $p=10$ replicas, temperature range $[10^{-8},10^{-4}]$, $q=500$ replica steps per iteration, single-swap neighbourhood, standard Metropolis acceptance $p(\Delta,t)=1$ if $\Delta>0$ else $e^{\Delta/t}$, and replica-swap probability $q(\Delta,t_r,t_{r+1})$ (page 4); genetic algorithm (Algorithm 3, page 5) with population $p=25$, $c=5$ children/generation, tournament selection, uniform crossover to size $k$, random-descent mutation (terminated after 5000 non-improving steps), roulette survival weighted $1/F(C)$.
- **Stop conditions**: absolute runtime limit or "no further improvements ... during a certain amount of time" (page 4); experiments used 30 min limit (Table 1) or 10 s no-improvement (Tables 2–3).
- **Complexity statement**: only the CH2 LR replica is explicitly characterized as having "quadratic time complexity" (page 10) — no Big-O given for E-NE/A-NE/HE evaluation or for parallel tempering itself.
- **Problem sizes tested**: rice 1000 accessions × 39 traits; coconut 1014 accessions × 30 SSR markers; maize 1250 accessions × 1117 SNPs; pea 4428 accessions × 17 markers (page 6). Core sizes: 20% for rice/coconut/maize, 10% for pea (page 6).
- **Runtimes**: E-NE optimization on pea took 154.1 ± 49.7 s (CH3) vs. 802.3 ± 0.8 s (CH2L, forced LR completion) (Table 2, page 7); CH3 execution times by objective across datasets given in Table 3 (page 8), e.g. HE fastest (16.6–62.8 s), E-NE/A-NE slower (37.5–154.1 s); parallel tempering "almost as fast as" random descent even for the 4000+-accession pea dataset (pages 9–10) — "after less than 10 s, parallel tempering found a better solution than random descent" (page 6).
- Hardware: two 10-core Intel E5-2660v3 (2.6 GHz), 128 GB RAM (page 6); implemented in Java 8 / JAMES framework v1.2, called from R (page 6).

## Relevance to: choosing metrics to quantify diversity LOSS under selection

- E-NE (page 3, 9) is the paper's recommended diversity metric because, unlike average pairwise distance, it does not "overrepresent extreme values" (page 2, 9) — relevant if the breeder wants a loss metric that penalizes clustering of retained lines rather than just rewarding a few far-apart outliers.
- DMIN is explicitly flagged as a poor optimization target because "very different cores may have a similar or even the same minimum distance" (page 9) — implying it is also a noisy/uninformative metric for tracking incremental diversity loss step-to-step.
- A-NE (minimized, page 3) directly measures loss of representativeness of the *original* collection by the retained subset — the paper frames it as the correct complement to E-NE when the concern is "how well does the retained set still cover the full collection," which maps onto "diversity loss relative to the founder population" framing.
- HE (page 3) ties diversity directly to allele frequencies in the retained set, so tracking $H_E$ before/after selection gives a direct allelic-diversity-loss measure, computed straight from the marker matrix.
- The paper never discusses a coancestry/relatedness-matrix-based loss metric (e.g., mean kinship) — that class of metric is simply not addressed here.

## Relevance to: cheapest metric inside a DE inner loop (1e5-1e6 evaluations)

- HE was "consistently faster" to optimize than E-NE or A-NE in all datasets tested (Table 3, page 8), and the paper attributes this to it being "known that allelic richness can also be effectively maximized with a basic stochastic hill-climber" (page 10) — makes HE the cheapest candidate metric for a high-iteration inner loop.
- E-NE and A-NE were shown to be optimizable by the simplest algorithm tested (random descent / single-swap hill-climbing) with "quite little variability" even without parallel tempering (page 9–10), suggesting per-swap incremental recomputation is tractable, though the paper gives no formal per-evaluation complexity for either.
- No explicit O(...) complexity is stated for E-NE, A-NE, or HE evaluation itself; the only complexity claim in the paper is that CH2's LR constructive replica has "quadratic time complexity" (page 10) — this is a statement about a specific *heuristic*, not about the metrics, so it does not directly transfer to per-evaluation cost inside a DE loop.
- DMIN is explicitly discouraged as an optimization objective for local-search-style loops because of its poor "modification sensitivity" (page 9–10) — a caution against using it as the per-evaluation fitness signal in a DE inner loop.
- The paper notes collections up to "multiple thousands of accessions" were handled "in at most a few minutes" (page 11) under 10 s-to-improvement stopping rules, but this describes wall-clock behavior of full local-search runs (thousands of evaluations), not a per-evaluation cost figure applicable at 1e5–1e6 evaluations.

---

# [mgd_genomics] Management of Genetic Diversity in the Era of Genomics (Meuwissen, Sonesson, Gebregiwergis, Woolliams 2020, Front Genet)

## Identification
Meuwissen, T. H. E., Sonesson, A. K., Gebregiwergis, G., & Woolliams, J. A. (2020). Management of Genetic Diversity in the Era of Genomics. *Frontiers in Genetics*, 11:880. doi: 10.3389/fgene.2020.00880 (p. 1).

## Metrics defined

- **Fhom** (homozygosity-based inbreeding). $F_{hom} = 1 - \sum_{loci\,k} \frac{2p_{t,k}(1-p_{t,k})}{2p_{0,k}(1-p_{0,k})}/N_{SNP}$ (Eq. 1A), p. 4. Inputs: allele frequencies per locus at time 0 and t (marker panel derived); can go negative if heterozygosity rises above baseline (p. 4).
- **Fdrift** (drift-based inbreeding). $F_{drift} = \sum_{loci\,k}\frac{\delta p_{t,k}^2}{p_{0,k}(1-p_{0,k})}/N_{SNP}$ (Eq. 1B), p. 4. Inputs: base and current allele frequencies per marker; "never negative" (p. 4); noted as analogous to $F_{ST}$ applied to one population over time (p. 4).
- **Classical equivalence** $var(p_{t,k})/[p_0(1-p_0)] = 1-H_{t,k}/H_0 \Rightarrow F_{drift}=F_{hom}$ (Eq. 2), p. 4. Holds only if $E[\delta p_{t,k}|p_0]=0$ across all $p_0$; inputs: allele-frequency trajectories under random mating assumption.
- **Discrepancy decomposition**: $F_{hom}-F_{drift} = 2\,cov\!\left(\delta p_{t,k}/\sqrt{p_{0,k}(1-p_{0,k})};\,(p_{0,k}-1/2)/\sqrt{p_{0,k}(1-p_{0,k})}\right)$ (Eq. 3), p. 4. Input: covariance between per-locus frequency change and initial frequency across a marker panel.
- **de Beukelaer term** for rate of homozygosity: $2(\delta p_{t,k}^2 + 2\delta p_{t,k}(p_0-\tfrac12))/H_{t,k}$, p. 4. Inputs: per-locus frequency change and base frequency.
- **Squared total selection intensity** $i^2$, with $i \approx \delta p_{t,k}/\sqrt{p_{0,k}(1-p_{0,k})}$, p. 4–5. Used to build $G_{i(p)}$ (Supplementary Info 2); input: per-locus intensity trajectory, not just terminal $\delta p$.
- **Group coancestry / rate of inbreeding constraint** $K = \tfrac12 c'Gc$ (with $A$ pre-genomics: $\tfrac12 c'Ac$), p. 2, p. 6. Inputs: relationship matrix $G$ (or $A$) and contribution vector $c$.
- **Rate of inbreeding regression**: $\log(\sum_k H_{t,k}/H_{0,k}) - \log(N_{SNP}) = t\log(1-\Delta F) \approx -t\Delta F$, p. 6. Input: heterozygosity time series per panel, fitted by regression on generation $t$ to give $\Delta F_{hom}$ (and analogously $\Delta F_{drift}$ from $\log(1-F_{drift})$).
- **FROH**: total length of runs of homozygosity relative to genome length, p. 3. Inputs: phased/unphased marker genotypes, ROH length/marker-density thresholds; described as individual-level, requiring pairwise extension ($G_{ROH}$) for population use (p. 3).
- **Ne** = $1/(2\Delta F)$ (Falconer & Mackay 1996), p. 2. Input: realized or target rate of inbreeding.

## Coancestry / relationship matrices compared

- **A (pedigree numerator relationship matrix)**: standard Wright IBD relationships relative to an assumed unrelated, non-inbred base population; guaranteed positive definite (p. 6). Used with random EBVs, $A(M,\sim)$, "required no marker panel" (p. 6).
- **GVR2 (VanRaden Method 2)**: $G_{VR2}=XX'/N_{SNP}$, genotypes standardized/centred on base-population reference frequency $p_{0,k}$ (p. 6). "Providing the base generation is used to define the reference frequencies at neutral unlinked loci... the expectation of $G_{VR2}$ is $A$" (p. 2) — i.e. equal weighting of loci after standardization. Directly targets $F_{drift}$ (p. 2–3).
- **GVR1 (VanRaden Method 1)**: $G_{VR1}=ZZ'/\sum_k H_{0,k}$, with $Z_{ij}\in\{-2p_{0j},1-2p_{0j},2-2p_{0j}\}$; "can be viewed as simply reweighting the loci [of GVR2] by $2p_{0,k}(1-p_{0,k})$" (p. 2), i.e. weighted mean vs. GVR2's simple mean of single-locus estimates. Also centred on base-population $p_0$, not current-generation $p$ (p. 2, discusses Powell et al. 2010's use of current-generation frequencies as an alternative, and Legarra 2016 for discussion).
- **G0.5**: centred on 0.5 for all loci regardless of actual $p_0$; "proportional to homozygosity and molecular coancestry (Toro et al., 2014)" (p. 3). Used to measure $F_{hom}$ and loss of heterozygosity $(1-F_{hom})$. Semi-positive definite like the other VanRaden-style matrices, with one zero eigenvalue from centring (p. 6).
- **GLA (linkage-analysis relationship matrix)**: uses pedigree + marker inheritance to estimate probabilities of transmitting maternal/paternal allele (departs from assumed 50/50 in A); requires both pedigree and marker data; guaranteed positive definite (p. 3, 6). "If two (base) individuals are unrelated in A then they are unrelated in GLA" — unlike the IBS-based matrices which give nonzero relationships even among base individuals (p. 3). Directly evaluates IBD rather than expecting it (p. 3).
- **Gi(p)**: built from squared total applied intensities rather than $\delta p^2$; a "novel" matrix (Supplementary Info 2); positive semi-definite like GVR1/GVR2/G0.5, diagonal-loaded with $\alpha=0.01$ (p. 6–7).
- **GROH**: hybrid IBD/homozygosity matrix from runs of homozygosity (de Cara et al. 2013 method); "not guaranteed to be semi-positive definite since its elements are calculated one by one," with large negative eigenvalues observed empirically (p. 6–7). Required trial-and-error diagonal loading (starting $\alpha=0.05$, doubled if $<1$ else $+1$, tested by Cholesky) to reach positive definiteness (p. 7); mean diagonal addition ≈ 8.7, making the matrix diagonally dominant (p. 10–11).
- All VanRaden-type matrices (GVR1, GVR2, G0.5, Gi(p)) are PSD "as they are the cross-product of SNP genotype matrices... with one eigenvalue of zero due to the centring of

---

# [subdivided] Optimal Management of Genetic Diversity in Subdivided Populations (Lopez-Cortegano, Caballero et al.)

## Identification

López‑Cortegano E., Pouso R., Labrador A., Pérez‑Figueroa A., Fernández J., Caballero A. (2019). "Optimal Management of Genetic Diversity in Subdivided Populations." *Frontiers in Genetics* 10:843. doi: 10.3389/fgene.2019.00843. Received 20 Apr 2019; accepted 13 Aug 2019; published 13 Sep 2019. (p. 1)

## Metrics defined

- **Total heterozygosity, $H_T$** — partitioned "following Nei (1973)" into within- and between-subpopulation components; no explicit equation given beyond the verbal Nei (1973) decomposition. Inputs: allele frequencies at multiallelic (SNP-haplotype) marker loci, per subpopulation. (p. 3)
- **Within-subpopulation expected heterozygosity, $H_S$** — "the average expected heterozygosity within subpopulations assuming Hardy-Weinberg proportions." Inputs: within-subpopulation allele frequencies. (p. 3)
- **Between-subpopulation component, $D_G$** — "the average Nei's minimum genetic distance between subpopulations, averaged over all possible pairs of subpopulations." Inputs: pairwise subpopulation allele frequencies. (p. 3)
- **Total allelic diversity, $A_T$** — defined as $A_T = A_S + D_A$, and used as optimization objective $A_T = D_A + \lambda A_S$ (the two forms coincide when $\lambda=1$, the default weighting used in most runs). Inputs: per-locus allele lists/counts by subpopulation, following Caballero and Rodríguez-Ramilo (2010) partition. (p. 3)
- **Within-subpopulation allelic diversity, $A_S$** — "the average number of alleles segregating in the subpopulations minus one." Inputs: allele counts per subpopulation per locus. (p. 3)
- **Between-subpopulation allelic diversity, $D_A$** — "the number of alleles present in a subpopulation and absent in other when subpopulations are compared in pairs and averaged over all possible pairs of subpopulations." Inputs: pairwise presence/absence allele sets across subpopulations. (p. 3)
- **Total heterozygosity objective, $H_T = D_G + \lambda H_S$** — optimization function maximized by maxHT, $\lambda$ = weight on within-subpopulation component. Inputs: $H_S$, $D_G$, chosen $\lambda$. (p. 3)
- **Total number of alleles, $K$** — total allelic number segregating in the whole population; maximized (maxK) "by managing contributions from parents to progeny and migrations so that the global probability of alleles' losses in the progeny is minimized." No explicit formula; inputs: whole-population allele inventory across loci. (p. 3–4)
- **Molecular inbreeding, $F$** — "the observed marker homozygosity of all individuals in the subpopulations…which includes homozygotes identical by descent and identical in state." No formula given; inputs: per-individual marker genotypes (homozygosity counts), not pedigree-based. (p. 4)
- **Variance of allelic frequencies within loci, VarFreq** — tracked statistic, no formula given; inputs: locus-wise allele frequency distributions. (p. 4, Figure 2 legend)
- **Effective number of alleles** — described verbally as "the number of alleles per locus if all had the same frequency (Crow and Kimura, 1970)"; stated equivalent to maximizing $H_T$; no explicit formula written in the paper. Inputs: allele frequencies per locus. (p. 7)
- Additional tracked (non-diversity, process) statistics: number of mating pairs (nMates), variance of female parental contributions (VarContFem), variance of migrant number per subpopulation (VarMigrants) — descriptive, no formulas given. (p. 4–5)

## Coancestry / relationship matrices compared

Not addressed as a methodological comparison. The paper does not construct, compare, or centre any marker-based or pedigree-based coancestry/relationship matrix (no discussion of centring on sample allele frequency $p$, on 0.5, or on base-population $p$, and no G-matrix vs A-matrix comparison). The only mention of coancestry is a single equivalence statement in the Introduction: "maximization of expected heterozygosity…is equivalent to the minimization of mean weighted coancestry" (Toro and Pérez‑Enciso, 1990; Ballou and Lacy, 1995; Meuwissen, 2007) (p. 2), given without a formula, valid-range statement, or centring specification. Management in this paper is explicitly marker/allele-frequency based rather than pedigree-based: "in the absence of genealogical data, molecular markers are used to analyze population diversity" (p. 7).

## Recommendations made

- Overall recommendation for structured-population conservation: maxAT. "maxAT, can be recommended as the method of choice because it maintains a high allelic richness" (p. 7).
- Abstract-level general recommendation: "maximization of allelic diversity should be a recommended strategy in conservation programs for structured populations." (p. 1)
- Weighting parameter guidance: "For intermediate values of λ (0.5 or 1), maxAT seems to be the most robust method" (p. 6), producing lowest inbreeding with near-maxK allelic numbers, at the cost of lower $H_T$ than maxHT (p. 6).
- Condition-specific alternative: when subpopulations represent distinct local-adaptation reservoirs and outbreeding depression risk is a concern, "a method such as maxK could be more appropriate" (p. 8), though this carries the irreversible-loss risk noted below.
- Migration-rate rule adopted from external literature (not itself validated de novo here): a cap of "a maximum

---

# [gcoancestry_regions] The use of genomic coancestry matrices in the optimisation of contributions to maintain genetic diversity at specific regions of the genome (Gomez-Romano, Villanueva et al., GSE)

## Identification
Gómez-Romano F, Villanueva B, Fernández J, Woolliams JA, Pong-Wong R. "The use of genomic coancestry matrices in the optimisation of contributions to maintain genetic diversity at specific regions of the genome." *Genetics Selection Evolution* (2016) 48:2. DOI: 10.1186/s12711-015-0172-y. (page 1)

## Metrics defined

- **Pedigree numerator relationship matrix (A)** — symbol `A`; no explicit formula given beyond its definition as "expected relationships assuming neutrality"; related to G by `G = ½A`; inputs: pedigree records only. (page 2)
- **Coancestry matrix (G)** — symbol `G`; defined verbally as "the coancestry matrix containing coefficients of coancestry between all candidates in the population"; inputs: pedigree **or** molecular (marker) data. (page 2)
- **Allelic-similarity genomic relationship (Nejati-Javaremi method)** — no dedicated symbol beyond G; formula: $(0.25)\sum_{i=1}^{2}\sum_{j=1}^{2}\delta_{ij}$ per SNP, averaged over all genotyped SNPs (whole genome or region); inputs: biallelic marker genotypes, allele-sharing indicator $\delta_{ij}$ (1 if alleles identical-by-state, else 0). (page 3)
- **Region-restriction threshold ($k_j$)** — symbol $k_j$; formula: $k_j = 1-(1-C_j)(1-f_j)$; inputs: targeted rate of coancestry $C_j$ for region $j$, current average coancestry $f_j$ in that region. (page 3)
- **Rate of coancestry / true diversity loss (Δf)** — symbol $\Delta f$; defined as "the rate at which the average true coancestry increases"; inputs: true genomic coancestry matrix computed from **non-marker** loci (held out from the SNP panel), or pedigree-based coancestry for the pedigree analogue. (page 4)
- **Expected rate of coancestry in next generation ($E(\Delta f_{t+1})$)** — formula: $E(\Delta f_{t+1}) = (c_t' G^x_t c_t - f_t)/(1-f_t)$; inputs: optimized contribution vector $c_t$, region-specific candidate coancestry matrix $G^x$, current average coancestry $f_t$ (both $f_t$ and $G^x$ computed from marker genotypes). (page 7)
- **Cross-product (VanRaden-type) genomic relationship** — formula: $(x_i-2p)(x_j-2p)$; inputs: genotype score $x\in\{0,1,2\}$ (reference-allele count), allele frequency $p$. (page 12)
- **Normalised cross-product relationship** — formula: $(x_i-2p)(x_j-2p)/(2p(1-p))$; inputs: same as above, plus frequency-based scaling $2p(1-p)$. (page 12)
- **Expected mean coancestry predictor ($f=c'Gc$)** — the general genetic-contribution-theory equation used to predict next-generation coancestry; inputs: contribution vector $c$, coancestry matrix $G$ (pedigree- or marker-based). (page 11)
- **Percentage of contributing candidates ($N_{cont}$) and variance of offspring number ($V_c$)** — auxiliary comparison statistics, not coancestry per se but used to characterise the diversity-management solutions; inputs: realised offspring-number distribution from optimized $c$. (page 4, tabulated pages 9–10)

## Coancestry / relationship matrices compared

- **Pedigree matrix A / G=½A**: no centring; assumes base population unrelated/non-inbred; "represents expected relationships assuming neutrality and does not take into account variation due to Mendelian sampling." Valid range implicitly [0,1] for coancestry. (page 1–2)
- **Genomic allelic-similarity matrix (Nejati-Javaremi)**: centring is implicit in the (0.25)ΣΣδij allele-sharing average — no explicit mean-centring by frequency; the method "has a 'natural' interpretation in relation to the definition of the coefficient of coancestry (i.e., the probability of randomly sampling the same allele from both individuals)." Should be positive definite by construction as used here, and is the matrix required to be positive definite for the SDP convexity condition. Should stay in valid coancestry range in practice for whole-genome averages but this is not guaranteed for small regions. (page 3, 12)
- **Cross-product (VanRaden-type) matrix, centred on allele frequency p (not stated as sample vs base-population p — paper simply writes "p is its frequency")**: un-normalised form $(x_i-2p)(x_j-2p)$ and normalised form dividing by $2p(1-p)$. The paper states values "range from −1 to x, where x can be substantially larger than 1 (depending on the allele frequency)... clearly outside the valid range for a coefficient of coancestry (i.e., [0:1])." Practical experience: whole-genome averages tend to stay in valid range, but small regions with few SNPs may not. Centering on p (rather than 0.5) means "a pair of individuals that are homozygous for the minor allele" get a higher relationship value than a pair homozygous for the common allele, "penalising" rare-allele carriers. Centering also "makes the matrix non-invertible (even when the number of SNPs in the region is larger than the number of candidates)." (page 12)
- Interpretive contrast: allelic-similarity matrices are expected to "favour solutions that tend to drive the gene frequency towards 0.5," while cross-product matrices "lead to solutions that are closer to the average gene frequency" and thus preserve status quo allele frequencies (rare alleles can still be lost to drift). (page 12–13)

## Recommendations made

- Use genomic (marker) coancestry rather than pedigree coancestry when optimising contributions, because "pedigree coancestry is not a good estimator of the true coancestry when genomic relationships are used in the optimisation of contributions" (page 5).
- When targeting specific regions, always add a genome-wide restriction: "an additional constraint was imposed to restrict the excessive loss of diversity across the rest of the genome" (page 6).
- Prioritise regions of high diversity loss for management: "regions that display a greater loss of diversity should be prioritized to better avoid further loss of diversity in those regions" (page 12).
- Choice of relationship-matrix type should match conservation goal: "the choice of how coancestry is quantified may depend on which of these two objectives is more important" (page 12).
- Contribution theory needs revision for genomic matrices: "a revision of contribution theory is needed to properly use genomic relationship matrices" (page 11).
- SDP is the recommended optimisation algorithm: "The SDP approach guarantees that the solution found is the optimal" (page 11).

## Documented failure modes

- **Bias in constraint fulfilment**: expected $\Delta f_{m\_ove\text{-}chr}$ always satisfied the 0.1% restriction, but realised rates were "approximately 1.4, 0.3 and 0.2 % for N = 20, 100 and 200, respectively" against a 0.1% target — a >10-fold overshoot at N=20 (page 7).
- **Doubling of intended coancestry**: in the resampled-offspring check, "the observed rate of coancestry was approximately double the intended rate" across three independent parent sets (page 8).
- **CHR_ove/REG_ove overshoot**: "for N = 20, a realised Δf of about 2 % was obtained for both CHR_ove and REG_ove when the constraint was 1 %" (page 7).
- **OVE_reg constraint violation**: "the realised values did not fulfil the imposed constraint (i.e. the realised Δfm_reg was greater than the C used)" (page 8).
- **Mutation-rate/LD dependency of OVE**: with higher mutation rate (μ=2.5×10⁻³, lower LD), "the advantage of OVE over PED... was only observed for the first generation and Δfm_ove became slightly higher under OVE than under PED in later generations" (page 5).
- **Trade-off cost of targeted regional minimisation**: "for N = 20, Δf for the rest of the genome with REG and CHR was respectively two and three folds higher than the observed Δf with PED. For N = 100, these differences were five and nine folds higher" (page 5–6).
- **Structural invalidity of cross-product/VanRaden-type matrices as coancestry estimators**: values can fall "clearly outside the valid range for a coefficient of coancestry (i.e., [0:1])" and centering "makes the matrix non-invertible," complicating SDP (page 12).
- **Systematic downward bias of f=c'Gc**: "the expected value predicted with the equation was consistently biased downward and the magnitude of this bias depended on the population size (the smaller is N, the greater is the bias)" (page 11).
- **Non-positive-definite / non-invertible genomic matrices in practice**: missing SNP genotypes can make pairwise coancestries computed on different SNP subsets non-positive-definite; small regions or SNP counts below candidate count can make G singular (page 12).

## Optimisation / algorithmic content

- **Optimisation problem 1** (minimise overall/regional coancestry): $\min c'Gc$ s.t. $c's=0.5$, $c'd=0.5$, $c_i\geq0$ (page 2).
- **Optimisation problem 2** (minimise target coancestry with restrictions elsewhere): $\min c'Gc$ s.t. $c'G_jc\leq k_j$ ($j=1,\dots,m$), $c's=0.5$, $c'd=0.5$, $c_i\geq0$ (page 3).
- **Solution method**: semidefinite programming (SDP), reformulated per Pong-Wong and Woolliams [15] using an auxiliary variable $v$ and Schur complements, solved with the SDPA package (page 3, 13–16, full derivation in Appendix).
- **Convexity requirement**: "constraints and objective functions need to be convex... the coancestry matrices must be positive definite" (page 12).
- **Practical fixes noted for non-PD/non-invertible G**: adding a small constant to the diagonal, or using the Moore–Penrose generalised inverse — "consequences of this for optimality... are yet to be quantified" (page 12).
- **Algorithm comparison** (qualitative, no benchmarked runtimes): Lagrange multipliers "fast and very efficient but does not guarantee the optimal solution"; genetic algorithms "very flexible... but... can be computer intensive, depending on the constraints included," and optimality "cannot be verified"; SDP "guarantees that the solution found is the optimal... also fast and flexible" (page 11–12).
- **Problem sizes tested**: N = 20 and 100 candidates per generation (200 additionally in Fig. 1 supplementary check); 20 chromosomes × 1 Morgan; nloci = 2000 (μ=2.5×10⁻³) or 60,000 (μ=2.5×10⁻⁵) per genome, yielding ~24,000–26,000 segregating SNPs; 10 generations of management; 100 replicates per scenario (page 3–4, 7).
- **Runtimes**: not addressed — no wall-clock or complexity-class statement is given anywhere in the text.

## Relevance to: choos