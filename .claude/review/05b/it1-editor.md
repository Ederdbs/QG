# 05b editor pass, iteration 1 (book/05b-heterosis-dominance.qmd)

Not rendered. Chunk option YAML for all 15 captioned chunks parsed with `yaml::yaml.load`; `knitr::purl` runs; every `@eq-/@fig-/@tbl-` resolves to a label in the chapter. `make_downloads.R` re-run (only 05b's script changed). No chunk code was touched beyond `#|` lines.

## 1. Edits applied

### Figures (checklist 1)
- All three figure captions now say what is plotted, the units (per locus at d_k = 1; sums in units of d; variances in squared units of d), the scale (25 + 25 inbred lines, 2000 markers), the seeds, that there is one draw per point with no replication, and what each line, bar or label is. The author's interpretive sentences are kept verbatim.
- fig-heterosis-sweep: "Dashed lines are the Balding-Nichols predictions" was wrong, because the grey dashed line is the mean total. It now reads "Coloured dashed lines ... ; the grey dashed line is the mean total over the sweep".
- fig-heterosis-alignment (`!expr` caption): `F_ST` and `d` are now set as math, and the caption describes the stacked bars and the relative-total labels. A `: ` inside the unquoted `!expr` scalar would have broken the YAML, so the wording avoids it.
- All three `fig-alt` texts were rewritten. They now describe the chart instead of repeating the first words of the caption.
- Each figure is now cited before it appears: @fig-heterosis-sweep (:547), @fig-heterosis-alignment (:667), @fig-heterosis-relocation (:1027).

### Tables (checklist 2)
- Twelve result chunks printed a bare `fmt()` data frame, which made them unnumbered tables (`df-print: kable`). They are now labelled and captioned: tbl-het-partition-identity, tbl-het-sweep, tbl-het-sweep-bn, tbl-het-alignment, tbl-het-alignment-stratified, tbl-het-s1-panel, tbl-het-var-components, tbl-het-relocation, tbl-het-step4-usage, tbl-het-step6-layout, tbl-het-step6-testers, tbl-het-step7-recycled. The last four replace the existing chunk labels `het-step4-usage`, `het-step6-layout`, `het-step6-testers` and `het-step7-recycled`. None of those chunks produces a figure.
- Each table is cited in the sentence that introduces it.
- Positional references were replaced. "the table above", "the scenario table of @sec-...", "the columns above", "the two columns above", "in the table", "the table averages", "every entry in the table" and "all three columns of the table" now point to @tbl-....

### Equations (checklist 3)
- 21 displays are labelled `{#eq-het-...}`: mean-one-locus, genotypic-value, value, expected, split, theta-ab, wi-hyb, id, distance, bn-total, bn-halves, alignment, expansion, gca-sca, gca-sca-terms, sca-dc, var-components, var-bn, gca-peak, sca-gca-ratio, rho-k. No collisions anywhere in the book.
- These positional references now cite the equation: "that display" (:99), "The formula above" (:387), "the identity above" (:462), "the mid-parent derivation above" (:870, and :1106), "the two closed forms above" (:1088), "the closed forms" (:943, :962), "the closed form first exceeds" (:1580), "the two-term identity of @sec-heterosis-alignment" (:1687, :1718).
- $\mathrm{MRD}_{ab}$ was used undefined. A definition sentence now follows @eq-het-distance ("modified Rogers distance").
- "Falconer & Mackay's heterosis ... [@falconer1996, Ch. 14]" is rephrased without the hand-typed author names, and it now cites @eq-het-split.

### Callouts (checklist 4)
- :390 "Inbreeding depression is not the current-cycle price of the diversity budget" changed from important to **warning**. It is the trap that would price alpha as a yield loss.
- :1701 "The diversity constraint stays additive" changed from warning to **important**. It states a design decision of the book.
- No `callout-caution`, and no footnotes.

### Text (checklist 5)
- Acronyms are now defined at first use: GCA and SCA (:33), DH (:55), $ID$ (:338).
- "the Caballero & Toro partition" (:220) is now "the partition of @caballero2002".
- Added [@balding1995] at the first use of Balding-Nichols (:475).
- Positional section references are now @-references: "the next section says" (:818) points to a new anchor `{#sec-heterosis-gca-average}` on "GCA is an average effect in the other pool's background". "the previous section's point" now cites @sec-heterosis-alignment. "The sweep above" and "the `fst` sweep below" now cite @sec-heterosis-flat. "the sweep below straddles" now cites @tbl-het-relocation.
- Percent signs are separated from their numbers by a space at 14 places (`r ...` % and "1 %").
- Headings were already in sentence case.

## 2. Findings passed on

- **05b-E1** `book/05b-heterosis-dominance.qmd:562-571, 687-691, 1053-1059`: the pool palette is used for series that are not pools. In fig-heterosis-sweep the total is pool-B amber and the shared term is pool-A blue. fig-heterosis-alignment draws shared in pool-A blue. fig-heterosis-relocation draws "GCA (both pools)" in pool-B amber. All three hard-code hex values instead of using `book_pal`. A reader of the rest of the book reads blue/amber as pool A/pool B. Suggested fix: `book_pal["ink"]`/`["mid"]` for the totals and the shared term, and `book_pal["loss"]` only where red means loss. That is a code change, so it goes to quant-Rwrite. The fig-caps name the current colours and must be updated with it.
- **05b-E2** `:569-571`: the fig-heterosis-sweep legend shows "predicted" as a grey dashed line. The predicted curves are drawn blue and red dashed, and the grey dashed line (mean total, `abline` :568) has no legend entry. The legend misdescribes the plot. This is a code change.
- **05b-E3** `:563, :689, :1055-1056`: axis labels lack units or use code names. "target fst between pools" is the Balding-Nichols parameter, $F_{BN}$ in @sec-notation. "expected heterosis" in the alignment bars needs "(units of d, summed over loci)". "variance of heterosis over the factorial" needs "(units of d^2)". `tbl-het-step7-recycled` headers `GCA_A/GCA_B/SCA` hold per-cent values with no unit in the header (`dimnames`, :1650). All of these are code changes.
- **05b-E4** `:616`: the callout-important "Every unit of divergence is paid for out of the shared term" states a result. It is not a design decision, and none of the four callout functions fits it. The writer should either make it a blockquote, like the key statements at :233 and :1114, or recast it as the warning it implies ("maximising F_ST buys nothing"). Book-wide, callout-important is also used for key results (08, 04e, 04f), so the taxonomy is not uniform outside this chapter either.
- **05b-E5** symbols used here but missing from `book/90-notation.qmd`: $\sigma^2_{GCA_A}$, $\sigma^2_{GCA_B}$ (90 has only $\sigma^2_{SCA}$, contrary to the verdict's note on D2), $\rho_k$ (90 has $\rho$ for 04e only), $F^\star_k$, $\mathrm{DC}(\cdot)$, $\mathrm{MRD}_{ab}$, $h_i$, $GD_{WI\text{-}hyb}$, $V_A$/$V_B$ (sampling variance, :572), $M$, $G(\mathbf{x})$, $p_{A,w}$, $\mu$ (grand mean of the factorial), $\theta_A$/$\theta_B$, $\mathbf{w}_A$. Two clashes go with these. $a$ is the additive effect in @eq-het-mean-one-locus and @eq-het-genotypic-value, but a line index in @eq-het-distance ($H_{ab}$, "lines $a$ and $b$", :426). "S1" means the selfed generation at :57 and :1287 ("S1 parents", "S1, S2") and the stage-1 monitor at :44 and in the heading at :731. Suggest "S$_1$ (once-selfed)" or different line indices; that is the writer's call.
- **05b-E6** `:755` tbl-het-s1-panel prints columns of the same `sw` data frame that tbl-het-sweep (:491) already shows in full (fst, divergence, frac_opposite_fixed, mean_abs_delta_p, mean_sq_delta_p). It is a redundant table. Deleting it, or turning it into a pointer to @tbl-het-sweep, is the writer's decision.
- **05b-E7** `:1220` het-step1-noninbred: the step 1 result (closed form, simulated hybrid, simulated gain, s.d., overstatement factor) is reported as a printed named vector, which is console output standing in for a result table. A labelled table needs a `data.frame` in the code, so it goes to quant-Rwrite or the writer. The other named-vector chunks are checks, not results, and are left as they are.
- **05b-E8** 10 labelled equations are not yet cited by number: eq-het-genotypic-value, -expected, -theta-ab, -wi-hyb, -bn-total, -expansion, -gca-sca-terms, -sca-dc, -gca-peak, -sca-gca-ratio. They are labelled because they are central. Where the prose already refers to them by description (for example "the closed form" in step 3 and the expected-peak text), the writer may want @eq- references. This is optional.

## 3. Orphaned figure files

None. No figure label was added or renamed, and no unnamed chunk produces a figure. `book/_freeze/05b-heterosis-dominance/figure-{html,typst}/` and `docs/05b-heterosis-dominance_files/figure-html/` hold only the three `fig-heterosis-*` files, and all three are still referenced. Because the source changed, 05b will re-execute on the next render (both `html.json` and `typ.json`).
