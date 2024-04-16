
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bagyo: Philippine Tropical Cyclones Data <img src="man/figures/logo.png" width="200" align="right" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/panukatan/bagyo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/panukatan/bagyo/actions/workflows/R-CMD-check.yaml)
[![R-hub](https://github.com/panukatan/bagyo/actions/workflows/rhub.yaml/badge.svg)](https://github.com/panukatan/bagyo/actions/workflows/rhub.yaml)
[![test-coverage](https://github.com/panukatan/bagyo/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/panukatan/bagyo/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/panukatan/bagyo/branch/main/graph/badge.svg)](https://app.codecov.io/gh/panukatan/bagyo?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/panukatan/bagyo/badge)](https://www.codefactor.io/repository/github/panukatan/bagyo)
[![DOI](https://zenodo.org/badge/314686124.svg)](https://zenodo.org/doi/10.5281/zenodo.10972234)
<!-- badges: end -->

Oceans and seas significantly impact continental weather, with
evaporation from the sea surface driving cloud formation and
precipitation. Tropical cyclones, warm-core low-pressure systems, form
over warm oceans where temperatures exceed 26°C, precipitated by the
release of latent heat from condensation. These cyclones, known by
various names depending on the region, have organised circulations and
develop primarily in tropical and subtropical waters, except in regions
with cooler sea surface temperatures and high vertical wind shears. They
reach peak intensity over warm tropical waters and weaken upon landfall,
often causing extensive damage before dissipating.

The Philippines frequently experiences tropical cyclones (called
***bagyo*** - pronounced /baɡˈjo/, \[bɐɡˈjo\] - in the Filipino
language) because of its geographical position. These cyclones typically
bring heavy rainfall, leading to widespread flooding, as well as strong
winds that cause significant damage to human life, crops, and property.
Data on cyclones are collected and curated by the [Philippine
Atmospheric, Geophysical, and Astronomical Services Administration
(PAGASA)](https://www.pagasa.dost.gov.ph/).

This package contains Philippine tropical cyclones data from 2017 to
2020 in a machine-readable format. It is hoped that this data package
provides an interesting and unique dataset for data exploration and
visualisation as an adjunct to the traditional
[`iris`](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html)
dataset and to the current
[`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/)
dataset.

## Installation

`bagyo` is not yet on CRAN but can be installed from the [panukatan R
universe](https://panukatan.r-universe.dev) as follows:

``` r
install.packages(
  "bagyo",
  repos = c('https://panukatan.r-universe.dev', 'https://cloud.r-project.org')
)
```

Once the `bagyo` package has been installed, the `bagyo` dataset can be
loaded into R as follows:

``` r
library(bagyo)
data(package = "bagyo")

bagyo
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

### `bagyo` is interesting to summarise

``` r
library(dplyr)

## Get cyclone category mean pressure and speed ----
bagyo |>
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

### `bagyo` is useful in learning how to work with dates

``` r
## Get cyclone category mean duration (in hours) ----
bagyo |>
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

### `bagyo` is great to visualise

<img src="man/figures/README-barplot-1.png" style="display: block; margin: auto;" />

<img src="man/figures/README-scatterplot-1.png" style="display: block; margin: auto;" />

## Citation

If you find the `bagyo` package useful please cite using the suggested
citation provided by a call to the `citation()` function as follows:

``` r
citation("bagyo")
#> To cite bagyo in publications use:
#> 
#>   Ernest Guevarra (2024). _bagyo: Philippine Tropical Cyclones Data_.
#>   doi:10.5281/zenodo.10972235
#>   <https://doi.org/10.5281/zenodo.10972235>, R package version 0.1.0,
#>   <https://panukatan.io/bagyo/>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {bagyo: Philippine Tropical Cyclones Data},
#>     author = {{Ernest Guevarra}},
#>     year = {2024},
#>     note = {R package version 0.1.0},
#>     url = {https://panukatan.io/bagyo/},
#>     doi = {10.5281/zenodo.10972235},
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
