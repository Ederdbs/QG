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


if (Sys.which("quarto") == "") {
    stop("quarto not found on PATH")
}
if (!dir.exists("book")) {
    stop("run this from the repository root")
}

t0 <- Sys.time()
status <- system2("quarto", args)
if (status != 0L) {
    stop("quarto render failed (exit ", status, ")")
}

# Keep the README's "N chapters, N parts, N appendices, N pages" line in
# step with the book. Pages are counted as /Type /Page objects, which needs
# no PDF tooling.
pdf <- "docs/Genetic-Diversity-in-Hybrid-Breeding.pdf"
if (file.exists(pdf) && file.exists("README.md")) {
    b <- readBin(pdf, "raw", file.size(pdf))
    b[b == as.raw(0)] <- as.raw(32)
    pages <- lengths(regmatches(
        rawToChar(b),
        gregexpr(
            "/Type\\s*/Page\\b(?!s)",
            rawToChar(b),
            perl = TRUE,
            useBytes = TRUE
        )
    ))
    yml <- readLines("book/_quarto.yml")
    app <- seq_along(yml) > grep("^  appendices:", yml)
    n_ch <- sum(grepl("^ {8}- .*\\.qmd$", yml))
    n_app <- sum(app & grepl("^ {4}- .*\\.qmd$", yml))
    n_part <- sum(grepl("^ {4}- part:", yml))
    rd <- readLines("README.md", encoding = "UTF-8")
    rd <- sub(
        "\\d+ chapters \u00b7 \\d+ parts \u00b7 \\d+ appendices \u00b7 \\d+ pages",
        sprintf(
            "%d chapters \u00b7 %d parts \u00b7 %d appendices \u00b7 %d pages",
            n_ch,
            n_part,
            n_app,
            pages
        ),
        rd
    )
    writeLines(rd, "README.md", useBytes = TRUE)
}

cat(sprintf(
    "done in %.1f min -> docs/\n",
    as.numeric(difftime(Sys.time(), t0, units = "mins"))
))
