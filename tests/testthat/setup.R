# One simulated dataset shared by the whole suite. Small enough to be quick,
# large enough that the identities are not satisfied by accident.
cfg <- modifyList(sim_config, list(n_pool_A = 12, n_pool_B = 12, m = 800))
ctx <- simulate_data(cfg)
set.seed(11)
idx <- sample.int(ctx$N, 40)
