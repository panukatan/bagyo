# Tests for data ---------------------------------------------------------------

test_that(
  "cyclones is a data.frame",
  {
    expect_s3_class(cyclones, "data.frame")
    expect_s3_class(cyclones, "tbl")
  }
)


test_that(
  "cyclones has specific names",
  {
    expect_named(
      cyclones,
      expected = c(
        "year", "category_code", "category_name", "name", "rsmc_name",
        "start", "end", "pressure", "speed"
      )
    )
  }
)

test_that(
  "cyclones has specific years",
  {
    expect_contains(cyclones$year, 2017:2020)
    expect_contains(
      cyclones$category_name,
      c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    )
    expect_contains(cyclones$category_code, c("TD", "TS", "STS", "TY", "STY"))
  }
)


