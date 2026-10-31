# 00-hybrid-programme -- iteration 1 response (D, M, B items + 00-R1 prose)

Files touched: book/00-hybrid-programme.qmd, book/11-plant-literature.qmd (one
citation key), book/references.bib, regenerated book/downloads/ and the HTML
freeze/docs for chapter 00 (single-chapter `--to html` render; the `typ.json`
freeze is now stale and needs the full render after the R* pass). Numbers below
come from `knitr::purl()` of the edited chapter run under
`pkgload::load_all("..")`.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 00-R1 | fixed (prose) | Interpretation after @eq-hp-ibs-ibd now reads: molecular coancestry is the floor `m^-1 sum_k (p0^2 + q0^2)` plus the pedigree coancestry `A/2` scaled by one minus the floor, "not plus the pedigree coancestry itself"; full sibs exceed unrelated pairs by one quarter of one minus the floor, printed inline as `ibs[["full_sib_expected"]] - ibs[["unrelated_expected"]]` = 0.0912, "not by 1/4". No new symbol (`b` was avoided: it already names a line). |
| 00-D1 | fixed | Sentence replaced: allele number in a subset can stay or fall, never rise; gene diversity of a *random* subset is lower in expectation by `(1/n_sel - 1/N)(fbar_d - fbar_o)` (formula and symbols of @sec-baseline); a *selected* subset carries no guarantee and one selected for diversity can exceed the pool. New labelled chunk `hp-subset-gd` (seed 5 immediately before the draw) asserts both with `stopifnot()`: random mean within 3 s.e. of the expectation, and `sel_greedy(w = 0)` subset > pool. Output: pool 0.3281, random-20 mean 0.3209 (s.e. 0.0001), expected 0.3210, random max 0.3251, diversity-greedy 0.3296. Result/Interpretation separated; interpretation ties it to why alpha uses the random-subset reference, scope "one pool pair, one subset size, one seed". The S2/S4 sentence that followed is unchanged. |
| 00-M1 | fixed | Interpretation now conditional: "Under dominance ... GCA is then a property of a line against a tester pool, not of the line alone; with d_k = 0 it would not depend on the testers." |
| 00-M2 | fixed | Result says "the dominance parts of the GCA"; caveat adds "the dominance part alone (a_k = 0)" and states that the additive part is common to both halves and, with additive effects independent of the dominance deviations, pulls the correlation towards 1, so the case shown maximises the disagreement. (`r sum(half)` left as is: 00-R3 belongs to the R pass.) |
| 00-M3 | fixed | "N_e is a rate" -> "N_e is a size defined by a rate, N_e = 1/(2 Delta F) in @eq-hp-drift, and so projects drift forward." |
| 00-B1 | fixed | "read through the partition into general and specific combining ability defined by @sprague1942, written as a linear model for a factorial between two sets of lines (the North Carolina Design II of @comstock1948; the notation g, s is that of @griffing1956)". Same division of credit as 04e-mating-design.qmd:154-157. |
| 00-B2 | fixed | `sprague1942`: added `doi = {10.2134/agronj1942.00021962003400100008x}` (Crossref: Sprague, Tatum, vol 34(10), 923-932, 1942). |
| 00-B3 | fixed | `wright1922`: added `doi = {10.1086/279872}` (Crossref: Wright, Am Nat 56(645), 330-338, 1922). |
| 00-B4 | fixed (no action) | No defect reported; bib unchanged. |
| 00-B5 | fixed | "...are IBD, the definition of @malecot1948; @wright1922 introduced it as the correlation between uniting gametes." |
| 00-B6 | contested (no change) | Not a defect: refcheck marks it UNVERIFIED (paywalled), judge marks NOT REQUIRED. The chapter's identity @eq-hp-gd is verified numerically (`stopifnot` in `hp-heterozygosity`) independently of the attribution; the diagonal-included convention is stated explicitly in the text and does not rest on the citation. I could not reach the full text either. |
| 00-B7 | fixed | Lines 209-212 now cite primary sources: @kadoumi2025 (TAG 138(9):233, doi 10.1007/s00122-025-05008-5; abstract: "Differentiation between Stiff Stalk and Non-Stiff Stalk heterotic groups increased significantly over time, while genetic diversity within both groups declined", 40 years, private European dent programme) and @vanheerwaarden2012 (PNAS 109(31):12420-12425, doi 10.1073/pnas.1209275109; abstract: "steady increase in genetic differentiation ... associated with increasing genetic separation of breeding pools"; also "selection has had limited impact on genome-wide patterns", which the sentence reports so the mechanism is not over-attributed). Metadata of both verified against Crossref; abstracts via Europe PMC (PMIDs 40883612, 22802642). `kadoumi2025` existed in the bib with a WRONG author list (Combes, Mary-Huard in place of Murigneux, Berton; order wrong) -- corrected to Crossref, issue 9 added; it is also cited in 04f-sparse-testing.qmd:759, unaffected in content. `vanheerwaarden2012` added. book/11-plant-literature.qmd:136-137: `[@kadoumi2025]` appended to the bold claim (its source, traced through reference/diversity_metrics/bibliography_plant.csv); no other change. |

