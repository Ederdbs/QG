Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Genetics Selection Evolution
DOI 10.1186/s12711‑015‑0172‑y
RESEARCH ARTICLE Open Access
The use of genomic coancestry matrices
in the optimisation of contributions to maintain
genetic diversity at specific regions of the
genome
Fernando Gómez‑Romano1, Beatriz Villanueva1, Jesús Fernández1*, John A. Woolliams2
and Ricardo Pong‑Wong2
Abstract
Background: Optimal contribution methods have proved to be very efficient for controlling the rates at which
coancestry and inbreeding increase and therefore, for maintaining genetic diversity. These methods have usually
relied on pedigree information for estimating genetic relationships between animals. However, with the large amount
of genomic information now available such as high‑density single nucleotide polymorphism (SNP) chips that contain
thousands of SNPs, it becomes possible to calculate more accurate estimates of relationships and to target specific
regions in the genome where there is a particular interest in maximising genetic diversity. The objective of this study
was to investigate the effectiveness of using genomic coancestry matrices for: (1) minimising the loss of genetic vari‑
ability at specific genomic regions while restricting the overall loss in the rest of the genome; or (2) maximising the
overall genetic diversity while restricting the loss of diversity at specific genomic regions.
Results: Our study shows that the use of genomic coancestry was very successful at minimising the loss of diversity
and outperformed the use of pedigree‑based coancestry (genetic diversity even increased in some scenarios). The
results also show that genomic information allows a targeted optimisation to maintain diversity at specific genomic
regions, whether they are linked or not. The level of variability maintained increased when the targeted regions were
closely linked. However, such targeted management leads to an important loss of diversity in the rest of the genome
and, thus, it is necessary to take further actions to constrain this loss. Optimal contribution methods also proved to
be effective at restricting the loss of diversity in the rest of the genome, although the resulting rate of coancestry was
higher than the constraint imposed.
Conclusions: The use of genomic matrices when optimising contributions permits the control of genetic diversity
and inbreeding at specific regions of the genome through the minimisation of partial genomic coancestry matrices.
The formula used to predict coancestry in the next generation produces biased results and therefore it is necessary to
refine the theory of genetic contributions when genomic matrices are used to optimise contributions.
Background offspring that each breeding candidate should pro-
It is generally accepted that control of the rate of duce to minimise coancestry. These methods were
coancestry provides a general framework to manage initially developed based on a pedigree-based relation-
genetic variability. Optimal contribution (OC) meth- ship matrix (A) that represents expected relationships
ods [1, 2] permit the determination of the number of assuming neutrality and does not take into account vari-
ation due to Mendelian sampling. Thus, although its use
*Correspondence: jmj@inia.es has proved to be efficient to manage genetic diversity,
1 Departamento de Mejora Genética Animal, INIA, Madrid, Spain it has some limitations. For instance, individuals from
Full list of author information is available at the end of the article
© 2016 Gómez‑Romano et al. This article is distributed under the terms of the Creative Commons Attribution 4.0 International
License (http://creativecommons.org/licenses/by/4.0/), which permits unrestricted use, distribution, and reproduction in any
medium, provided you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons
license, and indicate if changes were made. The Creative Commons Public Domain Dedication waiver (http://creativecommons.
org/publicdomain/zero/1.0/) applies to the data made available in this article, unless otherwise stated.

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 2 of 17
the same (full-sib) family inherit different sets of alleles Methods
but they are assumed to be equally related. In addition, Optimisation of contributions to minimise the loss
since matrix A does not consider differences between of genetic diversity
genomic regions, optimisation of contributions will, Assume a set of N breeding candidates and c the vec-
on average, control the rate of coancestry to the chosen tor of genetic contributions of the candidates to the next
value, but some genomic regions may have substantially (offspring) generation. These contributions represent the
higher rates than desired. fraction of the genetic material that each candidate con-
The management of genetic diversity can be improved tributes to the gene pool of the next generation. In dip-
if matrix A is replaced by a realised relationship matrix loid species, each sex contributes half of the gene pool, so
that is calculated by taking into account variation in the the genetic contribution of a given candidate ranges from
level of relationship between animals of the same fam- 0 to 0.5. Note that c 0 indicates that the candidate i
i =
ily and variation between genomic regions [3]. Because has no offspring and c 0.5 indicates that all offspring
i =
of the availability of high-density single nucleotide poly- are fathered (or mothered) by i. Let s and d be vectors of
morphism (SNP) chips, it is now possible to calculate indicators of the sex of the candidates, with s 1 if can-
i=
such realised relationship matrices. Genotypes for hun- didate i is male and 0 if it is female, and d 1 s.
= −
dreds or thousands of SNPs across the genome are now
commonly used to calculate relationship matrices for Optimisation problem 1
many species (e.g., [3–5]). These matrices have proved When the main breeding objective is to minimise the loss
to satisfactorily manage global genetic diversity and of genetic diversity, genetic contributions of candidates
outperform pedigree-based relationship matrices [6–8]. are optimised by minimising the expected average level
Marker-based relationship matrices can also be used of coancestry in the offspring generation. Hence, the OC
to minimise loss of variability at specific regions of the problem can be formulated as:
genome, which is useful for certain genomic regions.
Minimise
c′Gc,
(1a)
For example, for regions that harbour loci involved in
general resistance to disease [e.g. the major histocom-
subjectto
c′s=0.5,
(1b)
patibility complex (MHC)] a high level of genetic diver-
sity is desirable to ensure that the population can deal c′d=0.5,
(1c)
with potential new disease challenges. This is also the
case for regions that are associated with inbreeding c i ≥0, (1d)
depression for fitness traits [9, 10]. In addition, evolu-
tionary forces such as genetic drift and selection can where G is the coancestry matrix containing coefficients
lead to genomic regions that have substantially less of coancestry between all candidates in the population.
genetic variation than other regions. In fact, several Note that this differs from the formulations of Meuwis-
studies have reported that variation in genetic diver- sen [1], Grundy et al. [2] and Pong-Wong and Wool-
sity between regions could be quite large (e.g., [11–13]). liams [15], who used the numerator relationship matrix
Thus, conservation programmes could be more efficient A which is twice G (i.e., G ½A). The constraints (1b–d)
=
if approaches to maintain genetic diversity focussed are imposed in order to keep the solution for c within the
on some regions of the genome (regardless of whether valid range.
they contain known genes of interest) rather than on the Matrix G can be computed from pedigree or molecu-
whole genome. However, such approaches require that lar data. With the availability of dense SNP genotypes, it
constraints on coancestry are imposed on the rest of the is also possible to obtain a G matrix for specific regions
genome. Otherwise, rates of coancestry, inbreeding and of the genome. Hence, the optimisation problem can be
loss of variability could become high in regions that are implemented to minimise the loss of diversity across the
positioned away from the region that was targeted for whole genome or at specific regions of the genome by
minimisation [14]. using the appropriate G matrix (see below).
The objective of this study was to assess, through com-
puter simulations, the effectiveness of using dense SNP Optimisation problem 2
panels when contributions are optimised to: (1) minimise While keeping the objective of minimising the loss of
the loss of genetic variability at specific genomic regions diversity (across the genome or at specific regions), the
while restricting the overall loss of diversity in the rest of optimisation problem can be refined by imposing addi-
the genome; or (2) maximise the overall genetic diversity tional constraints so that the expected level of coances-
while restricting the loss of diversity at specific genomic try in the offspring generation for one or more genome
regions. regions cannot be greater than a given predefined value

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 3 of 17
(k). Hence, the OC problem can be reformulated by add- matrix, it still represents estimates of the true relation-
ing m additional constraints: ships unless full sequences are available and used to cal-
Minimise
c′Gc,
(2a)
culate relationships.
Simulations
subjectto c′G 1 c≤k 1 , (2b)
Different management strategies aimed at minimising
c′G c≤k , the loss of genetic diversity were compared using Monte
2 2
Carlo simulations. The strategies differed in the type of
.
. . information used to compute coancestries when opti-
c′G c≤k , mising contributions. They also differed in the objective
m m function to be minimised and the restrictions imposed
c′s=0.5,
(2c)
during the optimisation.
The study considered populations of N animals (20 or
c′d=0.5,
(2d)
100) born per generation. The sex of the individuals was
randomly assigned, with 50 % males and 50 % females.
c i ≥0, (2e) Each management scenario was replicated 100 times.
where G is the matrix for the part of the genome where Genetic and population models
coancestry will be minimised (overall or local) and The genetic model assumed that the genome was divided
G (j 1, …, m) is the coancestry matrix for region j into 20 chromosomes of 1 Morgan each. Each chromo-
j =
for which a restriction is imposed. The term k is the some had n biallelic loci equally spaced. The genotypes
j loci
maximum expected level of coancestry allowed for of n /2 of the loci (those located at alternate positions)
loci
region j. For a given generation, k can be calculated as were assumed to be known and they were used to cre-
j
k 1 (1 C)(1 f), where f is the average coancestry ate the genomic matrices required for the optimisation
j= − − j − j j
at region j in that generation, and C is the targeted rate of of contributions. Thus, these n /2 loci simulated per
j loci
coancestry for region j. chromosome mimicked genotyped SNPs. The remaining
The implementation of both optimisation problems n /2 loci per chromosome were used to assess the effect
loci
was carried out using a semidefinite programming (SDP) of the different management strategies on the amount of
approach as described in Pong-Wong and Woolliams diversity maintained. Both types of loci were simulated in
[15]. In order to do so, the optimisation problems 1 and 2 the same way and, as described below, differed simply in
were, first, reformulated as standard SDP problems and, their use: marker loci were used for taking management
thereafter, solved using the SDPA package [16]. Details decisions, whereas non-marker loci were used to meas-
on how they are reformulated as standard SDP problems ure true coancestry. In practice, commercial SNP chips
are in the “Appendix”. represent a proportion of the full sequence and they are
not designed to include rare SNPs and causative muta-
Coancestry matrices tions. In this study, we assumed that the interest lies in
Different coancestry matrices were used in the optimisa- the diversity of the non-marker loci, thus the relation-
tion of contributions. They included coancestry matri- ships computed using the non-marker loci are referred
ces computed from pedigree or genomic information. to as the true relationships. The coancestry matrix cal-
Genomic matrices were calculated using a large number culated with the observed marker loci (and used in the
of biallelic markers that mimicked SNPs and the allelic optimisation) is assumed to be an estimate of the true
similarity method proposed by Nejati-Javaremi et al. coancestry matrix.
[3]. For a given SNP, the allelic relationship between Initially, a base population in mutation-drift equilib-
two individuals is
(0.25) 2
i=1
2
j=1
δ
ij, where δ ij is the rium was generated. This ensured the existence of linkage
allele sharing status, whic(cid:31)h is e(cid:31)qual to 1 if allele i from disequilibrium (LD) between marker and non-marker
the first individual is identical to allele j from the sec- loci. Details on how the base population was created
ond individual and 0 otherwise. The genomic coancestry are in Gómez-Romano et al. [8]. In brief, a historical
between two individuals is the average genomic coances- population of size N was simulated for 10,000 genera-
try across all genotyped SNPs in the genome (for the tions of random mating. The historical population was
whole genome matrix) or in the regions of interest (for initialised assuming that alleles at the 20n simulated
loci
regional genomic matrices). Note that, although the loci were fixed. Two different mutation rates were con-
realised coancestry matrix based on SNP data is more sidered (μ 2.5 10−3 and μ 2.5 10−5) in order to
= × = ×
precise than the traditional pedigree-based coancestry mimic two different degrees of LD between marker and

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 4 of 17
non-marker loci. The last generation of this process was The specific locations of the 10 regions minimised under
considered to be the base population (t 0). In scenar- REG were randomly chosen. Strategies CHR and
= _ove
ios with μ 2.5 10−3, n was equal to 2000 and in REG were based on optimisation problem 2, in which
= × loci _ove
scenarios with μ 2.5 10−5, it was equal to 60,000. the average coancestry in specific regions of the genome
= ×
These values for n ensured that there was a sufficient was minimised while restricting the coancestry in the
loci
number of loci segregating at t 0, i.e. at least 1200 rest of the genome (f and f for CHR and
= m_ove-chr m_ove-reg _ove
for μ 2.5 10−3 and 1300 for μ 2.5 10−5 SNPs REG , respectively). The restriction applied to the rest
= × = × _ove
were segregating per chromosome, resulting in a total of of the genome was such that the intended rate of increase
24,000 and 26,000 SNPs for the whole genome, respec- in f and f was either 1.0 or 0.1 % per gen-
m_ove-chr m_ove-reg
tively. Only the loci that were segregating at t 0 were eration. Strategy OVE was also based on optimisation
= _reg
used for analysis. problem 2 and implied minimising the overall genomic
From t 0 onwards, the population was managed coancestry while imposing independent restrictions (0.10
=
under different strategies for 10 generations. In each gen- or 0.01 %) on the increase in coancestry at each of the 10
eration, the contributions of the potential parents were regions on different chromosomes (f ). An additional
m_reg
optimised according to the strategy used, and a genera- scenario where contributions were randomly assigned
tion of offspring of size N was generated with random (strategy RAN) was also considered for comparison.
mating based on optimised contributions. In turn, the
offspring produced became the candidates for the next Criteria of comparison
round. It should be noted that mutation rate was set to The rate at which genetic diversity is lost is given by the
zero during these ten generations of management. rate at which the average true coancestry increases (Δf).
Thus, the main criterion for comparing management
Scenarios compared strategies was the true genomic rate calculated for each
Seven management strategies (PED, OVE, CHR, generation, as well as the pedigree-based rate of coances-
REG, OVE , CHR and REG ) were considered try. For the purpose of comparing strategies, the true
_reg _ove _ove
(Table 1). Management in strategies PED, OVE, CHR relationship between individuals was assumed to be the
and REG was based on optimisation problem 1 and dif- genomic coancestry matrix computed using the non-
fered in the coancestry (f) minimised (i.e., in the G matrix marker loci. The number of individuals that contributed
used in Eq. 1a). Strategy PED minimised pedigree-based to the offspring generation and the variance of contribu-
coancestry (f ), OVE minimised the overall (i.e., average tions were also calculated for each generation.
p
for all markers in the genome) genomic coancestry (f
m_
Results
), CHR minimised coancestry across an entire chromo-
ove
some (arbitrarily chosen to be chromosome 1) (f ), Table 2 shows the average rates of pedigree and true
m_chr
and REG minimised the average genomic coancestry molecular coancestries for scenarios RAN, PED and
(f ) across 10 regions of 10 cM each located on 10 dif- OVE, when the mutation rate (μ) in the historical popula-
m_reg
ferent chromosomes. Since the proportion of the genome tion was assumed to be either 2.5 10−3 or 2.5 10−5.
× ×
to be minimised was the same for strategies CHR and These differences in mutation rate resulted in differ-
REG, CHR can be considered as a special case of REG in ent levels of LD between adjacent SNPs at t 0, i.e. for
=
which all regions are located on the same chromosome. μ 2.5 10−3, average LD was equal to 0.28 and 0.13 for
= ×
Table 1 Rates of coancestry minimised and restricted for each optimisation strategy
Strategy Minimisation Restriction
PED Pedigree coancestry –
OVE Overall genomic coancestry –
CHR Average genomic coancestry for chromosome 1 –
REG Average genomic coancestry across 10 regions of 10 cM each, –
located on different chromosomes
OVE Overall genomic coancestry Rate of genomic coancestry for each of 10 regions of 10 cM each,
_reg
located on different chromosomes
CHR Average genomic coancestry for chromosome 1 Overall rate of genomic coancestry
_ove
REG Average genomic coancestry across 10 regions of 10 cM each, Overall rate of genomic coancestry
_ove
located on different chromosomes

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 5 of 17
Table 2 Rates of pedigree and overall true genomic coancestry across generations (t) when applying different manage-
ment strategies (RAN, PED and OVE) in populations of two different sizes (N) and using two mutation rates (μ) to create
the base population
N t Rate of pedigree coancestry (%) Rate of genomic coancestry (%)
μ 2.5 10− 3 μ 2.5 10− 5 μ 2.5 10− 3 μ 2.5 10− 5
= × = × = × = ×
RAN PED OVE RAN PED OVE RAN PED OVE RAN PED OVE
20 1 2.46 1.28 2.47 2.45 1.28 2.69 2.47 1.32 0.17 2.57 1.31 0.20
2 2.40 1.30 1.79 2.39 1.30 1.97 2.47 1.25 1.32 2.45 1.31 1.01
3 2.44 1.30 1.73 2.43 1.30 1.89 2.34 1.24 1.29 2.30 1.32 1.08
4 2.52 1.30 1.70 2.52 1.30 1.89 2.55 1.30 1.40 2.48 1.32 1.05
5 2.46 1.30 1.75 2.45 1.30 1.88 2.40 1.35 1.50 2.48 1.30 1.10
10 2.39 1.30 1.81 2.39 1.30 1.85 2.36 1.28 1.47 2.42 1.35 1.07
100 1 0.50 0.25 0.74 0.52 0.25 1.05 0.50 0.26 0.16 0.55 0.22 0.40
− −
2 0.51 0.25 0.50 0.48 0.25 0.69 0.50 0.25 0.23 0.57 0.25 0.16
−
3 0.49 0.25 0.49 0.46 0.25 0.65 0.50 0.25 0.28 0.44 0.19 0.15
−
4 0.50 0.25 0.48 0.52 0.25 0.63 0.51 0.26 0.31 0.60 0.27 0.05
−
5 0.50 0.25 0.47 0.51 0.25 0.64 0.50 0.26 0.34 0.60 0.25 0.07
−
10 0.50 0.25 0.46 0.50 0.25 0.58 0.51 0.26 0.37 0.47 0.19 0.03
−
A
N
v
=
er
2
a
0
g e
a n
lin
d
k
1
a
0
g
0
e
, r
d
e
i
s
s
p
eq
ec
u
t
i
i
l
v
ib
e
r
l
i
y
u
w
m
h
b
e
e
n
t w
μ
e
=
e n
2 .
c
5
o
×
n s
1
e
0
c
−
u
5
tive SNPs at t
=
0 was 0.28 and 0.13 for N
=
20 and 100, respectively when μ
=
2.5
×
10− 3, and 0.40 and 0.21 for
RAN contributions are assigned at random, PED contributions are optimised to minimise f, OVE contributions are optimised to minimise f
p m_ove
N 20 and 100, respectively and for μ 2.5 10−5, it generations (data not shown). These results suggest
= = ×
was equal to 0.40 and 0.21, respectively. that the level of LD in scenarios with the higher muta-
As expected, across different selection scenarios and tion rate (μ 2.5 10−3) may not be sufficient for the
= ×
levels of mutation, the rate of coancestry (pedigree or genomic coancestry calculated with the observed SNPs
molecular) was always higher with the smaller popula- (and used in optimisation) to be a good estimator of the
tion size. Rates of pedigree and true genomic coances- true coancestry for unobserved loci. Hence, the remain-
try were similar for the strategies RAN and PED, but ing results will be based only on populations that were
large differences were observed when the contributions simulated assuming a mutation rate of μ 2.5 10−5.
= ×
were optimised to minimise f (strategy OVE). These Tables 3 (N 20) and 4 (N 100) show the rate of
m_ove = =
results clearly show that pedigree coancestry is not a genomic coancestry for the targeted regions (those where
good estimator of the true coancestry when genomic Δf was minimised) and for the rest of the genome under
relationships are used in the optimisation of contri- strategies CHR and REG. The OC method was very
butions. The performance of OVE depended on the efficient in avoiding loss of diversity in the considered
mutation rate used to create the base population. For regions to the point that, for most generations, genetic
μ 2.5 10−5, OVE substantially outperformed PED diversity even increased (i.e., the rate of coancestry was
= ×
by having a much lower rate of true genomic coances- negative). The optimisation was more successful when all
try across all generations and population sizes. Across targeted regions were on the same chromosome (CHR)
generations, the average rate of increase of genomic than when they were located on different chromosomes
coancestry (Δf ) was equal to 0.0132 (N 20) and (REG), although the proportion of the genome for which
m_ove =
0.0023 (N 100) for PED versus 0.0092 (N 20) and coancestry was minimised was the same (5 %). In both
= =
0.0014 (N 100) for OVE (negative rate means a scenarios (CHR and REG), the success in maintaining
− =
decrease in the genomic coancestry). However, with more diversity in specific regions had undesired conse-
a higher mutation rate (μ 2.5 10−3), the advantage quences for the rest of the genome, where the observed
= ×
of OVE over PED in terms of lower Δf was only Δf was several folds higher than when assuming random
m_ove
observed for the first generation and Δf became selection or when optimisation was based on pedigree
m_ove
slightly higher under OVE than under PED in later gen- coancestry (cf. Table 2). For instance, for N 20, Δf for
=
erations. Conversely, this good performance of OVE the rest of the genome with REG and CHR was respec-
in early generations implies that its actual level of true tively two and three folds higher than the observed Δf
coancestry remained lower than with PED at later with PED. For N 100, these differences were five and
=

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 6 of 17
Table 3 Average rate of genomic coancestry in genomic regions targeted for minimising coancestry and in the rest of the
genome across generations (t), when applying different management strategies (CHR, CHR , REG, REG ) for a popu-
|     |     |     |     |     |     | _ove _ove |     |
| --- | --- | --- | --- | --- | --- | --------- | --- |
lation of size 20
| t   | CHR | CHR       |           |     | REG | REG       |           |
| --- | --- | --------- | --------- | --- | --- | --------- | --------- |
|     |     | _ove      |           |     |     | _ove      |           |
|     |     | C   1.0 % | C   0.1 % |     |     | C   1.0 % | C   0.1 % |
|     |     | =         | =         |     |     | =         | =         |
Rate of genomic coancestry at regions targeted for minimisation (%)
| 1   | 4.64 | 4.33 | 3.79 |     | 2.18 | 2.06 | 1.78 |
| --- | ---- | ---- | ---- | --- | ---- | ---- | ---- |
|     | −    | −    | −    |     | −    | −    | −    |
| 2   | 1.08 | 1.09 | 0.54 |     | 0.39 | 0.64 | 0.16 |
|     | −    | −    | −    |     | −    | −    | −    |
| 3   | 0.06 | 0.28 | 0.22 |     | 0.33 | 0.32 | 0.05 |
|     | −    | −    | −    |     | −    | −    | −    |
| 4   | 0.06 | 0.14 | 0.04 |     | 0.25 | 0.23 | 0.09 |
|     | −    |      |      |     | −    |      |      |
| 5   | 0.30 | 0.22 | 0.14 |     | 0.10 | 0.25 | 0.23 |
| 10  | 0.42 | 0.37 | 0.35 |     | 0.54 | 0.35 | 0.40 |
Rate of genomic coancestry at the rest of genome (%)
| 1   | 6.28 | 2.27 | 1.47 |     | 3.86 | 2.42 | 1.67 |
| --- | ---- | ---- | ---- | --- | ---- | ---- | ---- |
| 2   | 4.34 | 2.44 | 1.52 |     | 3.22 | 2.26 | 1.59 |
| 3   | 4.20 | 2.32 | 1.40 |     | 3.31 | 2.32 | 1.61 |
| 4   | 4.04 | 2.38 | 1.50 |     | 3.05 | 2.46 | 1.59 |
| 5   | 3.82 | 2.37 | 1.48 |     | 2.98 | 2.30 | 1.67 |
| 10  | 3.28 | 2.40 | 1.40 |     | 2.81 | 2.25 | 1.45 |
Two different constraints (C) were imposed on the rate of coancestry at the rest of the genome when applying strategies CHR  and REG
_ove _ove
CHR contributions are optimised to minimise f , CHR  contributions are optimised to minimise f  while restricting f , REG contributions are optimised
|               |                                                  | m_chr _ove |                      |           | m_chr | m_ove‑chr |     |
| ------------- | ------------------------------------------------ | ---------- | -------------------- | --------- | ----- | --------- | --- |
| to minimise f | , REG  contributions are optimised to minimise f |            |  while restricting f |           |       |           |     |
|               | m_reg _ove                                       |            | m_reg                | m_ove‑reg |       |           |     |
Table 4 Average rate of genomic coancestry in genomic regions targeted for minimising coancestry and in the rest of the
genome across generations (t) when applying different management strategies (CHR, CHR , REG, REG ) for a popula-
|     |     |     |     |     |     | _ove _ove |     |
| --- | --- | --- | --- | --- | --- | --------- | --- |
tion of size 100
| t   | CHR | CHR       |           |     | REG | REG       |           |
| --- | --- | --------- | --------- | --- | --- | --------- | --------- |
|     |     | _ove      |           |     |     | _ove      |           |
|     |     | C   1.0 % | C   0.1 % |     |     | C   1.0 % | C   0.1 % |
|     |     | =         | =         |     |     | =         | =         |
Rate of genomic coancestry at regions targeted for minimisation (%)
| 1   | 4.69 | 4.48 | 4.18 |     | 2.34 | 1.93 | 1.77 |
| --- | ---- | ---- | ---- | --- | ---- | ---- | ---- |
|     | −    | −    | −    |     | −    | −    | −    |
| 2   | 1.83 | 2.00 | 1.94 |     | 0.36 | 0.40 | 0.41 |
|     | −    | −    | −    |     | −    | −    | −    |
| 3   | 0.81 | 0.82 | 0.86 |     | 0.13 | 0.17 | 0.21 |
|     | −    | −    | −    |     | −    | −    | −    |
| 4   | 0.67 | 0.75 | 0.91 |     | 0.10 | 0.07 | 0.17 |
|     | −    | −    | −    |     | −    | −    |      |
| 5   | 0.28 | 0.36 | 0.30 |     | 0.10 | 0.10 | 0.17 |
|     | −    | −    | −    |     | −    |      |      |
| 10  | 0.20 | 0.17 | 0.07 |     | 0.15 | 0.13 | 0.28 |
|     | −    | −    | −    |     |      |      |      |
Rate of genomic coancestry at the rest of genome (%)
| 1   | 3.43 | 1.45 | 0.67 |     | 1.74 | 1.30 | 0.47 |
| --- | ---- | ---- | ---- | --- | ---- | ---- | ---- |
| 2   | 1.70 | 1.44 | 0.65 |     | 1.21 | 1.16 | 0.45 |
| 3   | 2.17 | 1.26 | 0.34 |     | 1.14 | 1.12 | 0.46 |
| 4   | 1.32 | 1.35 | 0.52 |     | 1.03 | 1.05 | 0.43 |
| 5   | 2.02 | 1.23 | 0.45 |     | 1.00 | 1.03 | 0.45 |
| 10  | 1.44 | 1.16 | 0.42 |     | 0.98 | 0.89 | 0.42 |
Two different constraints (C) were imposed on the coancestry rate at the rest of the genome when applying strategies CHR  and REG
_ove _ove
CHR contributions are optimised to minimise f , CHR  contributions are optimised to minimise f  while restricting f , REG contributions are optimised
|               |                                                  | m_chr _ove |                      |           | m_chr | m_ove‑chr |     |
| ------------- | ------------------------------------------------ | ---------- | -------------------- | --------- | ----- | --------- | --- |
| to minimise f | , REG  contributions are optimised to minimise f |            |  while restricting f |           |       |           |     |
|               | m_reg _ove                                       |            | m_reg                | m_ove‑reg |       |           |     |
nine folds higher, respectively. Moreover, the poor perfor- with CHR being the most efficient for maintaining diver-
mance for the rest of the genome was related to the good  sity in these regions but also being the worst in losing it
performance for the regions targeted for minimisation,  for the rest of the genome.

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 7 of 17
In order to control this detrimental effect, an addi- compared it with the actual rate observed after the off-
tional constraint was imposed to restrict the excessive spring were generated. E(Δf ) was calculated as (c′
t+1 t
loss of diversity across the rest of the genome (strategies G c f)/(1 f), where G is the coancestry matrix
x t t − t − t x
CHR and REG ). The inclusion of such constraints of the candidates for the region in question and f the
_ove _ove t
succeeded in substantially reducing the rate of increase average coancestry in the candidates’ generation. Note
in coancestry, but the realised Δf values were higher than that f and G were computed from marker genotypes.
t x
the targeted rate (1.0 or 0.1 %), particularly for the popu- Figure 1 shows the expected and realised Δf for
m_ove-chr
lation with the smallest size (Tables 3, 4). For instance, for a CHR scheme for three populations of size 20, 100
_ove
N 20, a realised Δf of about 2 % was obtained for both and 200. Across all generations and population sizes, the
=
CHR and REG when the constraint was 1 %. This expected rate always met the requirement of being lower
_ove _ove
was also observed when the rate of coancestry was com- than the imposed restriction, but the realised value was
puted based on observed SNP genotypes. always higher than the restriction (i.e. the restriction
In order to investigate if this unexpected result was was set at 0.1 %, but the realised rate across generations
a consequence of the optimisation process failing to was approximately 1.4, 0.3 and 0.2 % for N 20, 100 and
=
find a solution that meets the imposed restriction, 200, respectively). Figure 1 also shows that the differ-
we calculated the expected rate of coancestry at t 1 ences between expected and realised Δf tended to
+ m_ove-chr
(E(Δf )) given the solutions from the optimisation and increase when N decreased.
t+1
2.0
1.5
1.0
0.5
0.0
−0.5
f∆
rhc−vo_m
N = 20
2.0
1.5
1.0
0.5
0.0
−0.5
f∆
rhc−vo_m
N = 100
2.0
1.5
1.0
0.5
0.0
−0.5
Generation
f∆
rhc−vo_m
N = 200
1 2 3 4 5 6 7 8 9 10
Fig. 1 Expected (dotted lines) and observed (straight lines) rate of genomic coancestry computed for the whole genome except chromosome 1
(Δf , in %) in the offspring generation, when the optimisation strategy was CHR with a restriction on the rate of coancestry in the rest of
m_ove‑chr _ove
the genome of 0.1 % for three population sizes (N). The specific imposed restrictions are indicated as filled circles

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 8 of 17
Although the results shown in Fig. 1 were consist- Table 5 shows the results for strategies OVE and
ent across replicates, generations and population sizes, OVE , for which contributions were optimised for
_reg
another analysis was carried out in order to test if these minimising overall coancestry (f ) with or without
m_ove
results can be explained by variation due to Mendelian a restriction on the increase of coancestry at specific
inheritance. Given a group of selected candidates which regions of the genome (Δf ). Here, the restrictions on
m_reg
were assigned an optimal contribution to fulfil a given Δf used in strategy OVE_reg were more stringent (i.e.
m_reg
constraint, 1000 sets of offspring generations were cre- C 0.10 and 0.01 %) than those imposed under strategies
=
ated using the same contributions. For each set, the real- CHR_ove and REG_ove (i.e. C 1 and 0.1 %). The inclu-
=
ised average coancestry for the restricted regions was sion of a constraint on Δf (i.e. OVE ) managed to
m_reg _reg
calculated and compared to the expected value. Figure 2 lower Δf (and such reduction was greater with the more
shows the distribution of average coancestry for three stringent constraint, e.g., C 0.01 %), but, as in CHR
= _ove
independent sets of parents (and consequently, with dif- and REG , the realised values did not fulfil the imposed
_ove
ferent optimal contributions). For all three sets of par- constraint (i.e. the realised Δf was greater than the C
m_reg
ents, the realised average coancestry in the offspring used).
generation was always higher than the expected value An interesting observation among these scenarios was
given the optimal contribution. Specifically, the observed the proportion of candidates which were selected to
rate of coancestry was approximately double the intended contribute offspring to the following generation and the
rate. variance of the number of offspring generated by each
217.0 717.0 227.0
350
300
250
200
150
100
50
0
127.0 627.0 137.0 217.0 617.0 27.0
Overall coancestry
ycneuqerF
Fig. 2 Distribution of observed average genomic coancestry in the offspring generation of three sets of parents. For each set of parents 1000
offspring generations were created using the same parental optimised contributions. The size of the assumed population was N 20, and the opti‑
=
misation strategy was CHR with an overall coancestry restriction of 0.1 %. Dotted lines indicate the targeted coancestry for each set of parents
_ove

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 9 of 17
Table 5 Average rate of genomic coancestry (in %) in specific regions and in the rest of the genome across generations
(t), when applying two different management strategies (OVE and OVE ) for populations of two different sizes (N)
_reg
| N   | t   | Specific regions |            |            | Rest of the genome |            |            |
| --- | --- | ---------------- | ---------- | ---------- | ------------------ | ---------- | ---------- |
|     |     | OVE              | OVE        |            | OVE                | OVE        |            |
|     |     |                  | _reg       |            |                    | _reg       |            |
|     |     |                  | C   0.10 % | C   0.01 % |                    | C   0.10 % | C   0.01 % |
|     |     |                  | =          | =          |                    | =          | =          |
| 20  | 1   | 0.35             | 0.35       | 0.35       | 0.23               | 0.25       | 0.25       |
|     | 2   | 1.23             | 0.81       | 0.80       | 1.07               | 1.05       | 1.09       |
|     | 3   | 1.33             | 1.27       | 0.67       | 1.14               | 1.15       | 1.23       |
|     | 4   | 0.89             | 1.23       | 0.83       | 1.08               | 1.15       | 1.05       |
|     | 5   | 0.98             | 0.92       | 0.76       | 1.06               | 1.06       | 1.19       |
|     | 10  | 0.81             | 0.68       | 0.84       | 1.07               | 1.07       | 1.16       |
| 100 | 1   | 0.48             | 0.49       | 0.49       | 0.51               | 0.49       | 0.47       |
|     |     | −                | −          | −          | −                  | −          | −          |
|     | 2   | 0.15             | 0.19       | 0.16       | 0.16               | 0.11       | 0.12       |
|     |     | −                | −          | −          | −                  | −          | −          |
|     | 3   | 0.18             | 0.15       | 0.19       | 0.07               | 0.07       | 0.06       |
|     |     | −                | −          | −          | −                  | −          | −          |
|     | 4   | 0.05             | 0.07       | 0.05       | 0.06               | 0.09       | 0.06       |
|     |     | −                | −          | −          | −                  | −          | −          |
|     | 5   | 0.25             | 0.27       | 0.29       | 0.03               | 0.02       | 0.07       |
|     |     | −                | −          | −          | −                  | −          | −          |
|     | 10  | 0.05             | 0.05       | 0.02       | 0.03               | 0.03       | 0.03       |
|     |     | −                | −          | −          | −                  | −          | −          |
Two different constraints (C) were imposed on the coancestry rate in each of the specific regions when applying strategy OVE
_reg
OVE contributions are optimised to minimise f m_ove , OVE _reg  contributions are optimised to minimise f m_ove  while restricting Δf m_reg
of coancestry in the offspring generation based on cur-
candidate (Tables 6, 7). Under random selection, this
variance was close to 2, which is the theoretical expected  rent genetic contribution theory can be biased down-
value if contributions follow a Poisson distribution. The  wards when using genomic coancestries. This may result
optimisation using pedigree coancestry resulted in all  in the rate of loss in genetic diversity at restricted regions
individuals  contributing  equally  (i.e.,  every  candidate  being higher than that set during management.
generates  two  offspring),  which  is  expected  since  all  Genomic relationship matrices that are based on high-
individuals in the base population were assumed to be  density SNP genotyping data can more accurately reflect
non-inbred and unrelated. However, when considering  the true relationships between individuals than the stand-
genomic coancestry, the proportion of selected candi- ard pedigree-based coancestry matrix because they take
dates differed substantially across strategies with OVE  into account the variability in the genetic information
having the largest number of selected candidates, CHR  received by each full-sib due to Mendelian segregation of
the smallest and REG somewhere in between. In general,  SNPs. Hence, it is not surprising that using the genomic
in the first generation, the proportion of candidates actu- coancestry matrix in OC (OVE) was more efficient in
ally contributing was lower than in the following genera- preserving genetic diversity than using pedigree-based
tions. This proportion was also lower for N   100 than  relationships (PED). However, this was true only if the
=
level of LD in the SNP panel was sufficiently high to rep-
for N  =  20. The inclusion of a constraint on the rate of
coancestry in the minimisation (OVE , REG , CHR resent the genome sequence not covered by SNPs. This
|     |     |     | _reg _ove | _   |     |     |     |
| --- | --- | --- | --------- | --- | --- | --- | --- |
) resulted in a slight increase in the number of selected  study showed that the rate of average coancestry was bet-
ove
candidates (cf. OVE, CHR, REG). ter minimised under strategy OVE than under strategy
PED for the population generated with the lowest muta-
Discussion
tion rate (which led to higher LD in the SNP panel). The
This study shows that the optimal contribution method  superiority of OVE over PED was clear for N   100, with
=
based on semidefinite programming can use genomic  the genetic diversity even increasing with OVE (Table 2).
coancestry  calculated  from  dense  panels  of  biallelic  These results were, however, not reproduced when con-
molecular  markers  to  efficiently  control  the  loss  of  sidering the population with the highest mutation rate.
genetic variability in specific genomic regions. Moreover,  In this case, OVE performed better (i.e., lower Δf) than
the method can also be easily extended to add constraints  PED in the first generation, but slightly worse (i.e., higher
for  simultaneously  maintaining  the  loss  of  diversity  Δf) in later generations. This finding agrees with previous
across the rest of the genome at an acceptable rate. This  results of Gómez-Romano et al. [8].
study also found that the prediction of the expected level

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 10 of 17
Table 6 Percentage of individuals that contributed to the next generation (N ) and variance of the number of offspring
cont
(V) when applying different management strategies (RAN, PED, OVE, REG, CHR) for populations of two different sizes (N)
c
| N   | t   | RAN  |      | PED  |     | OVE    |      | REG  |       | CHR  |       |
| --- | --- | ---- | ---- | ---- | --- | ------ | ---- | ---- | ----- | ---- | ----- |
|     |     | N    | V    | N    | V   | N      | V    | N    | V     | N    | V     |
|     |     | cont | c    | cont |     | c cont | c    | cont | c     | cont | c     |
| 20  | 0   | 88.4 | 1.77 | 100  | 0   | 81.0   | 2.28 | 56.7 | 6.00  | 47.0 | 8.57  |
|     | 1   | 87.0 | 1.83 | 100  | 0   | 90.3   | 1.37 | 61.1 | 4.88  | 49.0 | 7.30  |
|     | 2   | 88.4 | 1.80 | 100  | 0   | 91.4   | 1.25 | 62.2 | 4.63  | 53.8 | 6.22  |
|     | 3   | 86.0 | 2.03 | 100  | 0   | 89.8   | 1.40 | 65.4 | 4.06  | 56.2 | 5.72  |
|     | 4   | 88.5 | 1.70 | 100  | 0   | 90.1   | 1.33 | 65.5 | 3.98  | 56.7 | 5.61  |
|     | 9   | 89.5 | 1.64 | 100  | 0   | 90.5   | 1.26 | 71.6 | 3.18  | 63.3 | 4.41  |
| 100 | 0   | 85.6 | 2.10 | 100  | 0   | 54.3   | 6.33 | 34.0 | 13.67 | 23.6 | 23.64 |
|     | 1   | 86.4 | 1.97 | 100  | 0   | 60.1   | 5.12 | 38.4 | 11.49 | 26.3 | 18.46 |
|     | 2   | 87.1 | 1.95 | 100  | 0   | 61.4   | 4.88 | 39.9 | 10.54 | 28.6 | 16.88 |
|     | 3   | 86.1 | 2.07 | 100  | 0   | 61.3   | 4.52 | 42.0 | 9.88  | 29.1 | 15.49 |
|     | 4   | 87.9 | 1.96 | 100  | 0   | 65.0   | 4.43 | 44.6 | 9.10  | 30.1 | 15.86 |
|     | 9   | 86.9 | 1.99 | 100  | 0   | 81.0   | 2.28 | 51.3 | 6.97  | 47.0 | 8.57  |
RAN contributions are assigned at random, PED contributions are optimised to minimise f, OVE contributions are optimised to minimise f , REG contributions are
|                         |     |                                                 |     |     |     | p     |     |     | m_ove |     |     |
| ----------------------- | --- | ----------------------------------------------- | --- | --- | --- | ----- | --- | --- | ----- | --- | --- |
| optimised to minimise f |     | , CHR contributions are optimised to minimise f |     |     |     |       |     |     |       |     |     |
|                         |     | m_reg                                           |     |     |     | m_chr |     |     |       |     |     |
Table 7 Percentage of individuals that contributed to the next generation (N ) and variance of the number of offspring
cont
(V) when applying different management strategies (OVE , REG , CHR ) for populations of two different sizes (N)
| c   |     |      |     |     |     | _reg | _ove _ove |     |      |     |     |
| --- | --- | ---- | --- | --- | --- | ---- | --------- | --- | ---- | --- | --- |
| N   | t   | OVE  |     |     | REG |      |           |     | CHR  |     |     |
|     |     | _reg |     |     |     | _ove |           |     | _ove |     |     |
C   0.10 % C   0.01 % C   1.0 % C   0.10 % C   1.0 % C   0.10 %
|     |     | =    | =      |     |      | =   | =    |     | =      | =    |     |
| --- | --- | ---- | ------ | --- | ---- | --- | ---- | --- | ------ | ---- | --- |
|     |     | N V  | N      | V   | N    | V   | N    | V   | N V    | N    | V   |
|     |     | cont | c cont | c   | cont | c   | cont | c   | cont c | cont | c   |
20 0 84.8 1.75 88.1 1.44 72.3 3.68 76.70 5.99 63.6 4.58 68.8 3.73
1 93.1 1.04 96.2 0.78 80.6 2.14 81.10 4.88 69.8 3.55 79.1 2.52
2 94.8 0.90 96.7 0.69 83.1 1.90 82.30 4.62 70.1 3.44 78.0 2.41
3 94.4 0.92 96.6 0.70 84.1 1.81 85.20 4.07 72.9 3.24 81.2 2.24
4 94.8 0.86 96.5 0.71 84.1 1.82 85.50 4.00 72.6 3.28 82.3 2.06
9 95.1 0.85 97.4 0.68 85.9 1.78 89.70 3.17 73.4 3.03 83.6 1.91
100 0 55.4 6.12 56.0 5.83 38.1 11.48 51.90 7.12 35.5 13.29 43.9 9.59
1 61.4 4.78 61.4 5.05 40.2 10.43 56.70 5.96 35.0 14.14 47.0 7.95
2 63.8 4.43 64.6 4.15 40.9 10.28 57.80 5.47 36.1 12.74 49.6 7.70
3 64.7 4.29 66.1 3.97 43.4 9.51 58.10 5.43 35.4 12.92 49.4 7.91
4 65.8 4.08 66.5 4.04 44.0 9.08 60.60 5.00 35.5 13.42 51.8 7.21
9 67.5 3.74 69.5 3.54 50.3 7.31 63.70 4.39 38.5 11.30 52.9 6.38
Different restrictions (C) were applied on the rate of coancestry
OVE _reg  contributions are optimised to minimise f m_ove  while restricting Δf m_reg , REG _ove  contributions are optimised to minimise f m_reg  while restricting f m_ove‑reg , CHR _ove
| contributions are optimised to minimise f |     |     |  while restricting f |     |           |     |     |     |     |     |     |
| ----------------------------------------- | --- | --- | -------------------- | --- | --------- | --- | --- | --- | --- | --- | --- |
|                                           |     |     | m_chr                |     | m_ove‑chr |     |     |     |     |     |     |
The use of genomic relationship matrices also allowed  variability may be equally good or bad for all regions on
us to maintain (or even increase) genetic diversity in the  the same chromosome. This is consistent with the finding
targeted regions (Tables 3, 4). The efficiency in maintain- that the optimization was more efficient when it aimed
ing genetic diversity was greater when the regions were  at maintaining the genetic diversity in only a few regions
located on a single chromosome (CHR) than when they  than when the entire genome was targeted (cf. OVE vs.
were scattered across different chromosomes (REG). This  CHR and REG; Tables 2, 3, 4).
is not surprising since the level of coancestry in a region  However, the efficiency in reducing the rate of coances-
will be somewhat correlated to that of other regions on  try in specific regions was accompanied by a substantial
the same chromosome, thus a solution for maintaining  increase in the rate of coancestry across the rest of the

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 11 of 17
genome (which could be several fold higher than when point of view for breeding, not knowing the magnitude of
assuming random selection), as previously described by the change (provided it is in the right direction) is prob-
Roughsedge et al. [14]. Moreover, the performance in ably less of a problem than crossing a threshold on the
preserving genetic diversity in the targeted regions was maximum rate allowed. Hence, refinement of the theory
paralleled by a detrimental effect observed across the to account for this bias is more important for a breeding
rest of the genome (i.e., CHR preserved genetic diver- scheme where the objective is to maximise genetic gain
sity in the targeted regions more efficiently than REG, while restricting the rate of coancestry to a given value.
but it resulted in more loss of diversity for the rest of However, such breeding programmes generally involve
the genome). Our work shows that this undesired con- populations of medium to large size, hence the expected
sequence can be mitigated by imposing a constraint on bias with the current approach will be relatively small.
the rate of coancestry across the rest of the genome (cf. It is well known that in the absence of molecular or
REG and CHR ; Tables 3, 4). pedigree information, keeping equal numbers of males
_ove _ove
We observed an unexpected result when minimising and females and constant census sizes (i.e., equalis-
the rate of coancestry for specific regions and simultane- ing contributions) is the most appropriate procedure to
ously imposing a restriction on the rate of coancestry in minimize loss of genetic diversity [18]. In the present
other regions (strategies REG and CHR , OVE ), study, pedigree relationships between individuals of the
_ove _ove _reg
i.e. the realised rate of coancestry in the restricted regions base population were assumed to be unknown (and indi-
was always higher than the imposed restriction, particu- viduals were assumed to be unrelated and non-inbred)
larly for the lowest N value (Tables 3, 4, 5). This result and thus, when minimising Δf , the optimal solution
p
was observed in spite of the fact that the optimal solu- was to equalise contributions. This occurred not only
tion fulfilled the restriction that the expected Δf for the first generation but also in subsequent genera-
m_ove-chr
should not be larger than the restriction imposed (Figs. 1, tions, provided the population remained homogene-
2). This finding is similar to that previously reported ous at the pedigree level. However, for strategies using
by Roughsedge et al. [14] who also showed a clear dis- genomic coancestry, equalising contributions was never
crepancy between the observed and expected rates of the optimal solution because marker genotypes differ-
molecular inbreeding at specific positions of the genome. entiated genetic relationships between pairs of individu-
This leads to the conclusion that, when using genomic als with the same degree of pedigree-based coancestry.
coancestry matrices, the equation f c′Gc is a biased In fact, the OVE strategy led to lower Δf than the PED
=
estimator of the expected mean coancestry in the next strategy, while using fewer individuals for breeding and
generation. This equation was adopted from the genetic with unequal contributions, especially for N 100. This
=
contribution theory [17] and was derived based on the implies that, in addition to maintaining a higher level of
infinitesimal model and assuming that the coancestry genetic diversity, the use of genomic coancestry could
matrix is calculated using pedigree information. Ini- have some economic advantages when managing genetic
tially, it appeared justified to use this equation since the conservation programmes, since fewer animals need to
genomic relationship matrix is just a more refined esti- be maintained (i.e., animals not contributing to the next
mate of the coancestry that accounts to some extent for generation could be discarded).
the additional variation due to Mendelian inheritance. Several methods have been proposed and implemented
However, the fact that the expected value predicted with in the past to solve the OC problem. They mainly fall
the equation was consistently biased downward and the into three different categories: (1) Lagrange multipli-
magnitude of this bias depended on the population size ers [1, 2]; (2) genetic algorithms [19]; and (3) semidefi-
(the smaller is N, the greater is the bias) suggests that nite programming (SDP) approaches [15]. The Lagrange
some additional terms are arising from the Mendelian multiplier approach is fast and very efficient but does not
inheritance variance, which need to be accounted for guarantee the optimal solution to be found [15]. Also,
when predicting the expected coancestry in the offspring including additional constraints under the Lagrange
generation. Hence, a revision of contribution theory is multiplier approach requires major reformulation of the
needed to properly use genomic relationship matrices equations that are needed to find the optimal solution.
to manage genetic diversity. This study showed that this Methodologies based on genetic algorithms are very flex-
biased predictor can still be used to control the change ible in terms of adding or removing constraints but the
in coancestry but the amount of change may not be cor- sampling approach on which the method is based means
rectly estimated. However, this bias would have a more that optimality of the final solution cannot be verified.
profound effect when using c′Gc as a restriction on the Also, they can be computer intensive, depending on the
maximum coancestry to be allowed than when mini- constraints included. The SDP approach guarantees that
mizing it in an objective function. Also from a practical the solution found is the optimal. The method is also fast

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 12 of 17
and flexible, since additional constraints can be easily reference alleles in the genotype (i.e., 0, 1, 2) and p is its
added to the optimisation. In addition, general software frequency. Similarly, this relationship can be normalised
packages for solving optimisation problems with SDP are (weighted) by its frequency, leading to an estimate equal
available [16, 20–22]. to (x 2p)(x 2p)/(2p(1 p)). Then, the overall rela-
i − j − −
The main limitation of the SDP methodology is that the tionship between two individuals is the average across all
constraints and objective functions need to be convex, SNPs in the whole genome or in the regions of interest
which for the situation considered here means that the (times some constant). Such relationship matrices have
coancestry matrices must be positive definite. Such prop- been widely used with great success in different methods
erty should hold when the genomic relationship matrices to calculate genomic predictions of breeding values (e.g.
are calculated using the method proposed by Nejati- [5]), but the justification for using them as an estimate of
Javaremi et al. [3], as done here. However, in practice, it the coefficient of coancestry (and thereby its validity to
is likely that genotypes will be missing for a proportion model genetic diversity) is less clear. First, a close exami-
of the SNPs, so coancestries may be calculated with a nation of both (the normalised and the un-normalised)
slightly different set of SNPs for each pair of individuals, formulae shows that the values for the relationship esti-
which in certain situations can result in the genomic rela- mates range from 1 to x, where x can be substantially
−
tionship matrix being non-positive definite. This prob- larger than 1 (depending on the allele frequency). This
lem could be solved by adding a very small quantity to all means that relationship estimates calculated with these
diagonal elements of the matrix, so that it becomes posi- methods can be clearly outside the valid range for a coef-
tive definite. However, the consequences of this for opti- ficient of coancestry (i.e., [0:1]). Practical experience has
mality of the solution are yet to be quantified. Another shown that estimates of the average coancestry across
potential problem is that the SDP implementation the whole genome tend to be within the valid range but
requires the inverse of the genomic relationship matri- this may not be the case when considering a smaller
ces (see “Appendix”), which may not exist, especially region with few genotyped SNPs. Second, the relation-
when considering small genomic regions. For instance, ship calculated from the cross-product of the centered
if two sibs inherit the same haplotypes for the region in genotype score results in a pair of individuals that are
question from their common parent, their relationship homozygous for the minor allele in having a higher rela-
with the rest of the candidates will be the same and the tionship value than another pair of individuals that are
resulting matrix will be non-invertible. Similarly, when homozygous for the most frequent allele and, thus, those
the number of SNPs used to calculate the genomic rela- carrying rare alleles would be penalised when optimis-
tionship matrix is smaller than the number of candidates, ing contributions. Third, centering the genotype score
the matrix will also be non-invertible. A solution for this makes the matrix non-invertible (even when the number
problem could be to use the Moore–Penrose generalised of SNPs in the region is larger than the number of can-
inverse of the genomic matrix or to add a small constant didates), which adds a complication to the semidefinite
to all diagonal elements. Further studies are required to optimisation.
determine the consequence of using generalised inverse However, it is conceivable that, in practical conserva-
matrices in this context. tion programmes, one may need to consider both meth-
A key component to successfully manage genetic ods to calculate genomic relationship matrices (i.e. allelic
diversity using genomic relationship matrices is that similarity and crossproduct of genotype score), depend-
they are good estimates of the genomic coancestry, such ing on what is needed for the preserved population. The
that their use to predict the expected average coances- use of these genomic relationship matrices in the objec-
try in the offspring generation (i.e., f c′Gc) is justified tive function impacts the trajectory of the change in gene
=
(although they may be biased). In this study, the allelic frequency in different manners. Intuitively, it appears that
similarity method proposed by Nejati-Javaremi et al. [3] optimisation with the ‘allelic-similarity’ matrices [3] would
was used to calculate genomic relationships, since this favour solutions that tend to drive the gene frequency
method (i.e.,
(0.25) 2
i=1
2
j=1
δ
ij) has a ‘natural’ inter- towards 0.5. Conversely, optimisation using the ‘crossprod-
pretation in relation(cid:31) to th(cid:31)e definition of the coefficient uct’ matrices [4] will lead to solutions that are closer to the
of coancestry (i.e., the probability of randomly sampling average gene frequency, and thus will attempt to keep the
the same allele from both individuals). Other methods gene frequency unchanged (although rare alleles may still
for calculating genomic relationships, mainly based on be lost due to drift). Thus, considering that conservation
the cross-product of the centered (and normalised) geno- programmes generally aim at (1) increasing genetic diver-
type score, have also been proposed (e.g., [4]). For a given sity and (2) maintaining the uniqueness of the population,
SNP, the relationship between two individuals i and j, the choice of how coancestry is quantified may depend on
is equal to (x 2p)(x 2p), where x is the number of which of these two objectives is more important. On the
i − j −

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 13 of 17
one hand, using the ‘allelic similarity’ matrix may increase over time. Thus, breeding programmes should begin by
genetic diversity but also the risk of changing the charac- considering a few regions and gradually become more
teristics of the population. However, on the other hand, use sophisticated by adding more (with newly discovered
of the ‘cross-product’ matrix will favour the status quo, i.e. loci), while perhaps reducing the length of each region.
will better preserve the original characteristics of the popu- Clearly, the approach proposed here will permit a much
lation but at the same time, rare alleles may be lost due to better control in the management of genetic diversity in
drift. Clearly, a more extensive study is necessary to under- conservation programmes.
stand the principles that justify the use of different genomic
Conclusions
relationship matrices in management of genetic diversity.
In this study, we developed OC methodology to sepa- This study confirms that the use of genomic coances-
rately control genetic diversity in specific regions of the try in the optimisation of contributions is substantially
genome, and thereby allow for a better and more cus- more efficient in maintaining genetic diversity than
tomised solution to management of genetic diversity. the use of pedigree coancestry. Moreover, the use of
This added flexibility has great value since genomic data genomic coancestry permits the targeting of specific
shows that nucleotide diversity varies greatly across the genomic regions to minimise the loss of genetic diver-
genome (e.g., [12, 13]), probably as a result of evolution- sity and the extension of the optimisation procedure to
ary forces such as genetic drift and selection. In practical include restrictions for additional regions. This study
conservation programmes, regions that display a greater also highlighted the need to refine the theory of genetic
loss of diversity should be prioritized to better avoid fur- contributions using realised genomic relationship matri-
ther loss of diversity in those regions. Consequently, the ces in order to ensure that optimal contribution meth-
conservation scheme would be more successful by put- ods properly manage the genetic diversity available in a
ting more emphasis on these regions (using schemes population.
such as REG_reg or OVER_reg), rather than just max-
Authors’ contributions
imising the overall average diversity. Moreover, there BV, JF and RPW jointly conceived the design of the study. FGR and RPW devel‑
are genomic regions that include specific loci that are oped the simulation programs. FGR performed the simulations and wrote the
first draft of the manuscript. All authors discussed the results, made sugges‑
particularly relevant in terms of genetic diversity and it
tions and corrections. All authors read and approved the final manuscript.
would be useful to be able to control these regions sepa-
rately. Examples are the MHC region that is involved in Author details
1 Departamento de Mejora Genética Animal, INIA, Madrid, Spain. 2 The Roslin
general resistance to disease and regions that have been
Institute and the R(D)SVS, University of Edinburgh, Edinburgh, UK.
reported to be responsible for inbreeding depression [9,
10, 23]. Clearly, a high level of genetic diversity is desir- Acknowledgements
This work was funded by the Ministerio de Economía y Competitividad, Spain
able in those regions to ensure that the population can
(Grant CGL2012‑39861‑C02‑02). The Roslin Institute receives financial support
deal with potential new disease challenges and to avoid from the BBSRC. We also thank funding from the QUANTOMICS (222664‑2)
the detrimental effects of inbreeding depression. The list and GENE2FARM (289592) EU Projects.
of regions that include genes of interest is not complete
Competing interests
(and probably never will be) but it is likely to increase The authors declare that they have no competing interests.
Appendix: Formulation of the optimisation of genetic contributions to minimise loss of diversity as a
standard semidefinite programming
The optimisation of genetic contributions to minimise the increase of average coancestry (i.e., the loss of genetic diver-
sity) is reformulated as a standard semidefinite programming using the same approach that was proposed by Pong-
Wong and Woolliams [15]. However, small variations in the definition of genetic relationships and refinements in the
optimisation problem mean that equations representing the standard semidefinite programming are slightly different
to those reported by Pong-Wong and Woolliams [15]. The purpose of this Appendix is to briefly describe the precise
reformulation of the optimisation problem used in this study.
Pong-Wong and Woolliams [15] showed that the problem of optimisation of contribution can be reformulated as a
standard semidefinite programming, and thereby solved using such an approach. Following the notation of Vanden-
berghe and Boyd [24], the standard form for a semidefinite programming problem is:
Minimise
a′x,
n
subjectto Y ≥0,Y =Y + Yx,
0 i i
(cid:31)i=1

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 14 of 17
where a is the vector of ‘cost’, x is the vector of n variables to be optimised, x is the i element of x, Y is a positive sem-
i
idefinite matrix with n   1 affine matrices (Y, i   0, 1, 2, …, n). The matrix inequality Y   0 means that Y is positive
|     |     | +   |     |     | i = |     |     |     | ≥   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
semidefinite.
Optimisation problem 1
Following the same approach as Pong-Wong and Woolliams [15], the reformulation of optimisation problem 1 is done by
(1) introducing an auxiliary variable v to serve as the upper limit of the objective function, (2) using the Shur complement
to give a linear expression to the quadratic constraint; and (3) replacing the equality constraints by inequality constraints.
Hence, the optimisation problem 1 is reformulated as the optimisation of v and c to:
| Minimise  | v,        |             |     |     |     |     |     |     |     |
| --------- | --------- | ----------- | --- | --- | --- | --- | --- | --- | --- |
|           |           | G−1 c       |     |     |     |     |     |     |     |
| subjectto |           |             | ≥0, |     |     |     |     |     |     |
|           | (cid:31)  | c v(cid:30) |     |     |     |     |     |     |     |
|           | c′s−0.5≥  |             | 0,  |     |     |     |     |     |     |
|           | −c′s+0.5≥ |             | 0,  |     |     |     |     |     |     |
|           | c′d−0.5≥  |             | 0,  |     |     |     |     |     |     |
−c′d+0.5≥
0,
c≥ 0.
Then, matrix Y accounting for the six constraints is a block diagonal matrix of the form:
|     | G−1 | c   |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
c′ v�
|     | �  |     |     |     |     |     |     |    |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
c′s−0.5
|      |    |     |     |          |     |     |     |    |     |
| ---- | --- | --- | --- | -------- | --- | --- | --- | --- | --- |
| Y = |     | �   | �   | −c′s+0.5 |     |     |     |    |     |
|      |    |     |     |          |     |     |     |    |     |
c′d−0.5
|     |    |     | �   |     | �   |          |              |    |     |
| --- | --- | --- | --- | --- | --- | -------- | ------------ | --- | --- |
|     |    |     |     |     |     | −c′d−0.5 |              |    |     |
|     |    |     |     |     | �   | �        |              |    |     |
|     |    |     |     |     |     |          |              |    |     |
|     |    |     |     |     |     | �        | � [diag(c)] |     |     |
|     |    |     |     |     |     |          |              |    |     |
with the (n
+  2) affine matrices of Y equal to:
G−1
0(nx1)
|     | �0(1xn) | 0   | �   |     |    |     |     |     |     |
| --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
−0.5
| Y = |     |     |     | 0.5  |    |     |     |     |     |
| ---- | --- | --- | --- | ---- | --- | --- | --- | --- | --- |
| 0    |    |     |     |      |    |     |     |     |     |
|      |    |     |     | −0.5 |    |     |     |     |     |
|      |    |     |     |      |    |     |     |     |     |
|      |    |     |     |      |    |     |     |     |     |
0.5
|     |       |     |     |     |     |     |     |     |     |
| --- | ------ | --- | --- | --- | ---- | --- | --- | --- | --- |
|     |       |     |     |     | [0] |     |     |     |     |
|     |       |     |     |     |     |     |     |     |     |
|     | 0(nxn) | I   |     |     |      |     |     |     |     |
i
′
|     | � I | 0�  |     |     |    |     |     |     |     |
| --- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
i
s
i
| Y = |        |        | −s  |         |  ,   | i=1,n, |     |     |     |
| ---- | ------ | ------ | --- | ------- | ----- | ------ | --- | --- | --- |
| i    |       |        | i   |         |      |        |     |     |     |
|      |       |        | d   |         |      |        |     |     |     |
|      |       |        | i   |         |      |        |     |     |     |
|      |       |        |     | −d      |      |        |     |     |     |
|      |       |        |     | i       |      |        |     |     |     |
|      |       |        |     | [diag(I | i )] |        |     |     |     |
|      |       |        |     |         |      |        |     |     |     |
|      | 0(nxn) | 0(nx1) |     |         |       |        |     |     |     |
and
|     | �0(1xn) |     | 1 � |     |    |     |     |     |     |
| --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
0
| Y   | =  |     | 0   |        |  , |     |     |     |     |
| --- | --- | --- | --- | ------ | --- | --- | --- | --- | --- |
| n+1 |    |     |     |        |    |     |     |     |     |
|     |    |     |     |        |    |     |     |     |     |
|     |    |     |     | 0      |    |     |     |     |     |
|     |    |     |     | 0      |    |     |     |     |     |
|     |    |     |     |        |    |     |     |     |     |
|     |    |     |     | 0(nxn) |    |     |     |     |     |
|     |    |     |     |        |    |     |     |     |     |
� �

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 15 of 17
| where the size of the first block is (n  |     |     |     |     |  (n  |     |     |     |     |     |     |     |
| ---------------------------------------- | --- | --- | --- | --- | ---- | --- | --- | --- | --- | --- | --- | --- |
+  1)  × +  1), the sizes of the next four are 1  ×  1 and the size of the last one is
n   n. 0  are matrices/vectors of zeros of size j   k, I is the i column of the identity matrix of size n   n and diag(I)
| ×   | (j × k) |     |     |     |     | ×   | i   |     |     |     | ×   | i   |
| --- | ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
is a diagonal matrix with diagonal equal to I. All elements outside the block diagonal matrices are 0. Note that the
i
formulation described above differs from that given in Eq. (8) of Pong-Wong and Woolliams [15] by a constant value
in first block of Y . This is to account for the difference in the definition of relationship matrix (i.e., here the rela-
0
tion matrix contains coefficients of coancestry between individuals; whereas it is twice this value for Pong-Wong and
Woolliams [15]).
Optimisation problem 2
Reformulation of optimisation problem 2 is similar to that above, but the m additional constraints need to be added.
Hence, using the Shur complement again, the formulation of (2) becomes:
| Minimise | v,  |     |     |     |     |     |     |     |     |     |     |     |
| -------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
subjectto:
G−1 c
≥0,
(cid:31) c v(cid:30)
−1
|          | G c            |        |     |     |     |     |     |     |     |     |     |     |
| -------- | -------------- | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|          | j ≥0,          | j =1,m |     |     |     |     |     |     |     |     |     |     |
| (cid:31) | c k j (cid:30) |        |     |     |     |     |     |     |     |     |     |     |
c′s−0.5≥
0,
−c′s+0.5≥
0,
| c′d−0.5≥  | 0,  |     |     |     |     |     |     |     |     |     |     |     |
| --------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| −c′d+0.5≥ |     | 0,  |     |     |     |     |     |     |     |     |     |     |
c≥
0,
and the matrix Y is augmented to be:
G−1
c
|     | � c′ | v�  |     |     |     |     |     |     |     |     |     |    |
| --- | ----- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
−1
|     |     |     | G   | c ··· |     |       |         |            |         |          |            |     |
| --- | --- | --- | --- | ----- | --- | ----- | ------- | ---------- | ------- | -------- | ---------- | --- |
|     |    |     | 1 ′ |       |     |       |         |            |         |          |            |    |
|     |    | �  | c   | k 1�  |     |      |         |            |         |          |            |    |
|     |    |     |     |       |     |       |         |            |         |          |            |    |
|     |    |     | .   | ...   |     | .     |         |            |         |          |            |    |
|     |     |     | .   |       |     | .     |         |            |         |          |            |     |
|     |    |    | .   |       |     | .    |         |            |         |          |            |    |
|     |    |    |     |       | −   |      |         |            |         |          |            |    |
| Y   | =  |    |     |       | G   | 1 c  |         |            |         |          |            |  , |
|     |    |    |     | ···   | j   |      |         |            |         |          |            |    |
|     |    |    |     |       | c′  | �    |         |            |         |          |            |    |
|     |     |     |     |       | �   | k j   |         |            |         |          |            |     |
|     |    |    |     |       |     |      | c′s−0.5 |            |         |          |            |    |
|     |    |     |     |       |     |       |         |            |         |          |            |    |
|     |    |     |     |       |     |       |         |            |         |          |            |    |
|     |    |     |     |       |     |       | �       | � −c′s+0.5 |         |          |            |    |
|     |    |     |     |       |     |       |         |            |         |          |            |    |
|     |    |     |     |       |     |       |         |            | c′d−0.5 |          |            |    |
|     |     |     |     |       |     |       |         | �          | �       |          |            |     |
|     |    |     |     |       |     |       |         |            |         | −c′d−0.5 |            |    |
|     |    |     |     |       |     |       |         |            | �       | �        |            |    |
|     |    |     |     |       |     |       |         |            |         |          |            |    |
|     |    |     |     |       |     |       |         |            |         |          | [diag(c)] |     |
|     |    |     |     |       |     |       |         |            |         | �        | �          |    |
with the (n
|     | +  2) affine matrices of Y equal to: |     |     |     |     |     |     |     |     |     |     |     |
| --- | ------------------------------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
G−1
0(nx1)
|     | �0(1xn) | 0   | �   |     |     |     |     |     |     |     |     |     |
| --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

|     |       |     |          | G − 1 | 0(nx1) |     |          |      |      |       |     |     |
| --- | ----- | --- | -------- | ----- | ------ | --- | -------- | ---- | ---- | ----- | --- | --- |
|     |       |     |          | 1     |        | ··· |          |      |      |       |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |      |     | �0(1xn) |       | K 1    | �   |          |     |      |      |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |       |     |          |       | .      | ... | .        |      |      |       |     |     |
|     |      |     |          |       | . .    |     | . .      |      |      |      |     |     |
|     |      |     |         |       |        |     |          |     |      |      |     |     |
|     |      |     |         |       |        |     | − 1      |     |      |      |     |     |
|     | Y =  |     |         |       |        |     | G 0(nx1) |     |      |  ,   |     |     |
|     | 0    |     |         |       |        | ··· | j        |     |      |      |     |     |
|     |      |     |         |       |        |     | �0(1xn)  | k � |      |      |     |     |
|     |       |     |         |       |        |     |          | j   |      |       |     |     |
|     |      |     |          |       |        |     |          | −0.5 |      |      |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |      |     |          |       |        |     |          |      | 0.5  |      |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |      |     |          |       |        |     |          |      | −0.5 |      |     |     |
|     |      |     |          |       |        |     |          |      |      | 0.5  |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |
|     |      |     |          |       |        |     |          |      |      | [0]  |     |     |
|     |      |     |          |       |        |     |          |      |      |      |     |     |

Gómez‑Romano et al. Genet Sel Evol  (2016) 48:2  Page 16 of 17
|     |     | 0(nxn) | I i |     |     |     |     |     |     |     |     |     |     |
| --- | --- | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
′
|     |     | � I | 0�  |     |     |     |     |     |     |     |     |     |     |
| --- | --- | ---- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |     | i    |     |     |     |     |     |     |     |     |    |     |     |
|     |     |      |     | 0(n | I   |     |     |     |     |     |     |     |     |
|     |     |      |     | xn) | i   |     |     |     |     |     |     |     |     |
|     |     |     |     | ′   | ··· |     |     |     |     |     |    |     |     |
|     |     |     | �  | I   | 0�  |     |    |     |     |     |    |     |     |
i
|     |      |    |     | .   | ... | .       |     |     |     |     |    |        |     |
| --- | ---- | --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- | ------ | --- |
|     |      |    |     | .   |     | .       |     |     |     |     |    |        |     |
|     |      |    |    | .   |     | .       |    |     |     |     |    |        |     |
|     |      |    |    |     |     |         |    |     |     |     |    |        |     |
|     | Y = |     |    |     |     | 0(n xn) | I  |     |     |     |  , | i=1,n, |     |
|     | i    |    |    |     | ··· | ′       | i  |     |     |     |    |        |     |
|     |      |     |    |     |     | I       | 0� |     |     |     |     |        |     |
|     |      |    |     |     | �   | i       |     |     |     |     |    |        |     |
|     |      |    |    |     |     |         |    |     |     |     |    |        |     |
|     |      |    |     |     |     |         |     | s i |     |     |    |        |     |
|     |      |    |     |     |     |         |     |     |     |     |    |        |     |
|     |      |    |     |     |     |         |     | −s  | i   |     |    |        |     |
|     |      |    |     |     |     |         |     |     |     |     |    |        |     |
d
|     |     |    |     |     |     |     |     |     | i   |         |    |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------- | --- | --- | --- |
|     |     |    |     |     |     |     |     |     | −d  |         |    |     |     |
|     |     |    |     |     |     |     |     |     |     | i       |    |     |     |
|     |     |    |     |     |     |     |     |     |     | [diag(I | )] |     |     |
|     |     |    |     |     |     |     |     |     |     |         | i  |     |     |
and
|     |     | 0(nxn)   | 0(nx1) |     |     |     |     |     |     |     |     |     |     |
| --- | --- | -------- | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |     | �0(1xn) | 1      | �   |     |     |     |     |     |     |     |     |     |

|     |     |     |     |     | 0(nxn) 0(nx1) |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | ------------- | --- | --- | --- | --- | --- | --- | --- | --- |
···
|     |       |    |     |          |     |     |         |        |      |     |     |    |     |
| --- | ----- | --- | --- | -------- | --- | --- | ------- | ------ | ---- | --- | --- | --- | --- |
|     |       |    |     | �0(1xn) | 0   | �   |         |        |      |    |     |    |     |
|     |       |    |     |          |     |     |         |        |      |     |     |    |     |
|     |       |     |     |          | .   | ... |         | .      |      |     |     |     |     |
|     |       |    |     |          | .   |     |         | .      |      |    |     |    |     |
|     |       |    |     |         | .   |     |         | .      |      |     |     |    |     |
|     |       |    |     |         |     |     |         |        |      |    |     |    |     |
|     | Y n+1 | =  |     |         |     |     | 0(nxn)  | 0(nx1) |      |    |     |  . |     |
|     |       |    |     |         |     | ··· |         |        |      |    |     |    |     |
|     |       |    |     |         |     |     | �0(1xn) |        | 0 � |     |     |    |     |
|     |       |     |     |         |     |     |         |        |      |    |     |     |     |
|     |       |    |     |          |     |     |         |        |      | 0   |     |    |     |
|     |       |    |     |          |     |     |         |        |      |     |     |    |     |
|     |       |    |     |          |     |     |         |        |      |     |     |    |     |
|     |       |    |     |          |     |     |         |        |      | 0   |     |    |     |
|     |       |    |     |          |     |     |         |        |      |     |     |    |     |
0
|     |     |    |     |     |     |     |     |     |     |     |        |    |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------ | --- | --- |
|     |     |    |     |     |     |     |     |     |     |     | 0      |    |     |
|     |     |    |     |     |     |     |     |     |     |     |        |    |     |
|     |     |    |     |     |     |     |     |     |     |     | 0(nxn) |    |     |
|     |     |    |     |     |     |     |     |     |     |     |        |    |     |
|     |     |     |     |     |     |     |     |     |     |     | �      | �   |     |
Once the optimisation has been reformulated as a standard semidefinite programming problem, it can easily be solved
using general available purpose programmes.
In this study, the software SDPA was used to solve the optimisation problem. It is important to note that there is a slight
n
difference between the definition for Y used here (i.e., Y =Y 0 + Y i x i, adopted from Vandenbergh and Boyd [24])
i=1
|                               |     |     |     | Y =−Y | + n   | Y x i, [16]). Hence, (cid:31)from a practical point of view, the matrix Y |     |     |     |     |     |     |             |
| ----------------------------- | --- | --- | --- | ----- | ----- | ------------------------------------------------------------------------- | --- | --- | --- | --- | --- | --- | ----------- |
| and that used in SDPA (i.e.,  |     |     |     |       | 0 i=1 | i                                                                         |     |     |     |     |     |     |  described  |
0
above needs to be multiplied by  1, befor(cid:31)e it is given as input to the SDPA programme.
−
 6.  de Cara MAR, Fernández J, Toro MA, Villanueva B. Using genomic wide
Received: 30 July 2015   Accepted: 19 November 2015
information to minimize the loss of diversity in conservation pro‑
grammes. J Anim Breed Genet. 2011;128:456–64.
 7.  Saura M, Fernández A, Rodríguez MC, Toro MA, Barragán C, Fernández AI,
et al. Genome‑wide estimates of coancestry and inbreeding in a closed
herd of ancient Iberian pigs. PLoS One. 2013;8:e78314.
 8.  Gómez‑Romano F, Villanueva B, de Cara MAR, Fernández J. Maintaining
References
genetic diversity using molecular coancestry: the effect of marker density
 1.  Meuwissen THE. Maximizing the response of selection with a predefined
rate of inbreeding. J Anim Sci. 1997;75:934–40. and effective population size. Genet Sel Evol. 2013;45:38.
 9.  Pryce JE, Haile‑Mariam M, Goddard ME, Hayes BJ. Identification of
 2.  Grundy B, Villanueva B, Woolliams JA. Dynamic selection procedures for
genomic regions associated with inbreeding depression in Holstein and
constrained inbreeding and their consequences for pedigree develop‑
Jersey dairy cattle. Genet Sel Evol. 2014;46:71.
ment. Genet Res (Camb). 1998;72:159–68.
 10.  Saura M, Fernández A, Varona L, Fernández AI, de Cara MÁR, Barragán C,
 3.  Nejati‑Javaremi A, Smith C, Gibson JP. Effect of total allelic relation‑
ship on accuracy of evaluation and response to selection. J Anim Sci.  et al. Detecting inbreeding depression for reproductive traits in Iberian
pigs using genome‑wide data. Genet Sel Evol. 2015;47:1.
1997;75:1738–45.
 11.  Engelsma KA, Veerkamp RF, Calus MPL, Bijma P, Windig JJ. Pedigree and
 4.  VanRaden PM. Efficient methods to compute genomic predictions. J
marker‑based methods in the estimation of genetic diversity in small
Dairy Sci. 2008;91:4414–23.
groups of Holstein cattle. J Anim Breed Genet. 2012;129:195–205.
 5.  Hayes BJ, Bowman PJ, Chamberlain AJ, Goddard ME. Invited review:
genomic selection in dairy cattle: Progress and challenges. J Dairy Sci.
2009;92:433–43.

Gómez‑Romano et al. Genet Sel Evol (2016) 48:2 Page 17 of 17
12. Esteve‑Codina A, Paudel Y, Ferretti L, Raineri E, Megens HJ, Silió L, et al. 19. Carvalheiro R, De Queiroz SA, Kinghorn B. Optimum contribution selec‑
Dissecting structural and nucleotide genome wide variation in inbred tion using differential evolution. R Bras Zootecn. 2010;39:1429–36.
Iberian pigs. BMC Genomics. 2013;14:148. 20. Borchers B. CSDP, A C library for semidefinite programming. Optim Meth‑
13. Sachidanandam R, Weissman D, Schmidt SC, Kakol JM, Stein LD, Marth ods Softw. 1999;11:613–23.
G, et al. A map of human genome sequence variation containing 1.42 21. Wu SP, Boyd S. Sdpsol: a parser/solver for semidefinite programs with
million single nucleotide polymorphisms. Nature. 2001;409:928–33. matrix structure. In: El Ghaoui L, Niculescu SI, editors. Advances in linear
14. Roughsedge T, Pong‑Wong R, Woolliams JA, Villanueva B. Restricting matrix inequality methods in control. SIAM: Philadelphia; 2000. p. 79–91.
coancestry and inbreeding at a specific position on the genome by using 22. Benson SJ, Yinyu Y. Algorithm 875: DSDP5—software for semidefinite
optimized selection. Genet Res (Camb). 2008;90:199–208. programming. ACM Trans Math Softw. 2008;34:1–16.
15. Pong‑Wong R, Woolliams JA. Optimisation of contribution of candidate 23. Howard JT, Maltecca C, Haile‑Mariam M, Hayes BJ, Pryce JE. Characterizing
parents to maximise genetic gain and restricting inbreeding using sem‑ homozygosity across United States, New Zealand and Australian Jersey
idefinite programming. Genet Sel Evol. 2007;39:3–25. cow and bull populations. BMC Genomics. 2015;16:187.
16. Fujisawa K, Kojima M, Nakata K, Yamashita M. SDPA (SemiDefinite Pro‑ 24. Vandenberghe L, Boyd S. Semidefinite programming. SIAM Rev.
gramming Algorithm) user’s manual—version 6.2.0. Res Rep Math Comp 1996;38:49–95.
Sci Ser B. 2004.
17. Woolliams JA, Thompson RA. Theory of genetic contributions. In:
Proceedings of the 5th World congress on genetics applied to livestock
production, Guelph, 7–12 Aug 1994, vol 25; 1994. pp. 127–34.
18. Falconer DS, Mackay TFC. Introduction to quantitative genetics. 4th ed.
Harlow: Longman Group Ltd; 1996.
Submit your next manuscript to BioMed Central
and we will help you at every step:
• We accept pre-submission inquiries
• Our selector tool helps you to find the most relevant journal
• We provide round the clock customer support
• Convenient online submission
• Thorough peer review
• Inclusion in PubMed and all major indexing services
• Maximum visibility for your research
Submit your manuscript at
www.biomedcentral.com/submit
