temperature\_climatechange\_prep
================

Prepare Pressure Layer - Sea Surface Temperature Climate Change pressure
========================================================================

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Loading required package: DBI

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')
```

    ## Warning: package 'rprojroot' was built under R version 3.2.4

``` r
source('~/github/bhi/baltic2015/prep/common.r')

## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')


# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))

dir_tempcc    = file.path(dir_prep, 'pressures/climate_change/temperature_climatechange')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_tempcc, 'temperature_climatechange_prep.rmd') 
```

1. Background
-------------

2. Data
-------

Summer (July-Aug) sea surface temperature (SST, 0-5 m) by basin.

### 2.1 Data source

Data are from the [BALTSEM model](http://www.balticnest.org/balticnest/thenestsystem/baltsem.4.3186f824143d05551ad20ea.html), run by Bärbel Müller Karulis from the Baltic Sea Centre at Stockholm University.

### 2.2 Hindcast

### 2.3 Projections

3. Pressure model
-----------------

### 3.1 Current conditions

Current conditions = mean summer SST 2010-2014
- Use hindcast data??

### 3.2 rescaling data

min value = mininium summer SST duing reference period (1960-1990)

max value = maximum SST during the future projection period (2020-2050)

### 3.3 BHI region pressure

Apply basin values to BHI regions.

4. Prepate Data Layer
---------------------
