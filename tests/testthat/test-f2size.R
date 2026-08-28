# The F1 -> F4 sizing engine, checked against its analytical identities.

test_that("the map has the requested length and Haldane spacing", {
  map <- build_map(maize_chr_len, spacing_cM = 5)
  expect_equal(map$total_cM, sum(maize_chr_len))
  expect_equal(length(unique(map$chr)), length(maize_chr_len))
  # first marker of each chromosome segregates independently
  expect_true(all(map$r[map$first] == 0.5))
  # interior intervals follow Haldane
  d <- 5
  expect_equal(unique(round(map$r[!map$first & abs(diff(c(0, map$pos))) == d], 10)),
               round(0.5 * (1 - exp(-2 * d / 100)), 10))
})

test_that("heterozygosity halves with each selfing generation", {
  map <- build_map(maize_chr_len, spacing_cM = 10)
  d <- make_distortion(map, NULL, active = FALSE)
  set.seed(21)
  F1 <- make_F1(map, 400)
  expect_equal(panel_het(F1), 1)
  F2 <- cross_indices(F1, 1:400, 1:400, map, d)
  F3 <- cross_indices(F2, 1:400, 1:400, map, d)
  F4 <- cross_indices(F3, 1:400, 1:400, map, d)
  expect_equal(panel_het(F2), 0.50, tolerance = 0.03)
  expect_equal(panel_het(F3), 0.25, tolerance = 0.03)
  expect_equal(panel_het(F4), 0.125, tolerance = 0.05)
})

test_that("the identity D = 1 - (1 - H) / N holds under neutrality", {
  map <- build_map(maize_chr_len, spacing_cM = 10)
  d <- make_distortion(map, NULL, active = FALSE)
  set.seed(22)
  for (N in c(50, 200)) {
    pop <- run_scheme("ssd", N, map, d, f2_opt)
    D <- diversity_retained(panel_freq(pop))
    expect_equal(D, 1 - (1 - panel_het(pop)) / N, tolerance = 0.01)
  }
})

test_that("n_equivalent inverts diversity_retained", {
  expect_equal(n_equivalent(1 - (1 - 0.125) / 120), 120, tolerance = 1e-6)
})

test_that("map expansion: a Syn cycle adds half a map length of junctions", {
  map <- build_map(maize_chr_len, spacing_cM = 2)
  L <- map$total_cM / 100
  ssd  <- expected_junctions("ssd", map)[["junctions"]]
  syn1 <- expected_junctions("syn1", map)[["junctions"]]
  expect_equal(ssd, L * 1.75, tolerance = 1e-9)     # 1 + 0.5 + 0.25
  expect_equal(syn1 - ssd, L * 0.5, tolerance = 1e-9)
})

test_that("segregation distortion shifts ancestry away from 0.5", {
  map <- build_map(maize_chr_len, spacing_cM = 5)
  set.seed(23)
  neutral   <- run_scheme("ssd", 150, map, make_distortion(map, NULL, active = FALSE), f2_opt)
  distorted <- run_scheme("ssd", 150, map, make_distortion(map, f2_distorters), f2_opt)
  expect_lt(diversity_retained(panel_freq(distorted)),
            diversity_retained(panel_freq(neutral)))
})

test_that("f1_sizing halves the loss probability per extra plant", {
  s <- f1_sizing(1:10, h_res = 0.05, n_loci_eff = 5000)
  expect_equal(s$p_loss_per_locus[1], 1)
  expect_equal(s$p_loss_per_locus[-1] / s$p_loss_per_locus[-10],
               rep(0.5, 9), tolerance = 1e-12)
})
