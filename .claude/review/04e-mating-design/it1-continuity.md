# 04e-mating-design -- iteration 1, continuity (chapter mode, read-only)

Chapter: `book/04e-mating-design.qmd` (1162 lines). Read against `CLAUDE.md`, `book/_quarto.yml`, `book/90-notation.qmd`,
`THREAD.md` (00-09, 10 provisional, 10b), the part files, and the text of 00, 03, 04c, 05b, 08b, 09, 10b, 11, 11b, 04f, 04g
where they touch 04e. Nothing was edited. IDs `04e-C<n>`. Owner: **this** = 04e; **earlier (fix now)** = an approved
earlier chapter that could be fixed in this pass; **later (Owed)** = a chapter after 04e in `_quarto.yml`.
Line numbers are the worktree's (uncommitted part-review edits included).
It complements `it1-audit.md` (R1-R14, within-chapter numbers and the Owed table) and `it1-refs.md`; overlaps are cited, not redone.

Part order: 04e opens "Mating and testing design" after Optimisation (09, 10, 10b) and before 04f, 04g. It leans on 00, 03, 04c, 05b, 08, 08b
(all earlier) and forward-cites only 04f, 04g (declared) and 11b (see C2).

## Findings

**04e-C1 (H) Owner: this (alternative: earlier, 09, one sentence). 09's promise to 04e is not kept, and 04e's closing sentence contradicts 09 on what a "cross" is.**
- 09:190-199 (callout "What the contributions are attached to"): $c_i$ is attached to a hybrid, "that is, to one $A \times B$ cross"; "Assigning contributions to crosses under a field limit on the number of crosses is the problem of the mating-design part (@sec-mating)"; Gorjanc 2018 "cited here for the name only: that paper was not read ... nothing in this chapter rests on its content". THREAD 09 Owed: "04e @sec-mating must treat assigning contributions to crosses under a field limit".
- 04e:829-840 is one literature paragraph (Lehermeier, Lian, Gorjanc, Allier, Kinghorn), with no model of contributions-to-crosses under a crosses limit; 04e:1150-1153 says @sec-ocs "applied to crosses rather than hybrids, becomes the optimal cross selection of @gorjanc2018".
- Contradictions: (a) in 09 a hybrid *is* a cross, so "crosses rather than hybrids" has no referent there; (b) the crosses of 04e:829-832 and Gorjanc/Lehermeier/Allier are crosses *made to produce the next generation of lines* (within-pool, S2), which 11:192-201 and 08:408-420 (usefulness criterion, S2) say are upstream of the hybrid step 09/10 handle; the A x B crosses of 04e's design sections are a third object (crosses made to be tested). One word, three objects, never separated in 04e. (c) 04e restates the usefulness criterion (830-832) without a pointer to @sec-stages (08:408-420; 90:301-312, 357-358).
- Needed in 04e: either treat the assignment problem (what the Optimisation part's field limit $n_{sel}$ and `max_use` already do, and how it differs from a sampling design for estimation), or say that it is not treated and point to what is (09's callout then needs a one-line reword, earlier/fix now). Name the two senses of "cross".

**04e-C2 (H) Owner: this (reword); later (Owed) 11b (declare the assumption). Forward promise at 04e:1153-1155 is not kept.**
04e: "@sec-cycles is where the consequence of holding a design fixed while the pools drift is played out over many cycles." 11b has no crossing design: its cycle evaluates "every A x B hybrid" (11b:58, figure; no grep hit for tester, factorial, mating design, crossing plan in 11b), and 11b cites 04e zero times. 04e:1034-1035 (step 6 "re-optimise every cycle", with @sec-mating-connects) is only a pointer to 04e's own last section and is fine. Either 04e drops the promise or says it is not tested in the book (04e:1057-1060 open problem 5 already says "not validated"); 11b should state that it assumes a complete factorial with known values (its assumptions block after 11b:75).

**04e-C3 (H) Owner: this. Opening misdescribes earlier chapters (carries 03-C10).**
04e:35-39: "Every chapter before this one took the hybrids as given ... @sec-simulating-crosses derived populations from crosses already chosen ... None of them asks where that list came from."
- 03 forms every A x B cross once and derives no population (03:164-178); the derived-population chapter is @sec-sizing. 03-C10 was recorded in the 03 entry, part-simulation.md:93 and it1-audit.md R14 and the text is unchanged.
- "None of them asks where the list came from" is false of: 00:97-132 (testcross and sparse factorial as the way lines are evaluated, pointing to @sec-mating-tester, @sec-mating-sparse); 04c:1091-1139 ("How many testers, how many locations": "A programme cannot cross every candidate to every line", with a measured accuracy, tied to @tbl-mating-quantities); 05b:1745-1760, 1789-1799 (Step 6, crossing layout); 03:176-178 and 09:190-199 (each asks and defers to 04e). The true statement is narrower: the Optimisation part (09, 10, 10b) and the metrics take the list as given.

