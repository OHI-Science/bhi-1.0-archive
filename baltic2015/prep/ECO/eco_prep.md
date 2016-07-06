eco\_prep.rmd
================

-   [ECO subgoal data preparation](#eco-subgoal-data-preparation)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Regional Data](#regional-data)
        -   [2.2 Country Level data](#country-level-data)
        -   [2.3 Russian country level data](#russian-country-level-data)
        -   [2.4 Population density data](#population-density-data)
        -   [2.5 Aligning BHI regions with NUTS3 regions and population density](#aligning-bhi-regions-with-nuts3-regions-and-population-density)
    -   [3. Goal Model](#goal-model)
    -   [4. Other](#other)
        -   [4.1.2 Trend value of NA](#trend-value-of-na)
    -   [5. Regional GDP prep](#regional-gdp-prep)
        -   [5.1 Data organization](#data-organization)
        -   [5.2 Data associations with Baltic and BHI](#data-associations-with-baltic-and-bhi)
        -   [5.3 BHI region GDP](#bhi-region-gdp)
        -   [5.4 Data layer for layers](#data-layer-for-layers)
        -   [5.4.2](#section)
    -   [6.Country GDP prep](#country-gdp-prep)
        -   [6.1 Organize data](#organize-data)
        -   [6.2 Baltic regions](#baltic-regions)
        -   [6.4 Per capita national gdp](#per-capita-national-gdp)
        -   [6.5 Per capita National GDP](#per-capita-national-gdp-1)
        -   [6.3 Join BHI region id to countries](#join-bhi-region-id-to-countries)
        -   [6.4 Create and export country GDP data layer](#create-and-export-country-gdp-data-layer)

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

#### 2.4.1 Fine scale

Population density data obtained from the [HYDE database](http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html)

Year of data = 2005. Data were a 5' resolution. Erik Smedberg with the Baltic Sea Center re-gridded to a 10 x 10 km grid.

Population density within a 25km buffer from the coast will be used.

References: Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3 .1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>

#### 2.4.2 National

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

### 2.5 Aligning BHI regions with NUTS3 regions and population density

NEED TO ADD LINK to MARC methods

NUTS3 GDP data is joined in the database to the area and population density information associated with that NUTS3 and BHI region.

#### 2.5.1 Guide to column names in regional GDP associated with population density and area:

PopTot = total population in the BHI region's 25km buffer overlapping with a NUTS3 region
PopUrb = urban population in the BHI region's 25km buffer overlapping with a NUTS3 region
PopRur = rural population in the BHI region's 25km buffer overlapping with a NUTS3 region
PopTot\_density\_in\_buffer\_per\_km2" = total population in the BHI region's 25km buffer overlapping with a NUTS3 region population in the BHI region's 25km buffer overlapping with a NUTS3 region divided by the area within that buffer and NUTS3 region
PopUrb\_density\_in\_buffer\_per\_km2 = urban population in the BHI region's 25km buffer overlapping with a NUTS3 region population in the BHI region's 25km buffer overlapping with a NUTS3 region divided by the area within that buffer and NUTS3 region
PopRur\_density\_in\_buffer\_per\_km2 = rural population in the BHI region's 25km buffer overlapping with a NUTS3 region population in the BHI region's 25km buffer overlapping with a NUTS3 region divided by the area within that buffer and NUTS3 region
NUTS3\_area\_in\_BHI\_buffer\_km2 = area of a NUTS3 region associated with the 25km buffer of a BHI region

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
regional_gdp = read.csv(file.path(dir_eco, 'eco_data_database/nuts3_gdp.csv'))

dim(regional_gdp) #21375    18
```

    ## [1] 21375    18

``` r
str(regional_gdp)
```

    ## 'data.frame':    21375 obs. of  18 variables:
    ##  $ TIME                            : int  2000 2000 2000 2000 2000 2000 2000 2000 2000 2000 ...
    ##  $ GEO                             : Factor w/ 1384 levels "01-dec","02-dec",..: 43 44 45 46 47 48 49 50 51 52 ...
    ##  $ GEO_LABEL                       : Factor w/ 1371 levels "A Coruña","Aberdeen City and Aberdeenshire",..: 65 59 80 96 72 78 94 58 66 69 ...
    ##  $ UNIT                            : Factor w/ 1 level "Million euro": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Value                           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Flag_and_Footnotes              : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID                          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopTot                          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopUrb                          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopRur                          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopTot_density_in_buffer_per_km2: num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopUrb_density_in_buffer_per_km2: num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ PopRur_density_in_buffer_per_km2: num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ CNTR_CODE                       : Factor w/ 8 levels "DE","DK","EE",..: NA NA NA NA NA NA NA NA NA NA ...
    ##  $ rgn_nam                         : Factor w/ 9 levels "Denmark","Estonia",..: NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Subbasin                        : Factor w/ 18 levels "Aland Sea","Arkona Basin",..: NA NA NA NA NA NA NA NA NA NA ...
    ##  $ HELCOM_ID                       : Factor w/ 17 levels "SEA-001","SEA-002",..: NA NA NA NA NA NA NA NA NA NA ...
    ##  $ NUTS3_area_in_BHI_buffer_km2    : num  NA NA NA NA NA NA NA NA NA NA ...

#### 5.1.2 clean data object

``` r
unique(regional_gdp$UNIT) ## Million euro 
```

    ## [1] Million euro
    ## Levels: Million euro

``` r
regional_gdp = regional_gdp %>%
               select(-PopUrb,-PopRur,-PopUrb_density_in_buffer_per_km2,-PopRur_density_in_buffer_per_km2,-HELCOM_ID)%>% ## remove data not needed
              dplyr::rename(year = TIME, nuts3 = GEO, nuts3_name = GEO_LABEL,
                            unit = UNIT, value = Value, flag_notes = Flag_and_Footnotes,
                            rgn_id = BHI_ID,pop = PopTot,pop_km2 = PopTot_density_in_buffer_per_km2,
                            country_abb = CNTR_CODE,country=rgn_nam, basin= Subbasin,
                            area_nuts3_in_bhi_buffer= NUTS3_area_in_BHI_buffer_km2)%>%
              mutate(nuts3 = as.character(nuts3), 
                     nuts3_name = as.character(nuts3_name),
                     unit = as.character(unit),
                     country_abb=as.character(country_abb),
                     country = as.character(country),
                     basin = as.character(basin))

str(regional_gdp)
```

    ## 'data.frame':    21375 obs. of  13 variables:
    ##  $ year                    : int  2000 2000 2000 2000 2000 2000 2000 2000 2000 2000 ...
    ##  $ nuts3                   : chr  "BE100" "BE211" "BE212" "BE213" ...
    ##  $ nuts3_name              : chr  "Arr. de Bruxelles-Capitale / Arr. van Brussel-Hoofdstad" "Arr. Antwerpen" "Arr. Mechelen" "Arr. Turnhout" ...
    ##  $ unit                    : chr  "Million euro" "Million euro" "Million euro" "Million euro" ...
    ##  $ value                   : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ flag_notes              : logi  NA NA NA NA NA NA ...
    ##  $ rgn_id                  : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ pop                     : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ pop_km2                 : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ country_abb             : chr  NA NA NA NA ...
    ##  $ country                 : chr  NA NA NA NA ...
    ##  $ basin                   : chr  NA NA NA NA ...
    ##  $ area_nuts3_in_bhi_buffer: num  NA NA NA NA NA NA NA NA NA NA ...

#### 5.1.3 Find NUTS3 regions assigned to incorrect BHI region

Due to small differences in the shapefiles, some NUTS3 regions assigned to a BHI region belonging to a different country.

``` r
## find mis-assigned NUTS and BHI regions
mis_assigned =regional_gdp %>% 
  filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden|Russia",country)) %>% ## include Russia because some mis-assigned
select(country,country_abb, rgn_id,nuts3) %>% distinct() %>% arrange(rgn_id,country) %>%
  dplyr::rename(BHI_ID = rgn_id,
                country_bhi = country,
                country_abb_nuts = country_abb)
#write to csv
#write.csv(mis_assigned, file.path(dir_eco,"mis_assigned_bhi_nuts3.csv"),row.names = FALSE)
```

#### 5.1.4 Manually fix NUTS3 regions assigned to incorrect BHI region

``` r
## upload corrected files - the file exported in 5.1.3 was reviewed and corrected manually
correct_assign = read.csv(file.path(dir_eco,"mis_assigned_bhi_nuts3_corrected_manually.csv"),sep=";", stringsAsFactors = FALSE)
str(correct_assign)
```

    ## 'data.frame':    96 obs. of  9 variables:
    ##  $ country_bhi     : chr  "Germany" "Germany" "Germany" "Germany" ...
    ##  $ country_abb_nuts: chr  "DE" "DE" "DE" "DE" ...
    ##  $ BHI_ID          : int  10 4 8 10 10 8 10 8 8 4 ...
    ##  $ nuts3           : chr  "DE803" "DEF01" "DEF02" "DEF03" ...
    ##  $ MISASSIGNED     : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_manual   : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ country_manual  : chr  "" "" "" "" ...
    ##  $ correct_BHI_ID  : int  10 4 8 10 10 8 10 8 8 4 ...
    ##  $ correct_country : chr  "Germany" "Germany" "Germany" "Germany" ...

``` r
regional_gdp1 = full_join(regional_gdp,correct_assign,
                          by=c("country"="country_bhi", "country_abb"="country_abb_nuts",
                               "rgn_id"="BHI_ID", "nuts3"))

## replace the country and rgn_id with the "corrected column"
regional_gdp1 = regional_gdp1 %>%
                select(-country,-rgn_id,-MISASSIGNED,-BHI_ID_manual,-country_manual)%>%
                dplyr::rename(rgn_id = correct_BHI_ID,
                              country= correct_country) %>%
                arrange(nuts3)
```

#### 5.1.5 check NA in final years

``` r
##check 2014 - is max year?
regional_gdp1 %>% 
  select(country_abb,year,value)%>%
  group_by(country_abb)%>%
  summarise(max_year = max(year))%>%
  ungroup()%>%
  left_join(.,select(regional_gdp1, country_abb,year,value,nuts3,rgn_id),
            by=c("country_abb","max_year"="year"))%>%
  filter(!is.na(rgn_id))%>%
  print(n=100)%>%
  filter(!is.na(value))%>%
  select(country_abb)%>%
  distinct()
```

    ## Source: local data frame [96 x 5]
    ## 
    ##    country_abb max_year value nuts3 rgn_id
    ##          <chr>    <int> <int> <chr>  <int>
    ## 1           DE     2014    NA DE803     10
    ## 2           DE     2014    NA DEF01      4
    ## 3           DE     2014    NA DEF02      8
    ## 4           DE     2014    NA DEF03     10
    ## 5           DE     2014    NA DEF06     10
    ## 6           DE     2014    NA DEF08      8
    ## 7           DE     2014    NA DEF08     10
    ## 8           DE     2014    NA DEF0A      8
    ## 9           DE     2014    NA DEF0B      8
    ## 10          DE     2014    NA DEF0C      4
    ## 11          DE     2014    NA DEF0C      8
    ## 12          DE     2014    NA DEF0D     10
    ## 13          DE     2014    NA DEF0F     10
    ## 14          DK     2014 48028 DK011      6
    ## 15          DK     2014 48028 DK011     12
    ## 16          DK     2014 36356 DK012      6
    ## 17          DK     2014 36356 DK012     12
    ## 18          DK     2014 16414 DK013      2
    ## 19          DK     2014 16414 DK013      6
    ## 20          DK     2014 16414 DK013     12
    ## 21          DK     2014  1355 DK014     15
    ## 22          DK     2014  7633 DK021      2
    ## 23          DK     2014  7633 DK021     12
    ## 24          DK     2014 18242 DK022      2
    ## 25          DK     2014 18242 DK022      3
    ## 26          DK     2014 18242 DK022      7
    ## 27          DK     2014 18242 DK022      9
    ## 28          DK     2014 18242 DK022     12
    ## 29          DK     2014 17317 DK031      3
    ## 30          DK     2014 32468 DK032      3
    ## 31          DK     2014 32468 DK032      4
    ## 32          DK     2014 19136 DK041      3
    ## 33          DK     2014 33787 DK042      2
    ## 34          DK     2014 33787 DK042      3
    ## 35          DK     2014 23028 DK050      2
    ## 36          EE     2014 12434 EE001     34
    ## 37          EE     2014  1405 EE004     25
    ## 38          EE     2014  1405 EE004     28
    ## 39          EE     2014  1405 EE004     28
    ## 40          EE     2014  1405 EE004     31
    ## 41          EE     2014  1405 EE004     34
    ## 42          EE     2014  1153 EE006     34
    ## 43          EE     2014  1567 EE007     34
    ## 44          EE     2014  1567 EE007     34
    ## 45          FI     2014    NA FI194     38
    ## 46          FI     2014    NA FI194     40
    ## 47          FI     2014    NA FI195     38
    ## 48          FI     2014    NA FI195     40
    ## 49          FI     2014    NA FI195     42
    ## 50          FI     2014    NA FI196     38
    ## 51          FI     2014    NA FI200     36
    ## 52          FI     2014    NA FI200     38
    ## 53          LT     2014    NA LT003     23
    ## 54          LT     2014    NA LT003     23
    ## 55          LT     2014    NA LT003     23
    ## 56          LV     2014    NA LV003     24
    ## 57          LV     2014    NA LV003     24
    ## 58          LV     2014    NA LV003     27
    ## 59          LV     2014    NA LV006     27
    ## 60          LV     2014    NA LV007     27
    ## 61          LV     2014    NA LV007     27
    ## 62          LV     2014    NA LV009     27
    ## 63          PL     2014    NA PL424     17
    ## 64          PL     2014    NA PL621     18
    ## 65          PL     2014    NA PL621     18
    ## 66          PL     2014    NA PL622     18
    ## 67          PL     2014    NA PL633     18
    ## 68          PL     2014    NA PL634     17
    ## 69          PL     2014    NA PL634     18
    ## 70          SE     2014    NA SE110     29
    ## 71          SE     2014    NA SE110     35
    ## 72          SE     2014    NA SE121     35
    ## 73          SE     2014    NA SE121     37
    ## 74          SE     2014    NA SE122     29
    ## 75          SE     2014    NA SE123     26
    ## 76          SE     2014    NA SE123     29
    ## 77          SE     2014    NA SE212     14
    ## 78          SE     2014    NA SE213     14
    ## 79          SE     2014    NA SE213     26
    ## 80          SE     2014    NA SE214     20
    ## 81          SE     2014    NA SE214     26
    ## 82          SE     2014    NA SE221     14
    ## 83          SE     2014    NA SE221     26
    ## 84          SE     2014    NA SE224      1
    ## 85          SE     2014    NA SE224      5
    ## 86          SE     2014    NA SE224     11
    ## 87          SE     2014    NA SE224     14
    ## 88          SE     2014    NA SE231      1
    ## 89          SE     2014    NA SE232      1
    ## 90          SE     2014    NA SE313     37
    ## 91          SE     2014    NA SE321     37
    ## 92          SE     2014    NA SE331     37
    ## 93          SE     2014    NA SE331     39
    ## 94          SE     2014    NA SE331     41
    ## 95          SE     2014    NA SE332     41
    ## 96          SE     2014    NA SE332     41

    ## Source: local data frame [2 x 1]
    ## 
    ##   country_abb
    ##         <chr>
    ## 1          DK
    ## 2          EE

``` r
## only Estonia and Denmark provide 2014 data

## check 2013
regional_gdp1 %>% 
  select(country_abb,year,value,rgn_id,nuts3)%>%
  filter(year == 2013) %>%
  filter(!is.na(rgn_id))%>%
  filter(!is.na(value))%>%
  select(country_abb)%>%
  distinct()
```

    ##   country_abb
    ## 1          DE
    ## 2          DK
    ## 3          EE
    ## 4          FI
    ## 5          LT
    ## 6          LV
    ## 7          PL
    ## 8          SE

``` r
## all countries have 2013 data
```

### 5.2 Data associations with Baltic and BHI

#### 5.2.1 Filter for Baltic countries

Only NUTS3 regions associated with a BHI ID have a country name, so this effectively selects the NUTS3 regions on the Baltic Coast

``` r
## read in EU country abbreviations and names
##eu_lookup = read.csv(file.path(dir_eco, 'EUcountrynames.csv'), sep=";")  

## add country names to regional_gdp and filter for Baltic countries
regional_gdp2 = regional_gdp1 %>%
               filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country))
               
str(regional_gdp2)
```

    ## 'data.frame':    1440 obs. of  13 variables:
    ##  $ year                    : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ nuts3                   : chr  "DE803" "DE803" "DE803" "DE803" ...
    ##  $ nuts3_name              : chr  "Rostock, Kreisfreie Stadt" "Rostock, Kreisfreie Stadt" "Rostock, Kreisfreie Stadt" "Rostock, Kreisfreie Stadt" ...
    ##  $ unit                    : chr  "Million euro" "Million euro" "Million euro" "Million euro" ...
    ##  $ value                   : int  4950 4790 4821 4779 5039 5225 5119 5555 5873 5796 ...
    ##  $ flag_notes              : logi  NA NA NA NA NA NA ...
    ##  $ pop                     : int  200699 200699 200699 200699 200699 200699 200699 200699 200699 200699 ...
    ##  $ pop_km2                 : num  119 119 119 119 119 ...
    ##  $ country_abb             : chr  "DE" "DE" "DE" "DE" ...
    ##  $ basin                   : chr  "Bay of Mecklenburg" "Bay of Mecklenburg" "Bay of Mecklenburg" "Bay of Mecklenburg" ...
    ##  $ area_nuts3_in_bhi_buffer: num  1685 1685 1685 1685 1685 ...
    ##  $ rgn_id                  : int  10 10 10 10 10 10 10 10 10 10 ...
    ##  $ country                 : chr  "Germany" "Germany" "Germany" "Germany" ...

``` r
unique(regional_gdp2$country)
```

    ## [1] "Germany"   "Denmark"   "Estonia"   "Finland"   "Lithuania" "Latvia"   
    ## [7] "Poland"    "Sweden"

``` r
unique(regional_gdp2$country_abb)
```

    ## [1] "DE" "DK" "EE" "FI" "LT" "LV" "PL" "SE"

#### 5.2.2 Remove 2014

Only 2 countries have data

``` r
regional_gdp2 = regional_gdp2 %>%
                filter(year < 2014)
```

#### 5.2.2 Plot regional GDP, divide by country

Check to make sure each BHI region is only associated with NUTS regions from a single country

``` r
ggplot(regional_gdp2) +
  geom_point(aes(year, value, col=nuts3))+
  facet_wrap(~country)+
  ylab("GDP (million euro)")+
  #guides(color="none")+
  ggtitle("regional GDP by countries")
```

![](eco_prep_files/figure-markdown_github/plot%20regional%20gdp%20raw-1.png)

``` r
ggplot(regional_gdp2) +
  geom_point(aes(year, value, col=country),size=.7)+
  facet_wrap(~rgn_id, scales="free_y")+
  ylab("GDP (million euro)")+
  ggtitle("NUTS3 GDP by BHI region")
```

![](eco_prep_files/figure-markdown_github/plot%20regional%20gdp%20raw-2.png)

#### 5.2.3 Check data flags

``` r
regional_gdp2 %>% filter(!is.na(flag_notes))
```

    ##  [1] year                     nuts3                   
    ##  [3] nuts3_name               unit                    
    ##  [5] value                    flag_notes              
    ##  [7] pop                      pop_km2                 
    ##  [9] country_abb              basin                   
    ## [11] area_nuts3_in_bhi_buffer rgn_id                  
    ## [13] country                 
    ## <0 rows> (or 0-length row.names)

``` r
## no data flags

regional_gdp2 = regional_gdp2 %>%
                select(-flag_notes)
```

### 5.3 BHI region GDP

Each regional GDP is divided among BHI regions proportional to the population of the NUTS3 region associated with the BHI region.

Currently the population of the entire NUTS3 region is not extracted so the total GDP of the NUTS3 region is divided among the BHI regions, rather than dividing the fraction of the NUTS3 GDP associated with the NUTS3 25km coastal population.

#### 5.3.1 NUTS3 - BHI region lookup

``` r
nuts3_bhi_lookup = regional_gdp2 %>%
                   select(rgn_id,nuts3)%>%
                   distinct()
```

#### 5.3.2 Identify total NUTS3 population in the 25km buffer

Sum across BHI regions associated with a NUTS3. This is the same for all years as population data comes from a single year.

``` r
nuts3_buffer_pop= regional_gdp2 %>%
                  select(nuts3,pop,area_nuts3_in_bhi_buffer)%>%
                  distinct()%>% ## because duplicated for each year
                  group_by(nuts3)%>%
                  summarise(pop_nuts3 = sum(pop),
                            area_nuts3 = sum(area_nuts3_in_bhi_buffer))%>%
                  ungroup()
```

#### 5.3.3 Join the total NUTS3 area and population to the per BHI region

``` r
nuts3_bhi_join  = nuts3_buffer_pop %>%
                  full_join(., regional_gdp2, by="nuts3")
```

#### 5.3.4 Calculate the GDP fraction for BHI region based on the population fraction

``` r
nuts3_bhi_join2 = nuts3_bhi_join %>%
                  mutate(bhi_pop_prop = pop / pop_nuts3,
                         bhi_gdp_prop = value * bhi_pop_prop) %>%
                  arrange(rgn_id, year)


nuts3_bhi_join2 %>% select(nuts3, country,pop_nuts3, pop,bhi_pop_prop)%>%distinct()%>%arrange(nuts3)
```

    ## Source: local data frame [96 x 5]
    ## 
    ##    nuts3 country pop_nuts3    pop bhi_pop_prop
    ##    <chr>   <chr>     <int>  <int>        <dbl>
    ## 1  DE803 Germany    200699 200699    1.0000000
    ## 2  DEF01 Germany    127497 127497    1.0000000
    ## 3  DEF02 Germany    316944 316944    1.0000000
    ## 4  DEF03 Germany    280201 280201    1.0000000
    ## 5  DEF06 Germany    107850 107850    1.0000000
    ## 6  DEF08 Germany    396307  83889    0.2116768
    ## 7  DEF08 Germany    396307 312418    0.7883232
    ## 8  DEF0A Germany    380586 380586    1.0000000
    ## 9  DEF0B Germany    397202 397202    1.0000000
    ## 10 DEF0C Germany    285337 226701    0.7945026
    ## ..   ...     ...       ...    ...          ...

#### 5.3.5 Plot the population fraction and GDP fraction from each NUTS3 associated with each BHI region

``` r
ggplot(nuts3_bhi_join2)+
  geom_point(aes(rgn_id,bhi_pop_prop,colour=nuts3))+
  facet_wrap(~country)+
  ylim(0,1)+
  ggtitle("Population Fraction of NUTS3 regions for each BHI region")
```

![](eco_prep_files/figure-markdown_github/plot%20pop%20and%20gdp%20fraction%20in%20each%20bhi-1.png)

``` r
ggplot(nuts3_bhi_join2)+
  geom_point(aes(year,bhi_gdp_prop,colour=nuts3),size=.8)+
  facet_wrap(~rgn_id, scales="free_y")+
  guides(colour="none")+
  ggtitle("NUTS3 GDP allocated to each BHI region based on population")
```

![](eco_prep_files/figure-markdown_github/plot%20pop%20and%20gdp%20fraction%20in%20each%20bhi-2.png)

#### 5.3.6 Calculate the total BHI region buffer population and total BHI region GDP

``` r
bhi_gdp = nuts3_bhi_join2 %>%
          group_by(rgn_id,year)%>%
          summarise(bhi_pop = sum(pop),
                    bhi_gdp = sum(bhi_gdp_prop))%>%
          ungroup()%>%
          mutate(bhi_gdp_per_capita = bhi_gdp/bhi_pop)

str(bhi_gdp)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    476 obs. of  5 variables:
    ##  $ rgn_id            : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ year              : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ bhi_pop           : int  844828 844828 844828 844828 844828 844828 844828 844828 844828 844828 ...
    ##  $ bhi_gdp           : num  56729 54643 56549 60660 62353 ...
    ##  $ bhi_gdp_per_capita: num  0.0671 0.0647 0.0669 0.0718 0.0738 ...

#### 5.3.7 Plot Total GDP per BHI region

``` r
ggplot(bhi_gdp)+
  geom_point(aes(year,bhi_gdp),size=1)+
  facet_wrap(~rgn_id, scales="free_y")+
  ylab("GDP (million euro)")+
  ggtitle("BHI region GDP")
```

![](eco_prep_files/figure-markdown_github/plot%20total%20gdp%20per%20BHI%20region-1.png)

#### 5.3.7 Plot GDP per capita (population in the 25km buffer) by BHI region

``` r
ggplot(bhi_gdp)+
  geom_point(aes(year,bhi_gdp_per_capita),size=1)+
  facet_wrap(~rgn_id, scales="free_y")+
  ylab("GDP per capita (million euro)")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("BHI region per capita GDP")
```

![](eco_prep_files/figure-markdown_github/plot%20per%20capita%20gdp%20per%20BHI%20region-1.png)

### 5.4 Data layer for layers

Will export per capita GDP. This value only changes because of changes in GDP size, the population size is static because only have data from 2005.
\#\#\# 5.4.1 Prepare object for csv

``` r
bhi_gdp_layer = bhi_gdp %>%
                select(rgn_id,year,bhi_gdp_per_capita)
```

### 5.4.2

``` r
write.csv(bhi_gdp_layer, file.path(dir_layers, "le_gdp_region_bhi2015.csv"),row.names=FALSE)
```

6.Country GDP prep
------------------

### 6.1 Organize data

#### 6.1.1 Read in data

``` r
## read EU national GDP
country_gdp = read.csv(file.path(dir_eco, 'eco_data_database/nuts0_gdp.csv'))
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
russian_nat_gdp = read.csv(file.path(dir_eco, 'eco_data_database/ru_nat_gdp.csv'))

dim(russian_nat_gdp) #16 6
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
              mutate(unit = as.character(unit))%>%
              filter(unit == "Current prices, million euro")%>%
              mutate(unit = "million euro")

dim(country_gdp) #[1] 128   8
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

    ## 'data.frame':    144 obs. of  6 variables:
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

![](eco_prep_files/figure-markdown_github/plot%20national%20GDP-1.png)

### 6.4 Per capita national gdp

#### 6.4.1 read in population data

These data are in the folder 'eco\_data\_database' but have not yet been taken from server into BHI database

``` r
eu_pop = read.csv(file.path(dir_eco, 'eco_data_database/demo_gind_1_Data_cleaned.csv'), sep=";", stringsAsFactors = FALSE)

str(eu_pop)
```

    ## 'data.frame':    7020 obs. of  7 variables:
    ##  $ TIME              : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ TIME_LABEL        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ GEO               : chr  "BE" "BE" "BE" "BE" ...
    ##  $ GEO_LABEL         : chr  "Belgium" "Belgium" "Belgium" "Belgium" ...
    ##  $ INDIC_DE          : chr  "Population on 1 January - total " "Population on 1 January - males" "Population on 1 January - females" "Average population - total" ...
    ##  $ Value             : chr  "9947782" "4860099" "5087683" "9967379" ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...

``` r
dim(eu_pop)
```

    ## [1] 7020    7

``` r
ru_pop = read.csv(file.path(dir_eco, 'eco_data_database/naida_10_pe_1_Data_cleaned.csv'), sep=";", stringsAsFactors = FALSE)

str(ru_pop)
```

    ## 'data.frame':    82 obs. of  8 variables:
    ##  $ TIME              : int  1975 1975 1976 1976 1977 1977 1978 1978 1979 1979 ...
    ##  $ GEO               : chr  "RU" "RU" "RU" "RU" ...
    ##  $ GEO_LABEL         : chr  "Russia" "Russia" "Russia" "Russia" ...
    ##  $ UNIT              : chr  "THS_PER" "THS_PER" "THS_PER" "THS_PER" ...
    ##  $ UNIT_LABEL        : chr  "Thousand persons" "Thousand persons" "Thousand persons" "Thousand persons" ...
    ##  $ NA_ITEM           : chr  "Total population national concept" "Total employment domestic concept" "Total population national concept" "Total employment domestic concept" ...
    ##  $ Value             : num  133634 NA 134549 NA 135504 ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...

``` r
dim(ru_pop)
```

    ## [1] 82  8

#### 6.4.2 clean population data

EU population size information:
Population on 1 January: Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December . However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.
[Source](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)

``` r
## EU countries
eu_pop2 = eu_pop %>%
          select(-TIME_LABEL)%>%
          dplyr::rename(year = TIME,
                        country_abb = GEO,
                        country= GEO_LABEL,
                        unit = INDIC_DE,
                        value = Value,
                        flag_notes = Flag.and.Footnotes)%>%
          filter(unit == "Population on 1 January - total " )%>% # select this meauresure of population size
          mutate(value = ifelse(value== ":", NA, value),
                value= as.numeric(value))


## select only Baltic countries and data since 2000
eu_pop3 = eu_pop2 %>%
          mutate(country = ifelse(country =="Germany (until 1990 former territory of the FRG)","Germany",country),
                 country = ifelse(country =="Germany (including former GDR)","Germany",country),
                 country_abb = ifelse(country_abb == "DE_TOT","DE",country_abb))%>%
          filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>%
          filter(year >=2000)

str(eu_pop3)           
```

    ## 'data.frame':    144 obs. of  6 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2000 2001 ...
    ##  $ country_abb: chr  "DK" "DE" "DE" "EE" ...
    ##  $ country    : chr  "Denmark" "Germany" "Germany" "Estonia" ...
    ##  $ unit       : chr  "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " ...
    ##  $ value      : num  5330020 82163475 82163475 1401250 2381715 ...
    ##  $ flag_notes : chr  "" "" "" "" ...

``` r
## check data flags
eu_pop3 %>% select(flag_notes)%>%distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          b

``` r
eu_pop3 %>% filter(flag_notes == "b")  ## b = break in time series -- this should be fine
```

    ##   year country_abb country                             unit    value
    ## 1 2000          PL  Poland Population on 1 January - total  38263303
    ## 2 2010          PL  Poland Population on 1 January - total  38022869
    ## 3 2012          DE Germany Population on 1 January - total  80327900
    ## 4 2012          DE Germany Population on 1 January - total  80327900
    ## 5 2014          DE Germany Population on 1 January - total  80767463
    ##   flag_notes
    ## 1          b
    ## 2          b
    ## 3          b
    ## 4          b
    ## 5          b

``` r
eu_pop3 = eu_pop3 %>%
          select(-flag_notes)

##-----------------------------------------------------------##
## russian data

ru_pop2 = ru_pop%>%
          dplyr::rename(year = TIME,
                        country_abb = GEO,
                        country= GEO_LABEL,
                        unit = NA_ITEM,
                        unit_type = UNIT_LABEL,
                        value = Value,
                        flag_notes = Flag.and.Footnotes)%>%
          filter(unit=="Total population national concept") %>% ## other unit is employment
          mutate(value = value *1000)%>% ## convert value to total people not in thousands unit
         select(-unit_type,-UNIT)%>%
        filter(year>=2000)

##check data flags
ru_pop2 %>% select(flag_notes)%>%distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          e

``` r
ru_pop2 %>% filter(flag_notes =="e") ## population estimated in 2012 and 2013
```

    ##   year country_abb country                              unit     value
    ## 1 2012          RU  Russia Total population national concept 143170000
    ## 2 2013          RU  Russia Total population national concept 142834000
    ##   flag_notes
    ## 1          e
    ## 2          e

``` r
ru_pop2 = ru_pop2 %>%
          select(-flag_notes)
str(ru_pop2)
```

    ## 'data.frame':    16 obs. of  5 variables:
    ##  $ year       : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ country_abb: chr  "RU" "RU" "RU" "RU" ...
    ##  $ country    : chr  "Russia" "Russia" "Russia" "Russia" ...
    ##  $ unit       : chr  "Total population national concept" "Total population national concept" "Total population national concept" "Total population national concept" ...
    ##  $ value      : num  1.47e+08 1.46e+08 1.45e+08 1.45e+08 1.44e+08 ...

#### 6.4.3 Combine EU and Russian data

``` r
nat_pop = bind_rows(eu_pop3, ru_pop2)

## add column for the 2005 value, should I use to be consistent with regional gdp
nat_pop_2005 = nat_pop %>%
               filter(year==2005) %>%
               dplyr::rename(pop_2005 = value)%>%
               select(country, pop_2005)

nat_pop = nat_pop %>%
          full_join(., nat_pop_2005, by="country")
```

#### 6.4.4 Plot national population over time

``` r
ggplot(nat_pop)+
  geom_point(aes(year,value))+
  geom_hline(aes(yintercept = pop_2005))+
  facet_wrap(~country, scales="free_y")+
  ylab("Number of people")+
  ggtitle("National Population Size")
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20national%20population-1.png)

### 6.5 Per capita National GDP

#### 

### 6.3 Join BHI region id to countries

### 6.4 Create and export country GDP data layer
