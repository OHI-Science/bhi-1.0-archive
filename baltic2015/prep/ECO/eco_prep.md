eco\_prep
================

ECO subgoal data preparation
============================

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



dir_eco    = file.path(dir_prep, 'ECO')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_eco, 'eco_prep.rmd')
```

1. Background
-------------

2. Data
-------

### 2.1 Regional Data

Eurostat regional (NUTS3) GDP Data downloaded on 12 May 2016 from Eurostat database [nama\_10r\_3gdp](http://ec.europa.eu/eurostat/data/database?p_auth=EgN81qAf&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=nama_10r_3gdp)

Nominal GDP data in millions of Euros.

No data for Russia regions.

### 2.2 Country Level data

Eurostat Country GDP data Data downloaded 22 March 2016 from Eurostat Database [nama\_10\_gdp](http://ec.europa.eu/eurostat/data/database?p_auth=sHLAepWT&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=nama_10_gdp)

Nominal GDP in millions of Euros.

Data does not include Russia

### 2.3 Russian country level data

Eurostat database [naida\_10\_gdp](http://ec.europa.eu/eurostat/web/products-datasets/-/naida_10_gdp)

[Metadata link](http://ec.europa.eu/eurostat/cache/metadata/en/naid_10_esms.htm)

Download criteria:
Russia; Gross domestic product at market prices; CP\_MEUR (Current prices, million euro ); 2000-2014

### 2.4 Population density data

Population density data obtained from the [HYDE database](http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html)

Year of data = 2005. Data were a 5' resolution. Erik Smedberg with the Baltic Sea Center re-gridded to a 10 x 10 km grid.

Population density within a 25km buffer from the coast will be used.

References: Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3 .1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>

### 2.5 Aligning BHI regions with NUTS3 regions and population density

UPDATE with Marc's methods or link

3. Goal Model
-------------

'Xeco = (GDP\_Region\_c/GDP\_Region\_r)/(GDP\_Country\_c/GDP\_Country\_r)
'c = current year, r=reference year ' 'reference point is a moving window (single year value) 'Region is the BHI region which is comprised of GDP data from the associated NUTS3 regions 'data can be in nominal GDP because is a ratio value (adjusting by a deflator would cancel out)
'each BHI region is composed by one or more NUTS3 regions, these are allocated by population density from each NUTS3 region associated with a given BHI region

4. Other
--------

NEED TO UPDATE - this may change \#\#\# 4.1 Interpreting NA and zero \#\#\#\# 4.1.1 Status Score of Zero 'Status scores of zero were assigned when the region had no data or insufficient data but the indicator is applicable

#### 4.1.2 Trend value of NA

'Trend values of NA are assigned if there are not 5 years of data available to calculate a trend

5. Regional GDP prep
--------------------

### 5.1 Data organization

#### 5.1.1 Read in data

This should be check and updated when data are updated in database. Data should be extract from database by ´eco\_prep\_database\_call.r´ and saved to folder ´eco\_data\_database´

``` r
regional_gdp = read.csv(file.path(dir_eco, 'eco_data_database/nama_10r_3gdp_1_Data_download05-12-2016.csv'), sep=";")

dim(regional_gdp) #20760     6
```

    ## [1] 20760     6

``` r
str(regional_gdp)
```

    ## 'data.frame':    20760 obs. of  6 variables:
    ##  $ TIME              : int  2000 2000 2000 2000 2000 2000 2000 2000 2000 2000 ...
    ##  $ GEO               : Factor w/ 1384 levels "01-dec","02-dec",..: 43 44 45 46 47 48 49 50 51 52 ...
    ##  $ GEO_LABEL         : Factor w/ 1371 levels "A Coruña","Aberdeen City and Aberdeenshire",..: 65 59 80 96 72 78 94 58 66 69 ...
    ##  $ UNIT              : Factor w/ 1 level "Million euro": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value             : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Flag_and_Footnotes: logi  NA NA NA NA NA NA ...

#### 5.1.2 clean data object

``` r
unique(regional_gdp$UNIT) ## Million euro 
```

    ## [1] Million euro
    ## Levels: Million euro

``` r
regional_gdp = regional_gdp %>%
              dplyr::rename(year = TIME, nuts3 = GEO, nuts3_name = GEO_LABEL,
                            unit = UNIT, value = Value, flag_notes = Flag_and_Footnotes)%>%
              mutate(nuts3 = as.character(nuts3), 
                     nuts3_name = as.character(nuts3_name))
