# Tests for data ---------------------------------------------------------------

test_that(
  "bagyo is a data.frame",
  {
    expect_s3_class(bagyo, "data.frame")
    expect_s3_class(bagyo, "tbl")
  }
)


test_that(
  "bagyo has specific names",
  {
    expect_named(
      bagyo,
      expected = c(
        "year", "category_code", "category_name", "name", "rsmc_name",
        "start", "end", "pressure", "speed"
      )
    )
  }
)

test_that(
  "bagyo has specific values",
  {
    expect_contains(bagyo$year, 2017:2020)
    expect_contains(
      bagyo$category_name,
      c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    )
    expect_contains(bagyo$category_code, c("TD", "TS", "STS", "TY", "STY"))
  }
)


