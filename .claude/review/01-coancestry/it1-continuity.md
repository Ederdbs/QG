# Continuity review, chapter 01-coancestry, iteration 1

Scope: `book/01-coancestry.qmd` against `index.qmd`, `00-hybrid-programme.qmd`, `90-notation.qmd`, and each target of its forward references (02, 03, 05, 05b). Checks 1-4, 6, 8 in chapter mode. `file:line` refers to this worktree. Numbers were re-run on `simulate_data(book_cfg)`: mean of `diag(f)` 0.8192, heterozygous fraction 0.3617, `min(f)` 0.6448, `range(4f - 2J)` 0.579 to 1.327, `sum(G)` -4e-11. They agree with 00 (0.3617 at 00:435-447) and with 01's own claim that every `f_ij` exceeds 0.5 (01:277-278).

## Counts

| Severity | Count | Owner: 01 | Owner: other |
|---|---|---|---|
| H | 1 | 1 | 0 |
| M | 5 | 4 | 1 (06) |
| L | 7 | 3 | 4 (04, 08b, 02, 04c/90) |
| Total | 13 | 8 | 5 |

Owed items naming 01 (THREAD.md): 00-C26 (open, 01-C1, H), 00-C25 (open, 01-C4), introduction-C2 (open, 01-C3), introduction-C3 (open, 01-C2). None is settled in the text as it stands.

## Findings

- **01-C1 (H) -- definition, scope of "every diversity metric". Owner: 01.** `01:320-321`: "every diversity metric takes `ctx[["f"]]`", and the table row `01:314` "Use: every diversity quantity" for `f`. `00:463-465` (fixed under 00-D5): the coancestry-based metrics are computed on $\mathbf f$; frequency-based metrics such as $F_{drift}$ are not. The code agrees with 00: `freq_metrics()` (`R/01_metrics.R:212-226`) computes `F_hom`, `F_drift` and `alleles_lost` from `colMeans(X[idx, ])` and `ctx$p0`, with no `f`. 01 also says (`01:328-329`) that "metrics that read `ctx[["f"]]` directly are not covered", which concedes that there are metrics that do not, but the sentence before it says all of them do. This is 00-C26, unchanged. Fix in 01: restrict to the coancestry/homozygosity-lens metrics and the table row to the same scope.

- **01-C2 (M) -- definition at the hand-off, what "absolute" and "no base" mean. Owner: 01 (06 and 00 carry the other side).** `01:142` "Diversity requires an *absolute* scale", `01:172` "No centering, no scaling, no arbitrary base population", `01:296-298` "the fixed-base member of the VanRaden family, the one with an absolute scale". Against it: `00:465-475` and `00:514-524` establish that $\mathbb E[f_{ij}]$ is a floor $m^{-1}\sum_k(p_{b,k}^2+q_{b,k}^2)$ set by the base frequencies plus scaled pedigree coancestry, that unrelated pairs are not at 0, and that $\mathbf f$ is therefore "read as a comparison between sets measured on the same markers". Three sub-points. (a) 01 never says in which sense the scale is absolute (no centring constant estimated from the data being measured, `01:141-145`, `01:259-260`), so a reader of 00 then 01 meets "comparison on the same markers" and then "absolute". (b) 01's own $\mathbf G_{0.5} = 4\mathbf f - 2\mathbf J$ (`01:272`) is a centring at a fixed base ($p_k = 0.5$ everywhere) and is called equivalent under $\mathbf 1'\mathbf c = 1$; 00's floor with $p_{b,k} = 0.5$ is exactly the 1/2 that `4f - 2J` removes. 01 never connects the two, and "fixed-base" in `01:296` is a base, which `01:172` denies. (c) `00:522-524` cites `@sec-why-not-g` for "why it is never centred to make that floor vanish", but 01 proves only that centring on the sample frequencies fails; centring on a fixed base is what `01:262-298` presents as acceptable. Related, owned by 06: `06:157-158` "Molecular $\mathbf f$ has no base" (see 01-C7). Fix: 01 states the sense of "absolute" and links the floor of 00 to the `2J` of @eq-g05; 00:522-524 is then supported or reworded in 00's own review. This is introduction-C3.

