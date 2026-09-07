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

# quarto ships inside the RStudio/Positron bundles on macOS and is not on PATH
# there; fall back to those before giving up.
quarto <- Sys.which("quarto")
if (quarto == "") {
  cand <- c("/Applications/Positron.app/Contents/Resources/app/quarto/bin/quarto",
            "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto")
  quarto <- c(cand[file.exists(cand)], "")[1]
}
if (quarto == "") stop("quarto not found on PATH")
if (!dir.exists("book")) stop("run this from the repository root")

# docs/ sits outside book/, so quarto refuses to clean docs/*_files and each
# render lands its figures beside the stale ones as "fig-1 2.png", "fig-1 3.png",
# ... Clear them ourselves. Only on a full render: both passes then rewrite every
# figure, whereas --to html alone would not restore the figure-typst SVGs.
if (is.na(fmt)) unlink(Sys.glob("docs/*_files"), recursive = TRUE)

t0 <- Sys.time()
status <- system2(quarto, args)
if (status != 0L) stop("quarto render failed (exit ", status, ")")

# This repo lives under an iCloud-synced ~/Documents, and iCloud answers a fast
# rewrite of a tracked file by keeping a conflict copy next to it ("index 3.html").
# Two of those had already been committed into docs/. Sweep them.
dups <- list.files("docs", pattern = " [0-9]+([.][^.]+)?$",
                   recursive = TRUE, all.files = TRUE, full.names = TRUE)
if (length(dups)) {
  unlink(dups)
  cat(sprintf("removed %d iCloud conflict copies from docs/\n", length(dups)))
}

cat(sprintf("done in %.1f min -> docs/\n",
            as.numeric(difftime(Sys.time(), t0, units = "mins"))))

