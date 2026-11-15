# 11-plant-literature -- verdict, iteration 3

Chapter: book/11-plant-literature.qmd (720 lines) and appendix book/93-corpora.qmd (196 lines), read in full and knitted (knitr::knit, no error; every stopifnot in 11 passes). Read with it2-verdict.md, it2-response.md, the diffs of 90-notation.qmd, index.qmd, scripts/regenerate.R and references.bib. The knitted figure was opened and viewed. Chapters 10, 04e and 04g remain open: 11 imports no number from them.

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 11-D2 -- CLOSED -- fig-plant-landscape is now drawn in 93 (base R, from plant_metric_usage.csv and bibliography_plant.csv). Viewed: panel a title "Usage table (external)", x axis "records (of 687 screened)"; panel b title "Crop of the screened records", x axis "screened records (n = 687)", maize bar 197 (recomputed: 196 "maize" + 1 "popcorn (maize)" pooled by grepl("maize")); no "post-2018", no rank annotation; caption says 2017-2026 (plant range recomputed 2017-2026), external classification not recomputed, tie at rank 6 and effective size 12 of 12 (rank(-n_records, "min") = 1 2 3 4 5 6 6 8 9 10 11 12), and that "none" and empty labels are left out of panel b. 687 = 529 + 158 named once. Usage pct = records/687 within 0.051 (recomputed TRUE). Red outline on four categories as the caption says. Shortened axis labels are cosmetic and the caption names the categories.
- 11-D15 -- CLOSED -- the effective-size pattern no longer carries the bare token Ne. Recomputed on the shipped column: 1 record ("effective population size, genetic space"), 1 maize; usage table 17 (4 maize). Chunk asserts that no "effective alleles" record is matched. Inline ratios over the first four rows: 303/126, 117/54, 46/18, 46/12 = 2.2 to 3.8 (knit prints "2.2 to 3.8"). The text now states ROH 0 vs 22 and effective size 1 vs 17 explicitly. "Smaller counts in every row" holds for all seven rows (126/303, 54/117, 18/46, 12/46, 0/22, 1/17, 77/101).
- 11-D16 -- CLOSED -- the recommended-versus-descriptive contrast is gone. The mapping (alpha: inner quantity GD = 1 - theta = He to "Expected heterozygosity"; baseline-relative loss without category; theta only loosely to coancestry/kinship; N_e,par to effective size, a different quantity; A_ret to the merged richness category) is stated and labelled as the chapter's. Identity checked against 06:100-125 (theta_S = m^-1 sum(p^2 + q^2), GD = 1 - theta = He at the set's own frequencies, plug-in) and 07:937-943 (alpha definition). He row: usage table 101 (rank 3, 14.7 %), shipped column 77 (17 maize) by the chunk's pattern; the knit prints 77. Residual wording in 11-M15.
- 11-D17 -- CLOSED -- Wegary: the study's result is stated as in the abstract (Crossref: "Nearly 91% ... 30-36% of the scored alleles, but only 32% ... relative kinship coefficient <0.050, which suggests the presence of substantial redundancy ... repeated use of fewer genetic backgrounds"); the state-versus-relative disagreement is declared the chapter's inference, with the missing threshold and the authors' own reading stated; the 0.64-0.70 conversion is conditional on "scored alleles" meaning loci that differ. Consequence 9 says the same.
- 11-D18 -- CLOSED -- Arca: consequence 3 and the genebank bullet now report the abstract's finding (inbred lines derived from landraces with limited contributions enriched the haplotype diversity of the reference lines more than high-contribution ones) and state that no comparison with ranking by raw diversity is made; matches the Crossref abstract (10.1111/pbi.14022). Sanchez: bridging is "the recommendation of the abstract", declared unconfirmed against a direct-introduction arm and read as a hypothesis; the abstract (10.1073/pnas.2205780119) recommends bridging as managing the performance gap "efficiently" and names no direct-introduction arm, so the hedge is accurate.
- 11-M7 -- CLOSED -- @sec-plant-literature removed from the F_ST list in 90-notation.qmd:160; 11 uses F_BN for the parameter and F_ST for the statistic (Kadoumi, usage category).
- 11-M9 -- CLOSED -- the Kadoumi passage quotes the full text (Europe PMC PMC12397178: "its proportion of extreme-tail markers also increased by 20.76%, reaching 22.3% of SNPs in era 4"; extreme-tail defined there as P[MAF < 0.05]) and states that the abstract says LD increased ("marker fixation and linkage disequilibrium increased", confirmed) while claiming no SS-specific LD result.
- 11-M10 -- CLOSED -- "upper bound" replaced by "a count of annotation items, not a bound", with the reasons; recomputed 0.4920 / 0.4367 (49 % / 44 %) and, splitting also on "/" and " and ", 0.5429 / 0.5063 (54 % / 51 %), as printed.
- 11-M11 -- CLOSED -- "letters roh inside microhaplotypes" is correct; index.qmd and regenerate.R now call plant_metric_usage.csv an external classification not derivable from the bibliographies.
- 11-M12 -- CLOSED -- the four comments are in references.bib above yang2024, fritscheneto2023, mufumbo2022, huo2025.
- 11-M13 -- CLOSED -- the sentence before tbl-plant-unestablished states that rows 3 and 7 rest on @sec-cycles and @sec-programme and are conditional on them.
- 11-M14 -- CLOSED -- the callout no longer gives a cause ("why is not tested here").

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 11-M15 11:231-233 -- "what is rarely reported is the baseline-relative loss, the effective number of parents and (as far as the merged category allows) A_ret": for the first two the evidence is the absence of a category, which the following sentences and the abstract-screen caveat concede cannot show how often they are reported; for A_ret the merged category is rank 6 of 12 (6.7 %), which the same paragraph calls "in the middle". Scoped by "Under the mapping above" and by the next sentences, so not rejecting.
- 11-M16 11:177-179, 11:184-189, 93:73 and 93:172 -- prose clarity: (a) a revision-history remark ("the effective-size pattern in the previous version ...") sits in the chapter text; (b) "the ROH query printed in @sec-corpora returns one record only when ..." describes a variant the printed (anchored) query is not, and the printed query returns 0; (c) 93 says the corpora are "deliberately post-2017" while the plant file holds one 2017 record (animal file starts 2018).

