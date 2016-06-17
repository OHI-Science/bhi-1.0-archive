salinity\_climatechange\_prep
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



dir_salincc    = file.path(dir_prep, 'pressures/climate_change/salinity_climatechange')
dir_cc    = file.path(dir_prep, 'pressures/climate_change')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_salincc, 'salinity_climatechange_prep.rmd') 
```

1. Background
-------------

2. Data
-------

Annual surface water salinity (0-5 m) by basin.
Annual deep water salinity (50 m) by basin.

### 2.1 Data source

Data are from the [BALTSEM model](http://www.balticnest.org/balticnest/thenestsystem/baltsem.4.3186f824143d05551ad20ea.html), run by Bärbel Müller Karulis from the Baltic Sea Centre at Stockholm University.

### 2.2 Hindcast

### 2.3 Projections

3. Pressure model
-----------------

Two data layer, surface water salinity and deep water salinity. Each use the same current condition and rescaling procedure below.

### 3.1 Current conditions

Current conditions = mean salinity 2010-2014
- Use hindcast data

### 3.2 rescaling data

Salinity is projected to decrease with climate change, therefore we take the maximum from the historical period and the minimum from the current period. Will need to confirm this works for the deep salinity measure given the role of periodic inflows.

min value = minimum annual salinity during the future projection period (2020-2050)

max value = maximum annual salinity duing reference period (1960-1990)

**Greater pressure with lower salinity, so will need to take the inverse of the rescaling**

### 3.3 BHI region pressure

Apply basin values to BHI regions.

4 Prepare surface salinity Data layer
-------------------------------------

### 4.1 Read in surface salinity data

``` r
## read in data

hind_surf_sal = read.csv(file.path(dir_salincc, 'sal_data_database/hind_sal_surf.csv'))

proj_surf_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj_sal_surf.csv'))
```

### 4.2 Clean data

``` r
## remove where year is NA - these are for basins from baltsem not used
hind_surf_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_surface
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
hind_surf_sal = hind_surf_sal %>%
           filter(!is.na(year))


proj_surf_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_surface
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
proj_surf_sal = proj_surf_sal %>%
           filter(!is.na(year))
```

### 4.3 Plot data

``` r
ggplot(hind_surf_sal)+
  geom_line(aes(year,sal_surface)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Hindcast Annual Surface Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-1.png)<!-- -->

``` r
ggplot(proj_surf_sal)+
  geom_line(aes(year,sal_surface)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Surface Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-2.png)<!-- -->

### 4.4 Current conditions 2010-2014

Five most recent years

``` r
max_year = hind_surf_sal %>%
           select(year)%>%
           max()%>%
           as.numeric()

surf_sal_current = hind_surf_sal %>%
              filter(year >= (max_year-4))%>%
              select(basin_name_holas,sal_surface)%>%
              group_by(basin_name_holas)%>%
              summarise(current_surf_sal = mean(sal_surface))%>%
              ungroup()
              

surf_sal_current
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas current_surf_sal
    ##                    (fctr)            (dbl)
    ## 1               Aland Sea         5.791983
    ## 2            Arkona Basin        16.401680
    ## 3      Bay of Mecklenburg        16.401680
    ## 4          Bornholm Basin        13.612713
    ## 5            Bothnian Bay         3.522564
    ## 6            Bothnian Sea         5.791983
    ## 7   Eastern Gotland Basin        10.636945
    ## 8            Gdansk Basin        13.612713
    ## 9              Great Belt        33.538734
    ## 10        Gulf of Finland         8.189126
    ## 11           Gulf of Riga         5.553209
    ## 12               Kattegat        34.442408
    ## 13               Kiel Bay        32.783958
    ## 14 Northern Baltic Proper        10.636945
    ## 15              The Quark         5.791983
    ## 16              The Sound        33.321046
    ## 17  Western Gotland Basin        10.636945

### 4.4.1 Plot Current condition

``` r
ggplot(surf_sal_current)+
  geom_point(aes(basin_name_holas, current_surf_sal), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Surface Salinity 2010-2014 from hindcast time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20current%20surface%20sal%20condition-1.png)<!-- -->

### 4.5 Minimum val

From projection data, extract the minimum annual surface salinity for each basin between 2020-2050

``` r
min_surf_sal = proj_surf_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_surface)%>%
           group_by(basin_name_holas)%>%
           summarise(min_surf_sal = min(sal_surface))%>%
           ungroup()

