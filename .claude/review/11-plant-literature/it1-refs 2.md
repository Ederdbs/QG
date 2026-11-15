# Reference check: book/11-plant-literature.qmd (iteration 1)

Bibliography: book/references.bib. Date: 2026-11-14. Read-only on the book.

## Scope

- The chapter contains ONE citation key, `@kadoumi2025` (line 137). It resolves in references.bib (line 1476).
  All other `@` tokens are cross-references (`@sec-choosing`, `@sec-collapse`, `@sec-stages`, `@sec-subdivided`,
  `@sec-corpora`, `@sec-genomic-era`, `@sec-heterosis`, `@sec-cycles`): all resolve to existing anchors.
- Roughly 35 further study-level findings and numbers are attributed to papers WITHOUT a citation key
  (they come from the screened corpus in `book/data/bibliography_plant.csv` / `bibliography_animal.csv`, which holds
  one-line curator notes, not abstracts). I identified the source of each by searching Europe PMC/PubMed/Crossref and read
  the abstract (full text for Kadoumi and Zhao). Details below.
- Gorjanc 2018, Allier 2019, Lehermeier 2017, Cevallos, De Beukelaer 2018, Comstock 1949: NOT cited in this chapter.
  Comstock 1949 is not mentioned at all (no attribution to flag). Gorjanc 2018 and Allier 2019 are not cited either
  (bib entries `gorjanc2018` and `allier2019` exist and their metadata is correct, see 11-B20).

## Findings

### 11-B1  Systemic: study-level attributions with no citation key (MISSING SOURCE)
`11-plant-literature.qmd:38-338`. Every numeric or named-study claim below except Kadoumi has no `@key`; none of these
DOIs is in references.bib (only `yadav2025`, `gorjanc2018`, `meuwissen2020` are). Sources I found and read (all ABSTRACT level
unless stated; add to the bib and cite):

