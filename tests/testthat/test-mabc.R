# Ported from the 35-check battery in inst/scripts/run_mabc.R. The script's
# battery guarded the primitives and left the decision layer -- select_parent(),
# run_bc_program(), summarise_reps() -- untested, which is precisely where its
# selection-index defect lived. T11-T14 below are that gap closed: they assert
# that rec_drag returns the minimum-drag plant and that rec_bg demonstrably
# does not.

mabc_map <- build_map(maize_chr_len, spacing_cM = 5)
mabc_w   <- marker_weights(mabc_map)

test_that("marker weights are a genome partition", {
  expect_equal(sum(mabc_w), 1)
  expect_true(all(mabc_w > 0))
})

test_that("n_for_count reduces to the closed form at count = 1", {
  for (q in c(0.5, 0.25, 0.0625)) {
    expect_equal(n_for_count(q, 1, 0.95),
                 as.integer(ceiling(log(1 - 0.95) / log(1 - q))))
  }
})

test_that("n_for_count is the cumulative binomial, not 1 - (1-q)^n", {
  for (k in 1:4) {
    q <- 0.25^k
    n <- n_for_count(q, 3, 0.95)
    expect_gte(1 - pbinom(2, n, q), 0.95)          # n is sufficient
    expect_lt(1 - pbinom(2, n - 1, q), 0.95)       # and n - 1 is not
  }
  # asking for 3 instead of 1 costs about 2.1x, not 3x
  ratio <- n_for_count(0.25, 3) / n_for_count(0.25, 1)
  expect_true(ratio > 1.9 && ratio < 2.3)
})

test_that("foreground frequency is (1/2)^k and selfing is (1/4)^k", {
  set.seed(11)
  for (k in c(1, 2, 4)) {
    tg <- target_indices(mabc_map, k)
    H <- backcross(matrix(1, mabc_map$m, 1), 4000, mabc_map)
    expect_equal(mean(foreground_ok(H, tg)), 0.5^k, tolerance = 0.12)
  }
})

# One long chromosome, so the 200/g expectation is not truncated by a telomere.
# On a real map the finite-chromosome correction applies and drag is lower.
mabc_long <- build_map(c(1200), spacing_cM = 2)

test_that("drag without selection is about 200/g cM per gene", {
  set.seed(12)
  tg <- marker_index(mabc_long, 1, 400)
  H <- matrix(1, mabc_long$m, 8000)
  for (g in 1:2) {
    H <- meiosis(H, matrix(0, mabc_long$m, ncol(H)), mabc_long$r)
    H <- H[, H[tg, ] == 1, drop = FALSE]
    expect_equal(mean(drag_total(H, mabc_long, tg)), expected_drag(g),
                 tolerance = 0.08)
  }
})

test_that("drag is a union: bounded by the sum and by the maximum", {
  set.seed(13)
  t1 <- marker_index(mabc_long, 1, 400)
  t2 <- marker_index(mabc_long, 1, 800)
  H <- meiosis(matrix(1, mabc_long$m, 4000), matrix(0, mabc_long$m, 4000),
               mabc_long$r)
  H <- H[, H[t1, ] == 1 & H[t2, ] == 1, drop = FALSE]
  u <- drag_total(H, mabc_long, c(t1, t2))
  d1 <- drag_total(H, mabc_long, t1)
  d2 <- drag_total(H, mabc_long, t2)
  expect_true(all(u <= d1 + d2 + 1e-9))
  expect_true(all(u >= pmax(d1, d2) - 1e-9))
})

test_that("p_same_segment conditions on both targets being donor", {
  # naive exp(-L) is wrong: conditioning forces an EVEN number of crossovers
  expect_equal(p_same_segment(20), 0.9803, tolerance = 1e-3)
  expect_gt(p_same_segment(20), exp(-0.20))
  expect_equal(p_same_segment(0), 1)

  # and the formula is what the simulated merge rate actually follows
  set.seed(19)
  t1 <- marker_index(mabc_long, 1, 400)
  for (dd in c(20, 60)) {
    td <- marker_index(mabc_long, 1, 400 + dd)
    H <- meiosis(matrix(1, mabc_long$m, 8000), matrix(0, mabc_long$m, 8000),
                 mabc_long$r)
    H <- H[, H[t1, ] == 1 & H[td, ] == 1, drop = FALSE]
    merged <- drag_total(H, mabc_long, c(t1, td)) <
      drag_total(H, mabc_long, t1) + drag_total(H, mabc_long, td) - 1e-9
    expect_equal(mean(merged), p_same_segment(dd), tolerance = 0.03)
  }
})

test_that("make_shared_ibd hits s and clears the targets", {
  set.seed(14)
  tg <- target_indices(mabc_map, 4)
  sh <- make_shared_ibd(mabc_map, 0.60, mabc_w, 25, tg)
  expect_lt(abs(sum(mabc_w[sh]) - 0.60), 0.015)
  expect_false(any(sh[tg]))
})

