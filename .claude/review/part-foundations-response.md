# Response to part-foundations.md (continuity round)

| ID | Status | Change |
|---|---|---|
| C1 | fixed | 01 "Reading the diagonal": the promise is replaced by the result 03/05b deliver -- the expected F1 heterozygous fraction is one minus the mean A-B coancestry and does not depend on neutral divergence (@sec-heterosis-flat); 03 measures it flat across its `fst` grid. |
| C2 | fixed | index item 3, 02 "Base population" bullet and 02 closing paragraph now say what 02b shows: genic variance among A x B hybrids contains only the within-pool part of gene diversity (squared-effect weighted), not the between-pool term; proxy holds only through the within-pool part, with effects unrelated to which loci lose diversity, and is blind to disequilibrium. |
| C3 | fixed | index item 4: the budget is on $1 - \theta$ of the selected hybrids, which with inbred parents is within-pool + between-pool (@tbl-keystone); it does not isolate the within-pool loss, hence separate pool monitoring (@sec-stages). |
| C4 | fixed (in-scope side); 03 half deferred to 03 review | 90-notation: parameter gets its own symbol $F_{BN}$ (`fst`), mapping stated for 03/05b/07/08/12; new chunk `notation-fst-parameter` verifies $E$-ratio $\approx F_{BN}/(2-F_{BN})$ (0.0814 vs 0.0811, tol 0.005) and computes the book_cfg statistic (0.102; 0.084 with diagonal dropped) inline. Terms entry corrected. 02b captions/prose now say "Balding-Nichols `fst` = 0.15". 03:43-48 ("`fst` *is* the expected between-pool divergence", $F_{ST}$ symbol) deferred to 03 review. |
| C5 | fixed (meaning conflict in 02b); dedup deferred to 09 review | 02b: $\alpha$ inherits the restriction, not the zero -- an inequality $\alpha \le \alpha_{\max}$ against a same-size random subset, bounded rather than held at zero; consistent with 09:70-73. Removing the duplicated derivation/callout and the third budget-vs-lambda sentence from 09 deferred to 09 review. |
| C6 | deferred to 09 review | Invalid G in 09:55; 02b's example is untouched (already PD-asserted). |
| C7 | fixed | 02b criteria vector renamed $\mathbf{c} \to \boldsymbol\xi$ (unused elsewhere in the book); added to the 90-notation response table, "not the contributions $\mathbf{c}$". |
| C8 | fixed (in-scope side); 03 symbol deferred to 03 review | 02b merged frequency now $\bar p_k$, $\bar q_k$ (matches 90 heterosis table). 90 response table documents $\bar p_k$ and that 03 writes $p_{A,k}$ for $p_{Ak}$ and $p_k$ for the ancestral frequency. 01:63 $p_k$ (VanRaden population frequency) left as is: generic allele frequency per 90 general table. Renaming 03's ancestral symbol deferred to 03 review. |
| C9 | fixed | 02 "Equal contributions": with census weights $\bar f$ is the group coancestry $\theta$, so $N_s = 1/(2\theta)$ and $GD_T = 1 - \theta$ (asserted in `keystone-check`); 90 $\theta_S$ row states the same. |
| C10 | fixed | 01: $F_i$ is the "molecular inbreeding coefficient", explicitly not the population-level `F_hom`; code comment aligned. |
| C11 | fixed (02b close); 03 opening deferred to 03 review | 02b "Where this connects" ends with a pointer to @sec-simulating-crosses as the next part. |
| C12 | fixed | 02b intro: paragraph defining `simulate_pools()` (Balding-Nichols pools, 0/1 lines, factorial X, QTL effects, index construction with $h^2$) and pointing to @sec-simulating-crosses. |
| C13 | fixed | 02:11-12: "special case" replaced by "the $\alpha$ constraint of @sec-ocs bounds its total (@tbl-keystone)", a claim 02 itself supports. Nothing needed in 09. |
| C14 | deferred to 03 review | Both defects are in 03:99-108; 02 already defers the reason to @sec-heterosis and its drift arithmetic is correct. |
| C15 | fixed | 90 partition table: $GD_{WS}$ = within-pool diversity, equal to $GD_{BI}$ with inbred lines, the term recurrent selection erodes (@tbl-keystone). index item 2: partition "derived in @sec-subdivided and reported in @sec-catalogue". |
| C16 | fixed | 90: heterosis-table and OCS $\lambda$ rows now disambiguate each other; $r$ pointer now names the genomic-prediction table above and the response table below. |
| C17 | fixed | 02 OCS bullet: $\mathbf{u}$ is the vector of selection-criterion values (EBVs in @meuwissen1997, the multi-trait index $u_i$ in @sec-ocs). |

Verification: `make_downloads.R` run; 01, 02, 02b, index, 90 purled and sourced from `book/` with `_common.R`, no error or warning. No render. No chunk label renamed; every existing `stopifnot` kept.

## iteration 2

| ID | Status | Change |
|---|---|---|
| C2 | fixed | 02 "Base population" bullet now separates the two cases. Intermated mixture: $GD_T = 1 - \sum f_{ij}c_ic_j = \operatorname{mean}_k 2\bar p_k\bar q_k$ with $\bar p_k = \sum_i c_i p_{ik}$ (between-source term kept), HWE 0/0.5/1 genotype variance $\bar p_k\bar q_k/2$, genic variance $\sum_k\beta_k^2\bar p_k\bar q_k/2 = m\beta^2 GD_T/4$ under equal effects, so maximising $GD_T$ maximises genic variance; unequal effects differ by the squared-effect weighting. Never-intermated A x B hybrids: within-pool part only (@sec-response). LD caveat kept for both. No number stated. Checked in scratch: identity $GD_T$ = mean $2\bar p\bar q$ exact (all.equal, 4 sources, 500 loci, seed 1); simulated HWE genic variance 0.5058 vs $m\beta^2GD_T/4$ = 0.5054 (50 loci, 2e5 individuals, seed 2). |
| C4 | fixed | 90 heterosis table, $\bar H$ row: "its Balding-Nichols expectation falls as $(1 - F_{BN})^2$". |
| F-M1 | fixed | 90 mapping paragraph now lists @sec-simulating-crosses, @sec-heterosis, @sec-choosing, @sec-stages, @sec-plant-literature, @sec-case-study and @sec-verification (grep of `F_{ST}` over book/*.qmd: 03, 05b, 07, 08, 11:333, 12, 92:57/378 use the parameter; 02, 04c, 04f, 05 use the statistic). |
| F-M2 | fixed | index item 4: "the loss of gene diversity, $\alpha$, is a budget: the relative shortfall of the selected hybrids' $GD_T = 1 - \theta$ ... below that of a random selection of the same size" (matches `make_fitness()`, R/03_de_select.R:178). |

Verification: `make_downloads.R` run; 02, 90, index purled and sourced from `book/` with `_common.R`, no error or warning. No render.
