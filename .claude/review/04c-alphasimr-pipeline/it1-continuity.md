# 04c-alphasimr-pipeline -- continuity, iteration 1 (chapter mode)

Chapter: `book/04c-alphasimr-pipeline.qmd` (2086 lines, read in full), last chapter of the Simulation part
(`_quarto.yml`: 03, 04, 04b, **04c**). Read with `90-notation.qmd` (all), THREAD entries 00, 01, 02, 02b, 05b, 03,
04, 04b, every `Owed` line naming `04c`, `part-foundations.md`, the 04 and 04b continuity reports, and, where 04c
leans on them, 02b, 05b, 04d, 11b, 11c, 04e (text), `R/13_alphasimr_bridge.R`, `R/15_response.R`.
Line numbers are those of the file as it stands in this worktree (04c is unmodified; the THREAD line numbers match).
No book edit, no THREAD entry, no replacement prose.

## Verdict in one paragraph

The chapter's own construction (Steps 1-6, 8) is consistent with 00, 03, 05b and the approved Foundations on the
points it states as results: dominance effect model, `heterosis_value/_expected/_partition/_gca_sca` identities,
GCA at the opposite pool's frequencies, inbreeding depression at F = 1, `F_ST = GD_BS/GD_T`, the 0/1/2-versus-0/0.5/1
conversion, the relaxation list of 03:141-176. Four Owed items (02b-E8, 02b-C8, 02b-C10, 05b `d_k`) are **not**
settled in the text, one (02b-E8) is stated in terms 02b explicitly withdrew. The chapter also asserts things about
11b and 04d (a no-selection control that "isolates the selection component from drift") that those chapters do not
contain, never says why it follows 04 and 04b, and gives "genic variance" a second meaning.

## Findings

IDs `04c-C<n>`; "change" = the chapter that should change.

### High

**04c-C1 (H) -- Step 7 misstates what `weights = NULL` is; 02b-C10 not settled; change: 04c.**
- `04c:1176` "The book's pipeline defaults to `weights = NULL`, meaning equal weight on every trait. Step 7 is where
  that default gets examined"; `04c:1143` heading "what equal weighting assumes"; chunk `tbl-alphasimr-index`
  (`04c:1180-1210`) uses economic weights `a2 = c(1, 1)` on the raw trait units of traits with genetic variances 1 and 4.
- `02b:628-656` (approved): the criteria of `stage2_select()` are **predicted values** $\hat{\mathbf g}$, standardised
  by `build_ctx()`, so the default is $\sum_j\hat g_j/\mathrm{sd}(\hat g_j)$, i.e. economic weights $a_j = 1/\mathrm{sd}(\hat g_j)$,
  "an economic statement ... not a neutral one"; for BLUP $\hat{\mathbf g}$ the optimal index weights equal $\mathbf a$ (02b:660-675),
  and the Smith-Hazel $\mathbf b = \boldsymbol\Sigma_P^{-1}\boldsymbol\Sigma_G\mathbf a$ applies to **phenotypic records** $\mathbf y$.
- Three consequences in 04c: (i) `a2 = (1, 1)` on raw trait units is not the default (the default weights each trait by the inverse s.d. of the criterion, and the two traits have genetic variances 1 and 4);
  (ii) Step 7 compares equal weights with Smith-Hazel on phenotypes, which is the 02b `y` case, and calls the gap "what the default assumes";
  (iii) the AlphaSimR instance feeds `stage2_select()` **phenotypes**, not predictions: `R/13_alphasimr_bridge.R:198`
  `traits = as.data.frame(hybrid_pop@pheno)` (one plot, `setPheno()` at `R/13:171`), so Step 8's stage 2 is the phenotypic-criteria case,
  and no sentence says so. 02b-C10 asks exactly for the phenotypic-versus-predicted statement and for what the instance adds; neither is there.
- Same wording sits in `R/15_response.R:63-64` roxygen (a code/man item, quant-Rwrite; 02b owns the corrected statement).

**04c-C2 (H) -- the restricted index: lineage attributed to 02b is the one 02b withdrew; "exactly zero" states an expectation as realised (02b-E8); change: 04c.**
- `04c:1239-1244` "The restricted index holds trait 2 at exactly zero ... That is the construction of @kempthorne1959 and, as
  @sec-response argues, the classical ancestor of this book's `alpha` constraint -- restrict a direction rather than price it."
