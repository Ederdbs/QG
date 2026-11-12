# 06-metric-catalogue -- continuity review, iteration 1 (chapter mode)

Chapter: `book/06-metric-catalogue.qmd` (Metrics and prediction, after `05-genomic-era`). Read: `CLAUDE.md`, `_quarto.yml`, `90-notation.qmd`, THREAD entries 00, 01, 02, 02b, 05b, 03, 04, 04b, 04c, 05 (every Owed line naming `06`), `part-foundations.md`, and the earlier chapters cited below. Numbers marked (re-run) were reproduced with `null_distribution()` / `discriminatory_power()` on `simulate_data(book_cfg)`. Nothing edited.

Result: 2 H, 11 M, 5 L. No broken `@sec-`/`@eq-`/`@tbl-` target in 06. Every forward promise 06 makes is kept (section 4).

## 1. Findings

### H

**06-C1 (H) -- "every one operates on the molecular coancestry matrix": false for half the chapter. Change: 06.**
- `06:12-14` "every one operates on the molecular coancestry matrix from @sec-coancestry"; title `06:1` "metrics on `f`".
- Against: `06:199` ("A metric independent of f"), `06:101-107` (`theta_from_freq()`, `he_nei()` read frequencies), `06:229-238` (`alleles_lost` is a marker/MAF count), `06:631` (F_hom, F_drift in the z table, defined in 05), and `00:463-465`, `01:513-531` (frequency-based metrics "never read `ctx[["f"]]`").
- What is true is the common signature `f(idx, ctx) -> scalar`, which the sentence also states. This is the 01-C7 Owed, still open verbatim.

**06-C2 (H) -- GD is presented as the heterozygosity of the product ("next season's hybrid vigour"); 00 and 05 show it is not. Change: 06.**
- `06:190-195`: "GD and N_s answer 'how much heterozygosity does this selection preserve', the right question for next season's hybrid vigour."
- `00:440-447` and `00:408-411`: H_e of the merged set (= GD_T) and the observed hybrid heterozygosity differ, H_o = GD_T + GD_BS; `05:345-356`: truncation has the lowest GD (z = -17) yet hybrids MORE heterozygous than random subsets (realised F1 heterozygosity z = +2.5), and the 05 checklist (`05:2155`) says F_hom is merged-pool gene diversity and "not F1 heterozygosity".
- 06's own table agrees with 05: `GD_WI_hyb` 0.1814 (random) -> 0.1823 (truncation) while GD_T falls 0.3259 -> 0.3124 (`tbl-catalogue-gd-partition`).
- `06:119-120` ("5 % of the set's expected heterozygosity") is correct as written; the error is only the sentence at 190-195 and its "hybrid vigour" gloss. 05's resolution (expected merged-pool H_e vs realised F1 heterozygosity) should be what 06 says.

### M

**06-C3 (M) -- opening does not say why 06 follows 05. Change: 06.**
- `06:12-19` names only @sec-coancestry and @sec-choosing. 05 is cited only mid-chapter (`06:190`, `260`, `631`, `641`). 05 ends with a checklist and no hand-over; its only promise is `05:309` ("@sec-catalogue-null reads every metric against it, a chapter that comes after this one").
- Missing: what 05 left (two lenses, `F_hom`/`F_drift`, the resampled null used before its home) and what 06 adds (the catalogue and the baseline definition). The promise itself is kept (`06:624-649`).

**06-C4 (M) -- same example, same seed, two z-scores for truncation. Number: 06 vs 05. Change: 06 (caption/B), or 05.**
- 06 (`tbl-catalogue-z`, `06:631`, and prose `06:638-641`): GD -18.0, F_drift 36.0 (text prints "36" and "-18"). `null_distribution(ctx, 60, B = 400, B_full = 1000)`, caption "B_full = 1000, seed 7".
- 05 (`tbl-era-signature-z`, frozen: GD -17.06, F_drift 35.08, F_hom 9.41; `05:318` `B = 2000, B_full = 1000, seed = 7`).
- (re-run) B = 400 gives -18.01 / 9.45 / 35.97; B = 2000 gives -17.06 / 9.41 / 35.08. The null's full draws depend on B because `cheap` consumes the stream first. Both captions say "seed 7, 1000 subsets" and neither gives B, so a reader sees two numbers for one quantity. The ~1 z-unit gap is the Monte Carlo error `06:646-648` says "this chapter does not report".
- Same cause, smaller: gd_ref 0.32584 (06, B = 400) vs 0.32586 (05, B = 2000), alpha(truncation) 4.122 % vs 4.129 % (re-run).

