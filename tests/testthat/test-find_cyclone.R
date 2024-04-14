# Tests for find_bagyo() function ----------------------------------------------

test_that(
  "output is a tibble",
  {
    expect_s3_class(find_bagyo(), "tbl")
    expect_s3_class(find_bagyo(), "data.frame")
  }
)

test_that(
  "output is a tibble",
  {
    expect_s3_class(find_bagyo(.year = 2017), "tbl")
    expect_s3_class(find_bagyo(.year = 2017), "data.frame")
    expect_s3_class(find_bagyo(.year = 2016), "tbl")
    expect_s3_class(find_bagyo(.year = 2016), "data.frame")
    expect_s3_class(find_bagyo(.category = "TD"), "tbl")
    expect_s3_class(find_bagyo(.category = "TD"), "data.frame")
    expect_s3_class(find_bagyo(.year = 2017, .category = "TD"), "tbl")
    expect_s3_class(find_bagyo(.year = 2017, .category = "TD"), "data.frame")
  }
)

test_that(
  "output has the expected number of rows",
  {
    expect_equal(nrow(find_bagyo()), nrow(bagyo))
    expect_equal(nrow(find_bagyo(.year = 2017)), 22)
    expect_equal(nrow(find_bagyo(.year = 2016)), 0)
  }
)



