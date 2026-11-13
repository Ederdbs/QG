# 08-pipeline-stages -- reference check, iteration 1

File: book/08-pipeline-stages.qmd (459 lines). Bib: book/references.bib.

Summary: the chapter contains NO `[@key]` / `@key` bibliographic citation. The only `@` tokens are cross-references (@sec-hp-cycle, @sec-choosing, @sec-heterosis, @sec-cycles, @sec-plant-literature, @sec-collapse), all outside the scope of this check. Comstock 1949 is NOT cited in this chapter (it appears in 00, 04c, 04e). The single literature reference is typed as plain text.

## Findings

- 08-B1 | line 160 | Kadoumi et al. (2025) typed as plain text, not `[@kadoumi2025]` | STATUS: WRONG (form) -- metadata and attribution OK.
  Bib key `kadoumi2025` exists and every other chapter uses it as a key (00:208,345,359; 04f:759; 11:137), so this one will not appear in the chapter's bibliography link and will not be a link. Fix: `@kadoumi2025 tracked ...`.
  Metadata: Crossref https://doi.org/10.1007/s00122-025-05008-5 resolves to: Kadoumi, Heslot, Henriot, Murigneux, Berton, Moreau, Charcosset; "Evolution of population structure in a commercial European hybrid dent maize breeding program and consequences on genetic diversity"; Theor Appl Genet 138(9):233; 30 Aug 2025. Matches the bib entry (authors, year, title, journal, vol, no., article 233, DOI). No retraction or correction in the Crossref record (update-to empty).
  Attribution (ABSTRACT, from Crossref abstract; full text not read): "Forty years of breeding data and 84,000 genotypes"; "Differentiation between ... heterotic groups ... increased over time ... intragroup diversity decreased over time". This supports "tracked diversity erosion and heterotic-group divergence over decades of a commercial European dent maize programme -- and found the two opposite trends". Level: ABSTRACT (consistent; no number or equation attributed, so nothing needs FULL TEXT). Note for the chapter: 00-hybrid-programme.qmd:359 mentions a corpus that begins in 2017; do not read "decades" in this chapter as the corpus of the book.

- 08-B2 | lines 96, 88, 115 | F_ST^(W) vs G_ST: "Nei's G_ST = (H_T - H_S)/H_T" and "published threshold computed the other way" | STATUS: MISSING SOURCE.
  Wright's F_ST and Nei's G_ST are named and a published-threshold claim is made with no citation. Sources in bib: `nei1973` (Nei 1973 PNAS 70(12):3321-3323, DOI 10.1073/pnas.70.12.3321, Crossref confirms title/pages/year) and `wright1951`/`wright1969`. The coancestry form of F_ST and the GD partition are in Caballero & Toro 2002 (`caballero2002`, Conserv Genet 3:289-299, DOI 10.1023/A:1019956205473, Crossref OK; local PDF read: it defines F_ST on coancestries, Eq. 8 region, and cites Nei 1973 for gene diversity). Proposal: `Wright's $F_{ST}$ [@wright1951] ... Nei's $G_{ST}$ [@nei1973]`, and state the coancestry form from @caballero2002. UNVERIFIED: that C&T Eq. gives exactly (theta_w - theta_B)/(1 - theta_B); only grep of the PDF was done, not a line-by-line equation match, and the chapter does not attribute the equation to any source.
  Bib note (not cited here, not a finding of this chapter): `wright1951` has year 1951 but DOI 10.1111/j.1469-1809.1949.tb02451.x; Crossref gives Annals of Eugenics 15(1):323-354, issued 1949-01. Most literature cites it as 1951 (vol. 15 spans 1949-1951 in print) so it may be deliberate; flag for the bib owner.

- 08-B3 | line 226 (also 221) | "the textbook 2.063" selection intensity at 5% | STATUS: MISSING SOURCE.
  Value is the standard i for the top 5% of a normal (Falconer & Mackay table of selection intensities); bib has `falconer1996` (book, no DOI). Not verified in the book itself (no copy on disk, not in reach of PubMed). UNVERIFIED as a page-level attribution. Propose `[@falconer1996]` in "the textbook" sentence; add the page/table when someone with the book confirms it.

- 08-B4 | lines 218-220, 230, 235-240 | usefulness criterion `UC = mu + i h sigma` and "rank crosses on sigma_DH from marker effects" | STATUS: MISSING SOURCE.
  The usefulness criterion (Schnell & Utz 1975) has no bib entry and is not cited; the chapter's S2 section, sigma^2_DH = (1/4) sum beta_k^2 over discordant loci (ignores linkage) and Trap 4 are attributed to nobody. Primary source found in bib: `lehermeier2017` (Genetics, DOI 10.1534/genetics.117.300403, usefulness criterion with improved variance prediction) and `lian2015` (Crop Sci, prediction of genetic variance in biparental maize populations). Original Schnell & Utz 1975 is not in the bib and I did not retrieve it (UNVERIFIED; looked in bib only). Note: lehermeier2017 and lian2015 do not have volume/pages in the bib (not a check-1 finding of this chapter but relevant if cited).

- 08-B5 | lines 88, 230, 383 | "routine use", "common practice to rank crosses by marker distance", "where optimisation effort conventionally goes" | STATUS: MISSING SOURCE (soft).
  Qualitative claims about practice with no support. Candidates already in bib: `reif2007` (check topic fit before use), `hallauer2010`. UNVERIFIED which supports the specific claim; not read.

- 08-B6 | lines 380-400 | numbers "77%", "11%", "p = 0.0002", "11274" etc. | STATUS: not a literature claim -- they come from `book/data/pipeline_loss_ledger.csv` (internal simulation). Outside the scope of reference checking; noted for the numerical reviewer.

## Comstock 1949 (PENDING item)
`comstock1949` exists in references.bib (line 456): Comstock, R. E., Robinson, H. F., Harvey, P. H. (1949) "A breeding procedure designed to make maximum use of both general and specific combining ability", Agronomy Journal 41(8):360-367, DOI 10.2134/agronj1949.00021962004100080006x. Crossref resolves the DOI to the same title (with a footnote superscript), journal, vol 41, issue 8, pp 360-367, issued Aug 1949, authors Comstock, Robinson, Harvey. Existence and title: OK. Not cited in chapter 08, so nothing to check here; content not read (PENDING by instruction).

## Bib entries not cited in this chapter
Not applicable (chapter mode). Whole-book UNCITED check not run.

## Where I looked
Local: chapter text, references.bib, reference/papers/Analysis_of_genetic_diversity...pdf (pdftotext, grep for F_ST/Nei). Web: Crossref API for all DOIs above. PubMed/PMC: not needed (journals not biomedical; Crossref abstract used for Kadoumi). Full text of Kadoumi 2025 and Falconer & Mackay not reached.

## Tally
Citations checked: 1 explicit literature citation (Kadoumi 2025, plain text) -- metadata verified via Crossref, attribution at ABSTRACT level. 0 at FULL TEXT. 0 `@key` resolution failures (no `@key` present). 1 pending existence/title check (Comstock 1949) done. 4 groups of uncited claims (08-B2..B5).