**06-C5 (M) -- the rise of GD_BS under truncation: 06 says the cause is "not isolated"; 05 already derives and explains it. Change: 06 (cross-reference; reconcile mechanism).**
- `06:399-418`: "The rise is measured; its cause is not isolated here"; offers sampling variance of usage-weighted frequencies entering y_k^2 and says the comparison that would separate it "is not evaluated in this chapter".
- `05:1766-1790` and `05:358-359`: GD_BS = f~ - f-bar with f~ = (theta_A+theta_B)/2, f-bar = (theta_A+2theta_AB+theta_B)/4, so concentrating usage in one pool raises f~ about twice as fast as f-bar at fixed f^L; "Read as divergence, that looks like a gain in heterosis potential. It is not."
- 06's own numbers confirm the algebra: GD_BS = (theta_A+theta_B-2theta_AB)/4 gives (1.4800-1.2704)/4 - (1.4228-1.2734)/4 = 0.0151 = 0.0524 - 0.0374.
- Two accounts of one result, with different mechanisms, neither citing the other. Also `06:361-366` ("diversity between pools is the engine of heterosis and cannot be spent") followed by "GD_BS rises under truncation" invites the reading 05 rules out; 05b's conditions (flat d, inbred parents, complete factorial) are only partly carried (`06:363-366` qualifies by alignment with dominance, not by the factorial condition). 06's data have no dominance at all (`06:405-407`, `03:174`, `03:363`).
- Settles the 05b Owed item "slogan without conditions" only partly.

