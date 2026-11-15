# 11-plant-literature -- response to editor.md (11-E1..E11) and it3-verdict.md (M15, M16)

Files edited: book/11-plant-literature.qmd, book/93-corpora.qmd. No result changed. Knit of both (knitr::knit, scratchpad): no error, every stopifnot passes, including the two new ones (unanchored "roh" = 1 record, the microhaplotype one; anchored ROH = 0). make_downloads.R re-run. No render.

| ID | Status | Note |
|---|---|---|
| 11-E1 / M15 | fixed | rarity claim removed; see wording list |
| 11-E2 / M16a | fixed | revision-history sentence replaced by the pattern's definition, with computed counts |
| 11-E3 / M16b | fixed | the sentence now describes the printed query (0 records) and, separately, the unanchored variant (1 record); both computed |
| 11-E4 | fixed | every positional "below"/"above" that referred to text replaced; left: 11:26 (code comment, reworded), numeric uses ("below 0.050", "stay below", "above 0.050") |
| 11-E5 / M16c | fixed | caption and "Classical references" computed from the CSVs: plant file starts 2017 with 1 record, mainly 2018 onward; animal file 2018 |
| 11-E6 | contested in part | N_C: symbol dropped ("census size"), not added to 90. F_drift/F_hom: 90-notation.qmd is already the book's majority form (F_{drift} 53 occurrences in 8 files, F_{hom} 53 in 7; the \text{} form 9 in 4 files, 2 for F_hom, all in 09, 10, 11, 11b). Aligned the other way, minimally: the 2 occurrences in 11 changed to the form of 90. 09, 10 and 11b are outside this task and keep \text{} until their writers decide. |
| 11-E7 | fixed | 11 uses "optimal cross selection" for @gorjanc2018 in both places (the source's term, 09:199); OCS is defined once, at its first use in 11 (matrix-choice section), as optimal-contribution selection (@sec-ocs) |
| 11-E8 | contested (not done) | Crossref bibliographic queries returned no record of Wright (1978), the book (only reviews of it: 10.1126/science.207.4427.173, 10.2307/2529965, 10.1016/0047-2484(80)90079-2) nor of Schnell & Utz (1975) (unrelated hits). No verified metadata, so no bib entry added; the entries stay hand-typed and 93 says so after the table. |
| 11-E9 | fixed | maize in book_pal[["mid"]] (dark grey) against book_pal[["light"]], in both panels and the legend; fig-alt updated. Width 9 kept, as the editor tested. The Typst scaling (0.72) is a render-batch check, not done. |
| 11-E10 | fixed | ylab "records per year" on both panels, las = 2 so every year is labelled, caption states the two panels do not share a vertical scale. Typst size not checked. |
| 11-E11 | fixed | names(pl) inline; the two table() calls are tbl-corpora-relevance; sort(table(th)) is tbl-corpora-themes. |

## Evidence worth knowing
- The earlier sentence said the bare token "Ne" "hit three records of 'effective alleles (Ne)'". On the shipped column the string "effective alleles" is in 7 records, "(Ne)" in 2, and a case-insensitive word-bounded "Ne" in 0. The "three" was not reproducible; the sentence now prints the computed 7 and 2 (inline code). This is a correction of a number, not only of wording.
- Crossref used for E8 on 2026-11-14; absence of a Crossref record is not evidence the works do not exist.

## Prose and caption wording changes

book/11-plant-literature.qmd
- Heading of the usage paragraph: "The quantity inside $\alpha$ is among the most reported, the others are not." -> "... is among the most reported; the other recommended metrics are not identified as categories of the screen."
- The sentence "Under the mapping of @sec-plant-qualification, then, what is rarely reported is the baseline-relative loss, the effective number of parents and (as far as the merged category allows) $A_{ret}$, not gene diversity itself." -> "..., then, gene diversity itself has a category, and the baseline-relative loss and the effective number of parents are not identified as categories in the screen; $A_{ret}$ maps only to the merged richness category, in the middle by record count. The absence of a category is not a measure of how often the papers report a quantity, which a screen of abstracts does not show." (the following sentence "No category of the table corresponds to ..." unchanged.)
- "The effective-size pattern in the previous version also matched the bare token "Ne", which hit three records of "effective alleles (Ne)", a per-locus allele count and not an effective population size; it was removed." -> "The effective-size pattern does not contain the bare token "Ne": the shipped column lists "effective alleles" in `r n_ea` records (`r n_ne` of them as "(Ne)"), a per-locus allele count and not an effective population size, and the chunk of @tbl-plant-usage-check asserts that none of them is matched."
- "The ROH query printed in @sec-corpora returns one record only when "ROH" is matched case-insensitively inside a word: it then matches the letters "roh" inside the word "microhaplotypes", in an alfalfa record. Anchored as a word, as above, it returns none." -> "The ROH query printed in @sec-corpora is the pattern of @tbl-plant-usage-check, anchored as a word, and returns `r chk[5, 4]` records. Unanchored, a case-insensitive "roh" returns `r n_roh_loose` record, which matches the letters "roh" inside the word "microhaplotypes", in an alfalfa record."
- "The corpus below was screened" -> "The corpus (@sec-plant-corpus) was screened".
- "Each number below says which file it comes from." -> "Each number in this chapter says which file it comes from."
- ""in the animal file" below therefore describe" -> ""in the animal file" in this chapter therefore describe".
- "The study-level numbers below are read" -> "The study-level numbers of this chapter are read".
- "Allelic richness is used below in four senses" -> "... is used in this chapter in four senses".
- "The mapping below from the recommended metrics to the table's categories is this chapter's" -> "The mapping of the recommended metrics to the table's categories, given in this section, is this chapter's".
- "The tasks above are haplotype stacking and introgression" -> "The tasks of the records in this section are haplotype stacking and introgression".
- "the reduction of the census size $N_C$" -> "the reduction of the census size" (symbol dropped).
- $F_{\text{drift}}$ and $F_{\text{hom}}$ (2 places) -> $F_{drift}$ and $F_{hom}$.
- "@gorjanc2018 (animal file) simulates optimal-contribution selection (OCS, @sec-ocs) under rapid recurrent genomic selection" -> "simulates optimal cross selection under rapid recurrent genomic selection" (the editor's earlier insertion removed).
- "the optimal-contribution or optimal-cross framework is common ground" -> "the optimal-contribution selection (OCS, @sec-ocs) or optimal-cross framework is common ground" (OCS defined here, its first use).
- Code comment: "records said below to sit in the other species' file" -> "records said in the text to ...".

book/93-corpora.qmd
- Structure: "The columns that carry the screening annotation are described in @tbl-corpora-columns; the full list of columns of the plant file is printed first." + console output of names(pl) -> "The plant file has the columns `...` (inline). The ones that carry the screening annotation are described in @tbl-corpora-columns."
- Relevance and coverage: two table() console outputs -> tbl-corpora-relevance (caption: "Number of screened records by relevance score (3 = directly relevant, 2 = related background) in each file.").
- Themes: console sort(table(th)) -> tbl-corpora-themes (caption: "Themes of the directly relevant records (relevance 3) of `bibliography_animal.csv`, after splitting the semicolon-separated `theme` field; a record with several themes is counted once in each.").
- fig-corpora-years caption: "... each bar is a count of records, with no uncertainty. Both corpora are deliberately post-2017." -> "... with no uncertainty, and the two panels do not share a vertical scale. The plant file starts in 2017 with 1 record and is mainly from 2018 onward; the animal file starts in 2018." (years and count computed by `!expr` in the chunk option).
- fig-plant-landscape fig-alt: "maize (blue) and other crops (grey)" -> "maize (dark grey) and other crops (light grey)".
- Classical references: "The corpora are deliberately post-2017. The classical results the book rests on are cited from the source literature, and collected in `book/references.bib`:" -> "The plant file starts in 2017 (one record; mainly 2018 onward) and the animal file in 2018, so the corpora leave out classical work by construction. The classical results the book rests on are cited from the source literature, and collected in `book/references.bib` with two exceptions stated after the table:" (years computed inline).
- New paragraph after tbl-corpora-classical: Wright (1978) and Schnell & Utz (1975) are not in references.bib, given by author and year only; a Crossref query returned no record of either work (for Wright, only reviews), so neither was checked against a source record.
