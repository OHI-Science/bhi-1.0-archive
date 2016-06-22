bottom\_trawling\_prep
================

Bottom Trawling Pressure Layer
==============================

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




dir_trawl    = file.path(dir_prep, 'pressures/bottom_trawling')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_trawl, 'bottom_trawling_prep.rmd') 
```

1. Background
-------------

2. Data
-------

### 2.1 Data sources

[HELCOM Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html) under 'Pressures and Human Activities' then 'Fisheries' then 'Effort' - there are 8 data layers on \*fishing effort mobile bottom-contacting ground'.

### 2.2 Data attributes

Layers are quarterly effort.
Units are in hours fished.

3. Pressure Model
-----------------

Overlay trawl effort with BHI shape files so can assign effort per each BHI region.

### 3.1 Current pressure data

Trawl\_quarterly = sum hours within a BHI region / area of BHI region (hours/km2)

Xtrawl\_r\_y = annual hours / km2 = sum quarters in each year *y* in each region *r* to get total (hours/km2)

Xtrawl\_r = mean of hours / km2 across years

### 3.2 Rescale data

min value = 0

max value = max(quarterly hours/km2 across all regions) multipled by 4 = max annual

4. Prepare bottom trawl pressure layer
--------------------------------------
