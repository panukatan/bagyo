## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bagyo)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

## ----summary1-----------------------------------------------------------------
## Get number of cyclone categories per year ----
bagyo |>
  group_by(year, category_name) |>
  count() |>
  group_by(year) |>
  complete(category_name) |>
  ungroup()

## ----summary2-----------------------------------------------------------------
## Get yearly mean cyclone pressure and speed ----
bagyo |>
  group_by(year) |>
  summarise(mean_pressure = mean(pressure), mean_speed = mean(speed))

## ----summary3-----------------------------------------------------------------
## Get cyclone category mean pressure and speed ----
bagyo |>
  group_by(category_name) |>
  summarise(
    n = n(),
    mean_pressure = mean(pressure), 
    mean_speed = mean(speed)
  )

## ----working-with-dates1------------------------------------------------------
## Get cyclone category mean duration (in hours) ----
bagyo |>
  mutate(duration = end - start) |>
  group_by(category_name) |>
  summarise(mean_duration = mean(duration))

## ----working-with-dates2------------------------------------------------------
## Get number of cyclones per month by year ----
bagyo |>
  mutate(month = month(start, label = TRUE)) |>
  group_by(month, year) |>
  count() |>
  ungroup() |>
  complete(month, year, fill = list(n = 0)) |>
  arrange(year, month)

## ----barplot, fig.align = "center", fig.height = 4----------------------------
## Get cyclone category mean duration (in hours) ----
bagyo |>
  mutate(duration = end - start) |>
  group_by(category_name) |>
  summarise(mean_duration = mean(duration)) |>
  ggplot(mapping = aes(x = mean_duration, y = category_name)) +
  geom_col(colour = "#4b876e", fill = "#4b876e", alpha = 0.5) +
  labs(
    title = "Mean duration of cyclones",
    subtitle = "By cyclone categories",
    x = "mean duration (hours)",
    y = NULL
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank()
  )

## ----scatterplot1, fig.align = "center", fig.height = 5, fig.width = 8--------
## Cyclone speed by presssure ----
bagyo |>
  dplyr::mutate(year = factor(year)) |>
  ggplot(mapping = aes(x = speed, y = pressure)) +
  geom_point(mapping = aes(colour = category_name), size = 3, alpha = 0.5) +
  scale_colour_manual(
    name = NULL,
    values = c("#9c5e60", "#4b876e", "#465b92", "#e5be72", "#5d0505")
  ) +
  labs(
    title = "Cyclone maximum sustained wind speed and maximum central pressure",
    subtitle = "By cyclone categories and year",
    x = "wind speed (km/h)",
    y = "central pressure (hPa)"
  ) +
  facet_wrap(. ~ year, ncol = 4) +
  theme_bw() +
  theme(
    legend.position = "top",
    strip.background = element_rect(
      fill = alpha("#465b92", 0.7), colour = "#465b92"
    ),
    panel.border = element_rect(colour = "#465b92"),
    panel.grid.minor = element_blank()
  )

## ----scatterplot2, fig.align = "center", fig.height = 5-----------------------
bagyo |>
  mutate(
    year = factor(year),
    duration = as.numeric(end - start)
  ) |>
  ggplot(mapping = aes(x = speed, y = duration)) +
  geom_point(
    mapping = aes(colour = year, shape = year), size = 3, alpha = 0.5
  ) +
  geom_smooth(
    mapping = aes(colour = year), method = "lm", se = FALSE, linewidth = 0.75
  ) +
  scale_colour_manual(
    values = c("#9c5e60", "#4b876e", "#465b92", "#e5be72")
  ) +
  scale_shape_manual(values = 15:18) +
  labs(
    title = "Maximum sustained wind speed by duration of cyclones",
    subtitle = "2017-2020",
    x = "speed (km/h)", y = "duration (hours)",
    colour = "Year", shape = "Year"
  ) +
  theme_minimal() +
  theme(legend.position = "top")

## ----time-series, fig.align = "center", fig.height = 4, fig.width = 8---------
## Get number of cyclones per month by year and plot ----
bagyo |>
  mutate(month = month(start, label = TRUE)) |>
  group_by(month, year) |>
  count() |>
  ungroup() |>
  complete(month, year, fill = list(n = 0)) |>
  arrange(year, month) |>
  ggplot(mapping = aes(x = month, y = n)) +
  geom_col(colour = "#4b876e", fill = "#4b876e", alpha = 0.5) +
  scale_y_continuous(breaks = seq(from = 0, to = 6, by = 1)) +
  labs(
    title = "Number of cyclones over time",
    subtitle = "2017-2020",
    x = NULL,
    y = "n"
  ) +
  facet_wrap(. ~ year, ncol = 4) +
  theme_bw() +
  theme(
    strip.background = element_rect(
      fill = alpha("#465b92", 0.7), colour = "#465b92"
    ),
    panel.border = element_rect(colour = "#465b92"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(size = 10, angle = 90, hjust = 1, vjust = 0.5)
  )

## ----boxplot, fig.align = "center"--------------------------------------------
bagyo |>
  mutate(year = factor(year)) |>
  ggplot(mapping = aes(x = year, y = speed)) +
  geom_boxplot(colour = "#4b876e", fill = "#4b876e", alpha = 0.5) +
  labs(
    title = "Distribution of tropical cyclone maximum sustained wind speed",
    subtitle = "2017-2022",
    x = NULL, y = "speed (km/h)"
  ) +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank())

## ----boxplot-jitter, fig.align = "center"-------------------------------------
bagyo |>
  mutate(year = factor(year)) |>
  ggplot(mapping = aes(x = year, y = speed)) +
  geom_boxplot(colour = "#4b876e") +
  geom_jitter(
    colour = "#4b876e", fill = "#4b876e", alpha = 0.5,
    shape = 21, size = 2, width = 0.2
  ) +
  labs(
    title = "Distribution of tropical cyclone maximum sustained wind speed",
    subtitle = "2017-2022",
    x = NULL, y = "speed (km/h)"
  ) +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank())

## ----violin-jitter, fig.align = "center"--------------------------------------
bagyo |>
  mutate(year = factor(year)) |>
  ggplot(mapping = aes(x = year, y = speed)) +
  geom_violin(colour = "#4b876e", fill = "#4b876e", alpha = 0.5) +
  geom_jitter(colour = "#4b876e", size = 3, width = 0.2) +
  labs(
    title = "Distribution of tropical cyclone maximum sustained wind speed",
    subtitle = "2017-2022",
    x = NULL, y = "speed (km/h)"
  ) +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank())

