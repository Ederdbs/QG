VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 11-M15 -- CLOSED -- 11:237-242 no longer says "rarely reported"; it says that gene diversity has a category, that the baseline-relative loss and the effective number of parents are not identified as categories, that A_ret maps to the merged richness category (rank 6 of 12, "in the middle by record count"), and that the absence of a category is not a measure of how often papers report a quantity. The bold lead sentence (11:226) says "not identified as categories of the screen". Consistent with the mapping at 11:108-118.
- 11-M16 -- CLOSED -- (a) the "previous version" remark is gone (grep: no match); the pattern is defined with computed counts (11:182-185). (b) the sentence now describes the printed anchored query (0) and, separately, the unanchored variant (1). (c) 93 no longer says "deliberately post-2017"; the caption and "Classical references" state 2017 (1 record) and 2018.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 11-M17 11:604 -- notation: `$F_{\text{drift}}$` remains in 11, while 11:94 and 11:603 now use `$F_{drift}$` (the form of 90-notation.qmd:266,273). The writer's table says the occurrences in 11 were aligned; one is left. Same symbol, no change of meaning; mixed form within one chapter.
- 11-M18 11:179, 11:187-188, 11:191-192, 11:680; 11:237-244 -- redundancy: "0 ROH records" is stated three times in consecutive paragraphs, and after the M15 rewrite the "no category" statement is made twice (237-240, then 242-244 "No category of the table corresponds to ...").
Two non-disqualifying observations; the rule rejects at three.

WHAT WAS VERIFIED
- Knit of 11 and 93 (knitr::knit, base.dir in scratchpad, cwd book/) -- both OK, every stopifnot passes, including the two new ones (n_roh_loose == 1 with "microhaplotypes"; anchored ROH == 0) and the rank/pct/DOI ones. Nothing left in the worktree by my knit (no book/Rplots.pdf; book/figure/ holds only the two fig-joint-* files from other sessions).
- E2 -- Rscript on book/data/bibliography_plant.csv: "effective alleles" (ci) 7 records; "(Ne)" fixed 2, both inside records that carry "effective alleles"; word-bounded Ne, case-insensitive 0 and case-sensitive 0; effective-size pattern matches 1 record, none containing "effective alleles". Knit prints 7 and 2. The "three" is gone.
- E3 -- anchored ROH pattern 0 records; case-insensitive "roh" 1 record, "genetic diversity, differentiation (microhaplotypes, SNPs)", crop alfalfa. The text matches; the ROH query printed in 93 uses the same pattern as tbl-plant-usage-check (identical regex, checked by reading).
- E5 -- table(year): plant 2017 = 1, 2018 = 22, 2019 = 31 ... 2025 = 180, 2026 = 179; animal 2018 = 4 ... 2025 = 82, 2026 = 119. Caption and "Classical references" are computed inline from the CSV; "mainly from 2018 onward" holds (min year above 2017 is 2018).
- E6 -- grep of the book: F_{drift}/F_{hom} form of 90 is the majority outside 11; `\text{}` form remains in 09, 10, 11b (outside this task) and once in 11 (M17). N_C: no occurrence left in any chapter; "census size" without symbol at 11:584. 90-notation does not define it, so nothing to align.
- E7 -- 11:423 and 461 use "optimal cross selection" for @gorjanc2018 (source's title term; 09:14 and 09:199 use optimal-contribution selection for the book's OCS and cite gorjanc2018 for the name only). OCS defined once in 11, at 547 (first use of the abbreviation; grep), as optimal-contribution selection (@sec-ocs). Animal file note for gorjanc2018 read in the CSV.
- E8 -- 93:218-221 states that Wright (1978) and Schnell & Utz (1975) are not in references.bib and were not checked against a source record. Crossref queries I ran (2026-11-14): the Wright query returns only reviews of the book (10.2307/2529965, 10.1016/0047-2484(80)90079-2, 10.1126/science.207.4427.173); the Schnell & Utz query returns unrelated items. Matches the writer's statement. Absence from Crossref is not evidence that the works do not exist, and the text does not claim it is.
- E9/E10 -- knitted fig-plant-landscape viewed: left panel maize dark grey (book_pal mid = grey45) over light grey, red outlines on four categories (expected heterozygosity, marker coancestry, allelic richness, effective size), top bar population structure 303, bottom effective size 17, x label "records (of 687 screened)"; right panel maize 197, wheat 42, multi-crop 39, rice 33, x label "screened records (n = 687)". Alt and caption agree with what is drawn. fig-corpora-years viewed: ylab "records per year" on both panels, every year labelled, plant 1 in 2017 and 180/179 in 2025/2026, animal 4 in 2018 and 82/119 in 2025/2026, vertical scales differ (0-150 vs 0-119) as the caption says; alt agrees.
- E11 -- knitted tbl-corpora-relevance (plant 529/158, animal 235/89; plant matches the 687 and 158 of the text) and tbl-corpora-themes (7 themes, sum 218 over the 89 relevance-3 records, the code splits on ";" among relevance 3 as the caption says). tbl-corpora-crops: includes "none" (7) and "none (general crop)" (4); its caption does not claim to exclude them.
- Cross-references -- every @sec-/@tbl-/@fig-/@eq- in 11 and 93 (44 distinct) has a definition in a .qmd of book/ (Rscript over all chapters: no missing). Every citation key used in 11 exists in references.bib.
- Downloads -- purl of 11 and 93 compared with book/downloads/11-plant-literature.R and 93-corpora.R: identical code except the standalone header (library(hybdiv), set.seed).

NOT VERIFIED
- Source attribution of "modified Rogers distance" to Wright (1978) and "usefulness criterion" to Schnell & Utz (1975) in 93's classical table -- no record in references.bib, no source record found by Crossref; the appendix declares it. Not decisive: no claim in 11 depends on the table, and 11 cites neither work. Verification would need the books themselves.
- "2004 records across 29 queries" (93:31-32) -- external provenance, unchanged text.
- Typst layout of fig-plant-landscape (scale 0.72), tbl-plant-usage-check headers and tbl-plant-unestablished page break -- no render run (the task said not to); a form matter.
- docs/ and book/_freeze/ for 11 and 93 hold the earlier render; a render is pending and does not bear on content.
