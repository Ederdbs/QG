## quant-writer

| ID | Status | Evidence |
|---|---|---|
| 01-M6 | fixed | :269-271 now reads "lie in [-2, 2], negative exactly where f_ij < 0.5; on the book data every f_ij exceeds 0.5, so the range printed below is positive". Derivable from eq-g05 and the printed range(G05) = [0.579, 1.327] (min f = (0.579 + 2)/4 = 0.645). "Signed" remains only on G in tbl-matrix-roles. No code or number changed. |
| 01-M7 | fixed | :318-321 narrowed to "a switch to G inside theta_group(), and hence in the metrics built on it, fails the suite. Metrics that read ctx[["f"]] directly are not covered by that assertion." No code or number changed. |

make_downloads.R re-run (exit 0); not rendered.
