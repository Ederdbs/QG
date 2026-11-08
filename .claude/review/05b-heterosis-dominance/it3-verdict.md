# 05b-heterosis-dominance -- verdict, iteration 3

Text judged: `book/05b-heterosis-dominance.qmd` (uncommitted), scope limited to what the iteration-2 fixes changed: the d_k rename in `00`, `02`, `05b` (including the `fig-cap` string), the convention sentence at 05b:141-146, and M24-M27. Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-01-05`, branch `review-01-05`. Read: it2-verdict.md, it2-response.md, the changed passages, `git diff HEAD` of 00 and index.qmd. Scratch: `/private/tmp/claude-501/-Users-ederdbs-Documents-SB-quanti-gen/b21c3252-fade-4466-9e3d-6022a32fa781/scratchpad/it3/`. No `book/Rplots.pdf`, no `book/figure/`. Nothing in the book edited.

VERDICT: APPROVED

Counts: closed 05b-D2 and M24, M25, M27; reopened (low, narrowed) M23 and M26; new disqualifying none; new non-disqualifying none beyond the two reopened. Two open non-disqualifying observations plus the carried Info (M22); the accumulation threshold (three) is not reached, and neither touches a conclusion of the chapter.

## PREVIOUS IDS

- 05b-D2 -- CLOSED -- the reserved phrase "dominance deviation" no longer denotes d_k anywhere in 00, 01, 02, 02b, index.qmd, 05b, nor in chunk options, `!expr` captions, chunk comments or the regenerated `book/downloads/*.R`. Independent multi-line search (below): the three remaining hits are 05b:142 (naming the phrase as reserved), 05b:146 and 05b:153 (Fisher's statistical term). The fig-cap of `fig-heterosis-alignment` (05b:797) now reads "the same set of dominance effects in all three bars"; the download carries the same string.
- 05b-M23 -- OPEN (low, narrowed) -- the convention sentence (05b:141-146) is now scoped to this chapter, 00, 01, 02, 02b ("call d_k the dominance effect and nothing else") and admits the older name in other chapters (05:326, which I confirmed, "$d_k$ the dominance / deviation"). It is true of the reserved phrase. It is not true to the letter of "nothing else": `02b-response.qmd:578` names d_k "deviations" ("with deviations $d_k \sim N(...)$"), pre-existing text left untouched by the rename; the same paragraph's caption (02b:586) and comment (02b:592) say "dominance effects". Not the reserved phrase, so not D2.
- 05b-M24 -- CLOSED -- 05b:621-622 now gives the six totals by inline `round(min/max(sw$total), 4)` and points to the `total` column of @tbl-het-sweep, which is the table printed just above (label at 05b:588). Run: 0.362 and 0.3664, consistent with the 0.3620-0.3664 I reproduced in iteration 2.
- 05b-M25 -- CLOSED -- the third candidate (loss of segregating loci under six founders, changing the effective number of loci averaged) is added and the sentence "Each is a candidate explanation, not a result" covers it. The writer's reason for omitting the IQR remark (not a chunk of the chapter) is accepted; the claim is about the s.d., which holds.
- 05b-M26 -- OPEN (low, narrowed) -- see M26 below.
- 05b-M27 -- CLOSED -- the callout (05b:1338) now states the qualifier once for all three items: "all of them in expectation over the draw of the pools (the sweep itself is one draw per point)".

All other iteration-1/2 IDs remain closed; the diff does not touch them.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

Low
- **05b-M23** `book/05b-heterosis-dominance.qmd:141-146` against `book/02b-response.qmd:578` -- "call $d_k$ the dominance effect and nothing else" is contradicted for one word in a chapter the sentence names: 02b:578 calls d_k "deviations". The instance sits in the paragraph that introduces the illustrative dominance-only value, two lines before "dominance effects" in the caption and comment. Does not reuse "dominance deviation", so no collision with Fisher's term.
- **05b-M26** `book/05b-heterosis-dominance.qmd:487` -- "the only place the book uses the quantity is at $F = 1$ (@sec-alphasimr)" is contradicted by this chapter: the chunk at 05b:427-441 evaluates `inbreeding_depression(pA[k], d[k], 0.6)` against `ref_inbreeding_depression(..., 0.6)` and the text reports "$F = 0.6$" (the test file `test-response.R:42-52` also uses 0.5 and 0.6). It is a formula check on 300 loci of one pool, not a partially inbred generation, so the callout's conclusion (the book does not model depression for the F2-F4 generations) stands; the sentence as written does not.

Info
- M22 sources remain UNVERIFIED (non-decisive; see NOT VERIFIED).
- Owed, not blocking (named chapters; the convention sentence of 05b:145-146 admits them): d_k wording in 04c:333, 04e:176, 05:326, 06:364, 06:479, 08b:136, 08b:767, 12:262, 90:210, 90:515, 90:605; test title/comment at `tests/testthat/test-dominance.R:160` ("same multiset of dominance deviations", denotes d_k; owed to the tests pass). Added to the owed list by this review: `02b-response.qmd:578` is in a chapter the 05b sentence names, so it is owed to 02b if M23 is to be closed.

## WHAT WAS VERIFIED

- Multi-line search, `perl -0777`, over `book/index.qmd`, `00-*`, `01-*`, `02-*`, `02b-*`, `05b-*`:
  (a) `dominan\w*(?:(?!\n\n).){0,40}?deviat\w*` with `/gis` (crosses line breaks, markup, `$`, `*`, `/`, up to 40 characters inside one paragraph) and the reverse order `deviat\w*...dominan\w*` over index/00/01/02/02b: only 05b:142, 146, 153; none in the reverse order.
  (b) the same pattern over the regenerated `book/downloads/{00,01,02,02b,05b}*.R` (which hold chunk options, `!expr` strings and comments): hits only at the three Fisher/reserved-phrase lines of 05b (download lines 205, 209, 216); none for 00, 01, 02, 02b.
  (c) every `deviat\w*` in index/00/01/02/02b outside "standard deviation": all are statistical deviations of numerical checks (00-02b), except 02b:578 (d_k named "deviations", M23). `grep -n dominan` over the same files: every d_k occurrence is "dominance effect(s)", "flat dominance", "dominance part/value".
  (d) `grep -rn -i 'dominance.\{0,3\}deviation' R man tests inst`: only `tests/testthat/test-dominance.R:160`.
- 05b hits for `dominance deviation`: 142 (the phrase named as reserved), 146 and 153 ("Fisher's statistical dominance deviation", "the statistical dominance deviation that a given d_k induces"): all Fisher's term, in the sense defined at 05b:144-148. Other `deviation` hits in 05b (414, 436, 892, 930, 1012, 1017, 1039, 1106-1114, 1465-1482, 1574, 1711-1962) are numerical deviations or deviations from frequencies, checked line by line in the listing; none is dominance.
- 05b `d_k` is named only "dominance effect(s)" (29, 137, 173, 540, 783, 797, 990, 2048, 2052); "dominance value" (301, 320, 1466) denotes the total dominance contribution of a genotype, not d_k.
- Convention sentence true today for the reserved phrase in 00, 01, 02, 02b: yes; for "and nothing else": one slip, 02b:578 (M23). Labels `sec-hybrid-programme`, `sec-coancestry`, `sec-subdivided`, `sec-response`, `sec-genomic-era` exist (00:1, 01:1, 02:1, 02b:1, 05:1); 05:322-326 does carry the older name for d_k (confirms the "still use the older name" clause).
- Diff of 00 and index.qmd read: 00:40, 125, 138, 165 "dominance effect(s)"; no number or chunk code changed; 02:1097-1098 now reads "aligned with the dominance effects".
- Chapter re-run: `knitr::purl` of the current .qmd to the scratch directory, `_common.R` forcing `pkgload::load_all` of the worktree, `Rscript -e 'pdf(NULL); source("ch.R")'`: no error, 8.4 s; every `stopifnot` passes. Inline M24 values `0.362 0.3664` (mean 0.3646); fig-cap factor `1.55`, as in the text.
- M26: `grep -rn inbreeding_depression book/*.qmd R tests inst`: uses at 04c:506, 523, 528 (`F_coef = 1`), 05b:409-439 (F = 1, then 0.6), `test-response.R` (0.5, 0.6), definition `R/13_dominance.R:139-142` (`2 * F_coef * sum(d * p * (1 - p))`).

## NOT VERIFIED

- Falconer & Mackay (1996) Ch. 7 / Ch. 14 locators; Fisher (1918); Sprague & Tatum (1942); Griffing (1956); Reif et al. (2007) formula-level definition; Balding & Nichols (1995) beta form; Labroo et al. (2021) beyond refcheck's reading; Mackay et al. (2020) and White et al. (2020) abstracts only; Technow et al. (2014) taken from refcheck's full-text reading; Comstock et al. (1949) (title only is claimed); Moll et al. (1962) and Melchinger & Gumber (1998) existence only. None is decisive for 05b after the iteration-1/2 narrowing.
- Mechanism of the larger recycled-pool dispersion: untested; the chapter says so.
- Typst/PDF rendering and stale `docs/` and `_freeze`: not rendered.
- Owed rows in other chapters (listed above): not judged here.
