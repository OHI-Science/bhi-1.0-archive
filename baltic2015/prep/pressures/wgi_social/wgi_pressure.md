wgi\_pressure\_prep.rmd
================

-   [Prepare Worldwide Governance Indicators (WGI) for Social pressure data layer](#prepare-worldwide-governance-indicators-wgi-for-social-pressure-data-layer)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Data attributes](#data-attributes)
    -   [3. Pressure layer](#pressure-layer)
        -   [3.1 Current value](#current-value)
        -   [3.2 Rescaling](#rescaling)
    -   [4. Prepare Data layer](#prepare-data-layer)
        -   [4.1 Read in and organize data](#read-in-and-organize-data)
        -   [4.2 Plot WGI scores](#plot-wgi-scores)
        -   [4.3 Rescale to the Baltic region](#rescale-to-the-baltic-region)
        -   [4.4 Convert to Pressure score](#convert-to-pressure-score)
        -   [4.5 Assign country scores to BHI regions](#assign-country-scores-to-bhi-regions)
    -   [5. Prepare and save Objects](#prepare-and-save-objects)
        -   [5.1 Prepare object](#prepare-object)

Prepare Worldwide Governance Indicators (WGI) for Social pressure data layer
============================================================================

1. Background
-------------

The [Worldwide Governance Indicators (WGI) project](http://info.worldbank.org/governance/wgi/index.aspx#home) reports aggregate and individual governance indicators for 215 economies over the period 1996–2014, for six dimensions of governance:

Voice and Accountability
Political Stability and Absence of Violence/Terrorism
Government Effectiveness
Regulatory Quality
Rule of Law
Control of Corruption

2. Data
-------

OHI has already extracted these data by country. For BHI, we obtained these data on 13 July 2016 from [the file 'wgi\_combined\_scores\_by\_country.csv' on the OHI github site](https://github.com/OHI-Science/ohiprep/tree/master/globalprep/worldbank_wgi/intermediate).

### 2.1 Data attributes

Colname names in 'wgi\_combined\_scores\_by\_country.csv' "country": reporting country "year": reporting year "score\_wgi\_scale": mean score of six indicators: Voice and Accountability Political Stability and Absence of Violence/Terrorism Government Effectiveness Regulatory Quality Rule of Law Control of Corruption "score\_ohi\_scale": score\_wgi\_scale rescaled between 0 and 1 (score\_wgi\_scale range was - 2.5 and 2.5)

3. Pressure layer
-----------------

The rescaled value of the WGI score is a resilience data layer (eg. higher WGI, greater resilience). The inverse is the WHI pressure score.

### 3.1 Current value

The value for each country in 2013

### 3.2 Rescaling

The WGI scores have a range -2.5 to 2.5. They need to be rescaled to between 0 and 1. Use minimum and maximum value in the dataset. We compare the pressure layer difference if all countries are included in the dataset when selecting min and max to rescale or if only Baltic region values are used obtain min and max values to rescale.

4. Prepare Data layer
---------------------

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



dir_wgi    = file.path(dir_prep,'pressures/wgi_social')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_wgi, 'wgi_pressure_prep.rmd') 
```

### 4.1 Read in and organize data

#### 4.1.1 Read in data

``` r
## read in data
wgi_global = read.csv(file.path(dir_wgi, 'data_database/wgi_combined_scores_by_country.csv'), sep=";", stringsAsFactors = FALSE)
str(wgi_global)
```

    ## 'data.frame':    3210 obs. of  4 variables:
    ##  $ country        : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
    ##  $ year           : int  1996 1998 2000 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ score_wgi_scale: num  -2.07 -2.1 -2.12 -1.75 -1.57 ...
    ##  $ score_ohi_scale: num  0.0859 0.0808 0.0753 0.1503 0.1858 ...

``` r
bhi_lookup = read.csv(file.path(dir_wgi, 'bhi_basin_country_lookup.csv'), sep=";", stringsAsFactors = FALSE) %>%
            select(BHI_ID, rgn_nam) %>%
            dplyr::rename(rgn_id=BHI_ID,
                          country=rgn_nam)
```

#### 4.1.2 Select Baltic Sea countries

``` r
wgi_baltic = wgi_global %>%
            filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden|Russia",country))

wgi_baltic %>% select(country) %>% distinct()
```

    ##              country
    ## 1            Denmark
    ## 2            Estonia
    ## 3            Finland
    ## 4            Germany
    ## 5             Latvia
    ## 6          Lithuania
    ## 7             Poland
    ## 8 Russian Federation
    ## 9             Sweden

### 4.2 Plot WGI scores

#### 4.2.1 Plot WGI scores (WGI scale)

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_wgi_scale, colour = country ))+
   geom_line(aes(year, score_wgi_scale, colour = country ))+
  ylab("WGI Score")+
  ylim(-2.5,2.5)+
  ggtitle("WGI Scores (WGI scale")
```

![](wgi_pressure_files/figure-markdown_github/Plot%20raw%20Baltic%20WGI%20scores-1.png)

#### 4.2.2 Plot WGI scores - OHI global rescale

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_ohi_scale, colour = country ))+
   geom_line(aes(year, score_ohi_scale, colour = country ))+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("WGI Scores (OHI global rescale")
```

![](wgi_pressure_files/figure-markdown_github/Plot%20Baltic%20WGI%20ohi%20global%20rescale%20scores-1.png)

### 4.3 Rescale to the Baltic region

#### 4.3.1 Select Min and Max

``` r
## min
baltic_min = wgi_baltic %>%
             select(score_wgi_scale)%>%
             min()%>%
             as.numeric()
baltic_min
```

    ## [1] -0.8633578

``` r
## country and year of min
filter(wgi_baltic, score_wgi_scale == baltic_min)
```

    ##              country year score_wgi_scale score_ohi_scale
    ## 1 Russian Federation 2000      -0.8633578       0.3273284

``` r
#         country year score_wgi_scale score_ohi_scale
# Russian Federation 2000      -0.8633578       0.3273284


##max
baltic_max = wgi_baltic %>%
             select(score_wgi_scale)%>%
             max()%>%
             as.numeric()

## country and year of max
filter(wgi_baltic, score_wgi_scale == baltic_max)
```

    ##   country year score_wgi_scale score_ohi_scale
    ## 1 Finland 2004        1.985394       0.8970788

``` r
# country year score_wgi_scale score_ohi_scale
#Finland 2004        1.985394       0.8970788
```

#### 4.3.2 Rescale Baltic

``` r
wgi_baltic = wgi_baltic %>%
             mutate(min = baltic_min,
                    max=baltic_max,
             score_bhi_scale = (score_wgi_scale - baltic_min)/(baltic_max - baltic_min))%>%
             select(-min,-max)
```

#### 4.3.3 Plot rescaled to Baltic Region

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_bhi_scale, colour = country ))+
   geom_line(aes(year, score_bhi_scale, colour = country ))+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("WGI Scores (BHI region rescale")
```

![](wgi_pressure_files/figure-markdown_github/plot%20rescaled%20to%20baltic-1.png)

#### 4.3.4 Plot and Compare Rescaling options

Using the BHI region rescaling penalizes Russia. Does also spread the scores somewhat.

``` r
ggplot(gather(wgi_baltic, score_type, score, -country,-year) %>% filter(score_type != "score_wgi_scale")) + 
  geom_point(aes(year, score, colour = country ))+
   geom_line(aes(year, score, colour = country ))+
  facet_wrap(~score_type)+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("Rescale comparison WGI Scores")
```

![](wgi_pressure_files/figure-markdown_github/Plot%20and%20Compare%20Rescaling%20options-1.png)

### 4.4 Convert to Pressure score

#### 4.4.1 Convert to pressure score

Inverse of the score

``` r
wgi_baltic_pressure = wgi_baltic %>%
                      select(-score_wgi_scale)%>%
                      gather(., score_type, score, -country,-year)%>%
                      mutate(pressure_score = 1 - score) %>%
                      select(-score)
```

#### 4.4.2 Plot pressure score

``` r
ggplot(wgi_baltic_pressure) + 
  geom_point(aes(year, pressure_score, colour = country ))+
   geom_line(aes(year, pressure_score, colour = country ))+
  facet_wrap(~score_type)+
  ylab("Pressure Score")+
  ylim(0,1)+
  ggtitle("Rescale comparison WGI Pressure Scores")
```

![](wgi_pressure_files/figure-markdown_github/Plot%20and%20Compare%20Rescaling%20options%20with%20Pressure%20score-1.png)

### 4.5 Assign country scores to BHI regions

#### 4.5.1 Join BHI region lookup to country scores

``` r
wgi_pressure_rgn = wgi_baltic_pressure %>%
                   mutate(country = ifelse(country == "Russian Federation", "Russia", country))%>%
                   full_join(., bhi_lookup, by = "country")
```

5. Prepare and save Objects
---------------------------

Select global rescaling so that Russia is not so heavily penalized.

### 5.1 Prepare object

``` r
ss_wgi = wgi_pressure_rgn %>%
         filter(score_type == "score_ohi_scale")%>%
         select(-score_type, -country)%>%
         group_by(rgn_id) %>%
         filter(year == max(year))%>%
         ungroup() %>%
         select(rgn_id, year, pressure_score) %>%
         arrange(rgn_id)

ss_wgi = ss_wgi %>%
        select(-year)
```

#### 5.2 Save object

``` r
write.csv(ss_wgi, file.path(dir_layers, 'ss_wgi_bhi2015.csv'), row.names=FALSE)
```
