# Tests for get_bagyo() function -----------------------------------------------

test_that(
  "output is class tibble",
  {
    expect_s3_class(
      get_bagyo(),
      "bagyo"
    )
  }
)

test_that(
  "there is an output",
  {
    expect_output(print(get_bagyo()))
  }
)
