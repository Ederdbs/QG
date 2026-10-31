# Book cover: book/cover.pdf (Typst PDF) and book/cover.png (HTML cover-image).
#
# Run from the repository root with the fonts directory set:
#   FONTDIR=/path/to/fonts Rscript book/scripts/make_cover.R
# Fonts (all OFL): InstrumentSerif-Regular/-Italic, JetBrainsMono-Regular,
# Jura-Light. Needs showtext and the installed hybdiv; never run by render.
#
# The plate is real output, not decoration: the 50 x 50 line coancestry matrix
# of the book's teaching simulation (25 + 25 lines, 2000 markers, seed 1),
# rotated 45 degrees -- pool A left, pool B right, A x B coancestry on top --
# and the 625 A x B crosses below, with the 40 that stage2_select() picks at
# alpha = 0 in gold and the 40 picked by truncation as rings.
suppressMessages(library(hybdiv))
cfg <- modifyList(sim_config, list(n_pool_A = 25, n_pool_B = 25, m = 2000,
                                   seed = 1))
st <- stage1_simulate(cfg)
res <- stage2_select(st$X, st$f, st$hybrids, n_sel = 40, alphas = 0,
                     fL = st$fL)
x <- list(fL = st$fL, hyb = st$hybrids, sel = res$selection)
setwd("book")

suppressMessages({library(grid); library(showtext)})
FD <- Sys.getenv("FONTDIR")
font_add("titlefont", file.path(FD, "InstrumentSerif-Regular.ttf"),
         italic = file.path(FD, "InstrumentSerif-Italic.ttf"))
font_add("jbmono", file.path(FD, "JetBrainsMono-Regular.ttf"))
font_add("light", file.path(FD, "Jura-Light.ttf"))

fL <- x$fL; n <- nrow(fL); nA <- 25
hyb <- x$hyb; sel <- x$sel

col <- list(bg = "#0E1613", bone = "#E8E1CF", gold = "#E3AA3E",
            A = "#7FA79E", B = "#C98A68", dim = "#8E968F")

W <- 210; H <- 297
cx <- W / 2; cy <- 160          # diamond centre, mm from bottom
half <- 74                      # half-diagonal of the diamond, mm
u <- half / (n - 1)             # mm per matrix index

# Matrix cell (i, j) -> rotated position: the diagonal is horizontal, pool A
# left, pool B right, rows in A x columns in B on top.
pos <- function(i, j) {
  a <- j - (n + 1) / 2; b <- i - (n + 1) / 2
  list(x = cx + (a + b) * u, y = cy + (a - b) * u)
}

