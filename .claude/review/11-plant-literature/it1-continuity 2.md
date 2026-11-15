# 11-plant-literature -- continuity review, iteration 1 (chapter mode, read-only)

Chapter: `book/11-plant-literature.qmd` (371 lines, text unchanged since the part-metrics review). Read against `.claude/review/THREAD.md` (entries 00-09, 10 provisional, 10b final), the chapter sources of 00, 05, 05b, 06, 07, 08, 10b, 11b, 11c, 12, 04d, 04e, 04g, 90, 93, and the verdicts `04e-mating-design/it3-verdict.md` (REJECTED, open), `04f-sparse-testing/it5-verdict.md` (APPROVED), `04g-joint-allocation/it3-verdict.md` (REJECTED, open). `it1-audit.md` and `it1-refs.md` read for context only; their findings are not re-judged. Nothing was rendered or edited.

Owners: **this** = 11 itself; **earlier-now** = an earlier chapter that can be fixed now; **later-Owed** = a later chapter, goes to its Owed list.

Chapter order used (`_quarto.yml`): ... 09, 10, 10b | Mating and testing design: 04e, 04f, 04g | Evidence and practice: **11**, 04d, 11b, 11c, 12. So 11 follows 04g, and its own opening points back to 07.

## Findings

### 11-C1 [H] Kadoumi et al. (2025) is reported more strongly than 00 and 08 report it -- owner: this
`11:132-144` against `00:343-360` and `08:304-309, 313-314`.
- `11:135-137` "increased **significantly** over time while genetic diversity within **both** groups declined": 00:350-352 puts the within-group decline in NSS (H_e 0.371 -> 0.279) with SS "stable"; "both" contradicts that. 00 gives F_ST 0.178 -> 0.223 and no test; "significantly" has no source in the book. The chapter gives no number and says "over time" where 00 says "forty years" (Owed `11:137` "decades").
- Omitted, and decisive for 00's reading: the between-group Hamming distance fell slightly (0.430 -> 0.420), "the quantity nearest the product did not rise with F_ST" (00:346-350); the main loss is attributed to merging Iodent and Lancaster into NSS, so NSS "was not a closed pool"; the authors "can only speculate" that selection caused the rise (00:353-355).
- `11:140-143` "confirms the constraint is doing necessary work ... what must be protected from erosion and from excessive inflation is between-pool divergence": on 00's numbers the divergence statistic that tracks the hybrid (Hamming) eroded slightly, and a decline in one non-closed group is not a test of a constraint. 00:355-357 says "Neither study establishes drift in closed pools, alone or with selection, as the cause".
- `11:143-144` "exactly the panel `s1_monitor()` logs in @sec-stages": 08:304-309 says the opposite scope, "one programme observed with both movements, not a test of this panel" (abstract-level reading), and 08:313-314 sends the reader to 11 for that reading. The panel logs F_ST and per-pool GD, not the Hamming distance that fell. 11 as written contradicts the sentence that points to it.
- `00:358-360` promises that 11 "reads @kadoumi2025 within its corpus, which begins in 2017 and so excludes @vanheerwaarden2012". 11 neither says the corpus starts in 2017 nor mentions van Heerwaarden 2012 (separation of pools, little attributed to selection); `11:134` calls Kadoumi "the single most load-bearing empirical result in this corpus". Promise partly broken.
- Change: 11 (adopt 00's numbers and limits by pointer to @sec-hp-cycle; drop "both", "significantly", "exactly", "confirms"). Nothing owed by 00 or 08. Settles Owed `11:135-143`, `11:137`, `11:144`.

### 11-C2 [H] "Minimal non-redundant set" and "stands on its own evidence" -- owner: this
`11:23-26`, again `11:348-349`, against `07:28-31`, `07:452-454`, `07:927-929`, `07:976-980`.
- 07 shows no set is minimal: the residual criterion is "necessary, not sufficient" (07:449-454); nine metrics keep >= 0.35 of their rank variance after the rank of theta, so "non-redundant" holds for the nine, not for a chosen two; 07's recommendation is two inside the optimiser, **three** at validation (alleles retained, within/between decomposition, N_s), plus F_drift/F_hom as monitoring. 11:23-24 lists "allelic richness at validation" only.
- "That recommendation stands on its own evidence" (11:24-25): 07 states the recommendation is inside the homozygosity lens only, for inbred parents and an additive index, on a cached redundancy analysis of 621 selections with no recorded setting and no producer (07:927-929, 355-361). The chapter's own headline qualification ("it is not what plant practice does") is built on this sentence.
- Metric naming drift between the two statements of the recommendation: 11 says "theta and N_{e,par} as constraints"; 07 constrains alpha (proportional loss of GD against a same-size baseline) and N_{e,par}.
- Change: 11. Settles Owed `11:23` (metrics-C11, 07->11).

### 11-C3 [H] "The encoding, not the algorithm, decides the outcome", and the Yadav 2025 reading -- owner: this; later-Owed 12, 11b
`11:301-306` against `07:613-646`, `10b:739-751`, `10b:754-840`, `10b:554-724`; Owed `11:306`.
- 07 itself says Finding 4 is "a verdict on the N-dimensional key encoding, not on `sel_de()`" (07:645-646), at one budget, two arms both cold, four restrictions; 10 (OPEN, provisional) says the DE-vs-greedy order depends on the evaluation budget (below greedy at 30,000, above from 120,000, 1% only); 10b (final) finds `sel_de()` ahead of the line-encoded DE uncapped (+0.3004 at book scale), capped rows a tie or an unjudged 0.0041, and a swap local search ahead of both at equal wall-clock, "a comparison of whole algorithms". "The encoding decides" is therefore not a finding of 07, 10 or 10b.
- The literature result it is said to be "consistent with" is the opposite kind of statement: Yadav 2025 compares algorithms (GA, DE, PSO, SA) on one problem, so it says algorithm choice mattered there. 10b:739-751 reads the same paper at the same level (GA first on convergence AUC 0.879 vs DE 0.860; DE "took longer ... and performed comparably in final fitness"), and concludes only that a simple local search is "a serious competitor", the warm start and cheap move being 10b's own explanation. 11:303-304 says GA gave "the best convergence speed **and fitness**"; 10b says final fitness was comparable. Two chapters, one source, two readings.
- Internal tension at `11:297-299` ("No retrieved plant study applies DE or any metaheuristic to an OCS-type hybrid selection problem") against `11:301-304`, the paragraph that follows, which reports a DE comparison in wheat; the paragraph opens "On the animal side" and is about a plant study (`it1-refs` 11-B6; the file `bibliography_animal.csv` holds it, 93 declares that the animal file contains plant papers).
- 11 cites none of 09, 10, 10b in `11:283-306`; @sec-advanced is cited 0 times (THREAD, 10b inbound).
- Change: 11 (reword with 10b's reading, say "of the whole algorithm", cite @sec-advanced and the evaluation budget). Later-Owed: `12:222` ("The search is encoded on **line weights**, not hybrid keys", checklist rule) and `11b:201` ("DE finds slightly better plans per cycle"; no budget) stay on the Owed lists of 12 and 11b; 10 is OPEN so it cannot be cited for a number until 10-D19 is arbitrated. Settles Owed `11:306`.

### 11-C4 [H] Coancestry versus distance: 11 says they are one statistic and then argues for one over the other -- owner: this
`11:98-99` against `11:101-108`, `11:361-363` (consequence 9); `08:84-109` (Trap 1), `06` (f is identity in state), `90` (row for the distance 1 - f_ij).
- `11:98-99` ("MRD and coancestry are the same statistic: f_ij = 1 - MRD_ij^2") is true, by 08 Trap 1, only for **inbred lines coded 0/1** (08:87-109: "homozygous lines only, not claimed for hybrids"); the chapter does not carry the condition, and the literature MRD of 11:94-96 is computed on SSR panels and tester assignments.
- Two lines later the African highland result is turned into "a direct argument for a coancestry-based constraint over a distance-based one" (11:106-108), repeated as consequence 9 ("a coancestry constraint is safer than a distance-based one"). If f_ij = 1 - MRD_ij^2 (the book's own f), a constraint on f is a constraint on a monotone function of the distance: by 08's Trap 1 the two are "one number twice". The kinship in that study ("kinship below 0.05", "66.05% of pairwise kinship values near zero", 11:101-114) is on a centred or IBD scale; molecular f for pairs that differ at 30-36% of alleles is ~0.64-0.70 (f_ij = 1 - fraction differing), so the study's "kinship" is not the book's f. The book's own design decision is "f, never VanRaden G" (CLAUDE.md; 05 for the reason). The argument supports a kinship (genealogy-informed) measure over a distance, not the book's f over MRD.
- Change: 11 (state which matrix the study's kinship is, or restrict the claim to what a state-based f can and cannot see; carry the "inbred, 0/1" condition on the pointer). The Owed `11:98` pointer to Trap 1 is correct in direction and unqualified in scope; 08 needs no change.

### 11-C5 [H] "The consensus, such as it is" -- unsourced, self-contradicting, and at odds with 05 and 07 -- owner: this
`11:243-266` against `07:1031-1034` (07's own text at 07:1042-1047 in the file), `05:20-45`, `05` tbl-era-side-by-side, `07` Caveats.
- `11:245-248` "There is **no consensus** on which specific genomic matrix", and `11:262` "The consensus, such as it is: molecular or IBD-flavoured coancestry outperforms simple VanRaden-style relationship". The paragraph says both. 07:1042-1044 reads the same literature as "reports no consensus on a single preferred formulation" and "this chapter does not rely on a ranking of matrices"; 11 supplies the ranking.
- The ranking conflicts with 05's reading of Meuwissen et al. (2020): the homozygosity-lens matrix that the book's f is affine in (G_0.5) "misses the drift target by the widest margin of the nine schemes they ran"; VanRaden G_VR2 "meets the drift target only on the managed panel". 11:253-255 itself calls the molecular-versus-VanRaden contrast "a genuine trade-off", so "outperforms" holds for one criterion only.
- `11:249-260` (the four bullets) and `11:268-274` carry no `@key`; only `@sec-genomic-era` is cited (07-B3, `it1-refs`).
- `11:264-266` "the line-level collapse holds for **any** symmetric f^L, so this open question does not destabilise the computational results": 07 says "given that the hybrid-level matrix is defined by @eq-collapse-f", that the adequacy of @eq-collapse-f for a centred VanRaden matrix "is not established", and that managing on molecular coancestry "controls homozygosity, not drift". The cost and identity results survive; what the constraint controls does not. 11 states the first and omits the other two.
- Change: 11. Settles Owed `11:247-266`.

### 11-C6 [H] "Two of these items now have a simulated answer" -- the count is wrong against 06, 07, 09, 10, 10b and 04d -- owner: this
`11:312-317` against the list at `11:319-344`.
- Items of the list that an earlier chapter answers in simulation or measurement (each has its owner chapter; none is an operating programme, as the paragraph says):
  - DE or any metaheuristic on a theta-constrained line-usage selection (11:319-320): 10 and 10b (line-encoded DE `sel_de_fast()`, local search), simulated.
  - Runtime/complexity comparison OCS quadratic solvers versus metaheuristics (11:321-322): 09 (`ocs_quadprog()`, relaxation), 10b (@sec-advanced-lsvsde, @sec-advanced-headtohead; rounding gap 4.27% against the bound), simulated, one dataset per scale.
  - Hybrid-genome-level coancestry optimisation (11:329-330): the package's `sel_de()`/`sel_greedy()` on the N x N hybrid `f` (09, 10) and its collapse to lines (07 Finding 1).
  - Per-evaluation computational cost of diversity metrics (11:340-341): 07 Finding 2 (cached external) and 10b @tbl-advanced-eval-cost (live).
  - Diversity metrics defined on hybrids (11:342): 06 (`ctx[["f"]]` hybrid-level), 00 @sec-hp-popgen.
  - Combinatorial 0/1 selection compared with continuous contributions (11:343-344): 09 versus 10 (relaxation against discrete plans), 10b (`ocs_round()`, `ocs_bound()`).
  - Diversity cost per cycle-time reduction (11:181-183, 11:336-337): 04d measures gene diversity at year 15, paired runs with genomic selection switched on in year 6 (inbred-line, wheat-type programme; not hybrid maize, so the item stays open as worded, but the chapter's "conspicuous hole" has a simulated partial answer in the Evidence part itself).
- The wording "unestablished in the literature" versus "unaddressed in this book" is the right distinction; the count "two" is not true of the book. The sentence also feeds `11b:398`, which says what 11 listed "was something narrower".
- Change: 11 (replace the count by the list or say "some"). `11b:398` stays true for the one item it names.

### 11-C7 [H] The usage table and "checkable in one line each": 11 and 93 disagree on the numbers the claims rest on -- owner: later-Owed 93 and this
`11:15-20`, `11:28-34`, `11:42-48`, `11:338-339` against `93:99-111`, `93:25-29`; `book/data/plant_metric_usage.csv`; `scripts/regenerate.R:26-28`.
- 93:99-100 says the claims of @sec-plant-literature "are checkable in one line each"; the two queries it prints return 12 coancestry/kinship records and ROH 1 (0 maize) from the shipped `bibliography_plant.csv`, where 11 prints 46 (22 maize) and "22 records use ROH, only 5 in maize" (the CSV row is "Inbreeding coefficient / ROH", a merged category). `plant_metric_usage.csv` has no producer (regenerate.R lists it as not regenerated; "derived from those"). A result quoted in one chapter that differs from where it is computed (check 3). Audit finding 11-R1; recorded here for the cross-chapter side only.
- Change: 93 (later-Owed, appendix) must stop saying checkable, or the table be labelled cached external tabulation in 11; both. 11:18-20 ("@sec-corpora describes both and how to query them") inherits the promise.

### 11-C8 [M] "Allelic richness" and "status number" in the literature's senses, unmarked -- owner: this
`11:23`, `11:40`, `11:45-46`, `11:268-274`, `11:276`, `11:327` against `06:315-331`, `90:98`, `07:1008-1027`, `06:181-191`; Owed `11:40`, `11:268`.
- 06:329-331 (closed, part-metrics-and-prediction-verdict2 metrics-M1) now says "allelic richness" means A_ret (marker alleles retained out of 2m, biallelic, inbred lines, eq-catalogue-alleles-retained) only in @sec-choosing and @sec-stages, and names 11 as using the term for "values reported by the studies it reviews". 11 never says so. Three senses are in play in 11: A_ret at `11:23` ("allelic richness at validation", 07's sense); the screen's category "Allelic richness / rare alleles" (11:45-46, 11:327), and the expected number of alleles at drift-mutation equilibrium (11:268-274), multiallelic.
- `11:268` "On allelic richness the post-2018 work sharpens rather than contradicts the recommendation" carries the transfer 06 declines to make (Lopez-Cortegano 2019 reported "for direction, not transfer", multiallelic haplotypes against biallelic markers; 06:330-359). 07 states that whether MAF-threshold loss and allelic richness carry the same information "was not examined".
- Same issue for "status number" (`11:46`, `11:276`): 06 reads N_s on molecular f as a rescaling of theta in [1/2, 1], "not a head count" (06:181-191); the literature's status number is a count.
- Change: 11 (one sentence naming the sense at first use; scope the "sharpens" claim). The 06 side is settled.

### 11-C9 [M] F_ST for the Balding-Nichols parameter, and the scope of "invariant" -- owner: this (and 90 list)
`11:331-335` against `05b:530-540`, `90:157-162`; Owed 00-C18.
- `11:333` "expected heterosis is invariant to F_ST under neutral divergence": the simulation parameter is F_BN; 90:157-162 lists @sec-plant-literature among the chapters that "write that parameter as F_ST ... read it there as F_BN", so the notation file documents the clash rather than removing it. In the same chapter `F_ST` is also the literature statistic (`11:47`, `11:135`): one symbol, two quantities, in 11 (check 1).
- 05b's result is conditioned on "a d drawn independently of the frequencies" and on drift; "under selection ... can go either way" (05b:534-540). 11:333-335 drops both conditions and concludes "a dominance-informed ranking **must** differ from a frequency-based one"; the invariance is an expectation over pool draws, and says nothing about the ranking of crosses within one pair of pools.
- Change: 11 (F_BN, and carry the conditions or soften "must"). 90:160 may then drop 11 from its list (earlier-now, one word).

### 11-C10 [M] Two-object management "under selection" and the Trap 3 mechanism -- owner: this
`11:87-90`, `11:146-151` against `00:333-341`, `08:208-278`, `05b:534-540`; Owed `11:151` (keep).
- `11:87-90` "Within-pool and between-pool diversity trend in opposite directions **under selection** and require opposite management ... the argument of @sec-subdivided, arrived at from the applied side": 00:333-341 derives the opposite trends under **drift alone**, "not an argument for selection", and says the rise of GD_BS under `run_cycles()` is a simulation result with drift and selection not separated; @sec-subdivided gives the partition, not the management claim.
- `11:151` "That is Trap 3 of @sec-stages, with a mechanism attached": the pointer is right for the prescription (hold F_ST in a band, not at a maximum, 08:271-278; consequence 5 at 11:356 agrees). 08's reason is that expected heterosis, not the frequency statistics, decouples from F_ST (05b); 11's reason is the literature's background-specific QTL effects. They are two different mechanisms for one prescription; "now has a mechanistic basis" and "pushing it further does not add hybrid value" (11:146-150) generalise 05b, which leaves selection-driven divergence open (08:256-270). Keep the pointer as Owed says; scope the sentence.
- Change: 11.

### 11-C11 [M] "Reporting only a static status-number descriptor under active management" -- owner: this; 11b/11c keep true
`11:276-281` against `07:976-980`, `11b:236-268`, `11c:30-46`.
- 07 puts F_drift and F_hom (monitoring against the random-subset null) into the validation list; 11b:263-267 says "Report N_s as a descriptor of a plan, and measure Delta F from the trajectory", and fits rate-based N_e = 1/(2 Delta F) from a log(1 - F_drift) slope on managed runs, with an R^2 diagnostic that flags a saturating series; 11c builds Robertson's limit on the same N_e. 11's caution ("under *active* optimal molecular management, rate-based N_e is numerically pathological -- negative in early generations, with no long-term asymptote") describes the situation 11b/11c work in, and 11's conclusion ("report only a static status-number descriptor") is the opposite instruction to 11b's.
- Change: 11 (restrict the conclusion to the descriptor of a plan, say that Delta F measured on F_drift is 07/11b's monitoring item). 11b:262-263 "realised effective size" is Owed from 00-C5 and stays there.

### 11-C12 [M] Additive-plus-dominance for hybrid means: missing cross-links and an unstated consequence -- owner: this
`11:203-208`, `11:357-358` (consequence 6) against `07:127-136`, `08b:55-64` (additive trait by construction, no SCA), `05b:1434-1445`, `10b` line merit = GCA against the opposite pool (@sec-heterosis-gca-sca).
- 11 says the diversity constraint "needs neither" a dominance model and must not be conflated with mean ranking. True of the constraint. Left unsaid: under dominance the mean index is not a function of the line-usage vector w (07:127-136), so the collapse that makes the optimisation line-level holds for the diversity side only, and 10b's rounded route uses a line merit that is a GCA against a tester pool. 08b (the genomic-prediction chapter, the natural pointer for "additive-plus-dominance GBLUP") is cited 0 times from 11.
- `11:199-201` "confirms ... the decision to drop the progeny-variance term" does not say where the decision is made (05b:1434-1437: ranks hybrids on an index; `index.qmd:66`); 08:405-452's formula is additive, inbred parents, free recombination only. `11:192-201` is otherwise consistent with 08 (UC at S2 only, 91:234, 08's ledger arm "UC only") and with 04e:1208 (within-pool crosses producing lines, not the A x B design crosses). Owed `11:192-201` / S2: consistent; no change beyond the pointer.
- Change: 11 (cite @sec-genomic-prediction, @sec-heterosis-gca-sca, @sec-collapse for the line-level limit).

### 11-C13 [M] Forward and lateral links the finalised chapters and the Mating and testing part make true: absent -- owner: this
- @sec-advanced (10b), @sec-ocs (09), @sec-combinatorial (10): none cited; `11:243-306` is the OCS/optimisation paragraph (see 11-C3, 11-C6).
- Mating and testing design part (04e, 04f, 04g): not cited. 11 mentions tester choice (`11:94-96`) and testcross-based group assignment (`11:120-125`) but the part's chapters declare their own literature (abstract level; 04e and 04f cached external `sparsex`/REML study, 04g's three CSVs regenerated by `regenerate.R joint`). 04g:1512-1516 hands over correctly ("the Evidence and practice part ... does not use them: it starts from the metrics of @sec-choosing"), so nothing is owed to 04g; but 11's "unestablished" list says nothing about crossing or location design, so a reader leaves the part without being told that the literature on it is outside 11's screen. Not to import numbers from 04e/04g: 04e REJECTED (D19/D20) and 04g REJECTED (D6) at it3, neither is in THREAD.
- @sec-programme (04d): `04d:9` cites 11's seventh consequence and measures it; 11 does not cite 04d. Also `04e:1215-1217` uses Gorjanc 2018 (OCS under rapid recurrent genomic selection, four cycles per year) while `11:181-183` says the diversity cost per unit of cycle-time reduction is "not established in the retrieved set"; Gorjanc 2018 sits in the animal file (93: contains plant papers), so the statement is true of the plant file only and 11 does not say so (L).
- @sec-genomic-prediction (08b): see 11-C12.
- Change: 11.

### 11-C14 [L] Transition: the opening does not say why 11 follows 04g or that it opens a part -- owner: this
`11:11-13` against `04g:1512-1516`, `00:751`, `_quarto.yml` (11 is the first chapter of "Evidence and practice").
- The opening says only "@sec-choosing derived a recommendation. This one asks what the applied literature actually does". The jump from 04g is declared in 04g, not in 11. The reading map (`00:751`) says the part answers "what does the literature establish, what does a whole programme spend across cycles ... and how does one run end to end"; the opening of 11 does not situate itself as the first of those. Not a contradiction; check 6 asks the opening to say why. `11:13` "Part" also unnamed.
- Change: 11 (one sentence).

### 11-C15 [L] Promises to 11 that are kept, and the ones kept in part
- Kept: `00:76` (group assignment unsettled, 11:116-130); `00:733` (the three differences, 11:69-90); `00:751` (reading map question); `04d:9` (diversity cost per cycle, 11:359); `04g:1516`; `07:1042` for the first half ("reports no consensus"); `11b:343` (periodic germplasm injection, 11:169-171, 11:350-351); `11b:398` (unestablished crossover, 11:323-326).
- Not kept: `00:358-360` and `08:313-314` (11-C1); `06:331` ("values reported by the studies it reviews", 11-C8); `93:99` (11-C7); `07:1042-1044` second half (11-C5).
- Forward promises made by 11: `@sec-cycles` simulates the multi-cycle consequence and finds a gain crossover (`11:323-326`): kept (`11b`, `cycles_crossover.csv`, "The crossover reproduces", 11b:218); `@sec-heterosis` derives the term (`11:331-334`): kept, with the conditions of 11-C9; `@sec-corpora` "how to query them" (`11:18-20`): see 11-C7.

### 11-C16 [L] Notation
No symbol in 11 differs from `90-notation.qmd` except `F_ST` for `F_BN` (11-C9). `N_{e,par}`, `f^L`, `theta`, `f_ij`, `MRD` agree. `H_o`, `H_e` on `11:76` are literature panel values; 90's H_e is the within-set gene diversity row, and 07 rejects He as a separate metric because it is 1 - theta (`11:38-41` lists "gene diversity" and "PIC" in a panel without saying that the former is the book's GD). No finding.

## Owed items naming 11: status after this read
| Owed item | Status |
|---|---|
| `11:23` minimal non-redundant | open -> 11-C2 (this) |
| `11:247-266` consensus, no key | open -> 11-C5 (this) |
| `11:306` encoding decides | open -> 11-C3 (this; 12:222 and 11b:201 later-Owed) |
| `11:135-143`, `11:137` Kadoumi | open -> 11-C1 (this) |
| `11:98` Trap 1 pointer | direction correct, scope unqualified -> 11-C4 (this) |
| `11:151` Trap 3 pointer | keep; scope the mechanism -> 11-C10 (this) |
| `11:144` "exactly the panel" | open -> 11-C1 (this) |
| `11:333` F_ST | open -> 11-C9 (this; 90:160 one word) |
| `11:40`, `11:268` allelic richness | 06 side settled; 11 side open -> 11-C8 (this) |
| `11:192-201` / S2 crosses (08:408-420) | consistent; pointer only -> 11-C12 (this) |
| cross-links 08b, Mating part, 10b (uncited) | open -> 11-C12, 11-C13 (this) |
| `11:306` / `12:222` / `11b:201` | 11 side 11-C3; 12:222 and 11b:201 remain on 12's and 11b's Owed |
| `93:99-111` checkable | new, later-Owed 93 -> 11-C7 |

## Inbound `@sec-` count table
Method: label map from `{#sec-...}` over `book/*.qmd`; every `@sec-` citation resolved to its owning file; citations from a file to itself discarded; counted per owning file (all sections), with the number of distinct citing files. Broken `@sec-` targets across the whole book: none.

| Chapter file | inbound citations | citing files |
|---|---|---|
| 00-hybrid-programme | 70 | 18 |
| 01-coancestry | 42 | 15 |
| 02-subdivided | 64 | 17 |
| 02b-response | 49 | 15 |
| 03-simulating-crosses | 47 | 22 |
| 04-population-sizing | 31 | 13 |
| 04b-backcross-introgression | 16 | 10 |
| 04c-alphasimr-pipeline | 26 | 13 |
| 04d-breeding-programme | 20 | 6 |
| 04e-mating-design | 86 | 13 |
| 04f-sparse-testing | 53 | 8 |
| 04g-joint-allocation | 19 | 7 |
| 05-genomic-era | 66 | 22 |
| 05b-heterosis-dominance | 113 | 22 |
| 06-metric-catalogue | 74 | 23 |
| 07-choosing-metrics | 80 | 20 |
| 08-pipeline-stages | 47 | 17 |
| 08b-genomic-prediction | 36 | 14 |
| 09-optimal-contributions | 64 | 17 |
| 10-combinatorial-selection | 49 | 14 |
| 10b-advanced-selection | 37 | 11 |
| **11-plant-literature** | **16** | **9** |
| 11b-diversity-across-cycles | 54 | 20 |
| 11c-limits | 21 | 8 |
| 12-case-study | 22 | 15 |
| 90-notation | 40 | 12 |
| 91-package | 0 | 0 |
| 92-verification | 7 | 7 |
| 93-corpora | 2 | 2 |
| 99-references, index | 0 | 0 |

Inbound to 11 (single label `sec-plant-literature`, 16 citations from 9 files): `00:76`, `00:359`, `00:733`, `00:751`; `04d:9`; `04g:1516`; `06:331`; `07:1042`; `08:314`; `11b:343`, `11b:398`; `90:160`; `93:10`, `93:67`, `93:99`, `93:134`. Seven body chapters cite it (00, 04d, 04g, 06, 07, 08, 11b); 90 and 93 are appendices. Not cited from 11c or 12. Not a candidate for "no job": it has several, each tabled above, but five of those pointers (00:359, 06:331, 07:1042, 08:314, 93:99) make promises 11 keeps only in part (11-C15).

Outbound from 11 (self excluded): `sec-choosing` 4 (11:11, 23, 264, 306), `sec-stages` 3 (98, 144, 151), `sec-heterosis` 2 (314, 332), `sec-cycles` 2 (314, 324), `sec-collapse` 1 (52), `sec-subdivided` 1 (90), `sec-genomic-era` 1 (252), `sec-corpora` 1 (18). Zero to 00-06 (other than 02, 05), 08b, 09, 10, 10b, 04e-04g, 04d, 11c, 12.

## Not verified
- The studies themselves (11 and 10b both read abstracts); Kadoumi only through 00 and 08.
- 10 is PROVISIONAL (10-D19 open): nothing in this report rests on it beyond the budget statement 10 itself makes; 04e and 04g are open at it3, 04f approved, none has a THREAD entry.
- No render, no `_freeze` or `docs/` check.
