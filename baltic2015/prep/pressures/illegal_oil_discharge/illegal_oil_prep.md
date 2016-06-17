illegal\_oil\_prep
================

Prep of Illegal Oil Spill pressure data layer
=============================================

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



dir_oil    = file.path(dir_prep, 'pressures/illegal_oil_discharge')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_oil, 'illegal_oil_prep.rmd') 
```

1. Background
-------------

2. Data
-------

### 2.1 Data source

Data were downloaded from [HELCOM's Baltic Sea Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html). Data were under the tab 'Maritime & Response' then 'Illegal Oil Discharges'

Data were downloaded on 17 March 2016.

Data are available from 1998-2014.

Data are listed with a location (lat, lon) and a Estimated spill volume. Sometimes spill area is also provided.

3. Pressure model
-----------------

Assign all spill locations a BHI ID. Sum the total volume of illegal oil spilled in each BHI region in each year.
Note- if there are reported spills without volume - how to include??

### 3.1 Current conditions

Mean volume spilled in each BHI region 2000-2014

### 3.2 Rescaling 0 to 1

min value = 0

max value = max annual volume spilled in any BHI region 1998-2014

4. Data Layer preparation
-------------------------

Steps:
1. Get a BHI region assignment for all oil spill reports - do this by overlaying lat, lon locations with BHI shapefile
2. Get volume spilled by year by BHI region (also visualize number of spills per year per BHI region, number of spills with zero volumne reported)
3. Get current conditions, find max value, rescale data to between 0 and 1
4. Export and register data layer
