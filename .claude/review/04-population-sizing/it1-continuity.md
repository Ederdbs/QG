# 04-population-sizing -- continuity review, iteration 1

Chapter: `book/04-population-sizing.qmd` (`#sec-sizing`), first chapter of the Simulation part, after
`03-simulating-crosses`. Read: CLAUDE.md, `_quarto.yml`, `90-notation.qmd`, THREAD.md (00, 01, 02, 02b,
05b, 03 and every Owed line naming `04`), `part-foundations.md`, `part-verdict.md`, 00, 01, 03 (opening,
assumptions, end), 05 (A3), 06 (@sec-ns, bias), 08 (loss ledger), 11c, and the chapters that cite `@sec-sizing`.
Report only; the book and THREAD.md were not touched. Severity: H contradiction/broken promise, must fix
before the chapter closes; M; L.

## Verdict on the Owed items naming 04

| Owed item (source) | Status | Where it goes |
|---|---|---|
| `04:15` "The previous chapters took the candidate pool as given. This one asks where it comes from" contradicts 03:43-46, 03:376-384; also the wording "candidate pool" (03-C9, 00, 05b entries) | NOT settled; still in the text | fixed-here (04-C1) |
| `04:28` cross "between two divergent heterotic groups" against A3 (00:26-27, 00:199-205; 00-C2) | NOT settled; also appears at 04:16 and 04:487 | fixed-here (04-C2) |
| `04:808-809` cites @sec-coancestry for "gene diversity GD = 1 - theta"; cite @eq-hp-gd or @sec-identity (01-C8) | NOT settled | fixed-here (04-C4) |
| Keep true: 05b's callout (05b:505-542) rests on 04's P9 (`04:164-165`) listing phenotypic inbreeding depression as not modelled and "cannot be answered here" | Still true: 04:164-168 says exactly that; nothing in 04 models depression for 0 < F < 1 (F_F3 = 0.75 at 04:760 is used for coancestry only). 05b:522-523 correctly names "its P9". | keep (note 04-C8 on the label P9) |
| `04e:35-37` says 03 "derived populations from crosses already chosen" (03-C10) | Not for 04; but 04-C6 below adds that 03:165 should point to 04 | later-owed (04e); earlier-chapter (03, 04-C6) |

New items below are numbered 04-C1 .. 04-C10.

## Findings

### 04-C1 (H) -- opening contradicts 03 and uses the wrong name -- change 04
- `04-population-sizing.qmd:15-18`: "The previous chapters took the candidate pool as given. This one asks where it
  comes from: a wide cross between two divergent parents ... F1 -> F4".
- `03-simulating-crosses.qmd:43-47` ("It also builds the candidate set the rest of the book selects from") and
  `03:376-384` (every A x B combination formed; the candidate set is the complete factorial). 03 does not take the
  set as given; it builds it. 03:165-167 states the one thing it does not model: "the doubled-haploid or selfing
  path that produces inbred lines in a programme". That is exactly what 04 simulates, so the true reason 04 follows
  03 is available and 04 does not use it.
- "candidate pool": settled name is "candidate set"; "pool" means heterotic group (03, 00, 05b entries of THREAD.md;
  `part-foundations.md:117`). 04 is also on the list of chapters still carrying "candidate pool" (04:15 only; 04:806
  says "the panel this chapter sizes").
- Not "where the candidate set comes from": 04 produces a *line panel* (F4 lines from one cross), not hybrids. What
  04 builds on is the line level of the contract (03 draws lines "inbred by fiat"); the hybrid set is formed from
  lines after this. The opening must say that this chapter supplies what 03 assumed away.
- Settles: Owed 03-C9 and the "candidate pool at 04:15" items from 00 and 05b.

### 04-C2 (H) -- the cross of the chapter conflicts with A3 and 04 never says which programme step it is -- change 04
- `04:16`, `04:28-29` ("a wide biparental cross between two divergent heterotic groups", P1/P2 as "heterotic groups"),
  `04:486-488` ("If P2 is the donor whose germplasm the cross was made to introduce").
