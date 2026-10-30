# 04g-joint-allocation -- reference check, iteration 1

Chapter: book/04g-joint-allocation.qmd. Bibliography: book/references.bib.

## Findings

**04g-B1 -- WRONG** -- `book/04g-joint-allocation.qmd:317` (`@gonzalezbarrios2019`)
The text says "mega-environmental allocation reported a 40 % gain in response for the same resources". The abstract says the moderate MED strategy "could potentially increase selection response **up to 43%**". That makes the figure wrong (40 vs 43). It also drops the qualifier: this is a ceiling, not a typical gain.
Fix: "reported gains in selection response of up to 43 %".
Evidence: abstract via Europe PMC / Crossref, https://doi.org/10.2135/cropsci2018.11.0692

**04g-B2 -- WRONG (incomplete, low severity)** -- `:308` (`@montesinoslopez2024`)
The text says only that incomplete blocks "were *less variable* than random -- a worst-case property a mean accuracy does not show". The abstract says "The IBD method showed **superior performance** with less variability compared to random allocation". So the paper also reports better mean performance, and the chapter omits it. This matters for the "mixed record" framing at `:942`, where this paper sits on the "better than random" side.
Evidence: https://doi.org/10.3390/plants13213059 (PMC11548790 abstract)

**04g-B3 -- UNVERIFIED (possible overstatement)** -- `:309-310` (`@lell2021`)
The text says equal subgroups in overlapping subsets of environments were found "best". The abstract calls this "one promising design", "particularly appropriate" with high accuracy and low variability. I could not reach the full text to confirm it ranked first.
Suggest: "found ... most promising".
Evidence: https://doi.org/10.1002/tpg2.20150 (abstract, PMC12893651)

**04g-B4 -- WRONG (nuance, low severity)** -- `:323-325` (`@kadam2021`)
The text says optimising over *all possible* single crosses "gives a better training set". The paper reports that the advantage of PEVmean/CDmean increased "based on **expected** prediction accuracy". That is a deterministic forecast, not realised accuracy (the abstract says "This finding suggests that it may be worthwhile...").
Suggest: "raises the expected accuracy of a PEV- or CDmean-optimised training set".
Evidence: https://doi.org/10.1007/s00122-020-03722-w (abstract)

**04g-B5 -- UNVERIFIED** -- `:509-510` (`@caballero2002`)
The text says Caballero & Toro weight subpopulations by N_i/N_T, giving GD_BS = f~ - f_bar = D_bar. This is consistent with the book's own use of Eq. 8 elsewhere, but I could not reach the full text (Springer paywall). The weighting scheme is not checked against the original.
Evidence: https://doi.org/10.1023/A:1019956205473

**04g-B6 -- UNVERIFIED (minor)** -- `:518-519` (`@nei1973`)
The text gives D_ST = H_T - H_S, with H_S "the plot-weighted mean". Nei (1973) defines H_S as the average over subpopulations, and the identity is correct. The full text is a scanned PDF and I could not read it. If Nei uses a simple average, the weighted form is a generalisation, as Nei & Chesser 1983 later formalised. The chapter's parenthesis "(the plain mean under equal loads)" already hedges this, so no change is required.
Evidence: https://doi.org/10.1073/pnas.70.12.3321

**04g-B7 -- WRONG (metadata incomplete)** -- references.bib
All DOIs resolve to the right paper, and first author and year match Crossref. Several entries lack volume and pages that Crossref provides:
- melchinger2023: 136, 176
- guo2019: 12, 390-401
- endelman2014: 54, 48-59
- seye2020: 133, 1995-2010
- lorenzi2022: 135, 3143-3160
- gonzalezdieguez2026: 139, 78
- thomsen2026: 139, 227
- mothukuri2025: 138, article 62
- atanda2021: 12, 658978
- atanda2022: 135, 1939-1950
- rincent2012: 192, 715-728
- jarquin2020: 10, 2725-2739
- lubanga2025: 18, e20558
- hoefler2026: 66, e70366