```

### 5.2 Data associations with Baltic and BHI

#### 5.2.1 Filter for Baltic countries

``` r
## read in EU country abbreviations and names
eu_lookup = read.csv(file.path(dir_eco, 'EUcountrynames.csv'), sep=";")  

## add country names to regional_gdp and filter for Baltic countries
regional_gdp2 = regional_gdp %>%
               mutate(country_abb = substr(nuts3,1,2))%>%
               left_join(., eu_lookup, by="country_abb") %>%
               filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country))
```

    ## Warning in left_join_impl(x, y, by$x, by$y): joining factor and character
    ## vector, coercing into character vector

``` r
str(regional_gdp2)
```

    ## 'data.frame':    8160 obs. of  8 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2000 2000 ...
    ##  $ nuts3      : chr  "DK011" "DK012" "DK013" "DK014" ...
    ##  $ nuts3_name : chr  "Byen København" "Københavns omegn" "Nordsjælland" "Bornholm" ...
    ##  $ unit       : Factor w/ 1 level "Million euro": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ value      : int  29496 22264 11910 1036 5318 13525 12760 22418 13841 23100 ...
    ##  $ flag_notes : logi  NA NA NA NA NA NA ...
    ##  $ country_abb: chr  "DK" "DK" "DK" "DK" ...
    ##  $ country    : Factor w/ 36 levels "Albania","Austria",..: 8 8 8 8 8 8 8 8 8 8 ...

``` r
unique(regional_gdp2$country)
```

    ## [1] Denmark   Germany   Estonia   Latvia    Lithuania Poland    Finland  
    ## [8] Sweden   
    ## 36 Levels: Albania Austria Belgium Bulgaria Croatia ... United Kingdom

#### 5.2.2 Filter for regions associated with BHI regions

#### 5.2.3 Plot regional GDP, divide by country

### 5.3 BHI region GDP

#### 5.3.1 Population density in 25km for each NUTS3 region

#### 5.3.2 Percent NUTS3 region buffer pop den per BHI region

#### 5.3.3 GDP allocated to BHI regions

#### 5.3.4 BHI region total GDP

6.Country GDP prep
------------------

### 6.1 Organize data

#### 6.1.1 Read in data

``` r
## read EU national GDP
country_gdp = read.csv(file.path(dir_eco, 'eco_data_database/nama_10_gdp_1_Data.csv'), sep=";")
 dim(country_gdp) #[1] 4428    8
```

    ## [1] 4428    8

``` r
 str(country_gdp)
```

    ## 'data.frame':    4428 obs. of  8 variables:
    ##  $ TIME              : int  1975 1975 1975 1975 1975 1975 1975 1975 1975 1975 ...
    ##  $ GEO               : Factor w/ 36 levels "AL","AT","BE",..: 3 3 3 4 4 4 7 7 7 9 ...
    ##  $ GEO_LABEL         : Factor w/ 36 levels "Albania","Austria",..: 3 3 3 4 4 4 7 7 7 8 ...
    ##  $ UNIT              : Factor w/ 3 levels "Chain linked volumes (2010), million euro",..: 3 1 2 3 1 2 3 1 2 3 ...
    ##  $ NA_ITEM           : Factor w/ 1 level "B1GQ": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ NA_ITEM_LABEL     : Factor w/ 1 level "Gross domestic product at market prices": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value             : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Flag.and.Footnotes: Factor w/ 4 levels "","b","e","p": 1 1 1 1 1 1 1 1 1 1 ...

``` r
## read in Russian national GDP
russian_nat_gdp = read.csv(file.path(dir_eco, 'eco_data_database/naida_10_gdp_1_Data_cleaned.csv'), sep=";")

dim(russian_nat_gdp) #16  6
```

    ## [1] 16  6

``` r
str(russian_nat_gdp)
```

    ## 'data.frame':    16 obs. of  6 variables:
    ##  $ TIME              : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ GEO               : Factor w/ 1 level "Russia": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ UNIT              : Factor w/ 1 level "Current prices, million euro": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ NA_ITEM           : Factor w/ 1 level "Gross domestic product at market prices": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value             : num  280496 341640 364249 380971 475365 ...
    ##  $ Flag.and.Footnotes: Factor w/ 2 levels "","e": 2 2 1 1 1 1 1 1 1 1 ...

#### 6.1.2 Clean data

``` r
country_gdp = country_gdp %>%
              dplyr::rename(year = TIME, country_abb = GEO, country= GEO_LABEL,
                            unit=UNIT, na_item = NA_ITEM, na_item_label = NA_ITEM_LABEL,
                            value = Value, flag_notes = Flag.and.Footnotes) %>%
              mutate(country_abb = as.character(country_abb),
                     country = as.character(country))%>%
              mutate(country = ifelse(country =="Germany (until 1990 former territory of the FRG)","Germany",country ))

