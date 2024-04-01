# Retrieve and process tropical cyclones data ----------------------------------


## Load libraries ----
library(pdftools)
library(dplyr)
library(tibble)


## Download PDFs ----
urls <- paste0(
  "https://pubfiles.pagasa.dost.gov.ph/pagasaweb/files/tamss/weather/tcsummary/PAGASA_ARTC_",
  2017:2020, ".pdf"
)

Map(
  f = download.file,
  url = as.list(urls),
  destfile = as.list(
    paste0("data-raw/", 2017:2020, ".pdf")
  )
)


## 2017 data ----

df_2017 <- pdftools::pdf_data("data-raw/2017.pdf")[[24]]

df_2017 <- df_2017 |>
  dplyr::filter(y %in% c(125, 136, 148)) |>
  dplyr::pull(text) |>
  (\(x)
    {
      cbind(
        c(x[1:3], NA_character_, x[4:11], NA_character_,
          x[12:19], NA_character_, x[20:24]) |>
          (\(x) ifelse(x == "-", NA_character_, x))() |>
          matrix(ncol = 9, byrow = TRUE) |>
          (\(x) x[ , c(1:6, 8:9)])(),
        x[25:length(x)] |>
          matrix(ncol = 2, byrow = TRUE)
      )
    }
  )() |>
  rbind(
    df_2017 |>
      dplyr::filter(y %in% 159:366) |>
      dplyr::pull(text) |>
      (\(x)
        {
          cbind(
            x[1:170] |>
              (\(x) ifelse(x == "-", NA_character_, x))() |>
              (\(x) c(x[1:93], NA_character_, x[94:170]))() |>
              matrix(ncol = 9, byrow = TRUE) |>
              (\(x) x[ , c(1:6, 8:9)])(),
            x[171:length(x)] |>
              matrix(ncol = 2, byrow = TRUE)
          )
        }
      )()
  ) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x) c(
      "category", "domestic_name",
      "international_code", "international_name",
      "warning_start_date", "warning_start_time",
      "warning_end_date", "warning_end_time",
      "peak_pressure", "peak_speed"
    )
  ) |>
  dplyr::mutate(
    category_code = factor(
      category,
      levels = c("TD", "TS", "STS", "TY", "STY")
    ),
    category_name = factor(
      category,
      levels = c("TD", "TS", "STS", "TY", "STY"),
      labels = c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    ),
    domestic_name = stringr::str_to_title(domestic_name),
    international_name = stringr::str_to_title(international_name),
    warning_start = paste0(warning_start_date, "/2017") |>
      paste(warning_start_time) |>
      strptime(format = "%m/%d/%Y %I%p", tz = "PST"),
    warning_end = paste0(warning_end_date, "/2017") |>
      paste(warning_end_time) |>
      strptime(format = "%m/%d/%Y %I%p", tz = "PST"),
    dplyr::across(.cols = dplyr::starts_with("peak"), .fns = ~as.integer(.x))
  ) |>
  dplyr::select(
    category_code, category_name, domestic_name, international_name,
    warning_start, warning_end, peak_pressure, peak_speed
  )


## 2018 data ----

df_2018 <- pdftools::pdf_data("data-raw/2018.pdf")[[33]]

set1_2018 <- df_2018 |>
  dplyr::filter(y %in% 134:364) |>
  dplyr::pull(text) |>
  (\(x) x[x != "!"])() |>
  (\(x) x[x != "to"])() |>
  matrix(ncol = 11, byrow = TRUE) |>
  (\(x) x[ , c(1:6, 9:11)])() |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "warning_start_date",
        "warning_start_time", "warning_end_date", "warning_end_time",
        "peak_pressure", "peak_speed", "category_code")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "-", NA_character_, international_name
    ),
    warning_start = paste0(warning_start_date, "/2018 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    warning_end = paste0(warning_end_date, "/2018 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    dplyr::across(.cols = dplyr::starts_with("peak"), .fns = ~as.integer(.x)),
    category_code = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY")
    ),
    category_name = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY"),
      labels = c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    )
  )

set2_2018 <- df_2018 |>
  dplyr::filter(y %in% 479:709) |>
  dplyr::pull(text) |>
  (\(x) x[x != "!"])() |>
  (\(x) x[x != "to"])() |>
  (\(x) c(x[1:151], paste(x[152:153], collapse = ""), x[154:length(x)]))() |>
  matrix(ncol = 12, byrow = TRUE) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "warning_start_date",
        "warning_start_time", "warning_end_date", "warning_end_time",
        "duration_days", "duration_hours", "TCU", "TCA", "SWB", "IWS")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "-", NA_character_, international_name
    ),
    warning_start = paste0(warning_start_date, "/2018 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "PST"),
    warning_end = paste0(warning_end_date, "/2018 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "PST")
  )

df_2018 <- set1_2018 |>
  dplyr::mutate(
    warning_start = set2_2018$warning_start,
    warning_end = set2_2018$warning_end
  ) |>
  dplyr::select(
    category_code, category_name, domestic_name, international_name,
    warning_start, warning_end, peak_pressure, peak_speed
  )


## 2019 data ----

df_2019 <- pdftools::pdf_data("data-raw/2019.pdf")[[37]]

set1_2019 <- df_2019 |>
  dplyr::filter(y %in% 142:382) |>
  dplyr::pull(text) |>
  (\(x) x[x != "to"])() |>
  (\(x) c(
    x[1:2], NA_character_, x[3:23], NA_character_,
    x[24:44], NA_character_, x[45:65], NA_character_,
    x[66:130], NA_character_, x[131:length(x)]
  ))() |>
  matrix(ncol = 11, byrow = TRUE) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "international_code",
        "warning_start_date", "warning_start_time", "warning_end_date",
        "warning_end_time", "peak_pressure", "peak_speed", "peak_date",
        "peak_time")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "Unnamed", NA_character_, international_name
    ),
    international_code = stringr::str_remove_all(
      string = international_code, pattern = "\\(|\\)"
    ),
    warning_start = paste0(warning_start_date, "/2019 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    warning_end = paste0(warning_end_date, "/2019 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    dplyr::across(.cols = peak_pressure:peak_speed, .fns = ~as.integer(.x)),
    peak_time = paste0(peak_date, "/2019 ", peak_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC")
  )

set2_2019 <- df_2019 |>
  dplyr::filter(y %in% 488:728) |>
  dplyr::pull(text) |>
  (\(x) x[x != "to"])() |>
  (\(x) c(
    x[1:2], NA_character_, x[3:23], NA_character_,
    x[24:44], NA_character_, x[45:65], NA_character_,
    x[66:130], NA_character_, x[131:length(x)]
  ))() |>
  matrix(ncol = 11, byrow = TRUE) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "international_code",
        "warning_start_date", "warning_start_time", "warning_end_date",
        "warning_end_time", "duration_days", "duration_hours", "category_code",
        "landfall")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "Unnamed", NA_character_, international_name
    ),
    international_code = stringr::str_remove_all(
      string = international_code, pattern = "\\(|\\)"
    ),
    warning_start = paste0(warning_start_date, "/2019 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    warning_end = paste0(warning_end_date, "/2019 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    category_code = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY")
    ),
    category_name = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY"),
      labels = c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    )
  )

