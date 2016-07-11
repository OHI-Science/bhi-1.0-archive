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
        -   [3.1 Status](#status)
        -   [3.2 Trend](#trend)
    -   [4. Other](#other)
        -   [4.1 Interpreting NA and zero](#interpreting-na-and-zero)
        -   [4.2 Data issues](#data-issues)
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
        -   [6.6 Join BHI regions on countries](#join-bhi-regions-on-countries)
        -   [6.7 Natioanl GDP Data layer for layers](#natioanl-gdp-data-layer-for-layers)
    -   [7. Status and Trend Calculation](#status-and-trend-calculation)
        -   [7.1 Assign data layer](#assign-data-layer)
        -   [7.2 Set parameters](#set-parameters)
        -   [7.3 Status calculation](#status-calculation)
        -   [7.3.4 Which BHI regions have no status](#which-bhi-regions-have-no-status)
        -   [7.3.1 Plot status](#plot-status)
        -   [7.4 Trend calculation](#trend-calculation)

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

[NUTS spatial files from Eurostat](http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts) are available for several different years: 2006, 2010, 2013. Believe 2006 was used by Marc to join with BHI shapefile. NEED TO HAVE MARC CONFIRM. This may lead to some NUTS3 naming discrepancies between the shapefile associations and the GDP data. See more in Section 4.2.2

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

### 3.1 Status

Xeco = (GDP\_Region\_c/GDP\_Region\_r)/(GDP\_Country\_c/GDP\_Country\_r)
c = current year, r=reference year
reference point is a moving window (single year value)
Region is the BHI region which is comprised of GDP data from the associated NUTS3 regions data can be in nominal GDP because is a ratio value (adjusting by a deflator would cancel out) each BHI region is composed by one or more NUTS3 regions, these are allocated by population density from each NUTS3 region associated with a given BHI region
Data are in per capita GDP in millions of euro, using only population size from 2005 for all years.

### 3.2 Trend

Trend will be calculated based on the last 5 status years by fitting a linear model.

4. Other
--------

### 4.1 Interpreting NA and zero

#### 4.1.1 Status Score of Zero

'Status scores of NA were assigned when the region had no data or insufficient data but the indicator is applicable

#### 4.1.2 Trend value of NA

Trend values of NA are assigned if there are not 5 years of data available to calculate a trend

### 4.2 Data issues

#### 4.2.1 Missing German data

No GDP data for the following German NUTS3 regions: DE80H, DE805,DE80D, DE801,DE80F, DE80I. This means that there is no data for BHI regions 13 and 16.

#### 4.2.2 Mis-assignments

1.  NUTS3 regions are assigned to a BHI region due to minor differences in borders. These are fixed manually in the data preparation in section 5.1.4

2.  Finnish NUTS3 names have changed for the NUTS3 regions associated with BHI 32. These NUTS3 population data must be manually linked to BHI region 32. Fixed manally in section 5.1.5.

3.  Finnish NUTS3 regions also changed for those associated with BHI region 32:old names FI1A3, FI1A2, FI1A1 but new names appear to be in the same locations (new names FI1D7, FI1D6, FI1D5). These are also fixed in 5.1.5

4.  No data assigned to BHI 21 - this appears to be an error associated with the assignment of NUTS3 PL634 - unclear why this happens and is not fixed.

#### 4.2.3 GDP used is for entire NUTS3 -

Population data was not extracted for the entire NUTS3 area, only for the buffer area. Therefore, the entire GDP for the NUTS3 is allocated among BHI regions, rather than only the GDP associated with the population in the buffer.

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

#### 5.1.5 Correct error with Finnish name change

Finnish name changes to NUTS regions around the Gulf of Finland (minor fraction also Aland Sea) as well as round the Bothnian Sea result in mismatches between names in the GDP data (new names) and the shapefiles (old names).
![New Finnish NUTS3 names](new_FI_nuts3.png?raw=TRUE) ![Old Finnish NUTS3 names](BHI_regions_NUTS3_plot.png?raw=TRUE)

``` r
new_fi_nuts3 = c("FI1C4","FI1B1", "FI1D7","FI1D6","FI1D5")
old_fi_nuts3 = c("FI186","FI182","FI181", "FI1A3","FI1A2","FI1A1")

## select the GDP associated with the new NUTS3 names
gdp_new = regional_gdp1 %>%
          filter(nuts3 %in% new_fi_nuts3)

## select the population in the buffer associated with the old NUTS3 names
old_pop = read.csv(file.path(dir_eco, 'eco_data_database/fi_pop.csv'), stringsAsFactors = FALSE)


##modify objects to join information
gdp_new = gdp_new %>%
          select(year,nuts3, nuts3_name,unit,value,flag_notes)

old_pop = old_pop %>%
          select(BHI_ID, NUTS_ID, PopTot,
                 PopTot_density_in_buffer_per_km2,CNTR_CODE,rgn_nam,
                 Subbasin,NUTS3_area_in_BHI_buffer_km2)%>%
          dplyr::rename(rgn_id = BHI_ID, nuts3 = NUTS_ID,
                        pop = PopTot, 
                        pop_km2 = PopTot_density_in_buffer_per_km2,
                        country_abb = CNTR_CODE,country=rgn_nam, basin= Subbasin,
                        area_nuts3_in_bhi_buffer= NUTS3_area_in_BHI_buffer_km2)%>%
          mutate(rgn_id = ifelse(rgn_id == 41 & nuts3 == "FI1A3",42,rgn_id),
                 country = ifelse(country == "Sweden" & nuts3 == "FI1A3", "Finland", country ))%>% ## FI1A3 (old name) miss-assigned to Sweden's BHI 41, fix rgn_id and country
          group_by(rgn_id,nuts3,country_abb,country,basin)%>%
          summarise(pop = sum(pop),
                    pop_km2 = sum(pop_km2),
                    area_nuts3_in_bhi_buffer = sum(area_nuts3_in_bhi_buffer)) %>%  ## sum because multiple entries for same region due to mis-label
          ungroup()
                  

old_pop = old_pop %>%
          mutate(new_nuts3 = ifelse(rgn_id == 32 & nuts3 == "FI181","FI1B1",
                             ifelse(rgn_id == 36 & nuts3 == "FI181","FI1B1",
                             ifelse(rgn_id == 32 & nuts3 == "FI182","FI1B1",
                             ifelse(rgn_id == 32 & nuts3 == "FI186","FI1C4",
                             ifelse(rgn_id == 42 & nuts3 == "FI1A1","FI1D5",
                             ifelse(rgn_id == 42 & nuts3 == "FI1A2","FI1D6",
                             ifelse(rgn_id == 42 & nuts3 == "FI1A3","FI1D7",""))))))))%>%
          mutate(new_pop = ifelse(rgn_id == 32 & new_nuts3 == "FI1B1", sum(pop),pop),
                 new_pop_km2 = ifelse(rgn_id == 32 & new_nuts3 == "FI1B1", sum(pop_km2),pop_km2),
                 new_area_in_buffer =ifelse(rgn_id == 32 & new_nuts3 == "FI1B1", sum(area_nuts3_in_bhi_buffer),area_nuts3_in_bhi_buffer) )%>% ## need to make a single object associated with 32 and FI1B1 so GDP not assigned in duplicate
          select(-nuts3,-pop,-pop_km2,-area_nuts3_in_bhi_buffer)%>%
          distinct()%>%
          dplyr::rename(pop = new_pop,
                        pop_km2 = new_pop_km2,
                        area_nuts3_in_bhi_buffer= new_area_in_buffer)

## join
updated_fi = full_join(old_pop,gdp_new,
                       by=c("new_nuts3"="nuts3"))

head(updated_fi)
```

    ## Source: local data frame [6 x 13]
    ## 
    ##   rgn_id country_abb country           basin new_nuts3     pop  pop_km2
    ##    <dbl>       <chr>   <chr>           <chr>     <chr>   <int>    <dbl>
    ## 1     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## 2     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## 3     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## 4     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## 5     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## 6     32          FI Finland Gulf of Finland     FI1B1 2713362 2874.323
    ## Variables not shown: area_nuts3_in_bhi_buffer <dbl>, year <int>,
    ##   nuts3_name <chr>, unit <chr>, value <int>, flag_notes <lgl>.

``` r
str(updated_fi)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    90 obs. of  13 variables:
    ##  $ rgn_id                  : num  32 32 32 32 32 32 32 32 32 32 ...
    ##  $ country_abb             : chr  "FI" "FI" "FI" "FI" ...
    ##  $ country                 : chr  "Finland" "Finland" "Finland" "Finland" ...
    ##  $ basin                   : chr  "Gulf of Finland" "Gulf of Finland" "Gulf of Finland" "Gulf of Finland" ...
    ##  $ new_nuts3               : chr  "FI1B1" "FI1B1" "FI1B1" "FI1B1" ...
    ##  $ pop                     : int  2713362 2713362 2713362 2713362 2713362 2713362 2713362 2713362 2713362 2713362 ...
    ##  $ pop_km2                 : num  2874 2874 2874 2874 2874 ...
    ##  $ area_nuts3_in_bhi_buffer: num  788775 788775 788775 788775 788775 ...
    ##  $ year                    : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ nuts3_name              : chr  "Helsinki-Uusimaa" "Helsinki-Uusimaa" "Helsinki-Uusimaa" "Helsinki-Uusimaa" ...
    ##  $ unit                    : chr  "Million euro" "Million euro" "Million euro" "Million euro" ...
    ##  $ value                   : int  50242 53814 54465 55017 57714 60178 64105 69676 72791 69997 ...
    ##  $ flag_notes              : logi  NA NA NA NA NA NA ...

``` r
updated_fi = updated_fi %>%
             dplyr::rename(nuts3 = new_nuts3)%>%
             select(year,nuts3, nuts3_name,unit, value,flag_notes,
                    pop,pop_km2,country_abb , basin ,area_nuts3_in_bhi_buffer,
                    rgn_id,country)
##check colnames order matches with regional_gdp1
colnames(regional_gdp1);colnames(updated_fi)
```

    ##  [1] "year"                     "nuts3"                   
    ##  [3] "nuts3_name"               "unit"                    
    ##  [5] "value"                    "flag_notes"              
    ##  [7] "pop"                      "pop_km2"                 
    ##  [9] "country_abb"              "basin"                   
    ## [11] "area_nuts3_in_bhi_buffer" "rgn_id"                  
    ## [13] "country"

    ##  [1] "year"                     "nuts3"                   
    ##  [3] "nuts3_name"               "unit"                    
    ##  [5] "value"                    "flag_notes"              
    ##  [7] "pop"                      "pop_km2"                 
    ##  [9] "country_abb"              "basin"                   
    ## [11] "area_nuts3_in_bhi_buffer" "rgn_id"                  
    ## [13] "country"

``` r
## remove FI NUTS that had no associated population and replace with the updated
regional_gdp1 = regional_gdp1 %>%
                filter(!nuts3 %in% new_fi_nuts3) %>%
                bind_rows(.,updated_fi)
```

#### 5.1.6 check NA in final years

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

    ## Source: local data frame [102 x 5]
    ## 
    ##     country_abb max_year value nuts3 rgn_id
    ##           <chr>    <int> <int> <chr>  <dbl>
    ## 1            DE     2014    NA DE803     10
    ## 2            DE     2014    NA DEF01      4
    ## 3            DE     2014    NA DEF02      8
    ## 4            DE     2014    NA DEF03     10
    ## 5            DE     2014    NA DEF06     10
    ## 6            DE     2014    NA DEF08      8
    ## 7            DE     2014    NA DEF08     10
    ## 8            DE     2014    NA DEF0A      8
    ## 9            DE     2014    NA DEF0B      8
    ## 10           DE     2014    NA DEF0C      4
    ## 11           DE     2014    NA DEF0C      8
    ## 12           DE     2014    NA DEF0D     10
    ## 13           DE     2014    NA DEF0F     10
    ## 14           DK     2014 48028 DK011      6
    ## 15           DK     2014 48028 DK011     12
    ## 16           DK     2014 36356 DK012      6
    ## 17           DK     2014 36356 DK012     12
    ## 18           DK     2014 16414 DK013      2
    ## 19           DK     2014 16414 DK013      6
    ## 20           DK     2014 16414 DK013     12
    ## 21           DK     2014  1355 DK014     15
    ## 22           DK     2014  7633 DK021      2
    ## 23           DK     2014  7633 DK021     12
    ## 24           DK     2014 18242 DK022      2
    ## 25           DK     2014 18242 DK022      3
    ## 26           DK     2014 18242 DK022      7
    ## 27           DK     2014 18242 DK022      9
    ## 28           DK     2014 18242 DK022     12
    ## 29           DK     2014 17317 DK031      3
    ## 30           DK     2014 32468 DK032      3
    ## 31           DK     2014 32468 DK032      4
    ## 32           DK     2014 19136 DK041      3
    ## 33           DK     2014 33787 DK042      2
    ## 34           DK     2014 33787 DK042      3
    ## 35           DK     2014 23028 DK050      2
    ## 36           EE     2014 12434 EE001     34
    ## 37           EE     2014  1405 EE004     25
    ## 38           EE     2014  1405 EE004     28
    ## 39           EE     2014  1405 EE004     28
    ## 40           EE     2014  1405 EE004     31
    ## 41           EE     2014  1405 EE004     34
    ## 42           EE     2014  1153 EE006     34
    ## 43           EE     2014  1567 EE007     34
    ## 44           EE     2014  1567 EE007     34
    ## 45           FI     2014    NA FI194     38
    ## 46           FI     2014    NA FI194     40
    ## 47           FI     2014    NA FI195     38
    ## 48           FI     2014    NA FI195     40
    ## 49           FI     2014    NA FI195     42
    ## 50           FI     2014    NA FI196     38
    ## 51           FI     2014    NA FI200     36
    ## 52           FI     2014    NA FI200     38
    ## 53           FI     2014    NA FI1B1     32
    ## 54           FI     2014    NA FI1C4     32
    ## 55           FI     2014    NA FI1B1     36
    ## 56           FI     2014    NA FI1D5     42
    ## 57           FI     2014    NA FI1D6     42
    ## 58           FI     2014    NA FI1D7     42
    ## 59           LT     2014    NA LT003     23
    ## 60           LT     2014    NA LT003     23
    ## 61           LT     2014    NA LT003     23
    ## 62           LV     2014    NA LV003     24
    ## 63           LV     2014    NA LV003     24
    ## 64           LV     2014    NA LV003     27
    ## 65           LV     2014    NA LV006     27
    ## 66           LV     2014    NA LV007     27
    ## 67           LV     2014    NA LV007     27
    ## 68           LV     2014    NA LV009     27
    ## 69           PL     2014    NA PL424     17
    ## 70           PL     2014    NA PL621     18
    ## 71           PL     2014    NA PL621     18
    ## 72           PL     2014    NA PL622     18
    ## 73           PL     2014    NA PL633     18
    ## 74           PL     2014    NA PL634     17
    ## 75           PL     2014    NA PL634     18
    ## 76           SE     2014    NA SE110     29
    ## 77           SE     2014    NA SE110     35
    ## 78           SE     2014    NA SE121     35
    ## 79           SE     2014    NA SE121     37
    ## 80           SE     2014    NA SE122     29
    ## 81           SE     2014    NA SE123     26
    ## 82           SE     2014    NA SE123     29
    ## 83           SE     2014    NA SE212     14
    ## 84           SE     2014    NA SE213     14
    ## 85           SE     2014    NA SE213     26
    ## 86           SE     2014    NA SE214     20
    ## 87           SE     2014    NA SE214     26
    ## 88           SE     2014    NA SE221     14
    ## 89           SE     2014    NA SE221     26
    ## 90           SE     2014    NA SE224      1
    ## 91           SE     2014    NA SE224      5
    ## 92           SE     2014    NA SE224     11
    ## 93           SE     2014    NA SE224     14
    ## 94           SE     2014    NA SE231      1
    ## 95           SE     2014    NA SE232      1
    ## 96           SE     2014    NA SE313     37
    ## 97           SE     2014    NA SE321     37
    ## 98           SE     2014    NA SE331     37
    ## 99           SE     2014    NA SE331     39
    ## 100          SE     2014    NA SE331     41
    ## ..          ...      ...   ...   ...    ...

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

    ## 'data.frame':    1530 obs. of  13 variables:
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
    ##  $ rgn_id                  : num  10 10 10 10 10 10 10 10 10 10 ...
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

    ## Source: local data frame [102 x 5]
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

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    490 obs. of  5 variables:
    ##  $ rgn_id            : num  1 1 1 1 1 1 1 1 1 1 ...
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

``` r
## check flag_notes
country_gdp3 %>% select(flag_notes)%>% distinct()
```

    ##   flag_notes
    ## 1           
    ## 2  estimated

``` r
country_gdp3%>% filter(flag_notes == "estimated") ## two years GDP is estimated for Russia, 2000,2001  ## elimate column
```

    ##   year country country_abb         unit    value flag_notes
    ## 1 2000  Russia          RU million euro 280496.3  estimated
    ## 2 2001  Russia          RU million euro 341640.2  estimated

``` r
country_gdp3 = country_gdp3 %>%
               select(-flag_notes)
```

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

  dim(eu_pop3) ## Germany is duplicated because of GDR and FRG but in more recent years, value occurs twice ##144 6
```

    ## [1] 144   6

``` r
eu_pop3 = eu_pop3 %>%
          distinct()

dim(eu_pop3) ##129 6
```

    ## [1] 129   6

``` r
str(eu_pop3)           
```

    ## 'data.frame':    129 obs. of  6 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 ...
    ##  $ country_abb: chr  "DK" "DE" "EE" "LV" ...
    ##  $ country    : chr  "Denmark" "Germany" "Estonia" "Latvia" ...
    ##  $ unit       : chr  "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " ...
    ##  $ value      : num  5330020 82163475 1401250 2381715 3512074 ...
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
    ## 4 2014          DE Germany Population on 1 January - total  80767463
    ##   flag_notes
    ## 1          b
    ## 2          b
    ## 3          b
    ## 4          b

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

Calculate the national per capita GDP. Do in two different ways: (1) use the population in each year to calculate per capita GDP and (2) use the 2005 population in every year, such that the change in per capita GDP only reflect GDP change not population changes. This is to explore the consequences because regional per capita GDP is only possible by the second approach.

#### 6.5.1 Join GDP and population data

``` r
## rename some columns for clarity
str(country_gdp3)
```

    ## 'data.frame':    144 obs. of  5 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 ...
    ##  $ country    : chr  "Denmark" "Germany" "Estonia" "Latvia" ...
    ##  $ country_abb: chr  "DK" "DE" "EE" "LV" ...
    ##  $ unit       : chr  "million euro" "million euro" "million euro" "million euro" ...
    ##  $ value      : num  178018 2116480 6171 8606 12491 ...

``` r
str(nat_pop)
```

    ## 'data.frame':    145 obs. of  6 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 ...
    ##  $ country_abb: chr  "DK" "DE" "EE" "LV" ...
    ##  $ country    : chr  "Denmark" "Germany" "Estonia" "Latvia" ...
    ##  $ unit       : chr  "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " ...
    ##  $ value      : num  5330020 82163475 1401250 2381715 3512074 ...
    ##  $ pop_2005   : num  5411405 82500849 1358850 2249724 3355220 ...

``` r
country_gdp3 = country_gdp3 %>%
               dplyr::rename(unit_gdp = unit,
                             gdp = value)


nat_pop = nat_pop %>%
          dplyr::rename(unit_pop = unit,
                        pop_size = value)


## join
nat_gdp_pop = full_join(country_gdp3,nat_pop,
                        by=c("country","country_abb","year"))%>%
              arrange(country,year)


dim(nat_gdp_pop) ##145  8
```

    ## [1] 145   8

``` r
str(nat_gdp_pop)
```

    ## 'data.frame':    145 obs. of  8 variables:
    ##  $ year       : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ country    : chr  "Denmark" "Denmark" "Denmark" "Denmark" ...
    ##  $ country_abb: chr  "DK" "DK" "DK" "DK" ...
    ##  $ unit_gdp   : chr  "million euro" "million euro" "million euro" "million euro" ...
    ##  $ gdp        : num  178018 184046 189795 193353 202317 ...
    ##  $ unit_pop   : chr  "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " ...
    ##  $ pop_size   : num  5330020 5349212 5368354 5383507 5397640 ...
    ##  $ pop_2005   : num  5411405 5411405 5411405 5411405 5411405 ...

``` r
nat_gdp_pop %>% select(country)%>%distinct() #check country list
```

    ##     country
    ## 1   Denmark
    ## 2   Estonia
    ## 3   Finland
    ## 4   Germany
    ## 5    Latvia
    ## 6 Lithuania
    ## 7    Poland
    ## 8    Russia
    ## 9    Sweden

#### 6.5.2 Calculate national per capita GDP two ways

``` r
nat_gdp_pop = nat_gdp_pop %>%
              mutate(gdp_per_cap = gdp / pop_size,
                     gdp_per_cap_2005 = gdp / pop_2005)
```

#### 6.5.3 Plot national per capita GDP calcuated two ways

Note, there is no population data for Russia in 2014, that is why there is a difference in the number of data points between the two methods.

``` r
ggplot(nat_gdp_pop)+
  geom_point(aes(year, gdp_per_cap, colour=country))+
  geom_line(aes(year, gdp_per_cap, colour=country))+
  ylab("GDP per capita (million euro)")+
  ggtitle("National per capita GDP, population size by year")
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_path).

![](eco_prep_files/figure-markdown_github/plot%20nat%20per%20cap%20gdp%20both%20calculations-1.png)

``` r
ggplot(nat_gdp_pop)+
  geom_point(aes(year, gdp_per_cap_2005, colour=country))+
  geom_line(aes(year, gdp_per_cap_2005, colour=country))+
  ylab("GDP per capita (million euro)")+
  ggtitle("National per capita GDP, population size fixed to 2005")
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_path).

![](eco_prep_files/figure-markdown_github/plot%20nat%20per%20cap%20gdp%20both%20calculations-2.png)

``` r
## comparison plot
ggplot(nat_gdp_pop)+
  geom_point(aes(year, gdp_per_cap_2005), colour="green",shape=0)+
  geom_line(aes(year, gdp_per_cap_2005),colour="green")+
    geom_point(aes(year, gdp_per_cap),shape=1)+
  geom_line(aes(year, gdp_per_cap))+
  facet_wrap(~country, scales="free_y")+
  ylab("GDP per capita (million euro)")+
  ggtitle("National per capita GDP, compare population size alternatives")
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20nat%20per%20cap%20gdp%20both%20calculations-3.png)

#### 6.5.4 Decision on national per capita GDP

Seems to have relatively little effect. Choose to use a fixed population size (2005) so that it is consistent with the regional GDP approach.

``` r
nat_gdp_pop = nat_gdp_pop %>%
              select(year, country, country_abb, unit_gdp, gdp_per_cap_2005)%>%
              mutate(unit_gdp = "per capita million euro")
```

### 6.6 Join BHI regions on countries

#### 6.6.1 Load BHI region lookup

``` r
bhi_lookup = read.csv(file.path(dir_eco, "bhi_basin_country_lookup.csv"), sep=";",stringsAsFactors = FALSE) %>%
            select(rgn_nam, BHI_ID)%>%
            dplyr::rename(country= rgn_nam,
                          rgn_id = BHI_ID)

str(bhi_lookup)
```

    ## 'data.frame':    42 obs. of  2 variables:
    ##  $ country: chr  "Sweden" "Denmark" "Denmark" "Germany" ...
    ##  $ rgn_id : int  1 2 3 4 5 6 7 8 9 10 ...

#### 6.6.2 Join BHI region lookup and national GDP data

``` r
rgn_nat_gdp = full_join(bhi_lookup,nat_gdp_pop,
                        by="country")

str(rgn_nat_gdp)
```

    ## 'data.frame':    677 obs. of  6 variables:
    ##  $ country         : chr  "Sweden" "Sweden" "Sweden" "Sweden" ...
    ##  $ rgn_id          : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ year            : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ country_abb     : chr  "SE" "SE" "SE" "SE" ...
    ##  $ unit_gdp        : chr  "per capita million euro" "per capita million euro" "per capita million euro" "per capita million euro" ...
    ##  $ gdp_per_cap_2005: num  0.0313 0.0297 0.0311 0.0326 0.0341 ...

``` r
## check unique rgns
rgn_nat_gdp %>% select(rgn_id) %>% distinct() %>% nrow() ##42
```

    ## [1] 42

#### 6.6.3 plot national gdp by region to check

``` r
ggplot(rgn_nat_gdp)+
  geom_point(aes(year,gdp_per_cap_2005))+
  facet_wrap(~rgn_id)+
  ylab("GDP per capita (million euro)")+
  ggtitle("National Per Capita GDP by BHI region")
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20nat%20gdp%20by%20bhi%20region-1.png)

### 6.7 Natioanl GDP Data layer for layers

Will export per national capita GDP. This value only changes because of changes in GDP size, the population size is static because using fixed population size from 2005.

#### 6.7.1 Prepare object for csv

``` r
bhi_nat_gdp_layer = rgn_nat_gdp %>%
                      select(rgn_id,year,gdp_per_cap_2005)%>%
                      filter(year < 2014) ## so years are consistent with regional gdp

str(bhi_nat_gdp_layer)
```

    ## 'data.frame':    588 obs. of  3 variables:
    ##  $ rgn_id          : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ year            : int  2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ...
    ##  $ gdp_per_cap_2005: num  0.0313 0.0297 0.0311 0.0326 0.0341 ...

#### 6.7.2

``` r
write.csv(bhi_nat_gdp_layer, file.path(dir_layers, "le_gdp_country_bhi2015.csv"),row.names=FALSE)
```

7. Status and Trend Calculation
-------------------------------

Status and trend are calculated in functions.r but code is tested and explored here.

### 7.1 Assign data layer

``` r
  le_gdp_region   = bhi_gdp_layer %>%
                  dplyr::rename(rgn_gdp_per_cap = bhi_gdp_per_capita)

  le_gdp_country  = bhi_nat_gdp_layer %>%
                    dplyr::rename(nat_gdp_per_cap = gdp_per_cap_2005)
```

### 7.2 Set parameters

``` r
 ## set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend
```

### 7.3 Status calculation

#### 7.3.1 prepare region and country layers

``` r
## ECO region: prepare for calculations with a lag
  eco_region = le_gdp_region %>%
    dplyr::rename(gdp = rgn_gdp_per_cap) %>%
    filter(!is.na(gdp)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(gdp, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = gdp/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value)

head( eco_region)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##   rgn_id  year rgn_value
    ##    <dbl> <int>     <dbl>
    ## 1      1  2008  1.189080
    ## 2      2  2008  1.191704
    ## 3      3  2008  1.214566
    ## 4      4  2008  1.153353
    ## 5      5  2008  1.195502
    ## 6      6  2008  1.260872

``` r
dim(eco_region) ##210 3
```

    ## [1] 210   3

``` r
## ECO country
  eco_country = le_gdp_country %>%
    dplyr::rename(gdp = nat_gdp_per_cap) %>%
    filter(!is.na(gdp)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(gdp, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(cntry_value = gdp/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,cntry_value)

  head(eco_country)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##   rgn_id  year cntry_value
    ##    <int> <int>       <dbl>
    ## 1      1  2008    1.200626
    ## 2      2  2008    1.246874
    ## 3      3  2008    1.246874
    ## 4      4  2008    1.153895
    ## 5      5  2008    1.200626
    ## 6      6  2008    1.246874

``` r
  dim(eco_country) ## 252  3
```

    ## [1] 252   3

#### 7.3.2 Calculate status time series

``` r
## calculate status
  eco_status_calc = inner_join(eco_region,eco_country, by=c("rgn_id","year"))%>% #join region and country current/ref ratios ## inner_join because need to have both region and country values to calculate
               mutate(Xeco = rgn_value/cntry_value)%>% #calculate status
               mutate(status = pmin(1, Xeco)) # status calculated cannot exceed 1

  head(eco_status_calc)
```

    ## Source: local data frame [6 x 6]
    ## 
    ##   rgn_id  year rgn_value cntry_value      Xeco    status
    ##    <dbl> <int>     <dbl>       <dbl>     <dbl>     <dbl>
    ## 1      1  2008  1.189080    1.200626 0.9903833 0.9903833
    ## 2      2  2008  1.191704    1.246874 0.9557538 0.9557538
    ## 3      3  2008  1.214566    1.246874 0.9740890 0.9740890
    ## 4      4  2008  1.153353    1.153895 0.9995296 0.9995296
    ## 5      5  2008  1.195502    1.200626 0.9957325 0.9957325
    ## 6      6  2008  1.260872    1.246874 1.0112269 1.0000000

``` r
  dim(eco_status_calc) ## 210 6
```

    ## [1] 210   6

#### 7.3.3 Extract most recent year status

``` r
eco_status = eco_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data
              mutate(score=round(status*100),   #scale to 0 to 100
                     dimension = 'status')%>%
              select(region_id = rgn_id,score, dimension) #%>%
              ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
                                    ##will this cause problems if there are regions that should be NA (because indicator is not applicable?)

head(eco_status)
```

    ##   region_id score dimension
    ## 1         1    98    status
    ## 2         2    97    status
    ## 3         3    99    status
    ## 4         4    97    status
    ## 5         5    99    status
    ## 6         6   100    status

``` r
## what is max year
max_year_status= eco_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              select(rgn_id,year)
max_year_status %>% select(year)%>% distinct() ## all final years are 2013
```

    ## Source: local data frame [1 x 1]
    ## 
    ##    year
    ##   <int>
    ## 1  2013

### 7.3.4 Which BHI regions have no status

Regions 13,16,19,21,22,30,32,33 have NA status.

Russian regions have NA status because no regional data (19,22,33)

Regions with no coast line have no status because not joined to a NUTS reion (30)

Regions with missing regional data: 13,16 (from Germany see below)

Region with mis-assigned NUTS3 to BHI regions: 21 - See 4.2.2 about Polish NUTS3 regions

``` r
eco_status %>% filter(is.na(score)) #13,16,19,21,22,30,33
```

    ##   region_id score dimension
    ## 1        13    NA    status
    ## 2        16    NA    status
    ## 3        19    NA    status
    ## 4        21    NA    status
    ## 5        22    NA    status
    ## 6        30    NA    status
    ## 7        33    NA    status

``` r
eco_status_calc %>% filter(rgn_id == 13)
```

    ## Source: local data frame [0 x 6]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>,
    ##   cntry_value <dbl>, Xeco <dbl>, status <dbl>.

``` r
eco_region %>% filter(rgn_id == 13) ## No data for associated German NUTS3 DE80H, DE805, DE80D
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>.

``` r
eco_status_calc %>% filter(rgn_id == 16)
```

    ## Source: local data frame [0 x 6]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>,
    ##   cntry_value <dbl>, Xeco <dbl>, status <dbl>.

``` r
eco_region %>% filter(rgn_id == 16)## no data for associated German NUTS3 DE80F, DE80I
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>.

``` r
eco_status_calc %>% filter(rgn_id == 21)
```

    ## Source: local data frame [0 x 6]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>,
    ##   cntry_value <dbl>, Xeco <dbl>, status <dbl>.

``` r
eco_region %>% filter(rgn_id == 21)  ## based on Eurostat nuts3 map (http://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/#) should be associated with PL634. PL634 assigned to 17 and 18.  This appears to be an error!!
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: rgn_id <dbl>, year <int>, rgn_value <dbl>.

### 7.3.1 Plot status

Status values in the time series are between 0 and 1.
There are no values for Russia because we do not have regional GDP data.
Status values for the most recent year (2013 for all regions) are transformed to value between 0 and 100

``` r
## plot eco status time series
ggplot(eco_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(0,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("ECO status time series")
```

![](eco_prep_files/figure-markdown_github/plot%20eco%20status-1.png)

``` r
## plot eco status time series, less range on y-axis
ggplot(eco_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(.8,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("ECO status time series - different y-axis range")
```

![](eco_prep_files/figure-markdown_github/plot%20eco%20status-2.png)

``` r
## plot final year (2013) status

ggplot(eco_status)+
  geom_point(aes(region_id,score), size=2)+
  ylim(0,100)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("ECO status score in 2013")
```

    ## Warning: Removed 7 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20eco%20status-3.png)

### 7.4 Trend calculation

#### 7.4.1 Calculate Trend

``` r
  ## calculate trend for 5 years (5 data points)
  ## years are filtered in eco_region and eco_country, so not filtered for here
      eco_trend = eco_status_calc %>%
        filter(year >= max(year - trend_yr))%>%                #select five years of data for trend
        filter(!is.na(status)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
        group_by(rgn_id) %>%
        mutate(regr_length = n())%>%                            #get the number of status years available for greggion
        filter(regr_length == (trend_yr + 1))%>%                   #only do the regression for regions that have 5 data points
          do(mdl = lm(status ~ year, data = .)) %>%             # regression model to get the trend
            summarize(rgn_id = rgn_id,
                      score = coef(mdl)['year'] * lag_win)%>%
        ungroup() %>%
        full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
        mutate(score = round(score, 2),
               dimension = "trend") %>%
        select(region_id = rgn_id, dimension, score) %>%
        data.frame()
```

#### 7.4.2 Which regions have NA trend?

Same regions as NA status (13,16,19,21,22,30,33)

``` r
eco_trend %>% filter(is.na(score)) ## 13,16,19,21,22,30,33
```

    ##   region_id dimension score
    ## 1        13     trend    NA
    ## 2        16     trend    NA
    ## 3        19     trend    NA
    ## 4        21     trend    NA
    ## 5        22     trend    NA
    ## 6        30     trend    NA
    ## 7        33     trend    NA

#### 7.4.3 Plot trend

``` r
ggplot(eco_trend)+
  geom_point(aes(region_id,score), size=2)+
  geom_hline(yintercept = 0)+
  ylim(-1,1)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("ECO 5 yr trend score")
```

    ## Warning: Removed 7 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20eco%20trend-1.png)

#### 7.5 Plot trend and status together

``` r
plot_eco = bind_rows(eco_status,eco_trend)

ggplot(plot_eco)+
  geom_point(aes(region_id,score),size=2.5)+
  facet_wrap(~dimension, scales = "free_y")+
  ylab("Score")+
  ggtitle("ECO Status and Trend")
```

    ## Warning: Removed 14 rows containing missing values (geom_point).

![](eco_prep_files/figure-markdown_github/plot%20eco%20trend%20and%20status%20together-1.png)
