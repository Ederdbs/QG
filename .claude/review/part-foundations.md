# Part review: Foundations (01-coancestry, 02-subdivided, 02b-response, 05b-heterosis-dominance)

Scope: what the part adds on top of the four approved chapters, read in `_quarto.yml` order after 00 and before 03. Chapter findings (01-*, 02-*, 02b-*, 05b-*) are not repeated; items already in a THREAD `Owed` row are cited as "owed" and not re-opened unless the part-level evidence changes. Text judged: the worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-01-05` (branch review-01-05) as it stands, with `book/00-hybrid-programme.qmd`, `book/03-simulating-crosses.qmd` and `book/index.qmd` as modified there. `file:line` refers to that tree. Nothing was rendered; every number quoted below is either an inline `r` expression (checked by grep to be absent as a hard-coded figure in the four chapters) or a line count.

Result in one line: no H. 4 M, 11 L. The part argues in order and its forward pointers are declared; the defects are pointers that resolve to the wrong place, names for one quantity that the reader must reconcile alone, and an appendix (90) that has absorbed none of the part's decisions.

## 1. The part as an argument

Order: 00 (programme, definitions in words) -> 01 (what `f` is, why not `G`) -> 02 (partition of `f` over pools; keystone) -> 02b (what selection buys; the within-pool part of GD is what carries variance) -> 05b (what divergence buys; derives the claim 00, 01, 02 state with conditions) -> 03 (the generator all of it ran on). Each opening says why it follows: 01:8-22 (names what 00 defined and what 01 supplies), 02:5-24, 02b:24-31 (what 02 left to it), 05b:26-41 (lists the hand-overs from 00, 01, 02, 02b), 03:22-27 (lists what Foundations defined and which generator each chapter used).

Forward dependences of the four chapters on later parts, by chapter. All are declared in the text; "needed" means the sentence cannot be checked without the later chapter.

| From | To (later) | Nature | Declared | Needed to read |
|---|---|---|---|---|
| 01:374, 380 | 03 `@eq-balding-nichols`, `@sec-simulating-crosses` | symbol $p^*_k$ and the model it belongs to; promise of the flat grid | cited, but not marked "later" (see foundations-C14) | no: 01 defines $p^*_k$ in words |
| 01:114, 491 | 06 `@sec-ns`, 05 `@sec-genomic-era` | $N_s$ pointer; the $F_{hom}$/$F_{drift}$ gap | yes ("measured where those metrics are reported") | no |
| 02:12-13, 822-826, 1036 | 06 `@eq-catalogue-alpha`, 09 `@sec-ocs` | $\alpha$ and its use | yes | no ($\alpha$ is defined in words at 00:313-316) |
| 02:1037, 1089, 1092, 1098 | 05b | the $GD_{BS}$ identity and its limits | yes, in the keystone table caption and prose | no: conditions restated |
| 02b:63-72, 420, 532, 584, 915 | 03, 05b | generator; GCA/SCA split | yes (02b:531-532 says "derived in @sec-heterosis-gca-sca") | no |
| 05b:44-71, 413, 522-523, 1578-1587, 1915, 2092 | 08, 05, 04, 09, 10, 10b | S1 panel, $F_{hom}$ gap, P9, A3 declaration | yes ("in the Metrics and prediction part", "later") | 05b:522-523 rests on 04's P9; declared, and owed to 04 as "keep true" |
| 05b:620, 670, 1193 | 03 `@eq-balding-nichols` | the model behind every expectation of the chapter | 05b:68 says the generator is in "the Simulation part that follows"; 05b:620 does not | no: 05b:617-628 gives the moment property it uses |

Verdict: the part does not lean on a later part for anything it asserts as a result. The one place where a forward target is not marked as forward is foundations-C14. The reordering decision of CLAUDE.md (no part leans on a later one) holds for Foundations.

## 2. Findings

### M

- **foundations-C1 (M) -- a definition pointer resolves to the wrong place; three chapters name three homes for $\theta_A$, $\theta_B$, $\theta_{AB}$.** `02:605-607` writes "$\theta_A$, $\theta_B$, $\theta_{AB}$ in @sec-hp-popgen and in the code". `00` defines none of $\theta_A$, $\theta_B$ (grep over 00: no match) and names $\theta_{AB}$ and $\theta_w$ once, at `00:578-579`, inside the description of what @sec-stages logs, and in @sec-hp-inbreeding, not @sec-hp-popgen. `05b:351-353` says $\theta_{AB}$ is written so "in @sec-catalogue (later)". `90:10-11` says all the population-genetic quantities are introduced together in @sec-hp-popgen and defines the three at `90:205`/`90:226`. The THREAD entry for 02 ("Takes from `00`: ... $\theta_A, \theta_B, \theta_{AB}$") records the same wrong provenance. A reader of 02 who follows the pointer finds nothing; 02 itself defines $\theta_w$ and $\theta_{AB}$ locally at `02:409-410`, $\theta_A$, $\theta_B$ nowhere in the part. Owner: **02** (cite where they are defined, or define them at `02:605`); secondary 90:10-11 (the "introduced together" sentence is false for these three) and the THREAD 02 entry.

- **foundations-C2 (M) -- the pointer for the observed-heterozygosity identity lands on a section that does not contain it, and the quantity has five names.** `00:444-446`: "That excess is the identity $H_o = GD_T + GD_{BS}$ derived in @sec-heterosis-identity". `05b` never names $H_o$ or "observed heterozygosity" (grep). @sec-heterosis-identity (`05b:267-348`) derives the per-locus expected F1 heterozygosity $p_A + p_B - 2p_Ap_B = GD_T + GD_{BS}$ (@eq-het-split) under flat dominance. The form that matches 00's $H_o$ (the realised heterozygous fraction of the F1s) is @eq-het-wi-hyb, $2\,GD_{WI\text{-}hyb} = GD_T + GD_{BS}$, in `05b:382-418`, under a separate level-2 heading ("A second identity, at the hybrid level") with no id, so 00's pointer cannot reach it. The same quantity is called $H_o$ (`00:410-447`, `90:84`), the heterozygous fraction (`01:360-380`, `01:352`; `03:146-185`), expected F1 heterozygosity per locus (`02:1088`), mean heterozygosity of the F1s (`02:1035`, `02:1068`), and $2\,GD_{WI\text{-}hyb}$ (`05b:382-390`). No chapter says in one sentence that these are one number on the complete factorial. Owner: **00** (retarget `00:445` to @eq-het-wi-hyb, or to both equations); secondary **05b** (name $H_o$ where @eq-het-wi-hyb is derived, give the second identity an id).

- **foundations-C3 (M) -- within-pool diversity is $GD_{BI}$ in 02 and $GD_{WS}$ in 02b and 05b; the equality is never stated at the hand-over.** `02:1036` and `02:1052`: with inbred parents $GD_T = 1 - \theta_S = GD_{BI} + GD_{BS}$; `02:1101-1110`: "$GD_{BI}$ is the raw material of next cycle's response, which @sec-response makes precise". `02b:24-31` repeats that 02 "names the component $GD_{BI}$", then `02b:474-489` and `02b:512-514` work only with $GD_{WS} = m^{-1}\sum_k(p_{Ak}q_{Ak} + p_{Bk}q_{Bk})$ and $GD_T = GD_{WS} + GD_{BS}$; `02b` writes $GD_{BI}$ once (the opening). The step $GD_{WS} = GD_{WI} + GD_{BI} = GD_{BI}$ when $GD_{WI} = 0$ is in 02's table (`02:442-450`) but not applied in 02b. The same split occurs inside one chapter: `05b:476-477` ($GD_T = GD_{BI} + GD_{BS}$) and `05b:777-778`, `05b:1412` ($GD_T = GD_{WS} + GD_{BS}$ "with inbred parents"). The only place that states "$GD_{WS}$ equals $GD_{BI}$ with inbred lines" is the appendix, `90:118`. The argument 02 -> 02b is exactly "the $GD_{BI}$ of 02 is the $GD_{WS}$ of 02b", so the link belongs at that hand-over. Owner: **02b** (one sentence at `02b:474` or `02b:24-31`); secondary 05b:476 vs 05b:777.

- **foundations-C4 (M) -- the notation appendix (90) has absorbed none of the part's decisions, and three of its statements are now false against the part.** `git diff HEAD -- book/90-notation.qmd` is empty. Verified still present, each already in a THREAD `Owed` row unless marked new: `90:210`, `90:515`, `90:605` "dominance deviation(s)" for $d_k$ (05b:145-166 chose "dominance effect" for 00, 01, 02, 02b, 05b); `90:154-155` lists @sec-heterosis among the chapters that write $F_{BN}$ as $F_{ST}$ (false for 05b since 05b:617-628: $F_{BN}$ for the parameter, $F_{ST}$ only for the statistic); `90:207`, `90:232` $F^\star_k$ "divergence $F_{ST}$" (it is $F_{BN}$, @eq-het-gca-peak); `90:179` "against a base with all alleles distinct" (withdrawn at 01:235-256, 02:94-103); `90:118` "the term recurrent selection erodes" (02 now says drift, with selection not separated); `90:569`, `90:627` bare $\theta$ for $\theta_S$; `90:20`, `90:30` ("candidate hybrids in the pool", "frozen candidate-pool allele frequency") against "candidate set"; `90:282` $GD_S$ not a defined symbol. New at part level: `90:119` still reads "the heterosis engine -- maintain, do not maximise" unconditionally, against the conditions of 02:1037 and 05b:297-306; `90:627-630` states $N_s \in [1/2, 1]$ "on molecular $\mathbf f$" without "biallelic" (02:827-846 gives $N_s = 1.54$ for the multiallelic worked example; 01:111-114 states the biallelic condition); `90:587-591` (Terms) writes the ancestral frequency as $p$, `90:513` as $p^{*}_k$ (see C8); `90:10-11` (see C1). Missing rows owed from the part: $F_{IS}$, $F_{IT}$, $\bar D$, the second statistic written $F_{ST}$, $\tilde p_{k,i}$, $c_i$, $\theta_w$, $p_{b,k}$, $q_{b,k}$, $\overline G_{ii}$, $\mathbf 1_S$, $\bar f^L_{AB}$, $T$, $\bar g^B_T$, $\bar s_{i\cdot T}$, $i_{real}$, $e$, $a_i$, $b_j$. 90 is reviewed later; the severity is M because every item is owed and tracked, but the part cannot be called closed on the notation front until 90 is changed. Owner: **90** (appendix; a named later chapter).

### L

- **foundations-C5 (L) -- one quantity, two symbols in 02.** `02:364-365`: $1 - \bar f = H_T$, $1 - \tilde f = H_S$ (@eq-f-stats-het); `02:433-442`: the same two quantities are $GD_T$ and $GD_{WS}$ (@eq-gd-partition), and `02:1052` asserts $GD_T = 1 - \theta_S$. 02 never says $H_T = GD_T$, $H_S = GD_{WS}$. The only statement is `90:234` (Nei notation, "with two pools $H_T = GD_T$, $D_G = GD_{BS}$", citing @sec-catalogue). Owner: **02** (one sentence at `02:364`).

- **foundations-C6 (L) -- the GCA/SCA split of $H$ is computed in full twice, and 02b does not use the qualifier 05b introduces.** `02b:582-626` (chunks `response-gca-sca`, `tbl-response-gca-sca`) runs `heterosis_gca_sca()` on a second dominance draw ($d_k \sim N(0.3, 0.1^2)$, seed 7), asserts reconstruction, variance sum and orthogonality and reports shares 0.238/0.228/0.535 (inline), after stating that 05b "owns the decomposition and its tests". `05b:940-1130` does the same with the gamma(2, 4) draw (seed 4, `tbl-het-gca-sca-check`, `tbl-het-var-components`); `00:136-171` is a third draw of the dominance part alone. The two decompositions of the same pools therefore give two different SCA shares and nothing says why a reader should keep 02b's. Separately, `05b:961-973` declares "GCA for heterosis" for the term of @eq-het-gca-sca and "GCA" unqualified for the cross mean of @eq-hp-gca-sca; `02b:555-626` uses unqualified "GCA" for both objects, the first half for the cross mean `gv` and the second for $H$. Owner: **02b** (cut the second run to what 02b alone needs, the existence of an SCA component, with a pointer to @tbl-het-gca-sca-check; or use the qualifier); 05b is the owner of the decomposition.

- **foundations-C7 (L) -- the finite-pool offset of $GD_{BS}$ and $GD_T$ is derived in full in 05b and again in 03.** `05b:722-760` explains the sample-frequency offset ($\mathrm{Var}(\hat p) = pq/n$, equal and opposite in the two halves, proportional to $1 - F_{BN}$) and compares it with the sweep; `03:315-331` gives $E[GD_{BS}] = F_{BN}p^*q^* + (1 - F_{BN})p^*q^*/n$ and the factor $(1 - 1/n)$ on a different grid, and says itself that @sec-heterosis-flat "derives the same expectation and the same sample-frequency offset". The two agree (offset $= p^*q^*(1 - F_{BN})/n$ at $n_A = n_B = n$). Ownership: 05b owns the derivation; 03 keeps its numbers and the one formula it needs and cross-references. Owner: **03** (later chapter, content approved, form pending).

- **foundations-C8 (L) -- three base or ancestral frequency symbols, and the relation between two of them is never stated.** $p_{b,k}$ (base population of @eq-hp-ibs-ibd, `00:466-474`, `01:247-250`, `02:99`), $p_{0,k}$ (frozen candidate-pool frequency, `01:375`, `01:422`) and $p^{*}_k$ (ancestral frequency of the Balding-Nichols draw, `01:374-378`, `05b:620`, `03:80`). `01:374-375` separates $p^{*}_k$ from $p_{0,k}$; nobody says that for the book's simulated pools the base of the coancestry floor is the ancestral population, i.e. $p_{b,k} = p^{*}_k$, so that the floor of 01 equals $m^{-1}\sum_k(p^{*2}_k + q^{*2}_k)$ in expectation. `90:587-591` (Terms) writes the same ancestral frequency as $p$; `90:513` has the row for $p^{*}_k$. Owner: **01** (first chapter holding all three, `01:372-378`); secondary 90 (Terms).

- **foundations-C9 (L) -- the additive effect has three symbols and one letter two meanings, with the factor 1/2 unstated.** $a_k$ = additive effect at locus $k$ (`00:122`, `05b:132-143`, `05b:975`, `90` heterosis table); $\beta_k$ = marker effect (`02b` throughout, `05b:135` "this book's additive marker effects are $\beta_k$"); in 02b the substitution effect is $\beta_k/2$ and the line value $a_i = \sum_k\beta_k u_{ik}/2$ (`02b:535-540`, `02b:554`), the same letter $a$ as the locus effect $a_k$ of 00 and 05b and as the economic-weight vector $\mathbf a$ of `02b:628-729`. That 02b's $\beta_k/2$ is 00's and 05b's $a_k$ (coding 0/0.5/1) is not said in either chapter; 05b says only that "no quantity this chapter reports depends on it". `90` owes $a_i$, $b_j$ rows already (02b-E4). Owner: **02b** (state $a_k = \beta_k/2$ where `02b:535` first writes the substitution effect); 05b's callout already declares the other half.

- **foundations-C10 (L) -- one concept, three names: "identity in state", "identical in state", "identity by state".** `00:449` (heading, "Identity by descent, identity by state") and `90:618` (glossary) against `00:452` ("identical in state"), `01:239`, `02:95`, `03:504` ("identity in state"). Owner: **01** (the chapter that defines $\mathbf f$ as the IBS quantity, `01:239`), with 02 and 03 following; or change the heading of 00:449 and 90:618 to match.

- **foundations-C11 (L) -- 01 never says what data its numbers are computed on.** `01:65` calls `simulate_data(book_cfg)` and every table says "the book data" (`01:251`, `287`, `437`, `455`) with no mention of 25 + 25 lines, 2000 markers, 625 hybrids or A8. `00:35`, `02:126`, `02b:293`, `05b` and `03` call it the teaching scale; a reader of 01 meets $N_s = 0.7442$, $\min\mathbf f = 0.6448$ and the panel floor 0.6719 with no scale. Related to introduction-C10 (open, three names for the scale in the book); Foundations uses "teaching scale" in 00, 02, 02b, 03, 05b and no name in 01. Owner: **01**.

- **foundations-C12 (L) -- the preface keeps a word 01 removed.** `index:31-32`: every diversity quantity computed from $\mathbf G$ "is meaningless. @sec-coancestry shows this happening". 01 removed "meaningless" (owed to index since the 01 review) and shows that $\theta_S$ on $\mathbf G$ is zero by construction, $N_s$ diverges, and the printed `Ns_on_G` is the reciprocal of round-off with no information (`01:92-136`). Owner: **index** (earlier part). Adds to the introduction-C5..C8 group; not a duplicate of any of them.

- **foundations-C13 (L) -- the "what to run" half of 05b has no inbound citation.** 05b `@sec-heterosis-protocol` and its steps `@sec-heterosis-step1`..`step5`, `step7`, `step8`, `@sec-heterosis-premises`, `@sec-heterosis-dk-meaning`, `@sec-heterosis-distance`, `@sec-heterosis-gca-average` and `@sec-heterosis-lambda` are cited by no other file; only `step6` (3) has outside citations. The protocol is `05b:1445-2085`, 640 of 2191 lines (29 %); 05b:62-65 tells the reader to start there "if the question is what to run". The chapters that would run it, 08 (S1 panel) and 12 (`12:174-175`, `12:262-266`, the extension "the book names and does not attempt"), cite `@sec-heterosis` and `@sec-heterosis-gca-sca`, not the protocol. Owner: **12-case-study** (a named later chapter), secondary 08.

- **foundations-C14 (L) -- two Foundations chapters cite a later equation for a symbol without marking it as later.** `01:374` (first appearance of $p^{*}_k$ in the book) cites `@eq-balding-nichols`, defined at `03:83-84`, three chapters on; `05b:620` and `05b:670` do the same (05b:68 says the generator is "in the Simulation part that follows", the equation is not). Both chapters give the property they use in words (01:374-378, 05b:617-628), so nothing is needed from 03 to read them. Owner: **01**; **05b**.

- **foundations-C15 (L) -- "candidate population" for the hybrid set.** `05b:479` ("the merged candidate population"); the review settled "candidate set" for the hybrid set because "pool" means a heterotic group (00 entry, 05b settled item). No "candidate pool" remains in 00, 01, 02, 02b, 05b or in 03's prose (03 keeps the label `fig-candidate-pool`, `03:607`, `03:595`, `03:643`, not visible text). Owner: **05b**.

## 3. Ownership map for the repeated material

| Material | Owns (full development) | Restates, correctly cross-referenced | Verdict |
|---|---|---|---|
| $GD_{BS}$ as the divergence term of expected heterosis; the identity under flat $d$, inbred parents, complete factorial | **05b** (`05b:267-348`, @eq-het-split) | 00:435-447 (numerical $H_o$, pointer wrong: C2); 01:366-380 (heterozygous fraction $= 1 - \bar f^L_{AB}$, own computation); 02:1085-1100 (keystone row and paragraph, conditions restated); 03:286-331 (grid); 06:468-480 (owed: re-derives) | the conditions are the same in all five places (flat $d$, inbred parents, complete factorial, equal pool weights, neutral redraws); no contradiction. 02's paragraph is long for a restatement but carries the conditions; no finding |
| Neutral divergence moves nothing in expectation; $GD_T$ pays one for one; $GD_{WS}$ falls by twice | **05b** (@eq-het-bn-total, @eq-het-bn-halves) for the Balding-Nichols redraw; **02** (`02:596-616`) for the drift accounting ($\Delta$, $\Delta/2$) | 02b:512-514 (callout), 03:293-300, 02:1095-1096 | consistent: 1 and 2 in both derivations |
| Genic variance among hybrids; $GD_T$ as a proxy only through $GD_{WS}$ | **02b** (@eq-response-hybrid-var, `02b:462-489`) | 02:1101-1110 (three sentences, points to 02b); 05b:777-784 (cites @sec-response-genic for $2\bar p\bar q = p_Aq_A + p_Bq_B + y^2/2$) | settled; naming gap in C3 |
| GCA/SCA | **00** (the model @eq-hp-gca-sca and one tester demonstration, `00:136-171`); **02b** (additive case, `02b:518-580`); **05b** (dominance decomposition, tester mean, variance components, `05b:940-1130`, `1185-1366`); estimation in 04e | 02b:582-626 second run of the decomposition (C6) | three illustrations, three draws of $d$ (00 and 05b: seed 4 gamma; 02b: seed 7 normal); only 02b's is redundant |
| Balding-Nichols model | **03** (@eq-balding-nichols) | 00:582 (setting), 01:372-378 ($p^*_k$), 05b:617-628 (variance property), 90 Terms | one model, four statements of the same moments, consistent; symbols in C8, C14 |
| $F_{BN}$ against $F_{ST}$ | **00** (`00:575-585`) and **90** Terms | 02:404-427 (two statistics written $F_{ST}$), 05b:617-628, 01:372 | consistent in all four chapters: $F_{BN}$ for the parameter, $F_{ST} = GD_{BS}/GD_T$ for the statistic; stale only in 90:154 (C4) |
| Finite-pool offset | **05b** | 03:315-331 | C7 |

## 4. Inbound `@sec-` graph

Every `{#sec-...}`, `{#eq-...}`, `{#tbl-...}`, `{#fig-...}` and chunk `label:` resolved to its file (no label defined twice; no broken `@sec-`, `@eq-`, `@tbl-` or `@fig-` target; the ten `tbl-alphasimr-split-N`/`paired-N` hits in 04c are Quarto-generated sub-labels of `#| label:` chunks with several tables, not broken). Counts are `@sec-` occurrences from a different file; self-citations discarded. "Chapters" excludes `index` and appendices 90-93.

| Chapter | Total inbound | Citing files | From chapters (cites / files) | From 00 | From Foundations (cites / files) | From later parts (cites / files) | From 90-93 | From index | Sections of the file cited from outside |
|---|---|---|---|---|---|---|---|---|---|
| 00-hybrid-programme | 42 | 10 | 37 / 7 | -- | 34 / 4 | 3 / 3 (03, 05, 08) | 4 | 1 | 6 of 7 (`sec-hp-reading-map`: 0; `sec-hp-not-animal`: 1, from 02) |
| 01-coancestry | 39 | 15 | 35 / 13 | 4 | 15 / 3 (02, 02b, 05b) | 16 / 9 | 2 | 2 | 3 of 3 (`sec-coancestry` 31, `sec-why-not-g` 4, `sec-f-molecular` 4) |
| 02-subdivided | 51 | 14 | 42 / 10 | 6 | 16 / 3 | 20 / 6 (03, 04c, 04g, 06, 09, 11) | 7 | 2 | 2 of 7 (`sec-subdivided` 50, `sec-keystone` 1; the `sec-ct-*` subsections are cited inside the chapter only) |
| 02b-response | 32 | 14 | 25 / 10 | 1 | 7 / 2 | 17 / 7 (03, 04c, 04d, 04f, 05, 09, 11c) | 5 | 2 | 2 of 2 (`sec-response` 29, `sec-response-genic` 3) |
| 05b-heterosis-dominance | 86 | 21 | 68 / 17 | 7 | 10 / 3 | 51 / 13 | 16 | 2 | 8 of 21 (see C13) |
| (03-simulating-crosses, reference) | 30 | 16 | 24 / 12 | 4 | 6 / 3 | 14 / 8 | 5 | 1 | 1 of 1 |

Findings from the graph: no Foundations chapter is at 0 or 1; each has a job (01 is the single most cited definition of `f`, 02 the partition, 05b the heterosis source: 51 citations from 13 later chapters). Introduction-C2 is settled by the data: the second half of 00 now has readers (34 citations from the four Foundations chapters; `sec-hp-popgen` 9, `sec-hp-ibd` 8, `sec-hp-inbreeding` 7; `eq-hp-gca-sca` 6, `eq-hp-gd` 4, `eq-hp-ibs-ibd` 2, `tbl-hp-stages` 3). Still at zero: `sec-hp-reading-map`, `tbl-hp-reading-map`, `fig-hp-cycle` (00). 02b is not cited by 06, 07, 08, 08b, 10, 10b, 11, 11b or 12 (information only, 02b-C14). The sparse spread of 02 across later parts (6 files, 20 citations, all to `sec-subdivided`, plus 2 to `tbl-keystone`) is acceptable.

## 5. Promises made in the part, and whether they are kept

| Promise (location) | Target | Kept? |
|---|---|---|
| 01:380 "@sec-simulating-crosses measures the heterozygous fraction flat across its grid of $F_{BN}$, one simulated pair per point" | 03:185-331 (flat line, replicates, the identity asserted) | yes |
| 01:487-491 the consequence of the $F_{hom}$/$F_{drift}$ gap "is measured where those metrics are reported" | 05 (`05:892-930`) | yes (THREAD: keep) |
| 02:1081 "@sec-catalogue reports the partition rather than only $GD_T$"; 02:1082 "@sec-stages makes S1 a separate monitoring stage" | 06 (`tbl-catalogue-gd-partition`), 08 | yes |
| 02:1108 "@sec-limits is where the proxy is pushed until it breaks" | 11c | yes (owed: keep true) |
| 02:13, 822-826 $\alpha$ "used in @sec-ocs"; "this chapter is the case $\lambda \to \infty$" | 09 | plausible; 02 -> 09 owed row lists nothing open |
| 02b:36 "@sec-cycles will report a constrained programme overtaking an unconstrained one at a crossover that varies with the seed" | 11b (`cycles_crossover.csv`, 11b:215-298) | yes |
| 02b:341, 517, 909 "@sec-limits tests the second reason only" (the covariance term, against a random-selection control) | 11c | yes (owed: keep true) |
| 05b:28-29 "@sec-catalogue will decompose diversity on that basis and @sec-stages will build a monitoring panel around it" | 06, 08 | yes |
| 05b:1425, 2150 "@sec-stages Trap 3 will make [the] prescription [to hold $F_{ST}$ in a band]" | 08:117-140 | yes (08:119 quotes 05b; its use of $F_{ST}$ for the setting is owed to 08) |
| 05b:413 "@sec-era-fhom measures the gap on four 60-hybrid selections, three distinct" | 05 (`tbl-era-hom-two-levels`) | yes |
| 05b:2181 "the dominance loop is @sec-alphasimr; @sec-cycles has no dominance in its traits" | 04c, 11b | yes (owed: 11b:404-409 pointer to be restricted) |
| 05b:1753 "tester count against plot error is developed at @sec-mating-connectivity, @sec-mating-tester" | 04e | yes (targets exist) |
| 00:445 "$H_o = GD_T + GD_{BS}$ derived in @sec-heterosis-identity" (00 -> 05b) | 05b | **no, see C2** |
| 02:605-607 "$\theta_A, \theta_B, \theta_{AB}$ in @sec-hp-popgen" (02 -> 00) | 00 | **no, see C1** |
| 02:1101-1110 "$GD_{BI}$ ... which @sec-response makes precise" (02 -> 02b) | 02b | kept in substance; naming gap C3 |
| preface (`index:76-78`): "the deviation from a simulated oracle is printed next to" each exact identity | 01, 02, 02b, 05b | partly, see section 6, introduction-C1 |

## 6. Hand-over to Simulation (03)

03 opens correctly (03:22-27): it names what Foundations defined, which chapter drew data from which generator (@sec-response from `simulate_pools()`, @sec-heterosis from `simulate_lines()` and `simulate_data()`), states that the two generators return the same lines and `X` at `book_cfg`'s arguments, and asserts it (`02b:63-72`, `03` @sec-sim-lines). Checks that hold: 03 reproduces the description of `simulate_pools()` of 02b:48-59; 03's treatment of $F_{BN}$ (variance $F_{BN}p^*(1-p^*)$ of the Beta, 03:83-99) agrees with 00:582, 01:372-378, 05b:617-628 and 90 Terms; 03:367-370 keeps the conditions of the $GD_{BS}$ row of @tbl-keystone; 03:293-300 quotes the drift ratios 1 and 2 of 02:596-616; 03 prose no longer says "candidate pool" (only the figure label). The opening names two Foundations consumers of the generator (02b, 05b); 00, 01 and 02 also call `simulate_data(book_cfg)` without deriving it (L, not numbered: the sentence is true of the two it names). Open items for 03 from this part: C7 (cross-reference rather than re-derive the offset), C8/C14 (the first definition of $p^*_k$ lies in 03 although three earlier chapters use it), and the `fig-candidate-pool` label. The 03 THREAD item "keep true: `03:88` reproduces the same lines and X as the `simulate_pools()` call" is true as written.

## 7. Other checks that came out consistent

- Dominance effect: $d_k$ is "dominance effect" in 00, 01, 02, 02b and 05b (grep: "dominance deviation" occurs in these only as 05b:153, 157, 164, the reserved Fisher term); the older name remains in 04c:333, 04e:176, 06:364, 06:479, 08b:767, 12:262 and 90 (all owed). 05b:152-155 states exactly this.
- $F_{BN}$ against $F_{ST}$: in 00, 01, 02, 02b and 05b $F_{ST}$ is always the statistic $GD_{BS}/GD_T$ and $F_{BN}$ the parameter; no counterexample in the five chapters.
- "Candidate set" for the hybrid set: 00 (7), 05b (2), 03 (10); "candidate pool" absent from 00, 01, 02, 02b, 05b; present in 04, 05, 07, 09, 10, 10b, 90 (owed).
- Data: 00, 01, 02, 05b call `simulate_data(book_cfg)`; 02b's `simulate_pools()` call is asserted equal to `book_cfg`'s `fst` and seed; the figures quoted across the four chapters (0.3617, 0.3281, 0.0336, 0.6717...) are inline `r` expressions, none hard-coded, so they cannot drift apart.
- $F_i$, $s_i$, $H_{o,i}$: $F_i = 2s_i - 1$ is the molecular homozygous fraction (01:229-234) and $H_{o,i} = 1 - F_i$ (02:140-155); 01's heterozygous fraction $2(1 - \bar s) = 1 - \bar F$ is the same quantity.
- $\theta_S$ includes the diagonal everywhere; $\mathbf G_{0.5} = 4\mathbf f - 2\mathbf J$ is stated identically in 01, 02b and 90.
- Promises owed to the Foundations chapters by 00 are settled: all `[settled in ...]` rows in the 00 Owed list were checked against the current text (02: 02:354-361, 404-427; 05b: 617-628; 01: 507-531, 8-14).
- Assumptions: the conditions of the $GD_{BS}$ identity (flat $d$, inbred parents, complete factorial, equal pool weights, neutral redraws) and of the genic-variance statements (complete factorial, independent loci given pool frequencies, inbred parents) are restated, unchanged, wherever they are reused (00:435-447, 01:366-380, 02:1037, 02:1085-1100, 02b:462-489, 03:367-370). 05b:522-523 reuses 04's P9 as the ground for "this book does not model depression"; declared and owed to 04 as keep true.

## 8. part-introduction findings (1 H, 1 M, 6 L open at the start)

| ID | Sev | Disposition after Foundations | Evidence |
|---|---|---|---|
| introduction-C1 | H | **open**, evidence changed | The preface's promise (index:76-78) is delivered by 02b and 05b (achieved deviations printed throughout: about 53 and 76 lines with the vocabulary of deviation/gap/residual) and only in part by 01 (`sum_G` and `Ns_on_G` printed) and 02 (one enumeration deviation, 4e-15; the rest `stopifnot()`: 02 28, 01 10, 00 7 assertions). Of the five chapters 00, 01, 02, 02b, 05b, two keep it. Owner stays index (soften the sentence), or 00, 01, 02 print the deviations they assert. |
| introduction-C2 | M | **closed** (already marked settled in the file; verified) | 01 opens with the hand-off (01:8-14); `sec-hp-popgen`/`sec-hp-ibd`/`sec-hp-inbreeding` have 9/8/7 citations, from 01, 02, 05b. |
| introduction-C3 | M | **closed** (already marked settled; verified) | "absolute" removed (the only remaining occurrence, `01:254`, is the negation "not an absolute"); the two floors are separated, 01:235-256, 01:305-336, 01:443-451. |
| introduction-C4 | M | **open**, reduced | 05b's two pointers are settled (05b:67-71, 1433-1434: S1 and S2 point to @tbl-hp-stages, the panel to @sec-stages); `tbl-hp-stages` now has 3 citations (02, 05b). The claim "The names ... are used throughout the book" (`00:175`) is unchanged; S1-S4 occur in 02 (1), 05b (4), 08 (19), 08b (1), 11 (1) and none of 07, 09, 10, 10b, which @tbl-hp-stages lists under S4. Owner 00. |
| introduction-C5 | L | open | index:28-30 typeface unchanged. |
| introduction-C6 | L | open | index:24, 34 unchanged; 00 and 02b:866 already say "mean over random subsets". |
| introduction-C7 | L | open, 01 half closed | 01:493-531 restricts `ctx[["f"]]` to the coancestry-based metrics; index:28-29 is unchanged. |
| introduction-C8 | L | open | index:68-69 "the book starts with the theory" unchanged; Foundations is now where the theory starts, which the sentence does not say. |
| introduction-C9 | L | open | index:126-136 against 00:736-754 unchanged. |
| introduction-C10 | L | open | Foundations uses "teaching scale" (00, 02, 02b, 03, 05b), names nothing in 01 (foundations-C11); index:159 "default scale" and "book scale" in later chapters unchanged. |

Closed by the Foundations work: C2, C3. Still open: 8 (1 H, 1 M, 6 L); none of the eight is fully closed, C4 and C7 are reduced. New index finding from this part: foundations-C12.

## 9. Counts

By severity: H 0, M 4, L 11 (15 findings).

By owner:

| Owner | H | M | L | IDs |
|---|---|---|---|---|
| 00 | 0 | 1 | 0 | C2 |
| 01 | 0 | 0 | 4 | C8, C10, C11, C14 |
| 02 | 0 | 1 | 1 | C1; C5 |
| 02b | 0 | 1 | 2 | C3; C6, C9 |
| 05b | 0 | 0 | 1 | C15 |
| Earlier part (index) | 0 | 0 | 1 | C12 |
| Later chapters | 0 | 1 | 2 | C4 (90); C7 (03); C13 (12) |
| Total | 0 | 4 | 11 | |

Secondary owners (not counted above): C1 -> 90, THREAD 02 entry; C2 -> 05b; C3 -> 05b; C8 -> 90; C13 -> 08; C14 -> 05b.

New rows for THREAD.md at the part close (not written here; reports only): `-> 02`: C1, C5; `-> 00`: C2; `-> 02b`: C3, C6, C9; `-> 01`: C8, C10, C11, C14; `-> 05b`: C15 (and C14); `-> index`: C12; `-> 03`: C7; `-> 12`: C13; `-> 90`: C4 (append to the existing 90 rows); correction of the THREAD 02 entry "Takes from: `00`: ... $\theta_A, \theta_B, \theta_{AB}$".
