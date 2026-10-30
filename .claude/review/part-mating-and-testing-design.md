# Part-level coherence review: "Mating and testing design" (04e, 04f, 04g)

Scope: `book/04e-mating-design.qmd`, `book/04f-sparse-testing.qmd`, `book/04g-joint-allocation.qmd`,
with their links to `book/90-notation.qmd`, `book/04d-breeding-programme.qmd` and `book/05-genomic-era.qmd`.
Read-only review of the worktree at 4e06f93. Hard-coded numbers in 04e and 04f were recomputed from
`book/data/*.csv`; all of them match (see "Numbers checked").

Severity: H = fix before the part is considered coherent; M = should fix; L = polish.

---

## C1 (H) -- Part structure: the part depends on later chapters but presents that as prior knowledge

`index.qmd:114` says "The parts are ordered so that each depends only on what came before". The part
does not meet that claim. There are 35 `@sec-` references from the three chapters to Metrics,
Optimisation and Evidence chapters, and several of them are load-bearing and phrased as past results:

- `04e-mating-design.qmd:172-185` -- "@sec-heterosis-gca-sca **derived** exactly this decomposition" (05b,
  later). The live chunk `mating-gca-identity` (04e:187-201) calls `heterosis_gca_sca()`, which is
  introduced only in 05b.
- `04e-mating-design.qmd:411`, `04e:1142-1143` -- `@sec-heterosis-step6` (05b) given as the
  finite-population version of `fig-mating-testers`.
- `04f-sparse-testing.qmd:192`, `04f:782` (Box 5) -- "follows from @sec-heterosis-gca-sca".
- `04g-joint-allocation.qmd:567` ("the symbol of @sec-era-fhom"), `04g:626` (`@sec-era-step1`, frozen
  `p_0`), `04g:638` and `04g:775` (`@sec-era-step2`, `F_drift`), `04g:602` (`@sec-identity`, 06). The
  drift-lens paragraph (04g:636-645) assumes the reader already has F_drift and the two lenses, which
  are taught in 05.

Change: 04e, 04f and 04g. Each of these references should be marked as a forward pointer, or the
material they rely on should be given locally. If neither is done, `index.qmd:114` has to change.
04e and 04f have not yet been reviewed, so they are the cheaper place to start.

## C2 (H) -- Cross-reference graph: the part is cut off from the rest of the book, and 04g is cut off from the book's own index