- **01-C3 (M) -- transition, the opening does not say why 01 follows 00. Owner: 01.** `01:8-15` opens as the book's first chapter: it does not say that 00 has already defined IBD/IBS, coancestry, $s_i$, $F_i$ and $GD_S = 1-\theta_S$ (`00:449-559`, `00:385-406`), that A2 (inbred lines) is already declared (`00:24`, used at `01:19-22` without the name), or that this chapter supplies the computation, the contrast with $\mathbf G$ and the equations (@eq-x-freq, @eq-hybrid-dosage, @eq-f-molecular) that 00 points to (`00:15-16`, `00:30`, `00:94`, `00:463`). Its only link to 00 is one citation to `@sec-hp-cycle` at `01:25`. `01:14-15` says the chapter "derives the matrix used for the rest of the book", which leaves out that 00 has already defined it conceptually. This is introduction-C2.

- **01-C4 (M) -- redundancy, definitions restated instead of cross-referenced. Owner: 01.** The same four definitions appear in 00 (earlier) and 01: group coancestry as the mean of all $n^2$ coancestries, diagonal included (`01:92-94` against `00:531-533`, both citing Cockerham 1967); Malecot coancestry (`01:149-150` against `00:457-460`; 01's sentence reads "identical" without "by descent" or a base, 00's "IBD ... relative to a base"); $s_i = f_{ii} = (1+F_i)/2$ with $s_i = 0.5$ for a fully heterozygous F1 (`01:166-171` against `00:527-531`); $F_i$ as the fraction of markers at which $i$ is homozygous (`01:168-170` against `00:537-543`). `01:170-171` also points forward to `@sec-genomic-era` for the population-level `F_hom`, while `@sec-hp-inbreeding` (`00:566-574`) defines it earlier and says how it differs from $F_i$. The wording does not conflict, so this is redundancy and a missed backward reference, not a contradiction. Owner: 01 cross-references 00 (`@sec-hp-ibd`, `@sec-hp-inbreeding`, @eq-hp-gd) and keeps only what it derives. This is 00-C25.

- **01-C5 (M) -- number/definition, the referent of "This fraction". Owner: 01.** `01:221-225` ends on "the fraction of markers at which the two parent lines carry the same allele" (the homozygous fraction, $F_i$); the chunk at `01:227-232` then prints `heterozygous_fraction`; `01:236-238` begins "This fraction is not set by how far apart the heterotic pools are. Its expectation over the A x B factorial is one minus the mean coancestry between a pool-A and a pool-B line". The fraction of markers where two homozygous lines agree is $f^L_{ab}$ itself (`00:542`, $F_{(ab)} = f^L_{ab}$), so its expectation is the mean coancestry, not one minus it. The sentence is true of the heterozygous fraction (`03:198-201`: "exactly `1 - theta_AB`") and false of the nearest preceding referent. Fix in 01.

- **01-C6 (L) -- names, two terms used before their chapter and a repeated result. Owner: 01.** `01:239-241` "what the between-pool term of diversity gains, the shared term loses (@sec-heterosis-flat)". "Shared term" is 05b's label for the heterosis component $2\bar p(1-\bar p)$, which 05b equates with $GD_T$ (`05b:208-232`, @eq-het-split); in 03 the same fact is "$GD_{BS}$ gains, $GD_T$ loses" (`03:195-199`). 01 uses neither $GD_T$ nor $GD_{BS}$ (defined in 00 at `00:385-406` and in 02, which comes after), so "between-pool term of diversity" and "shared term" are two names for a pair that 00 already writes $GD_{BS}$ and $GD_T$, with $H_o = GD_T + GD_{BS} = 0.3617$ on this same data (`00:435-447`). The heterozygous fraction is also computed in 00 (`00:415-417`) and again in 01 (`01:229-232`) on the same `book_cfg` hybrids, with no cross-reference. Fix in 01: use $GD_T$ and $GD_{BS}$ and cite `@sec-heterosis-identity` or `@sec-hp-popgen`.