min_surf_sal
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_surf_sal
    ##                    (fctr)        (dbl)
    ## 1               Aland Sea     6.050936
    ## 2            Arkona Basin    15.071741
    ## 3      Bay of Mecklenburg    15.071741
    ## 4          Bornholm Basin    13.326296
    ## 5            Bothnian Bay     3.630166
    ## 6            Bothnian Sea     6.050936
    ## 7   Eastern Gotland Basin    11.079354
    ## 8            Gdansk Basin    13.326296
    ## 9              Great Belt    32.167874
    ## 10        Gulf of Finland     7.377814
    ## 11           Gulf of Riga     6.008234
    ## 12               Kattegat    34.496253
    ## 13               Kiel Bay    29.847152
    ## 14 Northern Baltic Proper    11.079354
    ## 15              The Quark     6.050936
    ## 16              The Sound    31.671227
    ## 17  Western Gotland Basin    11.079354

### 4.6 Maximum surface sal

From hindcast data, extract the maximum annual surface temperature for each basin between 1960-1990

``` r
max_surf_sal = hind_surf_sal %>%
             filter(year >= 1960 & year <= 1990)%>%
             select(basin_name_holas,sal_surface)%>%
             group_by(basin_name_holas)%>%
             summarise(max_surf_sal = max(sal_surface))%>%
             ungroup()
max_surf_sal
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas max_surf_sal
    ##                    (fctr)        (dbl)
    ## 1               Aland Sea     6.931835
    ## 2            Arkona Basin    18.598887
    ## 3      Bay of Mecklenburg    18.598887
    ## 4          Bornholm Basin    17.198359
    ## 5            Bothnian Bay     4.338411
    ## 6            Bothnian Sea     6.931835
    ## 7   Eastern Gotland Basin    13.036406
    ## 8            Gdansk Basin    17.198359
    ## 9              Great Belt    33.434824
    ## 10        Gulf of Finland    10.552085
    ## 11           Gulf of Riga     6.768972
    ## 12               Kattegat    34.763078
    ## 13               Kiel Bay    32.577922
    ## 14 Northern Baltic Proper    13.036406
    ## 15              The Quark     6.931835
    ## 16              The Sound    33.132088
    ## 17  Western Gotland Basin    13.036406

### 4.7 Plot min, max, and current

``` r
##join data for plot
surf_sal_data = full_join(surf_sal_current,min_surf_sal, by="basin_name_holas")%>%
            full_join(.,max_surf_sal, by="basin_name_holas")

ggplot(surf_sal_data)+
  geom_point(aes(basin_name_holas, min_surf_sal),color="blue",size=2.5)+
   geom_point(aes(basin_name_holas, current_surf_sal),color="black",size=2.5)+
   geom_point(aes(basin_name_holas,max_surf_sal),color="red",size=2.5)+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Basin Annual Surface Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surf%20sal%20min,%20max,%20current-1.png)<!-- -->

### 4.8 Rescale data for pressure layer

Some current surface salinities are greater than past max and others are fresher than current min
1. Normalize data
2. if below zero set to zero (eg if current is fresher than min value) and if above 1 set to 1 (eg if current is more saline than max value)
3. Take inverse so greater pressure with fresher conditions