| Chapter line | Claim | Source found | Abstract says |
|---|---|---|---|
| 38-42 | 376 SSA inbreds: PIC 0.39, GD 0.37, MAF 0.29, Shannon 6.86, Simpson 949.09, AR 787.70, distance 0.303 | Mukiti et al. 2025 PLoS ONE, 10.1371/journal.pone.0316793 | All numbers match. See 11-B9 on "Rogers". |
| 74-77 | pearl millet Ho 0.031, He 0.334 | Kandarkar et al. 2024 PLoS ONE, 10.1371/journal.pone.0298636 | Match (109 lines, 16,472 SNPs). |
| 101-104 | 298 African highland inbreds, 91% pairs differ 30-36%, 32% kinship <0.05 | Wegary et al. 2019 Sci Rep, 10.1038/s41598-019-49861-z | Verbatim match ("Nearly 91% ... 30-36% ... only 32% ... <0.050 ... redundancy ... repeated use of fewer genetic backgrounds"). |
| 110-111 | ex-PVP: 8 admixture subgroups "aligned with company of origin" | White et al. 2020 Crop Sci, 10.1002/csc2.20050 | "eight subgroups ... reflecting heterotic patterns and company of origin" (329 inbreds). Chapter drops "heterotic patterns". Minor. |
| 111-113 | China summer maize, 490 inbreds, 525,141 SNPs, 66.05% | Shu et al. 2021 Sci Rep, 10.1038/s41598-021-84732-6 | Match; abstract: "Majority of the inbred lines (66.05%) show pairwise relative kinship near zero". |
| 113-114 | sweet corn lower diversity/PIC/MAF, 514 vs 181 lines | Yang et al. 2025 Mol Breed, 10.1007/s11032-024-01533-1 | Match. |
| 121-125 | SSR linked to yield QTL no advantage over random SSR | Kumar et al. 2022 Crop Pasture Sci, 10.1071/CP21376 (Crossref abstract) | "crosses ... of linked SSR markers did not reveal any superiority ...; random-marker inter-heterotic crosses superior". Supported, but based on 19 inbreds (diallel); chapter gives no sample size. HSGCA "most consistent": Annor et al. 2020 Plant Breed 10.1111/pbr.12822 abstract: "HSGCA method was more effective" (41 lines). The claim "SNP-based and testcross-based classification disagree": UNVERIFIED (candidate Oyetunde 2020, 10.3390/agronomy10081198, abstract not read). |
| 153-155 | 10.8% of hybrids exceeding a check | Cheng et al. 2025 IJMS, 10.3390/ijms26062662 | Match: "10.8% of hybrids in the population POP5/C229 surpassed the high-yielding hybrid ND678 (CK)". |
| 164-167 | "ineluctable" diversity depletion, bridging | Sanchez et al. 2023 PNAS, 10.1073/pnas.2205780119 | Quote verbatim ("diversity depletion in closed programs appears ineluctable, calling for the introduction of relevant diversity donors"; bridging populations). Chapter says it "appears repeatedly": I found one source. |
| 175-176 | 12-88% gain advantage, oligogenic, 2-3 cycles/yr | Muleta et al. 2019 G3, 10.1534/g3.118.200932 | See 11-B3. NOT Gorjanc 2018. |
| 177-179 | Two-cycle GWS, larger gains at equal cost and time | Bernardo 2021 Crop Sci, 10.1002/csc2.20516 | Match: "124 to 178% of the largest gain from phenotypic selection and 112 to 135% of one-cycle GWS". The abstract reports no diversity metric (consistent with "no diversity metric at all", ABSTRACT only). |
| 177-178 | wheatgrass 2-5 yr to 1 yr | Crain et al. 2021 Plant Genome, 10.1002/tpg2.20080 | Match on years. See 11-B4. |
| 185-188 | hybrid rice RRS | Fritsche-Neto et al. 2023 TAG, 10.1007/s00122-023-04508-6 | See 11-B5. |
| 195-196 | UCPC multi-parental; barley; soybean; wheat | Allier et al. 2019 G3 10.1534/g3.119.400129; Neyhart & Smith 2019 10.2135/cropsci2018.11.0716 (330,078 combinations, barley); Wartha & Lorenz 2024 10.1038/s41437-024-00703-3 / Miller 2023 10.3389/fpls.2023.1171135 (soybean); Oget-Ebrad 2024 10.1007/s00122-024-04718-6 (wheat); Sakurai 2024 10.1093/g3journal/jkae224 | 330,078 match (also at l.294). Allier G3: "two to four parents ... maize". Consistent with "upstream". Sakurai: "does not consider genetic diversity". Negative claim "none on F1 hybrids" cannot be verified from abstracts. |
| 214-217 | GenoCore 310 of 3,300+ sorghum | Mufumbo et al. 2022 Genet Resour Crop Evol, 10.1007/s10722-022-01513-4 | Match (3333 accessions, 310, GenoCore). |
| 215-216 | rice cores 247 and 30 from 2,242 | Choudhury et al. 2021 Front Genet, 10.3389/fgene.2021.726152 | Match, but 30 is the "mini-core", 247 the "core". |
| 216-217 | lettuce 268 of 811, 99.4% | Huo et al. 2026 Hortic Res, 10.1093/hr/uhaf258 | Match. |
| 218-221 | 3-78-fold more haplotypic diversity | Reeves et al. 2020 Agronomy, 10.3390/agronomy10040593 (Crossref abstract) | Verbatim ("3-78 fold more haplotypic diversity in subsets than geographic or environmental data", Arabidopsis, Populus, sorghum). |
| 227-230 | 156 landraces, 2,340 individuals, 327 lines, two indicators | Arca et al. 2023 Plant Biotechnol J, 10.1111/pbi.14022 | Match. |
| 231-233 | ~1,000 landrace DH, haplotypes outperform | Mayer et al. 2020 Nat Commun, 10.1038/s41467-020-18683-3 | Match ("~1000 doubled-haploid lines", "Stability of haplotype effects across populations and environments"). |
| 234-235 | 899 DH, 600K | Polzer et al. 2025 TAG, 10.1007/s00122-025-04855-6 | Match (N = 899 training set, 600k array). The abstract also reports "prediction accuracies declined sharply across cycles", not mentioned. |
| 236-239 | DH beats gamete capture | Holker et al. 2022 PNAS, 10.1073/pnas.2121797119 | Match. |
| 251 | IBD vs homozygosity vs drift matrices | Meuwissen et al. 2020 Front Genet, 10.3389/fgene.2020.00880 (local PDF, abstract) | Match ("drift and homozygosity-based inbreeding could differ substantially ... unless diversity management was based upon IBD"). |
| 253-255 | deviation matrix vs VanRaden | Morales-Gonzalez et al. 2021 Genes, 10.3390/genes12050673 | Match. |
| 256-258 | linkage/pedigree matrix | Waege et al. 2026 GSE, 10.1186/s12711-026-01044-x | Match. |
| 259-260 | ROH vs SNP in pigs | Zhao et al. 2023 J Anim Sci Biotechnol, 10.1186/s40104-023-00872-x | FULL TEXT, see 11-B8. |
| 268-274 | allelic loss, linear N_C relation, N_e>500 | Allendorf et al. 2024 Evol Appl, 10.1111/eva.13733 | Match in all four points (abstract). |
| 276-279 | rate-based N_e negative, no asymptote | Toro et al. 2019 J Anim Breed Genet, 10.1111/jbg.12455 | Match ("effective population size takes negative values ... does not attain an asymptotic value"). |
| 301 | AlphaMate "most cited applied tool" | Gorjanc & Hickey 2018 Bioinformatics, 10.1093/bioinformatics/bty375 | UNVERIFIED: a "most cited" claim needs a citation count; the chapter's own CSV has a `citations` column, quote it or drop the claim. |
| 303-305 | 583-line wheat metaheuristics | Yadav et al. 2025 TAG, 10.1007/s00122-025-05028-1 (bib key `yadav2025`) | Match on content. See 11-B6. |