## R pass (00-R2..R7)

Chapter knitted end to end (`knitr::knit` + `pkgload::load_all("..")`, `error = FALSE`): every `stopifnot` passes, no errors; inline values checked in the knitted md. `book/downloads/00-hybrid-programme.R` regenerated with `make_downloads.R`. Not rendered: html/typ freeze and `docs/` for 00 are stale until the full render. No chunk added or relabelled; no figures orphaned.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 00-R2 | fixed | Prose before `hp-ibs-ibd` now says: each replicate draws two parents in HW proportions from the base, breeds two full sibs from them, and uses the two parents themselves as the unrelated pair -- matches `rbind(mo, fa)`. |
| 00-R3 | fixed | Result: "first half of pool B (`r sum(half)` lines; the second has `r sum(!half)`)" -> 12 / 13; caveat: "testers of `r sum(half)` and `r sum(!half)` lines". |
| 00-R4 | fixed | Chunk computes `gca_err <- max(abs(g1 - (rowMeans(H1) - mean(H1))))` and asserts `gca_err < 1e-10` (replaces `all.equal`, tolerance 1.5e-8); Result says "to within `r signif(gca_err, 1)`" -> 4e-13. Claim and check now agree. |
| 00-R5 | fixed | Result: "heterozygous at no locus, by construction (A2: they are coded 0/1; the assertion guards the coding, it measures nothing)"; the `stopifnot` line carries the comment `# coding guard: GL is 0/1 by construction (A2)`. |
| 00-R6 | fixed | :30 -> `` `r book_cfg[["n_pool_A"]]` + `r book_cfg[["n_pool_B"]]` lines, `r book_cfg[["m"]]` markers ``; "the same 25 pool-A lines" -> `` `r sum(pool == "A")` ``; IBS paragraph drops the typed sizes, chunk gains `p0_lim <- c(0.05, 0.95)` (same `runif` draw, numbers unchanged: 0.7264/0.6352), Result states `` `r n_pair` `` replicates, `` `r m_ibs` `` loci, `U(`r p0_lim[1]`, `r p0_lim[2]`)`; drift paragraph drops "20,000", Result states `` `r format(m_dr, big.mark = ",")` `` loci. |
| 00-R7 | fixed | `order(-g1)[seq_len(5)]`, `order(-g2)[seq_len(5)]`. |

## Editor pass (00-E1..E5)

Chapter purled and run end to end under `pkgload::load_all("..")` (all `stopifnot` pass; printed values unchanged: e.g. GCA correlation 0.8587, drift 0.5997/0.3496). `book/downloads/` regenerated. Not rendered; html/typ freeze and `docs/` for 00 and 90 stale until the full render. No chunk added or relabelled; `fig-hp-cycle` keeps its label, so no figure is orphaned.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 00-E1 | fixed | All seven chunks (hp-data, hp-gca-tester, hp-subset-gd, hp-heterozygosity, hp-ibs-ibd, hp-f-hybrid, hp-drift) are verification chunks whose every number is reported inline in the prose; each printed line is now preceded by `# verification echo: the text reports these values; not a results table`. Not converted to `tbl-` tables: that would need relabelling the chunks (`tbl-` prefix) and would duplicate numbers already in the Result sentences. |
| 00-E2 | fixed | "Where diversity is lost" now defines in place: "expected group coancestry $\theta_S$ (the mean of all pairwise coancestries in the set, diagonal included; defined in @sec-hp-popgen)" and "expected gene diversity $GD_S = 1 - \theta_S$ (@eq-hp-gd)", before the Result sentence uses $GD$. |
| 00-E3 | fixed | "the diversity loss $\alpha = (GD_{\text{ref}} - GD_S)/GD_{\text{ref}}$, the quantity the budget $\alpha_{\max}$ bounds, is measured against $GD_{\text{ref}}$, the gene diversity of a random subset of the same size (@sec-baseline)" -- same definition as the $\alpha$ row of 90-notation's selection table. |
| 00-E4 | fixed | book/90-notation.qmd: Coancestry table gains $\bar f_d$, $\bar f_o$ (diagonal / off-diagonal means of $\mathbf{f}$; $\theta_S = \bar f_d/n + (n-1)\bar f_o/n$, @sec-catalogue) and $F_{(ab)}$ (molecular $F$ of the single cross, $= f^L_{ab}$ for inbred parents, @sec-hp-popgen); Heterosis table gains $a_k$ (additive effect, @sec-mating-estimation) and $\delta u_{ik}$, $\delta v_{jk}$ (centred 0/1 genotypes $u_{ik} - p_{Ak}$, $v_{jk} - p_{Bk}$, as in 04e:180). Vector lengths of each `data.frame` kept equal (one row per symbol; 90-notation purled and run without error). |
| 00-E5 | fixed | Recycling arrows: dashed shafts drawn with `segments(lty = 2)` down to 1.2 units short of the S1 box, then a solid `arr()` (default `lty = 1`) for the last 1.2 units carrying the head. Label `fig-hp-cycle` unchanged. Checked on a PNG at 6.5 x 4.4 in: both heads solid, no stray dot. |
