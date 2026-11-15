# 04b-backcross-introgression -- continuity check, iteration 1

Chapter: `book/04b-backcross-introgression.qmd` (949 lines). Read in full, with `90-notation.qmd:383-421` (Backcrossing and Population sizing blocks), the THREAD entries 00, 01, 02, 02b, 05b, 03, 04, `part-foundations.md`, and 04 (`04:1-45`, `04:60-112`, `04:222-245`, `04:625-640`, `04:700-860`, `04:1060-1180`), 00 (`00:16-42`, `00:170-200`, `00:746`), 01/02 only for the kernel, `index.qmd:85-125`, `index.qmd:183-195`, `07`, `08`, `09`, `10`, `11b`, `04c`, `91`, `92` for what 04b points to or is pointed from. Nothing rendered; numbers checked against `book/data/mabc_*.csv` (IBD range 0.946-0.964, certified N 400, sizing 1610 / 99, all reproduce).

Result: 1 H, 9 M, 6 L. Every `@sec-` target of 04b resolves; every `@fig/@tbl/@eq` it uses is defined in it. The chapter follows 04 with a stated reason (04b:40-45), its numbers agree with where they are computed, and its provenance statements agree with `index.qmd:188-191` and `00` it3-verdict. The defects are: one assumption that changes inside the last section (H), two forward pointers that land on chapters that do not say what 04b says they say, three results/claims that 04 had qualified and 04b restates without the qualification, and a role in the programme (A1-A8, S1-S4) that 04 promised and 04b never states.

## Owed items naming 04b

| Source | Item | Disposition |
|---|---|---|
| 02b entry, Note (index) (THREAD:203) | the Preface has no `{#sec-preface}` label, 02b points to "item 3 of the Preface" in prose; "04b:874 uses the same form" | **fixed-here (nothing to change).** 04b:874 says "item 5 of the Preface's chain of argument"; `index.qmd:112-120` is item 5 and cites @sec-backcross. Form and number are right. The *content* of item 5 against what 04b measures is a new finding, 04b-C3. |
| 04 entry, Takes from / Assumes | 04:29-30 "(@sec-backcross treats introgression from a donor on its own terms)" | **kept in part, see 04b-C6.** 04b is the donor-introgression chapter, but it never says where it stands against A1-A8 or S1-S4. Not an Owed line, a promise from an approved chapter. |
| 03 / 05b / 01 / 02 / 02b / 00 entries | no other `Owed` line names 04b (grep of `04b`, `backcross`, `MABC`, `introgress`, `sec-backcross`, `sec-bc-` over THREAD.md: only THREAD:203 and the `run_mabc.R` item at THREAD:83, which is addressed to `92`, not to 04b) | nothing to settle |
| 92 item (THREAD:83) | "single place where the expensive computations live" false because of `run_mabc.R` | **earlier/later chapter (92).** 04b is already correct on this point (04b:47-54, 04b:729-749 agree with `index.qmd:188-191`). |

New items later-owed from this check: to `index` (04b-C3), `11b` (04b-C9), `90` (04b-C12, C13), and, optionally, `04` (04b-C15).

## Findings

