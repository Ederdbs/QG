#' # The bibliographic corpora {#sec-corpora}
#' 
# 93-corpora -- standalone script of the chapter 93-corpora.qmd
# Book: https://ederdbs.github.io/QG/93-corpora.html
#
# Reproduces every analysis of the chapter, in order; the chapter text is kept
# as comments (#') so the script reads as the chapter does.
#
# Requirements: R >= 4.1 and the 'hybdiv' package (this repository's root):
#   install.packages('remotes'); remotes::install_github('Ederdbs/QG')
# Run it top to bottom in an empty working directory.

library(hybdiv)
set.seed(2026)

# The teaching scale, the default of the live examples: small enough that a
# full render takes minutes, large enough that none of the identities hold by
# accident. Chapters that need another scale set it in their own chunks. The
# production scale is n_pool_A = n_pool_B = 71 and m = 25000; see the note in
# each chapter where the difference matters.
book_cfg <- utils::modifyList(
  hybdiv::sim_config,
  list(n_pool_A = 25, n_pool_B = 25, m = 2000, seed = 1)
)

# Paths to the cached artefacts, so chapters never guess.

# Rounded table helper, used wherever a metric panel is printed.
fmt <- function(x, digits = 4) {
  # A matrix must become a data frame first: `x[num] <- lapply(...)` on a
  # matrix recycles the logical over the flattened array and assigns a list
  # back, silently turning the matrix into a list.
  if (is.matrix(x)) x <- as.data.frame(x)
  if (is.data.frame(x)) {
    num <- vapply(x, is.numeric, logical(1))
    x[num] <- lapply(x[num], round, digits)
    x
  } else round(x, digits)
}

# A value in scientific notation for inline prose, as a complete math span. A
# numeric inline value that small or large leaves knitr as bare TeX,
# `4\times 10^{-13}`, from which Pandoc drops `\times 10` (the book printed
# 4^{-13}); a string passes through untouched. Not for use inside $...$.
fmt_sci <- function(x, digits = 2) {
  s <- sprintf("%.*e", digits - 1, x)
  sprintf("$%s \\times 10^{%d}$", sub("e.*", "", s), as.integer(sub(".*e", "", s)))
}
stopifnot(identical(fmt_sci(c(3.7e-13, 9.96e-5)),
                    c("$3.7 \\times 10^{-13}$", "$1.0 \\times 10^{-4}$")))

# One palette for every live figure: the two heterotic pools get fixed colours
# (A blue, B amber, a colour-blind-safe pair); red marks the constraint or the
# loss; greys carry everything else. Chapters pass these instead of hex codes.
book_pal <- c(A = "#1f5f8b", B = "#d98e04", loss = "#b2182b",
              ink = "#14202b", mid = "grey45", light = "grey85")

# Cached artefacts (expensive sweeps) are fetched from the repository on first use.
.book_get <- function(dir, ...) {
  f <- file.path(dir, ...)
  if (!file.exists(f)) {
    dir.create(dirname(f), showWarnings = FALSE, recursive = TRUE)
    utils::download.file(paste0('https://raw.githubusercontent.com/Ederdbs/QG/main/book/', f), f, quiet = TRUE, mode = 'wb')
  }
  f
}
book_data <- function(...) .book_get('data', ...)
book_fig  <- function(...) .book_get('figs', ...)
ani <- read.csv(book_data("bibliography_animal.csv"), stringsAsFactors = FALSE)
pl  <- read.csv(book_data("bibliography_plant.csv"), stringsAsFactors = FALSE)

