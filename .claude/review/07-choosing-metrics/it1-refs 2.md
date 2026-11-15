# Chapter 07 (book/07-choosing-metrics.qmd), references check, iteration 1

## Scope result
The chapter contains NO bibliographic `@key`. Every `@` outside R code is a cross-reference:
sec-catalogue (06-metric-catalogue.qmd), sec-ocs (09), sec-simulating-crosses (03), sec-genomic-prediction (08b),
sec-case-study (12), sec-plant-literature (11), sec-genomic-era (05). All 7 labels resolve (grep `{#sec-...}`).
Comstock 1949 (`comstock1949`) is not cited in this chapter; existence and title only, as instructed: Crossref confirms
Comstock, Robinson & Harvey, "A breeding procedure designed to make maximum use of both general and specific combining
ability", Agron. J. 41(8):360-367, 1949, DOI 10.2134/agronj1949.00021962004100080006x. Matches bib. (Full text unread.)

## Findings
- 07-B1 | qmd:463 | MISSING SOURCE | "Core Hunter's E-NE and A-NE ... designed for core-collection assembly". No citation.
  Bib has `debeukelaer2018` (DOI 10.1186/s12859-018-2209-z, resolves via Crossref to Core Hunter 3, De Beukelaer, Davenport, Fack, 2018;
  bib metadata OK except Crossref gives volume 19, matches). Local PDF (reference/papers/Core Hunter 3...pdf) FULL TEXT:
  "Entry-to-nearest-entry (E-NE)" and "Accession-to-nearest-entry (A-NE)" are defined as distance measures, "proposed by Odong et al. [4]";
  the paper is about core subset selection. Claim that they "require the O(N^2) matrix" is the chapter's own inference (pairwise distances), not a statement of the paper: UNVERIFIED as an attribution.
  Propose: cite @debeukelaer2018 and @odong2013 (already in bib, line 1939, not checked in detail).
- 07-B2 | qmd:309 | MISSING SOURCE | "`DEoptim` warns that NP should be at least ten times the parameter count". True: DEoptim 2.2-8 `?DEoptim.control`
  (FULL TEXT, installed help): "For many problems it is best to set 'NP' to be at least 10 times the length of the parameter vector." Default NP = 10*length(lower).
  It is a documentation recommendation, not a runtime warning in that text; "warns" is loose. (Not verified whether a runtime warning is also emitted.) Propose cite @mullen2011 (in bib, DOI 10.18637/jss.v040.i06 verified by Crossref: Mullen, Ardia, Gil, Windover, Cline, JSS 40, 2011) and the package manual; Storn & Price 1997 (`storn1997`) is the origin of the 5-10x rule but I did not read it: UNVERIFIED.
- 07-B3 | qmd:468-473 | UNVERIFIED / MISSING SOURCE | "Post-2018 work is consistent that molecular or IBD-flavoured coancestry beats a VanRaden-style drift matrix ... no consensus". No citation in this chapter; it defers to @sec-plant-literature. Chapter 11 (lines 247-266) states the same ("multiple post-2018 papers", "The consensus, such as it is") but its bullets (deviation-based matrix, linkage-and-pedigree matrix, ROH in pigs) also carry no @key in the passage I read. The sentence is a literature summary with no primary source reachable from this chapter. Chapter 07 phrase "is consistent" is stronger than ch. 11 "the consensus, such as it is". Not checked on the web; would require identifying the underlying papers.
- 07-B4 | qmd:15-33, 106, 458, 463 | MISSING SOURCE (minor) | Named concepts without citation: status number Ns = 1/(2 theta) (bib has Lacy 1989 `lacy1989`, `caballero2000` "Status number..."? line 95 title "Status number for measuring genetic diversity"; not opened), Nei's He = 1 - theta (`nei1973`), the OCS lattice statement (`meuwissen1997`), within/between pool decomposition (`caballero2002`, local PDF "Optimal Management of genetic diversity in subdivided populations.pdf" exists but I did not read it for this chapter). Propose adding these keys; all present in bib. Not verified for faithfulness.
- 07-B5 | qmd:16-33, 169-177, 199-215, 287-307 | NOT A REFERENCE ISSUE | Numerical claims (482x, 14.2 h, 178x, 5.7x, 88%/7%, 52%/36%/25%, band 0.666-0.670, 399 selections, 171 markers, index 0.351/1.988/2.337, 85%) are in-repo results from book/data CSVs and figures, uncited by design. Not checked against the CSVs here (outside reference check). 482x = 14.2h/ (106us*1e6=0.0294h) = 482, arithmetic OK. 14.2 h / 482 = 106 us: consistent.
- 07-B6 | qmd:326 | UNVERIFIED | "@sec-genomic-prediction fits an actual GBLUP model ... finds the same structure in its real residuals, at a comparable accuracy". Cross-reference exists; content of 08b not checked here.

## Whole-chapter note
No wrong metadata, no unresolved key, no misattributed equation/table. The chapter's literature exposure is entirely through uncited statements (B1-B4).

Counts: 0 bib keys cited in chapter; 7 cross-refs resolved; FULL TEXT: 2 (Core Hunter 3 definitions of E-NE/A-NE; DEoptim help NP guidance); metadata via Crossref: 4 (comstock1949, debeukelaer2018, mullen2011 + resolves); ABSTRACT: 0; UNVERIFIED: B2 (Storn), B3, B4, B6.