### 11-B2  Kadoumi 2025 (`:134-144`): headline is the abstract's, the full text qualifies it (WRONG-ish / overstated)
Bib entry correct (Crossref: Kadoumi, Heslot, Henriot, Murigneux, Berton, Moreau, Charcosset; TAG 138(9): 233, 2025-08-30;
DOI resolves to this paper). FULL TEXT read (PMC12397178).
- Abstract/Key message, verbatim: "Differentiation between Stiff Stalk and Non-Stiff Stalk heterotic groups increased
  significantly over time, while genetic diversity within both groups declined". The chapter's sentence matches it.
  "Decades": abstract says "Forty years of breeding data and 84,000 genotypes" (84,841; eras = 10-year windows, eras 0-4). OK.
- But the Results/Discussion say: He fell from 0.371 to 0.279 in NSS while "He ... remaining stable" in SS; the SS "remained
  relatively stable"; its decline appears in extreme-tail markers/LD only. The main cause of loss was the merging of Iodent
  and Lancaster into NSS ("population merging"), not generic selection erosion in both pools. The authors write: "These
  changes are thus not critical and only suggest that increased caution in diversity management is now needed".
  The chapter's "confirms the constraint is doing necessary work rather than solving a hypothetical problem" (l.140-141)
  and "single most load-bearing result" (l.134) go beyond the source.
- The authors flag a sampling bias: eras 0-2 contain only inbreds that fed the modern program (survivors), so early
  diversity may be over- or under-estimated. "Longitudinal commercial data, not simulation" is true, but omits this caveat.
- "protected from erosion and from excessive inflation is between-pool divergence" (l.141-143) is not in the paper: the authors
  recommend "enhancing heterotic group divergence, while preserving diversity across selection cycles". Single company (Limagrain), one germplasm range
  (mid-early/mid-late).
Suggested rewording: say the abstract's finding, add "driven mostly by NSS (He 0.371 to 0.279; SS stable)", cite the authors'
own "not critical, caution needed" and the survivor-sampling caveat; attribute the "inflation" band to the book, not the paper.

### 11-B3  Muleta 2019 (`:175-176`): qualifier lost, source uncited (MISSING SOURCE)
Abstract: "For oligogenic architecture, the maximum relative genetic gain advantage of GARS over PRS was 12-88%, which was
observed only during the first few cycles"; polygenic 26-165%; "Average prediction accuracy declines substantially after
several cycles"; "For small populations and oligogenic traits, cost per unit gain was lower in PRS than GARS". Chapter states
12-88% as a plain benefit of rapid cycling. It is a MAXIMUM, early-cycle, sorghum-simulation (Haiti) number. Source:
10.1534/g3.118.200932. Not Gorjanc 2018 (whose abstract gives 78% (15%) higher long-term gain with 4 cycles/yr, OCS vs truncation).

