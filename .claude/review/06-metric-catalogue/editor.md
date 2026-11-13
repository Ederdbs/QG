# 06-metric-catalogue -- editor report (quant-editor)

File: book/06-metric-catalogue.qmd. No figure chunks. Nothing rendered. Content and numbers untouched; chunk code untouched (options and captions only). Skipped: 00-E1, 00-E2, 00-E8.

## 1. Edits applied (APPLIED)

Tables
- 06-E1 APPLIED: chunk `gdbs-concentration` (the concentration table) was an unnumbered table. Now `#| label: tbl-catalogue-gdbs-conc` with a stand-alone `tbl-cap` (what k_A, k_B are, 300 draws, seed 5, s_e definition, scale, units, decimals); cited before it ("@tbl-catalogue-gdbs-conc compares the three sources").
- 06-E2 APPLIED: chunk `lambda-d-check` printed an unnumbered table. Now `#| label: tbl-catalogue-lambda-d` with `tbl-cap` (columns, flat vs gamma d_k seed 8, relative_error rounds to 0 at 4 decimals, assertions); cited before it ("it (@tbl-catalogue-lambda-d)").
- 06-E3 APPLIED (M23): caption of tbl-catalogue-z no longer says "the Monte Carlo error of each z is given in the text"; it now says the text gives it for the truncation z on GD and F_drift plus the relative error that applies to each z.
- Citation-before-appearance checked for all 14 tables: all cited before their chunk.

Equations
- 06-E4 APPLIED: @eq-catalogue-theta-pools used w_A, w_B undefined. Added "with w_A and w_B the usage weights of the pool-A and pool-B lines, each rescaled to sum to 1 within its pool (`line_weights()`, @sec-notation)" (matches 90-notation row). Terminal period of the display became a comma.

Text and citations
- 06-E5 APPLIED: SNP expanded at first use (qmd ~328).
- 06-E6 APPLIED: citation syntax at the Group coancestry opening: "(@caballero2002, p. 290, averages ... and cites @cockerham1967 ...)" produced nested parentheses; now "@caballero2002 [p. 290] average ... and cite @cockerham1967 (Cockerham's own text was not checked here)". Same for "[@nei1973; D_G is the symbol of @lopezcortegano2019 ...]" (narrative inside a bracket) -> "[@nei1973] (D_G is the symbol of @lopezcortegano2019 ...)". Wording otherwise unchanged.
- 06-E7 APPLIED: "the algebra above" (concentration Interpretation) -> "the algebra of @sec-era-step6".

Checked, no change: callouts (2; warning for N_s, note for global theta; types match function, both titled), headings (sentence case), units ("5 %", "30 s" style), acronyms (MAF, E-NE, A-NE defined; DE/OCS/GCA not used here), no footnotes, all chunk labels present, no `caution` callouts.

C18 (the repeated five-selection caption block): decision KEEP. quant-editor.md:31 says "the caption stands alone ... and the simulation scale or data source". Each of the 11 table captions must therefore state the scale and what the five selections are; the block cannot be moved to the text. Not shortened (shortening would drop the definition of trunc_cap / greedy_w / greedy_div, which only the captions give). If the author wants it shorter, the alternative is a numbered key table (tbl) cited from each caption; that is a restructure, owed to quant-writer, not applied.

## 2. Findings passed on (NEEDS quant-writer / quant-Rwrite)

- 06-E8 (quant-Rwrite) qmd:124-130, 160-163, 187-194, 758-769, 796-809, 838-843: raw R console output (named vectors, list) stands in for results in six unlabelled chunks (theta identity, matrix-vs-frequency timing, the two N_s edge cases, bias predicted/observed/mc_se, GD_population/GD_ref/gap_se, attainable alpha). Checklist 2: not allowed as results. Fix needs code (wrap in `fmt(data.frame(...))` with tbl- label), outside my remit. Several are cited by number in the text (gap_se, 0.680 %, predicted bias).
- 06-E9 (quant-Rwrite) qmd:301 `tbl-catalogue-alleles-lost`: `data.frame(...)` not passed through `fmt()`. Integer counts, so the output is identical; consistency only.
- 06-E10 (quant-writer / quant-refcheck) qmd:333, 651: Fernandez et al. (2004) and Bennewitz and Meuwissen (2006) are hand-typed in text (second-hand, flagged not read); no key in references.bib (only fernandezgonzalez2023/2026, a different author). Cannot convert to `@key` without an entry. Same as 06-M22.
- 06-E11 (quant-writer) qmd:603 "stated above" and 316 "the result of @lopezcortegano2019 below": relative pointers. H_T = H_S + D_G has no label; giving it one (or restating it) would remove "stated above". Low priority.
- 06-E12 (quant-writer) qmd:561-566 (06-M20): "Most of the rise" depends on the matching rule (k_A, k_B rounded up); the alternatives looked at (10 x 23: 0.27, 7 x 17: 0.49 in the verdict) are not in the text. Content, not form; already in the approved verdict as non-blocking.
- 06-E13 (info) book/downloads/06-metric-catalogue.R is stale after these edits (new chunk labels, caption options); regenerate with `Rscript book/scripts/make_downloads.R` before rendering. I did not run it (it rewrites every chapter script).

## 3. Orphaned figure files

None. No figure chunks; the two renamed chunks (gdbs-concentration, lambda-d-check) produce tables only, no PNG. No other file references the old labels (the `_freeze/06-metric-catalogue` html.json/typ.json will be regenerated on the next render because the source changed).
