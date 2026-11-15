# 08b-genomic-prediction -- iteration 1, continuity (chapter mode, read-only)

Scope: `book/08b-genomic-prediction.qmd` against 00-08 (THREAD entries final), `part-*.md`, `90-notation.qmd`,
and the later chapters that cite it (04c-04g, 09, 10, 11b, 12). Checks 1-4, 6, 8. The audit
(`it1-audit.md`) was read for context; only continuity is judged here, so its R1-R18 are not repeated
unless they have a cross-chapter side. Owner: THIS = 08b; EARLIER-NOW = an earlier chapter to be fixed in
this review; LATER-OWED = a later chapter, goes to `Owed` in THREAD.

## Owed items naming 08b: status

| Owed item | Status | Finding |
|---|---|---|
| 08: `08b:43` "the saving @sec-stages calls hybrid mining (S4)" | open, wrong | 08b-C3 |
| 08: `08b:729-740` Finding 5 consistency | open (partly consistent, two defects) | 08b-C9, 08b-C10 |
| 01-C11 `08b:19` quoted "is the right matrix for GBLUP." | open | 08b-C6 |
| 03-C11 `08b:9-13` "an optimistic ceiling" as 03's words | open | 08b-C6 |
| 05-C15 cite @eq-era-rank (08b:208-250) | open | 08b-C7 |
| "dominance deviation(s)" `08b:135`, `08b:767` | open | 08b-C8 |
| SCA absent from `ctx$traits` (02b/05b/11b), keep true | kept true (08b:134-138, 763-768; `traits = scale(Z %*% B)`, 03:433) | none |
| 04c LD promise (04c:337-340) | content true; 08b never says it | 08b-C13 |
| 07 (`07:670-672`) top/bottom of the range | true as to ordering; see C9, C10 | |

## Findings

### H

**08b-C1 (H) -- one symbol, two matrices: `Z`. Owner THIS (and the 90 row).** `08b:97-101` and
`08b:569-579` use $\mathbf Z$ for the centred marker matrix ($\mathbf g = \mathbf Z\boldsymbol\beta$,
$\mathbf G = \mathbf Z\mathbf Z'/\ldots$, $\mathbf u = \mathbf Z\boldsymbol\beta$, $\mathbf Z_t$); `08b:168-188`
uses the same $\mathbf Z$ for the incidence matrix "mapping training records to individuals", and the code
at `08b:258` and `08b:302` builds that incidence matrix as `Z` while `vr$Z` is the centred one
(`08b:590`). `08b:569` says "Substitute $\mathbf u = \mathbf Z\boldsymbol\beta$ ... into the equations
above", i.e. into equations in which $\mathbf Z$ already means the incidence. `90:58` fixes
$\mathbf Z$ as the centred dosage and "the marker design matrix of $\mathbf u = \mathbf Z\boldsymbol\beta$
(genomic prediction)"; it records a clash with joint allocation but not this one. The incidence matrix needs
another symbol in 08b; 90 should then say which.

**08b-C2 (H) -- CV0/CV1/CV2 carry two definitions in the book and a wrong attribution. Owner THIS; 90 and
04f LATER-OWED.** `08b:330-337` says @burgueno2012 "named the schemes that distinguish the cases" and
defines CV2 = both parents seen, CV1 = one parent unseen, CV0 = neither. `04f:422-433` defines the same
labels after the same reference as CV2 = genotype observed in other environments, CV1 = new genotype,
CV0 = new environment, CV00 = both new, and `04f:410-415` says "a second collision is inside this book"
(@sec-hybrid-cv against `@sec-sparse-validation`). `90:366-368` defines CV0/CV1/CV2 as 08b does;
`90:483-490` (Sparse testing table) defines CV1/CV2/CV0/CV00 as 04f does: the same labels, two meanings,
inside one appendix. Third vocabulary: T2/T1/T0 for the same parent-seen split (`04e:741-748`;
`90` Mating design table). So 08b's own claim that the labels are Burgueno's is contradicted by the later
chapter that cites the paper for its definitions. 08b is the chapter that introduces the labels first, so
it must say it reuses the three names with a hybrid-parent meaning (and drop or soften the attribution);
the collision note then belongs in 90 (one row equating CV2/CV1/CV0 of 08b with T2/T1/T0 of 04e) and
`04f:413`, which today describes the collision with a hybrid "CV1" that is "T2" (both parents planted)
and not the one-parent-unseen CV1 of 08b:333.

**08b-C3 (H) -- the S4 "saving" is not 08's, and the genotyping claim is not established earlier. Owner THIS
(owed 08, 08b:43).** `08b:42-44`: "Genotyping two parent lines already on hand is enough to rank a
candidate that would otherwise cost a full generation to phenotype -- the saving @sec-stages calls hybrid
mining (S4)". `08:710-716`: the S4 saving is memory, $O(N^2) \to O(L^2)$, "not a saving of time per
evaluation unless $n$ is large", and `08` discusses no genotyping or phenotyping saving (grep
`genotyp` in 08: S2 DH lines only, 08:316, 400). What 00 does establish about this chapter and S4 is
different: `00:183-191` lists @sec-genomic-prediction under S4 and says genomic prediction "supply the
predicted values that S4 selects on". The pointer should be to that (and `@tbl-hp-stages`), not to a
saving 08 states. The same unsourced claim returns at `08b:145-151` ("typically already on hand",
"a full crossing and evaluation cycle").

