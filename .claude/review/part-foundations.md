# Part-level coherence review: Foundations (01, 02, 02b) + index, 90-notation, seam into 03

Scope: book/01-coancestry.qmd, book/02-subdivided.qmd, book/02b-response.qmd, links to
book/index.qmd, book/90-notation.qmd, book/03-simulating-crosses.qmd. Settled decisions
(C&T eq. numbers removed, s_i = f_ii, G_0.5 = 4f - 2J, Sigma_P/Sigma_G, aggregate genotype W)
not re-raised. All paths relative to /Users/ederdbs/Documents/SB_quanti_gen-review/.

Counts: 17 findings -- 5 high, 7 medium, 5 low. Broken @sec- targets: 0.

## High

**C1 -- 01 promises the opposite of what 03 shows (fst vs F1 heterozygosity).**
book/01-coancestry.qmd:233-236 says more divergent pools "give more heterozygous F1 hybrids
and a diagonal closer to 0.5", and that @sec-simulating-crosses "puts [that relationship]
under experimental control". book/03-simulating-crosses.qmd:99-106 measures the
heterozygous fraction as flat across a twentyfold `fst` range, and
book/05b-heterosis-dominance.qmd:484-489 proves the total does not move. The forward promise
is kept by a refutation. Change: 01.

**C2 -- "gene diversity = genic variance with equal weights" is stated in index and 02, and
refuted in 02b.** book/index.qmd:87-92 ("genic variance is the same sum over the same loci as
gene diversity, weighted by squared effect instead of equally ... a variance constraint in
disguise"), book/02-subdivided.qmd:662-665 (same sentence, attributed to @sec-response) and
book/02-subdivided.qmd:503-504 ("@sec-response shows the two differ by the squared-effect
weighting"). book/02b-response.qmd:214-225 shows Var(x_k)/(p_k q_k) is not constant, that
gene diversity contains the between-pool term that genic variance subtracts, and that the
proxy holds "only through its within-pool part, and only if effect sizes are unrelated";
02b:227-243 adds the disequilibrium gap. The chapter that owns the claim says less than the
two that cite it. Change: index and 02 (02b is the owner).

**C3 -- What alpha budgets: index says within-pool, 02 says total.** book/index.qmd:93-95
("the loss of within-pool diversity is a budget ... alpha"); book/02-subdivided.qmd:628
(tbl-keystone: with inbred parents alpha budgets GD_T = 1 - theta = GD_BI + GD_BS, "not GD_BI
alone"). Consistent with CLAUDE.md (alpha is on theta/GD). Combined with C2, the index chain
(steps 3-4) argues for a within-pool constraint the book does not impose. Change: index.

**C4 -- F_ST names two different quantities.** As a statistic, (f~ - f-)/(1 - f-) =
GD_BS/GD_T: book/02-subdivided.qmd:218-220, :258; book/90-notation.qmd:98. As the
Balding-Nichols parameter `fst`: book/03-simulating-crosses.qmd:43-48 ("fst ... *is* the
expected between-pool divergence"), book/90-notation.qmd:395-397, and the captions/prose of
book/02b-response.qmd:51, :104, :149 ("F_ST = 0.15"). For two pools the expected statistic is
about F/(2 - F), not F; on `book_cfg` (fst = 0.15) the 02 partition statistic computed on fL
is 0.102 (checked in this review). A reader carrying 02's definition into 02b/03 reads the
wrong number. Change: 90-notation (give the parameter its own symbol), then 02b and 03.

**C5 -- alpha "inherits exactly zero" (02b) vs "bounded, not held at zero" (09); the
restricted-index argument is developed twice.** book/02b-response.qmd:385 (title "The alpha
constraint *is* a restricted index") and :423-425 ("moves the restricted trait by exactly
zero ... the property alpha inherits") versus book/09-optimal-contributions.qmd:70-73 (alpha
"is bounded relative to a resampling baseline rather than held at zero"). Same derivation and
example (P, G, a, R, index_restricted(), "exactly zero, not approximately", a "what is new"
callout with the same thesis) at 02b:385-438 and 09:44-75; the budget-vs-lambda sentence
appears a third time at index:40-44, 02b:387-389, 09:24-28. Owner: 02b (09:50 already says
"@sec-response derives their solution"); 09 should keep only a cross-reference plus its own
point about inequality vs equality. Fix the meaning conflict in 02b.

## Medium

**C6 -- Contradicting numbers in the duplicated example.** book/09-optimal-contributions.qmd:55
uses G = [2.0, 0.9; 0.9, 0.3] (det = -0.21, not a covariance matrix); book/02b-response.qmd:346-349
uses covariance 0.3 and asserts G and P - G are positive definite. Same example, different
inputs, and 09's is invalid. Change: 09 (falls out of C5).

**C7 -- Bold c reused inside the part.** Contributions summing to 1: book/90-notation.qmd:184,
book/01-coancestry.qmd:271-274, book/02-subdivided.qmd:481-513. "Vector of criteria c" in
book/02b-response.qmd:319-326 and :330. Same symbol, same part, adjacent chapters, and 02
uses c'u / c'fc three pages earlier. Change: 02b.

**C8 -- p_k: one symbol, two quantities across the seam; one quantity, two symbols in the
appendix.** p_k = hybrid-population frequency = (p_Ak + p_Bk)/2 in
book/01-coancestry.qmd:63 and book/02b-response.qmd:190; p_k = ancestral Balding-Nichols
frequency in book/03-simulating-crosses.qmd:43-47. The notation writes the merged-pool
frequency as p-bar_k (book/90-notation.qmd:136, and :25 "the bar denotes a group mean").
Also p_{A,k} (03:43) vs p_{Ak} (02b:188, 90:346, 05b:180). Change: 03 (ancestral symbol),
90-notation or 02b (pick p-bar_k or p_k for the merged frequency).

**C9 -- theta and f-bar are the same quantity with two symbols, never equated.**
theta = n^-2 1'f1 and N_s = 1/(2 theta) at book/01-coancestry.qmd:92-97 and
book/90-notation.qmd:63-65; f-bar and N_s = 1/(2 f-bar) at book/02-subdivided.qmd:520; GD_T is
1 - f-bar in eq-gd-partition (02:230, 90:86) but 1 - theta in tbl-keystone (02:628) and
keystone-check (02:641-645). Nowhere is theta_S = f-bar (individuals as subpopulations)
stated. Change: 02 (or 90-notation).

**C10 -- F_i named "molecular homozygosity" in 01, "molecular inbreeding" in 02/90, while
"homozygosity lens" is F_hom.** book/01-coancestry.qmd:167 vs book/02-subdivided.qmd:101, :118
and book/90-notation.qmd:110; F_hom (1 - mean(H_t/H_0), can be negative) at
book/90-notation.qmd:164-166. Calling F_i "homozygosity" invites conflation with F_hom.
Change: 01.

**C11 -- Seam into Simulation has no transition on either side.** book/02b-response.qmd:440-448
closes pointing to 05/06/08b/07/09/11c, not to the next part; book/03-simulating-crosses.qmd:8-16
opens on the stage-1 contract with no mention of Foundations or of why simulation follows the
response equation. Change: 03 opening (primary), optionally 02b close.

**C12 -- 02b uses a generator the book never introduces before (or in) 03.**
book/02b-response.qmd:25-29 is the first appearance in the book of `simulate_pools()`
(arguments n_qtl, h2; `sim$beta`, `sim$index` "what the breeder actually sees"); 03
(the generator chapter) never presents it (it uses simulate_lines/simulate_data). No pointer
says where the QTL/index model is defined. Change: 02b (pointer) or 03 (introduce it).

## Low

**C13 -- Unkept promise: "the constraint in @sec-ocs is a special case of [the partition]".**
book/02-subdivided.qmd:11-13. book/09-optimal-contributions.qmd never states or shows this; its
only @sec-subdivided citation (09:347) is about optimal_contributions(). Change: 02 or 09.

**C14 -- 03 sends the reader to 02 for a reason 02 does not give, and contradicts 02's drift
arithmetic.** book/03-simulating-crosses.qmd:106-107 ("@sec-subdivided is why GD_BS is
nonetheless held rather than minimised"): 02 asserts it and defers the reason to @sec-heterosis
(02:629, 657-660). 03:99-101 says divergence is paid "out of within-pool diversity, unit for
unit"; 02:354-358 says GD_WS falls by Delta while GD_BS rises by Delta/2 -- one-for-one holds
between GD_T (the shared term) and GD_BS, not within-pool. Change: 03.

**C15 -- Which term "erodes".** book/02-subdivided.qmd:628 (GD_BI "the one recurrent selection
erodes") vs book/90-notation.qmd:93 (GD_WS "what erodes -- defend it"). Equal with inbred lines,
but the two tables name different rows. Also book/index.qmd:85-86 attributes "the partition" to
@sec-catalogue, while 02 derives and owns it (02:618-623). Change: 90-notation, index.

**C16 -- Notation appendix: lambda triple, r pointer.** lambda = within/between weight
(book/90-notation.qmd:142), OCS penalty (:189, used at 02:513, 02b:389), GP variance ratio
(:211); only the GP one is disambiguated, the heterosis/OCS pair is not. book/90-notation.qmd:274
says r "in the next table" is accuracy, but the next table (Sparse testing, :277-294) has no r;
accuracy r is at :206 and :340. Change: 90-notation.

**C17 -- Bold u: index in OCS (book/09-optimal-contributions.qmd:19, book/90-notation.qmd:182
u_i "multi-trait index") vs "vector of breeding values" in the same OCS formula at
book/02-subdivided.qmd:510-511 (and GP u at 90:208); 02b u_k is an allele (90:347). Change: 02
(align with 09's reading in the OCS sentence).

## Inbound @sec- citations (from other files; self-references excluded)

| Chapter | Inbound |
|---|---|
| index | 0 (preface; expected) |
| 01-coancestry | 19 (13 files) |
| 02-subdivided | 23 (13 files) |
| 02b-response | 22 (12 files) |
| 03-simulating-crosses | 18 |
| 04-population-sizing | 12 |
| 04b-backcross-introgression | 4 |
| 04c-alphasimr-pipeline | 17 |
| 04d-breeding-programme | 15 |
| 04e-mating-design | 47 |
| 04f-sparse-testing | 35 |
| 04g-joint-allocation | 9 |
| 05-genomic-era | 25 |
| 05b-heterosis-dominance | 65 |
| 06-metric-catalogue | 33 |
| 07-choosing-metrics | 40 |
| 08-pipeline-stages | 27 |
| 08b-genomic-prediction | 22 |
| 09-optimal-contributions | 33 |
| 10-combinatorial-selection | 28 |
| 10b-advanced-selection | 23 |
| 11-plant-literature | 8 |
| 11b-diversity-across-cycles | 45 |
| 11c-limits | 16 |
| 12-case-study | 19 |
| 90-notation | 4 |
| 91-package | **0** (outside scope; @sec-package is never cited) |
| 92-verification | 5 |
| 93-corpora | 2 |

No Foundations chapter is under-cited. Broken targets: none.

Forward promises verified as kept: 02 -> @sec-ct-removal, @sec-catalogue (GD_WI exactly 0,
06:270), @sec-stages (S1 monitoring, 08:148), @sec-heterosis-flat, @sec-choosing (richness);
02b -> @sec-stages (sel_intensity in UC, 08:219), @sec-alphasimr (replicated breeder's
equation, 04c:730-800), @sec-cycles (seed-dependent crossover, 11b:273-276), Finding 5
(07:315), @sec-limits (disequilibrium, 11c:100-122), @sec-heterosis-gca-sca (flagged as a
later chapter at 02b:252). Not kept: C1, C13, C14.
