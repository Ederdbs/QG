# Loaded by every chapter. Two jobs: make the package available whether or not
# it is installed, and fix the small simulation scale the book runs live.
#
# Nothing here is chapter-specific. Anything a single chapter needs belongs in
# that chapter.

if (!requireNamespace("hybdiv", quietly = TRUE)) {
  # Running from a source checkout: load the package from ../R without
  # installing it.
  suppressMessages(pkgload::load_all(file.path("..")), classes = "packageStartupMessage")
} else {
  suppressPackageStartupMessages(library(hybdiv))
}

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
book_data <- function(...) file.path("data", ...)
book_fig  <- function(...) file.path("figs", ...)

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