Two non-disqualifying observations are open; the rule rejects at three. Other readings I considered and did not record: "the authors read both as redundancy" (abstract: "which suggests", anaphoric to both clauses) and "distant on the state scale" in consequence 9 (the chapter's characterisation, with the conditional stated earlier in the text).

WHAT WAS VERIFIED
- Knit of 11 and 93 -- knitr::knit into the scratchpad, cwd book/: both OK, all stopifnots pass. (Knitting created book/figure/; my two files were removed, two pre-existing files from other sessions were left.)
- Figure -- viewed fig-plant-landscape-1.png: values 303, 117, 101, 97, 83, 46, 46, 38, 37, 34, 22, 17; maize 197; crop bars 197, 42, 39, 33, 22, 19, 16, 13, 13, 10 (recomputed from the CSV; "none" 24 excluded).
- Usage table and column -- Rscript on book/data: n 687, relevance 529/158, years 2017-2026, maize 197; column counts structure 126 (32), F_ST 54 (11), richness 18 (3), coancestry 12 (7), ROH 0 (0), effective size 1 (1), He 77 (17); usage table 303/87, 117/36, 46/6, 46/22, 22/5, 17/4, He 101/23.
- Items with three or more -- 0.4920, 0.4367; with "/" and " and ": 0.5429, 0.5063.
- AlphaMate -- 58 citations, rank 9 of 324 (knit output).
- Kadoumi -- Europe PMC full text: extreme-tail passage and abstract LD sentence confirmed.
- Wegary, Arca, Sanchez -- Crossref abstracts read against the chapter's wording.
- Landscape PNG -- no reference in book/*.qmd, book/downloads, book/scripts or any tracked file outside docs/ and _freeze/; git status shows book/figs/plant_lit_landscape.png as staged deletion.
- 90-notation, index.qmd, regenerate.R, references.bib diffs read; the edits are as described. (The other hunks in 90-notation.qmd and regenerate.R belong to 04e/04g work, not judged here.)

NOT VERIFIED
- docs/ and book/_freeze/93-corpora: still hold the old render (docs/93-corpora.html:846 and docs/index.html:798 reference plant_lit_landscape.png); a render is pending and is not a content matter. Not run.
- "2004 records across 29 queries" (93:27-28): unchanged text, external provenance, not checkable here; not decisive.
- Wegary "scored alleles" meaning (full text not read; declared as a condition by the chapter).
- it2-response.md says the column has 69 He records; the chapter and my recomputation give 77. The text is correct (inline code); the response is wrong.