- **01-C7 (M) -- definition, the same scope and base claims in 06. Owner: 06.** `06:13-14` "every one [metric] operates on the molecular coancestry matrix from @sec-coancestry" (the same overstatement as 01-C1, against `00:463-465` and `R/01_metrics.R:212-226`); `06:157-158` "Molecular $\mathbf f$ has no base" against `00:465-475` (a base-frequency floor). Not yet owed in THREAD.md.

- **01-C8 (L) -- number/definition, cited for something it does not state. Owner: 04.** `04:808-809` "gene diversity $GD = 1 - \theta$ (@sec-coancestry)". 01 defines $\theta$ (`01:93-94`) but never writes $GD$ or $1-\theta$; the definitions are `@eq-hp-gd` (`00:392-394`) and `@sec-identity` (`06:80-95`). Related: `index:101-102` cites 01 for "$\theta$ their group coancestry", which 01 does supply.

- **01-C9 (L) -- notation. Owner: 01.** `01:93`, `01:96-98`, `01:104-105` and the chunk names `theta_on_G`, `Ns_on_G` use bare $\theta$ for the group coancestry of a set, where `90:70` has $\theta_S$ and 00 writes $\theta_S$ throughout (`00:388`, `00:531`). `02:536` also uses bare $\theta$ to cite 01. Minor, but the first definition after 00 should carry the subscript.

- **01-C10 (L) -- transition to a concept defined later. Owner: 01.** `01:98` introduces $N_s = 1/(2\theta)$ and says it diverges on $\mathbf G$, with no pointer to `@sec-ns` (`06:145-165`), which shows that on molecular $\mathbf f$ it lies in $[1/2, 1]$ and is not a head count (same at `00:701-707`). A reader leaves 01 with $N_s$ as a diagnostic that "diverges" on the wrong matrix and no statement of its value on the right one. 01 should cite `@sec-ns`.

- **01-C11 (L) -- quotation. Owner: 08b.** `08b:19` "`vanraden_G()` has said since @sec-coancestry that its matrix 'is the right matrix for GBLUP.'" 01 says (`01:71-73`) "the right matrix for genomic best linear unbiased prediction (GBLUP)"; the quoted wording is not in 01 and not in the roxygen of `vanraden_G` (`grep` over `R/` and `man/` finds none). Reword as a paraphrase or quote 01 exactly. The substance is consistent: 01 and 08b agree that $\mathbf G$ is for prediction.

- **01-C12 (L) -- hand-over. Owner: 02.** `01:331-333` hands over ("takes $\mathbf f$ and asks what happens when the population it describes is not one population, but several"). `02:5-14` opens with the programme and the partition and does not cite 01 or say it follows from it; the first citation of 01 is at `02:64`. The promise is kept in substance (02 takes $\mathbf f$ and partitions it).

- **01-C13 (L) -- notation, $x_{ik}$ with two meanings. Owner: 04c (and its 90 row).** `01:46` / `90:17,25` define $x_{ik} \in \{0, 0.5, 1\}$; `04c:318-322` and `90:547-550` use $x_{ik} \in \{0, 1, 2\}$ for the same individuals and markers, an entry of $\mathbf M^H$ in 01's notation. `90:550` flags it ("**not** the 0/0.5/1 entry of $\mathbf X$"), so it is declared, but it is a symbol reused for a different scale for the same object. `05:340-341` uses $x_{ik} \in \{0,1\}$ for lines (consistent with 90's $\mathbf G^L$ coding).

## Checked and consistent (not findings)