**08b-C4 (H) -- the stage-1 hand-off does not match the contract 03 and 09 describe. Owner THIS.**
`08b:709-720` says `data.frame(hybrid = cand, trait1 = predB)` is "exactly the `traits` argument
`stage1_build()` expects -- one column per trait, one row per hybrid". 03 establishes the contract
(`R/10_stage1.R:69-70`: `nrow(X) == nrow(ped) == nrow(traits)`; `traits` is $N \times$ n_traits, 03:604
"predicted traits, standardised"; `index` is the multi-trait index "standardised once", 03:574-575, built
by `build_ctx()`). The chapter's frame has 250 rows (candidates only), an id column that `stage1_build()`
would duplicate, and a single trait where `ctx$index` and 09:13 ("how a real programme gets a `traits`
matrix") speak of the multi-trait matrix; the 375 training hybrids drop out of any later candidate pool
(so $N$ becomes 250 in 09-10) and the text does not say so. `10:45` then cites @sec-genomic-prediction for
"`build_ctx()` forms the single index ... standardised to unit variance", which 08b never shows (03
owns it). Fix in 08b: state that `X` and `ped` are cut to `cand`, ids renumbered, one trait only and
what the index step adds; 10:45 re-point to 03 (LATER-OWED, L).

**08b-C5 (H) -- 04e promises that 08b fits kernels it does not fit. Owner 04e, LATER-OWED.**
`04e:729-731`: "The modern version models hybrid value as pool-specific additive kernels for GCA plus a
dominance or product kernel for SCA ...; @sec-genomic-prediction is where this book fits those models, and
@sec-hybrid-cv where it validates them by masking hybrids." `04e:1147`: "@sec-genomic-prediction fits
the hybrid prediction models this chapter's genomic results rest on." 08b fits one ridge/GBLUP kernel
(a single $\mathbf G$ over all hybrids, no pool split), BayesA, BayesB, BayesC$\pi$, all additive;
`08b:763-768` says SCA is absent and unmodelled; 04e's own genomic results are a cached external
`sparsex` GBLUP/REML sweep (`04e:79-81`). Both sentences should say what 08b does: the additive GBLUP and
the CV scheme (and that it is the SCA kernel that is missing), not those models. The reciprocal
statement in 05b (`05b:1390-1392`, `05b:2159-2162`: "such a model cannot represent SCA at all", "supplies
a missing term") matches 08b and is kept.

### M

**08b-C6 (M) -- two attributions in the opening that the cited chapters do not support (owed 01-C11, 03-C11).
Owner THIS.** (a) `08b:10-12`: 03 "called the result 'an optimistic ceiling.'" -- the phrase is not in 03
(grep: only `11b:102`, `12:170`, and 04e:1114 in another sense); 03's callout (03:453-478) claims only
that the optimum on known values is not exceeded by one on estimates. (b) `08b:19-20`: `vanraden_G()` "has
said since @sec-coancestry that its matrix 'is the right matrix for GBLUP.'" -- 01:84-86 reads "it is the
right matrix for genomic best linear unbiased prediction (GBLUP)"; the roxygen (`R/00_data.R:86-89`) says
"Use this for trait prediction only" and has no GBLUP sentence. (c) `08b:469-471`: `bWGR` "is exactly the
tool `vanraden_G()`'s docstring pointed toward without naming" -- the docstring names no tool. Quotation
marks and the "docstring" claim should go; paraphrase with the correct location. 03:183 and 03:484 ("the
gap in prediction is closed in @sec-genomic-prediction") are kept true by 08b:14-16.

**08b-C7 (M) -- rank of $\mathbf G$ rederived instead of cited, and its equality stated as a theorem
(owed 05-C15). Owner THIS; 05 owns the result.** `08b:208-251` rederives the span argument and rank table;
@eq-era-rank (`05:1935`: $\mathrm{rank}(\mathbf f) \le \mathrm{rank}(\mathbf B)$, also $\le m + 1$) is not
cited. Two differences with 05. (i) 05 says explicitly that the bound is a theorem and that equality "is a
measurement" at one scale and one draw of line genotypes (05:1993-2000); 08b:245 states
"$\mathrm{rank}(\mathbf G) = L - 2$, independent of both the number of hybrids and the number of markers"
as an identity, on three simulated scales (10, 20, 25 lines per pool, `m = 2000`), and omits the
$m + 1$ bound (not binding at $m = 2000$, not independent of $m$ in general). (ii) 05's value is
$L - 1 = 49$ for $\mathbf f$ at this scale and 08b's $L - 2 = 48$ for the centred $\mathbf G$: consistent,
and the extra dimension (centring) is explained in 08b but with no pointer to `@eq-g-sum-zero` (01:105),
only to `@sec-why-not-g`. Also: `08b:218` "singular for *every* population" holds for the $\mathbf G$ of
@eq-vanraden-g centred on its own frequencies; for a $\mathbf G$ centred on a fixed base
($\mathbf G_{0.5}$, `ctx$p0`; 01 and 05) $\mathbf 1'\mathbf G\mathbf 1 \ne 0$ and the argument of
`08b:210-216` does not apply (the factorial rank bound still does). `05:2036` points back to
@sec-g-singular for the blend; that pointer is kept.

**08b-C8 (L, listed M by the owed lists) -- "dominance deviations" for $d_k$. Owner THIS.**
`08b:135` ("the dominance deviations of @sec-heterosis are absent from `ctx$traits`") and `08b:766-767`
("@sec-heterosis's dominance deviations are where it comes from"): 05b settled "dominance effect" for
$d_k$ and reserves "dominance deviation" for Fisher's term (05b:153-164; 90 settled in 04c). Same two
lines as in the 05b/05 Owed. In the second the pointer should be the SCA section
(@sec-heterosis-gca-sca) rather than the chapter label, which also resolves the "where it comes from".

**08b-C9 (M) -- Finding 5 bridge compares unlike quantities. Owner THIS (07:670-672 stays true after).**
`08b:729-739` sets 08b's measured accuracy against the grid $r \in \{0.5, 0.7, 0.9, 1\}$ of 07
(`07:727`, matches). (i) 07's $r$ is a **nominal** accuracy: `07:680-685` and `90:346` say the realised
correlation of $\hat u$ with $u$ differs from $r$ in every seed and report it separately (`r_real`);
08b compares a *realised* correlation with the *nominal* grid without saying so. (ii) 07's target is
`ctx$index`, the three-trait standardised index $u$ (`07:677-678`); 08b predicts trait 1,
`g <- ctx$traits[, 1]` (`08b:59`), and `02b:910` already notes 08b measures "a different object". (iii)
Three values stand for "the" CV2 accuracy: 0.96 inline (`08b:731-732`, 375 training records, the opening
split), 0.93 in the table and callout (`08b:410`, 289 records). `08b:735-736` calls the 0.96 "the CV2
number". (iv) 07 describes the 08b residuals as "the same structure" (`07:670-672`): 08b:741-755 supports a
correlation of 0.14 of error products with $\mathbf f$ on one split (no dispersion; audit R10). Consistent:
ordering (CV2 at the top of the range, CV1 near the bottom, CV0 below it); 07's own realised-gain
difference is declared "not a result" (07:911-913) and 08b claims none.

**08b-C10 (M) -- "Finding 5's pessimistic cases are the realistic ones" meets the published values 04e
cites from the same source 08b cites. Owner THIS; 04e keeps.** `08b:739` and `08b:372-381`, `08b:406-414`
treat CV0/CV1 values of 0.12/0.65 as what a programme faces. `08b:330-331` cites @technow2014 as having
applied the scheme "to exactly this design". `04e:744-757` quotes that paper's T2/T1/T0 grain-yield
accuracies as 0.91, 0.85, 0.77 (300 training hybrids), and `04e:856` records the book's 0.10-0.15 T0 as in
"tension" with them, explained there by family structure and linkage that this book's generator lacks.
08b says nothing of the published values and presents its own as the honest measure ("what the 2000 markers
bought"). Which scheme a programme faces is not in the data (the audit's R9 is the same point inside the
chapter); here the cross-chapter side is that the book's later chapter says the 0.12 is not
programme-independent, and 08b should not claim realism. The 04e T0 figure (1137: ~0.1) and 08b's CV0 (0.12)
agree in size, from two different generators; neither chapter says the other's number is comparable.

**08b-C11 (M) -- $\mathbf G^*$ and $\hat u$/$g$: symbols that the model of the chapter and the code do not
share, and a clash with 07. Owner THIS; 90 LATER (appendix).** (i) The model is stated with $\mathbf G$
(`08b:156, 169`, MME at `08b:181-186` with $\mathbf G^{-1}$), the code solves with
$\mathbf G^* = 0.95\mathbf G + 0.05\mathbf I$ (`08b:256`), and the reliability formula `08b:282` uses
$\mathbf G^*_{ii}$ before the text introduces the symbol (it is named only by the prose at `08b:295`).
`90:347` lists $\mathbf G^*_{ii}$ in the reliability row; the Matrices table (`90:36-60`) has no row for
$\mathbf G^*$. (ii) $\mathbf u$ and $g$ are the same object in this chapter ($\mathrm{Var}(\mathbf g) =
\mathbf G\sigma^2_u$, `08b:100-101`; accuracy is $\mathrm{cor}(\hat{\mathbf u}, g)$, `08b:269`), under two
letters; and $u$ with a hat has the opposite role in 07: `07:677-678`, `90:283`, `90:297` have $u$ as the
TRUE index and $\hat u$ the simulated prediction, while `90:337`, `90:346` has $\hat{\mathbf u}$ as the BLUP
and $g$ the truth. 90 records the nominal-versus-realised clash of $r$ (90:346) but not this one. Not
settled by any entry in THREAD for 90.

**08b-C12 (M) -- an additive-only identity is turned into the "operational payoff" for hybrid crops.
Owner THIS (assumption across chapters).** `08b:37-44` ("a hybrid's value is additive in its two parents'
genotypes ... transformative ... in a cross-pollinated, hybrid crop") and `08b:140-151` ("scores *any* line
A x line B combination ... what makes genomic selection valuable specifically in a cross-pollinated,
hybrid crop") derive from `ctx$traits`, which has no dominance by construction (03:180-184; `08b:134-138`).
00 establishes that under dominance the dominance part of GCA is an average effect at the *opposite*
pool's frequencies (00:122-130; 05b), that SCA exists and is not a property of either line, and
`04e:729-734` says the SCA kernel is part of the modern hybrid model. The chapter's own callout
(`08b:763-768`) concedes SCA is absent from the data, after the payoff paragraph states the consequence for
real crops without that condition. The scoring of never-crossed combinations is true of the additive
simulation and of the additive part of a real hybrid; the chapter should say so where it states the payoff.

**08b-C13 (M) -- the marker-QTL gap 04c and 05 route to this chapter is not named in it. Owner THIS;
04d LATER-OWED.** `04c:337-340` (and the THREAD entry for 04c, "keeps true") say that
@sec-genomic-prediction "does not model" founder LD because "its traits are built on the markers
themselves, so every causal locus is genotyped, there is no marker-QTL gap ..., and its accuracies are a
best case in that respect"; `05` A5 (05:128-133) states marker panel = causal set as a limit;
`04d:425-428` says marker-versus-QTL "is the reason that accuracy is finite". 08b states a different
best-case reason (`08b:112-116`: no model misspecified; `08b:496-511`: QTL drawn among the markers), the
"What this chapter still does not model" list (`08b:757-787`) has six items and not this one, and
`08b:389-391` (Daetwyler, $M_e$ = marker count, "no linkage") touches it only as a unit choice. As stated
the 04c sentence is true of the code, but a reader sent to 08b for it finds nothing. `04d:425-428` also
attributes the finiteness of the accuracy to the marker-QTL gap; in 08b the accuracy is finite because
of training size, noise and the rank $L - 2$ (no gap exists). Add the item in 08b; reword `04d:425-428`
(LATER-OWED).

**08b-C14 (M) -- the opening does not say why 08b follows 08. Owner THIS.** The chapter follows
`08-pipeline-stages` in @_quarto.yml; its opening (`08b:10-26`) is built on 03 and 07 and mentions 08 only
through the wrong pointer of C3. 08 does not forward to 08b either (no `@sec-genomic-prediction` in 08,
`grep`; 08's checklist ends on S4 and the ledger, 08:942-966). The part (Metrics and prediction) turns
here from diversity metrics to predicting the index; `00:747` lists both chapters in this part's answer.
A sentence saying what 08's last chapter leaves ("the index at S4 is taken as given") and what this one
supplies is missing. The forward promise at `08b:14` (@sec-case-study repeats the caveat) is kept
(`12:164-170`), though 12 cites only Finding 5 and not 08b (C16).

### L

**08b-C15 (L) -- numbers: nothing broken across chapters.** Checked: $N = 625$, $L = 50$, $m = 2000$,
`seed = 1` match 07 (`07:675`) and `_common.R:22-25`; the producer of the cached sweep
(`regenerate.R:143-165`) uses the same `seed = 1` and `seed + 42`, so "the oligogenic architecture the
cached sweep uses" (08b:493) is the same draw; 289 / 272 / 64 / 375 follow from 25 + 25 lines and 8 held out
(`(25-8)^2`, `2*17*8`, `8*8`, `floor(0.6*625)`); rank 48 = $L - 2$ against 49 = $L - 1$ in 05; $\pi$ and
$\nu$ rows of 90 (`90:339-361`) agree with the chapter's use of `pi`, `df`, `R2`. One mismatch of
wording: the caption of the sweep (`08b:668`) says true $\pi = 0.9985$, `08b:510` and `08b:687` say
$1 - 1/2000$ / ~0.9995 (audit R13, inside the chapter). 90 has the same $\pi$ row with no true value.

**08b-C16 (L) -- later chapters that state "no prediction error" do not point to 08b. Owner 11b, 12,
LATER-OWED.** `11b:100-104` (C7) and `12:164-172` cite only Finding 5 for what relaxing the known index
does; neither cites @sec-genomic-prediction, where an actual fitted accuracy per CV scheme is measured
(`grep`: 11b, 11c, 12 have zero `@sec-genomic-prediction`). 08b:14 promises that 12 repeats the caveat,
and it does; the cross-link back is what is missing.

**08b-C17 (L) -- `ocs_quadprog` "handed the truth". Owner THIS.** `08b:719-721`: `ocs_quadprog(f, gebv,
lambda, ...)` "has until now been handed the truth". `09:348-356` calls it on a 20-line subset
(`fLs`) with `merit <- scale(rnorm(20))` -- random numbers on lines, not `ctx$index` at hybrid level --
and `10b:771`, `10b:1071` call it on `ctx$fL` with line merits. The statement fits neither (and the
argument there is a line contribution vector, so hybrid-level GEBVs of 08b are not a drop-in). Also the
`lambda` of that signature is the OCS penalty, not the $\lambda = \sigma^2_e/\sigma^2_u$ of `08b:186`
(90:341 warns; the chapter does not, two lines apart).

**08b-C18 (L) -- citation precision. Owner THIS.** `08b:12` cites @sec-choosing for Finding 5; the
section is `@sec-choosing-error` (07), cited from 90 only. `08b:136, 766` cite the chapter label
@sec-heterosis where @sec-heterosis-gca-sca is the object (C8). `08b:210` cites @sec-why-not-g and not
@eq-g-sum-zero for the identity it uses.

**08b-C19 (L) -- genetic-variance symbol across chapters. Owner 90, 04f (LATER-OWED).** $\sigma^2_u$
(08b, 90:337-341) is the genetic variance of the breeding values; `04f:278, 684` and 04g write the same
quantity $\sigma^2_G$ in the reliability $1 - \overline{\mathrm{PEV}}/\sigma^2_G$ and `04e` writes
$\sigma^2_g$ for the GCA variance; 90 lists only $\sigma^2_u$ in the prediction block. 08b's reliability
$1 - \mathrm{PEV}_i/(\sigma^2_u\mathbf G^*_{ii})$ and 04f's per-genotype reliability describe the same
construction, at a stated different normalisation (pairwise contrasts in 04f:278).

## Redundancy (check 4) and assumptions (check 8): result

- No derivation developed in full twice: the mixed-model equations and the PEV formula live in 08b
  (`08b:166-186, 278-282`); 04f and 04g use the machinery (`04f:684`, `04g:436`, `04g:1299`) and refer back
  (04g) or restate (04f:278, 684 with $\sigma^2_G$, C19). The $L - 2$ rank argument is the one duplication
  (05 owns it): C7. 04e:741-757 and 04f:413 repeat the CV2/CV1/CV0 hierarchy under other names: C2.
- Assumptions that carry over, and how 08b meets them: inbred parents and complete factorial
  (A2; stated, `08b:120-124`), additive, single trait, known $h^2$, no LD (stated or conceded in the callout,
  except C12/C13), $\sigma^2_u = 1$ "because `traits` is standardised" (`08b:197`): exact only up to
  $\overline{G_{ii}} = 1$ and the data-dependent `scale()` constant of 03:433; it is an equality in the
  chapter's prose. Not a cross-chapter conflict.

## Inbound `@sec-` citations of 08b (self-citations discarded; `grep` over `book/*.qmd` at this review)

| Target id (owned by 08b) | Inbound | Files | Citing lines |
|---|---|---|---|
| `sec-genomic-prediction` | 23 | 14 | `00:185, 191, 747`; `02b:910`; `03:183, 484`; `04c:337`; `04d:265, 404, 425`; `04e:730, 1147`; `04f:238, 1499`; `04g:1299`; `05b:135, 1390, 2159`; `07:671`; `09:13`; `10:45`; `90:353`; `92:237` |
| `sec-hybrid-cv` | 4 | 3 | `04e:731`; `04f:413`; `90:357`, `90:368` |
| `sec-g-singular` | 1 | 1 | `05:2036` |
| `sec-genpred-truth` | 0 | 0 | cited inside 08b only (5 times) |
| `sec-genpred-pi` | 0 | 0 | cited nowhere |
| `fig-genpred-selection`, `fig-genpred-accuracy` | 0 | 0 | cited nowhere (no `@fig-` in the chapter either) |

08b is not an orphan (23 inbound citations from 14 files, none of them from 08, 11b, 11c or 12). The
sub-sections `sec-genpred-truth` (the additive identity, used by 08b alone) and `sec-genpred-pi` are
unused outside; `sec-hybrid-cv` has 4 (three files). Broken targets: none; all 12 distinct `@sec-`
targets of 08b resolve (`sec-case-study` 12, `sec-choosing` 07, `sec-coancestry` 01, `sec-cycles` 11b,
`sec-heterosis` 05b, `sec-ocs` 09, `sec-simulating-crosses` 03, `sec-stages` 08, `sec-why-not-g` 01, and
08b's own `sec-g-singular`, `sec-genpred-truth`, `sec-hybrid-cv`).

Outbound citations of 08b to other chapters (counts): 03 3, 07 2, 01 2, 05b 2, 12 1, 11b 1, 09 1, 08 1.
No citation to 05 (C7), 02b, 04c, 04e/04f (C2) or 05b's SCA section (C8).

## Summary by owner

- THIS (08b): C1, C2 (attribution), C3, C4, C6, C7, C8, C9, C10, C11, C12, C13, C14, C17, C18.
- EARLIER-NOW: none needed (05 and 03 are correct; 01:84 is a paraphrase, not a quote).
- LATER-OWED: 04e (C5, C10 keep), 04f and 90 (C2 collision rows, C19), 90 (C1, C11 rows), 04d:425-428 (C13),
  10:45 (C4), 11b:100-104 and 12:164-172 (C16).