### 11-B4  Crain 2021 (`:177-178`): diversity step applies to the training population (UNCLEAR attribution)
Abstract: validation populations of 1,000-1,200 genets "were also selected using the genomic relationship matrix to represent
genetic diversity". Parents are chosen by GEBV (~100 of ~4,000) with no diversity constraint. Chapter: "an explicit
diversity-preserving sampling step" reads as if parent selection preserved diversity. Reword to "training-set sampling".

### 11-B5  Fritsche-Neto 2023 (`:185-188`): last clause not in source
Abstract supports "larger population sizes tend to have higher genetic gain and less depletion of genetic variance"
(additive variance lost to drift). "diversity is managed at the parental-pool level that feeds hybrids" is not stated; the
paper's point is genomic prediction of single-cross performance, "rather than reducing cycle length", "easier to implement than rapid-cycling RRS".

### 11-B6  Yadav 2025 (`:285-307`): misplaced, contradicts nearby plant claims
(a) Placed after "On the animal side, AlphaMate ..." but it is a plant study (583 wheat lines, 29,972 SNPs, stripe rust).
(b) l.291-293 says within plants the closest analogue has "no named algorithm", and l.297 says no plant study applies DE or any
metaheuristic; Yadav names GA, DE, PSO, SA in a plant. The chapter's qualifier "to an OCS-type hybrid selection problem"
saves the l.297 sentence (the task there is Optimal Haplotype Selection / Optimal Population Value, not OCS) but not l.291-293.
(c) "GA best convergence/fitness; DE robust but longer runtime and careful tuning" matches verbatim. "consistent with
@sec-choosing's encoding finding" is the book's inference. The bib key `yadav2025` exists (author "Yadav, S. and others";
volume 138(9), article 242, 2025: correct) and is used in 10b, not here.

### 11-B7  Beugnot 2023 (`:146-151`): mechanism overreach, no citation
Abstract supports only "background specific additive and dominance QTLs" and group-of-origin effects (Beugnot et al. 2023 TAG, DOI 10.1007/s00122-023-04431-w). It also says group "complementarity and differentiation" increase
over time and "ensure" hybrid performance. "pushing it further does not add hybrid value and risks removing shared favourable
alleles" is not in the abstract; it is the book's argument (@sec-heterosis). Cite as support for background-specificity only.

