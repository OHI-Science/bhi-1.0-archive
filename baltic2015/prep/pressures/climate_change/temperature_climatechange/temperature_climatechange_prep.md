temperature\_climatechange\_prep
================

Prepare Pressure Layer - Sea Surface Temperature Climate Change pressure
========================================================================

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

dir_tempcc    = file.path(dir_prep, 'pressures/climate_change/temperature_climatechange')
dir_cc    = file.path(dir_prep, 'pressures/climate_change')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_tempcc, 'temperature_climatechange_prep.rmd') 
```

1. Background
-------------

2. Data
-------

Summer (July-Aug) sea surface temperature (SST, 0-5 m) by basin.

### 2.1 Data source

Data are from the [BALTSEM model](http://www.balticnest.org/balticnest/thenestsystem/baltsem.4.3186f824143d05551ad20ea.html), run by Bärbel Müller Karulis from the Baltic Sea Centre at Stockholm University.

### 2.2 Hindcast

### 2.3 Projections

There are two different projection scenarios.

One set of projection scenarios use BALTSEM results run with forcing from the [ECHAM5](http://www.mpimet.mpg.de/en/science/models/echam/) global climate model for the scenario A1b. Project goes to year 2100.

The second set of projection scenarios use BALTSEM results run with forcing from the [HADCM3](http://www.metoffice.gov.uk/research/modelling-systems/unified-model/climate-models/hadcm3) global climate model for the scenario A1b. Projection goes to year 2099.

3. Pressure model
-----------------

### 3.1 Current conditions

Current conditions = mean summer SST 2010-2014
Use the hindcast data

### 3.2 rescaling data

Climate projections are for increased temperature. Greater pressure with higher temperature.

min value = mininium summer SST duing reference period (1960-1990)

max value = maximum SST during the future projection period (2020-2050)

### 3.3 BHI region pressure

Apply basin values to BHI regions.

4. Prepate Data Layer
---------------------

### 4.1 Read in data

``` r
## read in data

hind_sst = read.csv(file.path(dir_tempcc, 'temp_data_database/hind_sst.csv'))

proj_sst = read.csv(file.path(dir_tempcc,'temp_data_database/proj_sst.csv')) ## projection from echam5

proj2_sst = read.csv(file.path(dir_tempcc,'temp_data_database/proj2_sst.csv')) ##projection from hadcm3
```

### 4.2 Plot data

``` r
ggplot(hind_sst)+
  geom_line(aes(year,sst_jul_aug)) + 
  facet_wrap(~basin_name_holas)+
  ggtitle("Hindcast SST time series")
```

    ## Warning: Removed 2 rows containing missing values (geom_path).

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20data-1.png)<!-- -->

``` r
ggplot(proj_sst)+
  geom_line(aes(year,sst_jul_aug)) + 
  facet_wrap(~basin_name_holas)+
  ggtitle("Projected A1b SST time series ECHAM5")
```

    ## Warning: Removed 2 rows containing missing values (geom_path).

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20data-2.png)<!-- -->

``` r
ggplot(proj2_sst)+
  geom_line(aes(year,sst_jul_aug)) + 
  facet_wrap(~basin_name_holas)+
  ggtitle("Projected A1b SST time series HADCM3")
```

    ## Warning: Removed 2 rows containing missing values (geom_path).

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20data-3.png)<!-- -->

### 4.3 Clean data

``` r
## remove where year is NA - these are for basins from baltsem not used
hind_sst %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sst_jul_aug
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
hind_sst = hind_sst %>%
           filter(!is.na(year))


proj_sst %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sst_jul_aug
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
proj_sst = proj_sst %>%
           filter(!is.na(year))


proj2_sst %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sst_jul_aug
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
proj2_sst = proj2_sst %>%
           filter(!is.na(year))
```

### 4.3 Current conditions 2010-2014

Five most recent years

``` r
max_year = hind_sst %>%
           select(year)%>%
           max()%>%
           as.numeric()

sst_current = hind_sst %>%
              filter(year >= (max_year-4))%>%
              select(basin_name_holas,sst_jul_aug)%>%
              group_by(basin_name_holas)%>%
              summarise(current_sst = mean(sst_jul_aug))%>%
              ungroup()
              