``` r
 surf_sal_rescale = surf_sal_data%>%
               mutate(surf_sal_normalize = (current_surf_sal - min_surf_sal) / (max_surf_sal - min_surf_sal),
                      surf_sal_rescale = ifelse(surf_sal_normalize <0, 0,
                                         ifelse(surf_sal_normalize > 1, 1,surf_sal_normalize)),
                      surf_sal_rescale_inv = 1- surf_sal_rescale) ## take inverse 

 surf_sal_rescale
```

    ## Source: local data frame [17 x 7]
    ## 
    ##          basin_name_holas current_surf_sal min_surf_sal max_surf_sal
    ##                    (fctr)            (dbl)        (dbl)        (dbl)
    ## 1               Aland Sea         5.791983     6.050936     6.931835
    ## 2            Arkona Basin        16.401680    15.071741    18.598887
    ## 3      Bay of Mecklenburg        16.401680    15.071741    18.598887
    ## 4          Bornholm Basin        13.612713    13.326296    17.198359
    ## 5            Bothnian Bay         3.522564     3.630166     4.338411
    ## 6            Bothnian Sea         5.791983     6.050936     6.931835
    ## 7   Eastern Gotland Basin        10.636945    11.079354    13.036406
    ## 8            Gdansk Basin        13.612713    13.326296    17.198359
    ## 9              Great Belt        33.538734    32.167874    33.434824
    ## 10        Gulf of Finland         8.189126     7.377814    10.552085
    ## 11           Gulf of Riga         5.553209     6.008234     6.768972
    ## 12               Kattegat        34.442408    34.496253    34.763078
    ## 13               Kiel Bay        32.783958    29.847152    32.577922
    ## 14 Northern Baltic Proper        10.636945    11.079354    13.036406
    ## 15              The Quark         5.791983     6.050936     6.931835
    ## 16              The Sound        33.321046    31.671227    33.132088
    ## 17  Western Gotland Basin        10.636945    11.079354    13.036406
    ## Variables not shown: surf_sal_normalize (dbl), surf_sal_rescale (dbl),
    ##   surf_sal_rescale_inv (dbl)

### 4.9 Assign basin values to BHI regions

#### 4.9.1 Read in lookup for BHI regions

``` r
bhi_holas_lookup = read.csv(file.path(dir_cc, 'baltic_rgns_to_bhi_rgns_lookup_holas.csv'), sep=";")%>%
                   select(rgn_id, basin_name)
```

#### 4.9.2 join lookup for BHI regions to sst\_rescale

``` r
 surf_sal_rescale = surf_sal_rescale %>%
              full_join(., bhi_holas_lookup, by=c("basin_name_holas" = "basin_name"))%>%
              select(rgn_id,surf_sal_rescale_inv)%>%
              dplyr::rename(pressure_score = surf_sal_rescale_inv)%>%
              arrange(rgn_id)
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factors with
    ## different levels, coercing to character vector

#### 4.9.3 Plot rescaled surface salinity by BHI ID

``` r
ggplot(surf_sal_rescale)+
  geom_point(aes(rgn_id,pressure_score), size=2.5)+
   ggtitle("Surface Salinity pressure data layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20salinity%20pressure%20by%20bhi%20id-1.png)<!-- -->

### 4.10 Write surface salinity to layers

``` r
write.csv(surf_sal_rescale, file.path(dir_layers, 'cc_sal_surf_bhi2015.csv' ), row.names=FALSE)
```

5 Prepare deep salinity Data layer
----------------------------------

### 5.1 Read in deep salinity data

``` r
## read in data

hind_deep_sal = read.csv(file.path(dir_salincc, 'sal_data_database/hind_sal_deep.csv'))

proj_deep_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj_sal_deep.csv'))
```

### 5.2 Clean data

``` r
## remove where year is NA - these are for basins from baltsem not used
hind_deep_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_deep
    ## 1                   Northern Kattegat                NK   NA       NA
    ## 2                   Southern Kattegat                SK   NA       NA
    ##   salin_bottom_depth
    ## 1                100
    ## 2                 70

``` r
hind_deep_sal = hind_deep_sal %>%
           filter(!is.na(year))


proj_deep_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_deep
    ## 1                   Northern Kattegat                NK   NA       NA
    ## 2                   Southern Kattegat                SK   NA       NA
    ##   salin_bottom_depth
    ## 1                100
    ## 2                 70

``` r
proj_deep_sal = proj_deep_sal %>%
           filter(!is.na(year))
```

### 5.3 Plot data

``` r
ggplot(hind_deep_sal)+
  geom_line(aes(year,sal_deep, colour=factor(salin_bottom_depth))) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Hindcast Annual Deep Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-1.png)<!-- -->

``` r
ggplot(proj_deep_sal)+
  geom_line(aes(year,sal_deep,colour=factor(salin_bottom_depth))) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Deep Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-2.png)<!-- -->