- `00:26-27` and `00:199-205` (A3: germplasm recycled only within its own pool; "A DH derived from an A x B hybrid
  would carry both pools' alleles and erode their divergence"), restated at `05-genomic-era.qmd:79-83` ("A DH taken
  from an A x B F1 ... never happens"). An F2-F4 panel from a cross between two heterotic groups is exactly the
  derived population A3 excludes from the programme. `08-pipeline-stages.qmd:358-388` (S2) uses 1770 *within-pool*
  combinations; the book's programme never selfs an A x B F1.
- Two uses are possible and 04 states neither: (a) pre-breeding / introgression from a divergent source (the
  04:487 reading, and the link to `04b`), outside the programme's A1-A8; (b) a within-pool cross whose parents are
  simply "two divergent parents" (S2/S3 of @tbl-hp-stages), in which case "heterotic groups" is wrong. The chapter
  places itself in no row of @tbl-hp-stages (S1-S4, 00:173-197), although 00:746 lists it as the answer to "how
  large must a segregating population be".
- Settles Owed 00-C2 ("state the conflict"). The 04 text, not 00 or 05, changes.

### 04-C3 (H) -- the N_s callout contradicts 01, 06 and 90 -- change 04
- `04:842-855`: "$N_s$ is not informative inside a biparental cross ... Every line descends from two parents, so the
  panel has the genetic base of a single diploid individual, which is exactly what $N_s = 1/(2\theta)$ reports. ...
  @sec-ns warns that $N_s$ describes a base ... Use $D$ and $GD$ to compare sizing scenarios within a cross, and
  $N_s$ only once material from several crosses has been pooled."
- `01-coancestry.qmd:114-118`: on molecular $\mathbf f$, $N_s \in [1/2, 1]$ "for every set ... a monotone rescaling of
  $\theta_S$", "not a head count either"; `06-metric-catalogue.qmd:151-158` (@sec-ns): "Molecular f has no base ...
  $N_s \in [1/2, 1]$ for every set ... not a number of individuals; five individuals give $N_s = 1$, not 5";
  `90-notation.qmd:627-631`. So $N_s$ is uninformative on $\mathbf f$ for any panel, one cross or many; the
  advice "only once several crosses have been pooled" is false in the book's own terms (the pooled `ctx` of 01
  has $N_s$ between 0.5 and 1 too), and "reports the base of a single diploid" is a head-count reading the earlier
  chapters withdraw. The bound itself ($1/(2-D)$, at most 1) is correct and agrees with them.