sst_current
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas current_sst
    ##                    (fctr)       (dbl)
    ## 1               Aland Sea    16.01649
    ## 2            Arkona Basin    18.30592
    ## 3      Bay of Mecklenburg    18.30592
    ## 4          Bornholm Basin    17.76797
    ## 5            Bothnian Bay    15.31162
    ## 6            Bothnian Sea    16.01649
    ## 7   Eastern Gotland Basin    18.95239
    ## 8            Gdansk Basin    17.76797
    ## 9              Great Belt    18.25153
    ## 10        Gulf of Finland    18.80333
    ## 11           Gulf of Riga    19.07293
    ## 12               Kattegat    18.44557
    ## 13               Kiel Bay    18.38652
    ## 14 Northern Baltic Proper    18.95239
    ## 15              The Quark    16.01649
    ## 16              The Sound    18.20104
    ## 17  Western Gotland Basin    18.95239

### 4.4.1 Plot Current condition

``` r
ggplot(sst_current)+
  geom_point(aes(basin_name_holas, current_sst), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean SST 2010-2014 from hindcast time series")
```

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20current%20condition-1.png)<!-- -->

### 4.5 Historic Min

From Hindcast data, extract the minimum Jul-Aug SST for each basin between 1960-1990

``` r
hist_min = hind_sst %>%
           filter(year >= 1960 & year <= 1990)%>%
           select(basin_name_holas,sst_jul_aug)%>%
           group_by(basin_name_holas)%>%
           summarise(hist_min = min(sst_jul_aug))%>%
           ungroup()

hist_min
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas hist_min
    ##                    (fctr)    (dbl)
    ## 1               Aland Sea 12.20052
    ## 2            Arkona Basin 14.39512
    ## 3      Bay of Mecklenburg 14.39512
    ## 4          Bornholm Basin 14.09698
    ## 5            Bothnian Bay 11.53649
    ## 6            Bothnian Sea 12.20052
    ## 7   Eastern Gotland Basin 14.57497
    ## 8            Gdansk Basin 14.09698
    ## 9              Great Belt 15.24938
    ## 10        Gulf of Finland 13.60346
    ## 11           Gulf of Riga 15.14278
    ## 12               Kattegat 14.89529
    ## 13               Kiel Bay 15.68411
    ## 14 Northern Baltic Proper 14.57497
    ## 15              The Quark 12.20052
    ## 16              The Sound 14.99148
    ## 17  Western Gotland Basin 14.57497

### 4.6 Future max

From projection data, extract the maximum Jul-Aug SST for each basin between 2020-2050.

Do for each of the projection datasets

``` r
future_max1 = proj_sst %>%
             filter(year >= 2020 & year <= 2050)%>%
             select(basin_name_holas,sst_jul_aug)%>%
             group_by(basin_name_holas)%>%
             summarise(future_max = max(sst_jul_aug))%>%
             ungroup()
future_max1
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas future_max
    ##                    (fctr)      (dbl)
    ## 1               Aland Sea   16.80924
    ## 2            Arkona Basin   18.98328
    ## 3      Bay of Mecklenburg   18.98328
    ## 4          Bornholm Basin   18.24436
    ## 5            Bothnian Bay   16.63948
    ## 6            Bothnian Sea   16.80924
    ## 7   Eastern Gotland Basin   18.85925
    ## 8            Gdansk Basin   18.24436
    ## 9              Great Belt   18.77748
    ## 10        Gulf of Finland   18.30973
    ## 11           Gulf of Riga   19.70075
    ## 12               Kattegat   18.59230
    ## 13               Kiel Bay   19.39270
    ## 14 Northern Baltic Proper   18.85925
    ## 15              The Quark   16.80924
    ## 16              The Sound   18.77648
    ## 17  Western Gotland Basin   18.85925

``` r
future_max2 = proj2_sst %>%
             filter(year >= 2020 & year <= 2050)%>%
             select(basin_name_holas,sst_jul_aug)%>%
             group_by(basin_name_holas)%>%
             summarise(future_max = max(sst_jul_aug))%>%
             ungroup()
future_max2
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas future_max
    ##                    (fctr)      (dbl)
    ## 1               Aland Sea   19.46610
    ## 2            Arkona Basin   20.87886
    ## 3      Bay of Mecklenburg   20.87886
    ## 4          Bornholm Basin   20.98053
    ## 5            Bothnian Bay   18.10057
    ## 6            Bothnian Sea   19.46610
    ## 7   Eastern Gotland Basin   21.96635
    ## 8            Gdansk Basin   20.98053
    ## 9              Great Belt   20.64271
    ## 10        Gulf of Finland   20.97725
    ## 11           Gulf of Riga   22.86933
    ## 12               Kattegat   20.47663
    ## 13               Kiel Bay   21.51768
    ## 14 Northern Baltic Proper   21.96635
    ## 15              The Quark   19.46610
    ## 16              The Sound   20.67413
    ## 17  Western Gotland Basin   21.96635

### 4.7 Plot min, max, and current

``` r
##join data for plot
sst_data = full_join(sst_current,hist_min, by="basin_name_holas")%>%
            full_join(.,future_max1, by="basin_name_holas")%>%
            full_join(.,future_max2, by="basin_name_holas") %>%
            dplyr::rename(future_echam5=future_max.x,
                          future_hadcm3 = future_max.y) %>%
            gather(temp_type, temperature, -basin_name_holas)

