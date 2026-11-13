# 06-metric-catalogue -- iteration 3 verdict (head of department)

Scope: form pass (editor.md, editor-response.md) and the M20-M23 edits. Chapter purled and run end to end with the worktree package (pkgload::load_all): DONE in 31.5 s, every stopifnot passes (scratchpad/it3/run.R).

VERDICT: APPROVED

## PREVIOUS IDS
- 06-M20 -- CLOSED -- chunk gdbs-matching run (seed 5, 300 draws): shares 0.8064 (5 x 12), 0.4935 (7 x 17, floor of the mean of (5,12) and (10,23) = (7,17)), 0.2720 (10 x 23, distinct lines). Text gives 81 %, 49 %, 27 %. Ne_lines of truncation 4.49 and 11.84. The reading (share falls as the control uses more lines; equal usage over 10 x 23 is far less concentrated than truncation's usage, so a less matched control, not a counter-result; the right control not settled; one draw, one subset size, remainder not isolated) matches the numbers.
- 06-M21 -- CLOSED -- rho = 0.9321 (rho^2 = 0.869) recomputed from the csv; "strong but short of a monotone relation".
- 06-M22 -- CLOSED (Fernandez) / contested item accepted (Bennewitz) -- see below.
- 06-M23 -- CLOSED -- caption of tbl-catalogue-z now says what the text gives (s.e. of truncation z on GD and F_drift, relative error for each).
- Contested C18 (repeated five-selection caption block) -- ruling: KEPT. A form rule owned by quant-editor; the block is consistent with the text and with the stopifnot in the chunks (n = 60, N = 625, 25 + 25 lines, 2000 markers, seed 1, line cap 4). Not a content failure.
- Contested Bennewitz & Meuwissen (2006) left second-hand -- ruling: ACCEPTED. The text names author and year, says "as reported there; that paper was not read here", and the attribution (lambda = 0.5 "suggested to maximize the total genetic variance of a hypothetical quantitative trait") is word for word the sentence of Lopez-Cortegano 2019 (lc.txt l. 192-194). Source named, second-hand status declared. Proceedings paper without DOI; bibliographic form belongs to quant-refcheck.
- 06-E8..E13 (form findings passed to the author) -- closed as below.

## DISQUALIFYING FAILURES
None.

## NON-DISQUALIFYING OBSERVATIONS
- 06-M24 qmd:609-611 -- the Interpretation says "which of the three rules is the right control was not settled" and in the next sentence calls the first rule "the matched rule" and says most of the rise is the usage-concentration effect under it. The matching is by effective number of lines, which the chunk justifies, so it is not false; but the flat "most of the rise" rests on one of three rules (81 % vs 49 % vs 27 %). Loose, not a failure.
- 06-M25 qmd:699 -- Bennewitz and Meuwissen (2006) has no references.bib entry (plain text, second-hand, declared). Owed to quant-refcheck.
- 06-M26 qmd:194-201 -- tbl-catalogue-ns-edge prints the data frame without fmt(); form only.
- Three or more accumulated? No: these are one wording point, one bibliographic point and one form point, none of substance.

## WHAT WAS VERIFIED
- gdbs-matching: Rscript scratchpad/it3/run.R: kA,kB = 5,12; dist = 10,23; mid = 7,17; shares 0.8063967 / 0.4934857 / 0.2719857; the chunk's own stopifnot (share_k(c(kA,kB)) == conc_share) passes.
- rho: 0.9321064 (alleles_lost_MAF), -0.9251170, -0.9669946; rho^2 0.8688.
- Six console-to-table conversions carry the same values as in it2: identity difference 0 ("exactly 0" branch), theta/Ns bounds 0.5/1 and 1/0.5; bias predicted 2.222e-3, observed 2.277e-3, mc_se 4.12e-5 (it2: 2.222e-3, 2.277e-3, 4.1e-5); GD_population 0.32809, GD_ref 0.32586, sd 7.58e-4, gap_se 1.70e-5, apparent loss 0.680 % (it2: gap_se 1.7e-5, 0.680 %); attainable alpha 0.04128766 = 4.129 % (it2: 0.04128766). Timing table: one unreplicated run (matrix 10.9 us, frequency 197 us on this machine), declared as such in the caption; no number in the text depends on it.
- tbl-catalogue-alleles-lost via fmt(., 0): counts are integers; round(x, 0) of an integer count changes nothing (fmt body read in book/_common.R).
- fernandez2004: Crossref for DOI 10.1111/j.1523-1739.2004.00341.x gives Fernandez J., Toro M.A., Caballero A., Conservation Biology 18(5):1358-1367, 2004, title "Managing Individuals' Contributions to Maximize the Allelic Diversity Maintained in Small, Conserved Populations": identical to the bib entry (also identical to the reference list of Lopez-Cortegano 2019, lc.txt l. 483-486). Crossref abstract: GD-maximising strategies keep allelic diversity as high as AD-maximising ones; consistent with the text. The detailed mechanism (alleles toward intermediate frequencies, chance of loss by drift reduced, allele-count method keeps some rare alleles at low frequency, more likely eventually lost) is in Lopez-Cortegano 2019 p. 2 (lc.txt l. 115-136) and p. 7; the text says "it cites @fernandez2004, as reported there", i.e. through that paper. Accurate.
- Labels: every @sec-/@tbl-/@eq- in the chapter has a definition somewhere in book/*.qmd (script scratchpad/it3/lab.sh: no MISSING); every @key with a year has an entry in references.bib (no NOBIB). The new tables tbl-catalogue-identity/-timing/-ns-edge/-bias/-gd-baseline are cited before their chunk. "stated above" and "below" for lopezcortegano2019 replaced by @sec-richness / restated formula.
- book/downloads/06-metric-catalogue.R regenerated (contains gdbs-matching).

## NOT VERIFIED
- Fernandez et al. 2004 and Bennewitz & Meuwissen 2006 read only through Lopez-Cortegano 2019 and the Crossref abstract; the text declares this and no number or identity of the chapter depends on either.
- Monte Carlo s.e. of the 49 % and 27 % shares not computed; the effect (differences of 30 and 22 points against a conc s.e. of the order of 0.4 point of the share) is far outside it.
- Chapter not rendered (Quarto); _freeze is stale until the next render. Not a content matter.
