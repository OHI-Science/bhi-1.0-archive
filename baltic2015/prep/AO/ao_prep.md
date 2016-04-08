ao\_prep.rmd
================

AO Goal Data Prep
=================

Goal Overview
-------------

### Components

This goal has three sub-components: *stock, access, and need*. For BHI we focus first on the *stock* sub-component and will use this as a proxy for the entire goal initially

### Goal model

Xao = Mean Stock Indicator Value / Reference pt
Stock indicators = three HELCOM core indicators assessed for good environemental status (each scored between 0 and 1 by BHI)
Reference pt = maximum possible good environmental status (value=1)
*Should it be the mean of the 3 indicators or the sum of the three?*

Data
----

[HELCOM Core Indicator Abundance of coastal fish key functional groups](http://helcom.fi/baltic-sea-trends/indicators/abundance-of-coastal-fish-key-functional-groups/)

[HELCOM Core Indicator Abundance of key coastal fish species](http://helcom.fi/baltic-sea-trends/indicators/abundance-of-key-coastal-fish-species)

Good Environmental Status (GES) is assessed as either *GES* or *sub-GES* based on data times series using either a baseline or a trend approach, [see explanation](http://helcom.fi/baltic-sea-trends/indicators/abundance-of-key-coastal-fish-species/good-environmental-status/). There is only a single assessment for each region.

*status qualifying comments*: for one dataset if a monitoring station receives a "sub-GES" assessment, it is given a qualifier as "low" or "high".

Environmental status assessments provided by Jens Olsson (SLU).

Data Prep
---------

### Data scoring

We will have to determine appropriate 0-1 scale for *GES* and *sub-GES*

    ## Warning: package 'readr' was built under R version 3.2.4

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Warning: package 'ggplot2' was built under R version 3.2.4

    ## Loading required package: DBI

    ## Warning: package 'rprojroot' was built under R version 3.2.4

Layer prep
----------

``` r
## read in data...
  ## data are in "ao_data_database" - currently csv loaded directly there, need to put in the database and then set up script to extract

#assessment of GES status, all 2 indicators
coastal_fish = readr::read_csv2(file.path(dir_ao, 'ao_data_database/ao_coastalfish_ges_status.csv'))

head(coastal_fish)
```

    ## Source: local data frame [6 x 11]
    ## 
    ##      Basin_HOLAS Basin_assessment   country            monitoring_area
    ##            (chr)            (chr)     (chr)                      (chr)
    ## 1   Arkona Basin     Arkona Basin   Germany                Boergerende
    ## 2  Gotland Basin    Gotland Basin    Latvia                   Jurkalne
    ## 3  Gotland Basin    Gotland Basin Lithuania          Monciskes/Butinge
    ## 4 Bornholm Basin   Bornholm Basin   Germany      Pomeranian Bay, Outer
    ## 5 Bornholm Basin   Bornholm Basin   Germany   East of Usedom Peninsula
    ## 6   Arkona Basin     Arkona Basin   Germany Northeast of Ruegen Island
    ## Variables not shown: period (chr), coastal_water_type (chr),
    ##   core_indicator (chr), taxa (chr), assessment_method (chr), status (chr),
    ##   status_comment (chr)

``` r
dim(coastal_fish)
```

    ## [1] 120  11

``` r
str(coastal_fish)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    120 obs. of  11 variables:
    ##  $ Basin_HOLAS       : chr  "Arkona Basin" "Gotland Basin" "Gotland Basin" "Bornholm Basin" ...
    ##  $ Basin_assessment  : chr  "Arkona Basin" "Gotland Basin" "Gotland Basin" "Bornholm Basin" ...
    ##  $ country           : chr  "Germany" "Latvia" "Lithuania" "Germany" ...
    ##  $ monitoring_area   : chr  "Boergerende" "Jurkalne" "Monciskes/Butinge" "Pomeranian Bay, Outer" ...
    ##  $ period            : chr  "2003-2013" "1999-2007" "1998-2011" "2003-2103" ...
    ##  $ coastal_water_type: chr  "Mecklenburg Bight German Coastal waters" "Eastern Gotland Basin Latvian Coastal waters" "Eastern Gotland Basin Lithuanian Coastal waters" "Bornholm Basin German Coastal waters" ...
    ##  $ core_indicator    : chr  "Key species" "Key species" "Key species" "Key species" ...
    ##  $ taxa              : chr  "cod" "flounder" "flounder" "flounder" ...
    ##  $ assessment_method : chr  "Trend" "Trend" "Trend" "Trend" ...
    ##  $ status            : chr  "GES" "GES" "GES" "GES" ...
    ##  $ status_comment    : chr  NA NA NA NA ...

``` r
#locations of specific monitoring stations
coastal_fish_loc = readr::read_csv2(file.path(dir_ao, 'ao_data_database/ao_coastalfish_locations.csv')) #station location info - mix of lat-lon and a shape file value so not sure if needed
 
head(coastal_fish_loc)
```

    ## Source: local data frame [6 x 7]
    ## 
    ##    station LAT__DEC_D LON__DEC_D DECWGSN DECWGSE Shape_STAr Shape_STLe
    ##      (chr)      (dbl)      (dbl)   (dbl)   (dbl)      (dbl)      (dbl)
    ## 1  Hiiumaa     585000     230000  585000  230000         NA         NA
    ## 2    Finbo     602870     196710  602870  196710         NA         NA
    ## 3 Kumlinge     602250     208190  602250  208190         NA         NA
    ## 4    Ranea     658330     224260  658330  224260         NA         NA
    ## 5  Holmoen     636820     208750  636820  208750         NA         NA
    ## 6 Forsmark     604340     181620  604340  181620         NA         NA

``` r
dim(coastal_fish_loc)
```

    ## [1] 49  7

``` r
str(coastal_fish_loc)                                  
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    49 obs. of  7 variables:
    ##  $ station   : chr  "Hiiumaa" "Finbo" "Kumlinge" "Ranea" ...
    ##  $ LAT__DEC_D: num  585000 602870 602250 658330 636820 ...
    ##  $ LON__DEC_D: num  230000 196710 208190 224260 208750 ...
    ##  $ DECWGSN   : num  585000 602870 602250 658330 636820 ...
    ##  $ DECWGSE   : num  230000 196710 208190 224260 208750 ...
    ##  $ Shape_STAr: num  NA NA NA NA NA ...
    ##  $ Shape_STLe: num  NA NA NA NA NA ...

``` r
#bhi region and HOLAS basin look up
 basin_lookup = readr::read_csv(file.path(
  dir_prep,"baltic_rgns_to_bhi_rgns_lookup_holas.csv"))
basin_lookup=basin_lookup %>% select(bhi_id = rgn_id, basin_name)%>%
  mutate(basin_name = str_replace_all(basin_name,"_"," ")) 
basin_lookup
```

    ## Source: local data frame [42 x 2]
    ## 
    ##    bhi_id         basin_name
    ##     (int)              (chr)
    ## 1       1           Kattegat
    ## 2       2           Kattegat
    ## 3       3         Great Belt
    ## 4       4         Great Belt
    ## 5       5          The Sound
    ## 6       6          The Sound
    ## 7       7           Kiel Bay
    ## 8       8           Kiel Bay
    ## 9       9 Bay of Mecklenburg
    ## 10     10 Bay of Mecklenburg
    ## ..    ...                ...

Assign scores to GES status
---------------------------

``` r
## is status ever NA?
coastal_fish %>% filter(is.na(status)) #No
```

    ## Source: local data frame [0 x 11]
    ## 
    ## Variables not shown: Basin_HOLAS (chr), Basin_assessment (chr), country
    ##   (chr), monitoring_area (chr), period (chr), coastal_water_type (chr),
    ##   core_indicator (chr), taxa (chr), assessment_method (chr), status (chr),
    ##   status_comment (chr)

``` r
## Assign three alternative 0-1 scores
  ## score 1:  GES =1, subGES = 0
  ## score 2:  GES =1, subGES = 0.2
  ## score 3:  GES =1, subGES (low)= 0.2, subGES (high)=0.5, subGES = 0.2

coastal_fish_scores = coastal_fish %>% 
                      mutate(score1 = ifelse(status== "GES",1,0),
                             score2 = ifelse(status=="GES",1,.2),
                             score3 = ifelse(status== "GES",1,
                                      ifelse(status=="subGES" & status_comment == "low",.2,
                                      ifelse(status=="subGES" & status_comment == "high",.5,.2))))

coastal_fish_scores
```

    ## Source: local data frame [120 x 14]
    ## 
    ##       Basin_HOLAS Basin_assessment   country
    ##             (chr)            (chr)     (chr)
    ## 1    Arkona Basin     Arkona Basin   Germany
    ## 2   Gotland Basin    Gotland Basin    Latvia
    ## 3   Gotland Basin    Gotland Basin Lithuania
    ## 4  Bornholm Basin   Bornholm Basin   Germany
    ## 5  Bornholm Basin   Bornholm Basin   Germany
    ## 6    Arkona Basin     Arkona Basin   Germany
    ## 7    Arkona Basin     Arkona Basin   Denmark
    ## 8    Arkona Basin     Arkona Basin   Germany
    ## 9    Arkona Basin     Arkona Basin   Germany
    ## 10   Arkona Basin     Arkona Basin   Denmark
    ## ..            ...              ...       ...
    ## Variables not shown: monitoring_area (chr), period (chr),
    ##   coastal_water_type (chr), core_indicator (chr), taxa (chr),
    ##   assessment_method (chr), status (chr), status_comment (chr), score1
    ##   (dbl), score2 (dbl), score3 (dbl)

Plot alternative scores by location
-----------------------------------

``` r
## TODO 
  ##Make coastal_fish_scores long data format, then plot
```

Unique indicators per monitoring location
-----------------------------------------

1.  Is more than one key species monitored at a given locations?
2.  Is more than one function group monitored?
3.  How should these be combined more locally before taking a basin mean?

Average scores by within an indicator (key spp or functional) by HOLAS basin
----------------------------------------------------------------------------

This is probably not correct, probably need to combine within key species at a location first?

``` r
coastal_fish_indicator_mean = coastal_fish_scores %>%
                              group_by(Basin_HOLAS,core_indicator)%>%
                              summarise(mean_score1 = mean(score1),
                                        mean_score2 = mean(score2),
                                        mean_score3 = mean(score3))%>%
                              ungroup()
```
