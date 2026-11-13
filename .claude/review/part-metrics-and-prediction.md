# Part review -- Metrics and prediction (05, 06, 07, 08, 08b)

Scope: `book/05-genomic-era.qmd`, `06-metric-catalogue.qmd`, `07-choosing-metrics.qmd`,
`08-pipeline-stages.qmd`, `08b-genomic-prediction.qmd`, read against `CLAUDE.md`,
`book/_quarto.yml`, `book/90-notation.qmd` and the five THREAD entries. Read-only on the
book; THREAD.md untouched. Line numbers are those of the worktree
`/Users/ederdbs/Documents/SB_quanti_gen-review-04-06` at HEAD 172ec6c. Cross-reference
counts come from a script over `book/*.qmd` (self-citations discarded). I recomputed three
numbers that carry a cross-chapter claim and they hold: truncation alpha 0.04128766 at
`null_distribution(ctx, 60, B = 2000, B_full = 1000)` (default seed 7 = 06's and 05's call;
07:900 hard-codes 4.129 %), package `eff_dim` 26.19 and uncentred ratio 1.47 on 06's random
subset (07:380 hard-codes both). Nothing else in the part is a number that differs between
chapters.

Verdict on the part as a whole: it holds together. Openings state their predecessor, forward
use of 06's null by 05 is declared on both sides, the numbers quoted across chapters agree,
and 08b settled the rank argument by citing @eq-era-rank. Four things are open inside the
part (C1-C4), one broken promise sits in a chapter after the part but names a section of it
(C5, C6), and a block of older Owed items naming later chapters is still true of the current
text (C7-C16). Findings are ordered by severity.

## Findings

### H -- must be fixed before the part closes

**metrics-C1 (H) -- "allelic richness": one name, two quantities, and the recommended one is
defined nowhere. Owner: 06 (define or retitle); 07 and 90 follow.**
- 06:282 titles the section "Allelic richness {#sec-richness}" and defines in it
  `A_lost` (@eq-catalogue-alleles-lost, 06:293-296): markers with MAF >= 0.05 in the
  population and < 0.05 in the selection. `R/01_metrics.R:232` also calls this
  "allelic richness".
- 06:321 then uses "allelic richness (the count of alleles retained)" as a separate metric
  from `alleles_lost` ("`alleles_lost` keeps about a third"), without defining it.
- 07:42, 54, 961-970 recommend "Marker alleles retained (allelic richness)" by the bitset
  route (`alleles_retained_fast()`), and 07:1017-1025 lists "MAF-threshold allele loss" as a
  different, not recommended metric ("whether the two carry the same information was not
  examined"). 07:966 cites @sec-richness for the recommended one, but that section defines
  the other one.
- No equation anywhere in the book defines "alleles retained"; 90 has a row for `A_lost`
  only (90:78, 96); 91:165 names the function; 08's ledger column `alleles` (08:36, 08:757ff)
  is a third use. The one metric 07 keeps for validation therefore has no definition in
  the catalogue that is supposed to own the definitions.

**metrics-C2 (H) -- broken promise: 06 says the collapse "makes it cheaper still";
07 measures that it does not (at small n). Owner: 06.**
06:171-173: "The matrix route is the one that belongs in an optimiser's inner loop.
@sec-collapse makes it cheaper still." 07:299-310 reports the opposite for the
book's own small case (line route slower than the matrix route at N = 2,500, n = 50; cheaper
only at large n) and opens that bullet by saying the collapse "was expected to make it
cheaper still". 07:933-947 and 08:911-941 (cost summary, "the saving per evaluation belongs
to the incremental swap") agree with each other and not with 06. THREAD records this as
"06 closed, reword if the cross-check is wanted"; this review is the cross-check.

**metrics-C3 (H) -- 92 states a setting for the redundancy results that 07 withdraws.
Owner: 92 (appendix); symbol also owed by 00-C18.**
92:394-397: the empirical results "which metrics are redundant, how much index a constraint
costs -- were derived at F_ST = 0.15 with simulated markers". 07:355-361 says
`metric_redundancy.csv` records no N, L, m, n or F_BN, that an earlier version's
"F_BN = 0.15 and 12,000 markers" cannot be checked, and 07:524-528 says the same for the
whole analysis. 92 also writes the Balding-Nichols parameter as F_ST (92:57, 92:396),
against 07 and 08, which write F_BN throughout (open since 00-C18).

