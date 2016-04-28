open\_sea\_anoxia\_prep
================

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
dir_prep = make_path('baltic2015/prep') # replaces  file.path(dir_baltic, 'layers')


# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))



dir_anox   = file.path(dir_prep, 'pressures/open_sea_anoxia')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_anox, 'open_sea_anoxia_prep.rmd') 
```

1. Background on open sea anoxia data
-------------------------------------

### 1.1 Why anoxia?

2. Anoxia data
--------------

### 2.1 Data source

#### 2.1.1 Anoxia data layer

These data are from [Carstensen et al. 2014](http://www.pnas.org/content/111/15/5628.abstract). Jacob Carstensen provided dbf files containing O2 (mg⋅L−1) for a series of years for the Baltic Proper and the Gulf of Finland.

Other areas are not included in this study but at the present time have no anoxia problems - therefore they will recieve a pressure value of 0.

#### 2.1.2 Bathymetry

.....TO DO

3. Open sea anoxia spatial data scale
-------------------------------------

We will work on the BHI region scale. O2 rasters and Batlic bathymetry will be overlayed on BHI regions. Different approaches will be used for BHI regions in the Baltic Proper and in the Gulf of Finland.

In "baltic\_rgns\_to\_bhi\_rgns\_lookup\_holas\_basins.csv" in "~2015\_sea\_anoxia" the BHI regions associated with the Baltic Proper and Gulf of Finland are listed.

4. Open sea anoxia data rescaling
---------------------------------

Note, we may need to treat the Baltic Proper and the Gulf of Finland separately. In the Baltic Proper there is a strong halocline at 70m and it is the anoxic area below the halocline that is of interest (therefore we focus on areas with depths &gt;= 70). In the Gulf of Finland, there a less strong halocline and thermal stratification is important so we may have to think differently about which areas to focus on.

### 4.1 Current value

    - Baltic Proper BHI regions =  of area >= 70m deep the area with O2 <0 mg⋅L−1  
        - Need to decide if use most recent year (2014) or mean of recent years
    - Gulf of Finland BHI regions =   

### 4.2 Max value

    - Baltic Proper BHI regions =  total area >= 70m depth  
    - Gulf of Finland BHI regions =   

### 4.3 Min value

     - Baltic Proper BHI regions =  of area >= 70m deep the area with O2 <0 mg⋅L−1  in 1906  
     - Gulf of Finland BHI regions = 

5. Open Sea Anoxia layer prep
-----------------------------
