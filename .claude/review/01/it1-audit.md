# 01-coancestry -- chapter audit, iteration 1

Scope: book/01-coancestry.qmd (244 lines), book/_common.R, R/00_data.R
(molecular_coancestry, vanraden_G, simulate_data, build_ctx), frozen outputs in
book/_freeze/01-coancestry/execute-results/html.json. Numbers re-derived with
pkgload::load_all at book_cfg (25+25 lines, m = 2000, seed = 1); scripts in the
session scratchpad (a01.R, a02.R). The frozen outputs are reproduced exactly
(X[1:4,1:8], sum_G = -4.178879e-11, f min/max/diag/offdiag = 0.6448/0.8318/0.8192/0.6717).

## Findings

| ID | Severity | file:line | Problem | Evidence |
|---|---|---|---|---|
| 01-R1 | high | book/01-coancestry.qmd:101-103 | "In a *subset* the sum is not zero, but ... it oscillates around zero, takes negative values". False: G = ZZ'/k is PSD, so for any subset S, 1_S' G 1_S = ‖Z'1_S‖²/k >= 0 -- a subset sum can never be negative. Its expectation for a random subset of size n is n * mean(diag G) * (N-n)/(N-1) > 0, so it is biased upward and depends on n/N, not centred at zero. What *is* true: individual off-diagonal elements are negative (88.3% of them; min G = -0.139) and the subset value has no absolute scale (depends on n relative to N). | 2000 random subsets each at n = 10, 100, 400, 600, 620 of N = 625: fraction with negative sum = 0 at every n; min sums 5.2, 37.2, 49.4, 11.4, 3.4; expected values 8.8, 75.5, 129.5, 21.6, 4.5 (a02.R). |
| 01-R2 | high | book/01-coancestry.qmd:170-173 | "The excess above 0.5 measures exactly the fraction of markers at which the two parent lines carry the same allele". Off by a factor 2: f_ii = 0.5 + h_i/2 with h_i the homozygous fraction, so the excess is h_i/2. The chunk at :176-179 computes it correctly (molecular_F = 2*fd - 1 = 0.6383), contradicting the sentence immediately above it (excess = 0.3192). | all.equal(diag(f), 0.5 + rowMeans(X != 0.5)/2) is TRUE; mean excess 0.3192 vs mean homozygous fraction 0.6383 (a01.R). |
| 01-R3 | medium | book/01-coancestry.qmd:203-209 | "G_0.5 ... is proportional to homozygosity-based inbreeding and molecular coancestry. Structurally that is f". It is affine, not proportional: with p_k = 0.5, G_0.5 = (M-1)(M-1)'/(m/2) = 4f - 2J. The ranking/optimisation equivalence holds only because c'Jc = 1 under sum(c) = 1; the prose should state the affine map (and the chunk should assert it). | all.equal(tcrossprod(2*X - 1) / (m/2), 4*f - 2) is TRUE (a01.R). |
| 01-R4 | medium | book/01-coancestry.qmd (whole chapter) | Check 3: no stopifnot() anywhere. Identities asserted in prose and unchecked in a chunk: sum(G) == 0 (:90, :100 "It is exact"); f in [0,1] (:131, :166); the computable form equals the double sum (:139-153); f_ii = (1 + F_i)/2 (:133, used at :178); G_0.5 = 4f - 2J (:203-209, see 01-R3). All hold numerically: abs(sum(G)) = 4.2e-11; min/max f = 0.645/0.832; all.equal(f, tcrossprod(cbind(X, 1-X))/m) TRUE; literal double-sum oracle on 5x5 TRUE; diag identity TRUE. | a01.R. |
| 01-R5 | low | book/01-coancestry.qmd:94-100, :223 | Prose says "exactly 0" / "It is exact" next to printed output sum_G = -4.18e-11 and Ns_on_G = -9.35e15 (negative). Exact in exact arithmetic, floating residue in output; the negative sign of Ns is noise. Needs one sentence plus a tolerance assertion (e.g. abs(sum(G)) < 1e-8 * N^2), otherwise the reader sees a contradiction. | html.json output line "sum_G -4.178879e-11 ... Ns_on_G -9.348769e+15". |
| 01-R6 | low | book/01-coancestry.qmd:232-234 | "The test suite asserts `sum(G) == 0`". It asserts a tolerance, not equality. | tests/testthat/test-metrics.R:22 `expect_lt(abs(sum(ctx$G)), 1e-6 * ctx$N^2)`. |
| 01-R7 | low | book/01-coancestry.qmd:139-153 | Complexity framing: "The double sum is O(n^2 m) if computed naively. Expanding ..." implies the expansion lowers the order; tcrossprod is also O(n^2 m). The gain is BLAS constant, not order. "the same cost as building G" is correct; the lead-in is not. | Algebra. |
| 01-R8 | low | book/01-coancestry.qmd:69-73 | Check 4: dead chunk `#| file: ../R/00_data.R` with eval: false, echo: false -- reads the source tree (not book/data, figs or installed package) and renders nothing. Removing it renumbers unnamed chunks, but the chapter has no figures: docs/01-coancestry_files/ does not exist and book/_freeze/01-coancestry/ holds only execute-results/{html,typ}.json, so nothing is orphaned. | ls of both dirs. |
| 01-R9 | low | book/01-coancestry.qmd:51, 95-97, 160-163, 176, 231-232 | `ctx$X`, `ctx$G`, `ctx$f` used in code and prose. ctx contains both `f` and `fL`; `$f` exact-matches here so the result is correct, but CLAUDE.md mandates `ctx[["f"]]` and this is the chapter that introduces the convention. | names(ctx): X f G traits ped n_lines pool fL cfg N m index p0 maf_pop. |
| 01-R10 | low | book/01-coancestry.qmd:155-157 | Printing the function prints `<bytecode: 0x...>` and `<environment: namespace:hybdiv>`; the address changes per render (spurious freeze/docs diffs). Use `print(molecular_coancestry, useSource = FALSE)` filtered, or `body()`/`deparse()`. | html.json shows `<bytecode: 0x7cef7b4dd0>`. |

## Checks with no finding

1. Hand-typed numbers: none. The prose quotes no computed value; every number shown is chunk output. The constants 0.5 and 1 are derived in-text.
2. Seeds: the only draw is simulate_data(book_cfg), which seeds itself (R/00_data.R:39 set.seed(cfg$seed), :126 set.seed(cfg$seed + 99)); no AlphaSimR. _common.R:15 set.seed(2026) is irrelevant here.
4. Data sources: no reads of report/, data/ or reference/ (only 01-R8's R/ read).
5. simulate_data, vanraden_G, molecular_coancestry are exported in NAMESPACE and in the installed hybdiv 0.1.0; installed molecular_coancestry body identical to source.
6. No chunk changes in this iteration; chapter has no figures, so nothing to orphan (see 01-R8 if that chunk is removed). book/downloads/01-coancestry.R exists; chapter listed in book/_quarto.yml:22.
Not checked: whether Gomez-Romano et al. 2016, Toro 2014, Meuwissen 2020 say what :197-209 attribute to them (refcheck's job).