### 5.4 Current conditions 2010-2014

Five most recent years

``` r
max_year = hind_deep_sal %>%
           select(year)%>%
           max()%>%
           as.numeric()

deep_sal_current = hind_deep_sal %>%
              filter(year >= (max_year-4))%>%
              select(basin_name_holas,sal_deep)%>%
              group_by(basin_name_holas)%>%
              summarise(current_deep_sal = mean(sal_deep))%>%
              ungroup()
              

deep_sal_current
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas current_deep_sal
    ##                    (fctr)            (dbl)
    ## 1               Aland Sea         5.791983
    ## 2            Arkona Basin        16.401680
    ## 3      Bay of Mecklenburg        16.401680
    ## 4          Bornholm Basin        13.612713
    ## 5            Bothnian Bay         3.522564
    ## 6            Bothnian Sea         5.791983
    ## 7   Eastern Gotland Basin        10.636945
    ## 8            Gdansk Basin        13.612713
    ## 9              Great Belt        33.538734
    ## 10        Gulf of Finland         8.189126
    ## 11           Gulf of Riga         5.553209
    ## 12               Kattegat        34.442408
    ## 13               Kiel Bay        32.783958
    ## 14 Northern Baltic Proper        10.636945
    ## 15              The Quark         5.791983
    ## 16              The Sound        33.321046
    ## 17  Western Gotland Basin        10.636945

### 5.5.1 Plot Current condition

``` r
ggplot(deep_sal_current)+
  geom_point(aes(basin_name_holas, current_deep_sal), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Deep Salinity 2010-2014 from hindcast time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20current%20deep%20sal%20condition-1.png)<!-- -->

### 5.5 Minimum val

From projection data, extract the minimum annual deep salinity for each basin between 2020-2050

``` r
min_deep_sal = proj_deep_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_deep)%>%
           group_by(basin_name_holas)%>%
           summarise(min_deep_sal = min(sal_deep))%>%
           ungroup()

min_deep_sal
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_deep_sal
    ##                    (fctr)        (dbl)
    ## 1               Aland Sea     6.050936
    ## 2            Arkona Basin    15.071741
    ## 3      Bay of Mecklenburg    15.071741
    ## 4          Bornholm Basin    13.326296
    ## 5            Bothnian Bay     3.630166
    ## 6            Bothnian Sea     6.050936
    ## 7   Eastern Gotland Basin    11.079354
    ## 8            Gdansk Basin    13.326296
    ## 9              Great Belt    32.167874
    ## 10        Gulf of Finland     7.377814
    ## 11           Gulf of Riga     6.008234
    ## 12               Kattegat    34.496253
    ## 13               Kiel Bay    29.847152
    ## 14 Northern Baltic Proper    11.079354
    ## 15              The Quark     6.050936
    ## 16              The Sound    31.671227
    ## 17  Western Gotland Basin    11.079354

### 5.6 Maximum deep sal

From hindcast data, extract the maximum annual deep temperature for each basin between 1960-1990

``` r
max_deep_sal = hind_deep_sal %>%
             filter(year >= 1960 & year <= 1990)%>%
             select(basin_name_holas,sal_deep)%>%
             group_by(basin_name_holas)%>%
             summarise(max_deep_sal = max(sal_deep))%>%
             ungroup()
max_deep_sal
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas max_deep_sal
    ##                    (fctr)        (dbl)
    ## 1               Aland Sea     6.931835
    ## 2            Arkona Basin    18.598887
    ## 3      Bay of Mecklenburg    18.598887
    ## 4          Bornholm Basin    17.198359
    ## 5            Bothnian Bay     4.338411
    ## 6            Bothnian Sea     6.931835
    ## 7   Eastern Gotland Basin    13.036406
    ## 8            Gdansk Basin    17.198359
    ## 9              Great Belt    33.434824
    ## 10        Gulf of Finland    10.552085
    ## 11           Gulf of Riga     6.768972
    ## 12               Kattegat    34.763078
    ## 13               Kiel Bay    32.577922
    ## 14 Northern Baltic Proper    13.036406
    ## 15              The Quark     6.931835
    ## 16              The Sound    33.132088
    ## 17  Western Gotland Basin    13.036406

