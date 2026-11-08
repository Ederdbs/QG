# 03 -- iteration 4 response

| ID | Status | Change |
|---|---|---|
| 03-M16 | fixed | `alt_het` now reads: "the six single-draw points scatter over a range of 0.0046 around a dashed horizontal line at the expectation, 0.365, about as much as the replicate bars, and the figure cannot separate a flat line from a small trend". The range is `diff(range(div["het_fraction", ]))` (sprintf %.4f). Because `fig-alt` is evaluated before the figure chunk runs, the `div <- vapply(...)` block was moved verbatim, unchanged, from the figure chunk to the preceding `include: false` chunk (where `alt_het` is built); no logic changed. |
| 03-M17 | fixed | Body text: "the range of the figure (0.0046)" -> "the range of the six single draws (0.0046)"; number still `num(diff(range(d$het_fraction)))`. |

Checks: `make_downloads.R` ok (03 purls); the purled script sourced against `pkgload::load_all` from a temp dir runs to the end; `alt_het` renders with 0.0046 = `diff(range(d$het_fraction))` = 0.0046024. No `book/Rplots.pdf` or `book/figure/`. Not rendered, not committed.