Four entries (melchinger2023, seye2020, gonzalezdieguez2026, thomsen2026) use the PubMed journal string "TAG. Theoretical and applied genetics. Theoretische und angewandte Genetik" instead of "Theoretical and Applied Genetics" (cosmetic).

## Checked and faithful (no finding)

- **montesinoslopez2022ibd:** 1.4-26.5 % MSE.
- **montesinoslopez2023:** M4 best, M3 random close.
- **montesinoslopez2023genes:** M3/M4 slightly better; 15:85 split barely lower.
- **mothukuri2025:** 0.20-0.31.
- **rincent2017:** OptiMET beats random METs twice as large, wheat phenology.
- **hoefler2026:** replication and sparsity of MEDs by simulation, abstract via OpenAlex.
- **guo2019:** maize/wheat/rice; beats random, PEVmean and CDmean; 2-13 %.
- **endelman2014:** barley and maize; unbalanced multi-location beats one location; 250 YPU.
- **gonzalezdieguez2026:** 3-5 testers over 1,200 testcrosses per pool; the approximate incomplete factorial gave "similar" GCA accuracy (full text PMC12932368, sec. 4.5).
- **thomsen2026:** 1.67 % of mother x father combinations; unreplicated alpha-lattice METs from a commercial NPZ programme; GCA+SCA multi-environment models (full text PMC13469503).
- **schoemaker2024:** 3-5 environments, chosen as "highest quality data", match 10 random; trades testers against environments. "Well-chosen" is acceptable, though the choice was on data quality.
- **isidro2015:** stratified sampling for rice; CDmean and StratCDmean for wheat except test weight and heading date.
- **bustoskorts2016:** uniform sampling beat stratified and random; similar to CD; rice all alike.
- **berro2019:** stratified sampling with a weighted relationship matrix best for forward prediction.
- **ou2019:** criterion from Pearson's correlation, ridge regression, TSDFGS, rice and wheat.
- **akdemir2019:** targeted sets best.
- **atanda2021:** CDmean subsets per environment; CV1 vs CV2 similar; environment grouping helped.
- **windhausen2012:** 0.12 for grain yield, differences in population means.
- **fernandezgonzalez2023:** a diverse training set is robust; clustering information less effective.
- **heslot2020:** mixed binary-integer differential evolution (preprint subtitle, bioRxiv 10.1101/172064); maize hybrids; connected population design before crossing.
- **cullis2020 / butler2014:** model-based designs with relatedness; in-silico gains (Cullis abstract). The butler2014 abstract could not be retrieved; the A-optimality attribution matches the paper's known content.
- **lisle2021:** D-optimality diagnostic for variance parameters.
- **rio2022:** CD extended to G x E. **rincent2012:** CDmean.
- **seye2020 / lorenzi2022 / melchinger2023:** factorial at least as good as tester designs; fewer crosses per line favours untested lines (c = 1 best for H0 and I0).
- **papenberg2021:** k-means anticlustering.
- **meuwissen2020:** F_drift is their Eq. 1B, with per-marker standardisation by p0(1-p0), matching `:536-538` (full text PMC7438563).
- **jarquin2020, crespoherrera2021, lubanga2025, atanda2022, akdemir2021, isidroysanchez2021, debeukelaer2018:** cited only generically; metadata checked.

Check 2: all 43 citation keys used in the chapter resolve in references.bib, each defined once.

Check 4: I found no uncited external quantitative or historical claim. The literature-search description (`:238-246`) is the chapter's own provenance.

## Method

I checked 43 keys (77 citation occurrences). For every DOI I resolved metadata through the Crossref API, including author lists for 22 entries. I checked 31 attributions against abstracts from Europe PMC and OpenAlex. Full text was read for gonzalezdieguez2026, thomsen2026 and meuwissen2020 (Europe PMC XML). Heslot 2020 was checked through its bioRxiv preprint. caballero2002 and nei1973 remain unverified because the full text was unreachable.