#' 
#' @sec-plant-literature draws on two screened corpora. This appendix describes
#' them so the claims there can be checked, extended, or disagreed with.
#' 
#' ## What they are
#' 
#' @tbl-corpora-files lists the two corpora.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-files
#| echo: false
#| tbl-cap: "The two screened corpora: number of records, publication years and subject of each file."
knitr::kable(data.frame(
  Corpus = c("`bibliography_animal.csv`", "`bibliography_plant.csv`"),
  Records = c(nrow(ani), nrow(pl)),
  Years = c(paste(range(ani$year), collapse = "-"),
            paste(range(pl$year), collapse = "-")),
  Focus = c("optimal contribution, coancestry matrix choice, effective size, allelic richness",
            "diversity quantification, heterotic structure, genetic resources, optimisation"),
  check.names = FALSE))

#' 
#' Both are annotated screens, not exhaustive searches. The plant corpus came from
#' 2004 records across 29 plant-breeding queries on Crossref and Europe PMC, of
#' which `r nrow(pl)` were retained (relevance 2, related background, or 3, directly
#' relevant; `r sum(pl$relevance == 3)` are 3).
#' 
#' ## Structure
#' 
#' The plant file has the columns
#' `r paste0("\x60", names(pl), "\x60", collapse = ", ")`. The ones that carry the screening annotation are described in @tbl-corpora-columns.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-columns
#| echo: false
#| tbl-cap: "Annotation columns of the corpus files and what each holds."
knitr::kable(data.frame(
  Column = c("`relevance`", "`crop`", "`metric_used` / `metric_advocated`",
             "`selection_method`", "`theme`", "`contribution` / `relevance_note`"),
  Meaning = c("3 = directly relevant, 2 = related background",
              "plant corpus only",
              "the diversity metrics the record reports",
              "plant corpus only",
              "animal corpus only; multi-valued, semicolon-separated",
              "a one-line note on what the record adds"),
  check.names = FALSE))

#' 
#' ## Relevance and coverage
#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-relevance
#| echo: false
#| tbl-cap: "Number of screened records by relevance score (3 = directly relevant, 2 = related background) in each file."
knitr::kable(data.frame(
  Corpus = c("plant", "animal"),
  `Relevance 2` = c(sum(pl$relevance == 2), sum(ani$relevance == 2)),
  `Relevance 3` = c(sum(pl$relevance == 3), sum(ani$relevance == 3)),
  check.names = FALSE))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-crops
#| echo: false
#| tbl-cap: "Crop coverage of the directly relevant plant records (relevance 3): the ten most frequent crop labels and their number of records."
top <- sort(table(pl$crop[pl$relevance == 3]), decreasing = TRUE)
top <- top[names(top) != ""][1:10]
knitr::kable(data.frame(crop = names(top), records = as.integer(top)))

#' 
#' Maize dominates (@tbl-corpora-crops, @fig-plant-landscape), which is the intended bias -- but it also means every claim in
#' @sec-plant-literature about crops other than maize rests on a handful of
#' records.
#' 
#' The publication years of both files are in @fig-corpora-years.
#' 
## -----------------------------------------------------------------------------
#| label: fig-corpora-years
#| echo: false
#| fig-cap: !expr paste0("Number of screened records per publication year in the plant file (left, `bibliography_plant.csv`) and the animal file (right, `bibliography_animal.csv`); each bar is a count of records, with no uncertainty, and the two panels do not share a vertical scale. The plant file starts in ", min(pl$year), " with ", sum(pl$year == min(pl$year)), " record and is mainly from ", min(pl$year[pl$year > min(pl$year)]), " onward; the animal file starts in ", min(ani$year), ".")
#| fig-alt: "Two bar charts of the number of screened records per publication year, plant file on the left and animal file on the right. Both rise from a handful of records or fewer in the earliest year to the largest counts in 2025 and 2026."
op <- par(mfrow = c(1, 2), mar = c(4.6, 4.2, 2.5, 1))
barplot(table(pl$year), main = "plant", xlab = "year", ylab = "records per year", las = 2,
        col = "grey80", border = "white")
barplot(table(ani$year), main = "animal", xlab = "year", ylab = "records per year", las = 2,
        col = "grey80", border = "white")
par(op)