ggplot(sst_data)+
  geom_point(aes(basin_name_holas,temperature, colour = temp_type, shape=temp_type), size=2)+
  scale_shape_manual(values=c(19,19,17,19))+
  scale_colour_manual(values = c("black","red","orange","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Basin Jul-Aug SST Historic Min, Current, Future Max")
```

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20min,%20max,%20current-1.png)<!-- -->

### 4.8 Rescale data for pressure layer

Some current temperatures are warmer than the near future max if use the ECHAM5 projection. HADCM3 places current temperatures more in the middle of the range.

**Use HADCM3 projection**

``` r
 sst_rescale = sst_data%>%
               spread(.,temp_type,temperature)%>%
               mutate(sst_rescale = pmin(1,(current_sst - hist_min) / (future_hadcm3 - hist_min)))

 sst_rescale
```

    ## Source: local data frame [17 x 6]
    ## 
    ##          basin_name_holas current_sst future_echam5 future_hadcm3 hist_min
    ##                    (fctr)       (dbl)         (dbl)         (dbl)    (dbl)
    ## 1               Aland Sea    16.01649      16.80924      19.46610 12.20052
    ## 2            Arkona Basin    18.30592      18.98328      20.87886 14.39512
    ## 3      Bay of Mecklenburg    18.30592      18.98328      20.87886 14.39512
    ## 4          Bornholm Basin    17.76797      18.24436      20.98053 14.09698
    ## 5            Bothnian Bay    15.31162      16.63948      18.10057 11.53649
    ## 6            Bothnian Sea    16.01649      16.80924      19.46610 12.20052
    ## 7   Eastern Gotland Basin    18.95239      18.85925      21.96635 14.57497
    ## 8            Gdansk Basin    17.76797      18.24436      20.98053 14.09698
    ## 9              Great Belt    18.25153      18.77748      20.64271 15.24938
    ## 10        Gulf of Finland    18.80333      18.30973      20.97725 13.60346
    ## 11           Gulf of Riga    19.07293      19.70075      22.86933 15.14278
    ## 12               Kattegat    18.44557      18.59230      20.47663 14.89529
    ## 13               Kiel Bay    18.38652      19.39270      21.51768 15.68411
    ## 14 Northern Baltic Proper    18.95239      18.85925      21.96635 14.57497
    ## 15              The Quark    16.01649      16.80924      19.46610 12.20052
    ## 16              The Sound    18.20104      18.77648      20.67413 14.99148
    ## 17  Western Gotland Basin    18.95239      18.85925      21.96635 14.57497
    ## Variables not shown: sst_rescale (dbl)

### 4.9 Assign basin values to BHI regions

#### 4.9.1 Read in lookup for BHI regions

``` r
bhi_holas_lookup = read.csv(file.path(dir_cc, 'baltic_rgns_to_bhi_rgns_lookup_holas.csv'), sep=";")%>%
                   select(rgn_id, basin_name)
```

#### 4.9.2 join lookup for BHI regions to sst\_rescale

``` r
sst_rescale = sst_rescale %>%
              full_join(., bhi_holas_lookup, by=c("basin_name_holas" = "basin_name"))%>%
              select(rgn_id,sst_rescale)%>%
              dplyr::rename(pressure_score = sst_rescale)%>%
              arrange(rgn_id)
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factors with
    ## different levels, coercing to character vector

#### 4.9.3 Plot rescaled SST by BHI ID

``` r
ggplot(sst_rescale)+
  geom_point(aes(rgn_id,pressure_score), size=2.5)+
  ylim(0,1)+
   ggtitle("SST pressure data layer")
```

![](temperature_climatechange_prep_files/figure-markdown_github/plot%20sst%20by%20bhi%20id-1.png)<!-- -->

### 4.10 Write to layers

``` r
write.csv(sst_rescale, file.path(dir_layers, 'cc_sst_bhi2015.csv' ), row.names=FALSE)
```