- No chapter from 05 to 12 cites 04e, 04f or 04g (0 inbound from the body after the part). The material
  that overlaps (C6, C9, and `08-pipeline-stages.qmd:205`, `08:442`, "evaluate a crossing plan before
  making a single cross") does not link back.
- 04g has 9 inbound references, all from its two siblings (4 from 04e, 5 from 04f). These places
  mention 04e and 04f but leave 04g out:
  - `index.qmd:103-106`: the reading guide names @sec-mating and @sec-sparse only.
  - `index.qmd:120`: the part row mentions crosses and locations but not the joint problem.
  - `91-package.qmd:42` and `91-package.qmd:67`: the file/chapter table stops at `R/17_sparse_testing.R`
    and has no `R/18_joint_allocation.R` row.
  - `92-verification.qmd:209-215`: the "what a failing test means" table has rows for test-mating and
    test-sparse only.
  - `92-verification.qmd:236`: the "Computed live" provenance table lists @sec-mating and @sec-sparse
    but not @sec-joint, although 04g runs `tbl-joint-misspec`, `tbl-joint-alias`, `tbl-joint-live` and
    `tbl-joint-freq` live.
  - `92-verification.qmd:383-393` covers the 04e and 04f regeneration paths but not `regenerate.R joint`.

Change: `index.qmd`, `91-package.qmd` and `92-verification.qmd` should add @sec-joint. 05b, 08 and 08b
should cite back (see C6 and C9).

## C3 (M) -- Notation: GCA, SCA and their variances have three symbol sets within one part

- GCA:
  - `04e:164`, `04e:178`: $g^A_i$, $g^B_j$. This is also the form in `90-notation.qmd:227`.
  - `04f:189`, `04f:226`, `04f:921`: $\mathrm{GCA}^f_i$, $\mathrm{GCA}^m_j$, $\mathrm{SCA}_{ij}$. These
    do not appear in `90-notation.qmd`.
  - `04g:159-163`: $g^f_i$, $g^m_j$, $s_{ij}$, listed in `90-notation.qmd:271`.
  - 04g:163-165 has to translate between all three.
  - In 04f:189 the hybrid's genetic value is $g_{ij}$, which looks like a GCA symbol beside 04e's $g^A_i$.
- GCA variance:
  - $\sigma^2_g$ at `04e:168`.
  - $\sigma^2_f$, $\sigma^2_m$ at `04f:226-233`, and also $\sigma^2_{GCA}$ at `04f:196`, `04f:798` and
    `04f:884`.
  - $\sigma^2_{GCA_A}$ at `05b-heterosis-dominance.qmd:1400`.
- SCA variance:
  - $\sigma^2_s$ at `04e:169`, `04e:217`, and `04g:168`.
  - $\sigma^2_{SCA}$ in the same chapter at `04e:332` and `04e:437`, and throughout 04f. 04f:235 says it
    is "also written $\sigma^2_{SCA}$ in this chapter", which is two symbols by declaration.
  - `90-notation.qmd:101` defines $\sigma^2_{SCA}$ as the closed-form **heterosis** SCA variance
    $4\sum d_k^2 p q p q$. That is a different quantity from the design-level variance component.
  - The Mating-design table in `90-notation.qmd:227` has no entry for $\sigma^2_g$, $\sigma^2_s$ or
    $\sigma^2_e$.

Change: 04f should adopt 04g's $g^f/g^m/s$, with $\sigma^2_f$, $\sigma^2_m$, $\sigma^2_s$. 04e should drop
$\sigma^2_{SCA}$ at lines 332 and 437. `90-notation.qmd` should add the variance-component symbols to
the Mating-design table.

## C4 (M) -- Notation: $\rho$ means three things

- `04e:218` and `90-notation.qmd:228`: least-squares GCA accuracy, the closed form.
- `04f:151-160`: the accuracy of any selection criterion in $\Delta G_t = i\rho\sigma_A/t$. This is
  wider than the 90-notation definition.
- `04g:1086-1097` and `04g:1118`: Spearman's rank correlation ("$|\rho| \ge$ ..."). Here it means
  something unrelated, inside the same part that reserved $\rho$ for accuracy.

Also, `05b-heterosis-dominance.qmd:1399` writes the tester-accuracy curve that 04e calls "the same
curve" (04e:411) as $r_k$. That is the clash with "$r$ = plots" which `90-notation.qmd:242` says the
part avoids.

Change: 04g (Spearman symbol), 90-notation (widen the $\rho$ row), and 05b (or a cross-note in 04e).

## C5 (M) -- Evidence threshold: the part uses three different bars for "resolved"

- `04e:530` and `04e:1106-1109`: "resolved" means past **3** SE of the difference, and every quoted
  comparison is said to clear 3 SE.
- `04g:880-882`: "detected" means past 2 SE. It flags 2 to 3 SE explicitly against @sec-mating's 3.
- `04f`: no bar is stated.
  - Result 3 (`04f:55-57`, `04f:1098-1103`) rests on parentage - random, CV1, of +0.0086 +/- 0.0039 overall
    (z = 2.2, p = 0.026). The text calls this "real and small".
  - At k <= 2 it is +0.0187 +/- 0.0069 (z = 2.7).
  - The genomic-layer contrast is +0.023 +/- 0.009 (z = 2.6).
  - All three are below 04e's resolution bar. They are listed as a headline result anyway, and 04g:1057-1060
    then builds on that result.
  - 04f:612-616 uses "resolved" without defining it. The resolved cases happen to be z > 4.
- Change: 04f should state a bar and flag result 3 as 2 to 3 SE, in the same way 04g does.

## C6 (M) -- Redundancy: tester saturation and the k-tester accuracy curve are developed twice

- In 04e:
  - `04e:289-292` and `tbl-mating-connectivity`: one tester gives zero residual df, and SCA is not
    identifiable.
  - `04e:347-412`, `fig-mating-testers`, and the closed form at `04e:217-218`: GCA accuracy against k.
  - `04e:436-438` repeats the zero-df point.
- In 05b:
  - `05b-heterosis-dominance.qmd:1367-1395` (Step 6) develops the same thing again: `layout_df()`,
    `sca_df = 0` at one tester, "not estimable, not merely imprecise".
  - `05b:1396-1410` has the k-tester accuracy curve with a finite-population correction. It uses a
    different symbol set and has no plot-error term.
- 04e cites 05b. 05b does not cite 04e.
- Owner: 04e (@sec-mating-connectivity and @sec-mating-tester). It comes first and its design chapter
  has the general rank rule. 05b Step 6 should cite those sections and keep only its own addition, the
  finite-population correction, against 04e's curve in 04e's symbols.

## C7 (M) -- Names and definitions: CV0/CV1/CV2 attributed to @burgueno2012 with two incompatible meanings

- `04f:407-417` (callout) says @burgueno2012's CV labels classify **genotype x environment cells**: CV1
  is a new genotype and CV2 a missing cell.
- `08b-genomic-prediction.qmd:330-334` attributes to the same @burgueno2012 the **parent-seen** scheme:
  CV2 has both parents seen, CV1 one unseen, CV0 neither.
- `90-notation.qmd:201-203` (Genomic prediction) and `90-notation.qmd:250` (Sparse testing) list both
  meanings without a clash note. The table does add a clash note for $k$ at line 266.
- `04e:731` says @sec-hybrid-cv validates "by masking hybrids". 08b's point is that masking hybrids is
  the easy split and that holding out lines is the real test.
- Change: 08b (attribution) and 90-notation (clash note). 04e:731 needs a wording fix to match 08b.

## C8 (M) -- Transition 04d -> 04e is missing; the part ignores the chapter that introduced its trade-off

- `04d-breeding-programme.qmd:19-22` introduces the budget trade between "more entries at one location
  or fewer entries at eight locations". That is the same trade that 04f result 6 and 04g result 1
  measure.
- 04d's "Where this connects" (`04d:415-428`) has no forward pointer to the part.
- 04e's opening (`04e:35-39`) says "Every chapter before this one took the hybrids as given" and lists
  04c, 03 and Optimisation, but not 04d, the immediately preceding chapter (an inbred-line programme).
- 04g never cites @sec-programme. It uses @endelman2014 as the "line-breeding analogue" (04g:991-993).
- 04f cites @sec-programme only once, in its closing bullets (04f:1500).
- Change: 04e's opening and 04d's "Where this connects". 04g:991 could point to @sec-programme.

## C9 (L) -- Redundancy: the tester-choice argument (elite vs low-performing tester) is made twice

- `04e:414-430` ("Choice of tester": @smith1986 masking, the elite-tester counter-argument, staging)
  and `04f:774-787` (Box 5: @hull1945, @rawlings1962, the same masking argument, the elite-tester
  counter-argument).
- Owner: 04e (@sec-mating-tester). Box 5 should keep only its link to the opposite-pool frequency
  argument and cite @sec-mating-tester for the rest.

## C10 (L) -- Notation: $L$ for locations without a clash note

- `90-notation.qmd:13`: $L$ means parent lines.
- `90-notation.qmd:210`: $L$ means map length in Morgans.
- `90-notation.qmd:250`: $L$ means locations, used at `04f:277` (Box 2), `04f:949` and `04g:116`.
- The 90 Sparse-testing and Joint tables note the $k$ clash (90:266) but not the $L$ clash.
- Change: 90-notation.

## C11 (L) -- 90-notation: stale pointer

`90-notation.qmd:242-243`: "in the next table it is the accuracy of a selection criterion". The next
table is Sparse testing, which has no $r$. The accuracy $r$ is in the Response-to-selection table,
four tables later. Change: 90-notation.

## C12 (L) -- Two estimands are both called "accuracy" across the part

- 04e: "GCA accuracy" means the correlation with true GCA over all 200 lines per pool, averaged over
  pools (`04e:204-207`).
- 04f and 04g: "accuracy, all hybrids" means the correlation with the hybrid target value
  $g^f + g^m + s$ (`04f:926`, `04g:176`).
- 04g's design criterion is the PEV of **GCA**, which is 04e's estimand, but it is scored against the
  hybrid-value accuracy of 04f.
- 04g says this locally (04g:445-446, 1108-1126). However, the part's cross-chapter statements compare
  results across the two estimands without naming the switch: 04e:1112-1118 against 04f result 2, and
  04g:1289-1291 "the crossing plan is the larger lever".
- "PEV" likewise means the PEV of a hybrid's target value in 04f (Box 4, 04f:683-684, and
  `90-notation.qmd:255`), and the mean PEV of GCA effects in 04g (04g:436-444). The Joint table in 90
  has no PEV entry.