russian_nat_gdp = russian_nat_gdp %>%
                  dplyr::rename(year = TIME, country= GEO,
                            unit=UNIT, na_item = NA_ITEM,
                            value = Value, flag_notes = Flag.and.Footnotes) %>%
                            mutate(country_abb = "RU")
```

#### 6.1.3 Restrict years to &gt;= 2000

For EU country GDP

``` r
country_gdp = country_gdp %>%
              filter(year >=2000) %>%
               filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country))
```

#### 6.1.4 Select unit type - 'current prices, million euro

For EU country GDP

``` r
##EU country GDP
unique(country_gdp$unit)
```

    ## [1] Current prices, million euro             
    ## [2] Chain linked volumes (2010), million euro
    ## [3] Chain linked volumes, index 2010=100     
    ## 3 Levels: Chain linked volumes (2010), million euro ...

``` r
##[1] Current prices, million euro              Chain linked volumes (2010), million euro
##[3] Chain linked volumes, index 2010=100

country_gdp = country_gdp %>%
              filter(unit == "Current prices, million euro")%>%
              mutate(unit = "million euro")

dim(country_gdp) #[1] 576   8
```

    ## [1] 128   8

``` r
## Russia GDP, clean unit code
russian_nat_gdp = russian_nat_gdp %>%
                  mutate(unit = "million euro")
```

#### 6.1.5 assign data flag codes

``` r
country_gdp %>% select(flag_notes)%>%distinct() ## p e
```

    ##   flag_notes
    ## 1

``` r
country_gdp = country_gdp %>%
              mutate(flag_notes = ifelse(flag_notes == 'p', "provisional",
                                  ifelse(flag_notes == 'e', "estimated", "")))
country_gdp %>% filter(flag_notes == "provisional" | flag_notes == "estimated")  ## no baltic countries
```

    ## [1] year          country_abb   country       unit          na_item      
    ## [6] na_item_label value         flag_notes   
    ## <0 rows> (or 0-length row.names)

``` r
russian_nat_gdp %>% select(flag_notes) %>% distinct() #e
```

    ##   flag_notes
    ## 1          e
    ## 2

``` r
russian_nat_gdp = russian_nat_gdp %>%
                  mutate(flag_notes = ifelse(flag_notes == 'e', "estimated", ""))
russian_nat_gdp %>% filter(flag_notes == "estimated")  ## two years estimated 2000, 2001
```

    ##   year country         unit                                 na_item
    ## 1 2000  Russia million euro Gross domestic product at market prices
    ## 2 2001  Russia million euro Gross domestic product at market prices
    ##      value flag_notes country_abb
    ## 1 280496.3  estimated          RU
    ## 2 341640.2  estimated          RU

### 6.2 Baltic regions

#### 6.2.1 Filter for Baltic countries

``` r
country_gdp2 = country_gdp %>%
                filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country))
dim(country_gdp2);dim(country_gdp)                
```

    ## [1] 128   8

    ## [1] 128   8

``` r
colnames(country_gdp2)
```

    ## [1] "year"          "country_abb"   "country"       "unit"         
    ## [5] "na_item"       "na_item_label" "value"         "flag_notes"

``` r
colnames(russian_nat_gdp)
```

    ## [1] "year"        "country"     "unit"        "na_item"     "value"      
    ## [6] "flag_notes"  "country_abb"

#### 6.2.2 Bind rows EU Baltic countries and Russia data

``` r
country_gdp3 = bind_rows(select(country_gdp2, year, country, country_abb, unit, value, flag_notes),
                    select(russian_nat_gdp, year, country, country_abb, unit, value, flag_notes))
str(country_gdp3)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    144 obs. of  6 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 ...
    ##  $ country    : chr  "Denmark" "Germany" "Estonia" "Latvia" ...
    ##  $ country_abb: chr  "DK" "DE" "EE" "LV" ...
    ##  $ unit       : chr  "million euro" "million euro" "million euro" "million euro" ...
    ##  $ value      : num  178018 2116480 6171 8606 12491 ...
    ##  $ flag_notes : chr  "" "" "" "" ...

#### 6.2.3 Plot National GDP

``` r
ggplot(country_gdp3)+
  geom_point(aes(year,value))+
  facet_wrap(~country, scales="free_y") +
  ggtitle("National Nominal GDP")
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20national%20GDP-1.png)<!-- -->

### 6.3 Join BHI region id to countries

### 6.4 Create and export country GDP data layer
