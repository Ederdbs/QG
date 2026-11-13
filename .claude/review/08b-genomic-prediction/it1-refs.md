# 08b-genomic-prediction -- reference check, iteration 1

Chapter: book/08b-genomic-prediction.qmd. Bib: book/references.bib.
Local copies: /Users/ederdbs/Documents/SB_quanti_gen/reference/papers/ holds 5 PDFs, none cited by 08b. Next: PMC/Europe PMC, then web.

All 9 keys cited in the chapter resolve in references.bib. All 9 DOIs resolve via Crossref to the right paper, with the right first author, year, journal, volume and pages, except the bWGR author list (08b-B1). No retraction or corrigendum was found in Crossref (no update-to relation).

## Findings

### 08b-B1 -- xavier2019bwgr -- WRONG (author list)
- book/references.bib:28-34 lists 4 authors: Xavier, Muir, **Craig**, Rainey.
- Crossref for 10.1093/bioinformatics/btz794 lists 3: Alencar Xavier, William M. Muir, Katy M. Rainey. "Craig, B." does not appear in the paper's record (he is a co-author of the R package, not of the article). Remove him.
- Year: the bib says 2019 (online 2019-10-24), but volume 36(6) is print 2020-03-01. Acceptable if intended as the online year; use 2020 to match the volume.

### 08b-B2 -- line 330-331 -- WRONG attribution (CV0/CV1/CV2 naming)
- Sentence: "@burgueno2012 named the schemes that distinguish the cases, and @technow2014 applied them to exactly this design". The chapter then defines CV2 = both parents seen, CV1 = one parent unseen, CV0 = neither seen.
- Burgueno et al. 2012 (Crop Sci 52:707) define only CV1 (predict untested genotypes) and CV2 (genotypes tested in some environments but not others), in a genotype-by-environment setting. They have no CV0 and no parent-count partition. Evidence level: ABSTRACT/secondary snippet (the Crop Science text is not reachable); UNVERIFIED in full. CV0 as "tested lines in untested environments" comes from later work: the abbreviation list of Jarquin et al. 2017 (Kansas wheat) defines it. I did not find the labels in Jarquin et al. 2014 itself.
- Technow et al. 2014 (PMC4125404, FULL TEXT via PMC page) call the three groups **T2, T1, T0** ("two, one, and zero parents, respectively, were tested in other combinations"). They do not use the CV labels, and their reference list does not include Burgueno 2012.
- Suggested fix: attribute the parent-count partition to @technow2014 (T2/T1/T0) and say that the book borrows the CV0/CV1/CV2 names by analogy from the G x E literature. Do not say Burgueno "named the schemes".

### 08b-B3 -- line 387-388 -- UNVERIFIED (equation form and M_e notation)
- Sentence: "@daetwyler2008 give the deterministic accuracy ..., r = sqrt(n h^2 / (n h^2 + M_e))".
- FULL TEXT (PMC2561058, Europe PMC XML): Eq. (1) is an image and its form could not be read as text. The text says "accuracy is seen to be a function of the product of the observed heritability and the ratio of the number of phenotypes recorded to the number of loci involved, lambda". It also says "One could apply our formulae by interpreting n_G as the number of independent chromosome segments". So the idea is supported (Eq. 1 in terms of lambda = n_P/n_G); the exact algebra and the symbol M_e are not confirmed. I recall the M_e notation from Daetwyler et al. 2010 (Genetics 185:1021), which I did not check. Suggest citing 2008 for the formula in lambda and, if needed, Daetwyler 2010 for M_e. Please check Eq. (1) against the PDF.

