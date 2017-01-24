salinity\_climatechange\_prep
================

-   [1. Background](#background)
-   [2. Data](#data)
    -   [2.1 Data source](#data-source)
-   [3. Pressure model](#pressure-model)
    -   [3.1 Current conditions](#current-conditions)
    -   [3.2 rescaling data](#rescaling-data)
    -   [3.3 BHI region pressure](#bhi-region-pressure)
-   [4 Prepare surface salinity Data layer](#prepare-surface-salinity-data-layer)
    -   [4.1 Read in surface salinity data](#read-in-surface-salinity-data)
    -   [4.2 Clean data](#clean-data)
    -   [4.3 Plot data](#plot-data)
    -   [4.4 Current conditions 2010-2014](#current-conditions-2010-2014)
    -   [4.4.3 Plot Current condition - compare datasets](#plot-current-condition---compare-datasets)
    -   [4.5 Minimum val](#minimum-val)
    -   [4.6 Maximum surface sal](#maximum-surface-sal)
    -   [4.7 Plot min, max, and current](#plot-min-max-and-current)
    -   [4.8 Rescale data for pressure layer](#rescale-data-for-pressure-layer)
    -   [4.9 Assign basin values to BHI regions](#assign-basin-values-to-bhi-regions)
    -   [4.10 Write surface salinity to layers](#write-surface-salinity-to-layers)
-   [5 Prepare Deep salinity Data layer](#prepare-deep-salinity-data-layer)
    -   [5.1 Read in deep salinity data](#read-in-deep-salinity-data)
    -   [5.2 Clean data](#clean-data-1)
    -   [5.3 Plot data](#plot-data-1)
    -   [5.4 Current conditions 2010-2014](#current-conditions-2010-2014-1)
    -   [5.5.1 Plot Current condition](#plot-current-condition)
    -   [5.5 Minimum val](#minimum-val-1)
    -   [5.6 Maximum deep sal](#maximum-deep-sal)
    -   [5.7 Plot min, max, and current](#plot-min-max-and-current-1)
    -   [5.8 Rescale data for pressure layer](#rescale-data-for-pressure-layer-1)
    -   [5.10 Write deep salinity to layers](#write-deep-salinity-to-layers)

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



dir_salincc    = file.path(dir_prep, 'pressures/climate_change/salinity_climatechange')
dir_cc    = file.path(dir_prep, 'pressures/climate_change')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_salincc, 'salinity_climatechange_prep.rmd') 
```

1. Background
-------------

The Baltic Sea covers a broad salinity gradient. Climate change is expected to alter surface and deep water salinity throughout the Baltic Sea through a variety of processes including: changes in precipitation quantity and timing and changes in salt water inflows from the North Sea. Future salinity projections remain uncertain.

[Second Assessment of Climate Change for the Baltic Sea Basin](http://www.springer.com/gp/book/9783319160054)

The biodiversity gradient in the Baltic Sea reflects the salinity gradient and changes in salinity (particularly decreased salinity) are expected to place a pressure on maintaining biodiversity.

2. Data
-------

Annual surface water salinity (0-5 m) by basin.
Annual deep water salinity (50 m) by basin.

### 2.1 Data source

Data are from the [BALTSEM model](http://www.balticnest.org/balticnest/thenestsystem/baltsem.4.3186f824143d05551ad20ea.html), run by Bärbel Müller Karulis from the Baltic Sea Centre at Stockholm University.

#### 2.1.1 Datasets

\#\#\#\# 2.1.1.1 Hindcast

\#\#\#\# 2.1.1.2 Projections There are two different projection scenarios.

One set of projection scenarios use BALTSEM results run with forcing from the [ECHAM5](http://www.mpimet.mpg.de/en/science/models/echam/) global climate model for the scenario A1b. Project goes to year 2100.

The second set of projection scenarios use BALTSEM results run with forcing from the [HADCM3](http://www.metoffice.gov.uk/research/modelling-systems/unified-model/climate-models/hadcm3) global climate model for the scenario A1b. Projection goes to year 2099.

#### 2.1.2 Data to use

Data from all three above datasets have been explored. We have decided *to use the ECHAM5 dataset for all components of the pressure model (past max salinity, current salinity, future minimum salinity)*. While forecast data often captures past and future trends, specific values may not align with observed data. However, each of these datasets have different forcing and previous data exploration showed that using both hindcaset and future projection datasets was problematic given that the datasets did not track one anothers specific value. Included in the data prep are some of these data explorations.

3. Pressure model
-----------------

Two data layer, surface water salinity and deep water salinity. Each use the same current condition and rescaling procedure below.

### 3.1 Current conditions

Current conditions = mean salinity 2010-2014

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

Read in all datasets

``` r
## read in data

hind_surf_sal = read.csv(file.path(dir_salincc, 'sal_data_database/hind_sal_surf.csv'))

proj_surf_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj_sal_surf.csv')) ##echam5

proj2_surf_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj2_sal_surf.csv')) #hadcm3
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


proj2_surf_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_surface
    ## 1                   Northern Kattegat                NK   NA          NA
    ## 2                   Southern Kattegat                SK   NA          NA

``` r
proj2_surf_sal = proj2_surf_sal %>%
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

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-1.png)

``` r
ggplot(proj_surf_sal)+
  geom_line(aes(year,sal_surface)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Surface Salinity time series ECHAM5")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-2.png)

``` r
ggplot(proj2_surf_sal)+
  geom_line(aes(year,sal_surface)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Surface Salinity time series HADCM3")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-3.png)

``` r
### bind data together and plot in single plot
sal_data_plot = bind_rows(
                mutate(hind_surf_sal, sim_name = "hindcast"),
                mutate(proj_surf_sal, sim_name = "echam5"),
                mutate(proj2_surf_sal, sim_name = "hadcm3")) %>%
                arrange(basin_name_holas,sim_name,year)

ggplot(sal_data_plot)+
  geom_line(aes(year,sal_surface, colour = sim_name)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  xlim(1950,2100)+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("All Annual Surface Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20sal%20data-4.png)

### 4.4 Current conditions 2010-2014

#### 4.4.1 Current conditions if taken from the hindcast data

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
    ##                    <fctr>            <dbl>
    ## 1               Aland Sea         4.634799
    ## 2            Arkona Basin         6.844035
    ## 3      Bay of Mecklenburg         6.844035
    ## 4          Bornholm Basin         6.680249
    ## 5            Bothnian Bay         2.788640
    ## 6            Bothnian Sea         4.634799
    ## 7   Eastern Gotland Basin         6.402908
    ## 8            Gdansk Basin         6.680249
    ## 9              Great Belt        17.239578
    ## 10        Gulf of Finland         4.677351
    ## 11           Gulf of Riga         4.676581
    ## 12               Kattegat        20.185349
    ## 13               Kiel Bay        12.630705
    ## 14 Northern Baltic Proper         6.402908
    ## 15              The Quark         4.634799
    ## 16              The Sound        11.273051
    ## 17  Western Gotland Basin         6.402908

#### 4.4.2 Current conditions if taken from ECHAM5

``` r
year_range=seq(2010,2014)

surf_sal_current_echam5 =proj_surf_sal %>%
              filter(year %in% year_range)%>%
              select(basin_name_holas,sal_surface)%>%
              group_by(basin_name_holas)%>%
              summarise(current_surf_sal = mean(sal_surface))%>%
              ungroup()
              

surf_sal_current_echam5
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas current_surf_sal
    ##                    <fctr>            <dbl>
    ## 1               Aland Sea         5.366503
    ## 2            Arkona Basin         8.530967
    ## 3      Bay of Mecklenburg         8.530967
    ## 4          Bornholm Basin         7.921647
    ## 5            Bothnian Bay         3.286676
    ## 6            Bothnian Sea         5.366503
    ## 7   Eastern Gotland Basin         7.521552
    ## 8            Gdansk Basin         7.921647
    ## 9              Great Belt        18.809710
    ## 10        Gulf of Finland         5.859795
    ## 11           Gulf of Riga         5.621391
    ## 12               Kattegat        23.264056
    ## 13               Kiel Bay        13.815469
    ## 14 Northern Baltic Proper         7.521552
    ## 15              The Quark         5.366503
    ## 16              The Sound        12.928008
    ## 17  Western Gotland Basin         7.521552

### 4.4.3 Plot Current condition - compare datasets

``` r
ggplot(bind_rows(
       mutate(surf_sal_current, type = "hindcast"),
       mutate(surf_sal_current_echam5, type = "echam5")))+
  geom_point(aes(basin_name_holas, current_surf_sal, colour=type, shape=type), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Surface Salinity 2010-2014, compare time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20current%20surface%20sal%20condition-1.png)

### 4.5 Minimum val

From projection data, extract the minimum annual surface salinity for each basin between 2020-2050. Compare between the two projection data sets. ECHAM5 projects higher salinity than HADCM3, difference greatest between the two in Great Belt, Kattegat, Kiel, The Sound (which are the most variable and most saline).

``` r
min_surf_sal1 = proj_surf_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_surface)%>%
           group_by(basin_name_holas)%>%
           summarise(min_surf_sal = min(sal_surface))%>%
           ungroup()

min_surf_sal1
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_surf_sal
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     4.930861
    ## 2            Arkona Basin     8.047258
    ## 3      Bay of Mecklenburg     8.047258
    ## 4          Bornholm Basin     7.458430
    ## 5            Bothnian Bay     2.871873
    ## 6            Bothnian Sea     4.930861
    ## 7   Eastern Gotland Basin     7.055749
    ## 8            Gdansk Basin     7.458430
    ## 9              Great Belt    17.436164
    ## 10        Gulf of Finland     5.274723
    ## 11           Gulf of Riga     5.156436
    ## 12               Kattegat    22.061035
    ## 13               Kiel Bay    12.705039
    ## 14 Northern Baltic Proper     7.055749
    ## 15              The Quark     4.930861
    ## 16              The Sound    11.974787
    ## 17  Western Gotland Basin     7.055749

``` r
min_surf_sal2 = proj2_surf_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_surface)%>%
           group_by(basin_name_holas)%>%
           summarise(min_surf_sal = min(sal_surface))%>%
           ungroup()

min_surf_sal2
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_surf_sal
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     4.507619
    ## 2            Arkona Basin     7.479262
    ## 3      Bay of Mecklenburg     7.479262
    ## 4          Bornholm Basin     7.029108
    ## 5            Bothnian Bay     2.482426
    ## 6            Bothnian Sea     4.507619
    ## 7   Eastern Gotland Basin     6.688210
    ## 8            Gdansk Basin     7.029108
    ## 9              Great Belt    16.104217
    ## 10        Gulf of Finland     5.124817
    ## 11           Gulf of Riga     4.726595
    ## 12               Kattegat    20.591427
    ## 13               Kiel Bay    11.415734
    ## 14 Northern Baltic Proper     6.688210
    ## 15              The Quark     4.507619
    ## 16              The Sound    11.070839
    ## 17  Western Gotland Basin     6.688210

``` r
## difference between two model estimates

proj_diff = full_join(min_surf_sal1,min_surf_sal2,by="basin_name_holas")%>%
            dplyr::rename(min_echam5 = min_surf_sal.x,
                          min_hadcm3 = min_surf_sal.y)%>%
            mutate(proj_diff = min_echam5 - min_hadcm3)

## plot difference
ggplot(proj_diff)+
    geom_point(aes(basin_name_holas, proj_diff))+
 theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Diff in Projected Min Sal (ECHAM5 - HADCM3)")
```

![](salinity_climatechange_prep_files/figure-markdown_github/min%20surface%20sal-1.png)

### 4.6 Maximum surface sal

#### 4.6.1 Take max from hindcast dataset

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
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     5.543010
    ## 2            Arkona Basin     8.598662
    ## 3      Bay of Mecklenburg     8.598662
    ## 4          Bornholm Basin     8.052089
    ## 5            Bothnian Bay     3.388381
    ## 6            Bothnian Sea     5.543010
    ## 7   Eastern Gotland Basin     7.677039
    ## 8            Gdansk Basin     8.052089
    ## 9              Great Belt    19.188716
    ## 10        Gulf of Finland     6.231962
    ## 11           Gulf of Riga     6.000086
    ## 12               Kattegat    22.960039
    ## 13               Kiel Bay    14.083778
    ## 14 Northern Baltic Proper     7.677039
    ## 15              The Quark     5.543010
    ## 16              The Sound    13.386634
    ## 17  Western Gotland Basin     7.677039

#### 4.6.2 Take max from ECHAM5 dataset

From echam5 data, extract the maximum annual surface temperature for each basin between 1960-1990.

``` r
max_surf_sal_echam5 = proj_surf_sal %>%
             filter(year >= 1960 & year <= 1990)%>%
             select(basin_name_holas,sal_surface)%>%
             group_by(basin_name_holas)%>%
             summarise(max_surf_sal = max(sal_surface))%>%
             ungroup()
max_surf_sal_echam5
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas max_surf_sal
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     5.539979
    ## 2            Arkona Basin     9.120328
    ## 3      Bay of Mecklenburg     9.120328
    ## 4          Bornholm Basin     8.347591
    ## 5            Bothnian Bay     3.449004
    ## 6            Bothnian Sea     5.539979
    ## 7   Eastern Gotland Basin     7.791828
    ## 8            Gdansk Basin     8.347591
    ## 9              Great Belt    20.083892
    ## 10        Gulf of Finland     6.188563
    ## 11           Gulf of Riga     5.855224
    ## 12               Kattegat    24.391886
    ## 13               Kiel Bay    14.839115
    ## 14 Northern Baltic Proper     7.791828
    ## 15              The Quark     5.539979
    ## 16              The Sound    13.845555
    ## 17  Western Gotland Basin     7.791828

#### 4.6.3 Plot max historic value: Compare hindcast and echam5

Relatively similar between time series.

``` r
ggplot(bind_rows(
       mutate(max_surf_sal, type = "hindcast"),
       mutate(max_surf_sal_echam5, type = "echam5")))+
  geom_point(aes(basin_name_holas, max_surf_sal, colour=type, shape=type), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Max Surface Salinity 1960-1990, compare time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20max%20surface%20sal%20condition-1.png)

### 4.7 Plot min, max, and current

If black dot ("current salinity") is not between the max and min salinity values, using these values to rescale would mean that the pressure is either at its highest (if salinity is lower than the min value) or lowest (if above the max value). Current salinity is not great than the max value. However, it is often lower than the minimum value.

#### 4.7.1 Using different datasets

Hindcast for past and current, compare projections for future

``` r
##join data for plot
surf_sal_data = full_join(surf_sal_current,min_surf_sal1, by="basin_name_holas")%>%
             full_join(.,min_surf_sal2, by="basin_name_holas") %>%
            full_join(.,max_surf_sal, by="basin_name_holas") %>%
            dplyr::rename(min_surf_sal_echam5 = min_surf_sal.x,
                          min_surf_sal_hadcm3 = min_surf_sal.y)%>%
              gather(sal_type, salinity, -basin_name_holas)
  

ggplot(surf_sal_data)+
  geom_point(aes(basin_name_holas,salinity, colour = sal_type, shape=sal_type), size=2)+
  scale_shape_manual(values=c(19,19,19,17))+
  scale_colour_manual(values = c("black","red","light blue","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Basin Annual Surface Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surf%20sal%20min,%20max,%20current-1.png)

``` r
ggplot(surf_sal_data)+
  geom_point(aes(sal_type,salinity, colour = sal_type, shape=sal_type), size=2)+
  facet_wrap(~basin_name_holas, scales = "free_y")+
  scale_shape_manual(values=c(19,19,19,17))+
  scale_colour_manual(values = c("black","red","light blue","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("Basin Annual Surface Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surf%20sal%20min,%20max,%20current-2.png)

#### 4.7.2 Using only ECHAM5

``` r
max_surf_sal_echam5  = max_surf_sal_echam5 %>%
                       dplyr::rename(salinity =max_surf_sal) %>%
                        mutate(type = "max")
min_surf_sal1 = min_surf_sal1 %>%
                dplyr::rename(salinity =min_surf_sal) %>%
                        mutate(type = "min")
surf_sal_current_echam5  =surf_sal_current_echam5 %>%
                          dplyr::rename(salinity =current_surf_sal) %>%
                        mutate(type = "current")

surf_sal_data_echam5 = bind_rows(max_surf_sal_echam5,
                                 min_surf_sal1,
                                 surf_sal_current_echam5)

ggplot(surf_sal_data_echam5)+
  geom_point(aes(basin_name_holas,salinity, colour = type, shape=type), size=2)+
  scale_shape_manual(values=c(19,19,17))+
  scale_colour_manual(values = c("black","red","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("ECHAM5 Basin Annual Surface Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20echam%205%20all%20components-1.png)

``` r
  ggplot(surf_sal_data_echam5)+
  geom_point(aes(type,salinity, colour =type, shape=type), size=2)+
  facet_wrap(~basin_name_holas, scales = "free_y")+
  scale_shape_manual(values=c(19,19,17))+
  scale_colour_manual(values = c("black","red","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("ECHAM5 Basin Annual Surface Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20echam%205%20all%20components-2.png)

**It is clear that using only a single dataset produces a much better result**

### 4.8 Rescale data for pressure layer

**Use data from ECHAM5**
1. Normalize data
3. Take inverse so greater pressure with fresher conditions

``` r
 surf_sal_rescale =surf_sal_data_echam5 %>%
                    spread(type,salinity)%>%
               mutate(surf_sal_normalize = (current - min) / (max - min),
                      surf_sal_rescale_inv = 1- surf_sal_normalize)
                      ## take inverse 

 surf_sal_rescale
```

    ## Source: local data frame [17 x 6]
    ## 
    ##          basin_name_holas   current       max       min surf_sal_normalize
    ##                    <fctr>     <dbl>     <dbl>     <dbl>              <dbl>
    ## 1               Aland Sea  5.366503  5.539979  4.930861          0.7152018
    ## 2            Arkona Basin  8.530967  9.120328  8.047258          0.4507710
    ## 3      Bay of Mecklenburg  8.530967  9.120328  8.047258          0.4507710
    ## 4          Bornholm Basin  7.921647  8.347591  7.458430          0.5209599
    ## 5            Bothnian Bay  3.286676  3.449004  2.871873          0.7187324
    ## 6            Bothnian Sea  5.366503  5.539979  4.930861          0.7152018
    ## 7   Eastern Gotland Basin  7.521552  7.791828  7.055749          0.6328164
    ## 8            Gdansk Basin  7.921647  8.347591  7.458430          0.5209599
    ## 9              Great Belt 18.809710 20.083892 17.436164          0.5187641
    ## 10        Gulf of Finland  5.859795  6.188563  5.274723          0.6402346
    ## 11           Gulf of Riga  5.621391  5.855224  5.156436          0.6653738
    ## 12               Kattegat 23.264056 24.391886 22.061035          0.5161296
    ## 13               Kiel Bay 13.815469 14.839115 12.705039          0.5203326
    ## 14 Northern Baltic Proper  7.521552  7.791828  7.055749          0.6328164
    ## 15              The Quark  5.366503  5.539979  4.930861          0.7152018
    ## 16              The Sound 12.928008 13.845555 11.974787          0.5095347
    ## 17  Western Gotland Basin  7.521552  7.791828  7.055749          0.6328164
    ## Variables not shown: surf_sal_rescale_inv <dbl>.

#### 4.8.1 Plot Surface pressure layer by basin

``` r
ggplot(surf_sal_rescale)+
  geom_point(aes(basin_name_holas,surf_sal_rescale_inv),size=2.5)+
  ylim(0,1)+
  ylab("Pressure value")+
  xlab("Basin")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Surface salinity pressure layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20pressure%20layers%20by%20basin-1.png)

### 4.9 Assign basin values to BHI regions

#### 4.9.1 Read in lookup for BHI regions

``` r
bhi_holas_lookup = read.csv(file.path(dir_cc, 'bhi_basin_country_lookup.csv'), sep=";")%>%
                   select(BHI_ID, Subbasin)%>%
                   dplyr::rename(rgn_id = BHI_ID, 
                                 basin_name= Subbasin)
```

#### 4.9.2 join lookup for BHI regions to sst\_rescale

``` r
 surf_sal_rescale1 = surf_sal_rescale %>%
              full_join(., bhi_holas_lookup, by=c("basin_name_holas" = "basin_name"))%>%
              select(rgn_id,surf_sal_rescale_inv)%>%
              dplyr::rename(pressure_score = surf_sal_rescale_inv)%>%
              arrange(rgn_id)
```

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factors with different levels, coercing to character vector

#### 4.9.3 Plot rescaled surface salinity by BHI ID

``` r
ggplot(surf_sal_rescale1)+
  geom_point(aes(rgn_id,pressure_score), size=2.5)+
   ggtitle("Surface Salinity pressure data layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20surface%20salinity%20pressure%20by%20bhi%20id-1.png)

### 4.10 Write surface salinity to layers

``` r
write.csv(surf_sal_rescale1, file.path(dir_layers, 'cc_sal_surf_bhi2015.csv' ), row.names=FALSE)
```

5 Prepare Deep salinity Data layer
----------------------------------

### 5.1 Read in deep salinity data

``` r
## read in data

hind_deep_sal = read.csv(file.path(dir_salincc, 'sal_data_database/hind_sal_deep.csv'))

proj_deep_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj_sal_deep.csv')) #echam5

proj2_deep_sal = read.csv(file.path(dir_salincc,'sal_data_database/proj2_sal_deep.csv')) #hadcm3
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


proj2_deep_sal %>% filter(is.na(year))
```

    ##   basin_name_holas basin_name_baltsem basin_abb_baltsem year sal_deep
    ## 1                   Northern Kattegat                NK   NA       NA
    ## 2                   Southern Kattegat                SK   NA       NA
    ##   salin_bottom_depth
    ## 1                100
    ## 2                 70

``` r
proj2_deep_sal = proj2_deep_sal %>%
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

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-1.png)

``` r
ggplot(proj_deep_sal)+
  geom_line(aes(year,sal_deep,colour=factor(salin_bottom_depth))) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Deep Salinity time series ECHAM5")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-2.png)

``` r
ggplot(proj2_deep_sal)+
  geom_line(aes(year,sal_deep,colour=factor(salin_bottom_depth))) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Projected A1b Annual Deep Salinity time series HADCM3")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-3.png)

``` r
### bind data together and plot in single plot
sal_deep_plot = bind_rows(
                mutate(hind_deep_sal, sim_name = "hindcast"),
                mutate(proj_deep_sal, sim_name = "echam5"),
                mutate(proj2_deep_sal, sim_name = "hadcm3")) %>%
                arrange(basin_name_holas,sim_name,year)

ggplot(sal_deep_plot)+
  geom_line(aes(year,sal_deep, colour = sim_name)) + 
  facet_wrap(~basin_name_holas, scales="free_y")+
  xlim(1950,2100)+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("All Annual Deep Salinity time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-4.png)

``` r
## Plot the depth for the deep data
ggplot(filter(sal_deep_plot, sim_name=="echam5"))+
  geom_point(aes(basin_name_holas,salin_bottom_depth),size=2.5) + 
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Depth from which Deep salinity value taken")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20sal%20data-5.png)

### 5.4 Current conditions 2010-2014

#### 5.4.1 Using hindcast data

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
    ##                    <fctr>            <dbl>
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

#### 5.4.2 Using ECHAM5 data

Five most recent years

``` r
year_range = seq(2010,2014)

deep_sal_current_echam5 = proj_deep_sal %>%
              filter(year %in% year_range)%>%
              select(basin_name_holas,sal_deep)%>%
              group_by(basin_name_holas)%>%
              summarise(current_deep_sal = mean(sal_deep))%>%
              ungroup()
              

deep_sal_current_echam5
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas current_deep_sal
    ##                    <fctr>            <dbl>
    ## 1               Aland Sea         6.533404
    ## 2            Arkona Basin        17.158578
    ## 3      Bay of Mecklenburg        17.158578
    ## 4          Bornholm Basin        15.451484
    ## 5            Bothnian Bay         4.173777
    ## 6            Bothnian Sea         6.533404
    ## 7   Eastern Gotland Basin        12.386401
    ## 8            Gdansk Basin        15.451484
    ## 9              Great Belt        32.994195
    ## 10        Gulf of Finland         8.535118
    ## 11           Gulf of Riga         6.537405
    ## 12               Kattegat        34.705797
    ## 13               Kiel Bay        31.584487
    ## 14 Northern Baltic Proper        12.386401
    ## 15              The Quark         6.533404
    ## 16              The Sound        32.711900
    ## 17  Western Gotland Basin        12.386401

### 5.5.1 Plot Current condition

``` r
ggplot(bind_rows(
       mutate(deep_sal_current, type = "hindcast"),
       mutate(deep_sal_current_echam5, type = "echam5")))+
  geom_point(aes(basin_name_holas, current_deep_sal, colour=type, shape=type), size=2.5)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Deep Salinity 2010-2014, compare time series")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20current%20deep%20sal%20condition-1.png)

### 5.5 Minimum val

From projection data, extract the minimum annual deep salinity for each basin between 2020-2050. Compare the two projections. Direction of difference and magnitude is different among basins.

``` r
min_deep_sal1 = proj_deep_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_deep)%>%
           group_by(basin_name_holas)%>%
           summarise(min_deep_sal = min(sal_deep))%>%
           ungroup()

min_deep_sal1
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_deep_sal
    ##                    <fctr>        <dbl>
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

``` r
min_deep_sal2 = proj2_deep_sal %>%
           filter(year >= 2020 & year <= 2050)%>%
           select(basin_name_holas,sal_deep)%>%
           group_by(basin_name_holas)%>%
           summarise(min_deep_sal = min(sal_deep))%>%
           ungroup()

min_deep_sal2
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas min_deep_sal
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     5.692954
    ## 2            Arkona Basin    14.891935
    ## 3      Bay of Mecklenburg    14.891935
    ## 4          Bornholm Basin    13.623556
    ## 5            Bothnian Bay     3.155090
    ## 6            Bothnian Sea     5.692954
    ## 7   Eastern Gotland Basin    11.486482
    ## 8            Gdansk Basin    13.623556
    ## 9              Great Belt    32.348952
    ## 10        Gulf of Finland     7.429031
    ## 11           Gulf of Riga     5.556292
    ## 12               Kattegat    34.504942
    ## 13               Kiel Bay    30.664607
    ## 14 Northern Baltic Proper    11.486482
    ## 15              The Quark     5.692954
    ## 16              The Sound    32.026191
    ## 17  Western Gotland Basin    11.486482

``` r
## difference between two model estimates

proj_diff_deep = full_join(min_deep_sal1,min_deep_sal2,by="basin_name_holas")%>%
            dplyr::rename(min_echam5 = min_deep_sal.x,
                          min_hadcm3 = min_deep_sal.y)%>%
            mutate(proj_diff = min_echam5 - min_hadcm3)

## plot difference
ggplot(proj_diff_deep)+
    geom_point(aes(basin_name_holas, proj_diff))+
    geom_hline(yintercept = 0)+
 theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Difference in Deep Min Val between Projection datasets (ECHAM5 - HADCM3")
```

![](salinity_climatechange_prep_files/figure-markdown_github/min%20deep%20sal-1.png)

### 5.6 Maximum deep sal

#### 5.6.1 Using the Hindcast data

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
    ##                    <fctr>        <dbl>
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

#### 5.6.2 Using the ECHAM 5 data

``` r
max_deep_sal_echam5 = proj_deep_sal%>%
             filter(year >= 1960 & year <= 1990)%>%
             select(basin_name_holas,sal_deep)%>%
             group_by(basin_name_holas)%>%
             summarise(max_deep_sal = max(sal_deep))%>%
             ungroup()
max_deep_sal_echam5
```

    ## Source: local data frame [17 x 2]
    ## 
    ##          basin_name_holas max_deep_sal
    ##                    <fctr>        <dbl>
    ## 1               Aland Sea     6.875720
    ## 2            Arkona Basin    19.132597
    ## 3      Bay of Mecklenburg    19.132597
    ## 4          Bornholm Basin    18.005225
    ## 5            Bothnian Bay     4.322766
    ## 6            Bothnian Sea     6.875720
    ## 7   Eastern Gotland Basin    12.893410
    ## 8            Gdansk Basin    18.005225
    ## 9              Great Belt    33.532310
    ## 10        Gulf of Finland    10.064908
    ## 11           Gulf of Riga     6.872519
    ## 12               Kattegat    34.772998
    ## 13               Kiel Bay    32.743327
    ## 14 Northern Baltic Proper    12.893410
    ## 15              The Quark     6.875720
    ## 16              The Sound    33.308986
    ## 17  Western Gotland Basin    12.893410

### 5.7 Plot min, max, and current

#### 5.7.1 Using different datasets

Hindcast for max and current, and different projections compared for future

``` r
##join data for plot
deep_sal_data = full_join(deep_sal_current,min_deep_sal1, by="basin_name_holas")%>%
             full_join(.,min_deep_sal2, by="basin_name_holas") %>%
            full_join(.,max_deep_sal, by="basin_name_holas") %>%
            dplyr::rename(min_deep_sal_echam5 = min_deep_sal.x,
                          min_deep_sal_hadcm3 = min_deep_sal.y)%>%
              gather(sal_type, salinity, -basin_name_holas)
  

ggplot(deep_sal_data)+
  geom_point(aes(basin_name_holas,salinity, colour = sal_type, shape=sal_type), size=2)+
  scale_shape_manual(values=c(19,19,19,17))+
  scale_colour_manual(values = c("black","red","light blue","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Basin Annual Deep Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20min,%20max,%20current-1.png)

#### 5.7.2 Using only the ECHAM 5 dataset

``` r
max_deep_sal_echam5  = max_deep_sal_echam5 %>%
                       dplyr::rename(salinity =max_deep_sal) %>%
                        mutate(type = "max")
min_deep_sal1 = min_deep_sal1 %>%
                dplyr::rename(salinity =min_deep_sal) %>%
                        mutate(type = "min")
deep_sal_current_echam5  =deep_sal_current_echam5 %>%
                          dplyr::rename(salinity =current_deep_sal) %>%
                        mutate(type = "current")

deep_sal_data_echam5 = bind_rows(max_deep_sal_echam5,
                                 min_deep_sal1,
                                 deep_sal_current_echam5)

ggplot(deep_sal_data_echam5)+
  geom_point(aes(basin_name_holas,salinity, colour = type, shape=type), size=2)+
  scale_shape_manual(values=c(19,19,17))+
  scale_colour_manual(values = c("black","red","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("ECHAM5 Basin Annual Deep Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20echam%205%20all%20components-1.png)

``` r
  ggplot(deep_sal_data_echam5)+
  geom_point(aes(type,salinity, colour =type, shape=type), size=2)+
  facet_wrap(~basin_name_holas, scales = "free_y")+
  scale_shape_manual(values=c(19,19,17))+
  scale_colour_manual(values = c("black","red","blue"))+
    theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("ECHAM5 Basin Annual Deep Sal Min, Current, Max")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20echam%205%20all%20components-2.png)

**It is clear that using only a single dataset produces a much better result**

### 5.8 Rescale data for pressure layer

**Use data from ECHAM5**
1. Normalize data
3. Take inverse so greater pressure with fresher conditions

``` r
 deep_sal_rescale = deep_sal_data_echam5 %>%
                    spread(type,salinity)%>%
                    mutate(deep_sal_normalize = (current - min) / (max - min),
                      deep_sal_rescale_inv = 1- deep_sal_normalize) ## take inverse 

 deep_sal_rescale
```

    ## Source: local data frame [17 x 6]
    ## 
    ##          basin_name_holas   current       max       min deep_sal_normalize
    ##                    <fctr>     <dbl>     <dbl>     <dbl>              <dbl>
    ## 1               Aland Sea  6.533404  6.875720  6.050936          0.5849631
    ## 2            Arkona Basin 17.158578 19.132597 15.071741          0.5138909
    ## 3      Bay of Mecklenburg 17.158578 19.132597 15.071741          0.5138909
    ## 4          Bornholm Basin 15.451484 18.005225 13.326296          0.4542038
    ## 5            Bothnian Bay  4.173777  4.322766  3.630166          0.7848836
    ## 6            Bothnian Sea  6.533404  6.875720  6.050936          0.5849631
    ## 7   Eastern Gotland Basin 12.386401 12.893410 11.079354          0.7205109
    ## 8            Gdansk Basin 15.451484 18.005225 13.326296          0.4542038
    ## 9              Great Belt 32.994195 33.532310 32.167874          0.6056136
    ## 10        Gulf of Finland  8.535118 10.064908  7.377814          0.4306898
    ## 11           Gulf of Riga  6.537405  6.872519  6.008234          0.6122647
    ## 12               Kattegat 34.705797 34.772998 34.496253          0.7571749
    ## 13               Kiel Bay 31.584487 32.743327 29.847152          0.5998723
    ## 14 Northern Baltic Proper 12.386401 12.893410 11.079354          0.7205109
    ## 15              The Quark  6.533404  6.875720  6.050936          0.5849631
    ## 16              The Sound 32.711900 33.308986 31.671227          0.6354251
    ## 17  Western Gotland Basin 12.386401 12.893410 11.079354          0.7205109
    ## Variables not shown: deep_sal_rescale_inv <dbl>.

#### 4.8.1 Plot Deep pressure layer by basin

``` r
ggplot(deep_sal_rescale)+
  geom_point(aes(basin_name_holas,deep_sal_rescale_inv),size=2.5)+
  ylim(0,1)+
  ylab("Pressure value")+
  xlab("Basin")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Deep salinity pressure layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20pressure%20layers%20by%20basin-1.png) \#\#\# 5.9 Assign basin values to BHI regions

#### 5.9.1 Read in lookup for BHI regions

Done above in 4.9.1

#### 5.9.2 join lookup for BHI regions to sst\_rescale

``` r
 deep_sal_rescale1 = deep_sal_rescale %>%
              full_join(., bhi_holas_lookup, by=c("basin_name_holas" = "basin_name"))%>%
              select(rgn_id,deep_sal_rescale_inv)%>%
              dplyr::rename(pressure_score = deep_sal_rescale_inv)%>%
              arrange(rgn_id)
```

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factors with different levels, coercing to character vector

#### 5.9.3 Plot rescaled deep salinity by BHI ID

``` r
ggplot(deep_sal_rescale1)+
  geom_point(aes(rgn_id,pressure_score), size=2.5)+
   ggtitle("Deep Salinity pressure data layer")
```

![](salinity_climatechange_prep_files/figure-markdown_github/plot%20deep%20salinity%20pressure%20by%20bhi%20id-1.png)

### 5.10 Write deep salinity to layers

``` r
write.csv(deep_sal_rescale1, file.path(dir_layers, 'cc_sal_deep_bhi2015.csv' ), row.names=FALSE)
```