- `02b:733-779, 880-891` (THREAD 02b entry): Kempthorne & Nordskog (1959) **not read**; the matrix form $\mathbf b = \ldots$ is "the book's own statement";
  only $\mathbf C'\mathbf b = 0$ is claimed; the restricted direction "is not [the book's] contribution" and restricting a group coancestry while maximising gain is
  Meuwissen et al. (2020) (read); 02b lists four differences between an equality restriction on a trait and the $\alpha$ inequality on diversity (09-C11/R14 repeat this for 09).
  "As @sec-response argues, the classical ancestor of the `alpha` constraint" is the claim 02b withdrew.
- "holds trait 2 at exactly zero": the chunk asserts `abs(gain_trait2) < 1e-10 * max(abs(dG))` on $\mathbf G\mathbf b/\sqrt{\mathbf b'\mathbf P\mathbf b}$ computed from this population's
  sample matrices: the **model expectation** of the gain, not a realised change (caption `04c:1180` says "zero expected gain", the text two lines later says "exactly zero").
  02b-M17 and 02b-E8 flag the same wording in `R/15`, `man/index_restricted.Rd`, `92:113`.
- The Kempthorne source is also UNVERIFIED in `it1-refs.md` (04c-B5).

**04c-C3 (H) -- $d_k$ named "dominance deviation" (05b Owed); change: 04c, and 90.**
- `04c:333` "$d_k \in \mathbb R$ the dominance deviation, the departure of the heterozygote from that midpoint". `05b:145-166` (@sec-heterosis-dk-meaning) names this object
  the **dominance effect** and reserves *dominance deviation* for Fisher's statistical object (a property of a population). 00, 01, 02, 02b, 05b are converted.
- In 04c the clash is live, not cosmetic: the same chapter reports the statistical objects, `varD`/`genicVarD` (`04c:419-423, 485-491`) and the average effect $\alpha_k$
  (`04c:505-516`), and says `varD` "among the inbred founders is exactly zero ... whatever $d$ is" -- with "dominance deviation" meaning $d_k$ a reader reads `varD = 0` as $d_k = 0$.
- Residue outside 04c, same name: `90:210`, `90:518`, `90:608` (and the AlphaSimR row `90:555-559` defines $\delta_k$ from $d_k$ without naming it); `04e:176`, `05:325`, `06:364, 479`, `08b:135, 767`, `12:262`.
  Those are already Owed in the 05b entry; listed only so the grep is complete.

**04c-C4 (H) -- two claims about later chapters that those chapters do not support; change: 04c.**
- `04c:1928-1932` "the control isolates that component [selection] from the drift part, which is the distinction @sec-cycles draws with the package's own faster simulator over a longer
  trajectory and a grid of selection intensities, and @sec-programme draws a third time in an inbred-line programme."
  - 11b (`11b-diversity-across-cycles.qmd`): trajectories under a diversity budget `alpha`, `max_use` caps, injection, DE-versus-greedy selector, with the frozen-base drift lens;
    no random-selection control and no grid of selection intensities (grep: `n_sel` appears at 11b:59, 301 as a fixed value; the CSVs are `cycles_{trajectory,crossover,maxuse,injection,selector}`).
  - 04d: `04d:366-370` says its loss is "measured against the programme's own starting point rather than against a random-selection baseline of the same size ... a same-size random
    baseline would attribute part of this loss to drift rather than to selection" -- it explicitly does **not** draw the distinction.
- `04c:2067-2070` "@sec-cycles runs the same diversity-erosion argument ... this chapter is its cross-check against an engine with real meiosis behind it, and @sec-limits uses this chapter's linked arm":
  04c has no "linked arm" (the arm called linked is 11c's, built on `alphasimr_founder_pools()`, 11c:171-196); 04c's Step 8 has no diversity **constraint** (unconstrained RRS against a random-elite control), so it cross-checks nothing of 11b's `alpha` result;
  and 04c never computes `varA`/`genicVarA` across cycles (that is 11c's linked arm, `limits_linked.csv`). Medium in itself, High because the sentence is the chapter's stated connection to 11b/11c.

### Medium

**04c-C5 (M) -- opening does not say why 04c follows 04 and 04b; change: 04c.**
`04c:11-17` opens "@sec-simulating-crosses built the ... contract with a deliberately fast simulator ... This chapter builds one." The two chapters immediately before (04 sizing, 04b backcross) are not mentioned
in the opening; neither forwards to 04c (`04:1067-1170`, `04b:1068-1100`). 04 and 04b run on package simulators (`R/06_f2size.R`, `R/08_mabc.R`), not AlphaSimR, and 04c's one tie to them is the
bullet at `04c:2035-2036` (MABC scans cached) and the DH remark at `04c:662` (see C13). The part is 03 -> 04 -> 04b -> 04c; the transition is to 03 only. A sentence of position (what the part has done by now,
and that 04c is where the generator is rebuilt with real meiosis) is missing.

**04c-C6 (M) -- $r$ is accuracy and locations in one chapter; 02b-C8 only half-settled; change: 04c (and 90).**
- `04c:848-851` accuracy $r$ = correlation of the phenotype with the **breeding value** `bv()`; code `R_i_r_sdA`, `r_emp`. `04c:981-984` and eq. `@eq-alphasimr-accuracy` use $r$ for **locations** ("$t$ testers and $r$ locations").
  The `90:545-565` AlphaSimR table defines $r$ only as locations and says nothing of the accuracy $r$ the same chapter uses 130 lines earlier; `90:443-446` (mating-design note) lists the other clashes ($r$ plots; accuracy in GP and response tables) without naming 04c.
- 02b-C8: define $r$ against the breeding value (done, 04c:849-850) **and say it is not the $r$ of @eq-response-breeders unless $d = 0$** (not said). `02b:92-96` defines $r$ as accuracy "as a predictor of genetic value" with a purely additive trait ($d \equiv 0$, $\sigma_A$ = `sd(gv)`);
  04c's $\sigma_A$ is $\sqrt{\texttt{varA}}$ and its $r$ is against `bv()`. Also not said: 04c's "response" (`R_observed`, `04c:851-852`, change in the **progeny** mean after random mating) is the object 02b says it is *not* measuring (`02b:105-114, 288-296`: genetic differential on the selected hybrids, not transmitted).
  `04c:848` "the form @sec-response builds the book's objective side on" is true of the equation, not of the checked object. 02b's side is already declared (`02b:298-301`); 04c's side is silent.
- Related, same chapter: $t$ is testers (`04c:981`), selfing generation ($F_t$, `@eq-alphasimr-selfing`), a Student $t$ (declared) and, in prose, the paired $t$ statistic -- declared at `04c:981-983`; $q$ is the selected fraction in `tbl-alphasimr-breeders` and $q_k = 1-p_k$ at `04c:495-516` (not declared; code/prose only).

**04c-C7 (M) -- "genic variance" has two definitions across 02b and 04c; change: 04c (wording), 02b not.**
`04c:458-460` "`genicVarA` is what it would be if the loci were independent and in Hardy-Weinberg proportions ... the package's `genic_var()` computes the same quantity from a marker matrix directly."
`R/15_response.R:49-55` `genic_var()` = $\sum_k\beta_k^2\,\mathrm{Var}(x_k)$ with the **observed** per-locus variance of the matrix passed (02b `@eq-response-genic`); AlphaSimR's `genicVarA` = $\sum_k 2p_kq_k\alpha_k^2$
(HW, average effect with $d$; `04c:518-530`). They agree only for an additive trait in a Hardy-Weinberg population. 04c's own chunk shows the gap on the inbred panel (`ratio_LE` ~ 2, `04c:440-457`) and the dominance trait
adds another. 02b's "$V_{genic}$" and 04c's "genic" thus differ in what is held fixed (observed variance, so the ratio isolates the covariance term, versus HW expectation, so the ratio also carries homozygosity); 04c explains the inbred case but states the two as the same quantity.
11c reads both: the unlinked arm uses `genic_var()`/`var_genic`, the linked arm AlphaSimR `genicVarA` (`11c:177`), with `rel = (varA - genicVarA)/genicVarA`.

**04c-C8 (M) -- `GD_BS` "carries the heterosis signal" and RRS "expected" to raise it: conditions of 02/05b dropped; 05b's forward claim is only half kept; change: 04c.**
- `04c:1988-1991` "`GD_BS`, the between-pool divergence that carries the heterosis signal (@sec-choosing)"; `04c:1936-1940` "where it is, and positive, RRS is moving the pools apart faster than drift does, which is what a scheme selecting on the cross is expected to do".
  02/05b: $GD_{BS}$ is the divergence term of expected heterosis only for flat $d$, inbred parents, complete factorial, equal weights (`02:1037`, `05b:297-306`); with varying $d$ it holds for the $d$-weighted term only; neutral divergence adds no heterosis (`05b:602-787`).
  Step 8's pools are **outbred** recombined pools (`GD_WI > 0`), $d_k = \delta_k|a_k|$ varying, products 6 x 6 elite factorial. The conditions are not restated and the "expected" has no support in either chapter.
- 05b `2178-2183` (inference, declared as such): selection on cross performance "is the only [considered] process that can move frequencies depending on where the dominance is ... the dominance loop is run in @sec-alphasimr". 04c does run the loop on a dominance trait, but measures none of the alignment quantity of
  05b (`cov(d, y^2)`, `@eq-het-alignment`), nor the divergence share across cycles (`heterosis_divergence_share` is computed only across **founder split times**, `tbl-alphasimr-split`). The inference stays untested and 04c does not say it is untested. Keep-true for 05b passes (the loop exists and uses a dominance trait); the missing sentence is 04c's.
- `04c:1503-1505` "drift moves diversity from within pools to between them and does not create it": 05b's accounting is that within-pool diversity falls by **twice** what the between term gains and $GD_T$ pays unit for unit (`05b:602-787`); the sentence is about heterosis there ("the reading @sec-heterosis gives for expected heterosis") but is ambiguous on $GD$.

**04c-C9 (M) -- "book scale" is a third scale, not `book_cfg`; change: 04c (introduction-C10 residue).**
`04c:1596, 1607, 1790, 2032` (caption of `tbl-alphasimr-cycle1`, prose, figure caption, the Scale paragraph) call 12 + 12 founders, 5 x 150 = 750 sites "book scale"; `book_cfg` (A8, the teaching scale of 00/90) is 25 + 25 lines, 2000 markers;
`rrs_config` defaults are 20 + 20, 5 x 100; Steps 2-6 use 60 founders x 1000 QTL; Step 7 80 founders. `part-introduction.md` C10 left "book scale" in 04c to this review. The chapter's own scale list (`04c:2031-2040`) is correct; the label is what collides with A8.

**04c-C10 (M) -- tester-accuracy formula derived in full in three chapters; change: 04c cross-references, 05b/04e unchanged here.**
`@eq-alphasimr-accuracy` (04c:990-1012): $\rho = \sqrt{v_g/(v_g+v_s+v_e)}$ with finite tester pool factor $(n_B-t)/(n_B-1)$, sample variance $n_A/(n_A-1)$, plot error $\sigma^2_e/(tr)$, Jensen term measured (`tbl-alphasimr-jensen`).
`05b:1788-1799` (`@eq-het-rho-k`, Step 6 of the protocol): the same expression for heterosis with $\sigma^2_e = 0$ -- algebraically the $v_e = 0$ case of 04c's (the $n_A/(n_A-1)$ factors cancel when $v_e = 0$) -- and 05b's two untested reasons for the simulated mean exceeding it (Jensen; $\mathrm{cov}(g^A_i,\bar s_{i\cdot})$ not zero on a subset) are exactly what 04c measures for a different trait.
`04e:218` (`@tbl-mating-quantities`): the same $\rho$ with $c$, $r$, no finite-pool factor. 04c cites neither (`@sec-heterosis-step6`, `@sec-mating-tester`), and the three use $k$ (05b, 04e), $t$ (04c) for testers. The 90 AlphaSimR row declares the renaming of $k$ to $t$; it does not say that 05b's $\rho_k$ is the same quantity.
Owner: 04c holds the fullest version (finite pool, plot error, Jensen measured); 05b is earlier and approved; so 04c should state the relation to `@eq-het-rho-k` and 04e's $\rho$ rather than present the formula as new.

**04c-C11 (M) -- Step 7 repeats 02b's index paragraph; change: 04c.**
`04c:1210-1226` item 1 (eigenvector condition, sufficient condition $\mathbf G = c\mathbf P$, "requires neither equal variances nor uncorrelated traits", the `index_smith_hazel()` help-page example) is 02b's paragraph (`02b:700-713`, `02b:738-749`) re-developed; 02b owns it. 04c's own contribution is the numerical-optimum check (`optim`, `04c:1249`), which 02b lacks (THREAD 02b: "derivation as the maximiser is not given; checked outside the chapter by reviewer only"); that check should be offered as such, with a cross-reference to `@eq-response-smith-hazel` and `@tbl-response-restricted` for the rest.

### Low

**04c-C12 (L) -- $x_{ik}$ in 0/1/2 (01-C13): settled by declaration, residue.** `04c:325-327` and the `90` AlphaSimR row (first row) both say 0/1/2 dosage, "an entry of $\mathbf M^H$, not of $\mathbf X$".
01 (`@eq-hybrid-dosage`) already has the symbol $M^H_{(ab)k}$ for the same dosage; so one quantity has two symbols (01, 04c) and $x_{ik}$ two quantities (01/90 first table, 04c). Declared at both ends; renaming in 04c would remove it.

**04c-C13 (L) -- unflagged forward dependences and unmapped cross-references.**
(a) Last subsection of Step 8 runs `stage2_select()` and prints `DE_alpha`/`ref_truncation` rows, "the attainable `alpha` ceiling" (`04c:1980-1986`) and `max_use` (`04c:899`) with `@sec-combinatorial` cited three times and no "later" marker; the Simulation part precedes Optimisation. The `alpha` and the ceiling are introduced in the preface and `02b`, the row names are not.
(b) 04c cites no section of 00 (`@sec-hybrid-programme`, `@sec-hp-cycle`) although Step 8 *is* 00's programme (DH lines, testcross, recycling within pool, S1-S4 never mapped); 00:746 places 04c under "candidate lines and pools generated".
(c) Step 5's heterozygosity $(1/2)^{t-1}$ at $F_t$ (`@eq-alphasimr-selfing`) is 00's selfing series (offset: 00's $t$ counts selfings after the F1) and 04's live check (F2 0.497, F3 0.254, F4 0.127, `04:231-397`); neither is cited. `04c:662` "It is also why @sec-sizing is a chapter" (number of DH lines) -- 04 sizes selfing/SSD F2 to F4 populations, not DH (DH at 04:24, 208 only).
(d) 04c cites `@sec-heterosis` eight times and no `@eq-het-*`; `@eq-alphasimr-hij`, `-hbar`, `-gca` are 05b's `@eq-het-value`, `@eq-het-expected`, `@eq-het-gca-sca` in AlphaSimR coding. `@eq-alphasimr-gca` uses $g^A_i$ for the **whole** GCA of $G_{ij}$ (00's/04e's sense) and calls the dominance part `gca_A`, which is 05b's $g^A_i$ ("GCA for heterosis"); 90's two $g^A_i$ rows (Owed to 90, 00-C33) are not linked from 04c.
(e) `04c:285` "the case @sec-programme runs throughout" for `SP$addTraitA()`; `04d:145` uses `addTraitAG`; `04c`'s own table says so (the AG row). Wording only.

**04c-C14 (L) -- Step 8 selection is on GCA against **outbred** testers (`04c:1612-1617`), described as "the GCA estimate of Step 6" (`04c:1266, 1625`).** Step 6 and `@eq-alphasimr-gca` are for inbred pool B lines (05b premise A2); 04c states "outbred individuals rather than inbred lines" at item 2, so the assumption is declared; the identification with Step 6's GCA is not, and the tester slice is the first 2 individuals of the current pool.

**04c-C15 (L) -- $\sigma^2_{SCA}$ in 90 versus 04c.** `90:202, 214` $\sigma^2_{SCA} = 4\sum_k d_k^2p_{Ak}q_{Ak}p_{Bk}q_{Bk}$ (closed form for independent-Bernoulli lines); `04c:1004-1006` $\sigma^2_{SCA} = (n_An_B)^{-1}\sum s_{ij}^2$ (realised mean square on the factorial, computed `var_sca`); both called "the $\sigma^2_{SCA}$". Same for $\sigma^2_{GCA}$ versus `var_gca`/$v_g$ ($n_A-1$ divisor). Declared in the chapter, not in 90.

**04c-C16 (L, outside the chapters) -- project note conflicts with the chapter's measurement.** `CLAUDE.md` says the MaCS call "consumes an unpredictable amount of R's own random stream"; `04c:135-151` asserts (`stopifnot(identical(rs_ma, rs_mb))`) that `.Random.seed` is **identical** after two `runMacs()` calls from one seed and only the haplotypes differ; `11c:195-198` agrees with 04c. Not a chapter edit; the CLAUDE.md sentence and the `alphasimr_founder_pools()` roxygen should follow the measured behaviour.

## Owed items naming 04c: settlement

| Item (source) | 04c today | Disposition |
|---|---|---|
| Comstock et al. (1949), `04c:23, 916` (00, 05b entries) | RRS attributed to the paper (`04c:23`); "built on using the opposite pool as the tester so that selection captures both" (`04c:915-916`) | **PENDING** (no copy; `it1-refs.md` 04c-B1 UNVERIFIED a and b). Not a finding to fix here. What waits on the source: the two attributions only; 05b reports the title only (05b:1025-1031), so 04c:915-916 goes slightly beyond what the book has read ("both GCA and SCA" is in the title). |
| 01-C13 dosage {0,1,2} vs {0,0.5,1} | `04c:325-327` declares it; `90` row declares it | **Settled here by declaration** (no change owed); residue C12 (L) |
| 02b-E8 `04c:1242` ancestor of `alpha`; `04c:1239` "exactly zero" | unchanged | **Earlier-chapter claim stands, 04c must change** -> C2 (H) |
| 02b-C8 define $r$ against breeding value | `04c:849-850` done; "not the $r$ of `@eq-response-breeders` unless $d = 0$" and "different object" missing | **Open in 04c** -> C6 (M) |
| 02b-C10 Step 7 and phenotypic-versus-predicted criteria | unchanged | **Open in 04c** -> C1 (H), C11 (M) |
| 05b: `04c:333` "dominance deviation" | unchanged | **Open in 04c** (and 90) -> C3 (H) |
| 05b keep-true: dominance trait (`04c:272-357, 505`) and the loop | true as written (trait model, `inbreeding_depression(F_coef = 1)`, the loop on a dominance trait); 05b's inference stays untested and 04c does not say so | **Kept true**; the missing sentence is C8 |
| 03 keep-true: `04c:12-15`, relaxation list `04c:1995-2002`, `04c:1280` (BN draw), `04c:105` | all agree with 03:141-176 (no dominance, no recombination, independent markers; `03:158, 175` promises kept: linkage, outbred founders, directional dominance, multi-generation selection) | **Kept true** |
| 04b keep-true: `04c:2036` MABC scans cached | `04c:2035-2036` "unlike the MABC scans in @sec-backcross"; the six `mabc_*` tables are read from `book/data` (04b head) | **Kept true** |

Promises made *to* 04c by earlier/other chapters: `00:746` (kept), `02b:105, 298-301` (kept for the equation and the object; see C6), `03:158, 175` (kept), `05b:525` (kept: ID applied at F = 1 only, `04c:506, 519-531`), `05b:2182` (half kept, C8), `index:119-121` (kept), `90:567` (kept).
Promises made *by* 04c: `@sec-genomic-era` takes the marker-QTL gap seriously (`04c:372`; 05 has neutral versus QTL panels and LD, `05:511, 576, 1357`; not tested here); `@sec-genomic-prediction` builds traits on the markers (`04c:267`; 08b `qtl <- sample.int(m, 3)` trait, consistent); `@sec-limits` measures the `varA/genicVarA` ratio (11c:177, kept); `@sec-cycles` argues the recycling asymmetry (`11b:33-36`, kept); `@sec-cycles` / `@sec-programme` draw the control-versus-drift distinction (**not kept**, C4); `@sec-programme` adds G x E (04d:145, kept); `04c:2077-2079` closes the part and the next chapter is `05-genomic-era` (kept).

## The chapter's job (check 5, and the claim that it teaches primitives the Simulation part uses)

- Inbound `@sec-alphasimr` (self-citations discarded): 24 occurrences on 23 lines, from 12 files:
  `00:746`; `02b:105, 298`; `03:158, 175`; `04d:13, 78, 95, 244, 405, 410, 422`; `04e:35`; `04f:892`; `05b:525, 2182`; `11b:24`; `11c:171, 232`; `90:567`; `92:236`; `index:119, 121, 217`.
  Not an orphan. All 16 distinct `@sec-` targets cited by 04c resolve (no broken target).
- But the chapter is the **last** of the Simulation part, so "primitives the rest of the Simulation part uses" is true of nothing in that part: 04 and 04b run on `R/06_f2size.R`/`R/08_mabc.R` and cite 04c zero times; 03 cites it twice, forward.
  Chapters that use the primitives: **04d** (seven citations; `reps` Step 2, `selectWithinFam()` Step 6, Step 1 LD cost, Step 7 index questions, Step 8 non-reproducibility: all five statements true of 04c); `04f:892`/`04e:35` mention it for the genetics/commercial cross; `11c` builds its linked arm on the Step 8 wrapper; `11b:24` points to Step 8.
  05, 06, 07, 08, 08b, 09, 10, 10b, 12: zero citations (no reason to have any).
- `04c`'s forward dependence (outbound to later chapters): `@sec-programme` 12, `@sec-limits` 6, `@sec-cycles` 3, `@sec-combinatorial` 3, `@sec-genomic-era` 2, `@sec-genomic-prediction` 1, `@sec-choosing` 1; only `@sec-programme` carries a "later" marker (`04c:40-41`).

### Inbound `@sec-` counts (self-citations discarded; all chapters, files in `_quarto.yml` order of part, occurrences / distinct citing files)

| Chapter | In | Files |
|---|---|---|
| 00-hybrid-programme | 52 | 12 |
| 01-coancestry | 40 | 15 |
| 02-subdivided | 53 | 15 |
| 02b-response | 32 | 14 |
| 05b-heterosis-dominance | 88 | 21 |
| 03-simulating-crosses | 35 | 17 |
| 04-population-sizing | 25 | 11 |
| 04b-backcross-introgression | 9 | 8 |
| **04c-alphasimr-pipeline** | **24** | **12** |
| 05-genomic-era | 44 | 18 |
| 06-metric-catalogue | 48 | 20 |
| 07-choosing-metrics | 46 | 19 |
| 08-pipeline-stages | 40 | 17 |
| 08b-genomic-prediction | 28 | 15 |
| 09-optimal-contributions | 39 | 15 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 26 | 9 |
| 04e-mating-design | 62 | 9 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 12 | 5 |
| 11-plant-literature | 15 | 8 |
| 04d-breeding-programme | 19 | 6 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 20 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 21 | 7 |
| 91-package | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

No broken `@sec-` target anywhere (all sections resolved to a unique file). `index.qmd` and the references have no `{#sec-}`.

## Checks that pass (for the record)

- Notation: $\mu_0$/$\bar H$ renaming (90), $G_i$ versus Caballero-Toro, $\alpha_k$ versus the budget $\alpha$, `G`/`P` in Step 7 as $\boldsymbol\Sigma_G$, $\boldsymbol\Sigma_P$, $u_{ik}$, $p_{Ak}$, $y_k$, $H_{ij}$, $GD_{WI}+GD_{BI}+GD_{BS}$, $F_{ST} = GD_{BS}/GD_T$ (asserted in the chunk), $\theta$/$GD$ on `f` (not VanRaden $G$): all agree with 90, 02, 05b.
- Algebra consistent with 05b: $p_A+p_B-2p_Ap_B = 2\bar p\bar q + y^2/2$; Falconer's $\sum d_ky_k^2$ equals twice the divergence term; $ID = 2F\sum d_kp_kq_k$ at $F = 1$; GCA at the opposite pool's frequencies, $(1-2p_{Bk})$; a line's dominance value zero on an inbred panel.
- Selfing index: $F_t$ with $(1/2)^{t-1}$ matches 04's live F2/F3/F4 values and the 0.125 of 04/90.
- Reproducibility policy (found once, then branch; reseed before each founder draw) agrees with 11c:193-205 and 04d:242-245.
- Tester accuracy: `@eq-alphasimr-accuracy` reduces to 05b's `@eq-het-rho-k` at $\sigma^2_e = 0$ and to 04e's $\rho$ at $n_B\to\infty$ (algebra above, not run).

## Not checked here (other lanes)

References (`it1-refs.md`: Comstock, Sprague & Tatum, Falconer & Mackay locators 04c:330, 497, 508, 649, 712, Kempthorne & Nordskog UNVERIFIED; 02b gives no Falconer locator, 04c gives three); chunk numbers (inline values are computed at render, not re-run); the Typst fit of the five sub-tables of `tbl-alphasimr-split` and `tbl-alphasimr-paired`; `_freeze` and `docs/` freshness.
