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

# The teaching scale. Every live example in the book runs at this size: small
# enough that a full render takes minutes, large enough that none of the
# identities hold by accident. The production scale is n_pool_A = n_pool_B = 71
# and m = 25000; see the note in each chapter where the difference matters.
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
## -----------------------------------------------------------------------------
#| echo: false
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
#' which `r nrow(pl)` were scored relevant.
#' 
#' ## Structure
#' 
## -----------------------------------------------------------------------------
names(pl)

#' 
## -----------------------------------------------------------------------------
#| echo: false
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
table(plant = pl$relevance)
table(animal = ani$relevance)

#' 
## -----------------------------------------------------------------------------
#| echo: false
top <- sort(table(pl$crop[pl$relevance == 3]), decreasing = TRUE)
top <- top[names(top) != ""][1:10]
knitr::kable(data.frame(crop = names(top), records = as.integer(top)),
  caption = "Crop coverage of the directly relevant plant records.")

#' 
#' Maize dominates, which is the intended bias -- but it also means every claim in
#' @sec-plant-literature about crops other than maize rests on a handful of
#' records.
#' 
## -----------------------------------------------------------------------------
#| echo: false
#| fig-cap: "Publication year of the screened records. Both corpora are deliberately post-2017."
#| fig-alt: "Publication year of the screened records"
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.5, 1))
barplot(table(pl$year), main = "plant", xlab = "year", col = "grey80", border = "white")
barplot(table(ani$year), main = "animal", xlab = "year", col = "grey80", border = "white")
par(op)

#' 
## -----------------------------------------------------------------------------
#| echo: false
#| fig-cap: "Which diversity metrics the plant literature actually reports."
#| fig-alt: "Which diversity metrics the plant literature actually reports"
knitr::include_graphics(book_fig("plant_lit_landscape.png"))

#' 
#' ## Themes in the animal corpus
#' 
#' The `theme` column is multi-valued. Splitting it:
#' 
## -----------------------------------------------------------------------------
th <- unlist(strsplit(ani$theme[ani$relevance == 3], ";\\s*"))
th <- trimws(th); th <- th[nzchar(th)]
sort(table(th), decreasing = TRUE)

#' 
#' ## Querying them
#' 
#' The corpora are ordinary CSVs, so the claims in @sec-plant-literature are
#' checkable in one line each.
#' 
## -----------------------------------------------------------------------------
# records that report a coancestry or kinship metric
sum(grepl("coancestry|kinship|relatedness", pl$metric_used, ignore.case = TRUE))

# records using ROH, and how many of those are maize
roh <- grepl("ROH", pl$metric_used, ignore.case = TRUE)
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
#' The corpora are deliberately post-2017. The classical results the book rests on
#' are cited from the source literature, and collected in `book/references.bib`:
#' 
## -----------------------------------------------------------------------------
#| echo: false
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

