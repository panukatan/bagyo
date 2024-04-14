#'
#' Get a cyclone name
#'
#' Randomly returns a cyclone name and prints additional information available
#' from the package regarding the cyclone.
#'
#' @returns A list of information regarding a randomly selected cyclone from
#'   the `bagyo` dataset.
#'
#' @examples
#' get_bagyo()
#'
#' @rdname get_bagyo
#' @export
#'

get_bagyo <- function() {
  df <- bagyo::cyclones

  df <- df[sample(seq_len(nrow(df)), size = 1), ] |>
    as.list()

  attr(df, "class") <- "bagyo"

  df
}


#'
#' [print()] helper function for [get_bagyo()] function
#'
#' @param x Object of class `bagyo` produced by [get_bagyo()] function
#' @param ... Additional [print()] arguments
#'
#' @returns Printed output of [get_bagyo()] function
#'
#' @export
#'

print.bagyo <- function(x, ...) {
  cat("\n\tFeatured Bagyo\n\n", sep = "")
  cat(
    "Name:", format(x$name, width = 10, justify = "left"),
    "RSMC Name:", format(x$rsmc_name, width = 0, justify = "left"),
    "\n\n"
  )
  cat(
    "Year:", format(as.character(x$year), width = 5, justify = "left"),
    "Category Code:", format(x$category_code, width = 5, justify = "left"),
    "Category Name: ", format(x$category_name, width = 5, justify = "left"),
    "\n\n"
  )
  cat(
    "Start:", format(x$start, justify = "left"),
    "     ",
    "End:", format(x$end, justify = "left"),
    "\n\n"
  )
  cat(
    "Pressure:",
    format(as.character(x$pressure), justify = "left", width = 1),
    "hPa",
    "     ",
    "Speed:", format(as.character(x$speed), justify = "left", width = 1),
    "km/h",
    "\n\n"
  )
}
