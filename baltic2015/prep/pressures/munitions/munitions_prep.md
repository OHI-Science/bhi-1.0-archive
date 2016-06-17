munitions\_prep
================

Preparation of Munitions pressure data layer
============================================

These data need to be explored before can be determined to be a useful pressure layer.

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



dir_mun    = file.path(dir_prep, 'pressures/munitions')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_mun, 'munitions_prep.rmd')
```

1. Background
-------------

Legacy of munitions dumping in the Baltic Sea.

2. Data
-------

### 2.1 Data source

Multiple shape files downloaded from [HELCOM's Baltic Sea Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html).

Under 'Pressures and Human Activities' then under 'Dumped chemical munitions'

Downloaded 17 March 2016

### 2.2 Data layers

1.  Areas where sea dumped chemical warfare materials have been encountered
2.  Chemical munition transport routes to dumpsites
3.  Chemical weapons dumpsites in the Baltic Sea
4.  Emergency relocation areas for netted sea dumped chemical warfare material
5.  Reported encounters with chemical warfare materials 1961 to 2012
6.  Suspected en route dumping areas

### 2.3 Data formats

Different data layers hae different formats: areas (polygons), points, tracks.

Unclear how best to combine.

### 2.4 Data exploration Needed

Need to plot evaluate information associated with each data layer available.

3. Pressure model
-----------------

Option: total area in in BHI region associated with one or more munitions impact.

### 3. 1 Current conditions

Percent of BHI area with one or more munitions impact.

### 3.2 Rescaling between 0 to 1

min value = 0

max value = BHI region with greatest percent munitions impact

Layer prep
----------
