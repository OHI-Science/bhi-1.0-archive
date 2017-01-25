shapefile\_prep
================

Overview of BHI shapefile development
=====================================

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



dir_shape    = file.path(dir_prep, 'shapefile')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_shape, 'shapefile_prep.rmd')
```

1. Background
-------------

This document details the development of the BHI shape file and associated 25km buffer. The BHI regions combined HELCOM HOLAS basins with country EEZ regions. Each BHI region is therefore associated with a single country and a single Baltic Sea basin. There are 42 BHI regions in total.

NOTE: insert links to the HELCOM HOLAS basin file and EEZ file sources

2. Data
-------

3. Shapefile methods
--------------------

How did we achieve this shapefile.......

4. Buffer methods
-----------------

How did we achieve the buffer methods.............