### 11-B8  Zhao 2023 pigs (`:259-260`): imprecise (FULL TEXT)
The "at equal gain" result is genomic mating vs traditional mating ("Genomic mating outperforms other approaches in limiting
the inbreeding accumulation for the same expected genetic gain"). ROH vs SNP: abstract "ROH-based ... achieved faster genetic
gains"; Discussion: gain higher and DeltaF lower with the ROH matrix "at all heritabilities", while the authors admit they saw "no trends using
ROH-based inbreeding coefficients" to assess inbreeding and used pedigree F. It is a mate-allocation study, not OCS.

### 11-B9  Mukiti 2025 (`:38-42`): "Rogers" not in the abstract (UNVERIFIED for that word)
Abstract: "The average genetic distance was 0.303" and clustering used the IBS distance matrix; the word Rogers does not
appear. A different 376-line panel exists (Mahula et al. 2026, 10.1371/journal.pone.0358751: PIC 0.38, MAF 0.28); keep the
two apart. Full text not read (PLoS ONE, open); check whether the 0.303 is modified Rogers.

### 11-B10  Metric-usage table and "roughly 20%" not reproducible here (UNVERIFIED)
`plant_metric_usage.csv` counts are arithmetically consistent with the text (46/687 = 6.7%, 17/687 = 2.5%, 303/687 = 44.1%,
117/687 = 17.0%, 36 of 83 Rogers, ROH 22 with 5 in maize). But the counts come from abstract screening that is not in the repo:
a crude regex over the `metric_used` column of `bibliography_plant.csv` returns 158 population-structure records (not 303), and
only ~11% of records with 3+ metric families (not "roughly 20%"). Counts of 687 / 158 relevance-3 / 197 maize records do
reproduce. Terminology: the table caption and header say "687 relevant" but l.15-17 say 687 *screened*, 158 "directly relevant".
Add a sentence saying the usage counts are cached from the screening, and state how families were defined.

### 11-B11  Pearl millet, "complete inbreeding" (`:75-77`)
Numbers match. Ho = 0.031 is residual heterozygosity, not "complete" inbreeding; "purity control" is the chapter's reading, not the paper's.

### 11-B12  Hybrid mean/dominance claim (`:203-208`, "hybrid mean prediction benefits materially from additive-plus-dominance models") MISSING SOURCE
No source named. One candidate found, conclusion not verified (abstract read only to the model description): Godoy Dos Santos et al. 2026 G3,
10.1093/g3journal/jkag163 (GBLUP multikernel, additive plus non-additive, SS x NSS single crosses). Do not cite until its result is read.

### 11-B13  "appears repeatedly" / "established across crops" (`:162-164`) MISSING SOURCE
"Optimal contribution and optimal cross selection are established across crops" and "a load-bearing qualifier appears repeatedly"
carry no citation; I found one source for "ineluctable" (Sanchez 2023, above). Cite it, plus Gorjanc 2018 (10.1007/s00122-018-3125-3,
bib key `gorjanc2018`, metadata checked: TAG 131: 1953-1966, 2018) for OCS in a crop.

### 11-B14  Allier 2019 key collision risk (not cited here)
The chapter's "UCPC for multi-parental crosses" is Allier, Moreau, Charcosset, Teyssedre, Lehermeier, G3 2019,
10.1534/g3.119.400129. The bib key `allier2019` is a DIFFERENT paper (Allier, Lehermeier, Charcosset, Moreau, Teyssedre,
Front Genet 10: 1006, 2019, 10.3389/fgene.2019.01006, within-family variance in OCS; metadata correct). If the chapter adds `@allier2019` for UCPC it would
point at the wrong paper; add a new key (e.g. `allier2019ucpc`).

## Checked, no finding
- Kadoumi bib metadata (authors, year, volume, article number, DOI).
- Wegary 2019 numbers, Shu 2021, Yang 2025, Cheng 2025, Mufumbo 2022, Choudhury 2021, Huo 2026, Reeves 2020, Arca 2023,
  Mayer 2020, Polzer 2025, Holker 2022, Neyhart 2019, Morales-Gonzalez 2021, Waege 2026, Allendorf 2024, Toro 2019, Meuwissen 2020.
- Internal claims: `f_ij = 1 - MRD^2` (08-pipeline-stages.qmd:92-93); `s1_monitor()` and Trap 3 exist in @sec-stages.
- Comstock 1949: no attribution in this chapter.

## Evidence-level tally
- FULL TEXT: 2 (Kadoumi 2025; Zhao 2023). Kadoumi also checked against Crossref metadata.
- ABSTRACT (or Crossref abstract): 30 sources (Mukiti, Kandarkar, Wegary, White, Shu, Yang, Kumar, Annor, Cheng, Sanchez, Muleta,
  Bernardo, Crain, Fritsche-Neto, Allier G3, Neyhart, Sakurai, Mufumbo, Choudhury, Huo, Reeves, Arca, Mayer, Polzer, Holker,
  Meuwissen (local PDF p.1), Morales-Gonzalez 2021, Waege, Allendorf, Toro, Yadav, Beugnot).
- UNVERIFIED: usage-table counts and "roughly 20%" (11-B10), "Rogers" in Mukiti (11-B9), AlphaMate "most cited" (11-B1), SNP-vs-testcross
  disagreement (11-B1), hybrid additive+dominance claim (11-B12), soybean/wheat variance studies (Wartha/Miller/Oget-Ebrad found by title only), Bhat 2024 HSGCA, cassava dos Santos 2023 (abstract read, "distance-based" confirmed).
- Not found: none (every claim except those listed was traced to a paper).
Sources looked at, in order: local copies (reference/papers: Meuwissen 2020), PubMed/PMC full text (Kadoumi PMC12397178, Zhao PMC10262571), Europe PMC, Crossref, Consensus.