- Spread: `04d-breeding-programme.qmd:376-379` cites 04 for a different reason ("a homozygous line has
  self-coancestry 1 and the diagonal dominates") -- two explanations of the same fact in two chapters. 04d is a
  later chapter and should follow whatever 04 keeps.
- Wording: "@sec-ns warns that $N_s$ describes a base rather than projecting drift" does not match 06:174-188 (static
  descriptor of a set, not a drift projection; the base reading is what 06 *denies* for $\mathbf f$).

### 04-C4 (M) -- GD cited to the wrong place -- change 04
- `04:808-809`: "molecular coancestry $f$ and gene diversity $GD = 1 - \theta$ (@sec-coancestry)". 01 defines $\theta_S$
  and $\mathbf f$ but not $GD$; the definition is @eq-hp-gd (`00:395`, $GD_S = 1 - \theta_S = H_e$) and its
  derivation @sec-identity (`06:80`). Open item 01-C8, unchanged. The bridge paragraph at `04:830-836` then
  re-derives $GD = 1 - \theta = \overline{2p(1-p)}$ in two sentences without citing either.

### 04-C5 (M) -- the bridge "raw material for everything else" is asserted across assumptions the panel does not satisfy -- change 04
- `04:804-808`, `04:837-840`: the F4 panel "can be pushed straight into" the kernel; "the sizing decision made here
  therefore sets the $GD$ that @sec-choosing, @sec-ocs and @sec-combinatorial spend the rest of the book budgeting".
- A2 (`00:24-25`, `05-genomic-era.qmd:54`): parent lines fully inbred; 04's F4 lines carry $H = 0.125$ (`04:126-130`), so
  $GD_{WI} = H_o/2 > 0$ (`02:1035`) and the line-level identity $\theta_S = \mathbf w'\mathbf f^L\mathbf w$ and the
  "$GD_{WI} = 0$ exactly" statements do not apply to this panel. A5 (`05:94-95`) and 03:141-176: independent loci;
  04's markers are linked by construction (map, Haldane, `04:67-80`). A6/A8: the later budgets are against the frozen
  `ctx$p0` and a random-subset reference (`gd_ref`), the teaching scale 25 + 25 lines / 2000 markers; 04's $D$ has
  the panel itself as base and the cross's own maximum 0.5 as denominator (`04:151-153`, `04:836`), and its markers
  (about 167 at 10 cM, `04:814`) are not `book_cfg`'s.
- What 04 establishes is the line-level quantity of one derived panel; the quantity the later chapters budget is the
  gene diversity of hybrids formed from many such lines in two pools ($GD_T = GD_{WS} + GD_{BS}$ for hybrids,
  02:1035-1040). The sentence conflates the two levels. It also assumes the panel is a *pool* in the sense of the
  later chapters, which ties to 04-C2.
- Needed: one declared sentence of scope (which of A2, A5, A6, A8 the chapter does not satisfy and that $D$ and the
  later $GD$ are on different bases), not a new derivation.

### 04-C6 (M) -- 03 should point to 04, and 04's "ceiling" claim is promised-to-be-measured and not measured -- change 03 (pointer), 04 (claim)
- Pointer: `03:150-152` ("@sec-alphasimr relaxes this (linkage, outbred founders, directional dominance and several
  generations of selection)") and `03:165-167` ("does not model the doubled-haploid or selfing path ...
  (@sec-hp-cycle)") name no chapter that does. 04 is the chapter that models the map, meiosis and the selfing path
  (`11b:78-79`: "@sec-sizing is where linkage is modelled properly"). 03 and 04 are both in the Simulation part and
  04 has no inbound reference from 03. Earlier chapter: 03 (add a cross-reference at 03:165).
- Claim: `04:806-807`: "the claim that its diversity is a *ceiling* should be measured rather than asserted".
  The table that follows (@tbl-sizing-bridge, `04:811-828`) measures the identity $GD = D/2$ and $N_s = 1/(2-D)$; it
  measures nothing about a ceiling. `04:837-840` then asserts "An optimiser cannot select back up to variation the
  panel never sampled; the best it can do is spend what is left more slowly", which `index.qmd:116-118` repeats and
  cites to @sec-sizing. True for alleles absent from the panel; for $GD$ of a *subset* the book's own results
  (`06:574` "$\alpha < 0$ means more diverse than chance"; `06:177-180`, optimisation increasing diversity,
  negative $\Delta F$; `09:188` "maximum attainable $\alpha$") show that frequency rebalancing can raise a subset's
  $GD$ relative to chance. The chapter must either measure (a selection from the F4 panel against its whole-panel
  $GD$) or drop "measured rather than asserted". Not decidable from earlier chapters; 03 only shows whole set
  above *random* subsets (03:663-723).

### 04-C7 (M) -- symbols reused or doubled against 00, 02, 90 -- change 04 (and 90, owed)
- $H_t$: `00:599-604` $H_t$ = expected heterozygosity $m^{-1}\sum_k 2p_kq_k$ of a set at generation $t$ (drift,
  @eq-hp-drift); `04:129-130` $H_t$ = heterozygosity of the *parent whose meiosis produces generation $t+1$*
  (junction recursion). Two quantities, one symbol; THREAD (00 entry) says $H_t$ "needs no row" because it is used
  only in 00, which 04 and the sizing table of 90 (`90:343-351`) now falsify; 90 itself uses $H_t$ in the other sense at `90:262` ($1 - \overline{H_t/H_0}$).
- $H$ (no subscript): `04:155`, `04:797` is the per-plant observed heterozygosity ($= H_o$ of `00:406`, `02:164-171`,
  the 0.125 of F4); in 02 plain $H$ is gene diversity ($H_T$, $H_S$, @eq-f-stats-het, `02:366-368`); and the $D$ of
  04:150 is built on $2p(1-p) = H_e$. The same quantity as $H_o$ gets a second symbol, and the unsubscripted symbol
  has a different meaning in 02. 04 does not say $H$ is $H_o$; 90's row ("panel heterozygosity") also doesn't.
- $F_{F3}$ (`04:760`, "inbreeding of an F3 plant, F1 as base"): 00 fixes the convention $F^{(t)}$ with the filial
  generation $F_{t+1}$ having $F^{(t)}$ (`00:84-90`); 04's value (0.75) agrees but the symbol and the F1 base are
  not those of 00, and the selfing series is re-stated at `04:209-210`, `04:202` without citing @sec-hp-inbreeding /
  00:78-96. No row in 90.
- $N_e$: `04:41`, `04:774` use "the genetic $N_e$ of the F1 is 1" as a head count while `04:797-802` says $N_{eq}$ is
  "not a Wright effective size" and 00 defines $N_e = 1/(2\Delta F)$ rate-based (`00:599-617`). Say once what $N_e$
  means in the P2 sentence, or use another term.
- The other sizing symbols ($N, n, L, k, \beta, p, D, A_t, d, r, g$) are declared local in `90:378-383` and defined
  inline in 04; no further finding, except that $P$ (probability, `04:543`) is never defined in the prose.

### 04-C8 (L) -- "P1" ... "P9" label the assumptions and also the parents -- change 04
- `04:38-173` labels the assumptions P1-P9 (A1-A8 are the book's other list); `04:27-31`, `04:40` use P1, P2 for the
  parents ("frequency of P1 ancestry", "P2 homozygote", "P2P2"). "Assumption P2" and "parent P2" are adjacent
  (`04:40` heads the assumption P2 and 04:92 says "against P2 ancestry"); "P7" is cited for `(1-H)/2` the
  probability of a P2P2 line (`04:550-551`). 05b cites "its P9" (`05b:522-523`), so the label is now a cross-book
  address. Rename one family, keep P9's text (see Owed table, "keep true").

### 04-C9 (M) -- the finite-panel loss $1 - (1-H)/N$ is not tied to its siblings -- change 04 (cross-reference), 05b/03 keep
- @eq-sizing-div, `04:154-158`: $\mathrm E[D] = 1 - (1-H)/N$, checked by simulation, not derived. At $H = 0$ it is
  the loss for $N$ inbred lines: the same $1/n$ as the DH statement of `00:618-626` ("a pool re-derived as $n$ DH lines ... passes
  $n$ copies", after @eq-hp-drift at `00:602`) and as the per-marker $(1 - 1/n)$ finite-pool factor derived in
  `05b:722-760` and `03:315-331`, and the bias of `06:521-536` (@eq-catalogue-bias, $1/n - 1/N$). 04 does not mention
  any of them, calls the loss "drift" (`04:427-428`) without linking @eq-hp-drift's $n_{gam}$, and never says that
  $N/(1-H)$ is the number of gametes the F4 panel passes ($1 \le$ copies per line $\le 2$). Four chapters now
  hold the same sampling factor; 05b should own it (foundations-C7) and 04 should cross-reference and say what the
  $H$-correction adds, not re-state it as new.

### 04-C10 (L) -- closing promises -- change 04 (soften) / later-owed (08, 11c)
- `04:857-859`: "@sec-stages puts a number on how the loss is distributed across the whole pipeline" -- kept
  (`08:355-388`, DH induction 77% of the loss). "...and this stage is where the cheapest insurance is available --
  more plants, once, at the start": 08 does not vary plants per cross; it says the S2 stage is "the cheapest stage
  to constrain" through *cross selection* (`08:387`) with 40 DH per cross fixed (`08:358`). The insurance 04 claims
  is not what 08 shows. 08 also does not cite @sec-sizing (zero outbound reference to 04).
- `04:859-861`: "@sec-limits ... the same argument ... about the variance rather than the frequencies, and reaches
  a different conclusion about what is recoverable": loosely kept at `11c:212-213` ("recombination repays it");
  11c does not cite @sec-sizing and does not frame itself as "the same argument". Judge in 11c's review.
- The Simulation-part transition out is 04b (`04b:40`, `04b:859-863` explicitly mirror 04: "size for the objective
  that binds") -- consistent with 04:20-23, 04:526-528 and `04:750-792` (working-numbers table). No finding.

## Numbers, definitions, redundancy -- items checked and found consistent
- $D = \overline{2p(1-p)}/0.5$, $GD = D/2$, $N_s = 1/(2-D)$: consistent with `90:352`, `90:70-78`, `00:395`; the
  bridge chunk asserts $GD = D/2$ and $N_s = 1/(2-D)$. $\theta$ as the mean of $\mathbf f$ over all pairs with self
  included agrees with 01:108 and @eq-hp-gd. Selfing series ($H = (1/2)^{t-1}$ in $F_t$; F4 = 0.125) agrees with
  00:84-90. Coancestry of plants of one F3 line, $(1+F)/2 = 0.875$ with $F = 0.75$, agrees with the
  self-coancestry convention of 01/90. No number is quoted from an earlier chapter that differs from where it is
  computed (04 quotes none from 00-03, 05b).
- @tbl-sizing-f4-identities, @eq-sizing-div, @eq-sizing-n95, the junction recursion: derived and checked only in
  04; no other chapter develops them. `04b` simulates its own meiosis (`R/08_mabc.R`) on a 5 cM grid; no redundancy
  with 04's tables found.
- Assumptions of the F1 section: $h_{res} = 0.05$ and heterozygosity independent in the two parents relax A2 and P2;
  the chapter declares this (`04:42-43`, `04:688-704`).

## Cross-reference graph for 04 (`#sec-sizing`, children `#sec-sizing-*` have no external inbound)

Inbound to `04` from other files (citations of `@sec-sizing`), counted per citing file, self-citations excluded:

| Citing file | Count | Where |
|---|---|---|
| `04b-backcross-introgression.qmd` | 4 | 40, 811, 859, 863 |
| `90-notation.qmd` (appendix) | 3 | 378, 414, 416 |
| `05b-heterosis-dominance.qmd` | 2 | 522, 523 |
| `92-verification.qmd` (appendix) | 2 | 189 (string), 236 |
| `00-hybrid-programme.qmd` | 1 | 746 |
| `04c-alphasimr-pipeline.qmd` | 1 | 662 |
| `04d-breeding-programme.qmd` | 1 | 378 |
| `11b-diversity-across-cycles.qmd` | 1 | 79 |
| `index.qmd` | 1 | 117 |
| `91-package.qmd` (appendix) | 1 | 63 |
| **Chapters (excluding appendices, index)** | **10 citations from 6 chapters** | 00, 04b, 04c, 04d, 05b, 11b |
| `03-simulating-crosses.qmd`, `08-pipeline-stages.qmd`, `11c-limits.qmd` | 0 | the chapters that should cite it (04-C6, 04-C10) |

04 has a job (6 citing chapters). Outbound from 04 to other files: @sec-coancestry (01), @sec-choosing (07),
@sec-ocs (09), @sec-combinatorial (10), @sec-ns (06), @sec-stages (08), @sec-limits (11c). All resolve to existing
`{#sec-...}`; no broken `@sec-`, `@tbl-`, `@fig-` or `@eq-` target inside 04 (17 tbl/fig labels and 2 equations, all
defined and cited). 04 cites nothing from 00, 02, 02b, 05b, 03, although it relies on 00's selfing series, A2, A3,
@eq-hp-gd and @eq-hp-drift; all forward citations (06, 07, 08, 09, 10, 11c) are to context, none a dependency, and
none is marked "later" (acceptable for a "where this connects" section; 04-C3 shows one is mis-paraphrased).

## Transition summary
- In: the opening (04:15-18) says why 04 follows 03 wrongly (04-C1); the true reason (03:165-167, no selfing path)
  is not used.
- Out: 04b opens by reading 04 correctly (04b:40, 04b:859-863).
- Promises into 04 kept: P9 (05b). Promises into 04 not kept: 03-C9 candidate pool, 00-C2 A3, 01-C8 GD citation.

## Counts
H: 3 (04-C1, 04-C2, 04-C3). M: 5 (04-C4, 04-C5, 04-C6, 04-C7, 04-C9). L: 2 (04-C8, 04-C10).
Owed items: 3 fixed-here (04:15, 04:28, 04:808-809), 1 keep-true confirmed (P9), 1 later-owed (04e:35-37).