- Change: 04e's "Where this connects" and 90-notation (Joint table).

## C13 (L) -- Unreconciled direction between the 04e optimiser and 04g result 1

- `04e:959-968` and `tbl-mating-frontier`: the money-constrained optimiser keeps $c = 3$ and raises
  plots per cross to 2, 3 and 4 as the budget grows (600 crosses at 1,200 to 2,400 plots) rather than
  adding crosses.
- `04g:67-76`: at a fixed plot budget, distinct crosses beat locations per cross.
- These are not contradictory. 04e prices crosses (pollinations, nursery) and folds G x L into plot
  error, while 04g counts plots only and lists seed as an open problem (04g:1246-1248). Neither chapter
  says that this is why the two point in different directions.
- Change: 04e (not yet reviewed), at the frontier interpretation or in "Where this connects".

## C14 (L) -- Transition 04g -> 05

- 04g closes by handing to @sec-genomic-era (`04g:1304-1306`).
- 05's opening (`05-genomic-era.qmd:12-30`) starts on @meuwissen2020 with no bridge from the preceding
  part, and does not say why Metrics follows the design part.
- This is the first chapter of a new part, so the requirement is weaker. Still, 04g's promise ("the
  Metrics part ... measures the diversity of the hybrids a programme has") is not acknowledged on the
  receiving end.