#' 
## -----------------------------------------------------------------------------
#| label: fig-plant-landscape
#| echo: false
#| fig-width: 9
#| fig-height: 4.8
#| fig-cap: "Left: the usage table `plant_metric_usage.csv` as shipped, records per metric category, maize and other crops; it is an external classification with no producer in this repository and is not recomputed (see @tbl-plant-usage-check in @sec-plant-literature). Right: the ten most frequent crop labels among the screened records, with all labels containing 'maize' pooled; the labels 'none' and empty are left out. In both panels the denominator is the screened records of `bibliography_plant.csv` (relevance 2 or 3), 2017-2026. Red outline: the categories to which @sec-plant-literature maps the recommended metrics (expected heterozygosity for the quantity inside the proportional loss, coancestry, allelic richness, effective size), an approximate and non-unique mapping. Coancestry and allelic richness tie at rank 6 by record count; effective size ranks 12 of 12."
#| fig-alt: "Two horizontal bar charts. Left: records per diversity metric category in the plant usage table, from population structure (303 records) down to effective size or status number (17); each bar is split into maize (dark grey) and other crops (light grey), and red outlines mark expected heterozygosity, marker coancestry, allelic richness and effective size. Right: the ten most frequent crop labels among the screened plant records, maize (197) far ahead of wheat (42), multi-crop (39) and rice (33)."
mu <- read.csv(book_data("plant_metric_usage.csv"), stringsAsFactors = FALSE)
mu <- mu[order(mu$n_records), ]
lab <- sub(" \\(.*\\)$", "", mu$metric)
lab <- sub("Haplotype / pan-genome diversity", "Haplotype / pan-genome", sub("Modified Rogers / genetic distance", "Mod. Rogers / distance", sub(" / relatedness", "", sub("Effective population size", "Effective size", lab))))
red <- grepl("Expected heterozygosity|Marker coancestry|Allelic richness|Effective population", mu$metric)
op <- par(mfrow = c(1, 2), mar = c(4.2, 13, 2.5, 1), cex = 0.75)
bp <- barplot(rbind(mu$n_records - mu$n_maize, mu$n_maize), horiz = TRUE, las = 1,
              names.arg = lab, col = c(book_pal[["light"]], book_pal[["mid"]]),
              border = "white", xlim = c(0, 360),
              xlab = paste0("records (of ", nrow(pl), " screened)"),
              main = "Usage table (external)")
rect(0, bp[red] - 0.5, mu$n_records[red], bp[red] + 0.5, border = book_pal[["loss"]], lwd = 1.5)
text(mu$n_records + 2, bp, mu$n_records, adj = 0, cex = 0.8, col = book_pal[["mid"]])
legend("bottomright", c("other crops", "maize"), fill = c(book_pal[["light"]], book_pal[["mid"]]),
       bty = "n", cex = 0.8)
cr <- ifelse(grepl("maize", pl$crop, ignore.case = TRUE), "maize", pl$crop)
cr <- cr[!cr %in% c("", "none")]
top <- rev(head(sort(table(cr), decreasing = TRUE), 10))
par(mar = c(4.2, 7, 2.5, 1))
bp <- barplot(as.integer(top), horiz = TRUE, las = 1, names.arg = names(top), xlim = c(0, 240),
              col = ifelse(names(top) == "maize", book_pal[["mid"]], book_pal[["light"]]),
              border = "white", xlab = paste0("screened records (n = ", nrow(pl), ")"),
              main = "Crop of the screened records")
text(as.integer(top) + 2, bp, as.integer(top), adj = 0, cex = 0.8, col = book_pal[["mid"]])
par(op)

#' 
#' ## Themes in the animal corpus
#' 
#' The `theme` column is multi-valued. Splitting it:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-themes
#| echo: false
#| tbl-cap: "Themes of the directly relevant records (relevance 3) of `bibliography_animal.csv`, after splitting the semicolon-separated `theme` field; a record with several themes is counted once in each."
th <- unlist(strsplit(ani$theme[ani$relevance == 3], ";\\s*"))
th <- trimws(th); th <- th[nzchar(th)]
th <- sort(table(th), decreasing = TRUE)
knitr::kable(data.frame(theme = names(th), records = as.integer(th)))

