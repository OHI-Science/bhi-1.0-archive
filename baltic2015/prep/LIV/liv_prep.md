liv\_preo
================

-   [LIV subgoal data preparation](#liv-subgoal-data-preparation)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 NUTS0 (country) and NUTS2 region Employment rate](#nuts0-country-and-nuts2-region-employment-rate)
        -   [2.2 Russian data](#russian-data)
        -   [2.3 Population density data](#population-density-data)
        -   [2.4 Aligning BHI regions with NUTS3 regions and population density](#aligning-bhi-regions-with-nuts3-regions-and-population-density)
    -   [3. Goal model](#goal-model)
    -   [4. Other](#other)
    -   [5. Regional data prep](#regional-data-prep)
        -   [5.1 Data organization](#data-organization)
        -   [5.2 Select Baltic Countries](#select-baltic-countries)
        -   [5.3 BHI region Employment](#bhi-region-employment)
    -   [6. Country data prep](#country-data-prep)
        -   [6.1 Organize data](#organize-data)

LIV subgoal data preparation
============================

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


dir_liv    = file.path(dir_prep, 'LIV')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_liv, 'liv_prep.rmd')
```

1. Background
-------------

2. Data
-------

#### 2.1 NUTS0 (country) and NUTS2 region Employment rate

Data downloaded on 31 March 2016 from Eurostat database [lfst\_r\_lfe2emprt](http://ec.europa.eu/eurostat/data/database?p_auth=BgwyNWIM&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=lfst_r_lfe2emprt)

Data information: Available for Country Level (NUTS0), NUTS1, and NUTS2; ages 15-64; All sexes; years 1999-2014

[Metadata link](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm)
**Metadata overview**
The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonisation, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi\_esms, see paragraph 21.1.).

The EU-LFS is designed to give accurate quarterly information at national level as well as annual information at NUTS 2 regional level and the compilation of these figures is well specified in the regulation. Microdata including the NUTS 2 level codes are provided by all the participating countries with a good degree of geographical comparability, which allows the production and dissemination of a complete set of comparable indicators for this territorial level.

**Data flags** b break in time series
c confidential
d definition differs, see metadata
e estimated
f forecast
i see metadata (phased out)
n not significant
p provisional
r revised
s Eurostat estimate (phased out)
u low reliability
z not applicable

### 2.2 Russian data

#### 2.2.1 Regional data

HAVE NOT OBTAINED

#### 2.2.2 Country level data

### 2.3 Population density data

#### 2.3.1 Fine scale population data

Population density data obtained from the [HYDE database](http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html)

Year of data = 2005. Data were a 5' resolution. Erik Smedberg with the Baltic Sea Center re-gridded to a 10 x 10 km grid.

Population density within a 25km buffer from the coast will be used.

References: Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3 .1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>

#### 2.3.2 National

**EU countries**
Downloaded on March 31 2016 from Eurostat database [demo\_gind](http://ec.europa.eu/eurostat/data/database?p_auth=whAQQAX7&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=demo_gind)

Variables:
1990-2015 Population on Jan1

[Metadata Link](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)

*Population on 1 January:*
Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December . However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.

**Russia**
Downloaded on 10 June 2016 from Eurostat database: [naida\_10\_pe](http://ec.europa.eu/eurostat/web/products-datasets/-/naida_10_pe)
population (thousands of people)
employment (thousands of people) *need to exclude this*

### 2.4 Aligning BHI regions with NUTS3 regions and population density

UPDATE with Marc's methods or link

3. Goal model
-------------

Xliv = (Employment\_Region\_c/Employment\_Region\_r)/(Employment\_Country\_c/Employment\_Country\_r)
\* c = current year, r=reference year
\* reference point is a moving window (single year value)
\* Region is the BHI region - number of employed persons associated in the BHI region
\* Each BHI region is composed by one or more NUTS2 regions.
 \* NUTS2 employment percentage multipled by the by population in the 25km inland buffer associated with a BHI region. Sum across all associated with a BHI region to get the total employed people in the BHI region. \* For Country data, need to also get population size so can have total number of people employed, not percent employed

4. Other
--------

5. Regional data prep
---------------------

### 5.1 Data organization

#### 5.1.1 read in data

UPDATE after data put in database

``` r
## read in
regional_employ = read.csv(file.path(dir_liv, 'liv_data_database/lfst_r_lfe2emprt_1_Data_NUTS2_cleaned.csv'), sep = ";")

dim(regional_employ) #[1] 5344    9
```

    ## [1] 5344    9

``` r
str(regional_employ)
```

    ## 'data.frame':    5344 obs. of  9 variables:
    ##  $ TIME              : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ TIME_LABEL        : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ GEO               : Factor w/ 334 levels "AT11","AT12",..: 10 11 12 13 14 15 16 17 18 19 ...
    ##  $ GEO_LABEL         : Factor w/ 334 levels "Abruzzo","Adana, Mersin",..: 244 228 232 235 237 236 229 230 231 233 ...
    ##  $ SEX               : Factor w/ 1 level "Total": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ AGE               : Factor w/ 1 level "From 15 to 64 years": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ UNIT              : Factor w/ 1 level "Percentage": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value             : num  53.6 59.9 57.9 62.4 65.9 63.8 60 50.5 56.6 60.3 ...
    ##  $ Flag.and.Footnotes: Factor w/ 4 levels "","b","bu","u": 2 2 2 2 2 2 2 2 2 2 ...

#### 5.1.2 Clean data object

``` r
regional_employ = regional_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, nuts2 = GEO, nuts2_name = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(nuts2 = as.character(nuts2),
                         nuts2_name = as.character(nuts2_name),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries",
                                      ifelse(flag_notes== "u", "low reliability",
                                      ifelse(flag_notes== "bu", "break in timeseries and low reliability",""))))
```

### 5.2 Select Baltic Countries

#### 5.2.1 read in EU lookup

``` r
# read in EU country abbreviations and names
eu_lookup = read.csv(file.path(dir_liv, 'EUcountrynames.csv'), sep=";")  
```

#### 5.2.2 join to regional\_employ

``` r
## add country names to regional_gdp and filter for Baltic countries
regional_employ = regional_employ %>%
               mutate(country_abb = substr(nuts2,1,2))%>%
               left_join(., eu_lookup, by="country_abb") %>%
               filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country))
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

#### 5.2.2 Filter for regions associated with BHI regions

#### 5.2.3 Plot regional Employment percentage, divide by country

### 5.3 BHI region Employment

#### 5.3.1 Population density in 25km for each NUTS2 region

#### 5.3.2 Percent NUTS2 region buffer pop den per BHI region

#### 5.3.3 Employment allocated to BHI regions

Population Employed = Percent Employment \* Population in 25km buffer by NUTS2\_BHI

#### 5.3.4 BHI region total Population Employed

#### 5.3.5 Select years

6. Country data prep
--------------------

### 6.1 Organize data

#### 6.1.1 Read in data

``` r
## read in employement
country_employ = read.csv(file.path(dir_liv, 'liv_data_database/lfst_r_lfe2emprt_1_Data_NUTS0_cleaned.csv'), sep = ";")

dim(country_employ) #[1] 528    9
```

    ## [1] 528   9

``` r
str(country_employ)
```

    ## 'data.frame':    528 obs. of  9 variables:
    ##  $ TIME              : int  1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ TIME_LABEL        : int  1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ GEO               : Factor w/ 33 levels "AT","BE","BG",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ GEO_LABEL         : Factor w/ 33 levels "Austria","Belgium",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ SEX               : Factor w/ 1 level "Total": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ AGE               : Factor w/ 1 level "From 15 to 64 years": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ UNIT              : Factor w/ 1 level "Percentage": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value             : num  68.2 67.9 67.8 68.1 68.2 65.3 67.4 68.6 69.9 70.8 ...
    ##  $ Flag.and.Footnotes: Factor w/ 2 levels "","b": 1 1 1 1 1 2 2 1 2 1 ...

``` r
## read in 
```

#### 6.1.2 Clean data object

``` r
country_employ = country_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, country_abb = GEO, country = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(country_abb = as.character(country_abb),
                         country = as.character(country),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries", ""))
```

#### Transform employment % into \# of people employed
