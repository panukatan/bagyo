# Tests for data ---------------------------------------------------------------

testthat::expect_s3_class(tropical_cyclones, "data.frame")

testthat::expect_named(
  tropical_cyclones,
  expected = c("year", "category_code", "category_name", "name", "rsmc_name",
               "start", "end", "pressure", "speed")
)

testthat::expect_contains(tropical_cyclones$year, 2017:2020)