**06-C6 (M) -- `hybrid_het` collides with 05's realised F1 heterozygosity; the identity's conditions are not stated. Change: 06.**
- `tbl-catalogue-het-identity` (`06:503-514`): column `hybrid_het` = 1 - theta_AB = H_S + 2D_G, usage-weighted, i.e. the expectation for a random re-pairing of the selected lines. Truncation row 0.364821.
- 05 (`tbl-era-hom-two-levels-het`, `05:327-333`): `F1_het` = realised heterozygosity of the 60 chosen pairs = 2 GD_WI_hyb (0.3646); `GD_T_plus_BS` = 0.3648 (= 06's `hybrid_het`); the two differ by up to 0.0043 across selections. 06 names the line-usage quantity `hybrid_het`, and 06's own `GD_WI_hyb` x 2 = 0.3646.
- `06:467-474` says "expected heterozygosity of the A x B crosses" with "equal weight" but not "complete factorial of the selected lines at their usage weights", the condition 00:446-447, 05:327-333 and 05b state.
- Redundancy attached: the identity 1 - theta_AB = GD_T + GD_BS (@eq-het-theta-ab) is checked three times: 05b `tbl-het-theta-ab` (full factorial), 05 `tbl-era-hom-two-levels-het` (selections), 06 `tbl-catalogue-het-identity` (selections). 05b owns the identity; 06 adds only the H_S + 2D_G form.

**06-C7 (M) -- one quantity, two symbols (00-C28, still open). Change: 06.**
- `06:568` @eq-catalogue-alpha uses GD_random(n); `06:570-572` then says "Here GD_ref is ..." and that the two and the printed `GD_reference` and the code's `gd_ref` "are the same quantity".
- `00:315-316` defines alpha with GD_ref; `90:~292` (alpha row) uses GD_ref; `90:285,295` lists GD_random(n) as a separate row "the same quantity as GD_ref". Reconciling by assertion is documentation, not one symbol. alpha is therefore defined in two places (00:315, 06:568) with different denominators' symbols.

**06-C8 (M) -- @eq-catalogue-gd-he restates @eq-hp-gd without citing it (00-C25, still open). Change: 06.**
- `06:92-94` writes GD_S = 1 - theta_S = m^-1 sum 2 p q = H_e as a new labelled equation. `00:392-395` already states it as @eq-hp-gd and says `00:399` "@sec-identity derives the identity"; `02:78` cites "@eq-hp-gd, derived in @sec-identity"; `04:1070` likewise. 06 never cites @eq-hp-gd (grep). Derivation is 06's to own; the result should be labelled as @eq-hp-gd.
- The derivation `06:82-90` also uses f_ij = m^-1 sum [x x + (1-x)(1-x)] without citing @eq-f-molecular (01), so the step from @eq-catalogue-theta to the x-products is unreferenced (L within this finding).

**06-C9 (M) -- "Molecular f has no base" against 01 and 00 (01-C7, still open). Change: 06.**
- `06:151-154`: "N_s reads as a head count only on coancestry measured against a base ... Molecular f has no base."
- `01:235-256`: "No centering ... This is not the same as having no reference"; E[f_ij] = A/2 + (1 - A/2) x base-population floor (>= 1/2) (@eq-hp-ibs-ibd, `00:465-475`). The conclusion 06 draws (theta_S, N_s in [1/2, 1]) agrees with `01:112-114` and `01:117`; only the premise sentence conflicts (f has a base-frequency floor; what it lacks is a base at which unrelated individuals have coancestry 0).

**06-C10 (M) -- "dominance deviation(s)" for d_k (05b, 05 Owed). Change: 06.**
- `06:364` "weighted by dominance deviations", `06:479` "With dominance deviations d_k". Name in 05b, 01, 90: "dominance effect" (`90` grep for "dominance deviation" is empty). Other residue still open: 04e:176, 08b:135/767, 12:262.

**06-C11 (M) -- "production scale of `sim_config`" (00-C22 / 05-R11, still open). Change: 06.**
- `06:620-621` "The value at the production scale of `sim_config`". `05:150-156` (A8) reserves 71 + 71 / 25000 for the package's production and says "several chapters also call" the `sim_config` default (50 + 50, 5000) production scale, and where a result is scale-dependent "it says so"; `R/00_data.R:9` calls the `sim_config` default the development configuration. 06 should name the scale it means (lines, markers).

**06-C12 (M) -- bare TeX scientific value at `06:395` still renders broken (00 Owed). Change: 06.**
- `06:395` `` `r signif(max(abs(gdp[, "GD_WI"])), 2)` ``; frozen output `06render` line: `6.7\times 10^{-16}` as bare TeX, the pattern `_common.R:44-47` says Pandoc garbles. `fmt_sci()` exists (`_common.R:48`). `06:112` and `06:355` use `signif()` too; 112 prints "0" here and 355 prints 0.017, not small, so only 395 breaks.

**06-C13 (M) -- 10b cites a "rule" of @sec-catalogue that 06 does not state. Change: 10b.**
- `10b:1245` "@sec-catalogue's rule applies: one diversity lens, chosen deliberately, reported against a null." 06's text argues the opposite emphasis: report all metrics against the null (`06:626-627`), `A_T` not `H_T` as the target for multi-cycle programmes (`06:266-270`), "a constraint on GD alone would not flag it" (`06:645`). The "report against a null" half is 06's; the "one lens" half is 05's (the constraint pins one lens). Later chapter should cite the right one.

### L

**06-C14 (L) -- two names for the within-subpopulation gene diversity; sum/mean scale shift. Change: 06 (and 90).**
- `06:443-450`, `469`, `498`: H_S (Nei); `06:498` sets H_S = GD_T - GD_BS. Same quantity as GD_WS = GD_WI + GD_BI (`02:434`, `02b:475`, `03:320`, `90:110`). `90:234` lists H_T, H_S, D_G but never GD_WS; 06 does not say H_S = GD_WS.
- `06:477-484`: "Summed over loci ... expected heterosis is 2(D_G + H_S/2)" (H_S, D_G are sums there) vs `06:498-500` (H_T = GD_T etc., means over loci, 1/m). The identity is true up to the factor m but the same symbols mean both.
- Partial redundancy with 05b-C13: `06:467-474` re-derives the per-locus identity p_A + p_B - 2 p_A p_B = H_T + D_G that is @eq-het-split (`05b:273`); only the H_S + 2D_G form and the lambda link are new. 06 now cites @eq-het-split (3x) and @eq-het-theta-ab, so 05b-C13 is half-done.

**06-C15 (L) -- unlisted symbol and repo convention.** `$\theta_N$` (`06:524`, `06:533`) is not in `90`. `06:539` `ctx$f` against CLAUDE.md "use `ctx[["f"]]`, never `ctx$f`" (safe here because `ctx$f` exists; the rule is project-wide).

**06-C16 (L) -- near-verbatim duplicate with 09.** `06:620-622` "The correct procedure is to trace the frontier and choose its knee, which is @sec-combinatorial" repeats `09:202` "The correct procedure is to trace the frontier and choose its knee:", where the figure sits (`09:205`); 10 holds the recipe (`10:884-889`). Promise kept (see 4); 06 could point to @sec-ocs as well.

**06-C17 (L) -- inbound references.** `sec-richness` has 0 inbound and `sec-catalogue-null` 1 (05 only). 07 discusses `alleles_lost` as the non-redundant metric (`07:98`, `230-251`) without citing @sec-richness. Not a job problem for the chapter (see table).

**06-C18 (L) -- caption block repeated.** The 70-word description of the five selections is repeated verbatim in ten table captions (`06:47`, `216`, `244`, `298`, `340`, `378`, `387`, `434`, `505`, `594`, `631`). Not a cross-chapter issue; one definition plus a short caption would do.

## 2. Owed items naming 06: disposition

| Owed (source) | Status in current 06 | Disposition |
|---|---|---|
| 00: `06:395` bare scientific value | still bare TeX (06-C12) | fixed-here |
| 00-C28: GD_ref / GD_random(n) (`06:568-572`, `90:280-290`) | explained as same quantity, still two symbols (06-C7) | fixed-here (90 follows) |
| 00-C25: cross-reference @eq-hp-gd (`06:92-94`) | not cited (06-C8) | fixed-here |
| 00-C22 / 05-R11: "production scale" `06:620` | unchanged (06-C11) | fixed-here |
| 01-C7: `06:13-14` "every one operates on ... f" | unchanged (06-C1) | fixed-here |
| 01-C7: `06:154` "no base" | unchanged (06-C9) | fixed-here |
| 05b: `06:364`, `06:479` "dominance deviation(s)" | unchanged (06-C10) | fixed-here; 04e, 08b, 12 remain later-owed |
| 05b: slogan without conditions (`06:363-364`) | partly qualified (alignment), factorial/inbred conditions not carried (06-C5) | fixed-here |
| 05b-C13: re-derives @eq-het-split (`06:468-480`) | cites it, still re-derives per-locus identity and re-checks the identity (06-C6, 06-C14) | fixed-here |
| 05b: keep true @eq-catalogue-lambda-d | 05b:2121-2125 and `90:236` match 06:482-484 (lambda = 1/2 at flat d, lambda_d otherwise) | kept true, nothing to do |
| 03: keep @tbl-gd-baseline and 06's baseline gap true, 06 owns it | 06: GD_pop 0.3280928, GD_ref 0.3258386, loss 0.687 %; 03: 0.32809, 0.32586, 0.681 % (different draw, said in 03:707-709); the bias formula and its check are 06's (`06:521-553`) | kept true; 03's pointer is honoured. One residual: 06 does not point back to 03's table |
| 03: keep true `06:406` (index additive, @sec-simulating-crosses) | agrees with `03:174`, `03:363`, `03:473` | kept true |
| 04-M18: alpha < 0 should be displayed at @sec-baseline | `tbl-catalogue-alpha` shows -0.0003 (random) and -0.0135 (greedy_div); `06:598-599` | settled by 06 |
| 04: @sec-baseline is the finite-set bias with the same sampling factor (`04:210`) | factor (1/n - 1/N) in @eq-catalogue-bias | consistent |
| 02: GD_WI zero for inbred parents "(@sec-catalogue)" (`02:1035`); partition reported (`02:1081`) | `06:393-398`, assertion < 1e-12 | settled by 06 |
| 02b: "what the book adds is stated in @sec-baseline" (`02b:789`) | 06 states the random-subset reference and why (`06:516-590`) | settled |
| 05: @sec-catalogue-null reads every metric against the null (`05:309`) | `06:624-649` | settled |
| 01: N_s in [1/2, 1] (`01:117`), cited "(@sec-ns)" | `06:157` agrees | settled (premise sentence: 06-C9) |

Nothing is owed to 06 by a later chapter except what 06-C13 asks of 10b and the 04e/08b/12 naming residue.

## 3. Checks

1. Notation: `\theta_S`, `\bar f_d`, `\bar f_o`, `N_s`, `N_{e,par}`, `A_lost`, `\eta_{ij}`, `D_eff`, `\theta_A/B/AB`, `\lambda`, `\lambda_d`, `\omega` agree with `90`. Findings: 06-C7 (GD_ref / GD_random(n)), 06-C14 (H_S / GD_WS; sum vs mean), 06-C15 (`\theta_N`). `\bar p_k` is the group frequency in @eq-catalogue-gd-he and, at `06:470`, the merged-pool frequency "as in @eq-het-split": equal under equal pool weights, not said (no finding).
2. Names: `hybrid_het` (06-C6), "dominance deviation" (06-C10), "no base" (06-C9). Group coancestry is defined three times (00:535, 01:~105, 06:23-33) with the same meaning; no conflict.
3. Numbers: 06-C4. Consistent: 0.3617 not used; truncation theta_A 0.7581, theta_B 0.7219, GD_T 0.3124, GD_BS 0.0524, F_ST 0.1678, Ne_lines 4.49 / 11.84, Ne_parents 13.02, 1 - theta_AB 0.3648 all equal 05's `tbl-era-pools`, `tbl-era-pools-usage`; baseline gap equal to 03 up to the stated draw.
4. Redundancy: 06-C6 (identity checked three times, 05b owns), 06-C8, 06-C14 (@eq-het-split), 06-C16 (09). The baseline bias (`06:521-553`) is also stated in `00:270-285` as a forward statement that points to @sec-baseline; 06 owns it, no change needed.
6. Transitions and promises: 06-C3. Promises made by 06 (all kept): `06:15` @sec-choosing benchmarks the metrics (07 Finding 3); `06:143` @sec-collapse makes the matrix route cheaper (`07:38`); `06:227` N_e,par enters the objective in @sec-choosing (`07:22-23`, table: "Second constraint"); `06:248-252` alleles_lost "genuinely non-redundant", the redundancy analysis excludes F_drift/F_hom (`07` grep: only theta, Ne_par, alleles_lost, no F_*); `06:366` @sec-cycles demonstrates the within-pool half (`11b:411`, GD within pools falls while GD_BS rises); `06:621-622` frontier and knee (`09:202`, `10:884-889`); `06:361-363` @sec-heterosis derives the first half (`05b` @eq-het-theta-ab; with conditions, 06-C5).
8. Assumptions: 06-C2 (merged-pool H_e used as the hybrids' heterozygosity), 06-C6 (complete factorial of selected lines unstated), 06-C5 (flat d, complete factorial for the "engine" reading; no dominance in the data). `GD_WI = 0` stated under inbred parents (A2) at `06:396-398`; the additive index is stated at `06:405-407`.

## 4. Inbound `@sec-` references to 06 (self-citations discarded; grep over `book/*.qmd`)

| Anchor in 06 | Inbound | From |
|---|---|---|
| `sec-catalogue` | 22 | 00:747; 02:1035, 1081; 02b:907; 05:1691, 1703; 05b:28, 136, 353, 2121, 2149; 07:11; 10b:1245; 11b:411; 12:266; 90:88, 234, 241; 91:61 (x2); 92:236; index:95 |
| `sec-baseline` | 18 | 00:279, 317; 02b:789, 874; 03:704, 707; 04:210, 1152; 04b:1187; 04c:2224; 04d:369; 05:309, 1705; 10:54; 10b:138; 12:58; index:40, 111 |
| `sec-ns` | 7 | 00:704; 01:117; 04:1164; 10:130; 11b:258; 12:184; 90:638 |
| `sec-identity` | 4 | 00:399; 02:78; 04:1071; 04g:602 |
| `sec-catalogue-null` | 1 | 05:309 |
| `sec-richness` | 0 | -- |
| `eq-catalogue-lambda-d` | 2 | 05b:2124; 90:236 |
| `eq-catalogue-alpha` | 2 | 02:12; 90:295 |
| `eq-catalogue-ene-ane` | 2 | 90:90, 91 |
| `eq-catalogue-lambda` | 1 | 90:235 |
| `eq-catalogue-alleles-lost` | 1 | 90:92 |
| `eq-catalogue-deff` | 1 | 90:93 |
| other `eq-/tbl-catalogue-*` (theta, split, gd-he, ns, ne-par, theta-pools, het-hs-dg, bias, all tables) | 0 | -- |

Per citing chapter (all 06 anchors together): 90 x11, 05b x6, 00 x5, 05 x5, 02 x4, 04 x4, 02b x3, 12 x3, index x3, 10b x2, 11b x2, 91 x2, 10 x2, 03 x2, and one each from 01, 04b, 04c, 04d, 04g, 07, 92. Body chapters (excluding 90, 91, 92, index): 14 chapters cite 06; sec-catalogue and sec-baseline carry it. `sec-identity` is cited from 00, 02, 04, 04g and not from 07 or 08b, which use theta_from_freq; `sec-richness` and `sec-catalogue-null` have 0 and 1 readers (06-C17).

Outbound from 06 (non-self, resolved, none broken): `sec-choosing` x5, `sec-genomic-era` x4, `sec-subdivided` x4, `eq-het-split` x3, `sec-heterosis` x2, and once each `sec-coancestry`, `sec-collapse`, `sec-cycles`, `sec-simulating-crosses`, `eq-het-theta-ab`, `sec-combinatorial`. 06 cites neither @eq-hp-gd (06-C8), @sec-era-step6/@tbl-era-pools (06-C5), nor @sec-era-programme.
