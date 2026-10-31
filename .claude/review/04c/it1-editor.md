# 04c editor pass, iteration 1 (book/04c-alphasimr-pipeline.qmd)

Not rendered. All chunk-option YAML parsed with `yaml::yaml.load`. Every `@tbl-/@eq-/@fig-` reference resolves to a label in the chapter (sub-table references `-1`..`-5` included), and every label is cited before it appears. Equations are the exception: they are cited just after the display. `make_downloads.R` was re-run and only 04c's script changed; the purled script parses. Chunk code is untouched except the `#|` lines and the `fig_cap` caption string (:1726-1735). Quarto 1.10.18 was tested in scratch: `tbl-subcap` on a chunk with several `df-print: kable` outputs gives working subtables in both HTML and Typst. A `tbl-` labelled chunk that also prints console output places that output *above* the table float (see E6).

## 1. Edits applied

### Figures (1)
- fig-alphasimr-cycles: added `fig-alt`, which describes both panels and their four series. The `fig_cap` string now says what the bars are ("plus and minus one s.d. across draws"), the trait and units ("trait 1, trait units"), the definition of gene diversity ("1 - mean molecular coancestry") and the reproducibility caveat (founders from runMacs2()). The writer's per-pool sentence is kept verbatim.
- The figure is now cited before it appears: at :1583, "what @fig-alphasimr-cycles plots" replaces "what the next section plots". At :1906, "the figure above" is now @fig-alphasimr-cycles.

### Tables (2)
Every bare `fmt()` data frame or matrix was an unnumbered table. Each now has a label and a caption that stands alone (scale, seeds, number of draws, column meanings, units), and each is cited before the chunk:
tbl-alphasimr-engines, -ld, -varcomp, -lottery, -selfing, -breeders, -accuracy, -jensen, -index, -split (5 sub-tables: mean/s.d. of divergence, ascertainment, mean/s.d. of combining ability), -contrast, -cycle1, -rep1, -paired (2 sub-tables: paired contrasts, pooling check), -loss, -pipeline (2 sub-tables: cycle trajectory, stage-2 metrics).
Positional references were replaced: "the table above", "both tables here", "that table", "the row above it", "Read the first two tables together", "The third table", "those three tables", "The fourth and fifth tables ... the sixth", "the table shows", "this table" (twice), "The table is", "the tables", "`pool_tab` measures", "The loss table", "in the Monte Carlo chunk below the accuracy grid", "traced below".
Four one-sentence citations were added where a table directly followed a heading or a code-only lead-in. They are at :117, :201, :769 and :1531.

### Equations (3)
- Labelled: eq-alphasimr-gv (:322), -mhw, -hij, -hbar, -selfing, -gca, -accuracy. There are no collisions in the book.
- Positional and indirect references now cite the equation number: "It is the model of" -> "@eq-alphasimr-gv is the model of"; "under the model of Step 2" -> "of @eq-alphasimr-gv"; "the expression above keeps" -> "@eq-alphasimr-hbar keeps"; "the form above extends" -> "@eq-alphasimr-selfing extends"; "the F1 heterosis of Step 4" -> "of @eq-alphasimr-hij"; "Under the closed form above" -> "Under @eq-alphasimr-gca"; "The textbook form of this prediction" -> "of @eq-alphasimr-accuracy"; "only the first term" -> "only the first term of @eq-alphasimr-mhw".

### Callouts (4)
- The one callout (:171, warning "The founders are not seeded...") is a trap that produces a wrong number, so warning is the correct type. It has a title. The chapter has no footnotes.

### Text (5)
- Acronyms are now defined at first use: DH (:20, "inbred lines (doubled haploids, DH)"), LD (:115), MaCS (:113, "the MaCS program [@chen2009]"), QTL (:271), RIL (:625), MABC (:1964).
- Citation syntax:
  - `(@gaynor2021)`, `(@sprague1942)` x2, `(@chen2009)` and `(@smith1936; @hazel1943)` are now bracketed citations.
  - `(RRS;\n@comstock1949)` is now "(RRS) [@comstock1949]".
  - Three hand-typed author names were removed: "Comstock, Robinson and Harvey's ... (@comstock1949)" -> "The reciprocal recurrent selection of @comstock1949"; "Kempthorne and Nordskog's construction (@kempthorne1959)" -> "the construction of @kempthorne1959"; "the Caballero & Toro partition" -> "the partition of @caballero2002 (@sec-subdivided)".
  - "-- @michel2019." is now "[@michel2019]".
  - "@falconer1996, Ch. N" (x3) is now "@falconer1996 [ch. N]", the locator syntax.
- Units: "5%" -> "5 %" in four places of prose and inline strings (:1462, :1492 x2, :1802). The code comment at :1361 is untouched.
- Headings were already in sentence case.

## 2. Findings passed on

