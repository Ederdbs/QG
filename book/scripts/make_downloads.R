# Builds one standalone, downloadable R script per chapter (book/downloads/)
# and makes sure every chapter ends with the standard "Reproduce this chapter"
# section linking to it. Idempotent; run from the repo root:
#
#   Rscript book/scripts/make_downloads.R
#
# Re-run it after editing any chapter, then render the book. The script is the
# chapter itself: knitr::purl(documentation = 2) turns the prose into comment
# blocks and keeps every chunk, in order, so the reader gets the full
# explanation and the code step by step.

stopifnot(file.exists("book/_quarto.yml"))
site <- "https://ederdbs.github.io/QG"
raw  <- "https://raw.githubusercontent.com/Ederdbs/QG/main/book"
marker <- "<!-- reproduce-chapter -->"

# Chapters and appendices that carry code (index and references do not).
yml <- readLines("book/_quarto.yml")
qmd <- unique(sub("^\\s*- ", "", grep("^\\s*- .*\\.qmd$", yml, value = TRUE)))
qmd <- setdiff(qmd, c("index.qmd", "99-references.qmd"))

# Setup block: _common.R from set.seed() on, with the two cache helpers
# replaced by versions that download the cached artefact when it is missing.
common <- readLines("book/_common.R")
body <- common[seq(grep("^set.seed", common), length(common))]
body <- body[!grepl("^book_(data|fig)\\s+<-", body)]
fetch <- sprintf(c(
  "# Cached artefacts (expensive sweeps) are fetched from the repository on first use.",
  ".book_get <- function(dir, ...) {",
  "  f <- file.path(dir, ...)",
  "  if (!file.exists(f)) {",
  "    dir.create(dirname(f), showWarnings = FALSE, recursive = TRUE)",
  "    utils::download.file(paste0('%s/', f), f, quiet = TRUE, mode = 'wb')",
  "  }",
  "  f",
  "}",
  "book_data <- function(...) .book_get('data', ...)",
  "book_fig  <- function(...) .book_get('figs', ...)"), raw)

for (f in qmd) {
  id  <- sub("\\.qmd$", "", f)
  txt <- readLines(file.path("book", f))
  txt <- txt[seq_len(if (any(txt == marker)) which(txt == marker)[1] - 1 else length(txt))]
  while (length(txt) && !nzchar(txt[length(txt)])) txt <- txt[-length(txt)]

  # 1. standalone script from the chapter body
  tmp <- tempfile(fileext = ".qmd"); writeLines(txt, tmp)
  out <- tempfile(fileext = ".R")
  knitr::purl(tmp, out, documentation = 2, quiet = TRUE)
  r <- readLines(out)
  i <- grep('source("_common.R")', r, fixed = TRUE)[1]
  j <- max(grep("^## -----", r[seq_len(i)]))   # the whole setup chunk goes
  # chunks that print a package source file (#| file:) have no body here
  r[which(r == "# NA")] <- "# (the book prints a package source file here; see the function in R/)"
  hdr <- c(
    sprintf("# %s -- standalone script of the chapter %s", id, f),
    sprintf("# Book: %s/%s.html", site, id),
    "#",
    "# Reproduces every analysis of the chapter, in order; the chapter text is kept",
    "# as comments (#') so the script reads as the chapter does.",
    "#",
    "# Requirements: R >= 4.1 and the 'hybdiv' package (this repository's root):",
    "#   install.packages('remotes'); remotes::install_github('Ederdbs/QG')",
    "# Run it top to bottom in an empty working directory.",
    "",
    "library(hybdiv)", body, "", fetch)
  r <- append(r[-(j:i)], hdr, after = j - 1)
  writeLines(r, file.path("book/downloads", paste0(id, ".R")))

  # 2. standard footer, appended once
  foot <- c(
    "", marker, "",
    "## Reproduce this chapter {.unnumbered}", "",
    sprintf("All the code of this chapter, in order and with the explanation kept as comments, is one script: [**%s.R**](%s/downloads/%s.R){download=\"%s.R\"}.",
            id, site, id, id),
    "Download it, install `hybdiv`, and run it top to bottom in an empty directory; cached results are fetched on first use.")
  writeLines(c(txt, foot), file.path("book", f))
  message("ok ", id)
}
