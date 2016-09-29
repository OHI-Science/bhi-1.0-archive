Livelihoods (LIV) Subgoal Data Preparation
================

-   [1. Background](#background)
-   [2. Data](#data)
    -   [2.1 NUTS0 (country) and NUTS2 region Employment rate](#nuts0-country-and-nuts2-region-employment-rate)
    -   [2.2 Russian data](#russian-data)
    -   [2.3 Population density data](#population-density-data)
    -   [2.4 Aligning BHI regions with NUTS2 regions and population density](#aligning-bhi-regions-with-nuts2-regions-and-population-density)
-   [3. Goal model](#goal-model)
-   [5. Regional data prep](#regional-data-prep)
    -   [5.1 Data organization](#data-organization)
    -   [5.2 Join datasets](#join-datasets)
    -   [5.3 Are BHI regions missing?](#are-bhi-regions-missing)
    -   [5.4 Calculate number of employed people and allocation to BHI regions](#calculate-number-of-employed-people-and-allocation-to-bhi-regions)
    -   [5.5 Data layer for layers](#data-layer-for-layers)
    -   [6. Country data prep](#country-data-prep)
    -   [6.1 Organize data](#organize-data)
    -   [6.2 Transform EU data in number of people employed](#transform-eu-data-in-number-of-people-employed)
    -   [6.3 Join EU and Russian data](#join-eu-and-russian-data)
    -   [6.3.1 Join EU and Russian data](#join-eu-and-russian-data-1)
    -   [6.3.3. Restrict to Final year 2014](#restrict-to-final-year-2014)
    -   [6.4 National data by BHI regions](#national-data-by-bhi-regions)
    -   [6.5 Prepare national data layer for layer](#prepare-national-data-layer-for-layer)
-   [7. Status and Trend calculation exploration](#status-and-trend-calculation-exploration)
    -   [7.1 Assign data layer](#assign-data-layer)
    -   [7.2 Set parameters](#set-parameters)
    -   [7.3 Status calculation](#status-calculation)
    -   [7.3.4 Which BHI regions have no status](#which-bhi-regions-have-no-status)
    -   [7.3.1 Plot status](#plot-status)
    -   [7.4 Trend calculation](#trend-calculation)
-   [8. Data issues and concerns](#data-issues-and-concerns)
    -   [8.1 Shapefile incorrect assignments](#shapefile-incorrect-assignments)
    -   [8.2 Finnish NUTS2 name discrepancies](#finnish-nuts2-name-discrepancies)
    -   [8.3 No Russian regional data](#no-russian-regional-data)
    -   [8.4 Employment data for EU transformed from percent to number of people using 2005 population data for all years](#employment-data-for-eu-transformed-from-percent-to-number-of-people-using-2005-population-data-for-all-years)
    -   [8.5 Short Danish timeseries](#short-danish-timeseries)
    -   [9. Update region assignment](#update-region-assignment)

1. Background
-------------

"This sub-goal describes livelihood quantity and quality for people living on the coast.
Ideally, this sub-goal would speak to the quality and quantity of marine jobs in an area. It would encompass all the marine sectors that supply jobs and wages to coastal communities, incorporating information on the sustainability of different sectors while also telling about the working conditions and job satisfaction. "

[Reference](http://ohi-science.org/goals/#livelihoods-and-economies)

2. Data
-------

#### 2.1 NUTS0 (country) and NUTS2 region Employment rate

Data downloaded on 31 March 2016 from Eurostat database [lfst\_r\_lfe2emprt](http://ec.europa.eu/eurostat/data/database?p_auth=BgwyNWIM&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=lfst_r_lfe2emprt)

*Data information*: Available for Country Level (NUTS0), NUTS1, and NUTS2; ages 15-64; All sexes; years 1999-2014

[Metadata link](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm)

**Metadata overview**

The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonisation, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi\_esms, see paragraph 21.1.).

The EU-LFS is designed to give accurate quarterly information at national level as well as annual information at NUTS 2 regional level and the compilation of these figures is well specified in the regulation. Microdata including the NUTS 2 level codes are provided by all the participating countries with a good degree of geographical comparability, which allows the production and dissemination of a complete set of comparable indicators for this territorial level.

**Data flags**

-   b break in time series
-   c confidential
-   d definition differs, see metadata
-   e estimated
-   f forecast
-   i see metadata (phased out)
-   n not significant
-   p provisional
-   r revised
-   s Eurostat estimate (phased out)
-   u low reliability
-   z not applicable

### 2.2 Russian data

#### 2.2.1 Regional data

HAVE NOT OBTAINED

#### 2.2.2 Country level data

### 2.3 Population density data

#### 2.3.1 Fine scale population data

Population density data obtained from the [HYDE database](http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html)

Year of data = 2005. Data were a 5' resolution. Erik Smedberg with the Baltic Sea Center re-gridded to a 10 x 10 km grid.

Population density within a 25km buffer from the coast will be used.

*References*:

Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3.1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>

#### 2.3.2 National

**EU countries**

Downloaded on March 31 2016 from Eurostat database [demo\_gind](http://ec.europa.eu/eurostat/data/database?p_auth=whAQQAX7&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=demo_gind)

*Variables*:

-   1990-2015
-   Population on Jan1

[Metadata Link](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)

*Population on 1 January:*
Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December. However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.

**Russia**
Downloaded on 10 June 2016 from Eurostat database: [naida\_10\_pe](http://ec.europa.eu/eurostat/web/products-datasets/-/naida_10_pe)
population (thousands of people)
employment (thousands of people) *need to exclude this*

### 2.4 Aligning BHI regions with NUTS2 regions and population density

UPDATE with Marc's methods or link

3. Goal model
-------------

Xliv = (Employment\_Region\_c/Employment\_Region\_r) / (Employment\_Region\_c/Employment\_Region\_r)

-   c = current year, r=reference year
-   reference point is a moving window (single year value)
-   Region is the BHI region - number of employed persons associated in the BHI region
-   Each BHI region is composed by one or more NUTS2 regions.
-   NUTS2 employment percentage multipled by the by population in the 25km inland buffer associated with a BHI region. Sum across all associated with a BHI region to get the total employed people in the BHI region.
-   For country data, need to also get population size so can have total number of people employed, not percent employed

5. Regional data prep
---------------------

### 5.1 Data organization

``` r
## Libraries
library(RMySQL)
library(tidyverse)
library(tools)
library(rgdal) 

source('~/github/bhi/baltic2015/prep/common.r')
dir_liv    = file.path(dir_prep, 'LIV')

## add a README.md to the prep directory 
create_readme(dir_liv, 'liv_prep.rmd')
```

#### Read in employment and population data

``` r
## read in
regional_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts2_employ.csv'), stringsAsFactors = FALSE)

# dim(regional_employ) #[1] 5344    9
# str(regional_employ)

## 9.27.2016 - updated PopDensity 
nuts2_pop_density = read_csv(file.path(dir_liv, 'liv_data_database/NUTS2_BHI_ID_Pop_density_in_buffer.csv'))
```

#### Clean Regional employment data object

``` r
regional_employ1 = regional_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, nuts2 = GEO, nuts2_name = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(nuts2 = as.character(nuts2),
                         nuts2_name = as.character(nuts2_name),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes == "b", "break in timeseries",
                                      ifelse(flag_notes == "u", "low reliability",
                                      ifelse(flag_notes == "bu", "break in timeseries and low reliability",""))))
                  
# str(regional_employ1)

## check dataflags
# regional_employ1 %>% select(flag_notes)%>% distinct()
# regional_employ1 %>% filter(flag_notes =="low reliability" ) #not Baltic country
# regional_employ1 %>% filter(flag_notes =="break in timeseries and low reliability" ) #not Baltic country
# regional_employ1 %>% filter(flag_notes =="break in timeseries") ## this is not such a concern

## remove flags_notes
regional_employ1 = regional_employ1 %>%
                   select(-flag_notes)
```

#### 5.1.3 Clean nuts2\_pop\_area

``` r
## nuts2 population data

nuts2_pop_area1 = nuts2_pop_density %>%
                  select(-PopUrb,-PopRur,-PopUrb_density_in_NUTS2_buffer_per_km2,-PopRur_density_in_NUTS2_buffer_per_km2, -HELCOM_ID) %>%
                  dplyr::rename(rgn_id = BHI_ID,
                                nuts2 = NUTS_ID,
                                pop = PopTot,
                                pop_km2 = PopTot_density_in_NUTS2_buffer_per_km2,
                                country_abb= CNTR_CODE,
                                country = rgn_nam,
                                basin = Subbasin,
                                area = NUTS2_area_in_BHI_buffer_km2)
```

#### 4.1.3 Check NUTS2 names from Finland

Shapefiles have names from 2006, check accom1 and accom\_coast1 to see if the names have been updated, will need to fix.

-   ![Map of old NUTS2 names for Gulf of Finland](BHI_regions_NUTS2_plot.png?raw=true)
-   ![Map of new NUTS2 names for Gulf of Finland](new_FI_nuts2.png?raw=true "fig:")

``` r
check1 = regional_employ1 %>% filter(grepl("FI", nuts2)) %>% 
  select(nuts2, nuts2_name) %>% 
  distinct()
## These are the newer region names : FI1B, FI1C, FI1D

check2 = nuts2_pop_area1 %>% 
  filter(grepl("FI", nuts2)) %>% 
  select(nuts2) %>% 
  distinct()
## These are the older region names: FI18, FI1A

## Challenge because of coasts
## FI1C is associated with both the Gulf of Finland and the Aland Sea. FI1B has a small fraction associated with Aland Sea, the rest is Gulf of Finland

## Old FI18, contains both FI1C and FI1B. May need to combine data from the new regions, and apply fraction from the older region.  Helsinki is in FI1B, which would assign almost entirely to BHI 32 and whereas FI1C would divide more equally btween BHI 36 and BHI 32. Therefore, combining these regions in order to apply the division generated from the old region may have a different result.

## old FI1A seems to be the same along the coast as the new FI1D but new FI1D covers inland areas previously in FI13

## Do this after joining accom and accom_coast with the nuts2_pop_area data, will have to add these regions back in.
```

#### 4.1.4 Check for incorrectly assigned NUTS2 regions to BHI regions and fix

Note - (as in NUTS3 assignment issues see ECO).

``` r
## write to csv, fix manually, re-import csv
misassigned_nuts2 = nuts2_pop_area1 %>% select(nuts2, country, rgn_id)

## read in corrected assignments - same file as used for TR

# add BHI rgn 21 to the previously corrected file. 9.28.2016. 
corrected_nuts2 = read.csv(file.path(dir_liv,"misassigned_nuts2_manually_corrected.csv"), sep=";", stringsAsFactors = FALSE) %>%       rbind(c("PL63","Poland", as.integer(21),NA,NA, "", as.integer(21), 'Poland')) %>%
      mutate(rgn_id = as.integer((rgn_id)),
             X.correct_BH_ID = as.integer(X.correct_BH_ID))

## join nuts2_pop_area1 with corrected data and fix

nuts2_pop_area2 = nuts2_pop_area1 %>%
                  full_join(., corrected_nuts2,
                            by=c("rgn_id","nuts2","country")) %>%
                  select(-country,-rgn_id,-incorrect,-BHI_ID_manual, -X.country_manual) %>%
                  dplyr::rename(country =X.correct_country,
                               rgn_id = X.correct_BH_ID) %>%
                  select(rgn_id,nuts2,country,country_abb,basin,pop,pop_km2,area) %>%
                  group_by(rgn_id, nuts2, country,country_abb,basin) %>%
                  summarise(pop =sum(pop),
                            pop_km2 = sum(pop_km2),
                            area = sum(area)) %>% ## some regions occurr twice because of correcting the assignment, sum to get single value for each region
                  ungroup()

str(nuts2_pop_area2)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    73 obs. of  8 variables:
    ##  $ rgn_id     : int  1 1 2 2 2 2 3 3 3 3 ...
    ##  $ nuts2      : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ country    : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ country_abb: chr  "SWE" "SWE" "DNK" "DNK" ...
    ##  $ basin      : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ pop        : num  55875 550191 134723 163813 89600 ...
    ##  $ pop_km2    : num  81.6 140.1 166.8 131.4 61.4 ...
    ##  $ area       : num  684 3926 808 1247 1459 ...

### 5.2 Join datasets

#### 5.2.1 Join accom times series with nuts pop and area

Join data with inner join, this will exclude Finland areas with name mismatches. Fix Finnish data and add back into the dataset

``` r
employ_nuts1 = inner_join(regional_employ1, nuts2_pop_area2,
                         by=c("nuts2"))

# dim(regional_employ1) ## 5344    5
# dim(nuts2_pop_area2) ## 60 8
# dim(employ_nuts1) ## 896  12

# str(employ_nuts1) ## this is now missing the Finnish data where there are name discrepancies
```

#### 5.2.2 Get Finnish data that was excluded

One challenge is that the new regions are two regions (FI1B,FI1C) where the old region was one (FI18). FI1B includes Helsinki and plot below shows similar pattern but that FI1B is between 5.8 to 6.8 higher than FI1C.

Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate.

FI1D (new name) areas match old FIA1 areas - so this is a straight-forward fix.

![See Population density from Eurostat](pop_density_nuts2_FI.png?raw=TRUE) [Eurostat Population density image source](http://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/#). Layer is under 'Background Maps'

``` r
## Get Finnish data renamed so that employmodating and population data match
fi_employ_newnuts = regional_employ1 %>%
                   filter(nuts2 %in% c("FI1C","FI1B", "FI1D"))
# fi_employ_newnuts

## compare the employment percentage between FI1C and FI1B which used to be one region
ggplot(fi_employ_newnuts)+
  geom_point(aes(year,value, colour=nuts2, shape=nuts2))+
  ggtitle("Comparison of Finnish Region NUTS2 Employment percentage")
```

    ## Warning: Removed 18 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/Get%20Finnish%20data%20that%20was%20excluded-1.png)

``` r
## difference between FI1B and FI1C
fi_employ_newnuts %>% 
  select(-nuts2_name)%>%
  spread(nuts2,value) %>%
  mutate(diff_1b_1c = FI1B - FI1C) %>%
  filter(!is.na(diff_1b_1c))
```

    ##    year       unit FI1B FI1C FI1D diff_1b_1c
    ## 1  2005 Percentage 74.3 68.3 62.8        6.0
    ## 2  2006 Percentage 75.1 69.1 63.7        6.0
    ## 3  2007 Percentage 75.7 69.9 63.9        5.8
    ## 4  2008 Percentage 76.5 70.7 65.4        5.8
    ## 5  2009 Percentage 74.3 68.0 63.1        6.3
    ## 6  2010 Percentage 73.5 66.7 63.5        6.8
    ## 7  2011 Percentage 74.3 67.4 64.5        6.9
    ## 8  2012 Percentage 74.1 68.8 64.5        5.3
    ## 9  2013 Percentage 73.4 67.0 65.3        6.4
    ## 10 2014 Percentage 73.0 66.4 65.2        6.6

``` r
##Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate. 
    ## Therefore, only retain data for FI1B (exclude FI1C)

fi_employ_newnuts1 = fi_employ_newnuts %>% 
                     filter(nuts2 != "FI1C")




## assign old nuts names to employ data
fi_employ_newnuts1 = fi_employ_newnuts1 %>%
                    mutate(nuts_old = ifelse(nuts2 == "FI1B", "FI18",
                                      ifelse(nuts2 == "FI1D", "FI1A","")),
                           nuts2_name_old= ifelse(nuts2 == "FI1B","old region",nuts2_name ))%>%
                    select(-nuts2, -nuts2_name)%>%
                    dplyr::rename(nuts2=nuts_old,
                                  nuts2_name = nuts2_name_old)
                        
# head(fi_employ_newnuts1) ## there are NA but were NA for all regions in those years

## Get population data associated with old nuts names
fi_nuts_oldnuts = nuts2_pop_area2 %>%
                  filter(nuts2 %in% c("FI18","FI1A"))

# fi_nuts_oldnuts


## join fi employ to fi pop and area

fi_employ_correct_nuts = full_join(fi_employ_newnuts1, fi_nuts_oldnuts,
                          by=c("nuts2"))%>%
                          select(year,nuts2,nuts2_name,unit,
                                 value,rgn_id,country,country_abb,basin, pop,
                                 pop_km2,area)


# str(fi_employ_correct_nuts)
```

#### 5.2.3 Join Finnish data to other regional data

``` r
### bind to rest of data
colnames(fi_employ_correct_nuts)
```

    ##  [1] "year"        "nuts2"       "nuts2_name"  "unit"        "value"      
    ##  [6] "rgn_id"      "country"     "country_abb" "basin"       "pop"        
    ## [11] "pop_km2"     "area"

``` r
colnames(employ_nuts1)
```

    ##  [1] "year"        "nuts2"       "nuts2_name"  "unit"        "value"      
    ##  [6] "rgn_id"      "country"     "country_abb" "basin"       "pop"        
    ## [11] "pop_km2"     "area"

``` r
employ_nuts2 = bind_rows(employ_nuts1, fi_employ_correct_nuts)%>%
              dplyr::rename(employ_rate =value)
```

#### 5.2.4 Plot and check regional employment time series

``` r
ggplot(employ_nuts2)+
  geom_point(aes(year,employ_rate, colour=nuts2))+
  geom_line(aes(year,employ_rate, colour=nuts2))+
  facet_wrap(~country, scale="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Percent Employed NUTS2")
```

    ## Warning: Removed 148 rows containing missing values (geom_point).

    ## Warning: Removed 148 rows containing missing values (geom_path).

![](liv_prep_files/figure-markdown_github/Plot%20and%20check%20regional%20employment%20time%20series-1.png)

#### 5.2.5 Restrict dataset to year 2000 to 2014

``` r
employ_nuts3 = employ_nuts2 %>% 
              filter(year >=2000)
```

### 5.3 Are BHI regions missing?

Expected missing:

-   19,22, and 33 from Russia
-   21 from Poland because not assigned
-   30 has no coastline

``` r
employ_nuts3 %>% select(rgn_id)%>%distinct()%>%arrange(rgn_id)
```

    ##    rgn_id
    ## 1       1
    ## 2       2
    ## 3       3
    ## 4       4
    ## 5       5
    ## 6       6
    ## 7       7
    ## 8       8
    ## 9       9
    ## 10     10
    ## 11     11
    ## 12     12
    ## 13     13
    ## 14     14
    ## 15     15
    ## 16     16
    ## 17     17
    ## 18     18
    ## 19     20
    ## 20     21
    ## 21     23
    ## 22     24
    ## 23     25
    ## 24     26
    ## 25     27
    ## 26     28
    ## 27     29
    ## 28     31
    ## 29     32
    ## 30     34
    ## 31     35
    ## 32     36
    ## 33     37
    ## 34     38
    ## 35     39
    ## 36     40
    ## 37     41
    ## 38     42

``` r
## there are 37 regions

## missing: 19,21, 22,30,33
```

### 5.4 Calculate number of employed people and allocation to BHI regions

#### 5.4.1 Calculate the number of employed in BHI region with NUTS2 percentage

Use population within the 25km buffer and employment percentage to get the number of employed people. Population is constant at 2005 population size.

``` r
employ_nuts4 = employ_nuts3 %>%
               mutate(employ_pop = (employ_rate/100) * pop)
```

#### 5.4.2 Plot the number of people employed in each BHI region by NUTS2 region

``` r
ggplot(employ_nuts4)+
  geom_point(aes(year,employ_pop, colour=nuts2),size=.6)+
  facet_wrap(~rgn_id, scale="free_y")+
  guides(colour="none")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Number of People Employed in NUTS2 (25km buffer) by BHI region")
```

    ## Warning: Removed 128 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20nuts3%20employed%20by%20bhi%20region-1.png)

#### 5.4.3 Calculate total employed by BHI region

``` r
employ_nuts5 = employ_nuts4 %>%
               select(country,country_abb,rgn_id,year,employ_pop)%>%
               group_by(country,country_abb,rgn_id,year)%>%
               summarise(employ_pop_bhi = sum(employ_pop)) %>%
               ungroup()
```

#### 5.4.4 Plot Number of BHI employed

``` r
ggplot(employ_nuts5)+
  geom_point(aes(year,employ_pop_bhi, colour=country),size=.6)+
  facet_wrap(~rgn_id, scale="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Number of People Employed BHI region (25km buffer)")
```

    ## Warning: Removed 86 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20BHI%20employed-1.png)

### 5.5 Data layer for layers

#### 5.5.1 Prepare object for csv

``` r
liv_regional_employ = employ_nuts5 %>%
                     select(rgn_id, year, employ_pop_bhi)%>%
                     arrange(rgn_id, year)


## save also for visualize
### SAVE also for VISUALIZE
liv_rgn_time_data = employ_nuts5 %>%
                    dplyr::rename(value = employ_pop_bhi)%>%
                    mutate(unit= "employed people",
                           bhi_goal="LIV",
                           data_descrip = "NUTS2 Employment rate allocated to BHI region buffer population")

write.csv(liv_rgn_time_data, file.path(dir_baltic,'visualize/liv_rgn_time_data.csv'),row.names=FALSE)
```

#### 5.5.2 Write object to csv

``` r
write.csv(liv_regional_employ, file.path(dir_layers, 'liv_regional_employ_bhi2015.csv'),row.names =FALSE)
```

### 6. Country data prep

### 6.1 Organize data

#### 6.1.1 Read in data

``` r
## read in NUTS0 (national) employement from EU
nat_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts0_employ.csv'), stringsAsFactors = FALSE)

# dim(nat_employ) #[1] 528    9
# str(nat_employ)

## read in Russian national  pouplation and employment
ru_data = read.csv(file.path(dir_liv, 'liv_data_database/naida_10_pe_1_Data_cleaned.csv'), sep=";",stringsAsFactors = FALSE)
# dim(ru_data)
# str(ru_data)

## Read in EU population size
eu_pop = read.csv(file.path(dir_liv, 'liv_data_database/demo_gind_1_Data_cleaned.csv'), sep=";", stringsAsFactors = FALSE)
# str(eu_pop)
# dim(eu_pop)


# read in EU country abbreviations and names
eu_lookup = read.csv(file.path(dir_liv, 'EUcountrynames.csv'), sep=";")  
# dim(eu_lookup)
# str(eu_lookup)

## read in BHI look up table
bhi_lookup = read.csv(file.path(dir_liv, "bhi_basin_country_lookup.csv"), sep=";",stringsAsFactors = FALSE) %>%
            select(rgn_nam, BHI_ID)%>%
            dplyr::rename(country= rgn_nam,
                          rgn_id = BHI_ID)
```

#### 6.1.2 Clean National EU employment data object

``` r
nat_employ1 = nat_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, country_abb = GEO, country = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(country_abb = as.character(country_abb),
                         country = as.character(country),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries", ""))
                  
head(nat_employ1)
```

    ##   year country_abb country       unit value          flag_notes
    ## 1 1999          AT Austria Percentage  68.2                    
    ## 2 2000          AT Austria Percentage  67.9                    
    ## 3 2001          AT Austria Percentage  67.8                    
    ## 4 2002          AT Austria Percentage  68.1                    
    ## 5 2003          AT Austria Percentage  68.2                    
    ## 6 2004          AT Austria Percentage  65.3 break in timeseries

``` r
### check data flags
nat_employ1 %>% select(flag_notes)%>% distinct()
```

    ##            flag_notes
    ## 1                    
    ## 2 break in timeseries

``` r
nat_employ1 %>% filter(flag_notes == "break in timeseries") # not a major concern
```

    ##    year country_abb        country       unit value          flag_notes
    ## 1  2004          AT        Austria Percentage  65.3 break in timeseries
    ## 2  2005          AT        Austria Percentage  67.4 break in timeseries
    ## 3  2007          AT        Austria Percentage  69.9 break in timeseries
    ## 4  1999          BE        Belgium Percentage  58.9 break in timeseries
    ## 5  2001          BE        Belgium Percentage  59.7 break in timeseries
    ## 6  2005          BE        Belgium Percentage  61.1 break in timeseries
    ## 7  2011          BE        Belgium Percentage  61.9 break in timeseries
    ## 8  2001          BG       Bulgaria Percentage  50.7 break in timeseries
    ## 9  2003          BG       Bulgaria Percentage  53.1 break in timeseries
    ## 10 2005          BG       Bulgaria Percentage  55.8 break in timeseries
    ## 11 2008          BG       Bulgaria Percentage  64.0 break in timeseries
    ## 12 2010          BG       Bulgaria Percentage  59.8 break in timeseries
    ## 13 2011          BG       Bulgaria Percentage  58.4 break in timeseries
    ## 14 2003          HR        Croatia Percentage  53.4 break in timeseries
    ## 15 2005          HR        Croatia Percentage  55.0 break in timeseries
    ## 16 2006          HR        Croatia Percentage  55.6 break in timeseries
    ## 17 2005          CY         Cyprus Percentage  68.5 break in timeseries
    ## 18 2009          CY         Cyprus Percentage  69.0 break in timeseries
    ## 19 2005          CZ Czech Republic Percentage  64.8 break in timeseries
    ## 20 2011          CZ Czech Republic Percentage  65.7 break in timeseries
    ## 21 2005          DK        Denmark Percentage  75.9 break in timeseries
    ## 22 2000          EE        Estonia Percentage  60.9 break in timeseries
    ## 23 2005          EE        Estonia Percentage  64.8 break in timeseries
    ## 24 2000          FI        Finland Percentage  68.1 break in timeseries
    ## 25 2005          FI        Finland Percentage  68.4 break in timeseries
    ## 26 2008          FI        Finland Percentage  71.1 break in timeseries
    ## 27 2003          FR         France Percentage  63.4 break in timeseries
    ## 28 2005          FR         France Percentage  63.2 break in timeseries
    ## 29 2014          FR         France Percentage  63.8 break in timeseries
    ## 30 2005          DE        Germany Percentage  65.5 break in timeseries
    ## 31 2010          DE        Germany Percentage  71.3 break in timeseries
    ## 32 2011          DE        Germany Percentage  72.7 break in timeseries
    ## 33 2001          EL         Greece Percentage  56.5 break in timeseries
    ## 34 2004          EL         Greece Percentage  59.3 break in timeseries
    ## 35 2005          EL         Greece Percentage  59.6 break in timeseries
    ## 36 2009          EL         Greece Percentage  60.8 break in timeseries
    ## 37 2001          HU        Hungary Percentage  56.1 break in timeseries
    ## 38 2005          HU        Hungary Percentage  56.9 break in timeseries
    ## 39 2003          IS        Iceland Percentage  84.3 break in timeseries
    ## 40 2005          IS        Iceland Percentage  83.8 break in timeseries
    ## 41 2005          IE        Ireland Percentage  67.6 break in timeseries
    ## 42 2007          IE        Ireland Percentage  69.2 break in timeseries
    ## 43 2009          IE        Ireland Percentage  61.9 break in timeseries
    ## 44 2004          IT          Italy Percentage  57.8 break in timeseries
    ## 45 2005          IT          Italy Percentage  57.6 break in timeseries
    ## 46 2002          LV         Latvia Percentage  59.6 break in timeseries
    ## 47 2005          LV         Latvia Percentage  62.1 break in timeseries
    ## 48 2002          LT      Lithuania Percentage  60.6 break in timeseries
    ## 49 2005          LT      Lithuania Percentage  62.9 break in timeseries
    ## 50 2003          LU     Luxembourg Percentage  62.2 break in timeseries
    ## 51 2005          LU     Luxembourg Percentage  63.6 break in timeseries
    ## 52 2007          LU     Luxembourg Percentage  64.2 break in timeseries
    ## 53 2009          LU     Luxembourg Percentage  65.2 break in timeseries
    ## 54 2004          MT          Malta Percentage  53.4 break in timeseries
    ## 55 2005          MT          Malta Percentage  53.6 break in timeseries
    ## 56 2005          NL    Netherlands Percentage  73.2 break in timeseries
    ## 57 2010          NL    Netherlands Percentage  74.7 break in timeseries
    ## 58 2011          NL    Netherlands Percentage  74.2 break in timeseries
    ## 59 2005          NO         Norway Percentage  74.8 break in timeseries
    ## 60 2006          NO         Norway Percentage  75.4 break in timeseries
    ## 61 2000          PL         Poland Percentage  55.1 break in timeseries
    ## 62 2001          PL         Poland Percentage  53.7 break in timeseries
    ## 63 2003          PL         Poland Percentage  51.4 break in timeseries
    ## 64 2004          PL         Poland Percentage  51.4 break in timeseries
    ## 65 2005          PL         Poland Percentage  52.8 break in timeseries
    ## 66 2010          PL         Poland Percentage  58.9 break in timeseries
    ## 67 2002          PT       Portugal Percentage  69.1 break in timeseries
    ## 68 2005          PT       Portugal Percentage  67.3 break in timeseries
    ## 69 2011          PT       Portugal Percentage  63.8 break in timeseries
    ## 70 2002          RO        Romania Percentage  58.6 break in timeseries
    ## 71 2003          RO        Romania Percentage  58.7 break in timeseries
    ## 72 2005          RO        Romania Percentage  57.6 break in timeseries
    ## 73 2010          RO        Romania Percentage  60.2 break in timeseries
    ## 74 1999          SK       Slovakia Percentage  58.0 break in timeseries
    ## 75 2003          SK       Slovakia Percentage  57.9 break in timeseries
    ## 76 2005          SK       Slovakia Percentage  57.7 break in timeseries
    ## 77 2011          SK       Slovakia Percentage  59.3 break in timeseries
    ## 78 2005          SI       Slovenia Percentage  66.0 break in timeseries
    ## 79 2001          ES          Spain Percentage  57.7 break in timeseries
    ## 80 2005          ES          Spain Percentage  63.6 break in timeseries
    ## 81 2001          SE         Sweden Percentage  74.4 break in timeseries
    ## 82 2005          SE         Sweden Percentage  72.5 break in timeseries
    ## 83 2005          CH    Switzerland Percentage  77.2 break in timeseries
    ## 84 2014          TR         Turkey Percentage  49.5 break in timeseries
    ## 85 1999          UK United Kingdom Percentage  70.4 break in timeseries
    ## 86 2004          UK United Kingdom Percentage  71.6 break in timeseries
    ## 87 2005          UK United Kingdom Percentage  71.8 break in timeseries
    ## 88 2007          UK United Kingdom Percentage  71.5 break in timeseries
    ## 89 2008          UK United Kingdom Percentage  71.5 break in timeseries

``` r
### remove flag_notes

nat_employ1 = nat_employ1 %>%
              select(-flag_notes)

## Select only Baltic countries and data 2000 to end
nat_employ2 = nat_employ1 %>%
              filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>%
          filter(year >=2000)

# dim(nat_employ2)  

nat_employ2 %>% select(country) %>% distinct()
```

    ##     country
    ## 1   Denmark
    ## 2   Estonia
    ## 3   Finland
    ## 4   Germany
    ## 5    Latvia
    ## 6 Lithuania
    ## 7    Poland
    ## 8    Sweden

``` r
### plot employment by country
ggplot(nat_employ2)+
  geom_point(aes(year, value))+
  facet_wrap(~country) +
  ggtitle("Percent employed ")
```

![](liv_prep_files/figure-markdown_github/clean%20country%20data%20object-1.png)

#### 6.1.3 Clean Russian data object

Russian employment and population is in "thousand persons", transform into total number of people

``` r
## divide population and employment into separate objects

ru_data = ru_data %>%
          select(-UNIT) %>%
          dplyr::rename(year = TIME, 
                        country_abb = GEO,
                        country = GEO_LABEL,
                        unit = UNIT_LABEL,
                        dat_descrip = NA_ITEM,
                        value = Value,
                         flag_notes = Flag.and.Footnotes)

ru_data %>% select(unit, dat_descrip)%>% distinct()
```

    ##               unit                       dat_descrip
    ## 1 Thousand persons Total population national concept
    ## 2 Thousand persons Total employment domestic concept

``` r
ru_pop = ru_data %>%
         filter(dat_descrip == "Total population national concept")%>%
         mutate(ru_pop = value *1000) %>% ##transform into total number of people from thousands of people
         select(-value)

ru_employ = ru_data %>%
         filter(dat_descrip == "Total employment domestic concept")%>%
          mutate(ru_employ = value *1000) %>% ##transform into total number of people from thousands of people
         select(-value)


## check flags

ru_pop %>% select(flag_notes)%>% distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          b
    ## 3          e

``` r
ru_pop %>% filter(flag_notes == 'b' | flag_notes == 'e') ## estimated in 2012, 2013, 1989 break in time seires
```

    ##   year country_abb country             unit
    ## 1 1989          RU  Russia Thousand persons
    ## 2 2012          RU  Russia Thousand persons
    ## 3 2013          RU  Russia Thousand persons
    ##                         dat_descrip flag_notes    ru_pop
    ## 1 Total population national concept          b 146999100
    ## 2 Total population national concept          e 143170000
    ## 3 Total population national concept          e 142834000

``` r
ru_pop = ru_pop %>%
         select(-flag_notes)

ru_employ %>% select(flag_notes)%>% distinct() ## none flagged
```

    ##   flag_notes
    ## 1

``` r
ru_employ = ru_employ %>%
            select(-flag_notes)


## Select only data from 2000 to end
ru_pop = ru_pop %>%
         filter(year >=2000)

ru_employ= ru_employ %>%
         filter(year >=2000)


## Plot data
## plop Russia employment
ggplot(ru_employ) +
  geom_point(aes(year, ru_employ))+
  ylab("Number of people")+
  ggtitle("Number of People Employed - Russia")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/clean%20russian%20nat%20data%20object-1.png)

#### 6.1.4 Clean EU nat population data object

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
```

### 6.2 Transform EU data in number of people employed

Use 2005 population size. This is to be consistent with only have 2005 population size for the regional data. The same approach is used for ECO national data layer preparation.

This will mean that the data differ slightly from the Russian employment which are provided as number of people and probably then reflect population size changes as well.

However, because there is no regional Russian data, there is no Russian status calculation.

#### 6.2.1 Join EU national employment percent to population size from 2005

``` r
nat_pop_2005 = eu_pop3 %>%
               filter(year==2005) %>%
               dplyr::rename(pop_2005 = value)%>%
               select(country, pop_2005)

nat_employ3 = full_join(nat_employ2,nat_pop_2005,
                        by="country")

## number employed
nat_employ3 = nat_employ3 %>%
              dplyr::rename(employ_rate = value) %>%
              mutate(employ_pop = (employ_rate/100) * pop_2005) %>%  ## make sure to convert percentage to proportion
              select(-employ_rate, -pop_2005,-unit)
```

### 6.3 Join EU and Russian data

### 6.3.1 Join EU and Russian data

``` r
colnames(ru_employ)
```

    ## [1] "year"        "country_abb" "country"     "unit"        "dat_descrip"
    ## [6] "ru_employ"

``` r
colnames(nat_employ3)
```

    ## [1] "year"        "country_abb" "country"     "employ_pop"

``` r
## modify ru object
ru_employ = ru_employ %>%
            select(-dat_descrip)%>%
            dplyr::rename(employ_pop = ru_employ)



## bind rows
nat_employ4 = bind_rows(nat_employ3, ru_employ)
```

#### 6.3.2 Plot joined EU and Russian employment data

``` r
ggplot(nat_employ4) +
  geom_point(aes(year, employ_pop, colour = country))+
  geom_line(aes(year, employ_pop, colour = country))+
  ylab("Number of people")+
  ggtitle("Number of People Employed")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

    ## Warning: Removed 4 rows containing missing values (geom_path).

![](liv_prep_files/figure-markdown_github/plot%20joined%20EU%20and%20russian%20employment%20data-1.png)

### 6.3.3. Restrict to Final year 2014

Same as the regional data

``` r
nat_employ4 = nat_employ4 %>%
              filter( year < 2015)
```

### 6.4 National data by BHI regions

#### 6.4.1 Join national data to BHI regions

``` r
rgn_nat_employ =  full_join(bhi_lookup,nat_employ4,
                        by="country")
```

#### 6.4.2 Plot national data by BHI region

``` r
ggplot(rgn_nat_employ)+
  geom_point(aes(year,employ_pop,colour=country),size=.7)+
  facet_wrap(~rgn_id, scales="free_y")+
  ggtitle("Number People Employed Nationally for each BHI region")
```

    ## Warning: Removed 9 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20national%20data%20by%20BHI%20region-1.png)

### 6.5 Prepare national data layer for layer

#### 6.5.1 Prepare Object

``` r
liv_national_employ = rgn_nat_employ %>%
                     select(rgn_id, year, employ_pop)%>%
                     arrange(rgn_id, year)



### SAVE also for VISUALIZE
liv_nat_time_data = rgn_nat_employ %>%
                    select(rgn_id,year,value = employ_pop)%>%
                    mutate(unit= "employed people",
                           bhi_goal="ECO",
                           data_descrip = "National number of people employed (2005 pop size)")

write.csv(liv_nat_time_data, file.path(dir_baltic,'visualize/liv_nat_time_data.csv'),row.names=FALSE)
```

#### 6.5.2 Write to csv

``` r
write.csv(liv_national_employ, file.path(dir_layers,'liv_national_employ_bhi2015.csv'),row.names = FALSE)
```

7. Status and Trend calculation exploration
-------------------------------------------

Status and trend are calculated in functions.r but code is tested and explored here.

### 7.1 Assign data layer

``` r
  liv_regional_employ
```

    ## # A tibble: 765 × 3
    ##    rgn_id  year employ_pop_bhi
    ##     <int> <int>          <dbl>
    ## 1       1  2000       437489.2
    ## 2       1  2001       453582.1
    ## 3       1  2002       456333.1
    ## 4       1  2003       455559.4
    ## 5       1  2004       450152.1
    ## 6       1  2005       441190.0
    ## 7       1  2006       448127.5
    ## 8       1  2007       451389.9
    ## 9       1  2008       450736.5
    ## 10      1  2009       434213.7
    ## # ... with 755 more rows

``` r
  liv_national_employ 
```

    ##     rgn_id year employ_pop
    ## 1        1 2000  6407099.7
    ## 2        1 2001  6704475.6
    ## 3        1 2002  6668430.1
    ## 4        1 2003  6632384.5
    ## 5        1 2004  6524247.8
    ## 6        1 2005  6533259.2
    ## 7        1 2006  6587327.6
    ## 8        1 2007  6686452.9
    ## 9        1 2008  6695464.3
    ## 10       1 2009  6506225.0
    ## 11       1 2010  6497213.6
    ## 12       1 2011  6632384.5
    ## 13       1 2012  6650407.3
    ## 14       1 2013  6704475.6
    ## 15       1 2014  6749532.6
    ## 16       2 2000  4134313.4
    ## 17       2 2001  4107256.4
    ## 18       2 2002  4134313.4
    ## 19       2 2003  4063965.2
    ## 20       2 2004  4112667.8
    ## 21       2 2005  4107256.4
    ## 22       2 2006  4188427.5
    ## 23       2 2007  4166781.9
    ## 24       2 2008  4215484.5
    ## 25       2 2009  4074788.0
    ## 26       2 2010  3966559.9
    ## 27       2 2011  3955737.1
    ## 28       2 2012  3928680.0
    ## 29       2 2013  3923268.6
    ## 30       2 2014  3939502.8
    ## 31       3 2000  4134313.4
    ## 32       3 2001  4107256.4
    ## 33       3 2002  4134313.4
    ## 34       3 2003  4063965.2
    ## 35       3 2004  4112667.8
    ## 36       3 2005  4107256.4
    ## 37       3 2006  4188427.5
    ## 38       3 2007  4166781.9
    ## 39       3 2008  4215484.5
    ## 40       3 2009  4074788.0
    ## 41       3 2010  3966559.9
    ## 42       3 2011  3955737.1
    ## 43       3 2012  3928680.0
    ## 44       3 2013  3923268.6
    ## 45       3 2014  3939502.8
    ## 46       4 2000 53873054.4
    ## 47       4 2001 54203057.8
    ## 48       4 2002 53955555.2
    ## 49       4 2003 53543051.0
    ## 50       4 2004 53048045.9
    ## 51       4 2005 54038056.1
    ## 52       4 2006 55440570.5
    ## 53       4 2007 56925585.8
    ## 54       4 2008 57833095.1
    ## 55       4 2009 57998096.8
    ## 56       4 2010 58823105.3
    ## 57       4 2011 59978117.2
    ## 58       4 2012 60225619.8
    ## 59       4 2013 60638124.0
    ## 60       4 2014 60885626.6
    ## 61       5 2000  6407099.7
    ## 62       5 2001  6704475.6
    ## 63       5 2002  6668430.1
    ## 64       5 2003  6632384.5
    ## 65       5 2004  6524247.8
    ## 66       5 2005  6533259.2
    ## 67       5 2006  6587327.6
    ## 68       5 2007  6686452.9
    ## 69       5 2008  6695464.3
    ## 70       5 2009  6506225.0
    ## 71       5 2010  6497213.6
    ## 72       5 2011  6632384.5
    ## 73       5 2012  6650407.3
    ## 74       5 2013  6704475.6
    ## 75       5 2014  6749532.6
    ## 76       6 2000  4134313.4
    ## 77       6 2001  4107256.4
    ## 78       6 2002  4134313.4
    ## 79       6 2003  4063965.2
    ## 80       6 2004  4112667.8
    ## 81       6 2005  4107256.4
    ## 82       6 2006  4188427.5
    ## 83       6 2007  4166781.9
    ## 84       6 2008  4215484.5
    ## 85       6 2009  4074788.0
    ## 86       6 2010  3966559.9
    ## 87       6 2011  3955737.1
    ## 88       6 2012  3928680.0
    ## 89       6 2013  3923268.6
    ## 90       6 2014  3939502.8
    ## 91       7 2000  4134313.4
    ## 92       7 2001  4107256.4
    ## 93       7 2002  4134313.4
    ## 94       7 2003  4063965.2
    ## 95       7 2004  4112667.8
    ## 96       7 2005  4107256.4
    ## 97       7 2006  4188427.5
    ## 98       7 2007  4166781.9
    ## 99       7 2008  4215484.5
    ## 100      7 2009  4074788.0
    ## 101      7 2010  3966559.9
    ## 102      7 2011  3955737.1
    ## 103      7 2012  3928680.0
    ## 104      7 2013  3923268.6
    ## 105      7 2014  3939502.8
    ## 106      8 2000 53873054.4
    ## 107      8 2001 54203057.8
    ## 108      8 2002 53955555.2
    ## 109      8 2003 53543051.0
    ## 110      8 2004 53048045.9
    ## 111      8 2005 54038056.1
    ## 112      8 2006 55440570.5
    ## 113      8 2007 56925585.8
    ## 114      8 2008 57833095.1
    ## 115      8 2009 57998096.8
    ## 116      8 2010 58823105.3
    ## 117      8 2011 59978117.2
    ## 118      8 2012 60225619.8
    ## 119      8 2013 60638124.0
    ## 120      8 2014 60885626.6
    ## 121      9 2000  4134313.4
    ## 122      9 2001  4107256.4
    ## 123      9 2002  4134313.4
    ## 124      9 2003  4063965.2
    ## 125      9 2004  4112667.8
    ## 126      9 2005  4107256.4
    ## 127      9 2006  4188427.5
    ## 128      9 2007  4166781.9
    ## 129      9 2008  4215484.5
    ## 130      9 2009  4074788.0
    ## 131      9 2010  3966559.9
    ## 132      9 2011  3955737.1
    ## 133      9 2012  3928680.0
    ## 134      9 2013  3923268.6
    ## 135      9 2014  3939502.8
    ## 136     10 2000 53873054.4
    ## 137     10 2001 54203057.8
    ## 138     10 2002 53955555.2
    ## 139     10 2003 53543051.0
    ## 140     10 2004 53048045.9
    ## 141     10 2005 54038056.1
    ## 142     10 2006 55440570.5
    ## 143     10 2007 56925585.8
    ## 144     10 2008 57833095.1
    ## 145     10 2009 57998096.8
    ## 146     10 2010 58823105.3
    ## 147     10 2011 59978117.2
    ## 148     10 2012 60225619.8
    ## 149     10 2013 60638124.0
    ## 150     10 2014 60885626.6
    ## 151     11 2000  6407099.7
    ## 152     11 2001  6704475.6
    ## 153     11 2002  6668430.1
    ## 154     11 2003  6632384.5
    ## 155     11 2004  6524247.8
    ## 156     11 2005  6533259.2
    ## 157     11 2006  6587327.6
    ## 158     11 2007  6686452.9
    ## 159     11 2008  6695464.3
    ## 160     11 2009  6506225.0
    ## 161     11 2010  6497213.6
    ## 162     11 2011  6632384.5
    ## 163     11 2012  6650407.3
    ## 164     11 2013  6704475.6
    ## 165     11 2014  6749532.6
    ## 166     12 2000  4134313.4
    ## 167     12 2001  4107256.4
    ## 168     12 2002  4134313.4
    ## 169     12 2003  4063965.2
    ## 170     12 2004  4112667.8
    ## 171     12 2005  4107256.4
    ## 172     12 2006  4188427.5
    ## 173     12 2007  4166781.9
    ## 174     12 2008  4215484.5
    ## 175     12 2009  4074788.0
    ## 176     12 2010  3966559.9
    ## 177     12 2011  3955737.1
    ## 178     12 2012  3928680.0
    ## 179     12 2013  3923268.6
    ## 180     12 2014  3939502.8
    ## 181     13 2000 53873054.4
    ## 182     13 2001 54203057.8
    ## 183     13 2002 53955555.2
    ## 184     13 2003 53543051.0
    ## 185     13 2004 53048045.9
    ## 186     13 2005 54038056.1
    ## 187     13 2006 55440570.5
    ## 188     13 2007 56925585.8
    ## 189     13 2008 57833095.1
    ## 190     13 2009 57998096.8
    ## 191     13 2010 58823105.3
    ## 192     13 2011 59978117.2
    ## 193     13 2012 60225619.8
    ## 194     13 2013 60638124.0
    ## 195     13 2014 60885626.6
    ## 196     14 2000  6407099.7
    ## 197     14 2001  6704475.6
    ## 198     14 2002  6668430.1
    ## 199     14 2003  6632384.5
    ## 200     14 2004  6524247.8
    ## 201     14 2005  6533259.2
    ## 202     14 2006  6587327.6
    ## 203     14 2007  6686452.9
    ## 204     14 2008  6695464.3
    ## 205     14 2009  6506225.0
    ## 206     14 2010  6497213.6
    ## 207     14 2011  6632384.5
    ## 208     14 2012  6650407.3
    ## 209     14 2013  6704475.6
    ## 210     14 2014  6749532.6
    ## 211     15 2000  4134313.4
    ## 212     15 2001  4107256.4
    ## 213     15 2002  4134313.4
    ## 214     15 2003  4063965.2
    ## 215     15 2004  4112667.8
    ## 216     15 2005  4107256.4
    ## 217     15 2006  4188427.5
    ## 218     15 2007  4166781.9
    ## 219     15 2008  4215484.5
    ## 220     15 2009  4074788.0
    ## 221     15 2010  3966559.9
    ## 222     15 2011  3955737.1
    ## 223     15 2012  3928680.0
    ## 224     15 2013  3923268.6
    ## 225     15 2014  3939502.8
    ## 226     16 2000 53873054.4
    ## 227     16 2001 54203057.8
    ## 228     16 2002 53955555.2
    ## 229     16 2003 53543051.0
    ## 230     16 2004 53048045.9
    ## 231     16 2005 54038056.1
    ## 232     16 2006 55440570.5
    ## 233     16 2007 56925585.8
    ## 234     16 2008 57833095.1
    ## 235     16 2009 57998096.8
    ## 236     16 2010 58823105.3
    ## 237     16 2011 59978117.2
    ## 238     16 2012 60225619.8
    ## 239     16 2013 60638124.0
    ## 240     16 2014 60885626.6
    ## 241     17 2000 21033783.1
    ## 242     17 2001 20499349.4
    ## 243     17 2002 19735872.7
    ## 244     17 2003 19621351.2
    ## 245     17 2004 19621351.2
    ## 246     17 2005 20155784.9
    ## 247     17 2006 20804740.1
    ## 248     17 2007 21759085.9
    ## 249     17 2008 22598910.3
    ## 250     17 2009 22637084.2
    ## 251     17 2010 22484388.8
    ## 252     17 2011 22637084.2
    ## 253     17 2012 22789779.5
    ## 254     17 2013 22904301.0
    ## 255     17 2014 23553256.2
    ## 256     18 2000 21033783.1
    ## 257     18 2001 20499349.4
    ## 258     18 2002 19735872.7
    ## 259     18 2003 19621351.2
    ## 260     18 2004 19621351.2
    ## 261     18 2005 20155784.9
    ## 262     18 2006 20804740.1
    ## 263     18 2007 21759085.9
    ## 264     18 2008 22598910.3
    ## 265     18 2009 22637084.2
    ## 266     18 2010 22484388.8
    ## 267     18 2011 22637084.2
    ## 268     18 2012 22789779.5
    ## 269     18 2013 22904301.0
    ## 270     18 2014 23553256.2
    ## 271     19 2000 65070000.0
    ## 272     19 2001 65122900.0
    ## 273     19 2002 66658900.0
    ## 274     19 2003 66432200.0
    ## 275     19 2004 67274700.0
    ## 276     19 2005 68168900.0
    ## 277     19 2006 68854900.0
    ## 278     19 2007 70570000.0
    ## 279     19 2008 70965000.0
    ## 280     19 2009 69285000.0
    ## 281     19 2010 69804000.0
    ## 282     19 2011 70732000.0
    ## 283     19 2012         NA
    ## 284     19 2013         NA
    ## 285     19 2014         NA
    ## 286     20 2000  6407099.7
    ## 287     20 2001  6704475.6
    ## 288     20 2002  6668430.1
    ## 289     20 2003  6632384.5
    ## 290     20 2004  6524247.8
    ## 291     20 2005  6533259.2
    ## 292     20 2006  6587327.6
    ## 293     20 2007  6686452.9
    ## 294     20 2008  6695464.3
    ## 295     20 2009  6506225.0
    ## 296     20 2010  6497213.6
    ## 297     20 2011  6632384.5
    ## 298     20 2012  6650407.3
    ## 299     20 2013  6704475.6
    ## 300     20 2014  6749532.6
    ## 301     21 2000 21033783.1
    ## 302     21 2001 20499349.4
    ## 303     21 2002 19735872.7
    ## 304     21 2003 19621351.2
    ## 305     21 2004 19621351.2
    ## 306     21 2005 20155784.9
    ## 307     21 2006 20804740.1
    ## 308     21 2007 21759085.9
    ## 309     21 2008 22598910.3
    ## 310     21 2009 22637084.2
    ## 311     21 2010 22484388.8
    ## 312     21 2011 22637084.2
    ## 313     21 2012 22789779.5
    ## 314     21 2013 22904301.0
    ## 315     21 2014 23553256.2
    ## 316     22 2000 65070000.0
    ## 317     22 2001 65122900.0
    ## 318     22 2002 66658900.0
    ## 319     22 2003 66432200.0
    ## 320     22 2004 67274700.0
    ## 321     22 2005 68168900.0
    ## 322     22 2006 68854900.0
    ## 323     22 2007 70570000.0
    ## 324     22 2008 70965000.0
    ## 325     22 2009 69285000.0
    ## 326     22 2010 69804000.0
    ## 327     22 2011 70732000.0
    ## 328     22 2012         NA
    ## 329     22 2013         NA
    ## 330     22 2014         NA
    ## 331     23 2000  1999711.1
    ## 332     23 2001  1949382.8
    ## 333     23 2002  2033263.3
    ## 334     23 2003  2107078.2
    ## 335     23 2004  2073526.0
    ## 336     23 2005  2110433.4
    ## 337     23 2006  2133919.9
    ## 338     23 2007  2180893.0
    ## 339     23 2008  2160761.7
    ## 340     23 2009  2009776.8
    ## 341     23 2010  1932606.7
    ## 342     23 2011  2019842.4
    ## 343     23 2012  2080236.4
    ## 344     23 2013  2137275.1
    ## 345     23 2014  2204379.5
    ## 346     24 2000  1291341.6
    ## 347     24 2001  1307089.6
    ## 348     24 2002  1340835.5
    ## 349     24 2003  1356583.6
    ## 350     24 2004  1361083.0
    ## 351     24 2005  1397078.6
    ## 352     24 2006  1482568.1
    ## 353     24 2007  1532062.0
    ## 354     24 2008  1534311.8
    ## 355     24 2009  1356583.6
    ## 356     24 2010  1316088.5
    ## 357     24 2011  1367832.2
    ## 358     24 2012  1417326.1
    ## 359     24 2013  1462320.6
    ## 360     24 2014  1491567.0
    ## 361     25 2000   827539.7
    ## 362     25 2001   823463.1
    ## 363     25 2002   834333.9
    ## 364     25 2003   847922.4
    ## 365     25 2004   858793.2
    ## 366     25 2005   880534.8
    ## 367     25 2006   929453.4
    ## 368     25 2007   948477.3
    ## 369     25 2008   952553.8
    ## 370     25 2009   866946.3
    ## 371     25 2010   831616.2
    ## 372     25 2011   887329.1
    ## 373     25 2012   911788.3
    ## 374     25 2013   930812.3
    ## 375     25 2014   945759.6
    ## 376     26 2000  6407099.7
    ## 377     26 2001  6704475.6
    ## 378     26 2002  6668430.1
    ## 379     26 2003  6632384.5
    ## 380     26 2004  6524247.8
    ## 381     26 2005  6533259.2
    ## 382     26 2006  6587327.6
    ## 383     26 2007  6686452.9
    ## 384     26 2008  6695464.3
    ## 385     26 2009  6506225.0
    ## 386     26 2010  6497213.6
    ## 387     26 2011  6632384.5
    ## 388     26 2012  6650407.3
    ## 389     26 2013  6704475.6
    ## 390     26 2014  6749532.6
    ## 391     27 2000  1291341.6
    ## 392     27 2001  1307089.6
    ## 393     27 2002  1340835.5
    ## 394     27 2003  1356583.6
    ## 395     27 2004  1361083.0
    ## 396     27 2005  1397078.6
    ## 397     27 2006  1482568.1
    ## 398     27 2007  1532062.0
    ## 399     27 2008  1534311.8
    ## 400     27 2009  1356583.6
    ## 401     27 2010  1316088.5
    ## 402     27 2011  1367832.2
    ## 403     27 2012  1417326.1
    ## 404     27 2013  1462320.6
    ## 405     27 2014  1491567.0
    ## 406     28 2000   827539.7
    ## 407     28 2001   823463.1
    ## 408     28 2002   834333.9
    ## 409     28 2003   847922.4
    ## 410     28 2004   858793.2
    ## 411     28 2005   880534.8
    ## 412     28 2006   929453.4
    ## 413     28 2007   948477.3
    ## 414     28 2008   952553.8
    ## 415     28 2009   866946.3
    ## 416     28 2010   831616.2
    ## 417     28 2011   887329.1
    ## 418     28 2012   911788.3
    ## 419     28 2013   930812.3
    ## 420     28 2014   945759.6
    ## 421     29 2000  6407099.7
    ## 422     29 2001  6704475.6
    ## 423     29 2002  6668430.1
    ## 424     29 2003  6632384.5
    ## 425     29 2004  6524247.8
    ## 426     29 2005  6533259.2
    ## 427     29 2006  6587327.6
    ## 428     29 2007  6686452.9
    ## 429     29 2008  6695464.3
    ## 430     29 2009  6506225.0
    ## 431     29 2010  6497213.6
    ## 432     29 2011  6632384.5
    ## 433     29 2012  6650407.3
    ## 434     29 2013  6704475.6
    ## 435     29 2014  6749532.6
    ## 436     30 2000  3566132.1
    ## 437     30 2001  3618498.2
    ## 438     30 2002  3618498.2
    ## 439     30 2003  3597551.8
    ## 440     30 2004  3576605.3
    ## 441     30 2005  3581841.9
    ## 442     30 2006  3628971.4
    ## 443     30 2007  3681337.5
    ## 444     30 2008  3723230.4
    ## 445     30 2009  3597551.8
    ## 446     30 2010  3566132.1
    ## 447     30 2011  3613261.6
    ## 448     30 2012  3634208.0
    ## 449     30 2013  3608025.0
    ## 450     30 2014  3597551.8
    ## 451     31 2000   827539.7
    ## 452     31 2001   823463.1
    ## 453     31 2002   834333.9
    ## 454     31 2003   847922.4
    ## 455     31 2004   858793.2
    ## 456     31 2005   880534.8
    ## 457     31 2006   929453.4
    ## 458     31 2007   948477.3
    ## 459     31 2008   952553.8
    ## 460     31 2009   866946.3
    ## 461     31 2010   831616.2
    ## 462     31 2011   887329.1
    ## 463     31 2012   911788.3
    ## 464     31 2013   930812.3
    ## 465     31 2014   945759.6
    ## 466     32 2000  3566132.1
    ## 467     32 2001  3618498.2
    ## 468     32 2002  3618498.2
    ## 469     32 2003  3597551.8
    ## 470     32 2004  3576605.3
    ## 471     32 2005  3581841.9
    ## 472     32 2006  3628971.4
    ## 473     32 2007  3681337.5
    ## 474     32 2008  3723230.4
    ## 475     32 2009  3597551.8
    ## 476     32 2010  3566132.1
    ## 477     32 2011  3613261.6
    ## 478     32 2012  3634208.0
    ## 479     32 2013  3608025.0
    ## 480     32 2014  3597551.8
    ## 481     33 2000 65070000.0
    ## 482     33 2001 65122900.0
    ## 483     33 2002 66658900.0
    ## 484     33 2003 66432200.0
    ## 485     33 2004 67274700.0
    ## 486     33 2005 68168900.0
    ## 487     33 2006 68854900.0
    ## 488     33 2007 70570000.0
    ## 489     33 2008 70965000.0
    ## 490     33 2009 69285000.0
    ## 491     33 2010 69804000.0
    ## 492     33 2011 70732000.0
    ## 493     33 2012         NA
    ## 494     33 2013         NA
    ## 495     33 2014         NA
    ## 496     34 2000   827539.7
    ## 497     34 2001   823463.1
    ## 498     34 2002   834333.9
    ## 499     34 2003   847922.4
    ## 500     34 2004   858793.2
    ## 501     34 2005   880534.8
    ## 502     34 2006   929453.4
    ## 503     34 2007   948477.3
    ## 504     34 2008   952553.8
    ## 505     34 2009   866946.3
    ## 506     34 2010   831616.2
    ## 507     34 2011   887329.1
    ## 508     34 2012   911788.3
    ## 509     34 2013   930812.3
    ## 510     34 2014   945759.6
    ## 511     35 2000  6407099.7
    ## 512     35 2001  6704475.6
    ## 513     35 2002  6668430.1
    ## 514     35 2003  6632384.5
    ## 515     35 2004  6524247.8
    ## 516     35 2005  6533259.2
    ## 517     35 2006  6587327.6
    ## 518     35 2007  6686452.9
    ## 519     35 2008  6695464.3
    ## 520     35 2009  6506225.0
    ## 521     35 2010  6497213.6
    ## 522     35 2011  6632384.5
    ## 523     35 2012  6650407.3
    ## 524     35 2013  6704475.6
    ## 525     35 2014  6749532.6
    ## 526     36 2000  3566132.1
    ## 527     36 2001  3618498.2
    ## 528     36 2002  3618498.2
    ## 529     36 2003  3597551.8
    ## 530     36 2004  3576605.3
    ## 531     36 2005  3581841.9
    ## 532     36 2006  3628971.4
    ## 533     36 2007  3681337.5
    ## 534     36 2008  3723230.4
    ## 535     36 2009  3597551.8
    ## 536     36 2010  3566132.1
    ## 537     36 2011  3613261.6
    ## 538     36 2012  3634208.0
    ## 539     36 2013  3608025.0
    ## 540     36 2014  3597551.8
    ## 541     37 2000  6407099.7
    ## 542     37 2001  6704475.6
    ## 543     37 2002  6668430.1
    ## 544     37 2003  6632384.5
    ## 545     37 2004  6524247.8
    ## 546     37 2005  6533259.2
    ## 547     37 2006  6587327.6
    ## 548     37 2007  6686452.9
    ## 549     37 2008  6695464.3
    ## 550     37 2009  6506225.0
    ## 551     37 2010  6497213.6
    ## 552     37 2011  6632384.5
    ## 553     37 2012  6650407.3
    ## 554     37 2013  6704475.6
    ## 555     37 2014  6749532.6
    ## 556     38 2000  3566132.1
    ## 557     38 2001  3618498.2
    ## 558     38 2002  3618498.2
    ## 559     38 2003  3597551.8
    ## 560     38 2004  3576605.3
    ## 561     38 2005  3581841.9
    ## 562     38 2006  3628971.4
    ## 563     38 2007  3681337.5
    ## 564     38 2008  3723230.4
    ## 565     38 2009  3597551.8
    ## 566     38 2010  3566132.1
    ## 567     38 2011  3613261.6
    ## 568     38 2012  3634208.0
    ## 569     38 2013  3608025.0
    ## 570     38 2014  3597551.8
    ## 571     39 2000  6407099.7
    ## 572     39 2001  6704475.6
    ## 573     39 2002  6668430.1
    ## 574     39 2003  6632384.5
    ## 575     39 2004  6524247.8
    ## 576     39 2005  6533259.2
    ## 577     39 2006  6587327.6
    ## 578     39 2007  6686452.9
    ## 579     39 2008  6695464.3
    ## 580     39 2009  6506225.0
    ## 581     39 2010  6497213.6
    ## 582     39 2011  6632384.5
    ## 583     39 2012  6650407.3
    ## 584     39 2013  6704475.6
    ## 585     39 2014  6749532.6
    ## 586     40 2000  3566132.1
    ## 587     40 2001  3618498.2
    ## 588     40 2002  3618498.2
    ## 589     40 2003  3597551.8
    ## 590     40 2004  3576605.3
    ## 591     40 2005  3581841.9
    ## 592     40 2006  3628971.4
    ## 593     40 2007  3681337.5
    ## 594     40 2008  3723230.4
    ## 595     40 2009  3597551.8
    ## 596     40 2010  3566132.1
    ## 597     40 2011  3613261.6
    ## 598     40 2012  3634208.0
    ## 599     40 2013  3608025.0
    ## 600     40 2014  3597551.8
    ## 601     41 2000  6407099.7
    ## 602     41 2001  6704475.6
    ## 603     41 2002  6668430.1
    ## 604     41 2003  6632384.5
    ## 605     41 2004  6524247.8
    ## 606     41 2005  6533259.2
    ## 607     41 2006  6587327.6
    ## 608     41 2007  6686452.9
    ## 609     41 2008  6695464.3
    ## 610     41 2009  6506225.0
    ## 611     41 2010  6497213.6
    ## 612     41 2011  6632384.5
    ## 613     41 2012  6650407.3
    ## 614     41 2013  6704475.6
    ## 615     41 2014  6749532.6
    ## 616     42 2000  3566132.1
    ## 617     42 2001  3618498.2
    ## 618     42 2002  3618498.2
    ## 619     42 2003  3597551.8
    ## 620     42 2004  3576605.3
    ## 621     42 2005  3581841.9
    ## 622     42 2006  3628971.4
    ## 623     42 2007  3681337.5
    ## 624     42 2008  3723230.4
    ## 625     42 2009  3597551.8
    ## 626     42 2010  3566132.1
    ## 627     42 2011  3613261.6
    ## 628     42 2012  3634208.0
    ## 629     42 2013  3608025.0
    ## 630     42 2014  3597551.8

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
## LIV region: prepare for calculations with a lag
  liv_region = liv_regional_employ %>%
    dplyr::rename(employ = employ_pop_bhi) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value) %>%
   arrange(rgn_id,year)

head( liv_region)
```

    ## # A tibble: 6 × 3
    ##   rgn_id  year rgn_value
    ##    <int> <int>     <dbl>
    ## 1      1  2009 0.9645933
    ## 2      1  2010 0.9923031
    ## 3      1  2011 1.0002685
    ## 4      1  2012 0.9976671
    ## 5      1  2013 1.0025463
    ## 6      1  2014 1.0546335

``` r
dim(liv_region) ##222 3
```

    ## [1] 306   3

``` r
## LIV country
  liv_country =   liv_national_employ %>%
    dplyr::rename(employ = employ_pop) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(cntry_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,cntry_value) %>%
    arrange(rgn_id,year)

  head(liv_country)
```

    ## # A tibble: 6 × 3
    ##   rgn_id  year cntry_value
    ##    <int> <int>       <dbl>
    ## 1      1  2009   0.9972376
    ## 2      1  2010   0.9944828
    ## 3      1  2011   1.0068399
    ## 4      1  2012   0.9946092
    ## 5      1  2013   1.0013459
    ## 6      1  2014   1.0373961

``` r
  dim(liv_country) ## 252  3
```

    ## [1] 252   3

#### 7.3.2 Calculate status time series

``` r
## calculate status
  liv_status_calc = inner_join(liv_region,liv_country, by=c("rgn_id","year"))%>% #join region and country current/ref ratios ## inner_join because need to have both region and country values to calculate
               mutate(Xliv = rgn_value/cntry_value)%>% #calculate status
               mutate(status = pmin(1, Xliv)) # status calculated cannot exceed 1

  head(liv_status_calc)
```

    ## # A tibble: 6 × 6
    ##   rgn_id  year rgn_value cntry_value      Xliv    status
    ##    <int> <int>     <dbl>       <dbl>     <dbl>     <dbl>
    ## 1      1  2009 0.9645933   0.9972376 0.9672653 0.9672653
    ## 2      1  2010 0.9923031   0.9944828 0.9978083 0.9978083
    ## 3      1  2011 1.0002685   1.0068399 0.9934732 0.9934732
    ## 4      1  2012 0.9976671   0.9946092 1.0030745 1.0000000
    ## 5      1  2013 1.0025463   1.0013459 1.0011988 1.0000000
    ## 6      1  2014 1.0546335   1.0373961 1.0166160 1.0000000

``` r
  dim(liv_status_calc) ## 222 6
```

    ## [1] 306   6

#### 7.3.3 Extract most recent year status

``` r
liv_status = liv_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data
              mutate(score=round(status*100),   #scale to 0 to 100
                     dimension = 'status')%>%
              select(region_id = rgn_id,score, dimension) #%>%
              ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
                                    ##will this cause problems if there are regions that should be NA (because indicator is not applicable?)

head(liv_status)
```

    ##   region_id score dimension
    ## 1         1   100    status
    ## 2         2   100    status
    ## 3         3     0    status
    ## 4         3   100    status
    ## 5         4   100    status
    ## 6         5    98    status

``` r
## what is max year
max_year_status= liv_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              select(rgn_id,year)
max_year_status %>% select(year)%>% distinct() ## all final years are 2014
```

    ## # A tibble: 1 × 1
    ##    year
    ##   <int>
    ## 1  2014

### 7.3.4 Which BHI regions have no status

Regions 19,21,22,30,33 have NA status.

Russian regions have NA status because no regional data (19,22,33)

Regions with no coast line have no status because not joined to a NUTS reion (30)

Region with mis-assigned NUTS3 to BHI regions: 21 - See 4.2.2 about Polish NUTS3 regions

``` r
liv_status %>% filter(is.na(score)) #19,21,22,30,33
```

    ##   region_id score dimension
    ## 1        19    NA    status
    ## 2        22    NA    status
    ## 3        30    NA    status
    ## 4        33    NA    status

### 7.3.1 Plot status

Status values in the time series are between 0 and 1.
There are no values for Russia because we do not have regional GDP data.
Status values for the most recent year (2014 for all regions) are transformed to value between 0 and 100

``` r
## plot liv status time series
ggplot(liv_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(0,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("LIV status time series")
```

    ## Warning: Removed 21 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-1.png)

``` r
## plot liv status time series, less range on y-axis
ggplot(liv_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(.8,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("LIV status time series - different y-axis range")
```

    ## Warning: Removed 92 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-2.png)

``` r
## plot final year (2014) status

ggplot(liv_status)+
  geom_point(aes(region_id,score), size=2)+
  ylim(0,100)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("LIV status score in 2014")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-3.png)

### 7.4 Trend calculation

#### 7.4.1 Calculate Trend

``` r
  ## calculate trend for 5 years (5 data points)
  ## years are filtered in liv_region and liv_country, so not filtered for here
      liv_trend = liv_status_calc %>%
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

Same regions as NA status and also Danish regions because have a short time series.

Should the calculation be modifed so only 3 out of the last five years need for a trend?

``` r
liv_trend %>% filter(is.na(score)) ## 2,3,6,7,9,12,15,19,21,22,30,33
```

    ##    region_id dimension score
    ## 1          2     trend    NA
    ## 2          3     trend    NA
    ## 3          6     trend    NA
    ## 4          7     trend    NA
    ## 5          9     trend    NA
    ## 6         12     trend    NA
    ## 7         15     trend    NA
    ## 8         16     trend    NA
    ## 9         17     trend    NA
    ## 10        18     trend    NA
    ## 11        19     trend    NA
    ## 12        22     trend    NA
    ## 13        23     trend    NA
    ## 14        24     trend    NA
    ## 15        27     trend    NA
    ## 16        28     trend    NA
    ## 17        30     trend    NA
    ## 18        32     trend    NA
    ## 19        33     trend    NA
    ## 20        34     trend    NA
    ## 21        41     trend    NA
    ## 22        42     trend    NA

#### 7.4.3 Plot trend

``` r
ggplot(liv_trend)+
  geom_point(aes(region_id,score), size=2)+
  geom_hline(yintercept = 0)+
  ylim(-1,1)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("LIV 5 yr trend score")
```

    ## Warning: Removed 22 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20trend-1.png)

#### 7.5 Plot trend and status together

``` r
plot_liv = bind_rows(liv_status,liv_trend)

ggplot(plot_liv)+
  geom_point(aes(region_id,score),size=2.5)+
  facet_wrap(~dimension, scales = "free_y")+
  ylab("Score")+
  ggtitle("LIV Status and Trend")
```

    ## Warning: Removed 26 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20trend%20and%20status%20together-1.png)

8. Data issues and concerns
---------------------------

### 8.1 Shapefile incorrect assignments

Some corrected in 4.1.4.

But, Note - (as in NUTS3 assignment issues see ECO), BHI region 21 not assigned to any NUTS2 regions - despite clear association with PL63. PL63 split only between BHI 17 and BHI 18. This could not be fixed manually

### 8.2 Finnish NUTS2 name discrepancies

See 5.2.2

One challenge is that the new regions are two regions (FI1B,FI1C) where the old region was one (FI18). FI1B includes Helsinki and plot below shows similar pattern but that FI1B is between 5.8 to 6.8 higher than FI1C.

Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate.

FI1D (new name) areas match old FIA1 areas - so this is a straight-forward fix.

![See Population density from Eurostat](pop_density_nuts2_FI.png?raw=TRUE) [Eurostat Population density image source](http://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/#). Layer is under 'Background Maps'

### 8.3 No Russian regional data

No regional employment data for Russia (St. Petersburg and Kalingrad) so status cannot be calculated.

### 8.4 Employment data for EU transformed from percent to number of people using 2005 population data for all years

This is done for both the regional and the national datasets.

### 8.5 Short Danish timeseries

Danish regional time series are shorter. Data begin in 2007. Because data from 5 years prevous are need to calculated the regional/ref value, only three status years can be calculated. This also means that no trend is calculated because 5 years is required.

### 9. Update region assignment

Marc sent the updated NUTS regions shape files for 2006 (9/2016).

``` r
nuts3 = readOGR(dsn = path.expand(file.path(dir_liv, 'liv_data_database/NUTS_2006_shp_file_updated_9.2016')),
                layer = 'NUTS_2006_Level_3_reprojected_BHI_shapefile_25km_intersect')

data_nuts3 = nuts3@data %>% 
  dplyr::select(country = Country, 
                BHI_ID,
                nuts3 = NUTS_ID, 
                country_abb = CNTR_CODE)

write_csv(data_nuts3, file.path(dir_liv, 'liv_data_database/nuts_3_rgn_id_match_udpated_9.16.csv'))


nuts2 = readOGR(dsn = path.expand(file.path(dir_liv, 'liv_data_database/NUTS_2006_shp_file_updated_9.2016')),
                layer = 'NUTS_2006_Level_2_reprojected_BHI_shapefile_25km_intersect')

data_nuts2 = nuts2@data %>% 
  dplyr::select(country = Country, 
                country_abb = CNTR_CODE,
                BHI_ID, 
                nuts2 = NUTS_ID)

write_csv(data_nuts2, file.path(dir_liv, 'liv_data_database/nuts_2_rgn_id_match_udpated_9.16.csv'))
```
