# 08b-genomic-prediction -- editor (form pass)

Source: `book/08b-genomic-prediction.qmd`. No chunk code changed; no number changed. Not rendered. `make_downloads.R` re-run (`book/downloads/08b-genomic-prediction.R` regenerated). No knitr scratch present (`book/figure`, `Rplots.pdf` absent).

## 1. Edits applied

### Prose / caption wording changes (for quant-advice to diff)
| # | location (after edit) | before | after |
|---|---|---|---|
| W1 (M12) | ~464 | "In the direction measured, the reliability is conservative." | "... the implied accuracy is conservative." |
| W2 (M13) | ~1007 | "i.e. no gap where the model is right, and BayesA's" | "i.e. a difference inside its standard error, and BayesA's" |
| W3 (M13) | ~1020 | "is the contrast the opening of this section names beforehand (the regime the point-mass prior exists for)" | "is the contrast the opening of this section singles out on general grounds (the regime the point-mass prior exists for), not a registered one" |
| W4 | ~59 | "no marker-QTL gap" | "no gap between markers and quantitative trait loci (QTL)" (QTL expanded at first use; the two later "marker-QTL gap"/"marker and QTL" left as is) |
| W5 | ~162 | "general combining ability, with no specific combining ability left over" | "general combining ability (GCA) ... specific combining ability (SCA)" |
| W6 | ~221 | "this book's reference for BLUP" | "... for best linear unbiased prediction, BLUP" |
| W7 | ~237 | "generalised-least-squares intercept" | "generalised-least-squares (GLS) intercept" |
| W8 | ~262 | "by REML" | "by restricted maximum likelihood (REML)" |
| W9 | ~391 | "the same day the GEBV is" | "the same day the genomic estimated breeding value (GEBV) is" |
| W10 | ~1157 | "the OCS penalty on coancestry" | "the optimal contribution selection (OCS) penalty on coancestry" |
| W11 | ~120 | "the marker effects $\mathbf{B}$ drawn independently" | "the marker effects `B` ..." (the bold B clashed with the parent-usage matrix $\mathbf{B}$ of the rank argument ~290 and of the notation appendix; `B` is the code object) |
| W12 | fig-genpred-selection caption | "changes from chain to chain (text)." | "(@sec-genpred-bayes)." |
| W13 | ~259, ~381, ~454, ~885, ~949, ~1158 | "(previous section)", "(above)", "as stated above", "the equations above", "the single draw of the previous section", "the mixed model equations above" | "(@sec-genpred-truth)", "(@sec-genpred-mme)", "as stated in @sec-genpred-mme", "the mixed model equations (@eq-genpred-mme)", "the single draw of @sec-genpred-bayes", "(@eq-genpred-mme)" |

### Figures / tables
- Forward citations added so every float is cited before it appears: `@tbl-genpred-rank` (~304), `@fig-genpred-selection` (~759, "plotted in"), `@tbl-genpred-paired` and `@fig-genpred-accuracy` (~955), `@tbl-genpred-pi` (~1048), `@tbl-genpred-daetwyler` (~594). Wording change is the parenthetical only.
- `tbl-genpred-daetwyler`: `col.names` added (`k`, `measured`, `se`, `formula, n = lines`, `formula, n = records`) in place of the code names `formula_lines`/`formula_records` (allowed: `col.names` of a table call).
- All six tables carry `tbl-` label + `tbl-cap`; both figures `fig-` label + `fig-cap` + `fig-alt`; all tables go through `fmt()` except the integer rank table (no decimals). `ctx[["f"]]` is used everywhere; no `ctx$f`.

### Equations
- Labelled (`$$ ... $$ {#eq-...}`) and cited: `eq-genpred-var-g` (Var g = G sigma_u^2, cited ~147), `eq-genpred-mme` (mixed model equations, cited ~885, ~1158), `eq-genpred-reliability` (cited ~393), `eq-genpred-identity` (GBLUP = marker-ridge identity, cited ~939). `eq-genpred-rank` already existed. The Gibbs prior displays (~695-701) and the BayesB lines are left unlabelled (not cited).
- New heading label `{#sec-genpred-mme}` on "Where the mixed model equations come from" (used by W13). Cannot orphan a figure.