### 08b-B4 -- line 679 -- MISSING SOURCE (BayesCpi)
- "BayesCpi ... treats pi itself as unknown and updates it by Metropolis-Hastings ... [@xavier2019bwgr]".
- FULL TEXT of the bWGR paper (publisher page): it lists BayesCpi and says "Metropolis-Hasting for BayesCpi and BayesDpi", but "pi" is not mentioned and the paper does not say which parameter is updated. So the citation supports only the software, not the description of the method.
- Primary source: Habier, Fernando, Kizilkaya, Garrick (2011), "Extension of the Bayesian alphabet for genomic selection", BMC Bioinformatics 12:186, doi:10.1186/1471-2105-12-186 (Crossref resolves). Not in references.bib. Add it. Its content was not read (UNVERIFIED).

### 08b-B5 -- line 171 -- UNVERIFIED (Henderson 1975 and the joint-density derivation)
- "Treating u as a random variable ..., @henderson1975 maximises the joint density of what is observed and what is not". Metadata for 10.2307/2529430 is correct (Biometrics 31(2):423-447; Crossref shows only the first page).
- The paper is about BLUP under a selection model. The joint-density derivation of the mixed model equations is usually credited to Henderson's earlier work (1950, 1963, 1973). Full text of the 1975 paper not reachable (paywalled JSTOR, not in PMC). UNVERIFIED. Suggest "@henderson1975 and earlier work" or a more specific source.

### 08b-B6 -- line 376 -- UNVERIFIED beyond the abstract (Habier 2007)
- "@habier2007 separate the two things a genomic prediction can be using -- relationship ... and marker effects". ABSTRACT (PubMed 18073436): "markers can capture genetic relationships among genotyped animals, thereby affecting accuracies of GEBVs"; "accuracy of GEBVs can result entirely from genetic relationships captured by markers"; persistent accuracy due to LD is distinguished. Supports the sentence in substance. Full text (PMC2219482) not retrievable (Europe PMC returned an error). Status: ABSTRACT only.

## Checked and consistent
- gianola2009 (line 545): FULL TEXT (PMC2746159, section "A critique"). "Neither Bayes A nor Bayes B ... allow Bayesian learning on these variances to proceed far away from the prior"; "if nu = 5 ... irrespective of whether data on millions of markers or of individuals become available". Supports "the central objection". The quoted phrase "learning the genetic architecture" in the chapter is a paraphrase in quotation marks, not a quotation from Gianola; consider removing the quotation marks.
- meuwissen2001, delcampos2013 (line 420), BayesA/BayesB as the "Bayesian alphabet": the metadata is right. The attribution is general and uncontroversial (Meuwissen 2001 introduced BayesA/B). ABSTRACT only; I did not read full text.
- xavier2019bwgr (line 468): "fits both with bWGR::BayesA()/BayesB()". The paper lists BayesA and BayesB among the functions. FULL TEXT (publisher page).

## Comstock 1949 (PENDING, existence and title only)
comstock1949 is in references.bib:456 but **is not cited anywhere in 08b** (grep found no @comstock1949 in the chapter). Existence confirmed: Comstock, Robinson & Harvey, "A breeding procedure designed to make maximum use of both general and specific combining ability", Agron. J. 41(8):360-367, 1949, doi:10.2134/agronj1949.00021962004100080006x (Crossref, matches the bib). Content not checked.

## Unsupported quantitative claims
- No uncited numerical or historical claims were seen in the citation sweep. The result figures in the chapter (0.952, 0.931, 0.12, etc.) are the book's own R output, not literature. I did not review the code chunks.

## Summary of evidence levels
Citations checked: 9 keys (plus comstock1949, uncited here).
- FULL TEXT: 3 (daetwyler2008 partially, gianola2009, technow2014 labels) plus xavier2019bwgr (publisher page).
- ABSTRACT: 3 (habier2007, meuwissen2001, delcampos2013).
- UNVERIFIED (no full text): 2 (henderson1975, burgueno2012).
- Metadata via Crossref DOI: 10 of 10 resolve correctly, 1 with an error (B1).
Places looked: local reference/papers (not relevant), Crossref, PubMed/PMC, Europe PMC, PMC and OUP pages, web search.
