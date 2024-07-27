# Download PAGASA cyclone reports ----------------------------------------------

pagasa_download_cyclone_reports <- function(url, destfile) {
  if (!destfile %in% list.files("data-raw", full.names = TRUE)) {
    utils::download.file(url = url, destfile = destfile)
    destfile
  } else
    destfile
}