- Change: 05 (one sentence) or none.

## C15 (L) -- Redundancy: the hybrid mixed model is written out in full twice

- `04f:222-229`: kernels for GCA and SCA.
- `04f:917-940`: the location model, in words and component names.
- `04g:156-176`: "the model is @sec-sparse's, unchanged", followed by the full model with every
  distribution, including the location interactions that 04f never writes as distributions.
- Owner: 04f should carry the labelled equation, and 04g should cite it. Alternatively, 04f should
  point forward to @eq-joint-model as the formal statement. This is low priority because 04g is
  approved.

---

## Promises checked (kept)

- 04e:172 (female = pool A in 04f and 04g): kept at 04f:185 and 04g:114.
- 04e:639-640 and 04e:1049 ("@sec-joint takes this gap up"): kept.
- 04e:1112-1118: the claims about 04f result 2 match 04f:1060-1076.
- 04f:653 and 04f:1405 (a necessary screen and a counter-example in @sec-joint-criteria): kept by
  `tbl-joint-alias`.
- 04f:939 ($\sigma^2_{s\ell}$ in @sec-joint-model) and 04f:1302 ("measures what that buys"): kept by
  `tbl-joint-misspec`.
- 04f:1495: kept.
- 04e:1149-1151 (optimal cross selection in @sec-ocs): kept at `09-optimal-contributions.qmd:108`.
- 04g:128-135 and 04g:986-998 match 04f results 2 and 6. 04g:1145 matches 04f:1103 (optimised blocks
  show no gain).

## Numbers checked against `book/data` (all consistent)

- 04e:52 and 04e:853 (0.08 to 0.13): h2h gives 0.082, 0.107 and 0.125.
- 04e:855 (0.61, 0.72, 0.82 at 1, 1.5 and 2.5 %): 0.608, 0.722 and 0.815.
- 04e:856 (T0 0.10 to 0.15): 0.099 to 0.146.
- 04e:860 (LS penalty 0.50 at c = 2, under 0.01 for testers): 0.498, and 0.0007 to 0.0068.
- 04e:854 and 04e:859 (+34 %, +15 %, +13 %) match 04e:626 and 04e:440.
- 04f:54 (0.06 to 0.09): +0.060 at h2 = 0.4 and +0.086 at h2 = 0.2.
- 04f:928 and 04g:987: 20 % untested, 80 % planted.
- 04f:943 and 04g:866: genetic correlation 2/3.
- No broken `@sec-` targets anywhere in `book/*.qmd`.

## Inbound `@sec-` citations (from other files, any section id defined in the chapter)

| Chapter | Inbound total | From the body after the part (05-12) | Sources |
|---|---:|---:|---|
| 04d-breeding-programme | 15 | 0 | 04c 12, 04f 1, 92 1, index 1 |
| 04e-mating-design | 47 | 0 | 04g 20, 04f 17, 92 5, 90 3, 91 1, index 1 |
| 04f-sparse-testing | 35 | 0 | 04g 21, 92 7, 04e 5, 91 1, index 1 |
| **04g-joint-allocation** | **9** | **0** | 04f 5, 04e 4 (no index, 90, 91 or 92) |
| 05-genomic-era | 25 | 15 | 04g 5, 05b 4, 92 2, 06 2, 11b 2, 12 2, others 1 each |

The count is not 0 or 1 for any chapter in scope. However, every citation of 04e, 04f and 04g comes
from inside the part or from the appendices and index, and 04g is cited only by its two siblings
(see C2).