- 00's pointers into 01 resolve and say what 01 holds: @eq-x-freq (`00:30`), @eq-hybrid-dosage (`00:94`), @eq-f-molecular (`00:463`), `@sec-why-not-g` (`00:524`, but see 01-C2c), `@sec-f-molecular` for $s_i = 0.5$ of a fully heterozygous individual (`00:531` against `01:171`), reading map `00:741`.
- Assumption reuse: 01 uses only A2 (homozygous lines, `01:19-22`, `01:39-41`) and the complete A x B factorial (`01:237`), with neutral divergence stated where used (`01:238-239`). 00's neutrality caveat (`00:37-42`) does not reach 01: no trait selection appears. $\mathbf M^L \in \{0,2\}$ (`01:20`) agrees with `90:27`; $\mathbf X = \mathbf M^H/2$ (`01:50`) with `90:26`.
- Heterosis statement `01:34-37` (F1 minus mid-parent equals $\sum d_k$ over the loci where the parents differ, no epistasis) agrees with 05b (@eq-het-value, `05b:138-153`).
- $s_i = (1+F_i)/2$, $F_i = 2s_i - 1$, $F_i$ as the homozygous fraction: 01, 00 and `90:81` agree. The chunk `01:227-233` and 00's `Ho_hybrid` give the same 0.3617 on the same `book_cfg` data.
- `@eq-g05`: `G_0.5 = 4f - 2J`, with the order-equivalence only for $\mathbf 1'\mathbf c = 1$, agrees with `90:57` and `05:119`.
- Tests named at `01:322-329` exist as described (`tests/testthat/test-metrics.R:13-40`: `f` in [0,1], $|\sum G| < 10^{-6}N^2$, `theta_group()` on the whole population equals `mean(f)`).
- Subset-sum result `01:123-125` re-derived: $\mathrm E[\mathbf 1_S'\mathbf G\mathbf 1_S] = n\frac{N-n}{N-1}\overline G_{ii}$ is correct.
- Forward targets exist and say what 01 expects: `@sec-heterosis` (05b), `@sec-heterosis-flat` (`05b:467`, divergence gains and shared term loses), `@sec-simulating-crosses` (`03:106-181` heterozygous fraction flat in `fst`), `@sec-subdivided` (02), `@sec-genomic-era` (05, $F_{hom}$). All are declared as forward and none is needed to read 01.
- Cross-reference graph: no broken `@sec-` target in the book, no `{#sec-}` defined twice.

## Inbound `@sec-` count

Each `@sec-` resolved to the file that owns its `{#sec-...}` and counted only when the citing file differs from the owner. Recomputed in this worktree (unchanged from the part table).

| Chapter | Inbound | Citing files |
|---|---|---|
| 00-hybrid-programme | 9 | 7 |
| **01-coancestry** | **25** | **14** |
| 02-subdivided | 40 | 14 |
| 02b-response | 28 | 14 |
| 03-simulating-crosses | 28 | 16 |
| 04-population-sizing | 17 | 10 |
| 04b-backcross-introgression | 8 | 7 |
| 04c-alphasimr-pipeline | 21 | 11 |
| 04d-breeding-programme | 19 | 6 |
| 04e-mating-design | 58 | 8 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 11 | 4 |
| 05-genomic-era | 39 | 16 |
| 05b-heterosis-dominance | 79 | 21 |
| 06-metric-catalogue | 42 | 18 |
| 07-choosing-metrics | 47 | 20 |
| 08-pipeline-stages | 39 | 18 |
| 08b-genomic-prediction | 26 | 14 |
| 09-optimal-contributions | 37 | 16 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 25 | 8 |
| 11-plant-literature | 15 | 8 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 19 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 18 | 7 |
| 91-package | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

01's 25 split by target: `@sec-coancestry` 19, `@sec-why-not-g` 4, `@sec-f-molecular` 2. Citing files: 00 (3), 02 (2), 03 (3), 04 (1), 04b (1), 04c (1), 04g (1), 05 (2), 05b (2), 06 (1), 08b (3), 10 (1), 92 (2), index (2). The chapter has a job (kernel and G failure cited by 14 files). Low, with no owner change here: 91 (0), 93 (2), 92 (5).
