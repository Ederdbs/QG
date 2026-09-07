# Render the whole book, HTML + Typst PDF, into docs/.
#
# Run from the repository root:   Rscript inst/scripts/render_book.R
# Optional argument to render one format only:
#   Rscript inst/scripts/render_book.R html
#   Rscript inst/scripts/render_book.R typst
#
# Both outputs land in docs/ (see book/_quarto.yml output-dir); docs/ is tracked
# because GitHub Pages serves the book straight from main. Re-run this before
# committing whenever a chapter changes, or the published book goes stale.
#
# `execute: freeze: auto` means only chapters whose source changed re-run; the
# expensive results come from book/data and book/figs and are NOT regenerated
# here -- that is book/scripts/regenerate.R, run by hand.

fmt <- commandArgs(trailingOnly = TRUE)[1]
args <- c("render", "book", if (!is.na(fmt)) c("--to", fmt))

if (Sys.which("quarto") == "") stop("quarto not found on PATH")
if (!dir.exists("book")) stop("run this from the repository root")

t0 <- Sys.time()
status <- system2("quarto", args)
if (status != 0L) stop("quarto render failed (exit ", status, ")")

cat(sprintf("done in %.1f min -> docs/\n",
            as.numeric(difftime(Sys.time(), t0, units = "mins"))))