#' 
#' ## Querying them
#' 
#' The corpora are ordinary CSVs. The queries below count what the shipped
#' `metric_used` column holds; they do not reproduce the usage table of
#' @sec-plant-literature, which is an external classification with no producer here
#' and gives larger counts (@tbl-plant-usage-check compares the two).
#' 
## -----------------------------------------------------------------------------
# records that report a coancestry or kinship metric
sum(grepl("coancestry|kinship|relatedness", pl$metric_used, ignore.case = TRUE))

# records using ROH, and how many of those are maize
roh <- grepl("\\bROH\\b|runs of homozygosity", pl$metric_used, ignore.case = TRUE)
c(roh_total = sum(roh), roh_maize = sum(roh & grepl("maize", pl$crop, ignore.case = TRUE)))

# the most-cited directly relevant maize records
mz <- pl[pl$relevance == 3 & grepl("maize", pl$crop, ignore.case = TRUE), ]
head(mz[order(-mz$citations), c("year", "title", "citations")], 6)

#' 
## -----------------------------------------------------------------------------
# the animal-side records on matrix choice
mc <- ani[grepl("Coancestry / relationship matrix choice", ani$theme), ]
head(mc[order(-mc$citations), c("year", "title", "citations")], 6)

#' 
#' ## Limitations
#' 
#' **These are abstract screens.** Relevance and the metric annotations were scored
#' from titles and abstracts, not from full texts. A paper that computes a metric
#' without naming it in the abstract is invisible to this table -- which almost
#' certainly understates how often coancestry is computed as an intermediate step.
#' 
#' **The queries shaped the answer.** 29 plant-breeding queries were run; a
#' different query set would return a different landscape. The strong maize skew is
#' by design, and the counts for other crops are too small to support a claim about
#' those crops.
#' 
#' **"Not established in the retrieved set" means exactly that.** Every such
#' statement in @sec-plant-literature is a claim about *this corpus*, not about the
#' literature as a whole. It is a prompt to look further before assuming novelty,
#' not a proof of it.
#' 
#' **Citation counts are a snapshot** at screening time and are already stale.
#' 
#' ## Classical references
#' 
#' The plant file starts in `r min(pl$year)` (one record; mainly `r min(pl$year[pl$year > min(pl$year)])` onward) and the animal file in `r min(ani$year)`, so the
#' corpora leave out classical work by construction. The classical results the book
#' rests on are cited from the source literature, and collected in `book/references.bib`
#' with two exceptions stated after the table:
#' 
#' @tbl-corpora-classical lists them.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-corpora-classical
#| echo: false
#| tbl-cap: "Classical results the book rests on and the source each is cited from."
knitr::kable(data.frame(
  Result = c("group coancestry", "molecular / IBS coancestry",
             "gene diversity, Gst", "the subdivided-population partition",
             "status number", "optimal contribution selection",
             "genomic relationship matrix", "modified Rogers distance",
             "usefulness criterion", "differential evolution"),
  Source = c("Cockerham (1967)", "Nejati-Javaremi et al. (1997)",
             "Nei (1973)", "Caballero & Toro (2000, 2002)",
             "Lindgren & Mullin (1997, 1998)", "Meuwissen (1997)",
             "VanRaden (2008)", "Wright (1978)",
             "Schnell & Utz (1975)", "Storn & Price (1997)"),
  check.names = FALSE))

#' 
#' Wright (1978) and Schnell & Utz (1975) are not in `book/references.bib` and are
#' given in the table by author and year only. A Crossref bibliographic query for
#' each returned no record of either work (for Wright, only reviews of the book), so
#' neither entry was checked against a source record here.
