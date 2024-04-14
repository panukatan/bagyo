#'
#' Find cyclones information
#'
#' @param .year An integer value for a year or a vector of years of cyclones
#'   data to retrieve. Default to NULL to retrieve all years.
#' @param .category A character value or a vector of category code/s or category
#'   name/s to retrieve. Default to NULL to retrieve all categories
#'
#' @returns A data.frame of cyclones information based on specified `year` and
#'   `category`
#'
#' @examples
#' find_bagyo()
#' find_bagyo(.year = 2017)
#' find_bagyo(.category = "TD")
#' find_bagyo(.year = 2017, .category = "TD")
#'
#' @export
#'

find_bagyo <- function(.year = NULL, .category = NULL) {
  df <- bagyo::bagyo

  if (is.null(.year)) {
    if (is.null(.category))
      result <- df
    else
      result <- df[df$category_name %in% .category | df$category_code %in% .category, ]
  } else {
    if (is.null(.category))
      result <- df[df$year %in% .year, ]
    else
      result <- df[df$year %in% .year & (df$category_name %in% .category | df$category_code %in% .category), ]
  }

  ## Return result ----
  result
}