test_that("IBD + donor-specific = 1 and donor-specific = (1-s) * dosage", {
  set.seed(15)
  tg <- target_indices(mabc_map, 3)
  sh <- make_shared_ibd(mabc_map, 0.60, mabc_w, 25, tg)
  H <- backcross(matrix(1, mabc_map$m, 1), 50, mabc_map)
  expect_equal(ibd_elite(H, mabc_w, sh) + donor_specific(H, mabc_w, sh),
               rep(1, ncol(H)))
  # exact only in expectation: sharing is a realised draw, not a per-plant rate
  expect_equal(mean(donor_specific(H, mabc_w, sh)),
               0.40 * mean(donor_dosage(H, mabc_w)), tolerance = 0.02)
})

test_that("donor dosage at BC3 without selection is 1/16", {
  set.seed(16)
  # independent lineages, each advancing one unselected plant per generation
  dose <- replicate(300, {
    H <- matrix(1, mabc_map$m, 1)
    for (g in 1:3) H <- backcross(H, 1, mabc_map)
    donor_dosage(H, mabc_w)
  })
  expect_equal(mean(dose), expected_donor(3), tolerance = 0.08)
  expect_equal(expected_ibd(3, 0.5), 0.969, tolerance = 1e-3)
})

test_that("the schedule controls the population size of each generation", {
  set.seed(17)
  tg <- target_indices(mabc_map, 1)
  pr <- run_bc_program(c(200, 200, 200), 0.6, "rec_drag", mabc_map, mabc_opt,
                       tg, mabc_w)
  expect_equal(nrow(pr$traj), 3)
  expect_false(any(pr$traj$fail))
  expect_equal(pr$traj$n_fg[2], 100, tolerance = 40)   # 200 * (1/2)^1
})

test_that("rec_drag returns the minimum-drag plant and rec_bg does not", {
  set.seed(18)
  tg <- target_indices(mabc_map, 3)
  sh <- make_shared_ibd(mabc_map, 0.60, mabc_w, 25, tg)
  H <- backcross(matrix(1, mabc_map$m, 1), 400, mabc_map)
  fg <- which(foreground_ok(H, tg))
  skip_if(length(fg) < 20)
  best <- fg[which.min(drag_total(H[, fg, drop = FALSE], mabc_map, tg))]

  sd_ <- select_parent(H, mabc_map, tg, mabc_w, sh, "rec_drag", 1, mabc_opt)
  expect_equal(drag_total(H[, sd_$idx, drop = FALSE], mabc_map, tg),
               drag_total(H[, best, drop = FALSE], mabc_map, tg))

  # the documented defect: stage 2 discards stage 1, so the minimum-drag plant
  # is kept only by coincidence
  sb <- select_parent(H, mabc_map, tg, mabc_w, sh, "rec_bg", 1, mabc_opt)
  expect_gt(drag_total(H[, sb$idx, drop = FALSE], mabc_map, tg),
            drag_total(H[, sd_$idx, drop = FALSE], mabc_map, tg))
})

test_that("rec_drag beats rec_bg on end-of-programme drag, paired seeds", {
  tg <- target_indices(mabc_map, 3)
  d <- t(vapply(1:12, function(i) {
    set.seed(100 + i)
    sh <- make_shared_ibd(mabc_map, 0.60, mabc_w, 25, tg)
    vapply(c("rec_bg", "rec_drag"), function(st) {
      set.seed(100 + i)                      # common random numbers
      run_bc_program(c(150, 150, 150), 0.6, st, mabc_map, mabc_opt, tg,
                     mabc_w, shared = sh)$traj$drag[3]
    }, numeric(1))
  }, numeric(2)))
  expect_lt(mean(d[, "rec_drag"]), mean(d[, "rec_bg"]))
})

test_that("Clopper-Pearson bounds match known values", {
  expect_equal(cp_lo(30, 30), 0.8843, tolerance = 1e-3)
  expect_equal(cp_hi(0, 100), 0.03621, tolerance = 1e-3)
  expect_equal(cp_lo(0, 50), 0)
  expect_equal(cp_hi(50, 50), 1)
})

test_that("doubled haploids beat selfing at every gene number", {
  st <- sizing_table(4)
  expect_true(all(st$n_DH_3lines < st$n_F2_3plants))
  expect_equal(st$n_F2_3plants[4], 1610)
  expect_equal(st$n_DH_3lines[4], 99)
})

test_that("summarise_reps counts lost replicates as failures", {
  A <- rbind(
    data.frame(rep = 1, gen = 3, ibd = 0.97, dose = 0.06, drag = 40,
               n_fg = 5, ibd_pop_mean = 0.96, fail = FALSE),
    data.frame(rep = 2, gen = 3, ibd = NA, dose = NA, drag = NA,
               n_fg = 0, ibd_pop_mean = NA, fail = TRUE))
  s <- summarise_reps(A, mabc_opt, k = 3)
  expect_equal(s$p_lost, 0.5)
  expect_equal(s$p_both, 0.5)      # 1 of 2 replicates, not 1 of 1 survivor
})
