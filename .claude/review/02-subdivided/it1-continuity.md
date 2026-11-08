# Continuity review, chapter 02-subdivided, iteration 1

Scope: `book/02-subdivided.qmd` against `index.qmd`, `00-hybrid-programme.qmd`, `01-coancestry.qmd`, `90-notation.qmd`, `R/01_metrics.R` (`gd_partition`), `R/07_caballero_toro.R`, and every forward target (09, 05b, 06, 07, 08, 11b, 11c, 02b). Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-01-05`, branch `review-01-05`. Checks 1-4, 6, 8, plus the chapter-mode questions. `file:line` below are line numbers of that worktree. Nothing in the book was edited. Counts: H 2, M 10, L 6 (18 findings). By primary owner: 02-subdivided 17, 08-pipeline-stages 1. Secondary owners are named per finding.

Source check done: the local Caballero & Toro (2002) PDF (`reference/papers/Analysis_of_genetic_diversity_for_the_management_o.pdf`) was read for the worked example. The upper triangle of the matrix (0.3391, 0.3021, 0.2535, 0.3229, 0.3073, 0.3889, 0.2483, diagonal 0.8750, 0.4766, 0.3704), `s~` 0.7056, `f~` 0.4535, `f-bar` 0.3256, F_ST 0.1897, GD_T 0.6744, GD_WI 0.2944, GD_BI 0.2521, GD_BS 0.1279, the contributions (0.522, 0, 0.270, 0.208) and the census-weight loss/gain (-6.6, +1.8, -3.9, -0.8) all match the chapter. Also reproduced by running `ct_loss_gain()` / `optimal_contributions()` on the chapter's matrix (GD_T 0.6744 -> 0.6874; delta_pct 2 = 1.84 census, 6.47 equal). The toro2005 text and Cockerham (1969) were not read (UNVERIFIED).

## Findings

### 02-C1 (H) -- the reference of f is stated as "a base in which all alleles are distinct", against what 01 and 00 establish
- `02:61-64`: "the reference is a base in which all alleles are distinct, so $f_{ij}$ between unrelated lines is already high on a biallelic panel". The clause does not entail the conclusion: with a base of all-distinct alleles unrelated pairs would sit at 0. `02:119-121` (callout on $F_i$): "measured against a hypothetical base in which all alleles are distinct. It is not comparable across studies using different marker panels." Same phrase at `90:179`.
- `01:238-256` (and `00:465-475`, `00:514-524`): $f_{ij}$ is identity in state; Caballero & Toro's equivalence of molecular and pedigree coancestry requires all alleles distinct, "which biallelic markers cannot satisfy" (01:239-242); the expected unrelated level is the base-population floor $m^{-1}\sum_k(p_{b,k}^2+q_{b,k}^2)\ge 1/2$, and the observed level is the panel floor, an identity of the set (01:305-336, @tbl-panel-floor: 0.5271 on MAF > 0.30 markers, 0.8710 on MAF < 0.15).
- The conclusion of 02:61-64 (no fixed level marks redundancy; compare on one panel) agrees with 01, but the stated mechanism is the opposite of 01's. Neither 02:64 nor 02:120 names the floor or points to @tbl-panel-floor, which is the direct evidence for the "not a threshold carried over from another panel" sentence (02:84-87).
- Owner: **02** (02:61-64, 02:119-121); `90:179` follows (later fix, 90 owner).

### 02-C2 (H) -- F_ST: attribution and name contradict 08; 00-C1 is still open
- `02:218-225`: $F_{ST}=(\tilde f-\bar f)/(1-\bar f)=\bar D/(1-\bar f)$ presented as "Wright's fixation indices [@wright1951] written in coancestries", the $\bar D$ form "due to @cockerham1969". `02:258` and `90:123` identify it with $GD_{BS}/GD_T$; `00:575-581` agrees ("here, as in @sec-subdivided, $GD_{BS}/GD_T$").
- `08:86-106` (Trap 2): the expression $(\theta_w-\theta_T)/(1-\theta_T)$ (= 02's $F_{ST}$, with $\theta_w=\tilde f$, $\theta_T=\bar f$) is named $G_{ST}$ and attributed to Nei; the name $F_{ST}^{(W)}$, Wright's, goes to the different expression $(\theta_w-\theta_B)/(1-\theta_B)$. Same number printed under two names, and "Wright" attached to different formulas. `00:577-581` already declares the clash from 00's side.
- Source: C&T 2002 (local PDF, p. 291, Eq. 6) writes exactly 02's formula and calls them "Wright's (1969) F-statistics"; 02 cites @wright1951 instead (a different Wright work, not checked here, UNVERIFIED), and routes the $\bar D$ form through Cockerham via toro2005 (not read).
- Owner: **08** (primary: its "Wright" label for $(\theta_w-\theta_B)/(1-\theta_B)$ and its renaming of 02's statistic; also 08-C items owed from 00); **02** secondary (cite the source's attribution once the 08 decision is taken; state in one sentence that the form is also called $G_{ST}$ in @sec-stages, since 90 has no $G_{ST}$ row, owed from 00).

### 02-C3 (M) -- the opening does not say why 02 follows 01 (or 00); owed 01-C12
- `02:8-20`: opens with "A breeding programme is never one population", cites @caballero2002, @sec-ocs, @tbl-keystone, @sec-ct-removal. No citation of 01, of $\mathbf f$, or of 00. First citation of 01 is `02:64` (parenthetical); `02:536` the second. `02` cites no `@sec-hp-*` anywhere, although 00 forward-points to it seven times (`00:181`, `00:336`, `00:401`, `00:442`, `00:576`, `00:720`, `00:742`).
- `01:531-533` hands over precisely: "@sec-subdivided takes $\mathbf f$ and asks what happens when the population it describes is not one population, but several." 02's content fits that sentence, but the chapter never says it takes $\mathbf f$ (the individual-level matrix of @eq-f-molecular) and re-expresses it at the level of subpopulations (see 02-C7).
- Also at 02:12 $\alpha$ is used as "the $\alpha$ constraint of @sec-ocs" before any definition in this chapter; the definition is in 00 (`00:313-316`) and `06` (@eq-catalogue-alpha), and 02 itself re-uses the letter for $\alpha_i$ at 02:131.
- 00:709-732 (three departures) is not cited; the opening's "which term of it you are allowed to minimise" (02:13-14) is departure 2 of 00.
- Owner: **02**.

### 02-C4 (M) -- bare $\theta$ for the group coancestry; owed 01-C9
- `02:536`, `02:538`, `02:647`, `02:650` (table note: "$\theta$: mean coancestry of the selected hybrids"), and the variable `theta` at `02:660`. `01:103-114` and `90:70` use $\theta_S$; `00:385-406` defines $\theta_S$ for a set $S$. "$N_s$ is then the $1/(2\theta)$ of that chapter" (02:537) names a symbol that 01 does not use bare.
- The same bare form also sits in `index:101`, `90:569`, `90:627`; those are other chapters' owners.
- Owner: **02**.

### 02-C5 (M) -- $N_s=1/(2\bar f)$ presented as "the $1/(2\theta)$ of that chapter", but the scale 01 and 00 establish does not hold in the chapter's worked example
- `02:533-539`: "Minimising $\bar f$ maximises the status number $N_s=1/(2\bar f)$ ... this $N_s$ is then the $1/(2\theta)$ of that chapter".
- `01:111-114` and `00:701-707`: on molecular $\mathbf f$ at biallelic markers $\theta_S\in[1/2,1]$ and $N_s\in[1/2,1]$ for every set, a monotone rescaling, not a head count; `90:627-631` the same.
- The chapter's worked example is multiallelic (3 loci with 5, 3, 3 alleles, 02:363-364): $N_s=1/(2\times0.3256)=1.536$ (computed), outside $[1/2,1]$. The chapter never says that 01's range is a property of biallelic markers and of the book's panels, nor that its own $N_s$ for the example is not on that scale. A reader following "the $1/(2\theta)$ of that chapter" would expect $\le 1$.
- Assumption (check 8): biallelic panel (01, 00, 90) against multiallelic example (02).
- Owner: **02**.

### 02-C6 (M) -- the bridge from "subpopulations of individuals" to "a set of hybrids partitioned over parent lines" is not stated
- `00:385-406` (esp. 00:402-404): for a set of hybrids the partition is taken over their parent lines, each weighted by its use, so with inbred parents $GD_{WI}=0$. `R/01_metrics.R` `gd_partition()`: subpopulations are the two pools, weighted by line usage; $\bar f=(\theta_A+2\theta_{AB}+\theta_B)/4$ (equal pool weights, one A and one B parent per hybrid); $\tilde s$ is the mean self-coancestry of the parent lines; `GD_WI_hyb` is a separate hybrid-level term `1 - mean(diag(f)[idx])`.
- `02:536` says "With census weights $N_i/N_T$ ... whatever the subdivision" and `02:646-647`, `02:652-666` apply the partition to "selected hybrids" with `gd_partition()`, but the chapter nowhere says that (a) the "individuals" of the partition are then the parent-line slots, (b) the weights are usage weights, equal across the two pools by construction, and (c) $GD_{WI}$ (lines) and $GD_{WI\text{-}hyb}$ (hybrids) are the same formula $1-\tilde s$ over different "individuals". The assertion `all.equal(1 - theta, GD_T)` in `keystone-check` hides this: it holds through the line-level identity of 00/01 ($F_{(ab)}=f^L_{ab}$, $\theta_S=\mathbf w'\mathbf f^L\mathbf w$, 00:537-559), which 02 does not cite. Pools of 25 + 25 lines make census and usage weights coincide, so the check cannot tell them apart.
- Owner: **02** (cite 00:385-406 and 00:537-559 at 02:536 and at the table note); `06:382` (@sec-catalogue) already states the usage weights.

### 02-C7 (M) -- $f_{ii}$, $s_i$, $F_i$ mean subpopulation quantities here and individual quantities in 01 and 00, without a bridge in 02
- `02:89-94`, `02:103-104`: $f_{ii}=\sum_k\tilde p_{k,i}^2$ is the group coancestry of subpopulation $i$ (all pairs of its individuals, self-pairs included); $s_i$ the mean self-coancestry over its individuals.
- `01:229-234`, `00:527-533`: $s_i=f_{ii}=(1+F_i)/2$ is the diagonal element of $\mathbf f$ for one individual $i$.
- `90:80-81` records both meanings; 02 never says that the matrix it calls $f$ (n x n, subpopulations; `02:369-373`, `02:486`) is not the $\mathbf f$ of 01 (N x N, hybrids), nor that $f_{ij}$ of 02:53-55 is the block mean of 01's @eq-f-molecular. 02 uses $\mathbf f$ in bold for the 4 x 4 matrix (02:406, 02:415, 02:442, 02:481-495) and in the OCS bullet for the candidates' matrix (02:521-523). Inside 02, `02:181` uses $f_{ll'}$ for single individuals, which is 01's meaning.
- Owner: **02** (one sentence at the Notation list, 02:24-36).

### 02-C8 (M) -- the index $k$ is an allele in the first half of 02, a locus in the second half, and a marker in 01
- `02:54-55`, `02:91`, `02:103`, `02:169`: $k$ indexes alleles ($f_{ij}=\sum_k\tilde p_{k,i}\tilde p_{k,j}$, "k indexes an allele" is said only at `02:110-111`).
- `02:502-510`: $\bar p_k$, $\beta_k$, "every one of the $m$ loci": $k$ indexes loci. `01:210-234` (@eq-f-molecular) and `90` ($p_k$, $x_{ik}$): $k$ is a marker.
- The reconciliation "per locus then averaged" (02:35) is a bullet in the Notation list, not attached to eq. at 02:54, which as printed is the multiallelic single-locus form; for the biallelic case actually used by the package it is $m^{-1}\sum_k(p_ip_j+q_iq_j)$ (R/07_caballero_toro.R). The local $\tilde p_{k,i}$ uses a tilde for a subpopulation mean of individuals, whereas the Notation bullet at 02:28 defines the tilde only as a weighted mean across subpopulations.
- Owner: **02**.

### 02-C9 (M) -- @tbl-keystone row 2 attributes the erosion of $GD_{BI}$ to recurrent selection; the chapter's own argument and 00 do not separate selection from drift
- `02:647`: "$GD_{BI}$ ... the one recurrent selection erodes (@sec-cycles)"; `90:118` repeats it.
- `02:354-359`: the within-pool loss is shown under drift alone ("Selection is not covered by this argument"). `00:333-341`: the rise of $GD_{BS}$ under `run_cycles()` is a simulation result "with drift and selection acting together, so neither is isolated".
- Target: `11b:409-411` reports the `GD_BS` column (rising) and says "$GD$ within them falls"; 11b has no $GD_{BI}$ column and no arm without selection (the 11b items owed from 00-C5). So @sec-cycles shows within-pool diversity falling under selected arms, not that selection is what erodes $GD_{BI}$.
- Owner: **02** (reword the row: erodes under drift and, in the simulations of @sec-cycles, under selection); **11b** secondary (what it can claim).

### 02-C10 (M) -- @tbl-keystone row 3 states "the heterosis engine" and "an exact identity in @sec-heterosis" without the conditions of that identity
- `02:648`: "$GD_{BS}$ | between pools | the heterosis engine, to be preserved not minimised -- derived as an exact identity in @sec-heterosis".
- `05b:215-235` (@tbl-het-partition-identity): the identity holds with flat dominance $d_k\equiv1$, inbred lines and the complete A x B factorial; $GD_{BS}$ weighted by $d_k$ is the divergence half of expected heterosis. `index:68-69`, `index:84-86`, `00:72-74` and `90` (Terms: "only the divergence that coincides with dominance. Divergence produced by drift alone generates none") carry the dominance condition.
- Within 02, `02:676-679` ("pushing the pools apart buys nothing") and `02:648` ("engine") are reconciled only by reading 05b. The row as printed is the unconditional form.
- Owner: **02** (add the condition to the row or its note).

### 02-C11 (M) -- @eq-ne-meta: assumptions stated, but not reconciled with 00's sampling-unit result or with the book's inbred pools
- `02:545-557`, `02:570-594`: $N_e\approx 2Nn/[(V_W+V_B+1)(1-F_{ST})]$ for $n$ subpopulations of $N$ randomly mating individuals; equalising contributions doubles $N_e$ (V_W 0 against 1).
- `00:616-640`, `00:696-700`: "the sampling unit matters by a factor of two": a crossing block of $n$ plants passes $2n$ copies ($N_e=n$, consistent with $V_W=1$ here), a pool of $n$ DH lines passes $n$ copies ($N_e=n/2$). 02's $N$ and "individuals" are diploid random-mating plants; the book's pools are DH or inbred lines, where the formula's reading of $N$ is off by 2. 02:349-350 says only that clonal crops "need adaptation"; 02:344-347 (selfers, DH collections) gives no $N_e$ guidance.
- The source (C&T 2002 Eq. 14, local PDF) has $(1-F_{IT})$, which equals $(1-F_{ST})$ only when $F_{IS}=0$; 02:552 states random mating within subpopulations, but for pools of inbred lines $F_{IS}\neq0$ ($G_i\to1$, 02:160-162), so the F_ST form of eq. is outside its own assumption for the book's pools.
- Owner: **02**.

### 02-C12 (M) -- the sources note says the 2002 paper was not accessible; it is, and 01 used it
- `02:630-633`: "Only the 2005 review was accessible when this chapter was checked; values attributed to the 2002 paper ... are transcribed from it and were not re-checked against its full text."
- THREAD entry 01 and `01:238-242`: Caballero & Toro (2002, p. 292) quoted and "checked against the local PDFs". The 2002 PDF is in `reference/papers/`. Done in this review: the matrix (upper triangle), $\tilde s$, the global quantities, the contributions and the census-weight removal column match the paper (Table 3). The paper's own pig-breed Table 5 already prints FRBA +0.67 (02:466-467 attributes it to the 2005 table [Table 4]); the footnote correction concerns DESH.
- Owner: **02** (update the statement and the attribution of the 0.67 %; the 2005 table remains UNVERIFIED).

### 02-C13 (L) -- one quantity, two symbols: pool coancestries
- `02:354-356`: $f_{AB}$, $f_{AA}$, $f_{BB}$. `90:205`, `90:226`, `R/01_metrics.R` `theta_pools()`, `00:575-581`, `08:86-106`: $\theta_A$, $\theta_B$, $\theta_{AB}$ (usage-weighted; equal to 02's census versions when weights coincide).
- Owner: **02** (name the correspondence once) or **90**.

### 02-C14 (L) -- symbols used, not defined where used
- $\bar D$ at `02:219` is defined only at `90:183`; $\tilde F$ at `02:218-220` and the indices $F_{IS}$, $F_{IT}$ have no definition in 02 beyond the formulas (the tilde bullet at 02:28 names $\tilde f$ only) and no `90` row ($F_{IS}$ occurs in `90:181` only as an analogue). $H_{e,i}$ appears in `90:80`, defined in eq-fii-he.
- Owner: **02**; **90** row.

### 02-C15 (L) -- "frequency-based quantity" for $GD_T$ and genic variance
- `02:515-516`: "neither frequency-based quantity sees linkage disequilibrium". `01:493-531` and `00:463-465` use "frequency-based" for the metrics that read `colMeans(X[idx, ])` and `ctx[["p0"]]` and never `ctx[["f"]]` (`theta_from_freq()`, `he_nei()`, `F_drift`, `F_hom`); $GD_T=1-\theta$ is classified there as coancestry-based (`gene_diversity()`), although numerically equal to $H_e$ (@eq-hp-gd). The word is used in a third way here.
- Owner: **02**.

### 02-C16 (L) -- redundancy and missing cross-references
- `02:41-46`, `02:91-94`: the identity $1-f_{ii}=H_e$ and the plug-in remark are restated; `00:385-406` (@eq-hp-gd) states them for a set, `06:80` (@sec-identity) derives them, `90:569` repeats them. 02 cites neither @eq-hp-gd nor @sec-identity.
- `02:499-516`: the genic variance of a mixture base ($m\beta^2GD_T/4$) is a derivation that belongs to `02b:160-232` (@eq-response-genic, @eq-response-hybrid-var); 02b opens with "Every chapter so far measures what selection spends. None of them writes down what it buys" (02b:8-9), which 02:499-516 anticipates. 02 cites 02b forward correctly; owner of the derivation should be 02b, 02 a cross-reference.
- Owner: **02** (cross-reference); 02b keeps ownership.

### 02-C17 (L) -- stage S1 named without a definition; 00 assigns it to this chapter
- `00:181`: @tbl-hp-stages, S1 "conserving the heterotic groups (pool level)" -> @sec-subdivided, @sec-stages. `02:673` names "stage S1" as 08's job; 02 does not cite @tbl-hp-stages, and nowhere says that the partition is the S1 tool (the keystone paragraph 02:669-674 is the nearest). Part review introduction-C4 owns the S1-S4 vocabulary question.
- Owner: **02** (one citation at 02:673), 00 if the table is to stay as is.

### 02-C18 (L) -- $c$, $u$, $\mathbf f$ in the OCS bullet change object
- `02:481-495`: $\mathbf c$ are contributions of subpopulations, $\mathbf f$ the n x n subpopulation matrix. `02:521-529`: $\mathbf c$, $\mathbf u$, $\mathbf f$ are contributions, criterion values and coancestry of candidates (N x N), "the multi-trait index $u_i$ in @sec-ocs". `09:21-28` and `90:278` use $\mathbf c$, $u_i$ with the candidate meaning. Distinct objects under one symbol set inside a bullet list.
- Owner: **02**.

## Checked and consistent (not findings)
- Forward references resolve: @sec-ocs (09:1), @sec-heterosis-flat (05b:467), @sec-heterosis (05b:1), @sec-catalogue (06:1), @sec-cycles (11b:1), @sec-stages (08:1), @sec-response (02b:1), @eq-response-genic (02b:170), @sec-limits (11c:1), @sec-choosing (07:1), @sec-coancestry (01:1), @sec-notation (90:1). No broken `@sec-` target anywhere in the book (script over all `.qmd`). Citation keys caballero2002, cockerham1967, nei1973, toro2005, wright1951, cockerham1969, meuwissen1997, lindgren1997, falconer1996 exist in `references.bib`.
- Promises kept: 02:19 (@sec-ct-removal) in the chapter; 02:358/676 -> 05b "Divergence is not a bonus" (05b:467); 02:614 -> 07:258 (allelic richness as the non-redundant axis); 02:673 -> 08:67 (S1 section); 02:687-688 -> 11c. 03:187-191 verifies the chapter's drift expectations (ratios 1 and 2) as 02:354-357 derives them ($\Delta f$ rise, GD_WS -Delta, GD_BS +Delta/2, GD_T -Delta/2). 00:336 and 00:742 point to 02 for the drift argument and the partition; both are delivered.
- Settled from earlier chapters: `ctx[["f"]]` use in the 02 chunks is the coancestry-based one; 02's identities (`GD_T = GD_BI + GD_BS` with inbred parents, `GD_WI_hyb = H/2`) agree with 00:385-447 and 01's $s_i=(1+F_i)/2$; the heterozygous fraction identities of 01:360-380 do not conflict with 02's $H_o=2(1-s)$.
- Numbers quoted: 19 % / "less than a fifth" (F_ST 0.1897), 4/3 and 2 for the $N_e$ gains (asserted), OCS 0.6744 -> 0.6874. The "equal weights" column of @tbl-ct-loss (-6.92, +6.47, -6.94, -3.56) differs from the paper's unweighted column (-6.8, +6.5, -7.0, -3.6) at the first decimal for subpopulations 1 and 3; the chapter does not compare the two, so this is not a contradiction, but the cause (rounding of the components or a different definition of "unweighted") is not established.

## Inbound `@sec-` count (current worktree)

Each `@sec-` resolved to the file that owns its `{#sec-...}`; citations from a file to itself discarded. `index.qmd` counted as a citing file (it owns no label). No unresolved targets.

| Chapter | Inbound | Citing files |
|---|---|---|
| 00-hybrid-programme | 22 | 7 |
| 01-coancestry | 26 | 14 |
| 02-subdivided | 40 | 14 |
| 02b-response | 28 | 14 |
| 05b-heterosis-dominance | 80 | 21 |
| 03-simulating-crosses | 28 | 16 |
| 04-population-sizing | 17 | 10 |
| 04b-backcross-introgression | 8 | 7 |
| 04c-alphasimr-pipeline | 21 | 11 |
| 05-genomic-era | 39 | 16 |
| 06-metric-catalogue | 43 | 19 |
| 07-choosing-metrics | 47 | 20 |
| 08-pipeline-stages | 39 | 18 |
| 08b-genomic-prediction | 26 | 14 |
| 09-optimal-contributions | 37 | 16 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 25 | 8 |
| 04e-mating-design | 58 | 8 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 11 | 4 |
| 11-plant-literature | 15 | 8 |
| 04d-breeding-programme | 19 | 6 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 19 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 18 | 7 |
| 91-package | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

02-subdivided: 40 from 14 files (00 x6, 03 x5, 04c x5, 05b x4, 06 x4, 90 x4, 04g x3, 92 x2, index x2, 01, 02b, 09, 11-plant-literature, 91 x1 each). Healthy. Differences from the part review's table (00: 9 -> 22) come from chapter 01 and the other review edits now in the worktree. Low, no owner change here: 91 (0, package reference appendix), 93 (2), 92 (5).
