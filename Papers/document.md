DeBeukelaeretal.BMCBioinformatics (2018) 19:203
https://doi.org/10.1186/s12859-018-2209-z
RESEARCH ARTICLE OpenAccess
Core Hunter 3: flexible core subset
selection
HermanDeBeukelaer1* ,GuyFDavenport2andVeerleFack1
Abstract
Background: Core collectionsprovidegenebankcuratorsandplantbreedersawaytoreducesizeoftheir
collectionsandpopulations,whileminimizingimpactongeneticdiversityandallelefrequency.Manymethodshave
beenproposedtogeneratecorecollections,oftenusingdistancemetricstoquantifythesimilarityoftwoaccessions,
basedongeneticmarkerdataorphenotypictraits.CoreHunterisamulti-purposecoresubsetselectiontoolthatuses
localsearchalgorithmstogeneratesubsetsrelyingononeormoremetrics,includingseveraldistancemetricsand
allelicrichness.
Results: Inversion3ofCoreHunter(CH3)wehaveincorporatedtwonew,improvedmethodsforsummarizing
distancestoquantifydiversityorrepresentativenessofthecorecollection.AcomparisonofCH3andCoreHunter2
(CH2)showedthatthesenewmetricscanbeeffectivelyoptimizedwithlesscomplexalgorithms,ascomparedto
thoseusedinCH2.CH3ismoreeffectiveatmaximizingtheimproveddiversitymetricthanCH2,stillensuresahigh
averageandminimumdistance,andisfasterforlargedatasets.UsingCH3,asimplestochastichill-climberisableto
findhighlydiversecorecollections,andthemoreadvancedparalleltemperingalgorithmfurtherincreasesthequality
ofthecoreandfurtherreducesvariabilityacrossindependentsamples.WealsoevaluatetheabilityofCH3to
simultaneouslymaximizediversity,andeitherrepresentativenessorallelicrichness,andcomparetheresultswith
thoseoftheGDOptandSimElimethods.CH3cansampleequallyrepresentativecoresasGDOpt,whichwas
specificallydesignedforthispurpose,andisabletoconstructcoresthataresimultaneouslymorediverse,andeither
aremorerepresentativeorhavehigherallelicrichness,thanthoseobtainedbySimEli.
Conclusions: In version3,CoreHunterhasbeenupdatedtoincludetwonewcoresubsetselectionmetricsthat
constructcoresforrepresentativenessordiversity,withimprovedperformance.Itcombinesandoutperformsthe
strengthsofothermethods,asit(simultaneously)optimizesavarietyofmetrics.Inaddition,CH3isanimprovement
overCH2,withtheoptiontousegeneticmarkerdataorphenotypictraits,orboth,andimprovedspeed.CoreHunter
3isfreelyavailableonhttp://www.corehunter.org.
Keywords: Corecollections,Multi-objective,Localsearchheuristics
Background working)andbasecollections.Examplesofactivecollec-
Genebanks were established by national or international tionsincludeseedstoresorliveplantsthatcanbeaccessed
breeding,orconservationprogramswiththegoaltosafe- quicklybyplantbreedersandresearchersthroughgermi-
guardgeneticdiversityforfutureuse.Manybreedingpro- nation or clonal propagation. In contrast, accessions in
grams have established genebanks as a resource for new base collections are held in long-term storage, such as
variationinthecropstheybreed,allowingthemtoreact cryopreservation,andrequiresometimeforregeneration
tochangingenvironmentsandemergingbioticandabiotic andpropagationbeforebeingmadeavailable.
stresses. Accessions are often divided between active (or During the last few decades the collections stored in
genebanks have grown enormously, and cost of main-
*Correspondence:herman.debeukelaer@ugent.be tainingviablegermplasmwithingenebankshasincreased.
1DepartmentofAppliedMathematics,ComputerScienceandStatistics,Ghent Genebank curators must make decisions about which
University,Krijgslaan281S9,9000Gent,Belgium
accessionstomaintainintheactivecollectionversusthe
Fulllistofauthorinformationisavailableattheendofthearticle
base collection, and may even consider not maintaining
©TheAuthor(s).2018OpenAccessThisarticleisdistributedunderthetermsoftheCreativeCommonsAttribution4.0
InternationalLicense(http://creativecommons.org/licenses/by/4.0/),whichpermitsunrestricteduse,distribution,and
reproductioninanymedium,providedyougiveappropriatecredittotheoriginalauthor(s)andthesource,providealinktothe
CreativeCommonslicense,andindicateifchangesweremade.TheCreativeCommonsPublicDomainDedicationwaiver
(http://creativecommons.org/publicdomain/zero/1.0/)appliestothedatamadeavailableinthisarticle,unlessotherwisestated.

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page2of12
an accession at all. The concept of a core collection was [16]. The genetic distance sampling strategy constructs
introducedtohelpwiththesedecisions,andisdefinedas cores with a given minimum distance between selected
subset of the complete collection which most represents accessions by repeatedly including a random acces-
thediversityoftheentirecollectionwithminimumredun- sion and removing all others within a certain sampling
dancy[1].Genebankcuratorscanusecorecollectionsto radius[17].
definetheactivecollectionoverthebasecollection.Core CoreHunterwasdesignedtomeetthevarietyofcrite-
collections can also be used to aid researchers and plant riausedtoevaluatecorecollectionsfordifferentpurposes,
breeders in the choice of starting material. For example, and supports optimization of several of these metrics,
the potential for use of core collections has been shown using flexible local search algorithms [18]. Core Hunter
forassociationstudies[2,3]. can construct core collections for specific applications,
A variety of measures have been used to evaluate core and combines multiple objectives to bring the different
collections based on genetic marker data or phenotypic perspectives closer together, for example by simultane-
traits, including pairwise distances and allelic richness. ously maximizing genetic dissimilarity and allelic rich-
The choice of the most appropriate evaluation measure ness.AlthoughCoreHunterismainlyfocusedatfixedsize
dependsonthepurposeofthecorecollection[4].Some- core subset selection, version 1 and 2 allowed to spec-
times core collections are sampled based on a combi- ifyaminimumandmaximumsizeandpreferredsmaller
nation of both genotypes and phenotypes [5–7]. Many cores with the same value. Core Hunter was shown to
methodshavebeenproposedtosamplehighqualitycore outperform stratified sampling strategies, MSTRAT and
collections according to the measure(s) of interest. The PowerCore.
first methods were stratified sampling techniques that It has been assumed that, to obtain a diverse core, the
cluster the accessions, based on distance matrices calcu- averagedistancebetweenitsentriesshouldbemaximized
lated from their allele scores or phenotypic trait values, [9,18].However,ahighentry-to-entrydistancedoesnot
andthenselectseveralaccessionsfromeachclusterusing guarantee that selected accessions are sufficiently differ-
acertainallocationmethod.Brownsuggestedtorandomly ent,anditisknownthatmaximizingthiscriterionover-
selecteitheraconstant(C)numberofaccessionsperclus- represents extreme values [4, 19]. Core Hunter 2 (CH2)
ter,oranumberproportional(P)tothesizeorlogarithm deals with this issue by also maximizing the minimum
(L)ofthesizeofthecluster,andarguedthattheL-method distancebetweenselectedaccessions[19].Althoughaver-
ispreferred[8].Itwaslatershownthatmorediversecores age distance and allelic richness can be effectively opti-
are obtained when the number of included accessions is mizedusingsimpleandfastlocalsearchalgorithms,such
proportionaltothewithin-clusterdiversity[9]. as a stochastic hill-climber, a more complex and slower
Anotherallocationmethod,theM-method,maximizes mixedreplicasearch(MixRep)wasrequiredtomaximize
the probability to retain all observed alleles in order to minimum distance in the Core Hunter framework. The
construct cores with high allelic richness [10]. This idea MixRepalgorithmrunsmultipletypesofstochasticlocal
led to the development of the MSTRAT software, which searches in parallel, as well as a constructive algorithm
implements a generalized M-method that directly sam- (LR) that starts from an empty selection that is itera-
plesfromtheentirecollectiontomaximizeallelicrichness tivelyextended.Incaseanactivesearchisunabletofind
withasimplehill-climbingalgorithm[11].Otherheuris- any further improvements, it is terminated and replaced
tics work by repeatedly removing one of the two most with a new local search engine starting from a selection
similar accessions from the collection until the desired thatisobtainedbycombiningtwopreviouslyfoundhigh-
core size is obtained, either randomly (least distance quality selections, in an attempt to further explore other
stepwise sampling [12]), or using a specific elimination interesting regions of the search space, as in a genetic
criterionmaximizingthedistancetotheremainingacces- algorithm[20].
sionsorexpectedheterozygosityofthereducedcollection Another approach to maximize diversity, while at the
(SimEli) [13]. The genetic distance optimization strategy sametimeavoidinginclusionoftoosimilaraccessionsat
(GDOpt)wasdesignedtoconstructhighlyrepresentative theextremesofthecollection,istomaximizetheaverage
cores,inwhicheachaccessionfromtheentirecollection distance between each entry and the closest other entry
is represented by a similar core entry [14]. GDOpt par- in the core, as proposed by Odong et al. [4]. The SimEli
titions the data around a number of identified medoids, algorithm was shown to outperform Core Hunter 2 in
which are then selected as the core entries. Methods terms of this new entry-to-nearest-entry (E-NE) metric.
for variable size core sampling have also been devel- Alternatively, one may desire to optimally represent the
oped. PowerCore minimizes the size of the core, while individualaccessions,insteadofthewholerangeofdiver-
covering all observed marker alleles and/or trait values sity.Insuchcase,Odongetal.reccomendtominimizethe
[15]. GenoCore was developed for the same purpose, averagedistancebetweeneachaccessioninthefullcollec-
and specifically tailored to high-density marker datasets tionandthemostsimilaraccessioncontainedinthecore.

| DeBeukelaeretal.BMCBioinformatics |     |     |     |  (2018) 19:203  |     |     |     |     |     |     |     |     |     | Page3of12 |
| --------------------------------- | --- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --------- |
The GDOpt strategy was specifically developed to mini- Evaluationmeasures
mize this accession-to-nearest-entry (A-NE) metric, and CoreHunter3includesvariousevaluationmeasuresthat
showntooutperformbothCoreHunter2andSimElifor can be selected as optimization objectives, including but
thispurpose[13,14]. not limited to those described below. We refer to the
WeintroduceCoreHunter3(CH3),whichincorporates website http://www.corehunter.org for an overview of all
the two improved methods for summarizing distances, providedmeasures.
| entry-to-nearest-entry |     |     | (E-NE) | and | accession-to-nearest- |     |     |     |     |     |     |     |     |     |
| ---------------------- | --- | --- | ------ | --- | --------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Distancemeasures
entry(A-NE),proposedbyOdongetal.[4].CH3attempts
to find the maximum entry-to-nearest-entry distance to WeusedtheModifiedRoger’sdistance[18,21]toassess
|                |        |         |     |                            |     |     |     | the dissimilarity |     | of accessions |     | based | on genetic | marker |
| -------------- | ------ | ------- | --- | -------------------------- | --- | --- | --- | ----------------- | --- | ------------- | --- | ----- | ---------- | ------ |
| obtain diverse | cores, | whereas |     | accession-to-nearest-entry |     |     |     |                   |     |               |     |       |            |        |
data.ForphenotypictraitsweusedGower’sdistance[22]
| distance | is minimized |     | to represent |     | as much | as possible |     |     |     |     |     |     |     |     |
| -------- | ------------ | --- | ------------ | --- | ------- | ----------- | --- | --- | --- | --- | --- | --- | --- | --- |
all accessions from the entire collection. More specifi- which simultaneously takes into account qualitative and
|     |     |     |     |     |     |     |     | quantitative | traits. | Pairwise | distances |     | are aggregated | as  |
| --- | --- | --- | --- | --- | --- | --- | --- | ------------ | ------- | -------- | --------- | --- | -------------- | --- |
cally,CH3cansamplefixedsizecoresbasedonmolecular
|                  |               |       |                |               |          |          |        | follows to  | evaluate | the | diversity | or representativeness |     | of  |
| ---------------- | ------------- | ----- | -------------- | ------------- | -------- | -------- | ------ | ----------- | -------- | --- | --------- | --------------------- | --- | --- |
| marker data,     | phenotypic    |       | traits,        | a precomputed |          | distance |        |             |          |     |           |                       |     |     |
| matrix, or       | a combination |       | of             | these.        | The      | distance | matrix | thecore[4]: |          |     |           |                       |     |     |
| can be generated |               | using | an appropriate |               | measure, | such     | as     | •           |          |     |           |                       |     |     |
Entry-to-nearest-entry(E-NE):theaveragedistance
| Modified | Roger’s | distance | for | genotypes |     | [21] or Gower’s |     |     |     |     |     |     |     |     |
| -------- | ------- | -------- | --- | --------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- | --- |
betweeneachselectedaccessionandtheclosestother
| distance | for phenotypes |     | [22]. | As  | in previous | versions, |     |     |     |     |     |     |     |     |
| -------- | -------------- | --- | ----- | --- | ----------- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
coreentry.Thiscriterioncanbemaximizedto
CoreHunter3canalsomaximizeallelicrichness,aswell
constructhighlydiversecoresinwhichallaccessions
| as a combination |     | of multiple |     | metrics. | In  | particular, | we  |     |     |     |     |     |     |     |
| ---------------- | --- | ----------- | --- | -------- | --- | ----------- | --- | --- | --- | --- | --- | --- | --- | --- |
aremaximallydifferent.
| assess whether |     | the new | distance-based |     | E-NE | and | A-NE | •   |     |     |     |     |     |     |
| -------------- | --- | ------- | -------------- | --- | ---- | --- | ---- | --- | --- | --- | --- | --- | --- | --- |
Accession-to-nearest-entry(A-NE):themean
metricscanbeeffectivelyoptimizedusingfastlocalsearch
distancebetweeneachaccessionfromtheentire
algorithms,andwhethermaximizingE-NEindirectlyalso
collectionandthemostsimilarcoreentry,including
| yields a | high minimum |     | distance, |     | without | the need | for |     |     |     |     |     |     |     |
| -------- | ------------ | --- | --------- | --- | ------- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
itselfincasetheaccessionhasbeenselected.
| a more complex |     | algorithm. |     | Furthermore, |     | we assess | the |     |     |     |     |     |     |     |
| -------------- | --- | ---------- | --- | ------------ | --- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
Minimizingthiscriterionyieldscoresthatmaximally
| ability of | Core | Hunter | 3 to | simultaneously |     | maximize | E-  |     |     |     |     |     |     |     |
| ---------- | ---- | ------ | ---- | -------------- | --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
representallindividualaccessions.
| NE and | A-NE, | or E-NE | and | allelic | richness, | and | com- |     |     |     |     |     |     |     |
| ------ | ----- | ------- | --- | ------- | --------- | --- | ---- | --- | --- | --- | --- | --- | --- | --- |
pare the results with those obtained with Core Hunter WhencomparingCH3withCH2wealsoevaluatedthe
2, GDOpt, and SimEli, for three marker datasets with minimumdistance(DMIN)betweenselectedaccessions,
| different | allelic | composition |     | and varying |     | size, and | one |          |        |              |     |          |             |       |
| --------- | ------- | ----------- | --- | ----------- | --- | --------- | --- | -------- | ------ | ------------ | --- | -------- | ----------- | ----- |
|           |         |             |     |             |     |           |     | but this | is not | an objective |     | that can | be directly | opti- |
phenotypictraitdataset.CoreHunter3isavailableasan mized by CH3, for reasons explained in the discussion.
R package corehunter on CRAN and as an open source A detailed description and comparison of the E-NE and
| project on | GitHub. | A   | prototype | graphical |     | user interface |     |     |     |     |     |     |     |     |
| ---------- | ------- | --- | --------- | --------- | --- | -------------- | --- | --- | --- | --- | --- | --- | --- | --- |
A-NEmetricsareprovidedin[4].
| isalsoavailable.Seehttp://www.corehunter.org |     |     |     |     |     | formore |     |                 |        |         |          |          |         |          |
| -------------------------------------------- | --- | --- | --- | --- | --- | ------- | --- | --------------- | ------ | ------- | -------- | -------- | ------- | -------- |
| information.                                 |     |     |     |     |     |         |     | Allelicrichness |        |         |          |          |         |          |
|                                              |     |     |     |     |     |         |     | To evaluate     | the    | allelic | richness | of cores | sampled | based    |
| Methods                                      |     |     |     |     |     |         |     | on genetic      | marker | data,   | we used  | the      | average | expected |
Coreselectionproblem heterozygosity(HE)perlocus[18,23],calculatedas
A
Given a collection that contains n accessions, and a (cid:3) (cid:4)
|                                                    |              |     |                                |     |     |     |     |                                        |         | (cid:2)L | (cid:2)nl |        |               |             |
| -------------------------------------------------- | ------------ | --- | ------------------------------ | --- | --- | --- | --- | -------------------------------------- | ------- | -------- | --------- | ------ | ------------- | ----------- |
| desiredcoresize1<                                  |              | k   | < n,thefeasiblesolutionspaceof |     |     |     |     |                                        | 1       |          |           |        |               |             |
|                                                    |              |     |                                |     |     |     |     | 0≤HE=                                  |         | 1−       | pˆ2       | ≤1     |               |             |
| possiblecoresubsetsisdefinedas                     |              |     |                                |     |     |     |     |                                        | L       |          |           | la     |               |             |
|                                                    |              |     |                                |     |     |     |     |                                        |         | l=1      | a=1       |        |               |             |
| (cid:2)={C                                         | |C ⊂A∧|C|=k} |     |                                |     |     |     |     |                                        |         |          |           |        |               |             |
|                                                    |              |     |                                |     |     |     |     | whereListhenumberofmarkers(loci),n     |         |          |           |        | l isthenumber |             |
|                                                    |              |     |                                |     |     |     |     | of observed                            | alleles | at       | the lth   | locus, | and pˆ2       | is the fre- |
| where|C|denotesthesizeofthesubset.Thecoreselection |              |     |                                |     |     |     |     |                                        |         |          |           |        | l a           |             |
|                                                    |              |     |                                |     |     |     |     | quencyoftheathalleleatthelthlocusinthe |         |          |           |        | s             | electedcore |
problemthenconsistsoffindinganoptimalsubsetC∗
∈(cid:2)
collection.
| thatmaximizesacertainevaluationmeasureF(C) |     |     |     |     |     |     | (cid:2) → |     |     |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- | --- | --------- | --- | --- | --- | --- | --- | --- | --- |
:
| R,i.e. |     |     |     |     |     |     |     | Weightedindexandnormalization |     |     |     |     |     |     |
| ------ | --- | --- | --- | --- | --- | --- | --- | ----------------------------- | --- | --- | --- | --- | --- | --- |
Asinpreviousversions,CoreHuntercansimultaneously
C∗
| =argmaxF(C). |     |     |     |     |     |     |     | optimizekmeasuresbymaximizingaweightedindex |     |     |     |     |     |     |
| ------------ | --- | --- | --- | --- | --- | --- | --- | ------------------------------------------- | --- | --- | --- | --- | --- | --- |
C∈(cid:2)
(cid:2)k
In case the evaluation measure F(C) is intended to be F(c)= αF(c)
i i
minimized,thiscanbeachievedbymaximizing−F(C).
i=1

| DeBeukelaeretal.BMCBioinformatics |     |     |     |  (2018) 19:203  |     |     |     |     |     |     |     |     |     | Page4of12 |
| --------------------------------- | --- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --------- |
<
whereF istheithincludedevaluationmeasureand0 Algorithm1Randomdescent.
i
| α < 1    | is the | weight | assigned | to  | this objective, | with |        |            |     | A,   |      |                 |     |         |
| -------- | ------ | ------ | -------- | --- | --------------- | ---- | ------ | ---------- | --- | ---- | ---- | --------------- | --- | ------- |
| (cid:5)i |        |        |          |     |                 |      | Input: | collection |     | core | size | (k), evaluation |     | measure |
k
α = 1. In case of a measure F that is to be F(C), neighbourhood N(C) : (cid:2) → P((cid:2)) with (cid:2) =
| i=1 i |     |     |     |     | i   |     |     |     |     |     |     |     |     |     |
| ----- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
minimized, such as A-NE, it is transformed into a max- {C |C ⊂A∧|C|=k}
|           |           |     | (cid:8) = −F |        |                |        |         |     | bestfoundcoreC∗ |     | ∈(cid:2) |     |     |     |
| --------- | --------- | --- | ------------ | ------ | -------------- | ------ | ------- | --- | --------------- | --- | -------- | --- | --- | --- |
| imization | objective | F   |              | i when | it is included | in the | Output: |     |                 |     |          |     |     |     |
i
| weighted | index. | The | individual | measures |     | are automati- |     |     |     |     |     |     |     |     |
| -------- | ------ | --- | ---------- | -------- | --- | ------------- | --- | --- | --- | --- | --- | --- | --- | --- |
1: C ←randomelementof(cid:2)
| callynormalizedto[0,1],followingtheParetominimum |     |     |     |     |     |     |     | repeat |     |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- | --- | --- | ------ | --- | --- | --- | --- | --- | --- |
2:
based upper-lower-bound approach as described in [24], pickrandomneighbourC(cid:8) ∈N(C)
3:
toensureafairbalancebetweentheincludedobjectives,
ifF(C(cid:8))>F(C)then
4:
| independent | of  | their | original | range. | More | information |     |     | C ←C(cid:8) |     |     |     |     |     |
| ----------- | --- | ----- | -------- | ------ | ---- | ----------- | --- | --- | ----------- | --- | --- | --- | --- | --- |
5:
| about this | normalization |     | is  | provided | in the | documenta- |     |     |     |     |     |     |     |     |
| ---------- | ------------- | --- | --- | -------- | ------ | ---------- | --- | --- | --- | --- | --- | --- | --- | --- |
6: endif
| tionoftheRpackage. |     |     |     |     |     |     |     | untilstopconditionsatisfied |     |     |     |     |     |     |
| ------------------ | --- | --- | --- | --- | --- | --- | --- | --------------------------- | --- | --- | --- | --- | --- | --- |
7:
returnC
8:
Coresamplingalgorithms
| We evaluate | the         | performance |          | of three    | general | purpose    |                                          |             |     |           |          |                |     |           |
| ----------- | ----------- | ----------- | -------- | ----------- | ------- | ---------- | ---------------------------------------- | ----------- | --- | --------- | -------- | -------------- | --- | --------- |
| selection   | heuristics  | to          | optimize | the         | chosen  | evaluation |                                          |             |     |           |          |                |     |           |
|             |             |             |          |             |         |            | higher                                   | probability |     | to accept | inferior | modifications, |     | simi-     |
| measure     | or weighted |             | index    | for a fixed | core    | size: ran- |                                          |             |     |           |          |                |     |           |
|             |             |             |          |             |         |            | lartothefrequentlyusedsimulatedannealing |             |     |           |          |                |     | algorithm |
domdescent,paralleltempering,andageneticalgorithm.
[25].Theacceptancefunctioniscommonlydefinedas
| Based on | the | findings | in this | study, | only the | former two |     |     |     |     |     |     |     |     |
| -------- | --- | -------- | ------- | ------ | -------- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- |
(cid:6)
wereincludedinCoreHunter3,whichdefaultstothepar- 1 if(cid:4)>0
p((cid:4),t)=
allel tempering algorithm, but also provides a fast mode (cid:4)/t
|          |            |     |         |           |     |               |     |     | e   | else |     |     |     |     |
| -------- | ---------- | --- | ------- | --------- | --- | ------------- | --- | --- | --- | ---- | --- | --- | --- | --- |
| in which | the random |     | descent | algorithm | is  | applied. Note |     |     |     |      |     |     |     |     |
F(C(cid:8))
that these two stochastic local search algorithms were where (cid:4) = − F(C) and t is the temperature of
|     |     |     |     |     |     |     |     |     |     | i   | i   |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
also available in CH2, although they were not used by thereplica.Thisacceptancefunctionensuresthatneigh-
default.Thesearchalgorithmsareexecuteduntileitheran bours with a better score are always accepted, whereas
absolute runtime limit has been exceeded, or no further inferior neighbours are accepted at a probability that
| improvements |     | were | obtained | during | a certain | amount |               |     |           |     |        |          |             |       |
| ------------ | --- | ---- | -------- | ------ | --------- | ------ | ------------- | --- | --------- | --- | ------ | -------- | ----------- | ----- |
|              |     |      |          |        |           |        | exponentially |     | decreases |     | as the | solution | gets poorer | or as |
oftime. the temperature is decreased. In addition, searches with
|     |     |     |     |     |     |     | similar | temperature |     | periodically |     | exchange | their | current |
| --- | --- | --- | --- | --- | --- | --- | ------- | ----------- | --- | ------------ | --- | -------- | ----- | ------- |
Randomdescent
|     |     |     |     |     |     |     | selection, |     | which | has the | effect | to push | the most | promis- |
| --- | --- | --- | --- | --- | --- | --- | ---------- | --- | ----- | ------- | ------ | ------- | -------- | ------- |
ThisbasiclocalsearchoutlinedinAlgorithm1startswith
|     |     |     |     |     |     |     | ing | solutions | towards |     | the coolest | searches |     | to promote |
| --- | --- | --- | --- | --- | --- | --- | --- | --------- | ------- | --- | ----------- | -------- | --- | ---------- |
arandomselectionofthedesiredsizeandtheniteratively
|     |     |     |     |     |     |     | convergence |     | towards | a   | common | solution, | and | the worst |
| --- | --- | --- | --- | --- | --- | --- | ----------- | --- | ------- | --- | ------ | --------- | --- | --------- |
triestoimproveitsqualitybyslightlymodifyingthecore.
|     |     |     |     |     |     |     | solutions |     | towards | the hottest |     | searches | allowing | them to |
| --- | --- | --- | --- | --- | --- | --- | --------- | --- | ------- | ----------- | --- | -------- | -------- | ------- |
Theobtainedsimilarselection,referredtoasaneighbour escape from local optima. The probability that replica r
| of the current |           | selection, | is  | accepted        | if and | only if it has |     | +1  |           |       |         |           |     |          |
| -------------- | --------- | ---------- | --- | --------------- | ------ | -------------- | --- | --- | --------- | ----- | ------- | --------- | --- | -------- |
|                |           |            |     |                 |        |                | and | r   | will swap | their | current | selection | is  | commonly |
| a higher       | objective | function   |     | value according |        | to the cho-    |     |     |           |       |         |           |     |          |
definedas
| senevaluationmeasure.Otherwise,anothermoveistried |     |     |     |     |     |     |     |     |     | (cid:7) |     |     |     |     |
| ------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------- | --- | --- | --- | --- |
if(cid:4)>0
| from the | current | selection. |     | Core Hunter |     | uses a single- |     |           |     | 1   |         |         |     |     |
| -------- | ------- | ---------- | --- | ----------- | --- | -------------- | --- | --------- | --- | --- | ------- | ------- | --- | --- |
|          |         |            |     |             |     |                |     | q((cid:4) |     | )=  | (cid:8) | (cid:9) |     |     |
swapneighbourhood,i.e.considersallneighboursthatcan r ,t r ,t r+1 1− 1 (cid:4)
tr tr+1
|             |      |     |         |           |     |               |     |     |     | e   |     | else |     |     |
| ----------- | ---- | --- | ------- | --------- | --- | ------------- | --- | --- | --- | --- | --- | ---- | --- | --- |
| be obtained | from | the | current | selection | by  | replacing one |     |     |     |     |     |      |     |     |
selectedaccessionwithacurrentlyunselectedaccession. with(cid:4) = F(C )−F(C ).Assuch,ifthecurrentselec-
|     |     |     |     |     |     |     |     | r   | r+1 |     | r   |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
tionofreplicar+1hasabetterobjectivefunctionvalue
Paralleltempering
thanthatoftherthreplica,thesearealwaysswapped.In
Algorithm 2 describes the more advanced parallel tem- addition, similar to the probabilistic acceptance of infe-
pering method [18], also referred to as replica exchange riorneighbours,swapsthatpushsolutionsintheopposite
Monte Carlo (REMC), which consists of multiple coop- direction may also be performed—yet with a probability
erating local searches that are executed in parallel. Each that decreases for a larger difference in objective func-
searchperformsthesameprocedureasrandomdescent, tionvalueandreplicatemperature.Theparalleltempering
=
but may also accept inferior modifications to be able to algorithmimplementedinCoreHunter(cid:10)3consistso(cid:11)fp
escapefromlocaloptima,i.e.tofurtherimprovethecur- 10searcheswithatemperaturerangeof 10 −8,10 −4 ,and
rent selection even if none of the considered neighbours usesthesamesingle-swapneighbourhoodastherandom
has a better score. For this purpose, the search repli- descent method described above. The number of replica
catesareassignedfixed,increasingtemperatures,equally steps per iteration is fixed to q = 500, and the default
spread in a given range. A higher temperature leads to a acceptanceandswapfunctionsareapplied.

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page5of12
Algorithm2Paralleltempering. Selection (SELECT).Werandomlypickedfivecandidates
Input: collection A, core size (k), evaluation measure from the current population, from which the one
F(C), neighbourhood N(C) : (cid:2) → P((cid:2)) with withthehighestobjectivefunctionvaluewaschosen
(cid:2) = {C |C ⊂A∧|C|=k}, number of replicas (p), asaparent(tournamentselection).
temperature range [t ,t ], acceptance function Crossover (CROSS). A child was created from two par-
min max
p((cid:4),t), swap function q((cid:4),t ,t ), number of replica entsbyrepeatedlyaddinganarbitraryaccessionthat
1 2
stepsperiteration(q) isselectedineitherparentsolution(atrandomwith
Output: bestfoundcoreC∗ ∈(cid:2) equal probability) until the desired core size was
obtained.
1: forifrom1topdo
2: t i ←t min + p i− − 1 1 (t max −t min ) Muta t t h io e n ran (M do U m TA d T es E c ). en A t s h m eu u r t is a t t i i c on de o s p cr e i r b a e t d or ab w o e ve a , p s p t l a i r e t d -
3:
C
i
←randomelementof(cid:2)
ing from the given solution, until no improvement
4: endfor
wasfoundinthelast5000steps.
5:
C
best
←argmax
1≤i≤p
F(C
i
)
Survival (SURVIVE). We applied a roulette selection to
6:
s←0
discard five solutions in each step, so that the pop-
7: repeat
ulation size remained fixed over all generations. A
8: forifrom1top(inparallel)do solutionC wasassignedaweightof1/F(C)meaning
9: repeatqtimes
that the probability that it is discarded is inversely
10:
pickrandomneighbourC
i
(cid:8) ∈N(C
i
)
proportionaltoitsfitness.
11:
compute(cid:4)
i
←F(C
i
(cid:8))−F(C
i
)
12: withprobabilityp((cid:4) i ,t i ):setC i ←C i (cid:8)
13:
ifF(C
i
)>F(C
best
)then
C ←C Algorithm3Geneticalgorithm.
14: best i
15: endif Input: collection A, core size (k), evaluation measure
16: endrepeat F(C),populationsize(p),numberofchildrenpergen-
17: endfor eration (c), selection operator SELECT : (cid:2)p → (cid:2)
18: r←s+1 with (cid:2) = {C |C ⊂A∧|C|=k}, crossover operator
19:
whiler<pdo CROSS:(cid:2)2 →(cid:2),mutationoperatorMUTATE:(cid:2)→
20:
compute(cid:4)
r
←F(C
r+1
)−F(C
r
) (cid:2),survivaloperatorSURVIVE:(cid:2)p+c →(cid:2)p
21: with probability q((cid:4) r ,t r ,t r+1 ): swap C r and Output: bestfoundcoreC∗ ∈(cid:2)
C
r+1
1:
pop←∅
22:
r←r+2
2: forifrom1topdo
23: endwhile
3:
addrandomelementof(cid:2)topop
24:
s←1−s
4: endfor
2 2 5 6 : : u re n t t u il rn sto C p bes c t onditionsatisfied 5 6 : : C re b p es e t a ← t argmax C∈pop F(C)
7:
children←∅
8: forifrom1toc(inparallel)do
9:
P
1
←SELECT (pop)
Geneticalgorithm 10:
P
2
←SELECT (pop)
To assess the potential improvement of a global opti- 11:
C ←MUTATE (CROSS (P
1
,P
2
))
mization engine over a local search we also applied the 12:
addCtochildren
genetic algorithm [20] outlined in Algorithm 3. Here, 13: endfor
a population of initially randomly generated solutions 14:
forC ∈childrendo
(cores) is maintained. In every step, new child solutions 15:
addCtopop
are produced by combining two randomly chosen par- 16:
ifF(C)>F(C
best
)then
C ←C
ent solutions(crossover),followedbyoneormoreswaps 17: best
ofaccessions(mutation)betweentheunselectedandthe 18: endif
selected subset. These children are added to the pop- 19: endfor
ulation, and certain solutions are discarded to simulate 20:
pop←SURVIVE (pop)
survivalofthefittestindividualsinnaturalevolution.For 21: untilstopconditionsatisfied
ourexperimentsweusedapopulationsizeofp=25and
22:
returnC
best
generated c = 5 children in each step (in parallel). We
appliedthefollowingoperators:

| DeBeukelaeretal.BMCBioinformatics |     |     |     |  (2018) 19:203  |     |     |     |     |     |     |     |     |     | Page6of12 |
| --------------------------------- | --- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --------- |
ComparisonwithGDOptandSimEli Rthroughthepackagecorehunter(https://cran.r-project.
For the GDOpt selection strategy [14], we used the org/package=corehunter).GDOpt,SimEli,andallcompu-
k-medoids algorithm of Kaufman and Rousseuw [26] tational experiments were implemented in R v3.3.1 [31].
through the R function pam, to identify a representative Note that the R function pam used in GDOpt calls a C
corecollection.Thenumberofclusterswaschosenequal function which performs the actual partitioning. Exper-
to the desired core size and the returned medoids were iments were executed on a computing server with two
selectedascoreaccessions.WealsoimplementedSimEli 10-core Intel E5-2660v3 (2.6 GHz) CPUs and 128 GB
| in R, considering |       | both | elimination | criteria | suggested | in     | RAM. |     |     |     |     |     |     |     |
| ----------------- | ----- | ---- | ----------- | -------- | --------- | ------ | ---- | --- | --- | --- | --- | --- | --- | --- |
| [13]. In each     | step, | one  | of the      | two most | similar   | acces- |      |     |     |     |     |     |     |     |
Results
| sions was | eliminated, | maximizing |     | either | the average | dis- |     |     |     |     |     |     |     |     |
| --------- | ----------- | ---------- | --- | ------ | ----------- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
tance to the remaining accessions (SimEli-A-RA) or the OptimizingE-NEandA-NEwithlocalsearches
expectedheterozygosityofthereducedcollection(SimEli- We sampled 10 cores from each dataset using random
HE),untilthedesiredcoresizewasobtained.Thesource descent, parallel tempering, and the described genetic
code for these implementations is available on GitHub algorithm, configured to maximize E-NE with a runtime
(corehunter/corehunter3-paper). limitof30min.Table1showsmeanvaluesandstandard
deviationsoftheobtainedcores.Theresultsindicatethat
Datasets parallel tempering yields the highest E-NE values, with
We used four datasets of varying size and composition the lowest variability across independent samples. Vari-
to compare the performance of different core sampling ability in solution quality is always at least one order of
algorithms: magnitude below that observed for random descent and
thegeneticalgorithm.Still,variabilityisalreadyquitelow
1 Ricedata:1000accessionsforwhich39phenotypic
whenusingthebasicrandomdescentheuristic.Although
traitswererecorded,including28qualitativeand11
|     |     |     |     |     |     |     | the genetic | algorithm |     | also | outperforms |     | random | descent, |
| --- | --- | --- | --- | --- | --- | --- | ----------- | --------- | --- | ---- | ----------- | --- | ------ | -------- |
quantitativetraits.AvailablefromthePowerCore
itisnotaseffectiveasparalleltempering.Weperformed
project[15]andpreviouslyusedtoassessthe a pairwise comparison of the results obtained with the
performanceofseveralothercoresampling
|     |     |     |     |     |     |     | three applied | methods, |     | for | the four | considered |     | datasets, |
| --- | --- | --- | --- | --- | --- | --- | ------------- | -------- | --- | --- | -------- | ---------- | --- | --------- |
algorithms,includingSimEli[13].
|     |     |     |     |     |     |     | using a | Wilcoxon | rank-sum |     | test | [32]. The | twelve | result- |
| --- | --- | --- | --- | --- | --- | --- | ------- | -------- | -------- | --- | ---- | --------- | ------ | ------- |
2 Coconutdata:1014accessionscharacterizedusing
ingp-valueswereadjustedformultipletestingtocontrol
30crop-specificSSRmarkers.Usedinmultiple
|     |     |     |     |     |     |     | the family-wise |     | error | rate (FWER) |     | using | Holm’s | method |
| --- | --- | --- | --- | --- | --- | --- | --------------- | --- | ----- | ----------- | --- | ----- | ------ | ------ |
previouscoreselectionstudies[4,13,14]. [33].Alldifferenceswerestatisticallysignificantattheα =
3 Maizedata:1250accessionscharacterizedwith1117
0.05confidencelevel,withadjustedp-valuesrangingfrom
SNPmarkers.DistributedaspartoftheRpackage
0.00013to0.00049.Figure1displaysconvergencecurves
synbreedData[27].
|     |     |     |     |     |     |     | of the three | applied |     | algorithms, |     | again | averaged | over 10 |
| --- | --- | --- | --- | --- | --- | --- | ------------ | ------- | --- | ----------- | --- | ----- | -------- | ------- |
4 Peadata:4428accessionscharacterizedby17RBIP
|     |     |     |     |     |     |     | runs, for | the large | pea | dataset. | These | plots | confirm | that |
| --- | --- | --- | --- | --- | --- | --- | --------- | --------- | --- | -------- | ----- | ----- | ------- | ---- |
markers[28,29].Previouslyusedtocomparethe
allalgorithmsareabletoiterativelyimproveanarbitrarily
performanceofCoreHunter2withothercore
|     |     |     |     |     |     |     | bad random | selection |     | to reach | a   | high E-NE | value. | Again |
| --- | --- | --- | --- | --- | --- | --- | ---------- | --------- | --- | -------- | --- | --------- | ------ | ----- |
samplingalgorithmsforlargedatasets[19].
|            |         |        |               |     |             |         | we see        | that parallel |         | tempering | yields    | the      | highest-quality |            |
| ---------- | ------- | ------ | ------------- | --- | ----------- | ------- | ------------- | ------------- | ------- | --------- | --------- | -------- | --------------- | ---------- |
|            |         |        |               |     |             |         | cores (left). | Moreover,     |         | this      | algorithm | is       | almost          | as fast as |
| All cores  | sampled | in     | the performed |     | experiments | com-    |               |               |         |           |           |          |                 |            |
|            |         |        |               |     |             |         | the basic     | random        | descent |           | heuristic | (right). | Both            | meth-      |
| prised 20% | of the  | entire | collection    | for | the rice,   | coconut |               |               |         |           |           |          |                 |            |
odsveryquicklyimprovetheinitialrandomselection,and
andmaizedatasets,and10%forthelargepeadataset.
afterlessthan10s,paralleltemperingfoundabettersolu-
Implementationandhardware tionthanrandomdescent,afterwhichitkeepsimproving
CoreHunter3hasbeenreimplementedinJava8,usingthe thequalityofthecore.Incontrast,thegeneticalgorithm
JAMES framework (v1.2) for discrete optimization with takesaslowerstart,catchesupwithrandomdescentafter
local search metaheuristics [30] and was executed from 20s,andthenalsofurtherimprovestheselection—butnot
Table1Comparisonofrandomdescent,paralleltempering,andageneticalgorithm,whenmaximizingtheentry-to-nearest-entry
criterion(E-NE).Meanvaluesandstandarddeviationsarereportedfor10independentlysampledcorecollections
|     |     |     | Rice |     |     | Coconut |     |     | Maize |     |     |     | Pea |     |
| --- | --- | --- | ---- | --- | --- | ------- | --- | --- | ----- | --- | --- | --- | --- | --- |
0.1500±1.83e-04 0.5748±5.22e-04 0.4332±2.73e-04 0.3337±1.70e-03
Randomdescent
0.1508±1.40e-15 0.5759±2.12e-06 0.4359±8.56e-05 0.3412±1.46e-04
Paralleltempering
Geneticalgorithm 0.1506±1.12e-04 0.5755±1.04e-04 0.4346±3.45e-04 0.3386±8.00e-04

| DeBeukelaeretal.BMCBioinformatics |     |  (2018) 19:203  |     |     |     |     |     |     |     | Page7of12 |
| --------------------------------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- | --------- |
Fig.1Convergencecurvesforpeadataset.ThesecurvesshowtheE-NEvalueofthebestfoundsolutionateachpointintimeduringexecutionof
randomdescent,paralleltempering,andthegeneticalgorithm,averagedover10independentruns,forthelargepeadataset.Theleftplotreports
theprogressduringtheentirerunwitharuntimeof30minwhiletherightplotiszoomedinonthefirst40s
as effectively as parallel tempering. We performed these andexecutiontimefor10independentsamples,obtained
experiments only for the E-NE measure but assume that with both methods, and for each dataset except the rice
our findings also hold for A-NE due to the very similar collection, because CH2 cannot sample cores based on
composition of both criteria. All following CH3 results phenotypictraits.Forallthreedatasets,CH3yieldshigher
wereobtainedwiththeparalleltemperingalgorithm. E-NE and DMIN than CH2. However, a detailed inspec-
tionoftheoutputgeneratedbyCH2(notshown)revealed
ComparisonwithCoreHunter2 that the LR replica—one of the search replicas in the
ToassesswhethermaximizingE-NEindirectlyalsoyields MixRepalgorithmusedbyCH2—didnotalwayscomplete
a high minimum distance (DMIN) between selected before CH2 was terminated. This LR search is a con-
accessions, we compared the results of CH3 and CH2. structiveheuristicthatstartswithanemptyselectionand
WeconfiguredCH2tomaximizeaweightedindexinclud- iterativelyaddsthetwobestaccessions,i.e.thoseyielding
ing both average and minimum pairwise distance, with the best possible score when added to the current selec-
equal weight, and CH3 to maximize E-NE. Both algo- tion. After eachtwo additions,oneaccessionisremoved
rithmswereterminatedwhennoimprovementwasfound fromtheselection,againchosentooptimizethescoreof
duringthelast10s.Table2reportsaverageE-NE,DMIN, theremainingselection.Thisprocedureisrepeateduntil
|     |     |     |     | the desired     | core | size       | has been | reached.     | The | LR replica |
| --- | --- | --- | --- | --------------- | ---- | ---------- | -------- | ------------ | --- | ---------- |
|     |     |     |     | wasspecifically |      | includedin | CH2      | to construct |     | cores with |
Table2ComparisonofCoreHunter2and3
highminimumdistance[19].Therefore,werepeatedthe
E-NE DMIN Time(s) CH2experimentswithanabsoluteruntimelimitthatwas
| Coconut |     |     |     | empiricallydeterminedperdatasettoensurethattheLR |     |     |     |     |     |     |
| ------- | --- | --- | --- | ------------------------------------------------ | --- | --- | --- | --- | --- | --- |
0.552±3.53e-2 0.501±9.76e-2 27.6±06.0 replicaterminatedineachrun(CH2L).Especiallyforthe
CH2
CH3 0.576±9.35e-5 0.540±0.00e-0 37.5±07.9 large pea dataset, significantly more time was needed in
|      |               |               |           | this configuration. |     | Table | 2 shows | that | CH2L | is indeed |
| ---- | ------------- | ------------- | --------- | ------------------- | --- | ----- | ------- | ---- | ---- | --------- |
| CH2L | 0.569±5.91e-4 | 0.548±0.00e-0 | 31.0±00.1 |                     |     |       |         |      |      |           |
abletoconstructcoreswithamuchhigherminimumdis-
Maize
|     |     |     |     | tance than | CH2, | and | also outperforms |     | CH3 | in terms of |
| --- | --- | --- | --- | ---------- | ---- | --- | ---------------- | --- | --- | ----------- |
CH2 0.416±1.52e-2 0.396±2.46e-2 78.3±10.6 thismeasure.Althoughdifferencesinminimumdistance
CH3 0.435±2.70e-4 0.409±3.05e-3 74.3±26.5 obtained with CH2L and CH3 are not larger than 4%,
0.429±5.00e-4 0.415±1.11e-3 78.6±02.0 theyarestatisticallysignificantforthecoconutandmaize
CH2L
|     |     |     |     | datasets(p | = 0.000097),butnotforthepeadataset(p |     |     |     |     | =   |
| --- | --- | --- | --- | ---------- | ------------------------------------ | --- | --- | --- | --- | --- |
Pea
|     |               |               |           | 0.3064). | Moreover,        | CH3 | still    | yields | significantly | higher-   |
| --- | ------------- | ------------- | --------- | -------- | ---------------- | --- | -------- | ------ | ------------- | --------- |
|     | 0.219±1.49e-3 | 0.000±0.00e-0 | 85.6±04.5 |          |                  |     |          |        |               |           |
| CH2 |               |               |           | quality  | core collections |     | in terms | of     | the E-NE      | criterion |
CH3 0.338±1.04e-3 0.287±1.34e-2 154.1±49.7 (p=0.000097),andisfasterforlargedatasets.
| CH2L | 0.325±8.21e-4 | 0.297±0.00e-0 | 802.3±00.8 |     |     |     |     |     |     |     |
| ---- | ------------- | ------------- | ---------- | --- | --- | --- | --- | --- | --- | --- |
CH2maximizesaweightedindexincludingaverageandminimumpairwise ComparisonwithGDOptandSimEli
distance,withequalweight,whileCH3maximizesE-NE.MeanE-NE,DMIN,runtime We approximated the Pareto front obtained by Core
andcorrespondingstandarddeviationsarereportedfor10independent
executions.ThehighestobtainedE-NEandDMINvalueperdatasetisshownin Hunter 3 when simultaneously optimizing E-NE, and
|     |     |     |     |     |     |     |     |     | α   | ∈[0,1] |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------ |
bold.CH3wasterminatedwhennoimprovementswerefoundduring10s.ForCH2, either A-NE or HE, with varying weights and
1
twoalternativeswereconsidered:(a)thesamestopconditionasforCH3(CH2);and α = 1−α ,respectively,andcomparedtheresultswith
| (b)anabsoluteruntimelimitthatwasempiricallydeterminedperdatasettoensure |     |     |     | 2   | 1   |     |     |     |     |     |
| ----------------------------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
thattheLRreplicaofMixRepterminatedineachrun(CH2L) thoseobtainedbyGDOptandSimEli.NotethatA-NEis

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page8of12
minimized,whileE-NEandHEaremaximized.Asbefore, Core Hunter 3 is able to simultaneously improve over
CH3 was terminated when no improvement was found SimEliintermsofbothobjectives(E-NEandHEvalue).
during10s.Figure2showsthatGDOptandCH3areable Average execution times of GDOpt, SimEli and CH3
toconstructrepresentativecoreswithlowA-NE,whichis (configuredtooptimizeE-NE,A-NEorHE)arereported
notthecaseforSimEli.Infact,allcoressampledbySimEli in Table 3. Core Hunter 3 was slower than GDOpt and
haveaworseA-NEvaluethanthoseobtainedbyGDOpt SimEli for the rice and coconut datasets. For the maize
andCH3,evenwhenthelatterisconfiguredtomaximize datasetCH3wasfasterthanGDOptandSimEli-HEwhen
E-NE only. On the other hand, SimEli scores much bet- maximizingHEorE-NEbutslowerwhenminimizingA-
ter than GDOpt in terms of diversity (high E-NE). Still, NE and always slower than SimEli-A-RA. Finally, for the
CoreHunter3isabletofindcoreswhichsimultaneously peadataset,CH3wasfasterthanbothGDOptandSimEli.
have a higher diversity and are more representative than CoreHunter3wasalsoconsistentlyfasterwhenmaximiz-
thoseobtainedwithSimEli.Forthemaizedataset,SimEli- ingHEascomparedtotheconfigurationswhereE-NEor
A-RAandSimEli-HEfoundcoresofsimilarquality,while A-NEwereoptimized.
for the coconut and pea dataset SimEli-A-RA showed to
bepreferredintermsofbothE-NEandA-NE.Fortherice Discussion
dataset, SimEli-HE was not included because expected Depending on the purpose of a core collection, a vari-
heterozygosity can only be evaluated for genotypic data. ety of metrics is used to evaluate its quality. Distance-
Figure3showsthatGDOptyieldscoreswithsignificantly based measures are attractive because they are intuitive
lowerHEthananyoftheothermethods.SimEliperforms to understand and can capture both diversity within the
betterinthisrespect,especiallySimEli-HE,butasbefore core as well as representativeness of the accessions from
Fig.2Simultaneousoptimizationofentry-to-nearest-entry(E-NE)andaccession-to-nearest-entry(A-NE)distance.TheseParetofront
approximationsforCoreHunter3wereobtainedbysamplingcoreswithvaryingweightsα 1 ∈[0,1]andα 2 =1−α 1assignedtotheE-NEandA-NE
measures,respectively,withastepsizeof0.05.ThequalityofthecoresconstructedbyCH3iscomparedwiththoseobtainedbyGDOptandSimEli,
intermsofbothobjectivefunctions.Allreportedvaluesareaveragesof10independentlysampledcoreswiththesamesettings

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page9of12
Fig.3Simultaneousmaximizationofentry-to-nearest-entrydistance(E-NE)andexpectedheterozygosity(HE).TheseParetofrontapproximations
forCoreHunter3wereobtainedbysamplingcoreswithvaryingweightsα 1 ∈[0,1]andα 2 =1−α 1assignedtotheE-NEandHEmeasures,
respectively,withastepsizeof0.05.ThequalityofthecoresconstructedbyCH3iscomparedwiththoseobtainedbyGDOptandSimEli,intermsof
bothobjectivefunctions.Allreportedvaluesareaveragesof10independentlysampledcoreswiththesamesettings.Thericedatasetisexcluded
herebecauseexpectedheterozygositycanonlybeevaluatedforgenotypicdata
the full collection, computed from either genetic mark- minimumdistance,meaningthatthesearchhasnoclueas
ersorphenotypes.However,pairwisedistancesneedtobe towhetherthesemodificationsmayeventuallyleadtoan
aggregatedinanappropriatewaytoevaluatetheselected improvedsolution.Tosmoothouttheobjectivefunction,
core.Althoughmanystudiesandmethodshaveusedaver- CH2maximizedacombinationofaverageandminimum
age pairwise distance to assess the diversity in the core, distance. Also, the applied MixRep algorithm includes a
it is known that a high average does not guarantee that constructive LR heuristic (see “Results”), which is much
all accessions in the core are sufficiently different from better suited to maintain a high minimum distance as it
each other [4, 19]. Maximizing this criterion tends to iterativelyaddsaccessionstoaninitiallyemptyselection.
overrepresenttheextremesofthedistributioninthefull Unfortunately, the LR algorithm becomes slow for large
collection. datasets,becauseitbuildsthecorebottom-up,insteadof
CoreHunter2addressedthisissuebymaximizingmin- iterativelyrefiningarandomlychoseninitialselection.
imum distance in addition to average distance, using Two new distance-based metrics, entry-to-nearest-
a complex mixed replica search (MixRep) consisting of entry (E-NE) and accession-to-nearest-entry (A-NE),
different cooperating strategies [19]. The original Core introducedby[4],wereshowntogenerateimprovedcores
Huntersoftwareusedalocalsearchalgorithmtooptimize for specific goals. The E-NE criterion takes all acces-
the chosen evaluation measure, but such local searches sionsintoaccountandcanthereforepresumablybemore
arenotwellsuitedtooptimizeminimumdistancebecause effectively optimized with local searches as compared to
thismeasureisverysensitivetothepreciseselection.Sim- minimumdistance,butstillfocusesonmaintainingahigh
ilarcoresmayhaveverydifferentvalues,whileatthesame distance between each pair of closest accessions which,
time very different cores may have a similar or even the in contrast to average pairwise distance, avoids overrep-
sameminimumdistance.Thismakesitdifficultforalocal resentationofextremevalues.Therefore,inCoreHunter
searchtofinditswayfromarandomlygeneratedselection 3,theminimumdistancemeasurewasreplacedwiththe
to a high-quality core. In particular, for a given current newly proposed E-NE criterion. The A-NE metric was
solution,manypossiblemodificationsmaynotaffectthe alsoincludedtosamplecoresthatmaximallyrepresentall
individualaccessionsfromthefullcollection.
WeassessedwhetherthenewE-NEmetriccanindeed
Table3Averageexecutiontimes(seconds)ofGDOpt,both be effectively optimized with local search algorithms, in
SimEliimplementationsandCH3for10independentsamples
an attempt to avoid the complexity of the MixRep algo-
fromeachdataset.ThreeconfigurationsareconsideredforCH3:
rithmusedbyCH2,andinparticulartheslownessofthe
(a)maximizeE-NE;(b)minimizeA-NE;and(c)maximizeHE
LR replica. We showed that even a very basic stochastic
Rice Coconut Maize Pea hill-climber(randomdescent)canalreadyconstructcores
GDOpt 14.9 7.1 91.2 350.1 with high E-NE value and quite little variability in qual-
SimEli-A-RA 7.6 7.5 11.5 514.7 ityacrossindependentsamples.Still,thevalueofthecore
isfurtherimproved,andvariabilityfurtherreduced,when
SimEli-HE - 15.9 78.0 502.3
using the more advanced parallel tempering algorithm.
CH3E-NE 45.8 37.5 74.3 154.1
Sinceparalleltemperingtakesadvantageofmodernmulti-
CH3A-NE 74.6 55.7 133.1 86.7
coreCPUs,theassociatedcomputationaloverheadisvery
CH3HE - 16.6 40.2 62.8 limited.Inourexperiments,evenforthelargepeadataset

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page10of12
with over 4000 accessions, parallel tempering was only itmaybeconfusingthatthereisapossiblylargetimegap
marginallyslowerthanrandomdescent.Wealsoassessed betweenthelastimprovementfoundbytheotherreplicas
whetherageneticalgorithmcouldfurtherimprovethese andthatobtainedwhentheLRreplicahasfinished.Inthis
results.Suchglobaloptimizationstrategyiterativelycom- respect,CH3ismoreuser-friendlybecauseitusesawell-
bines currently known high-quality solutions (crossover) knownlocalsearchalgorithmthatgraduallyimprovesthe
in an attempt to explore other interesting regions of the E-NE value of the core. Large gaps between significant
solutionspace.Theobtainedsolutionsarethenexploited improvementsarenotexpected,whichmakesiteasierto
by applying local modifications (mutation). We used the determineanappropriatetimelimitandevenmoresoto
randomdescentheuristicasamutationoperator,sinceit useaconvenientadaptivestopconditionsuchasamaxi-
showed to be able to effectively improve the E-NE value mumtimewithoutfindinganimprovement,inwhichcase
ofagivenselection.Althoughthegeneticalgorithmout- the execution time is automatically adjusted—to some
performed random descent, it showed to be slower and extent—tothesizeofthecollection.
produced cores with slightly lower E-NE values as com- OneofthemainadvantagesofCoreHunter3andpre-
paredtoparalleltempering.Theseresultsindicatethatthe vious versions is its flexibility. While other methods are
intelligentexploitationofparalleltemperingismoreeffec- often developed for a specific purpose such as maximiz-
tive to optimize E-NE than the more global exploration ing diversity, representativeness, or allelic richness, Core
of the evaluated genetic algorithm. We thus conclude Hunterissuitedforeachoftheseasitincludesavarietyof
that parallel tempering is preferred, and that more com- evaluationmeasuresthatcandirectlybeoptimized,andif
plex algorithms are not needed to optimize E-NE, since desiredcombinedinaweightedindex.WecomparedCH3
a basic stochastic hill-climber (random descent) already with GDOpt, designed to maximize representativeness,
yieldshigh-qualitycoresandaglobaloptimizationengine and SimEli, where the elimination criterion was chosen
(geneticalgorithm)didnotprovideanyfurtheradvantage. either to maximize diversity (SimEli-A-RA) or expected
Moreover, parallel tempering does not yield a significant heterozygosity(SimEli-HE).CoreHunterwasconfigured
computational overhead—it is almost as fast as random tooptimizeaweightedindexincludingE-NEandeitherA-
descent. We assume that the same conclusion holds for NE(Fig.2)orHE(Fig.3),withvaryingweights,inorderto
A-NE due to the very similar composition of both met- approximate the corresponding Pareto front. The results
rics. Therefore, Core Hunter 3 uses parallel tempering showed that, as expected, GDOpt is especially suited to
by default, which is also known to effectively optimize construct cores that optimally represent all accessions
the other measures that were already included in CH2, fromtheentirecollection(lowA-NE),asitwasspecifically
suchasallelicrichness[19].Afastmodeisalsoprovided developed for this purpose. On the other hand, in terms
in which the basic random descent algorithm is applied, ofdiversity(E-NE)andallelicrichness(HE),SimEliscores
in case execution time is critical, but it was not used in muchbetterthanGDOpt.Fromthetwoconsideredelim-
thisstudy. ination criteria, SimEli-HE resulted in the highest allelic
To validate the effectiveness of the new E-NE mea- richness, while SimEli-A-RA showed to be most suited
sure, we assessed whether maximizing E-NE indirectly to maximize diversity (E-NE). Again, this was expected
alsoyieldsahighminimumdistance.Acomparisonwith and confirms that the SimEli method can be adjusted to
CoreHunter2,configuredtosamplecoreswithhighaver- someextent,byusinganappropriateeliminationcriterion
age and minimum distance, revealed that this is indeed depending on the purpose of the core collection. How-
the case. The minimum distance obtained with CH3 is ever,CoreHunter3foundcoresthatsimultaneouslyhave
slightlylowerascomparedtoCH2,butmoreimportantly higherE-NE(morediverse),andlowerA-NE(morerep-
CH3 yields higher E-NE values because it actively opti- resentative)orhigherHEvalues(higherallelicrichness),
mizes this criterion. As the minimum distance captures thanthoseobtainedbySimEli.Inaddition,CH3wasable
lessinformationaboutthecorethanE-NE,webelievethat to construct equally representative cores as GDOpt, and
thelattercriterionbetterreflectswithin-corediversity.As thuscombinesandimprovesovertheadvantagesofboth
expected, CH3 was faster than CH2 for large datasets, othermethods.
due to the quadratic time complexity of the LR replica. A comparison of execution times showed that CH3
Becauseofitsconstructivenature,LRonlyproducesuse- needs less time to optimize HE as compared to E-NE
ful results if given enough time to complete. Therefore, and A-NE. This is not surprising, as it is known that
a potential additional issue of CH2 is that the user is allelic richness can also be effectively maximized with a
responsible to set an appropriate time limit that allows basic stochastic hill-climber [19]. As we showedthat the
the LR replica to complete, when aiming at a high min- moreadvancedparalleltemperingalgorithmispreferred
imum distance. It is not possible to affect the execution tooptimizeE-NEandA-NE,itisclearlymoredifficultto
time of the LR replica and therefore this method does find cores with high E-NE and low A-NE than to maxi-
not provide a quality-runtime tradeoff to the user. Also, mizeallelicrichness.InourexperimentsCH3wasslower

DeBeukelaeretal.BMCBioinformatics (2018) 19:203 Page11of12
thanGDOptandSimEliforsmallerdatasetsbutfasterfor function value, minimizing the core size may not always
the large pea dataset. Note that although these methods be desired, depending on the purpose of the core. We
were implemented in different programming languages, are therefore convinced that fixed and variable size core
which affects their absolute execution times, the latter sampling should be treated as separate problems, using
doesnotaffecttheobservedtrendintheirexecutiontimes specificevaluationmeasuresandoptimizationstrategies.
whensamplingfromincreasinglylargecollections.Here,
the main advantage of Core Hunter is again its flexibil- Conclusions
ity. For example, the runtime of SimEli is determined We introduced Core Hunter 3 (CH3) and showed that
by the size of the dataset and the sampled core. When it constructs core collections with high diversity (high
samplingasmallcorefromalargecollection,manyacces- entry-to-nearest-entry distance; E-NE) and which maxi-
sions need to be eliminated, and finding the two most mallyrepresenttheindividualaccessionsfromtheentire
similar accessions in each step as well as deciding which collection (low accession-to-nearest-entry distance; A-
onetoeliminaterequiresmanycomputations.Incontrast, NE) using flexible and fast local search algorithms. By
the runtime of Core Hunter can be adjusted by using an default,theparalleltemperingalgorithmisused.Version
appropriatestopcondition.Itispossibletolimitthetotal 3 improves over Core Hunter 2 (CH2) in multiple ways.
runtime, but we used an adaptive condition that termi- CH3 is able to find cores with higher E-NE, within less
natedthesearchwhennomoreimprovementwasfound timeforlargedatasets,whichalsohaveahighminimum
during10s. distance,withouttheneedforamorecomplexalgorithm
Thereisofcourseatradeoffbetweenexecutiontimeand likethemixedreplicasearchfromCH2.Inaddition,CH3
solution quality, and we may be able to further increase finds similar and often better cores than GDOpt and
thequalityofthecorecollectionssampledfromanyofour SimEli,whichwerereportedtooutperformCH2interms
datasets by allowing a longer runtime. For the large pea ofE-NEandA-NE.Inparticular,CH3cancreateequally
datasetforexample,weindeedseethatallowingnomore representative cores as GDOpt, which was designed for
than10swithoutfindingfurtherimprovements(Table2) this purpose, while at the same time being able to con-
yieldsaslightlylowerE-NEvalueascomparedtoaconfig- struct cores that are simultaneously more diverse, and
urationwithanabsoluteruntimelimitof30min(Table1). either are more representative or have a higher allelic
Sinceeachofthetestedmethodswasabletosamplecores richness, than cores obtained with SimEli. As in previ-
fromcollectionswithuptomultiplethousandsofacces- ousversions,oneofthemainstrengthsofCoreHunteris
sions in at most a few minutes, we do not expect that itsflexibility.Theappliedlocalsearchalgorithmsarenot
theexecutiontimeofanyofthesealgorithmswillbelim- confinedtoaspecificevaluationmeasureandnewcriteria
iting for most practical applications. Still, Core Hunter caneasilybeintroducedandoptimizedwithouttheneed
is the only one whose runtime can be controlled by the toaltertheunderlyingalgorithms.Moreover,multiplecri-
userinvariousways,whichyieldsaninterestingquality- teriacanbesimultaneouslyoptimizedandtheexecution
runtime tradeoff that can be used to either reduce the timeiscontrolledbytheuserthroughvariousstopcondi-
executiontimeforlargedatasetswhenneeded,ortomore tions,whichoffersaconvenientquality-runtimetradeoff.
thoroughly explore the solution space when more time We therefore believe that Core Hunter is a very broadly
is available, neither of which is possible with the other applicablecoresubsetselectiontoolwithalotofopportu-
methods.Notethatalthoughwedidnotexperimentwith nitiestobefurtherextended.Forexample,wemayexplore
genotypicdatasetswithtensorhundredsofthousandsof the ability of Core Hunter 3 to sample cores based on
markers,thesecaneasilybedealtwithbyprecomputinga a combination of genotypes and phenotypes, or extend
distance matrix, if necessary, so that only the number of Core Hunter to properly incorporate variable size core
accessionsaffectstheperformanceofCoreHunter. samplingsuchasamethodtoconstructcoveringcoresof
minimumsize.
Variablesizecoresampling
PreviousversionsofCoreHunteralsosupportedvariable Abbreviations
A-NE:Averageaccession-to-nearest-entrydistance;CH2:CoreHunter2;CH3:
sizecoresampling.Wedecidedtoremovethisfunction-
CoreHunter3;DMIN:Minimumdistance;E-NE:Averageentry-to-nearest-entry
alityfromCoreHunter3,andtofocusonfixedsizecore distance;GDOpt:Geneticdistanceoptimization;HE:Expectedheterozygosity;
sampling for the provided evaluation measures, because MixRep:Mixedreplicasearch;REMC:ReplicaexchangeMonteCarlosearch
these measures are not generally applicable to compare
Acknowledgements
cores of different sizes. For example, reducing the core
WethankNathanSinnesaelwhoperformedpreliminaryexperimentsthat
size artificially increases dissimilarity between selected supportedthedevelopmentofCoreHunter3.Thecomputationalresources
accessions, while adding more accessions always yields a (StevinSupercomputerInfrastructure)andservicesusedinthisworkwere
providedbytheVSC(FlemishSupercomputerCenter),fundedbyGhent
morerepresentativecore.Also,whileCH1andCH2pre-
University,theHerculesFoundationandtheFlemishGovernment-
ferred the smallest of two cores with the same objective departmentEWI.

| DeBeukelaeretal.BMCBioinformatics |     |     |  (2018) 19:203  |     |     |     |     |     |     | Page12of12 |     |
| --------------------------------- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | ---------- | --- |
Funding 12. WangJ, HuJ, XuH, ZhangS.Astrategyonconstructingcorecollections
HermanDeBeukelaerissupportedbyaPh.D.grantfromtheResearch byleastdistancestepwisesampling.TheorApplGenet.2007;115(1):1–8.
Foundation-Flanders(FWO). 13. KrishnanRR, SumathyR, RameshS, BindrooB, NaikGV.SimEli:Similarity
eliminationmethodforsamplingdistantentriesindevelopmentofcore
Availabilityofdataandmaterials collections.CropSci.2014;54(3):1070–8.
Therawrice,coconutandmaizedatasetsareavailablefromthecited 14. OdongT, vanHeerwaardenJ, JansenJ, vanHintumTJ, vanEeuwijkF.
references[14,15,27]oronrequest.Therawpeadatasetandcomputed Statisticaltechniquesfordefiningreferencesetsofaccessionsand
distancematricesarealsoavailableonrequest. microsatellitemarkers.CropSci.2011;51(6):2401–11.
15. KimK-W,ChungH-K,ChoG-T,MaK-H,ChandrabalanD,GwagJ-G,KimT-S,
Authors’contributions ChoE-G, ParkY-J.PowerCore:aprogramapplyingtheadvancedm
HDBandGDimplementedtheCoreHunter3libraryinJava.HDBwas strategywithaheuristicsearchforestablishingcoresets.Bioinformatics.
| responsiblefortheRpackagewhileGDdevelopedthegraphicalinterface. |     |     |     |     | 2007;23(16):2155–62. |     |     |     |     |     |     |
| --------------------------------------------------------------- | --- | --- | --- | --- | -------------------- | --- | --- | --- | --- | --- | --- |
HDBperformedallexperiments,underthesupervisionofVF.HDBwrotethe 16. JeongS, KimJ-Y, JeongS-C, KangS-T, MoonJ-K, KimN.Genocore:A
initialmanuscriptwithallauthorscontributingtothefinalversion.Allauthors simpleandfastalgorithmforcoresubsetselectionfromlargegenotype
readandapprovedthefinalmanuscript. datasets.PLoSONE.2017;12(7):0181420.
|     |     |     |     |     | 17. JansenJ, | VanHintumT.Geneticdistancesampling:anovelsampling |     |     |     |     |     |
| --- | --- | --- | --- | --- | ------------ | ------------------------------------------------- | --- | --- | --- | --- | --- |
Ethicsapprovalandconsenttoparticipate methodforobtainingcorecollectionsusinggeneticdistanceswithan
Notapplicable. applicationtocultivatedlettuce.TheorApplGenet.2007;114(3):421–8.
|     |     |     |     |     | 18. ThachukC, | CrossaJ, | FrancoJ, | DreisigackerS, | WarburtonM, | Davenport |     |
| --- | --- | --- | --- | --- | ------------- | -------- | -------- | -------------- | ----------- | --------- | --- |
Competinginterests GF.CoreHunter:analgorithmforsamplinggeneticresourcesbasedon
Theauthorsdeclarethattheyhavenocompetinginterests. multiplegeneticmeasures.BMCBioinformatics.2009;10(1):1.
|     |     |     |     |     | 19. DeBeukelaerH, |     | Smy`kalP, | DavenportGF, | FackV.CoreHunterII:fastcore |     |     |
| --- | --- | --- | --- | --- | ----------------- | --- | --------- | ------------ | --------------------------- | --- | --- |
Publisher’sNote
subsetselectionbasedonmultiplegeneticdiversitymeasuresusing
SpringerNatureremainsneutralwithregardtojurisdictionalclaimsin mixedreplicasearch.BMCBioinformatics.2012;13(1):1.
publishedmapsandinstitutionalaffiliations. 20. HollandJH.AdaptationinNaturalandArtificialSystems:anIntroductory
AnalysiswithApplicationstoBiology,Control,andArtificialIntelligence.
| Authordetails |     |     |     |     | AnnArbor:UMichiganPress;1975. |     |     |     |     |     |     |
| ------------- | --- | --- | --- | --- | ----------------------------- | --- | --- | --- | --- | --- | --- |
1DepartmentofAppliedMathematics,ComputerScienceandStatistics,Ghent 21. WrightS.Evolutionandgeneticsofpopulations.volIV.Chicago:The
University,Krijgslaan281S9,9000Gent,Belgium.2NewZealandInstitutefor
UniversityofChicagoPress;1978.p.91.
Plant&FoodResearchLimited,412No1RdRD2,TePuke,NewZealand. 22. GowerJC.Ageneralcoefficientofsimilarityandsomeofitsproperties.JC
GowerBiometrics.1971;27(4):857–71.
Received:12October2016 Accepted:16May2018 23. BergEE, HamrickJ.Quantificationofgeneticdiversityatallozymeloci.
CanJForRes.1997;27(3):415–24.
|     |     |     |     |     | 24. MarlerRT, | AroraJS.Function-transformationmethodsformulti-objective |     |     |     |     |     |
| --- | --- | --- | --- | --- | ------------- | -------------------------------------------------------- | --- | --- | --- | --- | --- |
optimization.EngOptim.2005;37(6):551–70.
References
|     |     |     |     |     | 25. KirkpatrickS, | GelattCD, |     | VecchiMP.Optimizationbysimulatedannealing. |     |     |     |
| --- | --- | --- | --- | --- | ----------------- | --------- | --- | ------------------------------------------ | --- | --- | --- |
1. FrankelO,etal.Geneticperspectivesofgermplasmconservation.Genetic
Science.1983;220(4598):671–80.
manipulation:impactonmanandsociety.Cambridge:Cambridge
|     |     |     |     |     | 26. KaufmanL, | RousseeuwPJ.Chapter2PartitioningAroundMedoids |     |     |     |     |     |
| --- | --- | --- | --- | --- | ------------- | --------------------------------------------- | --- | --- | --- | --- | --- |
UniversityPress;1984.pp.161–170.
(ProgramPAM)inFindinggroupsindata:anintroductiontocluster
2. ElBakkaliA, HaouaneH, MoukhliA, CostesE, VanDammeP, KhadariB. analysis.NewYork:Wiley;1990.pp.68–125.
Constructionofcorecollectionssuitableforassociationmappingto
|     |     |     |     |     | 27. WimmerV, | AlbrechtT, | AuingerH-J, |     | SchoenC-C.synbreedData:Datafor |     |     |
| --- | --- | --- | --- | --- | ------------ | ---------- | ----------- | --- | ------------------------------ | --- | --- |
optimizeuseofmediterraneanolive(oleaeuropaeal.)geneticresources.
theSynbreedPackage.2015.Rpackageversion1.5.https://CRAN.R-
PLoSONE.2013;8(5):1–13.https://doi.org/10.1371/journal.pone.0061265.
project.org/package=synbreedData.
| 3. Muñoz-AmatriaínM, | Cuesta-MarcosA, |     | EndelmanJB, | ComadranJ, |            |             |            |        |                      |     |         |
| -------------------- | --------------- | --- | ----------- | ---------- | ---------- | ----------- | ---------- | ------ | -------------------- | --- | ------- |
|                      |                 |     |             |            | 28. JingR, | VershininA, | GrzebytaJ, | ShawP, | Smy`kalP, MarshallD, |     | Ambrose |
BonmanJM, BockelmanHE, ChaoS, RussellJ, WaughR, HayesPM, MJ, EllisTN, FlavellAJ.Thegeneticdiversityandevolutionoffieldpea
MuehlbauerGJ.Theusdabarleycorecollection:Geneticdiversity,
(pisum)studiedbyhighthroughputretrotransposonbasedinsertion
populationstructure,andpotentialforgenome-wideassociationstudies.
polymorphism(rbip)markeranalysis.BMCEvolBiol.2010;10(1):1.
PLoSONE.2014;9(4):1–13.https://doi.org/10.1371/journal.pone.0094688.
|            |                       |     |                           |     | 29. Smy`kalP., | KenicerG, | FlavellAJ, | CoranderJ,                              | KosterinO, | ReddenRJ, | Ford |
| ---------- | --------------------- | --- | ------------------------- | --- | -------------- | --------- | ---------- | --------------------------------------- | ---------- | --------- | ---- |
| 4. OdongT, | JansenJ, VanEeuwijkF, |     | vanHintumTJ.Qualityofcore |     |                |           |            |                                         |            |           |      |
|            |                       |     |                           |     | R, CoyneCJ,    | MaxtedN,  |            | AmbroseMJ,etal.Phylogeny,phylogeography |            |           |      |
collectionsforeffectiveutilisationofgeneticresourcesreview,discussion andgeneticdiversityofthepisumgenus.PlantGenetResour.2011;9(01):
andinterpretation.TheorApplGenet.2013;126(2):289–305.
4–18.
| 5. WangJ-C, | HuJ, LiuN-N, | XuH-M, | ZhangS.Investigationofcombining |     |                   |     |              |           |                |     |     |
| ----------- | ------------ | ------ | ------------------------------- | --- | ----------------- | --- | ------------ | --------- | -------------- | --- | --- |
|             |              |        |                                 |     | 30. DeBeukelaerH, |     | DavenportGF, | DeMeyerG, | FackV.JAMES:An |     |     |
plantgenotypicvaluesandmolecularmarkerinformationfor
object-orientedjavaframeworkfordiscreteoptimizationusinglocal
constructingcoresubsets.JIntegrPlantBiol.2006;48(11):1371–8.
searchmetaheuristics.SoftwPractExperience.2017;47(6):921–38.
6. FrancoJ, CrossaJ, DesphandeS.Hierarchicalmultiple-factoranalysisfor 31. RCoreTeam.R:ALanguageandEnvironmentforStatisticalComputing.
classifyinggenotypesbasedonphenotypicandgeneticdata.CropSci.
Vienna,Austria:RFoundationforStatisticalComputing;2016.R
2010;50(1):105–17.
FoundationforStatisticalComputing.https://www.R-project.org/.
| 7. BorrayoE, | Machida-HiranoR, | TakeyaM, | KawaseM, | WatanabeK. |                 |          |     |                                           |     |     |     |
| ------------ | ---------------- | -------- | -------- | ---------- | --------------- | -------- | --- | ----------------------------------------- | --- | --- | --- |
|              |                  |          |          |            | 32. HollanderM, | WolfeDA, |     | ChickenE.NonparametricStatisticalMethods. |     |     |     |
Principalcomponentsanalysis-k-meanstransposonelementbasedfoxtail
Chichester:Wiley;2013.
milletcorecollectionselectionmethod.BMCGenet.2016;17(1):1. 33. HolmS.Asimplesequentiallyrejectivemultipletestprocedure.ScandJ
8. BrownA.Corecollections:apracticalapproachtogeneticresources
Stat.1979;65–70.
management.Genome.1989;31(2):818–24.
| 9. FrancoJ, | CrossaJ, TabaS, | ShandsH.Asamplingstrategyforconserving |     |     |     |     |     |     |     |     |     |
| ----------- | --------------- | -------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
geneticdiversitywhenformingcoresubsets.CropSci.2005;45(3):
1035–44.
| 10. SchoenD, | BrownA.Conservationofallelicrichnessinwildcroprelatives |     |     |     |     |     |     |     |     |     |     |
| ------------ | ------------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
isaidedbyassessmentofgeneticmarkers.ProcNatlAcadSci.
1993;90(22):10623–7.
| 11. GouesnardB, | BataillonT, | DecouxG, | RozaleC, | SchoenD, DavidJ. |     |     |     |     |     |     |     |
| --------------- | ----------- | -------- | -------- | ---------------- | --- | --- | --- | --- | --- | --- | --- |
MSTRAT:Analgorithmforbuildinggermplasmcorecollectionsby
maximizingallelicorphenotypicrichness.JHered.2001;92(1):93–4.