**04b-C1 -- H -- 04b (and the claim it hands to `index`) -- the state/descent assumption changes inside the last section.**
04b:164-178 defines $s = 0.60$ as the fraction donor and elite share *by descent* (90:395 agrees; 90:620-622 separates IBS from IBD), with the donor "often from the same heterotic group", and every number in the chapter uses it. 04b:878-882 then builds the conversion-cost panel with "an unrelated line" donor that "matches the recurrent parent by state at about half the markers; donor-elite sharing is therefore already in the draw and is not added again through $s$". State-matching at 1/2 is the no-sharing baseline of two independent lines at allele frequency 1/2 (the 03 generator, 03:141-176), so the panel is the $s = 0$ case, not a case with the sharing already counted: under $s = 0.60$ the donor-specific fraction is $(1-s)D$ and the off-diagonal ratio would be about $2(1-s)D\,[1-(1-s)D] \approx 0.05$ at $D = 1/16$, not $2D(1-D) = 0.117$ (04b:918-920, the 0.117 is computed there). The statement "already in the draw" mixes the two readings of identity that 90:620 keeps apart. The 0.117 is the number `index.qmd:118` and 04b:874-877 present as the measurement behind "near-copies".
Change: 04b (state which $s$ the panel is, or compute it for the chapter's $s$; drop "already in the draw"). Check 8.

**04b-C2 -- M -- 04b:40-45 against 04:35-41 and 04:700-860 -- what 04 sized.**
04b says 04 "sized a segregating population for *diversity*: the objective was to sample as much of the cross as possible" and calls itself "the mirror image". 04 sizes four objectives (04:35-41: "it depends on what is sized *for*"): $D$, $\min(p, 1-p)$, SE($\hat p$) and the recovery of a P2 homozygote at $k$ loci (@eq-sizing-n95, @tbl-sizing-saturation). The last is the same kind of question as 04b's fixation section (a homozygote at $k$ unlinked loci), and 04b:861-866 then paraphrases 04's lesson as "not sizing for gene diversity, which saturates early", while in 04 the diversity metric saturates at $N$ 70-110 and recovery at $k = 5$ needs about 270 and $k \ge 8$ is not reached at 390. Change: 04b (state what 04 sized, including the recovery objective, and which of its objectives 04b's is). 04 is not reopened.

**04b-C3 -- M -- `index.qmd:116-118` against 04b:868-928 -- what the near-copy measurement shows.**
Preface item 5: "a set of near-copies cannot be rescued by any optimiser (@sec-backcross)". 04b measures that the gene diversity of eight BC3 conversions off one recurrent parent is 0.117 times that of eight unrelated lines (expectation, one draw), and says "the size of it is the argument". It does not run or bound an optimiser, and 04 (04:1151-1158) states the claim only conditionally ("no selection of lines restores an allele the panel does not carry") and notes a selection can have $\alpha < 0$ (@sec-baseline). Item 5 is the same over-reach as the item already owed to `index` for @sec-sizing (04-C6). Change: `index` (restate with the conditional scope) and/or 04b (say what is and is not shown). Owed -> `index`.

**04b-C4 -- M -- 04b:929-932 -- wrong target for the "per-line usage cap".**
"@sec-stages' per-line usage cap is the mechanism that already handles this". `08-pipeline-stages.qmd` has line-usage counts and `select_lines_constrained(theta_max =)` (08:277-314, Trap 5), a $\theta$ ceiling, not a cap on how often a line is used. The usage cap is `max_use` in @sec-choosing (07:446-448, 07:493-500), @sec-ocs (09:360-366, "the per-line usage cap that @sec-combinatorial enforces in the decoder") and @sec-combinatorial (10:79, 10:148, 10:254, 10:433). Change: 04b (re-point).

**04b-C5 -- M -- 04b:940-941 -- wrong target for "compute $\theta$ on markers rather than on pedigree".**
@sec-choosing makes no pedigree-against-marker recommendation (no occurrence of "pedigree" in 07; its recommendation box at 07:430-480 is about cost and metric choice; 07:169 and 07:440 say not to scan genotypes *per evaluation*, the opposite emphasis). The marker-against-pedigree argument is 00:461-469 / 00:519-520, 01:244-250 and 02:95. Change: 04b (re-point).

**04b-C6 -- M -- 04b:40-56 and whole chapter against 04:24-35, 00:16-42, 00:173-200 -- the chapter never says where it stands.**
04 promises that @sec-backcross treats donor introgression "on its own terms", outside A1-A8. 04b states none of A1-A8 and no stage of @tbl-hp-stages. Facts a reader needs and must reconstruct: the recurrent parent is inbred (A2, kept); markers are on a map with linkage (A5, "independent per locus", dropped in the main body) and are unlinked again in the last section (04b:880-886, restored); the donor is outside the pool (A3, "recycled only within its own pool"); conversion is not S1-S4. 04b:868-869 then says converted lines "re-enter the pool the rest of the book optimises over", where "pool" is the heterotic group in the settled vocabulary (03, 00, 05b: candidate set vs pool) and the re-entry is what A3 excludes for a donor-derived line. Change: 04b (one statement of which of A1-A8 hold, which are dropped, where conversion sits; replace "the pool"). Check 6, 8.

**04b-C7 -- M -- 04b:160-162, 04b:48, 04b:859-862 against 04:94-107, 04:225-228, 04:340-398 -- marker-resolution bias not imported.**
04b says Haldane is "exact for this chain precisely because Haldane is memoryless" and that the chapter and 04 share "the same map, the same Haldane meiosis". 04 measured that a per-interval switch counts a junction only as a change between adjacent markers, so two junctions in one interval cancel: deficit 4.2% (s.e. 0.19) at 2 cM, 2.2% at 1 cM, 20 of 20 negative. 04b uses 5 cM, 2.5 times 04's spacing, and its central quantities (drag, trimming with flanks at $\pm 5$ cM, 04b:129-131) are counted on that grid; 04b:778-796 discusses interference only. 04's own statement that the deficit is not removed by finer spacing and that the drag is "not measured" under interference (04:100-109) is not carried. "Same map" is true of `maize_chr_len` and the meiosis, not of the marker grid (2 cM there, 5 cM here). Change: 04b (a sentence in @sec-bc-assumptions pointing to @sec-sizing-verify, and "exact for the marker chain" in place of "exact").

**04b-C8 -- M -- 04b:571-643 and @tbl-bc-fixation against @eq-sizing-n95 (04:700-860) -- same derivation, no cross-reference.**
Both chapters derive "probability of a homozygote at $k$ unlinked loci" and size from it (04: at least one F4 line with $q = ((1-H)/2)^k$, $H = 0.125$, closed form with the Sedcole attribution, replicated 20 populations per $N$; 04b: at least $n_{keep} = 3$ BC3F2 plants or DH lines with $q = (1/4)^k$ or $(1/2)^k$, cumulative binomial). The parameters differ ($n_{keep}$, generation, $q$) so no number conflicts (04b 1610 / 99 reproduce from the CSV). 04b never mentions @eq-sizing-n95, and 04's measured result that the closed form understates what the simulated cross needs at $k = 5$ (185 against 270, distortion) is not mentioned for the BC3F2 binomial, which is checked only against a distortion-free simulation (`mabc_bcnf2.csv`, 04b:35, 04b:599-620). Owner of the derivation: 04 (@eq-sizing-n95). Change: 04b (cross-reference, say what differs; "no distortion" in the BC3F2 line, with 04b:808-809 already admitting distortion unmodelled).

**04b-C9 -- M -- `11b:344-346` against 04b -- what @sec-backcross performs.**
11b: "@sec-backcross is the machinery that performs [injection] -- introgression is how new material enters an elite pool without dragging the rest of the genome with it", for an experiment that replaces six of twenty-five lines per pool with founding-generation material (11b:348-). 04b models the transfer of $k \le 4$ target loci into one elite line, and its last section shows the product is a near-copy of the recurrent parent ($0.117$ of the diversity of unrelated lines): it adds $k$ loci, not a line. 11b:76-79 also says @sec-sizing is where "linkage is modelled properly" while 04b models it too. Change: 11b (judge in its own review). Owed -> `11b`.

**04b-C10 -- M -- 04b:926-928 -- "counted against the diversity budget of @sec-ocs".**
$\alpha$ is the shortfall of the selected set's $GD$ against the mean $GD$ of random subsets of the *same candidate set* ($GD_{\text{ref}}$, 90:282-290, 06 baseline). Conversions inside the candidate set lower $GD$ of the set and of the reference alike, so the budget does not charge their cost; what changes is the level of both. The sentence "because $\theta$ cannot distinguish eight conversions from one line entered eight times" is also overstated by the chapter's own table (8 copies of one line have $\theta = 1$, $GD = 0$; the conversions have $GD$ 0.117 of the unrelated panel). Change: 04b (say what the budget does and does not see; "nearly indistinguishable").

**04b-C11 -- L -- 04b:805-811 against 04:63-81 -- "rescaled before use, exactly as in @sec-sizing".**
04 gives no rescaling procedure: it says not to use IBM-expanded map lengths and explains that the "four-fold" expansion is baseline dependent, marked UNVERIFIED for @lee2002. Change: 04b (drop "exactly as", or say what 04 does say).

**04b-C12 -- L -- 04b:160, 04b:189 against 90:392-399 -- $d$ with two meanings; $P_{\text{same}}$ with no use.**
$d$ is "the interval length" (marker interval, 5 cM) at 04b:160 and the distance between two targets at 04b:189 ($L = d/100$); 90:394-399 follows both. All targets are on different chromosomes (04b:50, 04b:219), so $P_{\text{same}}$ and "the union of donor segments" (04b:180-190) apply to a case the chapter's runs do not contain; no reported number uses them. Change: 04b (one sentence), 90.

**04b-C13 -- L -- `90-notation.qmd:414-420` and 04b -- local-symbol note incomplete; $\theta$, $GD$ unsubscripted.**
The local note disclaims $s$, $D$, $N$/$n$, $L$, $\nu$, $k$ but not $q$ (per-plant probability; $q^*_k$, $q_{b,k}$ allele frequencies in 90:514-515), $d$ (dominance deviation $d_k$), $r$ (plots per cross, 90:427) or $P$ (90:343-348 gives the sizing $P$ a different meaning: probability of success, here required level). 04b:900-911 writes $\theta$ and $GD$ for a set of eight lines; 90:70 has $\theta_S$. Change: 90, with 04b following.

**04b-C14 -- L -- 04b:133-135 against 04b:245.** The figure annotation prints "~0.97" (`round(1 - (1-s) 0.5^4, 2)`) and the prose prints `r fmt(expected_ibd(3, .6), 3)` = 0.975. One value, two roundings. Change: 04b.

**04b-C15 -- L -- 04, closing (04:1160-1180) -- no pointer to 04b.** 04 closes with @sec-stages and @sec-limits only; 04:30 is its single mention of 04b. Optional, no claim depends on it; 04 is approved and is not reopened for this. Change: none required (04 optional).

## Checked, no finding

- Transition (check 6): 04b:40-45 says why it follows 04 (mirror image) with the correction of 04b-C2. The "ten maize chromosomes, `sum(maize_chr_len)` cM" is the same object as 04:63-65.
- Promises by 04b: @sec-bc-assumptions (04b:162, kept at 04b:773-826), @sec-bc-index (04b:251, 286, kept at 290), @sec-bc-running (04b:54, 853, kept at 645-749), item 5 of the Preface (04b:874; item exists, 04b-C3 for its content). All kept.
- Promises to 04b: `00:746` (placement under "candidate lines and pools generated ... segregating population"), `04:30` (see 04b-C6), `04c:2036` ("unlike MABC scans" cached: true), `91:63` (`R/08_mabc.R`: drag, index, sizing: true), `90:414`, `92:309`, `index:188-191` (three tables and both figures from the predecessor driver: matches 04b:739-749 and the it3-verdict of 00): kept. `11b:345` see 04b-C9; `index:118` see 04b-C3.
- Notation: $s$, $D$, $\text{IBD}_E$, $r$, $L$, $P_{\text{same}}$, $q$, $n$, $N$, $P$, $\nu$ agree with 90:392-421 and `R/08_mabc.R` (`expected_donor(gen) = 0.5^(gen+1)`, `expected_ibd`, `mabc_opt$target_ibd = 0.90`, `drag_per_gene = 30`, `P_crit = 0.95`, `n_keep_f2 = 3`). 04b's $k$ (target genes) and 04's $k$ (loci) are the same use, as 90:419-420 says. $D$ = donor dosage (04b) against diversity retained (04) is disclaimed at 90:416.
- Numbers: IBD at BC3, four genes, rec_drag: 0.946-0.964 (above the 0.90 target, 04b:254); certified $N$ = 400 (lo 0.978), next size 250 (lo 0.901); sizing 1610 BC3F2 against 99 DH at four genes (fig alt text 04b:626 agrees); conversion-cost ratio 0.117 in expectation. No chapter quotes a 04b number differently; 04b quotes none of 04's.
- Coding in the last section: lines coded 0/1 and `molecular_coancestry()` (`R/00_data.R:75`) gives the state-identity matrix (fraction of equal markers) for 0/1 lines; 00 (`GL <- simulate_lines()/2`) uses the same coding. $2D(1-D)$ as the expected ratio is correct for the model as built (04b-C1 concerns which model).
- Falque et al.: 04 (about 15% non-interfering) and 04b (gamma shape $4.2 < \nu < 6.2$ for the interfering pathway) say different parts of the same two-pathway model; no conflict (the $\nu$ range is checked in `it1-refs.md`, not here).
- Direction of the interference caveat: 04b ("every population size ... a lower bound") and 04 ("not measured") agree in direction; 04b does not claim a size.

## Inbound `@sec-` count (citations from other files only; self-citations discarded)

| Label (owner `04b-backcross-introgression.qmd`) | Inbound | Citing files |
|---|---|---|
| `sec-backcross` | 7 | `00:746`, `04:30`, `04c:2036`, `11b:345`, `91:63`, `90:414`, `index:118` |
| `sec-bc-running` | 2 | `index:191`, `92:309` |
| `sec-bc-index` | 0 | (04b only: 04b:251, 286, 434) |
| `sec-bc-assumptions` | 0 | (04b only: 04b:162) |
| **Chapter total** | **9 citations, 8 files** (00, 04, 04c, 11b, 90, 91, 92, index) | |

Outbound from 04b to other files: `@sec-sizing` 4 (04b:40, 810, 859, 863), `@sec-coancestry` 1, `@sec-ocs` 1, `@sec-stages` 1, `@sec-choosing` 1; no broken targets. The chapter has a job (cited by 8 files, mostly as the MABC/provenance pointer); only `index` and `11b` cite it for an argument, and both over-read it (04b-C3, 04b-C9). `04e`, `04f`, `04g`, `10`, `10b`, `12` cite it zero times.

## Disposition summary

- fixed-here (04b to change): C1 (H), C2, C4, C5, C6, C7, C8, C10 (M), C11, C12, C14 (L).
- earlier chapter: none to reopen (04, 00 approved); C15 optional on 04.
- later-owed: `index` (C3), `11b` (C9), `90` (C12, C13).
