# Tests for data ---------------------------------------------------------------

testthat::expect_s3_class(cyclones, "data.frame")

testthat::expect_named(
  cyclones,
  expected = c("year", "category_code", "category_name", "name", "rsmc_name",
               "start", "end", "pressure", "speed")
)

testthat::expect_contains(cyclones$year, 2017:2020)