**04e-C4 (M) Owner: this. Opening does not say why it follows 10b.**
The chapter opens a part after Optimisation but gives no link from 10b's close (what 10b leaves: selection among a list of predicted hybrids) to this chapter's question; the Preface (index:121-123) says the crossing plan comes "before any of it" while `_quarto.yml` places it after. One sentence naming the reason for the order (the list of hybrids that 09/10/10b take as given is what this part produces) is missing. Also not said: where the design problem sits in @tbl-hp-stages (00:173-197 says testing in cross is not a stage; S3/S4 are where a reduced line set or a hybrid mining step live).

**04e-C5 (M) Owner: this. Hand-off to the Optimisation part is mis-stated.**
04e:1150-1151 "@sec-combinatorial and @sec-advanced take the hybrids a crossing plan produced and select among them". The candidate set of 03 (complete A x B factorial, 03:176-178), 09, 10 and 10b is every combination with a predicted value, made or not. By 04e's own numbers the fielded plan is 1 to 7.5 % of the factorial (04e:97-99, @tbl-mating-fewest 1 % to 2.5 %); the other cells are predictions. The chapter never says what the values handed to the optimiser are after a sparse plan (BLUP GCA of the lines plus what for SCA, GBLUP additive, which accuracy: all-lines GCA 0.6-0.8, genomic T0 0.10-0.15), which is where 07's Finding 5 (nominal $r$) and 08b:1185-1200 meet 04e. Assumption across chapters (check 8): "known values for the whole factorial" (03, 09, 10, 10b) against a sampled factorial (04e).

**04e-C6 (M) Owner: this. Restates @eq-hp-gca-sca instead of citing it (00-C25 open, 00 entry line 67).**
04e:162-170 re-derives the model of 00:106-121 (same $\bar y_{ij}$, $g^A_i$, $g^B_j$, $s_{ij}$, $\bar e_{ij}$) with no `@eq-hp-gca-sca`, no label of its own, and without defining $\mu$ and $\bar y_{ij}$ (both owed rows in 90: THREAD line 78). 00:117-121 says @eq-hp-gca-sca "is the model of @sec-mating-estimation". 04e adds only $\mathrm{Var}(\bar e_{ij}) = \sigma^2_e/r_{ij}$, $n_A'$, $n_B'$; that is what it should keep.

**04e-C7 (M) Owner: this (one sentence). The symbol $g^A_i$ means two things between 05b and 04e, and 04e sends the reader to 05b without saying so.**
04e:164-178: $g^A_i = \sum_k [a_k + d_k(1-2p_{Bk})]\,\delta u_{ik}$, the whole GCA. 05b:962-983 ($g^A_i = \sum_k d_k(1-2p_{Bk})\delta u_{ik}$, "the dominance part ... Where the two have to be told apart, this book writes GCA for heterosis"); 90:211 (heterosis table, "GCA for heterosis") and 90:508 (mating table, "GCA of a pool-A / pool-B line") are two rows for one symbol. 04e:172-175 says 05b derived "exactly this decomposition" and 04e:182-183 that the additive part "changes nothing else". 05b states the distinction from its side and cites 04e:178; 04e should state it from its. Related: $\delta u_{ik}$ is defined at 04e:180 against "the pool frequencies $p_{Ak}$"; the chunk (04e:198-200) and `heterosis_gca_sca()` centre on the candidate lines' own means (it1-audit.md R11, 0.95 difference with pool frequencies); 90:218 defines $\delta u$ with $p_{Ak}$.

**04e-C8 (M) Owner: this ("dominance deviation", Owed from 05b). 04e:176 still says "the dominance deviation $d_k$".**
05b:153-164 reserves "dominance deviation" for Fisher's statistical term and names $d_k$ the dominance effect; 90:216 and 90 table rows were changed; the grep over `book/*.qmd` leaves 04e:176 and 12:264 ("Estimating the dominance deviations", owed to 12). 04c:406 uses it correctly (Fisher).

