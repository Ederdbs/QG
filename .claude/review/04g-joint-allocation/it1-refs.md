# 04g-joint-allocation -- verificacao de referencias, iteracao 1

Capitulo: book/04g-joint-allocation.qmd (1321 linhas). Bib: book/references.bib.
Onde procurei: (1) copias locais: reference/papers/ (Caballero & Toro 2002, lido com pdftotext) e reference/new_sparsing_test/*.txt (Gonzalez-Dieguez 2026 lido; os demais cinco nao entram em 04g); (2) PubMed/PMC (resumos de 20 artigos; texto completo via Europe PMC de Thomsen 2026, Meuwissen 2020; Nei 1973 sem texto completo); (3) Crossref (metadados e resumos), Europe PMC REST, ideas.repec (Heslot), busca web. Comstock 1949 PENDENTE: nao e citado em 04g (grep nos .qmd do capitulo = 0 ocorrencias), nenhuma atribuicao a ele -> nenhum achado.

## Checagens 1 e 2: chaves e metadados
- 43 chaves `@` distintas (sem @sec/@fig/@tbl/@eq): todas existem em references.bib (nenhuma ausente).
- Metadados conferidos (autor, ano, titulo, periodico, volume, paginas, DOI) em Crossref para 35 entradas e em PubMed para 8 (lorenzi2022, melchinger2023, meuwissen2020, lubanga2025, montesinoslopez2022ibd/2023/2023genes/2024 e outras). Nenhum `update-to`/retratacao/corrigendum sinalizado. Nenhum DOI aponta para outro artigo.
- Notas menores (sem achado): isidro2015 (online 2014, impresso v.128 2015; bib = 2015, ok); rio2022 (online 2021, v.135 = 2022; ok); hoefler2026 sem numero de fasciculo (v.66 e70366; Crossref: i5); caballero2002 sem DOI-problema (Crossref grafa "Caballero*"); gonzalezdieguez2026 e heslot2020 e mothukuri2025 tem preprint associado (a bib cita a versao publicada, correto).

## Achados

### 04g-B1 [WRONG -- atribuicao incompleta/contraditada em parte] :365-367
"Sparse factorials train hybrid prediction at least as well as tester designs, and fewer crosses per line favours the lines never crossed [@seye2020; @lorenzi2022; @melchinger2023]."
- "pelo menos tao bem": Seye 2020 (resumo, PMID 32185420) confirma ("as efficient as tester design in additive scenarios, but significantly outperformed ... when SCA was present"); Lorenzi 2022 (PMID 35918515) confirma ("the factorial design was as efficient as the tester designs, and, for some traits, outperformed them").
- "menos cruzamentos por linha favorece as linhas nunca cruzadas": confirmado por Lorenzi ("reducing the number of hybrids per line for the factorial design") e Melchinger 2023 (PMID 37532821: c = 1 da a maior acuracia para hibridos H0 e GCA de linhas I0). Mas Seye 2020 diz o contrario do que a frase da a entender: "The contribution number of each parental line ... had a small impact on accuracies". E Melchinger mostra o custo simetrico: c = 1 da a MENOR acuracia para H1, H2 e GCA de linhas I1 ("optimum choice of c ... depends on the size and resources of the breeding program"). A frase omite esse trade-off, que e exatamente o que sustenta a ressalva do resultado 1 do capitulo ("The split of the budget is a statement about what will be selected"). Sugestao: tirar @seye2020 da segunda oracao e acrescentar a metade simetrica de Melchinger. Evidencia: ABSTRACT (os tres).

### 04g-B2 [UNVERIFIED] :355-357 Heslot & Feoktistov 2020
"choose which maize hybrids to create and phenotype by mixed binary-integer differential evolution, extended to designing a connected population before crossing". O resumo publicado (ideas.repec; JABES 25:579) fala em "hybrid species", "hybrid combinations" e em escolher novas populacoes sob orcamento; nao menciona milho nem evolucao diferencial (so o subtitulo do preprint bioRxiv 172064, "Mixed binary-integer optimization using Differential Evolution", e a lista de referencias). Texto completo inacessivel. O nucleo (escolha binaria de cruzamentos a fenotipar + desenho de populacao antes de cruzar) esta confirmado em resumo; "maize" e "differential evolution" no artigo publicado ficam UNVERIFIED. O mesmo vale para :1241 ("problem @heslot2020 solved for crosses alone") e :60.

### 04g-B3 [UNVERIFIED] :321-325, :446 Butler 2014, Cullis 2020, Lisle 2021
- "optimise the A-optimality of the predicted genetic effects under the mixed model that will analyse the trial, relationship matrix included, and beat designs built for unrelated entries in silico" [@butler2014; @cullis2020]: o resumo de Cullis 2020 (Crossref) confirma "model-based designs", relacao genetica incluida e analise de 34 ensaios; mas nem "A-optimality" nem "beat ... in silico" aparecem no que li. Butler 2014: sem resumo acessivel (Crossref/Europe PMC). Texto completo nao alcancado.
- :446 "mean PEV of pairwise differences between effects used as the A-value in model-based design [@butler2014]": nao verificado (sem resumo nem texto).
- :325 Lisle 2021: o resumo diz que propoe o criterio D-optimality como diagnostico que "better forecast[s] the uncertainty of genetic variance parameter estimates" no REML (substituindo a "variety connectivity"). "diagnose whether a design can estimate its variance parameters at all" e mais forte que isso; sugerir "forecast the precision with which...".

### 04g-B4 [UNVERIFIED] :330-336, :1066-1068 Montesinos-Lopez 2023 (Genes) -- qual metodo?
Resumo (PMID 37107685): "methods M3 and M4 were slightly better than methods M1 and M2 ... prediction accuracy of the four methods barely decreased" a 15-85 %. O capitulo usa isso na lista de evidencias de alocacao por blocos incompletos. Nos outros dois artigos do grupo (TPG 2023, PMID 36815225) M3 = alocacao ALEATORIA e M4 = BIBD; se a numeracao e a mesma em Genes, "two of four methods slightly better" inclui o aleatorio e nao mostra BIBD > aleatorio. Tentei confirmar no texto completo (PMC10137724) mas a requisicao falhou (timeout). Conferem em ABSTRACT: 2022ibd "between 1.4% and 26.5% ... in terms of mean square error" (PMID 35170851); 2023 TPG "best method was M4 ... no important differences between M3 and M4" ("best with random close behind" ok); 2024 Plants "IBD ... superior performance with less variability compared to random allocation" (PMID 39519975).

### 04g-B5 [UNVERIFIED] :358-360 Guo et al. 2019
"chose maize, wheat and rice hybrid training sets from the parents' genotypes, beating random and PEV- or CD-optimised sets with 2 to 13 % of the hybrids". Resumo (Crossref/Europe PMC): os desenhos foram construidos e superaram amostragem aleatoria e metodos PEV/CD no conjunto de 276 hibridos de milho; trigo (2556) e arroz (1439) "validated the approaches"; "training set 2%-13% of the size of the whole set". O capitulo estende "beating" a trigo e arroz; o resumo so diz "validated". ABSTRACT apenas; texto completo nao lido.

### 04g-B6 [UNVERIFIED] :622 Nei 1973
"Nei's D_ST = H_T - H_S [@nei1973]": o resumo (PMC427228) so diz que a diversidade genica de uma populacao subdividida e decomposta em dentro e entre subpopulacoes; PMC nao fornece o texto (campo vazio). A definicao D_ST = H_T - H_S e padrao e a identidade D_ST = H_T - H_S confere algebricamente com a decomposicao de Caballero & Toro abaixo, mas a equacao nao foi lida no original. Numero de equacao nao citado no capitulo: nada a corrigir.

### 04g-B7 [MISSING SOURCE] :454 "North Carolina design II (NC II)"
Nome do delineamento sem citacao. references.bib ja tem `comstock1948` (Comstock & Robinson 1948, Biometrics, DOI 10.2307/3001412, Crossref confirma autores/ano/titulo "The Components of Genetic Variance in Populations of Biparental Progenies and Their Use in Estimating the Average Degree of Dominance"). Os capitulos 00 e 04e ja marcam que a atribuicao do Design II a essa fonte "nao foi verificada"; nao li o artigo. Sugestao: citar @comstock1948 com a mesma ressalva, ou remover o nome. Comstock 1949 nao e citado aqui.

### 04g-B8 [MISSING SOURCE -- baixa prioridade] :128 "At r = 1, which is the stage-1 norm"
Afirmacao empirica/historica sem fonte. Fontes encontradas que a sustentam em parte: Thomsen et al. 2026 (DOI 10.1007/s00122-026-05341-3; FULL TEXT PMC13469503: "61 METs implemented in alpha lattice design without replications", 4.000 hibridos) e Endelman et al. 2014 (DOI 10.2135/cropsci2013.03.0154; resumo: com semente limitada, delineamento desbalanceado em varios locais).

## Atribuicoes confirmadas (sem achado)
FULL TEXT:
- Caballero & Toro 2002 (reference/papers, pdftotext, p. 291): Eq. 1 (f~ = sum f_ii N_i / N_T, pesos N_i/N_T -- confere com "weights ... by their share N_i/N_T"); Eq. 6 (F_ST = (f~ - f-)/(1 - f-) = D-bar/(1 - f-)); Eq. 7 e texto: GD_T = 1 - f-, GD_WI = 1 - s~, GD_BI = s~ - f~, GD_WS = 1 - f~, GD_BS = f~ - f-. Confere com eq-joint-gdbs e com "it is also the D-bar in F_ST".
- Meuwissen et al. 2020 (PMC7438563, Methods, Eq. 1B): F_drift = (sum_k dp_{t,k}^2 / [p_{0,k}(1 - p_{0,k})]) / N_SNP, dp = p_t - p_0. Confere com "the numerator of F_drift ... before each marker is standardised by p0(1 - p0)". (Identidade GD(p0) - GD(pbar) = 2(p0 - pbar)(1 - p0 - pbar) verificada por algebra.)
- Gonzalez-Dieguez 2026 (reference/new_sparsing_test): "3-5 testers, sparsely distributed among full-sibs"; Tabela 1 mantem 1.200 testcrosses no total para 1 a 1200 testers (= "equal number of testcrosses"); "GCA prediction accuracies were similar to those achieved with sparse testcrossing designs using three to five testers" para o fatorial incompleto aproximado (= "matched, not beaten").
- Thomsen 2026 (PMC13469503): "This design realized 1.67% of all possible combinations between mother and father lines"; dados de empresa comercial (NPZ), colza de inverno; "alpha lattice design without replications"; modelos GCA+SCA superiores.
ABSTRACT (consistente com a frase do capitulo):
- Endelman 2014: delineamento desbalanceado em varios locais > todas as entradas em um; "up to 250 yield plot equivalents per family" otimo nao genotipa mais progenies que fenotipadas; familias biparentais de cevada e milho.
- Atanda 2021: CV1 vs CV2 (CDmean por familia/ambiente), acuracia similar; agrupamento de ambientes melhora acuracia.
- Kadam 2021: PEVmean/CDmean sobre todos os cruzamentos possiveis aumentam acuracia esperada; "may be worthwhile".
- Lell 2021: 1.604 hibridos de trigo; subgrupos iguais com ambientes sobrepostos, alta acuracia e baixa variabilidade.
- Mothukuri 2025: correlacao 0,20 a 0,31 entre medidas de relacao e acuracia.
- Rincent 2017: OptiMET "more efficient than random MET composed of twice as many environments" (fenologia do trigo).
- Gonzalez-Barrios 2019: MED moderado "could potentially increase selection response up to 43 %".
- Schoemaker 2024: "three to five environments that had the highest quality data produced similar prediction accuracy as data from 10 random environments"; testers x ambientes x tamanho.
- Hoefler 2026: replicacao e esparsidade de MEDs por simulacao.
- Isidro 2015 (estratificada em arroz; CDmean/StratCDmean em trigo exceto peso de teste e data de florescimento), Bustos-Korts 2016 (uniforme > estratificada/aleatoria em milho e trigo, similar ao CD; arroz todos iguais), Berro 2019 (estratificada + matriz ponderada por efeito de marcador, melhor para previsao futura), Akdemir 2019 (targeted > untargeted), Rio 2022 (novas formas de CD para G x E, previsao de confiabilidade), Fernandez-Gonzalez 2023 ("a diverse training set makes GS robust against population structure, while including clustering information was less effective"), Windhausen 2012 ("predictive ability was low (i.e., 0.12 for grain yield)"; previsao "mostly from differences in mean performance"), Ou & Liao 2019 (criterio a partir da correlacao de Pearson, ridge, TSDFGS; ilustracao em arroz/trigo e "advantageous over existing methods" nao visiveis no trecho lido -- ABSTRACT parcial), Lubanga 2025 (OL; ponteiro de contexto em :342-343), Seye/Lorenzi/Melchinger (ver B1).

## Apenas metadados (nenhuma atribuicao verificavel alem do titulo/DOI)
akdemir2021, isidroysanchez2021 (:273-275, afirmacao "could in principle select G x E pairs" e do autor), debeukelaer2018 (:395 "allele-frequency and distance criteria"), rincent2012 (:327), papenberg2021 (:409, :589, :1256: sem resumo acessivel; "k-means anticlustering" e "groups of prescribed size" nao confirmados no texto), jarquin2020 e crespoherrera2021 e atanda2022 (:342-343, ponteiros a @sec-sparse-overlap; atanda2022 foi lido em texto completo na revisao de 04f), meuwissen2020 alem de Eq. 1B.

## Contagem
Citacoes verificadas por nivel: FULL TEXT = 4 fontes (Caballero & Toro 2002, Meuwissen 2020, Gonzalez-Dieguez 2026, Thomsen 2026); ABSTRACT = ~28 fontes (lista acima); apenas metadados = 9 (lista acima); UNVERIFIED por falta de texto = 5 itens (B2, B3, B4, B5, B6). Achados: 1 WRONG (B1), 4 UNVERIFIED (B2-B6, contando B3 como um), 2 MISSING SOURCE (B7, B8). Comstock 1949: nao citado.