**metrics-C4 (H) -- 04e promises models that 08b does not fit. Owner: 04e (Mating and
testing design).** 04e:729-731 ("@sec-genomic-prediction is where this book fits those
models [pool-specific additive kernels for GCA plus a dominance or product kernel for SCA]
and @sec-hybrid-cv where it validates them") and 04e:1147 ("fits the hybrid prediction
models this chapter's genomic results rest on"). 08b fits one additive GBLUP kernel over
all hybrids with no pool split, plus BayesA, BayesB and BayesC-pi, on a trait with no SCA
(08b:55-64, 184-189, 1247-1251). Open item 08b-C5.

**metrics-C5 (H) -- 04d contradicts 08b on why accuracy is finite. Owner: 04d.**
04d:423-428: "@sec-genomic-prediction is where the accuracy this chapter assumes is actually
measured, and marker-versus-QTL is the reason that accuracy is finite". In 08b there is no
marker-QTL gap: the trait is generated from the markers the models see
(08b:57-60, 1239-1246), and the finite accuracy comes from training size, noise and the rank
bound of @eq-genpred-rank. Open item 08b-C13.

### M

**metrics-C6 (M) -- 08b's opening describes the end of 08 incorrectly. Owner: 08b.**
08b:13-14: "@sec-stages closes with the S4 selection taken as given: the hybrids are ranked
on `ctx$index`". 08's S4 section (08:688-735) is followed by the ledger, the cost summary
and the checklist, so S4 is not the close; and "taken as given", or any ranking on
`ctx$index`, appears nowhere in 08 (08:300 is the only mention of `index`, as a logged
column of `run_cycles()`). The THREAD marks 08b-vs-08 as "settled" on the strength of this
sentence. The transition 08 -> 08b should lean on what 08 does say (S4 section; 00's
@tbl-hp-stages) or on 03's `ctx$index`.

**metrics-C7 (M) -- what to hold "in a band" is two different quantities. Owner: 08 or 05
(pick one and say why); 05b:1427 follows.**
05:1792 and 05:2164 (checklist): "GD_BS held in a band, not maximised".
08:274 and 08:948 (checklist item 2): "Hold F_ST in a band, not at a maximum".
05b:1427 announces the F_ST version ("@sec-stages Trap 3 will make, to hold the statistic
F_ST in a band"), 05b:2150 protects the GD_BS component. 05:1730-1735 argues that F_ST
(= GD_BS/GD_T) rises under a one-pool collapse because GD_T falls, so the two bands are not
the same instrument; neither chapter says which one the prescription is.

**metrics-C8 (M) -- 06 promises a demonstration that 11b does not give. Owner: 11b (add)
or 06 (reword).** 06:477-479: "The diversity within each pool is the fuel for future
progress, which @sec-cycles demonstrates." 11b logs the merged `GD`, `GD_BS`, `F_hom`,
`F_drift`, `max_line`, `index` (11b:12-13, 186) and never reads within-pool diversity
(`GD_WS`, `GD_BI`, `theta_A/B`) as the fuel; 08:297-300 states the same column set.

**metrics-C9 (M) -- 09 restates 07's conclusion in terms 07 does not use. Owner: 09.**
09:382-386: "Allelic richness, A-NE and G_st are computed once, on the final solution. This is
the same conclusion @sec-choosing reached from the production-scale benchmark." 07 does not
mention G_st; keeps A-NE out of the loop but only "offered once on the returned plan"
(07:982-1006); and 07:246-255 names its scale "benchmark scale" and withdraws the cached
figure's "production scale" label. Open item 07->09.

**metrics-C10 (M) -- the cached DE table is developed in full in 07 and in 10, and the
definition of the four restrictions is circular. Owner: 10 (owns the table); 07 keeps the
preview.** 07:531-646 (Finding 4, `de_constraints.csv`, nine rows, encodings, limits) and
10:448-480 (the same file, same four restrictions, same "neither arm is `sel_de()`"). 07:536
says the definitions are in @sec-combinatorial; 10:455 and the caption at 10:475 define the
restrictions by citing back to "@sec-choosing". Open item 07->10.

**metrics-C11 (M) -- "the encoding, not the algorithm, decides" is cited as established; 07
says it is a verdict on the N-dimensional key encoding only. Owner: 11 (11:23, 11:306), 12
(12:222).** 07:645-646 and 07:452-454 (the residual criterion is necessary, not sufficient;
"minimal non-redundant set" is not shown). 11:21-24 calls the 07 set "minimal
non-redundant"; 12:222 turns it into a checklist rule ("The search is encoded on line
weights, not hybrid keys"). Open items 07->11, 07->12.

**metrics-C12 (M) -- 07 describes 08b's error structure more strongly than 08b claims.
Owner: 07.** 07:670-672: 08b "finds the same structure in its real residuals". 08b:1196-1217
reports the correlation of error products with f on one simulation, against a permutation
null that is "a reference, not a sampling distribution for a formal test", and says it was
not compared with Finding 5's generator. "Real" is also wrong for simulated data. The same
sentence puts CV1 "near the bottom" of the 0.5-1 grid while 08b:1186-1190 puts CV1 between 0.5
and 0.7 with a mean of about 0.67 (the upper end of that interval). Open item 08b->07.

**metrics-C13 (M) -- the three F_ST statements are told in full twice. Owner: 08 Trap 2
(owns the ratio identity and the cached table), 02 (owns @eq-f-stats); 05 should point.**
05:1772-1787 develops G_ST = GD_BS/GD_T, `Fst_Wright`, F_BN and the 1.81 ratio, and
08:147-205 (Trap 2) develops the same three with the identity F^btw/F = 2 - F^btw and the
7-row cached table; 90:274 states it a third time. The two numbers agree (05's 1.81 at
seed 1 teaching scale, 08's 1.817 on its seed-12 world, both inside [1, 2]), so this is
redundancy, not a contradiction.

**metrics-C14 (M) -- the closing cross-links the 08b review asked for are still absent from
the Evidence part. Owner: 11b, 12 (and 10, 09 for the two re-points).**
(a) 11b, 11c and 12 cite @sec-genomic-prediction nowhere; 11b:100-104 and 12:164-172 cite
only Finding 5 for "what relaxing the known index does" (08b-C16). (b) 10:43-46 cites
@sec-genomic-prediction for "`build_ctx()` forms the single index ... standardised to unit
variance", which 08b does not show (08b:1163-1168 points to 03) (08b-C4). (c) 09:11-14 says
08b shows how a real programme gets "a `traits` matrix" for `stage1_build()`; 08b's
hand-off is one trait, N = 250 (08b:1136-1181).

### L

**metrics-C15 (L) -- same partition, two symbol sets, correspondence stated only in 90.
Owner: 08.** 02, 05 (05:1717-1722, 05:1792) and 90's partition table write the coancestries
of the partition as f-bar, f-tilde, s-tilde; 08:122-142 writes theta_T, theta_w, and cites
@eq-gd-partition of 02 without saying theta_T is f-bar and theta_w is f-tilde. The mapping is
in 90 only (90:318-321). theta_AB is census-weighted in 08 (mean of f_ij over A x B lines) and
usage-weighted in 06:482-489 and 05:1720.

**metrics-C16 (L) -- the usage vector w has two normalisations and N_e,par two
parametrisations. Owner: 06 (state the relation); 07 optional.** 06:489 (w_A, w_B each sum
to 1 within a pool, as `line_weights()` returns) against 07:103 and 07:146 (w sums to 1 over
both pools, 1/2 per pool, so w_A of 06 is twice 07's block). 90 records both (the w and
theta_A/B/AB rows) but neither chapter links the other. 06:250 writes N_e,par = 1/sum p_i^2
with p_i the usage share of line i, while 07:933 and 08:719 write (sum k_a)^2/sum k_a^2 = 1/sum
w_a^2 -- the same number; p_i re-uses the allele-frequency letter and index letter that 90
reserves.

**metrics-C17 (L) -- "production scale" means four things in the part's neighbourhood.
Owner: 07.** 05:152-156 and 06:909 (71 + 71 lines, 25,000 markers, and the `sim_config`
default 50 + 50 / 5,000, both named); 07:251-255 (the "benchmark scale", L = 300, N = 22,500,
declared distinct); but 07:318 ("the cached production values") applies the old label to that
benchmark, and 07:616-645 uses "production scale" for the N = 10,000, L = 200 point of
`search_benchmark.csv`, which 10b:42 defines as a different production scale. 12:35 still says
"production scale of `sim_config`" (owed 05->12).

**metrics-C18 (L) -- version-history and first-person prose left in the book. Owner: 07.**
07:357-360 ("the previous version of this chapter gave F_BN = 0.15 and 12,000 markers, and I
cannot check either"), 07:381 ("I read it as the uncentred ratio"), 07:608-610 ("I do not
know why"), 07:653 ("An earlier version of this finding quoted ..."). No other chapter of the
part speaks this way; the content is fine, the register records review history.

**metrics-C19 (L) -- identities already owned are re-asserted in 08's S4 section. Owner:
06 (GD = 1 - theta = H_e, 06:117-140), 07 (the collapse, 07:194-223).** 08:693-735
(@tbl-s4-usage, @tbl-s4-he) re-runs the collapse and H_e = 1 - theta on a different world;
05:1688-1699 and 05:254-340 assert GD = GD_T = He again. All cross-reference their owners and
08's own rule ("every identity shown is asserted") explains the repetition; the second world
(100 hybrids from 900, seed 91) is the only new content. Candidate for trimming, not an error.

**metrics-C20 (L) -- 07's drop-in code is silent on what 10 and 10b say about it. Owner: 07.**
07:1049-1077 recommends `sel_de_fast()` for all four restrictions; 10:874 and 10b:1273 call it
"the only route that accepts them" and add that it trails the capped greedy on index.

**metrics-C21 (L) -- hard-coded copies of live numbers. Owner: 07.** 07:380 ("1.47 on that
chapter's subset", "26.19 there") and 07:900 ("4.129%") are typed from 06; both verified
equal to the live values at this commit, but a seed or cache change in 06 would leave them
stale silently.

### Open Owed items carried forward (still true of the current text; verified)

These are not new, but a part review should not close with them unnamed.
- Owner 90: no rows for G_VR1, G_VR2, G_i(p), G_LA, G_ROH (05-C19; `grep` over 90 finds none,
  yet 05 uses them 14+ times); the u / u-hat rows (90:283, 301 against 90:341) with opposite
  vs same roles in 07/08b, and the truth called u in 07, g in 08b (08b:240-247) while 90's
  bold-g is the per-trait vector (90:571), not a per-hybrid value (08b-C11 ii); sigma^2_u in
  90 against sigma^2_G in 04f:278 and 684 (08b-C19); n_DH row cites `n_per` (90:331; 08-M13).
- Owner 10b: 10b:1245 "@sec-catalogue's rule applies: one diversity lens, chosen deliberately,
  reported against a null"; 06 states no such rule (06-C13).
- Owner 04e, 12: "dominance deviation" for d_k (04e:176, 12:264; 05-owed).
- Owner 04b: 04b:1195 cites @sec-choosing for `max_use`; 07 defines it only in the Finding 4
  preview and @sec-combinatorial owns it.
- Owner 92/index: F_ST for F_BN (92:57, 92:396; see C3).

## Checks that came back clean

1. Notation inside the part: theta_S, GD = 1 - theta = H_e, N_s in [1/2, 1], alpha with
   gd_ref, F_hom / F_drift, GD_WI_hyb, F_BN versus F_ST (07 and 08 use F_BN throughout; 05
   uses it where it means the parameter), the line-level kernel f^L (eq-f-molecular), the
   rank statement (@eq-era-rank in 05, cited and extended in 08b:287-298, L - 1 against
   L - 2 consistent) and the three meanings of lambda (06 heterosis weight, 08b
   sigma^2_e/sigma^2_u, OCS penalty) are kept apart in the text of the chapter that needs
   them or in 90.
2. Numbers: same null call in 05, 06 (B = 2000, B_full = 1000, seed 7); GD_ref 0.32586,
   alpha 4.129 % (07:900); 0.3617-type F1 heterozygous fraction in 05 equals twice
   `GD_WI_hyb`, and 06/05 agree on its sign across draws (06:236-240 -> @tbl-era-seeds-z).
   08's 1.817 and 05's 1.81 are the same identity on two worlds.
3. Assumptions across chapters: 07 and 08 declare A2 (inbred/DH parents) wherever the collapse
   or the DH identities are used; 08 declares "no frozen base" where 05/06 use p0; 08b
   declares additive trait, marker panel = causal set (the A5 gap), complete factorial and a
   best-case accuracy, and adds none of the dominance results of 05b to its claims; 06's
   heterosis readings (@eq-catalogue-het-hs-dg, lambda_d) state their needs (inbred parents,
   complete factorial, equal pool weight).
4. Transitions: 05 follows 04c (04c:2358 hand-over true of 05:12-22); 06 follows 05 and says
   why (06:12-17); 07 follows 06 (07:24-26); 08 follows 07 (08:18-39, the metric set restated
   as 07 states it); 08b follows 08 apart from C6; 09 follows the part (09:9-14).
5. Forward promises kept: 05 -> 06 (@sec-baseline, @sec-catalogue-null); 06 -> 07 (GD/ANE
   contrast, N_e,par into the objective); 06 -> 09/10 (frontier and recipe, 09:139-206,
   10:530); 07 -> 08b (GBLUP fitted, nominal vs realised accuracy, 08b:1182-1235);
   08 -> 11b (columns logged, 08:297-300 true); 08b -> 12 (the caveat is repeated at 12:164-172).
   Broken or partial: C2, C6, C8 above.
6. Part structure: 05 reads against 06's null before it is defined (05:309, declared); 07
   Finding 4 previews the Optimisation part (07:531-538, declared); 05b, 00 and 04 cite the
   part forward, each time saying "in the Metrics and prediction part" or "later" (05b:413,
   786, 1427, 2122, 2150, 2159). No hidden dependence found.
7. Broken targets: none. Every `@sec-`, `@eq-`, `@tbl-`, `@fig-` citation in `book/*.qmd`
   resolves to a label (the only unresolved strings are Quarto's generated sub-table suffixes
   `tbl-alphasimr-split-N` / `paired-N` in 04c, outside this part).
8. Cached files: 05 (none), 06 (reads `metric_redundancy.csv`, declared external), 07 (four
   external files, declared), 08 (five external, declared), 08b (two files, both reproduced by
   `regenerate.R genpred`, so they must not be listed among the unreproducible files of 92;
   92:274-282 does not list them -- correct).

## Inbound `@sec-` citations (self-citations discarded)

Per chapter of the part: total citations received, number of citing files, and where they come
from. "Earlier" = Introduction, Foundations, Simulation; "Later" = Optimisation onward plus
appendices and `index`.

| Chapter | Total | Citing files | From within the part | From earlier parts | From later parts and appendices |
|---|---|---|---|---|---|
| 05-genomic-era | 61 | 20 | 20 (06: 10, 07: 6, 08: 3, 08b: 1) | 23 | 18 |
| 06-metric-catalogue | 70 | 22 | 24 (07: 14, 05: 5, 08: 5) | 28 | 18 |
| 07-choosing-metrics | 57 | 18 | 19 (06: 9, 08: 7, 08b: 3) | 10 | 28 |
| 08-pipeline-stages | 42 | 16 | 4 (05: 2, 08b: 2) | 24 | 14 |
| 08b-genomic-prediction | 31 | 15 | 2 (05: 1, 07: 1) | 10 | 19 |

Per section (only those cited from outside their own chapter; sections not listed have zero):

| Owner | Section | Inbound | Note |
|---|---|---|---|
| 05 | sec-genomic-era | 36 | |
| 05 | sec-era-programme | 13 | A1-A8 |
| 05 | sec-era-step1 / step2 / step4 / step6 | 2 / 2 / 2 / 2 | step 7: 1 (90:61); fhom 2; transposition 1 |
| 05 | sec-era-fdrift, sec-era-protocol, sec-era-step3, sec-era-step5 | 0 each | read inside 05 only |
| 06 | sec-catalogue | 33 | |
| 06 | sec-baseline | 21 | |
| 06 | sec-ns | 10 | |
| 06 | sec-identity | 4 | |
| 06 | sec-catalogue-null | 1 | 05:309 only |
| 06 | sec-richness | 1 | 07:966 only (see C1) |
| 07 | sec-choosing | 35 | |
| 07 | sec-collapse | 15 | |
| 07 | sec-choosing-error | 5 | 08b 3, 90 2 |
| 07 | sec-choosing-cost | 2 | both from 08 |
| 07 | sec-choosing-redundancy, -search, -recommendation, -ane | 0 each | read inside 07 only |
| 08 | sec-stages | 42 | 16 files |
| 08 | sec-stages-trap2, -trap5, -ledger, -cost | 0 each | read inside 08 only |
| 08b | sec-genomic-prediction | 25 | 14 files; none from 11b, 11c, 12 |
| 08b | sec-g-singular | 2 | 05:2036, 90:64 |
| 08b | sec-hybrid-cv | 4 | 04e:731, 04f:413, 90:367, 90:383 |
| 08b | sec-genpred-truth, -mme, -reliability, -bayes, -pi, -handoff | 0 each | read inside 08b only |

Reading of the table: no chapter has a job problem (lowest total is 31). The weak edges are
inside the part: 08 and 08b receive only 4 and 2 citations from their own part, so the part
is read as a sequence and not as a web (08 -> 08b is a single dependency, the opening
sentence of C6). 08b has no inbound edge from 11b, 11c or 12 (C14). 06's `sec-richness`
has exactly one reader and it is the one pointing at the wrong metric (C1). The sections
`sec-era-step3`, `-step5`, `-fdrift` and `-protocol`, whose results carry the chapter's own
claims, are cited by no other chapter.
