# 12-case-study, iteration 1: references check

Scope: book/12-case-study.qmd (282 lines), bib book/references.bib.

Headline: the chapter has NO `@key` bibliography citation (every `@` outside R code is an
internal `@sec-` cross-reference). So there is no bib entry to verify, no Comstock 1949
attribution (grep: zero hits for comstock/@comstock in this file), and no external paper is
attributed any content. The only source-attributed item is the unlabelled identity "Eq3"
(line 102), checked below. The substantive checks are therefore the internal attributions
("@sec-X found ...") and the checklist claims against the chapters they lean on.

## Findings

**12-B1 (WRONG, cross-reference target) -- line 58.**
"`alpha_max` is the attainable ceiling from @sec-baseline". @sec-baseline
(06-metric-catalogue.qmd:814) defines alpha against a resampling baseline (eq-catalogue-alpha)
and says nothing of an attainable ceiling or of truncation (grep "attainable|ceiling" in the
section: none). The ceiling alpha_trunc, "alpha_max >= alpha_trunc restricts nothing", and the
warning from `stage2_select()` are in @sec-ocs (09-optimal-contributions.qmd:443-444). R code
confirms: R/11_stage2.R:95 `alpha_max <- alpha_loss(sel_trunc, ...)`. Fix: point to @sec-ocs
(and @sec-baseline for the baseline only).

**12-B2 (WRONG / contradicted by the book) -- lines 229-231.**
"A large gap means the optimiser has not converged; a slack constraint means the search never
reached the boundary." 10-combinatorial-selection.qmd:1316-1331 says the opposite for the
gap: "A gap is the [sum of two things: the optimiser's and the relaxation's] ... the gap alone
does not separate them", the bound is that of a continuous relaxation of a discrete problem,
and 'a large gap means the optimiser has not converged' "cannot be applied" at production scale
(uncertified bound, `bound_certified` FALSE). Also line 229 says "continuous relaxation" where the
valid object is the Lagrangian bound `ocs_bound()` (CLAUDE.md; 09:355, 10:1278-1293), and
"never reached the boundary" is reasoned about in 10:896-906 as not established by a slack
constraint alone. Rewrite: check against `ocs_bound()`, read the `converged` attribute first,
and treat a gap as an upper limit on suboptimality only when certified.

**12-B3 (UNSUPPORTED / contradicted) -- line 225.**
Checklist "The search is encoded on **line weights**, not hybrid keys." 10b-advanced-selection.qmd
(1951-1975) states that no experiment isolates the encoding, that the closest comparison
(`sel_de()` vs `sel_de_fast()`) "favours `sel_de()` uncapped" (hybrid-key encoding ahead at
benchmark book scale, resolved by 3 seeds), and that the line encoding is not cheaper per
evaluation (59 vs 47 us, CLAUDE.md). The 5.7x result of Finding 4 was under four simultaneous
restrictions with the decoder satisfying the cap by construction (10:896-906). The checklist
item should be conditional ("under a per-line cap and at large N, the line encoding is the only
feasible route; uncapped it is not shown to be better").

**12-B4 (OVERSTATED) -- lines 247-248.**
"DH induction, not hybrid mining, is usually where the diversity goes." 08-pipeline-stages.qmd
(Interpretation after the ledger, "Where the diversity actually goes") says S2 carries the
largest share "in this file, at this scale, with these 8 pools: that is a statement about the
first arm [UC only], not about DH induction in general", that with the diversity term "the
three stages carry similar shares", and that the structural reason is a hypothesis. "usually"
generalises one cached external study (8 pools, one arm). Rephrase as "in the one study the
book has (8 pools, merit-only arm), ...", or drop "usually". FULL TEXT of the book chapter
checked (docs/08-pipeline-stages.html and .qmd:840-866).

**12-B5 (OVERSTATED) -- lines 273-275.**
"@sec-cycles shows concentration is what erodes the programme's future." 11b-diversity-across-
cycles.qmd:478-497 states the Spearman association between gain and genic variance (within-cycle)
"is an association, not a test of a mechanism ... no arm manipulates genic variance", and
:626-628 "A mechanism in which a better per-cycle optimiser spends budget that a later cycle
needs is a hypothesis; nothing here tests it." Chapter 12 turns the hypothesis into a result.
Rephrase: "@sec-cycles finds the unconstrained arm falls behind as genic variance is spent; it
does not test the mechanism". Also line 270-275 "@sec-cycles assumes it away (C7)": faithful
(C7 at 11b:178).

**12-B6 (IMPRECISE) -- lines 187-190.**
"could not say whether it improved the effective number of parents or the alleles retained at
the end of the pipeline". In 08 (Table of end-of-pipeline outcomes) the Ne row is "Ne (set
unrecorded)": +1.13, 95% CI -0.97 to 3.22, higher in 6/8 pools, p = 0.24; marker alleles
retained +40.6 (CI -100.9 to 182.1, 5/8, p = 0.52). It is the Ne of an unrecorded set, not
"the effective number of parents" (`Ne_parents`, a defined metric of this book). The sentence
also omits the one outcome that did move: final-set GD higher by 0.0078 (CI 0.0021 to 0.0136,
7/8; post hoc) and merit lower by 11.0% (8/8). Suggest "the effective size of an unrecorded
set". Claim "lowered S2 loss and raised the S3 and S4 losses" is faithful (8/8 pools; 9.40 to
3.43%).

