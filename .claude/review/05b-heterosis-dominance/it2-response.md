# 05b-heterosis-dominance -- response to it2-verdict (writer)

Multi-line search: `perl -0777` over book/00 .. 02b, index.qmd, 05b, 05, with `dominance\s+(\/\s*)?deviations?` and a looser `dominance\W{0,6}(\w+\W{1,4}){0,2}deviation` (catches markup and line breaks). Chunk options and `!expr` strings are inside the file text, so they are covered.

| ID | Status | Evidence |
|---|---|---|
| 05b-D2 | fixed | Hits, each decided. d_k (renamed to "dominance effect(s)"): 00:39-40 ("gives every marker a dominance / effect"), 02:1097-1098 ("aligned with the dominance / effects"), 05b:793 (fig-cap string of `fig-heterosis-alignment`: "the same set of dominance effects in all three bars"). Fisher's statistical term (kept): 05b:142, 144, 151 (and 149, same sense). 01, 02b, index.qmd: no occurrence (multi-line search). Re-run after the edits: only the three Fisher hits remain in 00-02b/index/05b. Wording only; no number or chunk code changed (the fig-cap string is the one permitted exception). |
| 05b-M23 | fixed | 05b:141-146 now states the convention for this chapter and for @sec-hybrid-programme, @sec-coancestry, @sec-subdivided, @sec-response, and says that other chapters (@sec-genomic-era among them) still use the older name for d_k, a difference of wording. No promise about the rest of the book. |
| 05b-M24 | fixed | "stays within the range quoted above" replaced by the six totals, printed by inline `round(min/max(sw$total), 4)` and pointing to the `total` column of @tbl-het-sweep (the table printed just above). |
| 05b-M25 | fixed | A third candidate is added: loss of segregating loci under six founders, which changes the effective number of loci the statistic averages. Stated as a candidate, not a result (the verdict did not test it, and neither did I). The tail-carried GCA_A remark (IQR ratio 1.05) is left out: it was run by the reviewer, not by a chunk of the chapter, so it cannot enter the text under the rule that every number comes from a chunk. |
| 05b-M26 | fixed | "the quantity enters the book elsewhere only at F = 1" replaced by "the only place the book uses the quantity is at F = 1 ... @sec-genomic-era writes the same formula for the crossing block without computing it, and the book computes it for no partially inbred generation". |
| 05b-M27 | fixed | Callout now reads "Three things stay true at every point on that sweep, all of them in expectation over the draw of the pools (the sweep itself is one draw per point)." The qualifier is stated once for the three items. |
| Info: test-dominance.R:160 | owed -> R/ tests | Comment/title "dominance deviations" for the multiset of d_k; quant-Rwrite or a later pass. Not touched here. |
| 05:326 | owed -> 05 | "$d_k$ the dominance / deviation at locus $k$" (line break inside the phrase; denotes d_k). Added to the owed d_k list: 04c:333, 04e:176, 05:326, 06:364, 06:479, 08b:136, 08b:767, 12:262, 90:210, 90:515, 90:605. 05b:141-146 now says so. |

## Checks
- `Rscript book/scripts/make_downloads.R`: all chapters ok; downloads for 00, 01, 02, 02b, 05b regenerated.
- Chapters touched (00, 01, 02, 02b, 05b) purled to a scratch directory and sourced with a `_common.R` copy forcing `pkgload::load_all` of the worktree, `pdf(NULL)`: all exit 0 (1.8, 1.7, 4.5, 3.3, 8.5 s); every stopifnot in 05b passes.
- No `book/Rplots.pdf`, no `book/figure/` in the worktree. Not committed, not rendered.