### 5.7 Plot min, max, and current

``` r
##join data for plot
deep_sal_data = full_join(deep_sal_current,min_deep_sal, by="basin_name_holas")%>%
            full_join(.,max_deep_sal, by="basin_name_holas")

ggplot(deep_sal_data)+
  geom_point(aes(basin_name_holas, min_deep_sal),color="blue",size=2.5)+
   geom_point(aes(basin_name_holas, current_deep_sal),color="black",size=2.5)+
   geom_point(aes(basin_name_holas,max_deep_sal),color="red",size=2.5)+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Basin Annual Deep Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20min,%20max,%20current-1.png)<!-- -->

### 5.8 Rescale data for pressure layer

Some current deep salinities are greater than past max and others are fresher than current min
1. Normalize data
2. if below zero set to zero (eg if current is fresher than min value) and if above 1 set to 1 (eg if current is more saline than max value)
3. Take inverse so greater pressure with fresher conditions

``` r
 deep_sal_rescale = deep_sal_data%>%
               mutate(deep_sal_normalize = (current_deep_sal - min_deep_sal) / (max_deep_sal - min_deep_sal),
                      deep_sal_rescale = ifelse(deep_sal_normalize <0, 0,
                                         ifelse(deep_sal_normalize > 1, 1,deep_sal_normalize)),
                      deep_sal_rescale_inv = 1- deep_sal_rescale) ## take inverse 

 deep_sal_rescale
```

    ## Source: local data frame [17 x 7]
    ## 
    ##          basin_name_holas current_deep_sal min_deep_sal max_deep_sal
    ##                    (fctr)            (dbl)        (dbl)        (dbl)
    ## 1               Aland Sea         5.791983     6.050936     6.931835
    ## 2            Arkona Basin        16.401680    15.071741    18.598887
    ## 3      Bay of Mecklenburg        16.401680    15.071741    18.598887
    ## 4          Bornholm Basin        13.612713    13.326296    17.198359
    ## 5            Bothnian Bay         3.522564     3.630166     4.338411
    ## 6            Bothnian Sea         5.791983     6.050936     6.931835
    ## 7   Eastern Gotland Basin        10.636945    11.079354    13.036406
    ## 8            Gdansk Basin        13.612713    13.326296    17.198359
    ## 9              Great Belt        33.538734    32.167874    33.434824
    ## 10        Gulf of Finland         8.189126     7.377814    10.552085
    ## 11           Gulf of Riga         5.553209     6.008234     6.768972
    ## 12               Kattegat        34.442408    34.496253    34.763078
    ## 13               Kiel Bay        32.783958    29.847152    32.577922
    ## 14 Northern Baltic Proper        10.636945    11.079354    13.036406
    ## 15              The Quark         5.791983     6.050936     6.931835
    ## 16              The Sound        33.321046    31.671227    33.132088
    ## 17  Western Gotland Basin        10.636945    11.079354    13.036406
    ## Variables not shown: deep_sal_normalize (dbl), deep_sal_rescale (dbl),
    ##   deep_sal_rescale_inv (dbl)

### 5.9 Assign basin values to BHI regions

#### 5.9.1 Read in lookup for BHI regions

Done above in 4.9.1

#### 5.9.2 join lookup for BHI regions to sst\_rescale

``` r
 deep_sal_rescale = deep_sal_rescale %>%
              full_join(., bhi_holas_lookup, by=c("basin_name_holas" = "basin_name"))%>%
              select(rgn_id,deep_sal_rescale_inv)%>%
              dplyr::rename(pressure_score = deep_sal_rescale_inv)%>%
              arrange(rgn_id)
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factors with
    ## different levels, coercing to character vector

#### 5.9.3 Plot rescaled deep salinity by BHI ID

``` r
ggplot(deep_sal_rescale)+
  geom_point(aes(rgn_id,pressure_score), size=2.5)+
   ggtitle("Deep Salinity pressure data layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20salinity%20pressure%20by%20bhi%20id-1.png)<!-- -->

### 5.10 Write deep salinity to layers

``` r
write.csv(deep_sal_rescale, file.path(dir_layers, 'cc_sal_deep_bhi2015.csv' ), row.names=FALSE)
```
