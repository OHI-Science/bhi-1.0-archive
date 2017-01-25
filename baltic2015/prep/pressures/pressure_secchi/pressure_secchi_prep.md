pressure\_secchi\_prep.rmd
================

-   [Prepare water clarity pressure data layer (using secchi data)](#prepare-water-clarity-pressure-data-layer-using-secchi-data)
    -   [1. Background](#background)
    -   [2. Data](#data)
    -   [3. Pressure model](#pressure-model)
    -   [4. Prepare pressure layer](#prepare-pressure-layer)
        -   [4.1 Read in NUT status layer](#read-in-nut-status-layer)
        -   [4.2 Transform status from 0-100 value to 0-1 value](#transform-status-from-0-100-value-to-0-1-value)
        -   [4.3 Inverse of NUT status for pressure layer](#inverse-of-nut-status-for-pressure-layer)
        -   [4.4 Plot pressure layer](#plot-pressure-layer)
    -   [5. Prepare and save object to layers](#prepare-and-save-object-to-layers)
        -   [5.1 Prepare object](#prepare-object)
        -   [5.2 Save object](#save-object)

Prepare water clarity pressure data layer (using secchi data)
=============================================================

1. Background
-------------

Water clarity / transparency is a direct pressure on Lasting Special Places and Tourism as it affects people's perception of aesthetic properties of nature.

2. Data
-------

[Data sources and data preparation are found in the CW subgoal NUT](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/CW/secchi/secchi_prep.md) which uses secchi data as a measure of nutrient status.

3. Pressure model
-----------------

This pressure layer is the inverse of the NUT goal status for the most recent year. This varies among basins (the scale at which the status is calculated). The most recent year is 2013 for all basins except: Aland Sea (2012), Bothian Sea(2011), Great Belt (2009), Gulf of Finland (2012), Gulf of Riga (2012),The Quark (2012).

4. Prepare pressure layer
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
## source common libraries, directories, functions, etc
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


dir_pres_sec    = file.path(dir_prep,'pressures/pressure_secchi')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_pres_sec, 'pressure_secchi_prep.rmd')  
```

### 4.1 Read in NUT status layer

``` r
nut_status = read.csv(file.path(dir_layers, "cw_nu_status_bhi2015.csv"))
```

### 4.2 Transform status from 0-100 value to 0-1 value

``` r
nut_status1 = nut_status %>%
              mutate(score = score /100)
```

### 4.3 Inverse of NUT status for pressure layer

``` r
inv_secchi = nut_status1 %>%
             mutate(pressure_score = 1- score)%>%
             select(rgn_id,pressure_score)
```

### 4.4 Plot pressure layer

``` r
ggplot(inv_secchi)+
  geom_point(aes(rgn_id, pressure_score), size = 2.5)+
  ylab("Pressure value")+
  ylim(0,1)+
  ggtitle("Water clarity pressure score")
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](pressure_secchi_prep_files/figure-markdown_github/plot%20inverse%20secchi%20pressure%20layer-1.png)

5. Prepare and save object to layers
------------------------------------

### 5.1 Prepare object

``` r
inv_secchi
```

    ##    rgn_id pressure_score
    ## 1       1           0.00
    ## 2       2           0.00
    ## 3       3           0.06
    ## 4       4           0.06
    ## 5       5             NA
    ## 6       6             NA
    ## 7       7           0.19
    ## 8       8           0.19
    ## 9       9           0.13
    ## 10     10           0.13
    ## 11     11           0.07
    ## 12     12           0.07
    ## 13     13           0.07
    ## 14     14           0.00
    ## 15     15           0.00
    ## 16     16           0.00
    ## 17     17           0.00
    ## 18     18           0.17
    ## 19     19           0.17
    ## 20     20           0.08
    ## 21     21           0.08
    ## 22     22           0.08
    ## 23     23           0.08
    ## 24     24           0.08
    ## 25     25           0.08
    ## 26     26           0.35
    ## 27     27           0.30
    ## 28     28           0.30
    ## 29     29           0.24
    ## 30     30           0.24
    ## 31     31           0.24
    ## 32     32           0.11
    ## 33     33           0.11
    ## 34     34           0.11
    ## 35     35           0.28
    ## 36     36           0.28
    ## 37     37             NA
    ## 38     38           0.29
    ## 39     39           0.03
    ## 40     40           0.03
    ## 41     41           0.22
    ## 42     42           0.22

### 5.2 Save object

``` r
write.csv(inv_secchi, file.path(dir_layers, 'po_inverse_secchi_bhi2015.csv'), row.names = FALSE)
```