### Callouts / headings / citations
- Two callouts: `callout-warning` ("Report which parents the training set had seen", a trap that gives a wrong figure: kept) and `callout-note` ("What this chapter still does not model", see 08b-E5). Both titled; no `callout-caution`. Headings are sentence case. Citations are all Quarto syntax. No footnotes.

## 2. Findings passed on

- **08b-E1** `08b:~806-812` (`fig-genpred-selection` chunk): y axes have `ylab = ""` (the panel title carries the quantity, no units/quantity on the axis) and x label is the bare word "marker". Needs chunk code (`ylab = "posterior inclusion probability"` / `"per-marker variance"`): quant-Rwrite/quant-writer. Typst: two panels in 6.5 in x 4 in, `mar = c(4,4,2,1)`; check the left axis label does not clip.
- **08b-E2** `08b:~977-987` (`fig-genpred-accuracy`): 12 boxes, grey shades GBLUP/BayesA/BayesB encoded only in the caption (no legend), and the 12 tick labels are `method.arch\nh2=..` strings at `cex.axis = 0.7`, `las = 2`: at 6.5 in width the labels are long and the default bottom margin will clip or overlap them. Flag for the Typst check; the fix (legend, shorter labels, `mar`) is chunk code. The y axis `accuracy (candidates)` is fine.
- **08b-E3** Raw R console output standing in for a table, with its figures quoted in the prose: chunks `genpred-seeds` (mean/sd matrix R40, ~445), `genpred-bayes-seeds` (min/median/max of the 8 chains, ~825), `genpred-paired-values` (t and p of the eight contrasts, ~999), `genpred-cpi` (mean/sd over 5 seeds, ~1105), `genpred-errstructure` (~1204). Converting any of them to a `tbl-` needs chunk code: for quant-writer to decide which of them are results (genpred-paired-values and genpred-bayes-seeds are the ones the argument leans on). The vector-returning check chunks (`genpred-generative`, `genpred-linear-identity`, `genpred-rank-train`, `genpred-handoff`, ...) are verification output and can stay.
- **08b-E4** Wide table for the Typst check: `tbl-genpred-paired` has 8 columns (`arch`, `h2`, `n`, `GBLUP`, `BayesA - GBLUP`, `se A`, `BayesB - GBLUP`, `se B`); its headers `BayesA - GBLUP` are long. Also `tbl-genpred-cv` (7 columns; first column holds the long scheme names). If either overflows the A4 text block, split or transpose (writer).
- **08b-E5** `08b:~1218` callout type: "What this chapter still does not model" is a list of limitations, which fits none of note (definition/clarification), warning (trap producing a wrong number), important (design decision), tip. Kept as `callout-note`; decision on the type for the book's limitation boxes belongs to the author/quant-writer (check what the other chapters use for the same function).
- **08b-E6** Symbols missing from `book/90-notation.qmd` (report, not edited): $\sigma^2_\beta$ (~124, 128), $\sigma^2_k$ (~696), $\lambda_\beta$ (~899), $\mu$/$\hat\mu$ intercept (~213), $\mathbf{V}$ (code only; text uses $\mathbf{G}^*_{tt} + \mathbf{I}\lambda$), $\mathbf{C}$ and $\mathbf{C}^{uu}$ appear only inside the PEV row. The other symbols ($\sigma^2_u$, $\sigma^2_e$, $\lambda$, $h^2$, $r_i^2$, PEV, $\pi$, $\nu$, $S$, $M_e$, $\mathbf{G}^*$, $\mathbf{W}$, $\mathbf{Z}$, $\mathbf{M}^H$) are there.
- **08b-E7** `08b:~13-17`, first paragraph cites `@tbl-hp-stages` and `@sec-hybrid-programme`: both resolve. The shipped `docs/`/`_freeze` text predates these edits; the chapter must be re-rendered by the caller (I did not render).
- **08b-E8** Numbers inline use the chapter's own `f3()`/`f4()`/`round()` helpers (sprintf), not `fmt()`; `fmt()` is a table helper, so I left them. If the style guide wants one formatter for inline too, that is a book-wide decision.

## 3. Orphaned figure files

None. No chunk label was added or renamed (existing labels `fig-genpred-selection`, `fig-genpred-accuracy` unchanged), so no PNG was renamed. `book/_freeze/08b-genomic-prediction/` is stale relative to the source (as the it3 verdict already noted) until the caller re-renders.
