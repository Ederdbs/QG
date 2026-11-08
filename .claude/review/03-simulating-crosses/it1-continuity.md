# Continuity: book/03-simulating-crosses.qmd (iteration 1, chapter mode)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05 (branch review-01-05). Read: CLAUDE.md, _quarto.yml, 90-notation, THREAD entries 00, 01, 02, 02b, 05b and every Owed item naming 03, it1-audit.md, it1-refs.md, then 00, 01 (scale, ancestral p), 02 (keystone, drift paragraph), 02b (simulate_pools), 05b (@sec-heterosis-flat), 05 (A5, A6), 06 (@sec-baseline), 07 (@sec-collapse), 12, 04, 04b, 04c, 04e, 08b, 11b and the other citers of @sec-simulating-crosses. Nothing was edited. One scratch R run (outside the repo) recomputed the fst = 0.15 row at m = 1500 and m = 2000.

Counts: H 2, M 6, L 7 (15 findings).
Owners: this chapter (03) 11 (H1, M5, L5); 01 1 (H); 04 1 (L); 04e 1 (L); 08b 1 (L).

Verified and consistent (not findings):
- Opening (03:8-22) says why it follows 05b: the Foundations chapters drew data from `simulate_pools()` (02b:48-63), `simulate_lines()` and `simulate_data()` (05b:67-68) without deriving them. 02b:911-913 and 05b:67-68 both announce 03 as the next step. The 02b description of `simulate_pools()` (02b:48-59) equals 03:14-22 (traits differ, lines and X identical; asserted at 03:91-92).
- Owed from 01 (01:378-380): the heterozygous fraction is flat across 03's F_BN grid, one pair of pools per point. Kept (03:180-183; replicate spread measured in the audit, R11).
- Owed from 02 (02:606-613, drift paragraph): ratios 1 and 2 in two equal pools. 03:189-196 quotes them correctly and the audit reproduced them (1.002 and 2.008 over 200 grids). The conditions of the keystone row are NOT kept (03-C1).
- F_BN is the parameter (`fst`), F_ST the statistic GD_BS/GD_T of @eq-f-stats, and the statistic estimates about F_BN/(2 - F_BN) = 0.081 at 0.15: 03:68-76 agrees with 00:561-585, 05b:617-628 and 90:150-167.
- f is built as in @eq-f-molecular and stated as in 01 for the properties it names (sum(G) = 0, f in [0,1]); G is not used for diversity.
- Ancestral p* uniform on [0.05, 0.95] and the level 0.365 agree with 05b:675, 05:559 and 90:513. 03:20-22 agrees with 00:41 (traits have effects at every marker).
- Forward promises kept: @sec-collapse (07:38, line usage and theta_S = w' fL w), @sec-baseline (06:516-590, bias of the whole-pool baseline), @sec-genomic-era (05:97, p0 frozen in `build_ctx()`), @sec-case-study (12:160-178, GEBV error and additive model), @sec-heterosis-flat and @sec-heterosis-alignment (05b:602, 05b:789).
- d_k does not occur in 03, so there is no clash with "dominance effect". "candidate set" is the settled name for the hybrid set (00, 05b); 03 breaks it (03-C3).
- "lighter form": absent from 03. Residue is outside 03 (R/09_reference.R:13, 91-package.qmd:109), not in THREAD; reported by the audit (R15).

## Findings

### 03-C1 (H) owner: 03 -- 03:201-218 states the heterosis conclusion without the conditions 02 and 05b attach to it (Owed from 02, unsettled)
- 03:214 "Neutral divergence relocates diversity; it does not create heterosis." and 03:215-217 "@tbl-keystone ... states that `GD_BS` is nonetheless to be preserved rather than minimised".
- 02:1039 (the keystone row itself): "with flat dominance ($d_k \equiv 1$), inbred parents and the complete A x B factorial ... there $GD_{BS}$ is the divergence term of heterosis, to be preserved not minimised; outside those conditions it is not an identity". 02:1085-1097 adds equal pool weights and says it "does not hold for non-flat dominance or for divergence that is aligned with the dominance effects". 05b:602-610 and the callout after the sweep scope the same sentence to expected heterosis at d_k = 1 ("adds no *expected* heterosis"). THREAD 02 Owed (-> 03) asks 03 to keep these conditions.
- Check 8: the chapter's own data carry no dominance (03:288, 00:41, 06:404), so in this chapter the heterozygous fraction is not heterosis; it is heterosis only at d_k = 1. 03 never says d_k = 1, and does not mention inbred parents or the complete factorial in the paragraph (the equal pool sizes are noted at 03:130). "nonetheless" at 03:216 makes preservation read as a consequence of the flat line; in 02 and 05b it follows from alignment.
- Change: 03 (state the conditions and say the quantity is the heterozygous fraction, equal to heterosis at d_k = 1).

### 03-C2 (H) owner: 01 (also 05b, 90) -- the ancestral frequency has three symbols and one of them is also the frozen base
- 01:374-376 "Given the ancestral frequency $p_{0,k}$ ... $2p_{0,k}(1 - p_{0,k})$" (ancestral Balding-Nichols frequency). The same symbol is the frozen base of the candidate set at 00:368 ("$p_{0,k}$ the frozen base frequency of the founding candidate set"), 05:97 and 05:186 (A6, `ctx$p0`), 90:30 and 03:329 (`p0`), and in 01 itself at 01:420 ("base-generation frequency $p_{0,k}$"). In the Balding-Nichols simulation these are different quantities: the base is the hybrid-set mean (about (p_A + p_B)/2 of the sampled lines), not the ancestral vector.
- The ancestral frequency is $p^{*}_k$ in 03:59-72 and 90:513, plain $p$ in 05b:620, 05b:670-675, 05b:698, 05b:1193 and in the 90 Terms entry (90:587-590), which also contradicts 90:513 inside 90.
- One symbol for two quantities (01 against 00/05/90) and one quantity with three symbols (01, 05b, 03/90). Change: 01 (use $p^{*}_k$ at 01:374-376), 05b (use $p^{*}$ for the ancestral frequency where 90 and 03 define it), 90 (Terms entry). 03 is the owner of the definition and is correct.

### 03-C3 (M) owner: 03 (also 90, 04) -- "candidate pool" for the hybrid set (Owed from 00 and 05b, unsettled)
- 03:29, 329, 412, 414, 419, 433, 441 and the row "GD, whole pool" (03:444); label `fig-candidate-pool` (03:418, need not change). 03:56-190 use "pool" for the heterotic pools A and B, so "the whole pool" at 03:433 follows a section about GD within and between pools.
- 00-C13/00-M14 and 05b ("no candidate pool left in 05b") settle "candidate set" (00:368 uses it). Same residue: 90:20 and 90:30, 04:15.
- Change: 03 (prose and captions); 90 and 04 are owed by the THREAD already.

### 03-C4 (M) owner: 03 (05b owns the derivation) -- the neutral-divergence sweep and its expectation are developed in full in 03 and in 05b
- 03:101-218: grid of F_BN (0.02 to 0.40, seed 1, m = 1500), figure and table of the heterozygous fraction and GD_WS, GD_BS, GD_T, 200-replicate trade ratios, the finite-n correction E[GD_BS] = F p*q* + (1 - F) p*q*/n and "loss of GD_T = gain of GD_BS = F p*q*(1 - 1/n)" (03:204-211).
- 05b:602-787 (@sec-heterosis-flat): the same experiment (F_BN grid 0.02 to 0.45, seed 5, m = 2000, tbl-het-sweep, fig-heterosis-sweep), the same expectation (@eq-het-bn-total, @eq-het-bn-halves), the same E[2p(1-p)] = 0.365 and the same sample-frequency offset (1 - F)(1/n_A + 1/n_B)/4 times E[2p(1-p)] (05b:737-765), which is 03's (1 - F) p*q*/n. Both the "twice" accounting (05b:767-784) and ratios 1 and 2 (03:189-191) are stated.
- No contradiction (the formulas agree; checked), but two figures and two tables carry the same message with different grids, seeds and m, and 02/05b cite @sec-heterosis-flat (05b), while 01:378-380 cites 03 for the measurement. Decide the owner: the expectation and the finite-n offset belong to 05b (earlier, with the premises of C1); 03 should keep what is generator-specific (what the knob does to the line coancestries and GD components) and cross-reference.

### 03-C5 (M) owner: 03 -- the F_BN = 0.15 row does not reproduce the 0.3617 quoted at the same F_BN and seed elsewhere
- 03:116 and 03:158 set m = 1500; 03:112, 142, 173 call this "the book scale". `book_cfg$m` = 2000 (03:20 itself prints it; 03:419 says 2000 markers).
- At F_BN = 0.15, seed 1, 25 + 25 lines: heterozygous fraction 0.3674 at m = 1500 (recomputed; first row of tbl-divergence-grid at 0.15) against 0.3617 at m = 2000, the value of THREAD 00 (00:435-447), 01 (01:360-380, tbl-diagonal) and 05b (0.3281 + 0.0336). A reader meets two numbers for what the text presents as the same quantity on the same data. Nothing in 03 explains m = 1500. Also 03:180-183 range 0.363-0.3726 against 05b's 0.3620-0.3664 (different m and seed; both centred on 0.365).
- Change: 03 (use `book_cfg$m`, or state why 1500 and drop "book scale"); the 0.15 row would then reproduce the earlier number.

### 03-C6 (M) owner: 03 -- the assumptions of the generator that other chapters attribute to 03 are never stated in 03
- Later chapters cite 03 for: linkage equilibrium, loci independent, no recombination (00:31, A5 at 05:94-95 "drawn independently per locus (`simulate_lines()`)", 11b:76-79 "the same abstraction @sec-simulating-crosses already makes", 04c:12-15 "independent markers, no recombination, no dominance", and the whole of 04c:1993-1999 "what this adds over @sec-simulating-crosses": linkage, directional dominance, outbred founders, multi-generation).
- 03 shows only "2 x Bernoulli(p)" (03:78-79); independence across loci, absence of a map and of descent between lines, unrelated founders, and effects at every marker are implicit. The callout "What this simulation deliberately does not model" (03:281-290) lists GEBV error and dominance only.
- Change: 03 (a short statement of the generator's assumptions, so that A5, C1 of 11b and the "adds over" list of 04c point to something stated).

### 03-C7 (M) owner: 03 -- as the opener of the Simulation part it points forward to none of the part and to the wrong place for dominance
- 03 cites only 01, 02, 02b, 05b, 90 and, for forward targets, 05, 06, 07 and 12. No citation of 04, 04b, 04c (the other chapters of the part), 04e (which crosses; relaxes the complete factorial of 03:222-239), or 08b (which closes the GEBV gap that 03:285-288 opens; 08b:8-16, 08b:698-706 call themselves that).
- 03:288-289: the additive model "cannot express specific combining ability -- see the caveats in @sec-case-study". The dominance side is 05b (@sec-heterosis-gca-sca, `heterosis_value()`) and 04c (a trait with dominance, 04c:1996-1999); 12 only names the extension (12:174-175, 12:262-266, "does not attempt").
- 03:222 "Every A x B combination is formed" is the complete-factorial assumption on which the identities of 02, 05b and 01 rest (check 8); 03 does not call it an assumption nor say which chapter relaxes it (04e, 04f, 04g).
- Change: 03.

### 03-C8 (M) owner: 03 (06 owns the baseline) -- the whole-pool-versus-random-subsets gap is demonstrated in both 03 and 06 with two numbers
- 03:412-448: GD of the whole set 0.3281, mean of 400 random subsets of 60 0.3259, "apparent loss" 0.6808 % (seed cfg$seed + 3).
- 06:578-590: `GD_population` 0.3280928, `GD_reference` 0.3258386, `apparent_loss_if_wrong_baseline` 0.0068707 (0.69 %), on the same ctx and n = 60, with the bias @eq-catalogue-bias (06:525) and a check against it (06:542-556).
- Same example in two chapters; 03 defers the explanation to @sec-baseline (03:436) but computes it. The 0.68 % and 0.69 % differ only by seed. Change: 03 (keep the figure of the set, cross-reference the number) or 06 (cite 03's table); the derivation stays in 06.

### 03-C9 (L) owner: 04 -- opening contradicts 03
- 04:15 "The previous chapters took the candidate pool as given. This one asks where it comes from" against 03:29-32 ("It also builds the candidate pool") and 03:222-239. 04 is about the lines and the wide cross, not about the hybrid set. Also "candidate pool" (C3) and the A3 issue already owed at 04:28.
- Change: 04.

### 03-C10 (L) owner: 04e -- misdescribes 03
- 04e:35-37 "@sec-simulating-crosses derived populations from crosses already chosen". 03 forms every A x B cross (03:222-224) and derives no population; the derived-population chapter is @sec-sizing (04).
- Change: 04e.

### 03-C11 (L) owner: 08b -- quotation attributed to 03
- 08b:10-12 says 03 built `ctx$traits` from known marker effects "and called the result 'an optimistic ceiling.'" 03:285-288 says "an upper bound on what a real programme would realise"; "optimistic ceiling" is in 11b:102 and 12:170. Change: 08b (drop the quotation marks or cite 12). See also the unconditional "upper bound" in 03:285-288 (audit R9, 03 to condition).

### 03-C12 (L) owner: 03 -- symbols of the trait construction clash with 90
- 03:249, 259-260, 264, 270-271 `R` (3 x 3 target correlation of the marker effects) against 90:501 (R restriction matrix of the index; 02b) and 90:497 ($R$ response). 03:253 `B` (marker effects, "each row of `B`" at 03:270) against $\boldsymbol\beta$ (90:310, 90:509) and $\mathbf B$, parent-usage incidence (90:43, 90:52). 03:86-92 `L` (line genotype matrix, 0/2) against $L$, the number of lines (90:20), where 90 names the matrix $\mathbf M^L$. All in code, but 03:259-260, 270-271 use them in prose.
- 03:275 $n_A$, $n_B$ for lines per pool against 90:474 (female/male lines of @sec-mating; audit R13).
- Change: 03 (or add the local sense to 90).

### 03-C13 (L) owner: 03 -- one quantity, three names inside 03
- The mean coancestry between lines of the two pools is `between_pool_f` (03:123, 142), "f_AB" (03:130 comment) and `theta_AB` (03:202), against $\bar f^L_{AB}$ (01:372, 360-380), $f_{AB}$ (02:596) and $\theta_{AB}$ in 90:205. 05b:349-380 identifies them for the complete factorial (05b-C20 owed to 90). 03:202 also states the identity as true of "an A x B hybrid" (per hybrid it is 1 - f^L_ab; audit R8).
- Change: 03.

### 03-C14 (L) owner: 03 -- what f is, as established in 01, is not carried into the chapter that builds it
- 03:319-321 "f is inside [0, 1]: the two properties from @sec-coancestry" and the contract row "molecular coancestry of the hybrids" (03:45-48). 01:222-250 adds that f is identity in state, that unrelated individuals are not expected at 0, and that its level is set by the marker panel ("the minimum of f ... above 0.5 for the book data"). tbl-ctx-check prints min(f) = 0.6447 and max(f) = 0.8318 (recomputed) without comment; the assertion `min(f) >= 0` is weaker than 01's statement.
- Change: 03 (one sentence).

### 03-C15 (L) owner: 03 -- "book scale" against "teaching scale"
- 03:112, 142, 173, 419 "book scale"; 00:35, 02:87, 02b:159, 05:106 (A8), 05b:632 "teaching scale" (introduction-C10 names this and lists 03 among the "book scale" users). The same phrase attaches to m = 1500 in 03 (C5).
- Change: 03, when introduction-C10 is closed.

## Inbound `@sec-` count (resolved to the owning file, citations from the file itself discarded)

| Chapter | Inbound | Citing files |
|---|---|---|
| 00-hybrid-programme | 41 | 9 |
| 01-coancestry | 37 | 15 |
| 02-subdivided | 50 | 14 |
| 02b-response | 32 | 14 |
| 03-simulating-crosses | 28 | 16 |
| 04-population-sizing | 18 | 10 |
| 04b-backcross-introgression | 8 | 7 |
| 04c-alphasimr-pipeline | 22 | 11 |
| 04d-breeding-programme | 19 | 6 |
| 04e-mating-design | 60 | 8 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 11 | 4 |
| 05-genomic-era | 41 | 16 |
| 05b-heterosis-dominance | 81 | 21 |
| 06-metric-catalogue | 43 | 19 |
| 07-choosing-metrics | 47 | 20 |
| 08-pipeline-stages | 39 | 18 |
| 08b-genomic-prediction | 26 | 14 |
| 09-optimal-contributions | 39 | 16 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 25 | 8 |
| 11-plant-literature | 15 | 8 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 20 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 18 | 7 |
| 91-package, 99-references, index | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

(Counts include appendix citers; they differ from the part-introduction table, which was computed earlier and before 05b was extended.) Broken `@sec-` targets across the book: none. Citing files of 03 (16): 00, 01, 02b, 04c, 04e, 05b, 06, 07, 08b, 09, 11b, 12, 90, 91, 92, index (index.qmd and 91 use the label but own none; the 16 includes them). Outgoing from 03: sec-subdivided 5, sec-response 4, sec-coancestry 3, sec-heterosis 3, sec-notation 2, one each to sec-heterosis-flat, sec-heterosis-alignment, sec-collapse, sec-case-study, sec-genomic-era, sec-baseline; none to 04, 04b, 04c (C7).

03 has 28 inbound citations from 16 files; the job given to it is real (generator, contract, `ctx`). 04b has the lowest inbound count in the book (8 from 7 files) and 04g the fewest citing files (4); both belong to later reviews.