**12-B7 (MISSING SOURCE, minor) -- line 102.**
`max_deviation_from_Eq3`: "Eq3" is a label with no citation in this chapter. FULL TEXT
verified against reference/papers/"Management of genetic diversity in the era of genomics.pdf"
(Meuwissen et al. 2020, Front Genet 11:880, p. 4, Eq. 3): "F_hom - F_drift =
2 cov( dp_{t,k}/sqrt(p0(1-p0) ; (p0 - 1/2)/sqrt(p0(1-p0)) )". So the equation number is correct
and `cov_diag = F_hom - F_drift` (line 98-99) is the content of that equation. Add
"[@meuwissen2020, their Eq. 3]" (key exists, references.bib:180) so the chapter is
self-standing; 05-genomic-era.qmd:516 already uses exactly that form. Not a content error.

## Internal claims verified (no finding)

- Line 192-194 "unconstrained ahead of alpha_max = 0.02 ... for eight cycles and behind it for
  the rest, on the seed mean": book/data/cycles_trajectory.csv seed means: unconstrained higher at
  cycles 0-7 (7.953 vs 7.697 at 7), lower from cycle 8 (8.419 vs 8.440). 8 cycles ahead, 8 behind.
  Faithful. (11b:340-346 adds that the crossing at cycle 8 is "not resolved by five seeds"; ch12
  carries "on the seed mean" but not this caveat. Optional addition.)
- Line 199-200 re-anchoring: 11b:273-279, F_drift exactly zero in all 5 draws and 15 generations
  (asserted), "five generations of real drift would be reported as exactly none". Faithful.
- Line 167-170 (Finding 5): "index biased upward" (07: "the plan's own scorecard is biased
  upward", r = 0.5: reported 1.77 vs delivered 0.92); correlated vs independent error alpha
  3.67% vs 1.22% (ratio of means 3.0, 60/60 seeds, r = 0.6, truncation). "several times" =
  about three times, one method and one accuracy; acceptable, could say "about three times".
- Line 271 "@sec-choosing Finding 5 measures it within one cycle": faithful.
- Line 183-184 N_s a static descriptor, not a drift projection: 06:208-220 (Toro 2020 abstract
  only, as that chapter itself says). Faithful.
- Line 251-252 closed pool depletes: 11b fig-alt/C6, F_drift rises in all three budgets. Faithful.
- Line 249-250 log(1-F) linearity: 05-genomic-era.qmd:207-210 (attributed there to Meuwissen
  2020). 11b:632 refers back to this very checklist. Consistent.
- Line 265-269 / 270: @sec-heterosis alignment (05b:793) and lambda of @sec-catalogue
  (06:677-713, lambda_d) exist and say what is claimed.
- Line 178 symmetric pools: R/00_data.R:41-45 `bn(p_anc, fst)` for both pools. Faithful.
- Line 75 "@sec-genomic-era called for" Ne_parents: 05:1820-1822 says `ne_parents()` is
  "reported alongside the two lenses" in @sec-case-study. Faithful.
- All `@sec-` anchors in the chapter resolve (baseline, genomic-era, stages, simulating-crosses,
  choosing, heterosis, ns, cycles, catalogue). `@sec-baseline` resolves but points to the
  wrong content (12-B1).

## Comstock 1949
Not cited in this chapter; nothing attributed. No finding.

## Where I looked
Local: this worktree's book/*.qmd, docs/*.html (rendered numbers), book/data/cycles_trajectory.csv,
R/00_data.R, R/11_stage2.R; reference/papers/ (Meuwissen 2020 pdf, pdftotext -layout).
PubMed/web not needed: no external bib entries are cited.

## Evidence-level count
External bib citations in the chapter: 0. Source-attributed equation checked at FULL TEXT: 1
(Meuwissen 2020 Eq. 3, via 12-B7). Internal cross-chapter attributions checked against the
cited chapter's source text and data: 17 (12-B1 to B6 plus the 11 "verified" items), none
UNVERIFIED except that "Heterotic-group assignment ... treated as uncertain" (line 211-212) and
"the number of selected parent lines is biologically plausible" (line 241) are advice with no
cited source in the book, not checked.
