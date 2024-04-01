
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bagyo: Philippine Tropical Cyclones Data <img src="man/figures/logo.png" width="200" align="right" />

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/panukatan/bagyo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/panukatan/bagyo/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/panukatan/bagyo/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/panukatan/bagyo/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/panukatan/bagyo/branch/main/graph/badge.svg)](https://app.codecov.io/gh/panukatan/bagyo?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/panukatan/bagyo/badge)](https://www.codefactor.io/repository/github/panukatan/bagyo)
<!-- badges: end -->

Oceans and seas significantly impact continental weather, with
evaporation from the sea surface driving cloud formation and
precipitation. Tropical cyclones, warm-core low-pressure systems, form
over warm oceans where temperatures exceed 26°C, precipitated by the
release of latent heat from condensation. These cyclones, known by
various names depending on the region, have organized circulations and
develop primarily in tropical and subtropical waters, except in regions
with cooler sea surface temperatures and high vertical wind shears. They
reach peak intensity over warm tropical waters and weaken upon landfall,
often causing extensive damage before dissipating.

The Philippines frequently experiences tropical cyclones (called
**bagyo** in the Filipino language) because of its geographical
position. These cyclones typically bring heavy rainfall, leading to
widespread flooding, as well as strong winds that cause significant
damage to human life, crops, and property. Data on cyclones are
collected and curated by the [Philippine Atmospheric, Geophysical, and
Astronomical Services Administration
(PAGASA)](https://www.pagasa.dost.gov.ph/).

This package contains Philippine Tropical Cyclone data from 2017 to 2020
in a machine-readable format. It is hoped that this data package
provides an interesting and unique dataset for data exploration and
visualisation.

## About the `tropical_cyclones` data

The `bagyo` package contains the `tropical_cyclones` dataset. This
dataset was taken from annual reports on Philippine tropical cyclones
prepared and released by [PAGASA](https://www.pagasa.dost.gov.ph/) at
its
[website](https://www.pagasa.dost.gov.ph/tropical-cyclone/publications/annual-report)
in PDF format.

Because the reports are in PDF format and the information described
above are in tables within the documents, scripts for scraping the
desired data were developed and implemented to arrive at the
`tropical_cyclones` dataset. The data scraping script can be viewed
[here](https://github.com/panukatan/bagyo/blob/main/data-raw/process_data.R).

The following information is available from the dataset:

| **Variable**    | **Description**                                                                             |
|:----------------|:--------------------------------------------------------------------------------------------|
| *year*          | Year                                                                                        |
| *category_code* | Tropical cyclone category code                                                              |
| *category_name* | Tropical cyclone category name                                                              |
| *name*          | Name given to the tropical cyclone by Philippine authorities                                |
| *rsmc_name*     | Name given to the tropical cyclone by the Regional Specialized Meteorological Centre (RSMC) |
| *start*         | Date and time at which cyclone enters Philippine area of responsibility (PAR)               |
| *end*           | Date and time at which cyclone leaves Philippine area of responsibility (PAR)               |
| *pressure*      | Peak central pressure in *hPa*                                                              |
| *speed*         | Maximum sustained wind speed in *km/h*                                                      |

This metadata can be viewed in R through a call to `?tropical_cyclones`
in the R console.

Whilst tropical cyclones have ravaged the Philippines far earlier than
2017 and more currently than 2020, official and publicly available data
for the information described above is only available in the reports for
years 2017 to 2020. Earlier documents of this annual reporting pre-2017
have been produced but are not available on the PAGASA website. These
reports of the tropical cyclone season (re-started in 2019) are
published within two years after the termination of the season. Hence,
the most recent report is only up to 2020.

## Installation

`bagyo` is not yet on CRAN but can be installed from the [panukatan R
universe](https://panukatan.r-universe.dev) as follows:

``` r
install.packages(
  "bagyo",
  repos = c('https://panukatan.r-universe.dev', 'https://cloud.r-project.org')
)
```

Once the `bagyo` package has been installed, the `tropical_cyclones`
dataset can be loaded into R as follows:

``` r
library(bagyo)
data(package = "bagyo")

tropical_cyclones
#> # A tibble: 86 × 9
#>     year category_code category_name         name  rsmc_name start              
#>    <dbl> <fct>         <fct>                 <chr> <chr>     <dttm>             
#>  1  2017 TD            Tropical Depression   Auri… <NA>      2017-01-07 08:00:00
#>  2  2017 TD            Tropical Depression   Bisi… <NA>      2017-02-03 14:00:00
#>  3  2017 TD            Tropical Depression   Cris… <NA>      2017-04-14 14:00:00
#>  4  2017 TS            Tropical Storm        Dante Muifa     2017-04-26 08:00:00
#>  5  2017 STS           Severe Tropical Storm Emong Nanmadol  2017-07-02 02:00:00
#>  6  2017 TD            Tropical Depression   Fabi… Roke      2017-07-22 02:00:00
#>  7  2017 TY            Typhoon               Gorio Nesat     2017-07-25 14:00:00
#>  8  2017 TS            Tropical Storm        Huan… Haitang   2017-07-30 02:00:00
#>  9  2017 STS           Severe Tropical Storm Isang Hato      2017-08-20 08:00:00
#> 10  2017 TS            Tropical Storm        Joli… Pakhar    2017-08-24 14:00:00
#> # ℹ 76 more rows
#> # ℹ 3 more variables: end <dttm>, pressure <int>, speed <int>
```

## Usage

### Demonstrate tidy data wrangling

#### Tropical cyclones are interesting to summarise

``` r
library(dplyr)

## Get yearly mean cyclone pressure and speed ----
tropical_cyclones |>
  group_by(year) |>
  summarise(mean_pressure = mean(pressure), mean_speed = mean(speed))
#> # A tibble: 4 × 3
#>    year mean_pressure mean_speed
#>   <dbl>         <dbl>      <dbl>
#> 1  2017          986.       88.0
#> 2  2018          961.       66.7
#> 3  2019          976.       59.0
#> 4  2020          973.       62.0

## Get cyclone category mean pressure and speed ----
tropical_cyclones |>
  group_by(category_name) |>
  summarise(
    n = n(),
    mean_pressure = mean(pressure), 
    mean_speed = mean(speed)
  )
#> # A tibble: 5 × 4
#>   category_name             n mean_pressure mean_speed
#>   <fct>                 <int>         <dbl>      <dbl>
#> 1 Tropical Depression      23          996.       39.8
#> 2 Tropical Storm           25          986.       61.6
#> 3 Severe Tropical Storm    15          978.       75  
#> 4 Typhoon                  21          941.      102. 
#> 5 Super Typhoon             2          908.      112.
```

#### Tropical cyclones are useful in learning how to work with dates

``` r
## Get cyclone category mean duration (in hours) ----
tropical_cyclones |>
  mutate(duration = end - start) |>
  group_by(category_name) |>
  summarise(mean_duration = mean(duration))
#> # A tibble: 5 × 2
#>   category_name         mean_duration  
#>   <fct>                 <drtn>         
#> 1 Tropical Depression    46.69565 hours
#> 2 Tropical Storm         57.48000 hours
#> 3 Severe Tropical Storm  79.13333 hours
#> 4 Typhoon               106.66667 hours
#> 5 Super Typhoon          77.50000 hours
```

### Demonstrate various `ggplot2` data visualisation geoms

#### Bar plots

<img src="man/figures/README-barplot-1.png" style="display: block; margin: auto;" />

#### Scatter plots

<img src="man/figures/README-scatterplot-1.png" style="display: block; margin: auto;" />

## Citation

If you find the `bagyo` package useful please cite using the suggested
citation provided by a call to the `citation()` function as follows:

``` r
citation("bagyo")
#> To cite bagyo in publications use:
#> 
#>   Ernest Guevarra (2024). bagyo: Philippine Tropical Cyclones Data R
#>   package version 0.0.0.9000 URL https://panukatan.io/bagyo/
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {bagyo: Philippine Tropical Cyclones Data},
#>     author = {{Ernest Guevarra}},
#>     year = {2024},
#>     note = {R package version 0.0.0.9000},
#>     url = {https://panukatan.io/bagyo/},
#>   }
```

## Community guidelines

Feedback, bug reports and feature requests are welcome; file issues or
seek support [here](https://github.com/panukatan/bagyo/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://panukatan.io/bagyo/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://panukatan.io/bagyo/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.

<br> <br>