- **04c-E1** (writer / quant-Rwrite) Result tables are printed as named-vector console output and so cannot be numbered:
  - :354-357, realised vs requested dominance degree
  - :389-393, base-population mean, variances and realised h2
  - :437-440, varA / varA_LE / varA_LD
  - :505-508, inbred vs HW mean and inbreeding depression
  - :576, heterosis per cross
  - :602-606, factorial heterosis summary
  - :910-911, var_GCA_A / var_SCA / cor_perse_gv_vs_GCA, which is "the last number" the prose builds on
  - :1110-1113, realised correlations and h2
  - :1231-1236, founder-pool summary, which the prose cites at :1246 as "printed above"
  
  Each needs a `data.frame` in the code before it can take a `tbl-` label. The selInt and optim checks (:844, :1195) and `dim()` (:1900) are checks and can stay as they are.
- **04c-E2** (quant-Rwrite) fig-alphasimr-cycles :1746 hard-codes `cols <- c(A = "#1f5f8b", B = "#c0392b")`. Pool B is red, not the book's pool-B amber `#d98e04`, and red is `book_pal["loss"]`. Use `book_pal[c("A", "B")]`. The legend (:1765) labels the series "pool A, selected"/"pool B, selected" in *both* panels. In the left panel this contradicts the caption and the D3 fix (the two curves are A x B testcross levels, not per-pool responses). It should say something like "A lines on B testers"/"B lines on A testers" in the left panel. The left y-axis label "Mean testcross phenotype" (:1771) has no unit and should read "(trait units)".
- **04c-E3** (quant-Rwrite / layout) fig-alphasimr-cycles has `fig-width: 9`. Typst lays it into 6.5 in, so all text is scaled to about 72 %, and with `legend(cex = 0.75)` the legend comes out near 5 pt in the PDF. Use 6.5 x about 4 with a larger legend, or stack the panels vertically. This needs a render to judge, so it was not applied.
- **04c-E4** (writer) Tables likely too wide for the Typst A4 text block (6.5 in): tbl-alphasimr-lottery (9 columns), -breeders (9), -jensen (8 cells + max_abs + row names = 10), -rep1 (10), -split-3 (8). Candidates are transposing -jensen (cells as rows), splitting -lottery into parent/F1 and DH columns, and dropping the redundant `split` column already carried by row names in the -split sub-tables. These are splits and transpositions, so they go to the writer.
- **04c-E5** (writer) Symbols that clash with or are missing from `book/90-notation.qmd`:
  - $x_{ik}$: 0/1/2 dosage here, but 0/0.5/1 in 90 (the 0/1/2 matrix is $\mathbf M^H$).
  - $G_i$, $G_{ij}$: genetic value here, but $G_i$ is the Caballero-Toro statistic in 90; the F1 value $G_{ij}$ in @eq-alphasimr-hij is never defined in words.
  - $\mathrm{GCA}_i$, $\mathrm{SCA}_{ij}$: 90 uses $g^A_i$, $s_{ij}$.
  - $\alpha_k$, $\alpha^{(B)}_k$ (average effect): 90 reserves $\alpha$ for the diversity-loss constraint and has $\alpha_i$ for Caballero-Toro.
  - $\rho(t, r)$ with $t$ testers: 90 has $\rho$ with $k$ testers and $c$, $r$.
  - Not in 90 at all: $\mu_0$, $\delta_k$ (dominance degree), $M_{HW}$, $M_{F_t}$, $\bar H$ (90 has $H_i$), $v_g$, $v_s$, $v_e$, $n_A$/$n_B$ as pool sizes (only in the mating-design sense).
  - Step 7's prose writes $\mathbf G$, $\mathbf P$, $\mathbf a$, $\mathbf b$ as code (`b = P^-1 G a`), whereas 90 uses $\boldsymbol\Sigma_P$, $\boldsymbol\Sigma_G$; `G` here is also not the relationship matrix.
  
  Add the symbols to 90 or rename them; that is the writer's call.
- **04c-E6** (quant-Rwrite) In three labelled chunks a table is followed by console output: tbl-alphasimr-varcomp (named vector at :437-440), -accuracy (named vector at :1023-1024) and -pipeline (`dim()` at :1900). Quarto (verified in scratch) renders that console output *before* the table float, so in the book the vector appears above the table it follows in the code. Move the trailing outputs into their own chunk, or into E1's data frames.
- **04c-E7** (writer, optional) The prose cross-refers internally by "Step N" names (about 80 times). That is explicit, not positional, so it was left alone. Anchors such as `{#sec-alphasimr-step6}` on the eight Step headings would make the references clickable in both formats. Five other chapters cite this chapter only as @sec-alphasimr.

## 3. Orphaned figure files

None. The only figure label, fig-alphasimr-cycles, is unchanged. No unlabelled chunk produces a figure, and table labels write no image files. `docs/04c-alphasimr-pipeline_files/figure-html/fig-alphasimr-cycles-1.png` and `book/_freeze/04c-alphasimr-pipeline/figure-{html,typst}/fig-alphasimr-cycles-1.{png,svg}` stay referenced. The source changed, so 04c re-executes on the next render (both `html.json` and `typ.json`). That was already true after the writer and code passes.
