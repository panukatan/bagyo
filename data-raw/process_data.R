# Retrieve and process tropical cyclones data ----------------------------------

## 2017 data ----

download.file(
  url = "https://pubfiles.pagasa.dost.gov.ph/pagasaweb/files/tamss/weather/tcsummary/PAGASA_ARTC_2017.pdf",
  destfile = "data-raw/2017.pdf"
)

df_2017 <- pdftools::pdf_data("data-raw/2017.pdf")[[24]]

df_2017 |>
  dplyr::filter(y %in% c(125, 136, 148)) |>
  dplyr::pull(text) |>
  (\(x)
    {
      cbind(
        c(x[1:3], NA_character_, x[4:11], NA_character_,
          x[12:19], NA_character_, x[20:24]) |>
          (\(x) ifelse(x == "-", NA_character_, x))() |>
          matrix(ncol = 9, byrow = TRUE),
        x[25:length(x)] |>
          matrix(ncol = 2, byrow = TRUE)
      )
    }
  )() |>
 |>
  (\(x)
    {
      rbind(
        x[1, c(1:5, 7:8)],
        c(x[1, 9:10], x[2, c(1:3, 5:6)]),
        c(x[2, 7:10], x[3, c(1, 3:4)])
      ) |>
        cbind(
          x[3, c(5, 7, 9)],
          x[3, c(6, 8, 10)]
        ) |>
        data.frame() |>
        tibble::tibble() |>
        (\(x)
          {
            names(x) <- c(
              "category", "domestic_name", "international_name",
              "warning_period_start_date", "warning_period_start_time",
              "warning_period_end_date", "warning_period_end_time",
              "peak_pressure", "peak_speed"
            )
            x
          }
        )()
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
  dplyr::mutate(
    category_code = factor(
      category,
      levels = c("TD", "TS", "STS", "TY", "STY")
    ),
    category_name = factor(
      category,
      levels = c("TD", "TS", "STS", "TY", "STY"),
      labels = c(
        "Tropical Depression", "Tropical Storm", "Severe Tropicl Storm",
        "Typhoon", "Super Typhoon"
      )
    ),
    domestic_name = stringr::str_to_title(domestic_name),
    international_name = ifelse(
      international_name == "-", NA_character_, international_name
    ),
    warning_period_start = paste0(warning_period_start_date, "/2017") |>
      paste(warning_period_start_time) |>
      strptime(format = "%m/%d/%Y %I%p", tz = "PST"),
    warning_period_end = paste0(warning_period_end_date, "/2017") |>
      paste(warning_period_end_time) |>
      strptime(format = "%m/%d/%Y %I%p", tz = "PST")
  )