draw <- function(file, dev) {
  dev(file)
  showtext_begin()
  grid.newpage()
  pushViewport(viewport(xscale = c(0, W), yscale = c(0, H)))
  grid.rect(gp = gpar(fill = col$bg, col = NA))
  mm <- function(v) unit(v, "native")
  hl <- gpar(col = col$dim, lwd = 0.35, alpha = 0.7, fill = NA)
  mono <- function(lab, x, y, just = "centre", size = 5.6, colr = col$dim,
                   rot = 0)
    grid.text(lab, mm(x), mm(y), just = just, rot = rot,
              gp = gpar(fontfamily = "jbmono", fontsize = size, col = colr))

  fmin <- min(fL)
  z <- (fL - fmin) / (1 - fmin)
  dmin <- 0.22; dmax <- 1.85   # disc diameters, mm
  ij <- expand.grid(i = 1:n, j = 1:n)
  p <- pos(ij$i, ij$j)
  pa <- ij$i <= nA; pb <- ij$j <= nA
  dz <- dmin + (dmax - dmin) * sqrt(z[cbind(ij$i, ij$j)])
  # Pools: within-pool coancestry, tinted A / B.
  k <- pa == pb
  grid.circle(mm(p$x[k]), mm(p$y[k]), r = unit(dz[k] / 2, "mm"),
              gp = gpar(fill = ifelse(pa[k], col$A, col$B), col = NA))
  # Top: A x B coancestry, same scale, so it shrinks to grains.
  k <- pa & !pb
  grid.circle(mm(p$x[k]), mm(p$y[k]), r = unit(dz[k] / 2, "mm"),
              gp = gpar(fill = col$bone, col = NA, alpha = 0.85))
  # Bottom: the crosses (row in B, column in A).
  hp <- pos(hyb$line_B, hyb$line_A)
  de <- sel[["DE_alpha_0.00"]] == 1; tr <- sel[["ref_truncation"]] == 1
  grid.circle(mm(hp$x), mm(hp$y), r = unit(0.3, "mm"),
              gp = gpar(fill = col$dim, col = NA, alpha = 0.5))
  grid.circle(mm(hp$x[tr]), mm(hp$y[tr]), r = unit(0.95, "mm"),
              gp = gpar(fill = NA, col = col$bone, lwd = 0.45))
  grid.circle(mm(hp$x[de]), mm(hp$y[de]), r = unit(0.72, "mm"),
              gp = gpar(fill = col$gold, col = NA))

  # Hairline frame of the diamond.
  e <- 2.2 * u
  grid.polygon(mm(c(cx - half - e, cx, cx + half + e, cx)),
               mm(c(cy, cy + half + e, cy, cy - half - e)), gp = hl)

  # Corner labels.
  mono("POOL A", cx - half - e - 3, cy + 1.8, just = "right")
  mono("25 LINES", cx - half - e - 3, cy - 1.8, just = "right")
  mono("POOL B", cx + half + e + 3, cy + 1.8, just = "left")
  mono("25 LINES", cx + half + e + 3, cy - 1.8, just = "left")
  mono("A × B  COANCESTRY", cx, cy + half + e + 5)
  mono("625 CROSSES  ·  40 CHOSEN", cx, cy - half - e - 5)
  # Edge annotations, parallel to the upper edges.
  off <- 4.5
  mono("f(i, j)  ∈  [0.61, 1]", cx - half / 2 - off, cy + half / 2 + off,
       rot = 45, size = 5)
  mono("θ = c′f c    GD = 1 − θ", cx + half / 2 + off,
       cy + half / 2 + off, rot = -45, size = 5)

  # Legend for the bottom quadrant, low right, outside the diamond.
  lx <- cx + half / 2 + 12; ly <- cy - half / 2 - 14
  grid.circle(mm(lx), mm(ly), r = unit(0.72, "mm"),
              gp = gpar(fill = col$gold, col = NA))
  mono("chosen, α ≤ 0", lx + 3, ly, just = "left", size = 5)
  grid.circle(mm(lx), mm(ly - 4.5), r = unit(0.95, "mm"),
              gp = gpar(fill = NA, col = col$bone, lwd = 0.45))
  mono("truncation", lx + 3, ly - 4.5, just = "left", size = 5)

  # Registration marks and plate header.
  M <- 14
  reg <- function(x, y)
    grid.segments(mm(c(x - 2.2, x)), mm(c(y, y - 2.2)),
                  mm(c(x + 2.2, x)), mm(c(y, y + 2.2)), gp = hl)
  reg(M, H - M); reg(W - M, H - M); reg(M, M); reg(W - M, M)
  mono("HYBDIV  ·  PLATE I", M + 5, H - M, just = "left")
  mono("SEED 1  ·  2000 MARKERS", W - M - 5, H - M, just = "right")

  # Title block.
  tx <- 22
  grid.segments(mm(tx), mm(62), mm(W - tx), mm(62), gp = hl)
  grid.text("Genetic Diversity", mm(tx - 0.8), mm(42),
            just = c("left", "bottom"),
            gp = gpar(fontfamily = "titlefont", fontsize = 40, col = col$bone))
  grid.text("in Hybrid Breeding", mm(tx - 0.8), mm(27.5),
            just = c("left", "bottom"),
            gp = gpar(fontfamily = "titlefont", fontface = "italic",
                      fontsize = 40, col = col$bone))
  grid.text("Measuring it, constraining it,\nand optimising against it, with R",
            mm(W - tx), mm(55), just = c("right", "top"),
            gp = gpar(fontfamily = "light", fontsize = 9, col = col$bone,
                      lineheight = 1.35))
  mono("EDER D. B. S.", W - tx, 27.5, just = c("right", "bottom"), size = 6.4,
       colr = col$gold)
  showtext_end()
  invisible(dev.off())
}

draw("cover.pdf", function(f) pdf(f, width = W / 25.4, height = H / 25.4))
showtext_opts(dpi = 300)
draw("cover.png", function(f) png(f, width = W / 25.4, height = H / 25.4,
                                  units = "in", res = 300, type = "cairo"))