**04e-C9 (M) Owner: this and 90 (later Owed to 04f, 04g, 08b side already recorded in 08b-C19). Variance-component symbols.**
Within 04e one quantity, the SCA variance, is $\sigma^2_s$ (04e:169, 217-218, table row 3-4) and $\sigma^2_{SCA}$ (04e:332, 437), the GCA variance is $\sigma^2_g$ (168, 217-218) and $\sigma_{GCA}$ (940), and the code names are `vc$A`, `vc$B`, `vc$S`. Elsewhere: 05b:1797-1798 and 90:228-239 write $\sigma^2_{GCA_A}$, $\sigma^2_{GCA_B}$, $\sigma^2_{SCA}$ (90:228 as the closed form $4\sum d_k^2 p_{Ak}q_{Ak}p_{Bk}q_{Bk}$, not a model parameter); 04f:233-235 maps $\sigma^2_f$, $\sigma^2_m$ to 04e's $\sigma^2_g$ and says $\sigma^2_s$ "is also written $\sigma^2_{SCA}$"; 08b:128-155 $\sigma^2_u$, 04f:278, 684 $\sigma^2_G$. 04e defines $\sigma^2_g$ as "within the pool whose lines are being ranked", but the running example has two pool values (8.185, 7.158, 04e:30) and the closed-form chunks use their mean (04e:387, 402-405); this is not said. 90's mating table (508-516) has no row for $\sigma^2_g$, $\sigma^2_s$, $\sigma^2_e$, $\bar y_{ij}$, $\mu$, $n_A$, $n_B$, $n_A'$, $n_B'$. Needed: one symbol per quantity in 04e ($\sigma^2_s$ or $\sigma^2_{SCA}$), a defined mean for $\sigma^2_g$, and one mapping row in 90 (owner 90, earlier/fix now or at the 90 close; 04f's note at 233-235 then follows).

**04e-C10 (M) Owner: this. "SCA:GCA ratio" and "SCA share" are two statistics, and 04e:1143-1148 lets 05b's stand for 04e's.**
04e's ratio is $\sigma^2_s / \overline{\sigma^2_{GCA}}$ (cached reference 0.3779 = 2.899 / mean(8.185, 7.158)); 04e:439-441, 626, 855, 860, 1145-1147. 05b's quantity (05b:1355-1370, 1402-1425, `frac_SCA`) is $\sigma^2_{SCA}/(\sigma^2_{GCA_A} + \sigma^2_{GCA_B} + \sigma^2_{SCA})$ of the variance in *heterosis*, additive variance excluded, under *neutral* divergence; 05b:1362-1370 says its ratio is not Reif's $\sigma^2_D/\sigma^2_A$ nor interchangeable with it. In the 04e running example the share is 2.899/18.242 = 0.159 and 04e:409 and 844 speak of "SCA 20 to 30 % of the genetic variance" (a share, of total genetic variance). 04e:1145-1148 says 05b's results "show that the SCA:GCA ratio driving every design choice in this chapter falls as the pools diverge". The direction transfers; the quantity and the neutral-drift, dominance-only assumption do not. Use one name per statistic and state the assumption where 05b is invoked.

**04e-C11 (M) Owner: this. Comstock et al. (1949), 04e:156-158 (Owed, "PENDING").**
"@comstock1949 built reciprocal recurrent selection on them [the North Carolina layouts] -- the direct ancestor of the two-pool programme." The paper is unread; 05b:1036, 1072 and 04c:62, 1021 cite it for existence and title only and say so; 05:92 does likewise. Existence and title are confirmed (Crossref, it1-refs.md B6). The sentence attributes content (built on the NC layouts; ancestry). Reword to a report of what the title supports, or drop. @comstock1948 as the source of the NC layouts agrees with 00:104 and 05b:968.

**04e-C12 (M) Owner: this. The diversity claim of the closing section is unquantified and uses the wrong stage.**
04e:1135-1141: "the loss of gene diversity that @sec-stages tracks across the pipeline starts in the nursery plan, not at selection"; "a sparse factorial that crosses every candidate keeps the whole candidate set in contention". No GD, $\theta$ or $A_{ret}$ of a design is computed in the chapter (the chapter's only link to the book's subject), and nothing says which stage of @tbl-hp-stages it is: choosing 50 lines of 200 by CDmean is line selection (S3), which 08 already measures; 00:173-197 says testing in cross is not a stage. The identities the book uses for hybrids ($H_o = GD_T + GD_{BS}$ "over the full hybrid factorial", 90:89, and 03:176-178) hold for the complete factorial; for a sparse plan the diversity of the fielded hybrids depends on which cells are filled, which 04e does not state. Either compute one diversity metric per design (`theta_group()`/`fast_theta()` of the lines, `alleles_retained()`), or label the paragraph as a hypothesis.

**04e-C13 (M) Owner: this. Preface contract for identities (index:76-82; THREAD line 87, "keep true" for 04e).**
`mating-gca-identity` (04e:187-201) prints `max_abs_diff` and the prose says "machine precision" with no `stopifnot()` and no tolerance; `mating-estimable` (298-311) prints residuals the same way. The rank identity (280) does assert. (it1-audit.md R10.) The Monte Carlo comparison of fig-mating-testers gives the estimate with dispersion and the closed form: ok.

**04e-C14 (M) Owner: earlier, 03:423 (fix now) and 90. $n_A$, $n_B$.**
03:423 says its $n_A$, $n_B$ "count the lines of pool A and pool B, not the female and male lines of @sec-mating". In 04e:170-172 $n_A$, $n_B$ are the candidate lines of pool A and pool B and the pool-A line *is* the female; 90:557 says the female/male lines are "the $n_A$, $n_B$ of @sec-mating". The disclaimer in 03 distinguishes two things that 04e makes the same. 90's first table writes the same quantity $L_A$, $L_B$ (90:25-30) and has no row for $n_A$, $n_B$ except the 04c-local row (90:632) and the joint table's $n_F$, $n_M$ (90:552).

**04e-C15 (L) Owner: this. $c$ and $k$ in @tbl-mating-quantities.**
Row 3-4 are written for "$c$ crosses per line" (04e:216-218, 90:512-514), the tester sections and fig-mating-testers use $k$ (353-356, 366, 387, 1019), and 04e never says that for a tester design $c = k$. 05b:1798 and 04c:1136-1137 state the mapping ($c = k = t$) from their side; 90:462 and 90:545 note $k$ elsewhere but nothing notes that $\mathbf c$ in the selection table (90:289-291, 09, 10, 10b) is the contribution vector, so $c$ is used for two quantities in the book (only the $r$ clash is noted, 90:524). Also, per it1-audit.md R1, the closed form is exact only for a fixed tester set; 04c:1133-1139 and 05b:1789-1799 rely on it only in the tester case (c = k), so they stay valid whichever way R1 is resolved, but they should be rechecked if the table is rewritten.

**04e-C16 (L) Owner: this. Residue of the 08b-kernels Owed (settled otherwise).**
04e:729-733 now matches 08b:55-64 and 1239-1246 (one additive GBLUP over all hybrids, no pool split, trait with no SCA, @sec-hybrid-cv at 08b:467). Residue: 04e:1148-1150 "this chapter's estimates are those of @sec-mating-estimation" names the section that defines the model, while the genomic accuracies in @tbl-mating-gblup come from the cached external study (which did fit pool-specific and SCA kernels, 04e:735-740); the sentence should say whose estimates they are. The T0 values quoted in 08b:1195-1197 (0.10 to 0.15 against 0.91/0.85/0.77) agree with 04e:800-801, 857; if the T0 comparison at 857 is rewritten (it1-audit.md R12), 08b:1195-1200 needs a recheck (later/earlier Owed to 08b, conditional).

**04e-C17 (L) Owner: this. Carry-over: file attribution.**
04e:82-83 "its tables are in `book/data/mating_*.csv`" captures `mating_core_sweep.csv` (in-repo) and `mating_core_findings.csv` (literature extraction, read by no chapter); index:184-190 (and CLAUDE.md) say the opposite. Name the three external files (it1-audit.md R6a; 00 entry line 66).

## Checked, no finding

- T0 / T1 / T2 against CV0 / CV1 / CV2: 04e:742-745 (both T2, one T1, neither T0) = 90:411-414 = 08b:1195-1197 = 04f:415-417, which says CV1 of 04f is a T2 hybrid of 04e. 04e never uses CV labels. No edit owed; an optional pointer to 90:414 for the other CV meanings.
- 08b kernels sentences (04e:729-733): consistent with 08b, see C16.
- Published figures reused across chapters (0.91/0.85/0.77; 04e:746): same in 08b.
- Own arithmetic: 1,584 crosses = 4 x 400 - 16 (04e:556), 399 x 3 = 1,197 (1125), 2.5 to 7.5 % (97-99): correct. 04g:125 ($n_c = c\,n_F$) and 04f:186, 04g:165 (pool A = female) match 04e:171-172. 04g:881, 946, 958 (three-standard-error rule) match 04e:530, 1109-1110. 04f:1488-1492 matches 04e:1115-1119 on its result 2.
- Broken `@sec-` targets in 04e: none (all 20 distinct `@sec-` ids resolve: 04c, 03, 05b, 08, 08b, 09, 10, 10b, 11b, 04f, 04g, and its own labels; the `@tbl-`/`@fig-` ids are chunk labels).
- Redundancy: tester accuracy $\rho$ has three homes (04e table row 4, 05b @eq-het-rho-k, 04c @eq-alphasimr-accuracy); ownership is declared consistently (05b and 04c defer the general form to 04e, 04e:411 defers the finite-pool form to 05b); the layout-df table of 05b Step 6 is declared as the heterosis-side check only (05b:1750-1756). No action beyond C15.

## Owed items naming 04e (status after this iteration)

| Owed | Source | Status |
|---|---|---|
| 04e:176 "dominance deviation" | 05b entry | OPEN, C8 |
| 04e:35-37 "derived populations" | 03-C10 | OPEN, C3 |
| 04e:1149-1152 09's per-hybrid $c$ / crosses under a field limit | 09 entry | OPEN, C1 |
| $\sigma^2_g$, $\sigma^2_s$, $\sigma^2_{SCA}$ vs $\sigma^2_u$ (08b-C19) | 08b entry | OPEN, C9 |
| Comstock 1949 (04e:157) | 00, 05b entries | OPEN, C11 |
| T0/T1/T2 vs CV0/CV1/CV2 | 08b-C? / 90 | consistent, no edit |
| 08b kernels (04e:729-731, 1147) | 08b-C5 | SETTLED by the part-review edit; residue C16 |
| cross-reference @eq-hp-gca-sca (04e:164) | 00-C25 | OPEN, C6 |
| `mating_*.csv` wildcard (04e:82-83) | index/00 | OPEN, C17 |
| keep true: GCA of cross mean with $a_k$ and $d_k(1-2p_{Bk})$ (04e:168-190) and the rank rule | 05b entry | TRUE; C7 asks for one sentence on the symbol |
| keep true: 03 complete factorial assumption relaxed in @sec-mating | 03 entry | TRUE in substance, but see C3, C5 |

## Inbound `@sec-` citations of 04e labels (self-citations discarded; grep over `book/*.qmd`, one count per citation)

| Label | Inbound | From |
|---|---|---|
| `sec-mating` | 36 | 00 (1), 03 (2), 04c (1), 04f (9), 04g (12), 09 (1), 10b (1), 90 (3), 91 (1), 92 (3), index (2) |
| `sec-mating-estimation` | 4 | 00 (2), 05b (1), 90 (1) |
| `sec-mating-connectivity` | 5 | 04f (2), 04g (1), 05b (2) |
| `sec-mating-tester` | 6 | 00 (1), 04c (1), 05b (3), 92 (1) |
| `sec-mating-sparse` | 4 | 00 (1), 04f (2), 04g (1) |
| `sec-mating-genomic` | 5 | 04f (1), 04g (2), 08b (1), 90 (1) |
| `sec-mating-cost` | 2 | 04f (1), 04g (1) |
| `sec-mating-open` | 3 | 04f (2), 04g (1) |
| `sec-mating-reproduce` | 1 | 92 (1) |
| `sec-mating-connects` | 2 | 04g (2) |
| `sec-mating-binding`, `sec-mating-analysis`, `sec-mating-decision` | 0 each | cited inside 04e only |

Chapter total 68 inbound from 13 files; 04e has a job. Zero from 01, 02, 02b, 04, 04b, 05, 06, 07, 08, 10 and from the whole Evidence and practice part (04d, 11, 11b, 11c, 12): see C2. `sec-mating-analysis` (04e's own "largest effect", BLUP against least squares) is cited by neither 04f nor 04g, whose analyses assume it; `sec-mating-decision` is cited by none. Inbound promises to 04e that resolve: 00:101-102, 117-121; 03:178; 04c:1133-1137; 05b:1755-1759, 1798, 2143; 08b:1197; 90:217, 414, 524, 545, 557. The one that does not: 09:196-199 (C1).
