# Part review: Simulation (03-simulating-crosses, 04-population-sizing, 04b-backcross-introgression, 04c-alphasimr-pipeline)

Scope: what the part adds on top of the four approved chapters, read in `_quarto.yml` order after Introduction and Foundations and before Metrics and prediction. Chapter findings (03-*, 04-*, 04b-*, 04c-*) are not repeated; items already in a THREAD `Owed` row are cited as "owed" and re-opened only where the part-level evidence changes. Text judged: the worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-04-06` (branch review-04-06) as it stands, including its uncommitted edits to `book/03-*`, `04-*`, `04b-*`, `04c-*`, `04d-*`, `05-*`, `05b-*`. `file:line` refers to that tree. Nothing was rendered. The cross-reference graph was computed by script over every `book/*.qmd` (labels `{#sec-...}` mapped to owner files, self-citations discarded, citations to the label's file counted per chapter); there are no broken `@sec-` targets in the whole book (0 of all citations).

Result in one line: no H. 5 M, 6 L, one USER DECISION (MaCS wording). The part argues in order and every chapter opens by saying why it follows; the defects are (a) the A1-A8 relaxations are declared four different ways and A2 is said to hold and not to hold of the same objects, (b) one name/symbol collision between 04 and 04b, (c) a linkage pointer in 03 that skips 04 and 04b, and (d) a set of owed items that name later chapters and are still open.

## 1. The part as an argument

Order: 03 (the generator: lines inbred by fiat, independent neutral markers, no map, additive traits) -> 04 (the selfing path F1-F4 for one cross, on a map with Haldane meiosis and distortion; sizes the F4 line panel, not the hybrid set) -> 04b (the donor-introgression operation promised at 04:30; sizes BC3 conversions, then measures what a panel of conversions does to `GD`) -> 04c (replaces 03's generator by AlphaSimR: linkage, dominance, outbred founders, RRS across cycles against a paired control; the contract comes out unchanged). Each opening says why it follows: 03:19-47 (lists what Foundations defined and which generator each used), 04:15-21 (03 draws lines "inbred by fiat" and does not model the selfing path), 04b:53-79 (04 sized four objectives; the fourth, a homozygote at k loci, is asked from a BC3; keeps 04:30's promise), 04c:47-56 (returns to 03's contract and replaces its generator; 04 and 04b "are not prerequisites"). The close hands on explicitly: 04c:2331-2333 to @sec-genomic-era, whose opening (05:12-24) says what it takes from the part (03 only) and which chapters of the part it does not measure.

The part is not a chain: only 03 is a prerequisite of the other three; 04 -> 04b is a real dependence (04b cites 04 ten times); 04c depends on neither 04 nor 04b by its own statement (04c:52-56), and the graph confirms it (04c cites 04 three times and 04b twice, all as pointers).

### Dependences on earlier chapters (all four lean only on earlier chapters for what they need to be read)

| Chapter | Needs (earlier) | Not needed, but cited later in the book (forward, count) |
|---|---|---|
| 03 | 00 (A2/A5/A8, hp-cycle), 01 (f, G, eq-g-sum-zero), 02 (partition, keystone), 02b (simulate_pools), 05b (heterosis-flat, het-value, alignment, gca-sca) | 04 (1), 04c (2), 04e (2), 04g (1), 05 (1), 06 (2), 07 (1), 08b (2), 10b (1), 12 (1) |
| 04 | 00 (hp-cycle, hp-inbreeding, hp-popgen, eq-hp-drift, eq-hp-gd), 01, 02, 03 | 04b (1, promise), 05 (2, `sec-era-programme`), 06 (4: baseline, identity, ns), 08 (1), 11c (1) |
| 04b | 00, 01, 04 (10) | 05 (1), 06 (1), 07 (1), 09 (2), 10 (1) |
| 04c | 00, 01, 02, 02b (15), 03 (6), 04 (3), 04b (2), 05b (18) | 04d (13), 04e (2), 05 (2), 06 (1), 08b (1), 10 (3), 11b (3), 11c (7) |

Forward citations that are more than pointers (the text cannot be fully checked without the later chapter):
- 04:29, 04:1078 and 04b:66 send the reader to @sec-era-programme (05, a later part) for the definition of A1-A8, without saying it is later. 00:18-35 restates the list with its labels, so nothing is unresolvable, but the citation target is a later chapter (simulation-C1).
- 04:1070-1071 ("`GD = 1 - theta` (@eq-hp-gd, derived in @sec-identity)") and 04:1164 (`@sec-ns`) point to 06 for a derivation the bridge section uses. `@eq-hp-gd` is in 00, so the identity is stated earlier; only the derivation is later. Declared by "the rest of the book works on one kernel" (L, simulation-C9).
- 04b:1186-1197 builds its "two consequences for the rest of the book" on `alpha` of @sec-ocs (09) and `max_use` of @sec-choosing/@sec-combinatorial (07, 10), without saying they come later (simulation-C9).
- 04c:1122-1127 ties @eq-alphasimr-accuracy to @tbl-mating-quantities (04e, a later part) as the limit n_B -> infinity (simulation-C9). The tie to @eq-het-rho-k (05b) is earlier and fine.

## 2. Findings

IDs `simulation-C<n>`. Each names the chapter that should change.

### simulation-C1 (M) The relaxations of A1-A8 are declared four different ways; only 04b maps all eight

- 03:141-176 declares the generator's assumptions in prose, with no A-labels (biallelic neutral unlinked markers; unrelated, inbred-by-fiat lines; equal pool sizes and complete factorial; additive traits known without error). It never says which of A1-A8 it meets.
- 04:23-33 maps to A2 and A3 only (its panel is a derived population "outside A1-A8"); 04:1075-1082 maps to A2, A5 and A8 only; A1, A4, A6, A7 are silent.
- 04b:65-79 maps all eight (A2 holds, A3 not met, A5 dropped then restored, A1/A4/A6/A7/A8 unused).
- 04c: A5 appears once (04c:435-436); the relaxations are in prose (04c:46-56, 2239-2255), no labels; A3 (recycling within pool) and A4/A6 (discrete cycles, frozen base) are exactly what Step 8 is built to satisfy and are not said to hold.
- 05:20-24 states the arrangement openly ("A1-A8 are this chapter's list, not a list the Simulation part uses; @sec-sizing and @sec-backcross map their departures onto it; @sec-simulating-crosses and @sec-alphasimr do not"). That sentence is true of the four chapters as they stand. So the question is not an error but whether the policy is what the book wants: a reader going 03 -> 04c meets one chapter that never mentions A1-A8, two that map partly or fully, and one that does not.
- Citation target: A1-A8 are defined in 05 (the label `sec-era-programme`, later part) and restated, without the "declared for the numbers of that chapter" scope, in 00:18-35. 04 and 04b cite only 05.
- Change: decide once. Either (i) accept 05:20-24 as the policy and add, in 00:18-35 or at the head of 03:141, one sentence saying that the Simulation part states its assumptions in its own terms and that only 04 and 04b map them; or (ii) give 03 and 04c a one-line mapping (03: A1, A2, A5, A7, A8 met; A3, A4 not modelled; 04c: A2 relaxed for founders, A5, A7 relaxed, A3/A4/A6 kept). Owner: 03 and 04c for (ii); 00 or 05 for (i).

### simulation-C2 (M) A2 (and A5) are said to hold and not to hold of the same objects

- 04:23-27: "selfing to fixation is the alternative to doubled-haploid induction that A2 allows for deriving lines". 04:1077-1079: the F4 panel "departs from each [A2, A5, A8]: its lines carry H = 0.125". So A2 is the licence for the route and the thing the product violates; 04 stops at F4, not at fixation, and the opening does not say so.
- 04b:70-71: "A2 holds (the recurrent parent is fully inbred, and the converted line is fixed at the end)". 05:21-23: the F4 panels, the backcross populations and the AlphaSimR cycles "depart from assumptions A2 and A5". For the backcross populations (BC1-BC3, heterozygous at the targets) 05 is right; for the recurrent parent and the converted line 04b is right; neither says which object it means.
- A5: 04b says dropped in the main body and restored in @sec-bc-connects; 05:22-23 lists the backcross populations as departing from A5, which is true only of the main body (04b:74-76).
- Change: 05:21-24 (say which object departs: the F4 panel from A2 and A5, the BC1-BC3 populations from A5 and from A2 before fixation, the cycles from A2 and A5; 05 is APPROVED and in the next part, so this goes to its part review) and 04:23-27 (say the panel is F4, not fixed; the fixation case is the A2 route). 04b:70-71 is correct as it stands for the objects it names.

### simulation-C3 (M) 04b calls 04's `D` "gene diversity" and then uses `D` for donor dosage

- 04:195-199 defines `D` as diversity retained, `m^-1 sum_j 2 p_j (1-p_j)/0.5`; 04:1130-1136 shows `GD = D/2` exactly and says `GD` is "the quantity the later chapters constrain". 90:357 and 90:422 agree (`D` is diversity retained; `GD` gene diversity).
- 04b:53-54 "the gene diversity $D$ retained", 04b:1070-1072 "of which gene diversity saturates earlier than recovery", 04b:1077-1078 "not sizing for gene diversity alone": the quantity is 04's `D`, which is twice `GD`, named with `GD`'s name.
- 04b:222 and 04b:1114, 1169 then use `D` for donor dosage in the same chapter (declared local at 90:421-422, where the disclaimer is "not the diversity retained D of @sec-sizing"). The reader meets `D` as "gene diversity" on the first page and as donor dosage from @sec-bc-model.
- Change: 04b (use "diversity retained" for 04's quantity at 04b:53-54, 1070-1072, 1077-1078, as 04 and 90 do).

### simulation-C4 (M) 03 points to 04c alone for the relaxation of "no map, no recombination"

- 03:153-159: "There is no genetic map and no recombination ... @sec-alphasimr relaxes this (linkage, outbred founders, directional dominance and several generations of selection)". 03:164-166 correctly sends the selfing path to @sec-sizing.
- 04 builds a map and Haldane meiosis (04:63-98, SA3-SA4) and 04b builds a 5 cM marker chain with linkage drag as its subject (04b:182-229). Both relax the unlinked-markers assumption of 03 two and one chapters before 04c. 04c:46-56 says so ("run on the package's own map-and-meiosis simulators"), and 04c:2239-2244 states what it adds over 03 (real map, dominance, coalescent founders, multi-generation selection), which is correct as "added over 03" but does not claim to be the first.
- 11b:77-79 (owed from 04b, "@sec-sizing is where linkage is modelled properly") has the same pattern in the other direction.
- Change: 03:157-159 (add @sec-sizing and @sec-backcross as where a map and recombination first appear, for a single cross and a conversion respectively).

### simulation-C5 (M) `k` means two things in 04

- 04:130 (caption) and 04:136 (column header): `$k$` is the transmission of the P1 allele through the male gamete (the `k` column of `f2_distorters`, SA5). 04:705-715, 842-868, 883 and the whole of the recovery section: `$k$` is the number of unlinked loci (@eq-sizing-n95). 90:348-351 (the `k` row, "unlinked loci at which a P2 homozygote is to be recovered") and 90:387 ("k counts loci, not a marker index or testers") define `k` for the sizing block as loci only.
- No algebra uses the transmission `k`, so nothing is mis-computed; but two quantities share a symbol in one chapter, 575 lines apart, and the second is not in 90.
- Change: 04 (rename the header at 04:136 and the caption at 04:130, e.g. to "P1 transmission", keeping the code column name in backticks) or add the second sense to the sizing block of 90.

### simulation-D1 (USER DECISION, nothing to fix) MaCS wording against CLAUDE.md

Recorded as a decision for the user, as asked. It is not a finding.

- What 04c establishes (04c:162-216, 221-251, 313-330; THREAD 04c `Owed`): ONE pair of default-threaded `runMacs()` calls per render, read inline as `differed` or `identical`, with `.Random.seed` asserted identical after both calls; nothing on `runMacs2()` (never called in Step 1, used in Step 8); a mechanism (`nThreads`) as an untested hypothesis. Verdict probes (it2): `runMacs()` pair differed in 5 of 6 fresh sessions, identical in 1; `runMacs2()` 0/8 differing in each of three scripted probes; Step 8 identical across two whole executions; the stream identical. The committed render, the author's check run and the verdict's runs did differ, so some non-reproducibility between machines or sessions exists, cause undetermined.
- What the rest says, without qualification: `CLAUDE.md` ("MaCS is not seeded by `set.seed()`, and it poisons everything downstream of it ... the call consumes an unpredictable amount of R's own random stream, so every later draw in the same session inherits an unpredictable seed"; "two calls with the same seed return different founders (measured in `04c`)"; also "~13x" for the `runMacs` adjacent `r^2`, which 04c now reads inline per render, 04c:259-295); `book/11c-limits.qmd:195-198` ("`alphasimr_founder_pools()` is **not** reproducible from `cfg$seed` ... two calls with the same configuration return different founder haplotypes"); `book/04d-breeding-programme.qmd:244` ("whose `runMacs2()` founders are not reproducible"); `book/index.qmd:188` ("a re-run writes a new draw") and `index.qmd:216`; `R/13_alphasimr_bridge.R:46-64` (roxygen of `alphasimr_founder_pools()`, "`runMacs()` behaves the same way, measured in 04c"). 04c:230-233 itself reports that those chapters and the help page say it and that it "did not test that".
- Rules that hold under either reading, kept in 04c and in 11c: found once and branch both arms; `set.seed()` immediately before each founder draw; `saveRDS` what cannot be reseeded. 04d:244-246's argument (same seed, same founders, hence a legitimate paired comparison) needs only the `quickHaplo()` half of that sentence.
- Options for the user: (a) keep CLAUDE.md, 11c, 04d, index and the roxygen as they are and accept that 04c is the one chapter that says "not established" (04c is written to stay true under either outcome); (b) weaken all of them to 04c's scope (one measured pair, the stream identical, `runMacs2()` unmeasured) and drop "poisons everything downstream" from CLAUDE.md; (c) commission the k/n table over >= 20 seeds for `runMacs`, `runMacs2` and `nThreads = 1` (about 2.6 s per `runMacs()` call; contested at it2 and the contest upheld) and then edit all places to the measured rate. Reconcile all or none; no part-level edit is proposed before the decision.

### simulation-C6 (L) Redundancy: 03's neutral-divergence derivation against 05b's (the decision owed to this review)

- 05b owns the derivation (`05b:602-787`: @eq-het-bn-total, @eq-het-bn-halves, the sample-frequency offset, grid seed 5, six points 0.02-0.45, expected heterosis per locus at `d_k = 1`). 03:337-360 states the same expectations for its own grid (seed 1, six points 0.02-0.40, heterozygous fraction and `GD` components), plus the per-hybrid identity `1 - f^L_ab` (not in 05b), the finite-`n` form `E[GD_BS] = F_BN p*q* + (1 - F_BN) p*q*/n`, the (1 - 1/n) factor in the change between grid ends, and 03's 200-seed replicate analysis (03:178-335), none of which is in 05b.
- I checked the algebra: with `n_A = n_B = n`, 05b's offset `Ep (1 - F_BN)(1/n_A + 1/n_B)/4` (`Ep = E[2p*q*]`) equals `(1 - F_BN) p*q*/n` per marker, which is the second term of 03's `E[GD_BS]`; and 03's expected change 0.0666 against 0.0694 for unbounded pools is `0.38 x E[p*q*] x (1 - 1/25)` with `E[p*q*] = 0.25 - 0.9^2/12 = 0.1825`. The two agree and both use `p*`, `q* = 1 - p*` (03:91-107, 05b `p^{*}` throughout the section). The text of 03 says so (03:358-360).
- What is duplicated is therefore the formulas, about 24 lines, written in two parametrisations of one offset (05b per locus with `1/n_A + 1/n_B`; 03 per marker with `1/n`). 03 needs the finite-`n` form to interpret its own numbers (it compares them with them), so the paragraph cannot go; but it does not need to re-state what the unbounded-pool expectations are.
- Decision: keep 05b as owner. 03:338-357 can shrink to the finite-`n` form and the two numbers, citing @eq-het-bn-halves for the unbounded-pool expectation and saying that 05b's offset `(1/n_A + 1/n_B)/4` is the same quantity at `n_A = n_B`. Low: no number disagrees, and the duplication is declared at 03:345-346, 358-360.
- Same pattern, smaller: 03:512-534 shows `sum(G) = 0` and the `f` range on the same `ctx` that 01 shows at 01:118-135 (@tbl-g-sums); 01 owns @eq-g-sum-zero; 03 re-demonstrates it on its own build and adds the "sample centring" scope. Accepted. The visible discrepancy of the `f` maximum (0.8317 in @tbl-ctx-check against 0.8318 in 01's table, one value rounded two ways) is the owed optional item to 03; still open, no claim depends on it.
- Same pattern, smaller: the Haldane map function is stated in 04:94-96 (SA4, unlabelled) and again as @eq-bc-haldane in 04b:189-195, each with its own attribution to @haldane1919 (04: none for the page; 04b: "page-level attribution not verified"); 04b cites 04 for the junction bias (04b:202) but not for the formula. L: 04b could write "the Haldane function of SA4" and keep the assertion against `haldane_r()`.

### simulation-C7 (L) Owed items that name a later chapter and are still open at part close

Verified against the current text of each target (none of the targets has been edited by the Simulation reviews, by design). Not re-argued; listed so that the later part reviews pick them up.

| Owed from | Target (current line) | State |
|---|---|---|
| 03 (03-C10) | `04e:35-37` "@sec-simulating-crosses derived populations from crosses already chosen" | open; 03 forms the complete factorial and derives no population (@sec-sizing does) |
| 03 (03-C11) | `08b:11-12` puts "an optimistic ceiling" in quotation marks as 03's words | open; 03 never says it, its callout claims only maximality (03:453-478) |
| 03 (03-M6) | `11b:102`, `12:170` "optimistic ceiling" | open; 03's callout no longer supports a ceiling reading |
| 04 (04-C6) | `index.qmd:116-118` "a panel cannot be selected back up to variation it never sampled" | open; 04 claims only that no selection restores an allele the panel does not carry (04:1154-1155) |
| 04 (04-C3, M20) | `04d:376-379` "the same arithmetic @sec-sizing explains for a biparental cross" | open; 04 now explains `N_s in [1/2, 1]` for every set of lines as a monotone function of `D` (04:1160-1169), not the diagonal-dominance argument |
| 04b (04b-C9) | `11b:344-346` "@sec-backcross is the machinery that performs [injection]"; `11b:77-79` "@sec-sizing is where linkage is modelled properly" | open; 04b adds loci to one elite line and its last section shows the product is a near-copy of the recurrent parent |
| 04c | `04d:244`, `11c:195-198`, `index:188`, `index:216`, `R/13:46-64` | the MaCS USER DECISION above |
| 03, 04, 04b, 04c | `90-notation.qmd` rows | open: 90:20 "candidate hybrids in the pool" and 90:30 "frozen candidate-pool allele frequency" (settled name "candidate set"); 90:152-158 and 90:596-597 plain `p` for the ancestral frequency against `p^{*}_k` at 90:498 and in 03; no rows for `\bar f^L_{AB}` or `q^{*}_k`; the `d` of 04b (marker interval at @eq-bc-haldane, distance between targets at @eq-bc-psame) and the local-symbol note 90:415-421 lacking `q`, `d`, `r`, `P`; `n_rep` wording (90:373); `GD`/`theta` unsubscripted for eight lines at 04b:1100-1170; `g^A_i` two senses (00-C33) |
| 04c | `R/15_response.R:63-64` roxygen, `R/13:114` "Comstock, Robinson & Harvey (1949)" | code items, not the book's |
| 03 | `91-package.qmd:109`, `R/09_reference.R:13` "lighter simulator" | open, Low |

Promises made by the four chapters and kept in their targets (verified): 04:30 -> 04b (kept, 04b:65-80); 03:405 -> @sec-collapse (07:38); 03:466 -> @sec-bound (`ocs_bound()` valid at book scale, 10b); 03:476-477 -> @sec-genomic-prediction closes the gap (08b:14-16); 03:560-567 -> @sec-genomic-era (the frozen `p0` is A6, 05:141); 04c:435-436 -> @sec-genomic-era "(assumption A5) states the same collapse as a limit" (05:109-133 does, and says the marker panel and the causal loci are the same set wherever `simulate_data()` is the source); 04c:326-330 -> @sec-genomic-prediction (08b:116, 498-499: traits built on markers, "every accuracy is a best case"); 04c:2326-2329 -> @sec-programme (04d, `library(AlphaSimR)` at 04d:6); 04c:2322-2324 -> @sec-limits builds its linked arm on `alphasimr_founder_pools()` and takes the `varA`/`genicVarA` gap (11c:171-232); 04:1174-1176 -> @sec-limits "a different conclusion about what is recoverable" (11c: variance disequilibrium is repaid by recombination, allele loss is permanent, consistent with 04:1154-1155); 04:1171-1173 -> @sec-stages (08 does not vary plants per cross, as 04 says).

### simulation-C8 (L) The no-selection control: 04c names the chapters that lack one and omits the one that has one

- 04c:2152-2158 and 04c:2316-2324 say the Step 8 control is not a replication of another chapter's control: @sec-cycles (11b) has a budget `alpha` and no random-selection arm (true: `grep random` finds nothing in 11b), @sec-programme (04d:366-370) measures against the programme's own start (true, quoted correctly). Both owed "keep true" items hold.
- `11c-limits.qmd:118-125` (section "What the metrics cannot see", "The experiment") has a paired control in which the hybrids "are chosen at random instead of on the index", same founders, same seeds, and is built on 04c's `alphasimr_founder_pools()` (11c:171-232). It measures a different quantity (the `varA - genicVarA` gap, not gene diversity), so 04c's claim is not wrong; but a reader of 04c:2152-2158 is told the book has no other random-selection arm, and the one that exists is a cited dependent of 04c's own wrapper. Change: 04c:2152-2158 (name @sec-limits as the other paired no-selection design, for the variance gap, found once and branched in the same way). Optional; not a contradiction.
- Naming within 04c is consistent ("paired no-selection control", `random_elite = TRUE`; "random elites" at 04c:2319 is the same arm); the other random baselines of the book are kept apart in the text (04c:2152-2158, 2254-2255: random-subset null of the same size for `alpha`, 09/10).

### simulation-C9 (L) Declared assumption sections and forward ties that cannot be cited precisely

- The labelled sections that carry the part's assumptions, `@sec-sim-assumptions` (03:141), `@sec-sizing-assumptions` (04:50), `@sec-bc-assumptions` (04b:957), are cited by no chapter outside their own (graph, section 3 below). Every external pointer goes to the chapter label: 04c:48 and 04c:2237, 05:12-24, 11b:79 ("the same abstraction @sec-simulating-crosses already makes"), 04b:1015, 04c:736. The text each of them paraphrases is the list at 03:153-176 and SA1-SA9; a pointer to the section label would let the reader land on it.
- Forward ties a reader of the part meets before the target (sections 1 above): 04:1070-1071 and 1164 (06), 04b:1186-1197 (09, 07, 10), 04c:1122-1127 (04e). Each is a pointer with a stated meaning, none is needed to follow the chapter. Note them; no change required beyond the optional "later" marker the Part-structure check asks for.

### simulation-C10 (L) "book scale" against "teaching scale" in 03

- 03:465 ("heuristics ... which at book scale are not certified optima") against "teaching scale" at 03:119, 238-240, 387, 436, 586, 673 and A8 (00:35, 05:150); 04c:2237-2285 settled on "teaching scale" and removed "book scale" (THREAD 04c "book scale is gone"). 03:465 means the 25 + 25 / 625-hybrid scale; `10b` and CLAUDE.md use "book scale" in the same sense (`ocs_bound()` "at book scale"). One name for A8's scale would remove the choice.
- Change: 03:465 (or leave and let the Metrics/Optimisation parts decide the book-wide term; 10b:635 and 10b:949 use it).

### simulation-C11 (L) 04b has no job downstream beyond one pointer, and the pointer overreads

- Inbound (table below): 12 raw, of which 5 are appendices/index, 3 are siblings (04, 04c) and 4 are other chapters in 3 files: 00:746 (the map of the book), 05:18-21 (a disclaimer that 05 does not measure backcross populations) and 11b:345 (the injection claim owed as 04b-C9). No chapter outside the part quotes or builds on a number of 04b (the 0.047 and 0.117 ratios of @tbl-bc-conversion-cost reach only `index.qmd:116-119`, item 5 of the chain of argument).
- 04b is a self-contained treatment promised by 04:30 and it keeps the promise; the question for the part is only whether the single downstream use (11b's injection) says what 04b measured. It does not (owed). No change in 04b.

## 3. Cross-reference graph (self-citations discarded, whole book, script-computed)

Inbound `@sec-` citations to each chapter, by source:

| Chapter | Raw inbound | Appendices + index (90, 91, 92, index) | Part siblings | Other chapters (count in n files) | Other chapters, by file |
|---|---|---|---|---|---|
| 03-simulating-crosses (`sec-simulating-crosses` 39; its six inner ids 0) | 39 | 6 (90:2, 91:2, 92:1, index:1) | 8 (04:2, 04c:6) | 25 in 12 files | 00:4, 01:2, 02b:4, 04e:1, 05:3, 05b:3, 06:1, 07:1, 08b:3, 09:1, 11b:1, 12:1 |
| 04-population-sizing (`sec-sizing` 27, `sec-sizing-verify` 2) | 29 | 8 (90:4, 91:1, 92:2, index:1) | 14 (03:1, 04b:10, 04c:3) | 7 in 5 files | 00:1, 04d:1, 05:2, 05b:2, 11b:1 |
| 04b-backcross-introgression (`sec-backcross` 10, `sec-bc-running` 2) | 12 | 5 (90:1, 91:1, 92:1, index:2) | 3 (04:1, 04c:2) | 4 in 3 files | 00:1, 05:2, 11b:1 |
| 04c-alphasimr-pipeline (`sec-alphasimr` 26; no other label) | 26 | 5 (90:1, 92:1, index:3) | 2 (03:2) | 19 in 9 files | 00:1, 02b:2, 04d:7, 04e:1, 04f:1, 05:2, 05b:2, 11b:1, 11c:2 |

Reading: every chapter of the part has far more than one inbound citation, but the work is unevenly distributed. 03 is the contract everyone cites (25 citations from 12 chapters). 04c is the base for 04d (7) and has dependents in the Mating and testing and Evidence parts. 04 is cited from outside mostly in passing (05:2 and 05b:2 are disclaimers; 04d:1 is the owed `N_s` sentence). 04b's four outside citations are a map entry, a disclaimer and an overread (simulation-C11).

Inner section labels cited from outside their own chapter: 03 none of six; 04 `sec-sizing-verify` 2 (04b:202, 04c:789); 04b `sec-bc-running` 2 (index:191, 92:309); 04c has one label. `sec-sizing-ancestry`, `sec-sizing-assumptions`, `sec-sizing-results`, `sec-sizing-f1`, `sec-sizing-connects`, `sec-bc-model`, `sec-bc-index`, `sec-bc-fixation`, `sec-bc-assumptions`, `sec-bc-connects` and all six 03 inner ids are cited only from their own chapter (simulation-C9).

Outbound `@sec-` citations of the four chapters (file counts): 03: 05b 10, 02 6, 01 5, 02b 4, 90 4, 06 2, 04e 2, 08b 2, 04c 2, 00 1, 04 1, 04g 1, 05 1, 07 1, 10b 1, 12 1. 04: 00 4, 06 4, 03 2, 05 2, 01 1, 02 1, 04b 1, 08 1, 11c 1. 04b: 04 10, 00 2, 01 2, 09 2, 05 1, 06 1, 07 1, 10 1. 04c: 05b 18, 02b 15, 04d 13, 11c 7, 02 6, 03 6, 04 3, 10 3, 11b 3, 00 2, 04b 2, 04e 2, 05 2, 01 1, 06 1, 08b 1. Broken targets from the four: none.

## 4. Checks, in brief

1. Notation. `F_BN` (not `fst`, not `F_ST`) for the Balding-Nichols parameter in 03; `F_ST = GD_BS/GD_T` for the statistic, used so in 04c:1489-1490; `p*`/`q*` in 03 and 05b; the only plain-`p` remnants are in 90 (owed). Local symbols are declared local and disclaimed in 90 for 04 (90:385-391), 04b (90:420-422) and 04c (90:572). Collisions: `D` (simulation-C3), `k` (simulation-C5); `t` in 04c has three senses (tester count, Student `t`, selfing generation) and 04c:1083-1085 says which is which; `g^A_i` has two senses declared at 04c:1029-1034 and 05b:970-977 (owed as 00-C33); `H`, `D`, `L`, `N`, `d`, `r`, `P`, `s`, `q` have per-chapter local senses declared in 90, with the `d` and `q` gaps owed to 90.
2. Names. "Diversity retained" / "gene diversity" (simulation-C3); "candidate set" settled in 03, 04 and 04c (no "candidate pool" left in the four chapters); "teaching scale" (simulation-C10).
3. Numbers. No hard-coded number from one chapter of the part appears in another (grep for 0.3617, 0.3281, 0.081, 625, 2000 markers in 04, 04b, 04c: none; 04b's "04's closed form understated at k = 5" is a statement, not a number, 04b:759-761, 1010-1012). `book_cfg` scale quoted by inline expression everywhere. One visible rounding discrepancy (0.8317/0.8318, owed).
4. Redundancy: simulation-C6.
6. Transitions and promises: section 1 and the kept-promises list under simulation-C7. Open promises are only the owed items to later chapters.
8. Assumptions across chapters: simulation-C1, C2, C4. Also checked and consistent: 04's `N_s in [1/2, 1]` for every set of lines (04:1160-1169) with 90:635-637 and with the 0.6448-0.8317 range of `f` for 03's hybrids (an instance, inside the range); 04's `GD = D/2` with 04c's `alphasimr_gd()` and `GD_WI` = half the observed heterozygosity; 04's F-index (F1 as base, `t` from the F1) with 04c:787-790 and `(1/2)^{t-1}`; 04b's `D = (1/2)^{n_bc+1}` with 90:401; 04b's conversion-cost model (allele frequency 1/2, independent markers, inbred 0/1) against 04's bridge scope paragraph (04:1075-1082, a different base and the same `GD`).
