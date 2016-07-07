tr\_prep.rmd
================

-   [Prepare Data Layers for Tourism and Recreation (TR) Goal](#prepare-data-layers-for-tourism-and-recreation-tr-goal)
    -   [1. Background](#background)
    -   [2. Data](#data)
    -   [3. Goal Model](#goal-model)
    -   [4. Data Layer Preparation](#data-layer-preparation)
        -   [4. Data clean and organize](#data-clean-and-organize)
    -   [5. Prepare and Save Data Layers](#prepare-and-save-data-layers)
    -   [6. Explore Status and Trend calculation](#explore-status-and-trend-calculation)
    -   [7. Issues or Concerns](#issues-or-concerns)

Prepare Data Layers for Tourism and Recreation (TR) Goal
========================================================

1. Background
-------------

2. Data
-------

3. Goal Model
-------------

4. Data Layer Preparation
-------------------------

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 3.2.5

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
```

    ## Warning: package 'tidyr' was built under R version 3.2.5

``` r
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Warning: package 'RMySQL' was built under R version 3.2.5

    ## Loading required package: DBI

    ## Warning: package 'DBI' was built under R version 3.2.5

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


dir_tr    = file.path(dir_prep, 'TR')



## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_tr, 'tr_prep.rmd') 
```

### 4. Data clean and organize

#### 4.1 Read in data

5. Prepare and Save Data Layers
-------------------------------

6. Explore Status and Trend calculation
---------------------------------------

7. Issues or Concerns
---------------------