df_2019 <- set1_2019 |>
  dplyr::mutate(
    warning_start = set2_2019$warning_start,
    warning_end = set2_2019$warning_end,
    category_code = set2_2019$category_code,
    category_name = set2_2019$category_name
  ) |>
  dplyr::select(
    category_code, category_name, domestic_name, international_name,
    warning_start, warning_end, peak_pressure, peak_speed
  )


## 2020 data ----

df_2020 <- pdftools::pdf_data("data-raw/2020.pdf")[[35]]

set1_2020 <- df_2020 |>
  dplyr::filter(y %in% 158:400) |>
  dplyr::pull(text) |>
  (\(x) x[x != "to"])() |>
  (\(x) c(
    x[1:24], NA_character_, x[25:67], NA_character_,
    x[68:154], NA_character_, x[155:length(x)]
  ))() |>
  matrix(ncol = 11, byrow = TRUE) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "international_code",
        "warning_start_date", "warning_start_time", "warning_end_date",
        "warning_end_time", "peak_speed", "peak_pressure", "peak_date",
        "peak_time")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "Unnamed", NA_character_, international_name
    ),
    international_code = stringr::str_remove_all(
      string = international_code, pattern = "\\(|\\)"
    ),
    warning_start = paste0(warning_start_date, "/2020 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    warning_end = paste0(warning_end_date, "/2020 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    dplyr::across(.cols = peak_pressure:peak_speed, .fns = ~as.integer(.x)),
    peak_time = paste0(peak_date, "/2020 ", peak_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC")
  )

set2_2020 <- df_2020 |>
  dplyr::filter(y %in% 495:737) |>
  dplyr::pull(text) |>
  (\(x) x[x != "to"])() |>
  (\(x) c(
    x[1:71], NA_character_, x[72:81], NA_character_,
    x[82:146], NA_character_, x[147:length(x)]
  ))() |>
  (\(x) c(
    x[1:24], NA_character_, x[25:67], NA_character_,
    x[68:154], NA_character_, x[155:length(x)]
  ))() |>
  matrix(ncol = 11, byrow = TRUE) |>
  data.frame() |>
  tibble::tibble() |>
  dplyr::rename_with(
    .fn = function(x)
      c("domestic_name", "international_name", "international_code",
        "warning_start_date", "warning_start_time", "warning_end_date",
        "warning_end_time", "duration_days", "duration_hours", "category_code",
        "landfall")
  ) |>
  dplyr::mutate(
    international_name = ifelse(
      international_name == "Unnamed", NA_character_, international_name
    ),
    international_code = stringr::str_remove_all(
      string = international_code, pattern = "\\(|\\)"
    ),
    warning_start = paste0(warning_start_date, "/2020 ", warning_start_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    warning_end = paste0(warning_end_date, "/2020 ", warning_end_time) |>
      strptime(format = "%m/%d/%Y %H", tz = "UTC"),
    category_code = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY")
    ),
    category_name = factor(
      category_code,
      levels = c("TD", "TS", "STS", "TY", "STY"),
      labels = c(
        "Tropical Depression", "Tropical Storm", "Severe Tropical Storm",
        "Typhoon", "Super Typhoon"
      )
    )
  )

df_2020 <- set1_2020 |>
  dplyr::mutate(
    warning_start = set2_2020$warning_start,
    warning_end = set2_2020$warning_end,
    category_code = set2_2020$category_code,
    category_name = set2_2020$category_name
  ) |>
  dplyr::select(
    category_code, category_name, domestic_name, international_name,
    warning_start, warning_end, peak_pressure, peak_speed
  )


## Concatenate ----
tropical_cyclones <- rbind(df_2017, df_2018, df_2019, df_2020) |>
  dplyr::mutate(
    year = lubridate::year(warning_start), .before = category_code
  ) |>
  dplyr::rename(
    name = domestic_name,
    rsmc_name = international_name,
    start = warning_start,
    end = warning_end,
    pressure = peak_pressure,
    speed = peak_speed
  )

## Export data ----
usethis::use_data(tropical_cyclones, overwrite = TRUE, compress = "xz")


