cs\_prep
================

Carbon Storage (CS) Data prep
=============================

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
# source
source('~/github/bhi/baltic2015/prep/common.r') #for create_readme() function

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



dir_cs   = file.path(dir_prep, 'CS')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_cs, 'cs_prep.rmd') 
```

1. Background on Zostera data
-----------------------------

### 1.1 Why Zostera data

### 1.2 Zostera species in the Baltic Sea

### 1.3 Related publications

[Boström et al 2014](http://onlinelibrary.wiley.com/doi/10.1002/aqc.2424/abstract)

[HELCOM Red List Biotope Information Sheet](http://helcom.fi/Red%20List%20of%20biotopes%20habitats%20and%20biotope%20complexe/HELCOM%20Red%20List%20AA.H1B7,%20AA.I1B7,%20AA.J1B7,%20AA.M1B7.pdf)

2. Data source
--------------

### 1.1 Download information

[HELCOM Marine Spatial Planning Map Service](http://maps.helcom.fi/website/msp/index.html)
Select - Marine Spatial Planning - Ecology - Ecosystem Health status
Data layer - "Zostera Meadows"
Downloaded on 10 May 2016 by Jennifer Griffiths

[Metadata link](http://maps.helcom.fi/website/getMetadata/htm/All/Zostera%20meadows.htm)

### 2.2 Additional background

*Notes from Joni Kaitaranta (HELCOM)*: According to the Zostera meadows metadata there is many data sources. The dataset was compiled in 2009-2010 for the HOLAS I assessment so the dataset is not very recent. Major source was Boström et al. 2003. In: Spalding et al. World Atlas of Seagrasses but there was also national e.g. from NERI Denmark downloaded in 2009 from a URL that is no longer valid.

*Data Structure*: Is unclear, spatial files need to be reviewed. Is it just points, or does it include areal coverage of Zostera. Data observations are accompanies by either "dense" or "sparse."

3. CS goal model overview
-------------------------

### 3.1 Status

X\_cs\_region = Current\_area\_Zostera\_meadows\_region / Reference\_pt\_region

Reference\_pt\_region = Current\_area\_Zostera\_meadows \* 1.25
This is based upon ["During the last 50 years the distribution of the Zostera marina biotope has declined &gt;25%. The biotope has declined to varying extents in the different Baltic Sea regions."](http://helcom.fi/Red%20List%20of%20biotopes%20habitats%20and%20biotope%20complexe/HELCOM%20Red%20List%20AA.H1B7,%20AA.I1B7,%20AA.J1B7,%20AA.M1B7.pdf)

**If data are not areal coverage**: if data are simply points of presence, need to rethink goal model

### 3.2 Trend

Consider using the trend of NUT subcomponent for CW goal (e.g. secchi status trend).

Layer prep
----------