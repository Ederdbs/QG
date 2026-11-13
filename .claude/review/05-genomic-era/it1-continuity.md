# 05-genomic-era -- it1 continuity (chapter mode)

Scope: `book/05-genomic-era.qmd` (1864 lines) against 00, 01, 02, 02b, 05b, 03, 04, 04b, 04c (all as THREAD entries; text read where cited) and the later chapters that cite it or that it cites (06, 08, 08b, 11b, 11c, 12, 90). Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-04-06`. Nothing rendered; every number below is either an inline `r` expression or a line count. No book edits, no THREAD entry.

Framing correction. By `_quarto.yml` chapter 05 is the FIRST chapter of "Metrics and prediction" (after 04c), not the last of "Simulation". 04c closes Simulation (04c:2331-2333: "This closes the Simulation part ... starting with @sec-genomic-era"). 05 is the consumer of the Simulation part; it restates A1-A8, which 00:18-42 already restates for use before 05.

Result in one line: 6 H, 9 M, 6 L. Mechanically sound: every `@sec-` of 05 resolves (24 distinct targets, 0 broken), 44 inbound references. The H items are the unsettled Owed items from 00 (A5, `run_cycles()`), the F_ST naming still opposite to 02, and three forward promises made TO 05/by 05 that the target does not keep (marker-versus-QTL, the cycle-by-cycle audit, overlapping cycles).

## Findings

### H

**05-C1 (H) -- A5 says "markers are neutral" and the audit of Step 5 rests on it; the data of the chapter are not neutral. [05; settles Owed 05-3 as NOT settled]**
- `05:91-95` A5: "Markers are neutral, biallelic ... linkage equilibrium within pool because each line's genotype is drawn independently (`simulate_lines()`)". `05:6` builds `ctx <- simulate_data(book_cfg)`, whose traits have effects at every marker (`03:141-176`, THREAD 03; `00:37-42`: "wherever the book selects on that index, the markers its metrics read are themselves under selection"; Owed from 00: "A5 must say which simulator it covers").
- 05 selects on that index throughout: truncation (`05:231-234`, `05:1395-1398`), `sel_greedy(w = 1)` (`05:233`, `05:937`), the capped row (`05:1398`).
- Step 5 (`05:1299-1372`) calls the held-out half "loci the optimiser never saw". `05:1320-1321` asserts `c_mgmt$index == ctx$index`: the index-weighted plan is chosen on an index whose effects sit at every marker, the audit half included. So the audit half was seen by the `index` row through the trait; only the `max_div` row (w = 0) never saw it. The "first limit" of `05:1355-1360` (linkage equilibrium makes the audit a best case) does not mention it.
- `05:1757-1759` ("measured here: raising heterozygosity on the monitored panel does not raise it at unmonitored loci") and `05:1352-1354` inherit this: "unmonitored" is not "neutral" in this data.
- Change: 05. State which simulator and which loci carry effects (A5 and Step 5); distinguish the `max_div` and `index` rows of the audit.

**05-C2 (H) -- "`run_cycles()` ... implements exactly this loop". [05; Owed 05-2 NOT settled]**
- `05:83-84` against `00:213-219` (reduced form: recycling by `line_weights()`/`next_pool()`, no trials, no S3, index known without error; 11b C7, C8) and `11b:80-90` (C2: recycling by DH; C3: constant pool sizes). A3 as stated in 05 ("lines are chosen on hybrid performance against the opposite pool") is not what `run_cycles()` does: it selects on a known index, not on testcross performance.
- Change: 05 (reduce to "in reduced form", point to 11b's C-list).

**05-C3 (H) -- the F_ST naming of 05 is the opposite of 02's and the attribution to Wright is unverified. [05; Owed 05-8 (from 02) NOT settled; 08 follows]**
- `05:358-365`: the standardised-variance form "@wright1951 introduced"; "the chapter's own F_ST column (@sec-era-step6) is the Nei G_ST [@nei1973] of `gd_partition()`, a different statistic on a different partition". `05:1487-1492`: "`gd_partition()`'s `F_ST` is GD_BS/GD_T, which is the Nei G_ST form ... `Fst_Wright` is the other definition". `05:1466` caption: "two definitions of F_ST (Wright, Nei's G_ST)".
- `02:340-427` (@eq-f-stats): the book's F_ST IS $GD_{BS}/GD_T = \bar D/(1-\bar f)$, at one locus $\Delta p^2/(4\bar p\bar q)$, i.e. the standardised-variance form; the Wright credit is C&T's (Eq. 6, Wright 1969) and Toro & Caballero's (Cockerham 1969), "originals not read"; the between-referenced statistic is "also written F_ST", cites no external source, and "in this chapter it is always @eq-f-stats". `00:575-581` agrees with 02 and says 08 calls GD_BS/GD_T $G_{ST}$. `wright1951` carries a 1949 DOI against the year 1951 (THREAD 00-B13).
- So 05 (a) says the book's F_ST is not the standardised-variance form, which 02 shows it is at each locus; (b) labels the between-referenced statistic "Wright's"; (c) attributes to `wright1951` a form 02 credits elsewhere. 05's `F_ST` column itself (`05:1400`, `05:1434-1453`) agrees with 02; the surrounding prose does not.
- Change: 05 (reconcile with 02:340-427; withdraw the `wright1951` attribution or mark it unverified). 08:86-106 (Trap 2, `F_{ST}^{(W)}` / `G_{ST}`, `d$Fst_Wright`) is later-owed to 08 (already in the 00 and 02 entries).

**05-C4 (H) -- promise from 04c (and 04d) that @sec-genomic-era "takes the marker-QTL gap seriously" is not kept. [05 or 04c/04d; Owed 05-12 judged otherwise by the 04c review]**
- `04c:430-436`: every segregating site is a QTL "so there is no marker-versus-QTL gap to reason about. Real programmes have that gap; @sec-genomic-era is where the book takes it seriously". `04d:427`: "@sec-genomic-era is where marker-versus-QTL, the reason that accuracy is finite, is taken seriously".
- 05 mentions QTL only in `05:399-401` (hitch-hiking, one sentence), `05:511` (Meuwissen's four panels, "a QTL panel") and `05:714` (A's overshoot). No computation separates marker from QTL panels; the book's own data have effects at every marker (05-C1), exactly the collapse 04c declares. The audit (Step 5) is management panel versus audit panel, not marker versus causal locus. The 04c review read the promise as kept on the strength of the Meuwissen panels (THREAD 04c); on this reading the promise is kept only as a report of a paper's design.
- Change: either 05 gets a measured treatment (and says A5/A7 are where the book collapses the gap), or 04c:435-436 and 04d:427 are reworded to what 05 does. This is a decision for it2.

**05-C5 (H) -- 05's promise that @sec-cycles carries the cycle-by-cycle audit is not kept. [11b or 05]**
- `05:1361-1362`: "the cycle-by-cycle version of the same audit is @sec-cycles". `grep -i audit` over `11b-diversity-across-cycles.qmd` is empty; so is the half-panel idea (no `odd`, `unmonitored`, `split`). `12:199-250` (checklist, "Validating the plan") has no audit item although 05's checklist has one (`05:1851`).
- Change: 05 (drop the claim) or 11b (add it). Later-owed to 11b if the claim stays.

**05-C6 (H) -- 05's promise that @sec-limits treats overlapping cycles is not kept. [11c or 05]**
- `05:86-89` (A4): "Real programmes overlap cycles and reuse the same line for years, which biases any $\Delta F$ read off a cycle index; see @sec-limits". `11c-limits.qmd` headings (1, 19, 54, 77, 96, 151, 169, 193, 207, 228): Robertson's limit, the $R^2$ column, what metrics cannot see, C1 restated, reproducibility trap; `grep -i "overlap|reuse|cycle index|year"` over 11c is empty. (11b:80-90 does not discuss overlap either; its C3 only says pool sizes are constant.)
- Change: 05 (point to where it is true or state it as unmeasured) or 11c.

### M

**05-C7 (M) -- the opening claims a link to the Simulation part that the chapter does not use. [05; check 6]**
- `05:12-14`: "The Simulation part produced populations whose true history is known; this part measures them". Outbound `@sec-` from 05 to 03, 04, 04b, 04c: ZERO (no `@sec-simulating-crosses`, `@sec-sizing`, `@sec-backcross`, `@sec-alphasimr`); the only populations measured are 03's `simulate_data(book_cfg)` (`05:6`) and the toy `pool_traj()` (`05:1014-1033`) -- not the F4 panel (04), a conversion panel (04b) or an AlphaSimR cycle (04c), all outside A1-A8 (A2 for 04 and 04c's outbred founders; A5 for 04, 04b main body, 04c).
- The opening also does not say why 05 follows 04c (04c:2331-2333 says why 04c hands on to 05; 05 does not answer), nor name 03 as the generator of A5/A6/A8 (`05:91-99`, `05:106-110` rest on 03:141-176, 03:558-567).
- Change: 05.

**05-C8 (M) -- "dominance deviation" for $d_k$ is still in 05. [05; Owed 05-9 (from 05b) NOT settled]**
- `05:325-326` ("$d_k$ the dominance / deviation at locus $k$", break inside the phrase). `05b:150-156` fixes "dominance effect", reserves "dominance deviation" for Fisher's term, and says "@sec-genomic-era among them" still uses the older name.
- Change: 05.

**05-C9 (M) -- the hybrid-level identity is cited at the wrong section. [05]**
- `05:221-222` ("on the full factorial it equals $GD_T + GD_{BS}$ ... (@sec-heterosis-identity)") and `05:74` ("the identity @sec-heterosis derives"). The identity $2\,GD_{WI\text{-}hyb} = GD_T + GD_{BS}$ (@eq-het-wi-hyb) and its limit on selected subsets are in @sec-heterosis-hybrid-identity (`05b:382-418`, THREAD 00 entry); @sec-heterosis-identity (`05b:267`) is the per-locus split @eq-het-split. 05's `05:276-285` and 05b's `05b:411-418` agree on the content (max departure on four selections, three distinct).
- Change: 05 (cite @sec-heterosis-hybrid-identity / @eq-het-wi-hyb).

**05-C10 (M) -- one quantity with two symbols, one symbol with two senses inside 05. [05, then 90]**
- Markers: $N_{SNP}$ at `05:182-189`, `05:354`, `05:417` against $m$ at `05:1595-1596`, `05:1613` and `ctx$m` throughout; `90:15` $m$ = markers; `90:472` $N_{SNP}$ is a row of the joint-allocation table ("markers; replaces $m$, which marks the male pool"), local to 04g. 05 declares $N_{SNP}$ only by the Meuwissen citation (`05:188-189`).
- $\alpha$: `05:1549`, `05:1742-1744`, `05:1855` write $\alpha$ for the ridge added to the diagonal; `05:389-390` and `05:1424` use $\alpha$ for the diversity-loss statistic (and `05:389-390` says the average effect "classically written $\alpha$" is NOT it, in this book); `90:278` $\alpha$ is the budget. Three senses of one letter in a chapter that has declared the clash once.
- Change: 05 (one marker symbol; a different letter for the ridge or an explicit local declaration); 90 follows.

**05-C11 (M) -- the loss $\alpha$ is reported against one random draw, the practice the chapter argues against. [05]**
- `05:1422-1426` and `05:1526-1527`: truncation costs X% of gene diversity "against the random baseline ... computed here on a single random draw rather than on the resampled `gd_ref`"; `00:310-321` defines $\alpha$ against $GD_{\text{ref}}$ = mean GD of random subsets; `05:254-318` and `05:908-916` show that a single `random` draw is no control, and `null60$gd_ref` is in scope (`05:888`).
- Change: 05.

**05-C12 (M) -- 05 uses results of earlier/later chapters without citing the chapter that owns them. [05; check 7]**
- The random-subset null and $\alpha$ baseline (`05:254-263`, `05:869-872`: `null_distribution()`, `discriminatory_power()`, `gd_ref`) are 00:267-321's and 06's (@sec-baseline, @sec-catalogue-null); 05 cites 00 once (`05:42`) and 06 only as @sec-catalogue for `GD`/$\alpha$ (`05:1412`, `05:1425`). The reader meets z-scores against the null in Part 4 without a pointer, although 06 is later.
- The partition $GD_T = 1-\bar f$, $GD_{BS} = \tilde f - \bar f$, $\bar f = (\theta_A + 2\theta_{AB} + \theta_B)/4$ is restated twice (`05:214-216`, `05:1439-1441`) with [@caballero2002] and no `@sec-subdivided` / `@eq-gd-partition`, although 02 owns it (`02:340-441`, `fst-two-forms` chunk) and the three statements agree. Same for 00's $GD_S = 1-\theta_S$ (@eq-hp-gd) at `05:1411-1416`.
- Change: 05 (cross-reference rather than restate; declare the forward use of 06).

**05-C13 (M) -- A1-A8 are stated in 05 but only 04 and 04b say where they stand against them; 03 and 04c do not. [04c, 03, and 05]**
- 04: A3 exception declared (`04:24-35`), bridge scope under A2/A5/A8 (`04:1075-1084`). 04b: A2 kept, A3 not met, A5 dropped then restored, A1/A4/A6/A7/A8 unused (`04b:65-80`). 03 uses no A-labels (`grep "\bA[1-8]\b"` returns nothing); 04c uses none (`04c:46-55` lists the relaxations of 03's assumptions in words). 04c Step 8 departs from A2 (outbred founders), A5 (`runMacs` LD), A7 (dominance in the genotypic value) and uses A3's loop; this is nowhere mapped onto 05's labels, and 05 does not say its A-list is not the Simulation part's.
- The A3/A5 pair in 05 is also not reconciled: A5's "each line's genotype is drawn independently" holds for the founding pool only; under A3's within-pool recycling lines share ancestors (`05b:1915-1920`, `11b:80-90`); 05 says neither at `05:91-95` nor at `05:1355-1360`.
- Change: 04c (a sentence placing it against A1-A8, as 04 and 04b do), 05 (A5 scoped to the founding pool).

**05-C14 (M) -- later chapters contradict the rule 05 sets for reading $\Delta F$. [11b, later-owed; 12]**
- `05:1283-1291`, `05:1850`: $\Delta F = 1 - e^{\text{slope}}$, not $-\text{slope}$, with a stated error of about $\Delta F/2$. `11b:238-243`: `dF_per_cycle = -coef(f)[["cycle"]]`, `Ne = 1 / (-2 * coef(f)[["cycle"]])`, the first-order form. `11b:234` attributes the regression recipe to @sec-case-study's checklist; 05 owns it at `05:993-1297` and its own checklist (`05:1836-1857`).
- Change: 11b (later-owed); 05 keeps true `05:1287` ("@sec-cycles fits the same regression to `run_cycles()` output") and `05:1296` (the diagnostic fires on the unconstrained run; 11b:247-253 does).

**05-C15 (M) -- the span/rank argument of Step 7 is rederived in 08b. [08b, later-owed; 05 owns]**
- `05:1614-1638` (@eq-era-rank, $\mathbf X = \tfrac12\mathbf B\mathbf G^L$, rank $f$ $\le$ rank $\mathbf B$; measured rank $f$ = $L-1$, rank $G$ = rank $f$ - 1) and `05:1710-1732`; `08b:208-250` (@sec-g-singular: "every hybrid row is an average of two line rows ... rank(G) = L - 2", 48 at book scale, 577 zero eigenvalues). The numbers agree (L-1 = 49 for $f$, L-2 = 48 for $G$ at 25+25); 08b does not cite @eq-era-rank, and 05 sends the reader forward to 08b (`05:1732`).
- Change: 08b cross-references 05's derivation (05 is earlier and carries the theorem and the measured/asserted split).

### L

**05-C16 (L) -- "candidate pool" is still in 05. [05; Owed 05-6 NOT settled]** `05:735` ("candidate-pool allele frequencies"), `05:829`, `05:876` (caption), `05:926` ("one candidate\npool", across a line break). Settled name: "candidate set" (00, 03, 05b). `90:20`, `90:30` are owed to 90 (THREAD 03 entry).

**05-C17 (L) -- scientific notation still bare in prose. [05; Owed 05-5 NOT settled]** `05:783-784` (`sprintf("%.1e", ...)`), `05:944` (`sprintf("%.2e", ...)`), `05:1704` (`signif(ev_min, 2)`), `05:1743` (`signif(abs(ev_min), 1)`) print `1.2e-15`-type values inline; `fmt_sci()` exists (`book/_common.R:48`).

**05-C18 (L) -- two checklists. [05 or 12; check 4]** `05:1836-1857` (15 rows) and `12:199-250` repeat the same items (frozen base, both lenses separately, `cov_diag`, $\log(1-F)$ regression, plausible number of parent lines); 12 omits 05's audit, rank check and $\Delta F = 1 - e^{\text{slope}}$ rows, 05 omits the allelic-richness and $N_s$ rows. State which one owns (12 is the end-of-book checklist; 05's is keyed to its steps).

**05-C19 (L) -- letters reused across Simulation and 05. [04, 05, 90]** $H$: observed heterozygosity in 04 (`04:164-167`, disclaimed there) against $H_{t,k} = 2p(1-p)$ expected heterozygosity in 05 (`05:187`, `05:182-183`); $G_i(p)$ (`05:490`, a Meuwissen/Liu matrix) against $G_i$, the Caballero-Toro statistic of `90:182`; `90` has no rows for `G_VR1`, `G_VR2`, `G_i(p)`, `G_LA`, `G_ROH`, which 05 uses as names in backticks only. 05 is true without them.

**05-C20 (L) -- "This book has no IBD route at all". [05]** `05:1764-1766` is true of relationship matrices in an optimiser. The Simulation part tracks descent in its own simulators (04 SA1 ancestry; 04b's $\mathrm{IBD}_E$, `04b:330-374`; pedigree $\mathbf A$, `90:55`; `05:1857` "where possible, an IBD alternative"). Restrict the claim to the optimiser's matrices.

**05-C21 (L) -- "production scale". [06, 12 later-owed; 05 stands]** `05:108-109` (71 + 71 lines, 25000 markers, "no chunk of this chapter runs") agrees with `R/00_data.R:9-10` (roxygen: production = 71 + 71, 25000; `sim_config` = development configuration, 50 + 50, 5000) and with `03:15`, `03:380`. `06:620` and `12:35` call `sim_config` itself the production scale. CLAUDE.md says both. Later-owed to 06, 12 (already in the 00 entry).

## Owed items naming 05: settlement

| # | Owed (source) | Status | Where |
|---|---|---|---|
| 1 | Comstock et al. (1949) as attribution of A3 at 05:80-81 (00, 05b) | PENDING by the user's declaration: record, not a finding to fix. 05 still cites `@comstock1949` at `05:81` for "lines are chosen on hybrid performance against the opposite pool and recycled inside their own pool"; 00:207 and 05b cite it for title/heterotic structure only; 04c title only; the paper is unread | user |
| 2 | `run_cycles()` "implements exactly this loop" (00-C6) | NOT settled | 05-C2, fix in 05 |
| 3 | A5 must say which simulator it covers (00-C6) | NOT settled; a deeper form found | 05-C1, fix in 05 |
| 4 | two values of "production scale" (00-C22) | 05 consistent with R/00_data.R and 03; 06 and 12 follow | 05-C21, later-owed 06, 12 |
| 5 | bare scientific values at 05:1704, 05:1743 | NOT settled (also 05:783-784, 05:944) | 05-C17, fix in 05 |
| 6 | "candidate pool" 05:829, 05:876 | NOT settled (also 05:735, 05:926) | 05-C16, fix in 05 |
| 7 | promise: consequence of the F_hom/F_drift gap "measured where those metrics are reported" (01:487-491) | kept: `05:892-930` and the pull toward 0.5 at `05:195`, `05:518-556`, `05:927` | settled-kept |
| 8 | 05:360-364 Wright attribution and the Nei G_ST naming, opposite to 02 and 00 (02) | NOT settled | 05-C3, fix in 05 (08 follows) |
| 9 | `05:325-326` "dominance deviation" for $d_k$ (05b) | NOT settled | 05-C8, fix in 05 |
| 10 | Comstock at 05:80-81 (05b) | same as 1 | PENDING |
| 11 | keep true: A5 (`05:94-95`) = 03:141-176; A6 / `ctx$p0` frozen (`05:97`, `05:186`) = 03:558-567 (03) | kept as to the text: `05:745` asserts $p_0 = (p_A + p_B)/2$, `05:798` says `build_ctx()` recomputes `colMeans(X)`; A5's neutrality caveat is 05-C1 | settled-kept, with 05-C1 |
| 12 | 04c:435-436 marker-QTL promise (04c) | NOT kept on this reading; the 04c review read it as kept | 05-C4 |
| (dup) | "candidate pool" at 05:829, 05:876 (05b entry) | same as 6 | 05-C16 |

## Cross-chapter checks that held (no finding)

- Notation: $F_{hom}$, $F_{drift}$, $\kappa$, `cov_diag`, $\mathbf B$, $\mathbf G^L$, $\mathbf G_{0.5} = 4\mathbf f - 2\mathbf J = 8\mathbf Z_h\mathbf Z_h'/m$, $\theta_A, \theta_B, \theta_{AB}$ agree with `90:18-61`, `90:255-270` and with 00/01/02; $p_{0,k}$ for the frozen base agrees with 01:420-446 and 00:368.
- Numbers: 05 hard-codes none of the chapter-computed values of 00/03 (0.3617, 0.3281); the live `fmt(mean(ctx$X == 0.5), 3)` is the 0.3617 of 03. rank(f) = L-1, rank(G) = L-2 agrees with 08b:245-250. $\Delta F = 1/n_{gam}$, $N_e = n_{gam}/2$, crossing block $N_e = n$, DH pool $N_e = n/2$ (`05:999-1002`) agrees with @eq-hp-drift (00:587-695); 05 re-simulates the two regimes on frequencies as a calibration of the regression and not as a derivation (acceptable duplication of the experiment, not of the formula).
- Assumptions: $F_{hom}$ read on the merged-pool $H_e$, not on the product's $H_o$ (`05:218-225`) agrees with 00:569-575; the inbreeding-depression statements (`05:325-343`) agree with 05b's exact zero for inbred lines (`05b:~470-480`) and its "book computes it for no partially inbred generation" (`05b:529`, true of `05:325`); 05b:413 ("@sec-era-fhom ... four 60-hybrid selections, three distinct, largest departure of the four") is true of `05:276-289`.
- Promises kept in the target: `@sec-cycles` fits the log regression and fires $R^2$ on the unconstrained run (11b:234-253, `05:1287`, `05:1296`); `next_pool()` draws one Bernoulli per locus per new line (11b:84-86, `05:1004`); the cap's cost is paid in 11b (11b:308-338, `05:1511`); `@sec-case-study` reports `ne_parents()` (`05:1523`, checklist in 12). 00's pointers to 05 (`00:568` $F_{drift}$, `00:624`, `00:702` Step 4, `00:733` transposition, `00:747`) all resolve to what 05 contains.

## Does the Simulation part hold with 05? (not the part review)

Read as 03, 04, 04b, 04c followed by 05:

- 03 -> 05 holds: A5 and A6/`ctx$p0` agree with 03:141-176 and 03:558-567 (Owed 03 "keep true" kept); 03 forward-points to 05 for $F_{hom}$ and $F_{drift}$ and 05 delivers. The caveat is 05-C1/05-C7: 05 never cites 03.
- 04, 04b -> 05: both declare their departures from A1-A8 in A-labels (04:24-35, 04:1075-1084; 04b:65-80) and those agree with the 05 list. Neither is measured, cited or reused in 05 (zero outbound). 04's bridge ($N_s \in [1/2, 1]$, $D$ vs GD) is the only place where a Simulation chapter touches a 05 quantity, and it points to 00/06, not to 05.
- 04c -> 05: 04c:2331-2333 hands on explicitly; 04c:435-436 and 04d:427 promise a treatment of marker-versus-QTL that 05 does not give (05-C4), and 04c's relaxations of A2/A5/A7 are not placed against the A-list (05-C13). `alphasimr_gd()` (04c) and `gene_diversity()` (05) are the same $1 - \theta$; consistent.
- Inbound/outbound: 05 receives 44 inbound references (00, 01, 02b, 03, 04, 04b, 04c, 04d, 04g, 05b, 06, 07, 09, 11, 11b, 12, 90, 92); outbound to the Simulation part: 0. 03, 04, 04b and 04c are used by 05 only through the package functions; the part's boundary on the Metrics side is declared on one side (04c) only.
- Verdict for the part review that will follow: the Simulation chapters are consistent among themselves on A-labels (04, 04b) and on the p0/Balding-Nichols objects (03, 04c); the open items sit at the 05 end (05-C1, C3, C4, C7, C13). A part review should hold 03-05 until 05-C1 and 05-C4 are decided.

## Inbound `@sec-` citation count (self-citations discarded; this worktree)

Rule: label -> owning file -> count of citations from other files. Broken `@sec-` targets over the whole book: 0.

| Chapter | Inbound | | Chapter | Inbound |
|---|---|---|---|---|
| 00-hybrid-programme | 54 | | 08-pipeline-stages | 40 |
| 01-coancestry | 40 | | 08b-genomic-prediction | 28 |
| 02-subdivided | 54 | | 09-optimal-contributions | 39 |
| 02b-response | 42 | | 10-combinatorial-selection | 31 |
| 03-simulating-crosses | 36 | | 10b-advanced-selection | 26 |
| 04-population-sizing | 27 | | 11-plant-literature | 15 |
| 04b-backcross-introgression | 10 | | 11b-diversity-across-cycles | 51 |
| 04c-alphasimr-pipeline | 24 | | 11c-limits | 21 |
| 04d-breeding-programme | 20 | | 12-case-study | 21 |
| 04e-mating-design | 64 | | 90-notation | 21 |
| 04f-sparse-testing | 38 | | 91-package | 0 |
| 04g-joint-allocation | 12 | | 92-verification | 5 |
| **05-genomic-era** | **44** | | 93-corpora | 2 |
| 05b-heterosis-dominance | 97 | | 99-references, index | 0, 0 |
| 06-metric-catalogue | 49 | | | |
| 07-choosing-metrics | 45 | | | |

05 inbound by label (cited from other files): `sec-genomic-era` 26 (00:568, 00:747, 01:495, 02b:907, 03:561, 04c:435, 04c:2333, 04d:427, 05b:154, 05b:529, 05b:1579, 06:190, 06:260, 06:631, 06:641, 07:480, 09:228, 11:252, 11b:143, 11b:334, 12:75, 12:196, 90:267, 90:623, 92:165, 92:236), `sec-era-programme` 8 (00:18, 00:205, 00:564, 00:723, 04:29, 04:1078, 04b:66, 05b:1916), `sec-era-step4` 2 (00:624, 00:702), `sec-era-fhom` 2 (04g:567, 05b:413), `sec-era-step1` 2 (04g:626, 05b:1588), `sec-era-step2` 2 (04g:638, 04g:775), `sec-era-transposition` 1 (00:733), `sec-era-step7` 1 (90:59). The labels `sec-era-step3`, `-step5`, `-step6` have no inbound citation from another file (cited inside 05 only).

Outbound from 05 (24 distinct targets, all resolve): `sec-heterosis` (05b) 7, `sec-cycles` (11b) 6, `sec-stages` (08) 2, `sec-heterosis-id` (05b) 2, `sec-coancestry` (01) 2, `sec-catalogue` (06) 2, `sec-case-study` (12) 2, `sec-hybrid-programme` (00) 1, `sec-response` (02b) 1, `sec-ocs` (09) 1, `sec-notation` (90) 1, `sec-limits` (11c) 1, `sec-heterosis-identity` (05b) 1, `sec-g-singular` (08b) 1; to 02, 03, 04, 04b, 04c: 0.
