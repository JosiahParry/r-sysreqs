
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sysreqs

The goal of sysreqs is to make it easy to identify R package system
dependencies. There are two components to this package: an “API” and a
wrapper package.

This API and package is based on
[`rstudio/r-system-requirements`](https://github.com/rstudio/r-system-requirements)
and the API client for [RStudio Package
Manager](https://www.rstudio.com/products/package-manager/). The
functionality is inspired by \[`pak::pkg_system_requirements()`\].

## Installation

This package can be installed from github.

``` r
remotes::install_github("josiahparry/r-sysreqs")
```

## Usage

The primary function is `get_pkg_sysreqs()` this will return a named
list for each system dependency identified where each element is a named
list for each required system library containing the dependencies,
recommended pre-installation and post-installation commands. This
function works for only one package at a time.

``` r
library(sysreqs)

get_pkg_sysreqs("igraph", os = "ubuntu", "16.04")
#> $glpk
#> $glpk$dependencies
#> [1] "libglpk-dev"
#> 
#> $glpk$pre_installs
#> [1] NA
#> 
#> $glpk$post_installs
#> [1] NA
#> 
#> 
#> $gmp
#> $gmp$dependencies
#> [1] "libgmp3-dev"
#> 
#> $gmp$pre_installs
#> [1] NA
#> 
#> $gmp$post_installs
#> [1] NA
#> 
#> 
#> $libxml2
#> $libxml2$dependencies
#> [1] "libxml2-dev"
#> 
#> $libxml2$pre_installs
#> [1] NA
#> 
#> $libxml2$post_installs
#> [1] NA
```

If you seek the dependencies for multiple packages use
`get_pkgs_sysreqs()`.

``` r
get_pkgs_sysreqs(
  c("rJava", "igraph", "rgdal", "spdep"),
  "ubuntu", "16.04"
)
#> # A tibble: 8 × 5
#>   pkg    name    dependencies pre_installs post_installs   
#>   <chr>  <chr>   <list>       <list>       <chr>           
#> 1 rJava  gnumake <chr [1]>    <chr [1]>    <NA>            
#> 2 rJava  java    <chr [1]>    <chr [1]>    R CMD javareconf
#> 3 igraph glpk    <chr [1]>    <chr [1]>    <NA>            
#> 4 igraph gmp     <chr [1]>    <chr [1]>    <NA>            
#> 5 igraph libxml2 <chr [1]>    <chr [1]>    <NA>            
#> 6 rgdal  gdal    <chr [2]>    <chr [3]>    <NA>            
#> 7 rgdal  proj    <chr [1]>    <chr [1]>    <NA>            
#> 8 spdep  <NA>    <chr [1]>    <chr [1]>    <NA>
```

Additionally, if you want to retrieve the json simply parses as a list
without any helpers, please use the various `fetch_*()` functions.

-   `fetch_systems()`: supported operating systems
-   `fetch_patterns()`: the regex patterns to identify system
    dependencies
-   `fetch_pkg()`: returns package information (name, version, and
    system requirements as written in the DESCRIPTION
-   `fetch_rules()`: returns the rules for a given system library
-   `fetch_pkg_deps()`: returns the matched system dependencies

## The API

Access to the R system dependency data that are available from
[`rstudio/r-system-requirements`](https://github.com/rstudio/r-system-requirements)
is made available by a simple plain-text website hosted at
[`r-sysdeps.josiahparry.com`](https://r-sysdeps.josiahparry.com). The
sysreq package makes calls to that url to fetch information

Contents:

-   [`patterns`](patterns.json) is used as a look-up table for identify
    system dependencies
-   [`systems`](systems.json) provides a list of available operating
    systems (limited to linux distributions)
-   [`/rules`](rules/index.html) is a directory containing the lookup
    rools for each system dependencies requirements
    e.g. `rules/gdal.json`
-   [`/pkgs`](pkgs/index.html) is a directory containing json files for
    each package listing their name, version, and system dependencies
    e.g. `pkgs/igraph.json`
