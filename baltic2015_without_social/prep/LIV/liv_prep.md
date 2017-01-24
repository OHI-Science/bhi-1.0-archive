Livelihoods (LIV) Subgoal Data Preparation
================

-   [1. Background](#background)
    -   [Goal Description](#goal-description)
    -   [Model & Data](#model-data)
    -   [Reference points](#reference-points)
    -   [Considerations for *BHI 2.0*](#considerations-for-bhi-2.0)
    -   [Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 NUTS0 (country) and NUTS2 region Employment rate](#nuts0-country-and-nuts2-region-employment-rate)
    -   [2.2 Russian data](#russian-data)
    -   [2.3 Population density data](#population-density-data)
    -   [2.4 Aligning BHI regions with NUTS2 regions and population density](#aligning-bhi-regions-with-nuts2-regions-and-population-density)
    -   [2.5 Alternative employment data - explored but excluded](#alternative-employment-data---explored-but-excluded)
-   [3. Goal model](#goal-model)
-   [4. Data issues: Mis-assignments](#data-issues-mis-assignments)
-   [5. Regional data prep](#regional-data-prep)
    -   [5.1 Data organization](#data-organization)
    -   [5.2 Join datasets](#join-datasets)
    -   [5.3 Are BHI regions missing?](#are-bhi-regions-missing)
    -   [5.4 Calculate number of employed people and allocation to BHI regions](#calculate-number-of-employed-people-and-allocation-to-bhi-regions)
    -   [5.5 Data layer for layers](#data-layer-for-layers)
    -   [6. Country data prep](#country-data-prep)
    -   [6.1 Organize data](#organize-data)
-   [7. Status and Trend calculation exploration](#status-and-trend-calculation-exploration)
    -   [7.1 Status calculation](#status-calculation)
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
-   [10. Alternative data and Status calculation - Used for Status for now](#alternative-data-and-status-calculation---used-for-status-for-now)
    -   [10.1 Alternative 1 - not incorporated](#alternative-1---not-incorporated)
    -   [10.2 Alternative 2 - not incorporated](#alternative-2---not-incorporated)
    -   [10.3 Alternative 3 - Used for now](#alternative-3---used-for-now)

1. Background
-------------

### Goal Description

The Livelihoods sub-goal describes livelihood quantity and quality for people living on the coast. Livelihoods includes the number of jobs in different marine related sectors. Ideally, this sub-goal would speak to the quality and quantity of marine jobs in an area. It would encompass all the marine sectors that supply jobs and wages to coastal communities, incorporating information on the sustainability of different sectors while also telling about the working conditions and job satisfaction.

<!---
Due to a lack of sector-specific employment information, **for the BHI we used overall employment rate in the Baltic coastal regions to represent ocean-dependent livelihood.**  
--->
### Model & Data

Data for each country were downloaded from the [EU-Study on Blue Growth](https://webgate.ec.europa.eu/maritimeforum/node/3550), Maritime Policy and the EU Strategy for the Baltic Sea Region” identified the potential for Blue Growth in each of the EU Member States (MS) of the Baltic Sea Region (BSR) and at sea basin level.

<!---Employment rate data was extracted from NUTS2 employment to substitute Baltic regional employment data, and compare that with the country-level employment rate. 
--->
### Reference points

*to be determined*

<!---
110% of the highest coastal/national employment rate ratio in the most recent five years. 
--->
### Considerations for *BHI 2.0*

<!---
Regions 19, 22 , 30, and 33 have NA status and trend. 

Russian regions have NA status because no regional data (19,22,33)

Regions with no coast line have no status because not joined to a NUTS region (30)
--->
### Other information

*external advisors/goalkeepers: Martin Quaas and Wilfried Rickels.*

2. Data
-------

#### 2.1 NUTS0 (country) and NUTS2 region Employment rate

Data downloaded on 31 March 2016 from Eurostat database [lfst\_r\_lfe2emprt](http://ec.europa.eu/eurostat/data/database?p_auth=BgwyNWIM&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=lfst_r_lfe2emprt)

*Data information*: Available for Country Level (NUTS0), NUTS1, and NUTS2; ages 15-64; All sexes; years 1999-2014

[Metadata link](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm)

**Metadata overview**

The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonization, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi\_esms, see paragraph 21.1.).

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

### 2.5 Alternative employment data - explored but excluded

The [“Study on Blue Growth, Maritime Policy and the EU Strategy for the Baltic Sea Region”](https://webgate.ec.europa.eu/maritimeforum/node/3550) identified the potential for Blue Growth in each of the EU Member States of the Baltic Sea Region, and also provided detailed marine revenue and employment by sector and in each BHI country. This data was explored but excluded from this assessment. See data exploration in section 10.

3. Goal model
-------------

Xliv = (Employment\_Rate\_Region / Employment\_Rate\_Country)\_c / (Employment\_Rate\_Region / Employment\_Rate\_Country)\_r

-   c = current year, r=reference year
-   reference point is the max Region:Country employment ratio of the past five years
-   Region is the BHI region:
-   Each BHI region is composed by one or more NUTS2 regions.
-   NUTS2 employment percentage multiplied by the by population in the 25km inland buffer associated with a BHI region. Sum across all associated with a BHI region to get the total employed people in the BHI region.
-   Regional Employment rate = \# of employment/regional population
-   For country data, we have employment rate data directly

4. Data issues: Mis-assignments
-------------------------------

1.  NUTS3 regions are assigned to a BHI region due to minor differences in borders. These are fixed manually in the data preparation in section 5.1.4

2.  Finnish NUTS3 names have changed for the NUTS3 regions associated with BHI 32. These NUTS3 population data must be manually linked to BHI region 32. Fixed manually in section 5.1.5.

3.  Finnish NUTS3 regions also changed for those associated with BHI region 32:old names FI1A3, FI1A2, FI1A1 but new names appear to be in the same locations (new names FI1D7, FI1D6, FI1D5). These are also fixed in 5.1.5

These issues were manually fixed below.

5. Regional data prep
---------------------

### 5.1 Data organization

``` r
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

source('~/github/bhi/baltic2015/prep/common.r')
dir_liv    = file.path(dir_prep, 'LIV')

## add a README.md to the prep directory 
create_readme(dir_liv, 'liv_prep.rmd')
```

#### Read in employment and population data

``` r
## read in
regional_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts2_employ.csv'), stringsAsFactors = FALSE)

dim(regional_employ) #[1] 5344    9
str(regional_employ)

## PopDensity (updated - 9.27.2016)
nuts2_pop_density = read_csv(file.path(dir_liv, 'liv_data_database/NUTS2_BHI_ID_Pop_density_in_buffer.csv'))
```

#### Clean Regional employment data object

``` r
regional_employ1 = regional_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, nuts2 = GEO, nuts2_name = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes) %>%
                  mutate(nuts2 = as.character(nuts2),
                         nuts2_name = as.character(nuts2_name),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes == "b", "break in timeseries",
                                      ifelse(flag_notes == "u", "low reliability",
                                      ifelse(flag_notes == "bu", "break in timeseries and low reliability",""))))
                  
str(regional_employ1)

## check dataflags
regional_employ1 %>% select(flag_notes) %>% distinct()
regional_employ1 %>% filter(flag_notes =="low reliability" ) #not Baltic country
regional_employ1 %>% filter(flag_notes =="break in timeseries and low reliability" ) #not Baltic country
regional_employ1 %>% filter(flag_notes =="break in timeseries") ## this is not such a concern

## remove flags_notes
regional_employ1 = regional_employ1 %>%
                   select(-flag_notes)
```

#### Clean population data

``` r
## nuts2 population data

nuts2_pop_area1 = nuts2_pop_density %>%
                  select(-PopUrb,-PopRur,-PopUrb_density_in_NUTS2_buffer_per_km2,-PopRur_density_in_NUTS2_buffer_per_km2, -HELCOM_ID, - CNTR_CODE) %>%
                  dplyr::rename(rgn_id = BHI_ID,
                                nuts2 = NUTS_ID,
                                pop = PopTot,
                                pop_km2 = PopTot_density_in_NUTS2_buffer_per_km2,
                                country = rgn_nam,
                                basin = Subbasin,
                                area = NUTS2_area_in_BHI_buffer_km2) %>% 
                  mutate(country_abb = substr(nuts2, 1, 2))
```

#### Check NUTS2 names from Finland

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

#### Check for incorrectly assigned NUTS2 regions to BHI regions and fix

As mentioned in Section 4.

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

### 5.2 Join datasets

#### Join accom times series with nuts pop and area

Join data with inner join, this will exclude Finland areas with name mismatches. Fix Finnish data and add back into the dataset

``` r
employ_nuts1 = inner_join(regional_employ1, nuts2_pop_area2,
                         by=c("nuts2"))

 dim(regional_employ1) ## 5344    5
 dim(nuts2_pop_area2) ## 60 8
 dim(employ_nuts1) ## 896  12

 str(employ_nuts1) ## this is now missing the Finnish data where there are name discrepancies
```

#### Get Finnish data that was excluded

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
ggplot(fi_employ_newnuts) +
  geom_point(aes(year,value, colour=nuts2, shape=nuts2)) +
  ggtitle("Comparison of Finnish Region NUTS2 Employment percentage")
```

![](liv_prep_files/figure-markdown_github/Get%20Finnish%20data%20that%20was%20excluded-1.png)

``` r
## difference between FI1B and FI1C
fi_employ_newnuts %>% 
  select(-nuts2_name) %>%
  spread(nuts2,value) %>%
  mutate(diff_1b_1c = FI1B - FI1C) %>%
  filter(!is.na(diff_1b_1c))
            
##Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate. 
    ## Therefore, only retain data for FI1B (exclude FI1C)

fi_employ_newnuts1 = fi_employ_newnuts %>% 
                     filter(nuts2 != "FI1C")




## assign old nuts names to employ data
fi_employ_newnuts1 = fi_employ_newnuts1 %>%
                    mutate(nuts_old = ifelse(nuts2 == "FI1B", "FI18",
                                      ifelse(nuts2 == "FI1D", "FI1A","")),
                           nuts2_name_old= ifelse(nuts2 == "FI1B","old region",nuts2_name )) %>%
                    select(-nuts2, -nuts2_name) %>%
                    dplyr::rename(nuts2=nuts_old,
                                  nuts2_name = nuts2_name_old)
                        
# head(fi_employ_newnuts1) ## there are NA but were NA for all regions in those years

## Get population data associated with old nuts names
fi_nuts_oldnuts = nuts2_pop_area2 %>%
                  filter(nuts2 %in% c("FI18","FI1A"))

# fi_nuts_oldnuts


## join fi employ to fi pop and area

fi_employ_correct_nuts = full_join(fi_employ_newnuts1, fi_nuts_oldnuts,
                          by=c("nuts2")) %>%
                          select(year,nuts2,nuts2_name,unit,
                                 value,rgn_id,country,country_abb,basin, pop,
                                 pop_km2,area)


# str(fi_employ_correct_nuts)
```

#### Join Finnish data to other regional data

``` r
### bind to rest of data
colnames(fi_employ_correct_nuts)
colnames(employ_nuts1)

employ_nuts2 = bind_rows(employ_nuts1, fi_employ_correct_nuts) %>%
              dplyr::rename(employ_rate = value)
```

#### Plot and check regional employment time series

``` r
ggplot(employ_nuts2) +
  geom_point(aes(year,employ_rate, colour=nuts2)) +
  geom_line(aes(year,employ_rate, colour=nuts2)) +
  facet_wrap(~country, scale="free_y") +
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain")) +
  ggtitle("Time series Percent Employed NUTS2")
```

![](liv_prep_files/figure-markdown_github/Plot%20and%20check%20regional%20employment%20time%20series-1.png)

#### Restrict dataset to year 2000 to 2014

``` r
employ_nuts3 = employ_nuts2 %>% 
              filter(year >=2000)
```

### 5.3 Are BHI regions missing?

Expected missing:

-   19,22, and 33 from Russia
-   30 has no coastline

``` r
employ_nuts3 %>% select(rgn_id) %>% distinct() %>% arrange(rgn_id)

## there are 38 regions

## missing: 19, 22, 30, 33
```

### 5.4 Calculate number of employed people and allocation to BHI regions

#### Calculate the number of employed in BHI region with NUTS2 percentage, and total population per BHi region

Use population within the 25km buffer and employment percentage to get the number of employed people. Population is constant at 2005 population size.

``` r
employ_nuts4 = employ_nuts3 %>%
               mutate(employ_pop = (employ_rate/100) * pop) 
```

#### Plot the number of people employed in each BHI region by NUTS2 region

``` r
ggplot(employ_nuts4) +
  geom_point(aes(year,employ_pop, colour=nuts2),size=.6) +
  facet_wrap(~rgn_id, scale="free_y") +
  guides(colour="none") +
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain")) +
  ggtitle("Time series Number of People Employed in NUTS2 (25km buffer) by BHI region")
```

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20nuts3%20employed%20by%20bhi%20region-1.png)

#### Calculate total employed by BHI region

``` r
employ_nuts5 = employ_nuts4 %>%
  select(country,country_abb,rgn_id,year,employ_pop, pop) %>%
  group_by(country,country_abb,rgn_id,year) %>%
  summarise(employ_pop_bhi = sum(employ_pop),
            pop_bhi = sum(pop)) %>%
  mutate(bhi_employ_rate = employ_pop_bhi/pop_bhi *100) %>% 
  ungroup() %>% 
  select(rgn_id, country, year, bhi_employ_rate)
```

#### Plot Number of BHI employed

``` r
ggplot(employ_nuts5) +
  geom_point(aes(year,bhi_employ_rate, colour=country),size=.6) +
  facet_wrap(~rgn_id, scale="free_y") +
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain")) +
  ggtitle("Time series Number of Employment rate per BHI region (25km buffer)")
```

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20BHI%20employed-1.png)

### 5.5 Data layer for layers

#### 5.5.1 Prepare object for csv

``` r
liv_regional_employ = employ_nuts5 %>%
                     select(rgn_id, year, bhi_employ_rate) %>%
                     arrange(rgn_id, year)


## save also for visualize
### SAVE also for VISUALIZE
liv_rgn_time_data = employ_nuts5 %>%
                    dplyr::rename(value = bhi_employ_rate) %>%
                    mutate(unit= "employed people",
                           bhi_goal="LIV",
                           data_descrip = "NUTS2 Employment rate allocated to BHI region")

write.csv(liv_rgn_time_data, file.path(dir_baltic,'visualize/liv_rgn_time_data.csv'),row.names=FALSE)
```

#### 5.5.2 Write object to csv

``` r
write.csv(liv_regional_employ, file.path(dir_layers, 'liv_regional_employ_bhi2015.csv'),row.names =FALSE)
```

### 6. Country data prep

We took EU nuts0 level employment data and extracted employment rates on the national level.

### 6.1 Organize data

``` r
## read in NUTS0 (national) employement from EU
nat_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts0_employ.csv'), stringsAsFactors = FALSE)

## read in BHI look up table
bhi_lookup = read.csv(file.path(dir_liv, "bhi_basin_country_lookup.csv"), sep=";",stringsAsFactors = FALSE) %>%
            select(rgn_nam, BHI_ID) %>%
            dplyr::rename(country= rgn_nam,
                          rgn_id = BHI_ID)
```

<!-- #### 6.1.1 Read in data -->
<!-- ```{r read in national data, message = FALSE} -->
<!-- ## read in NUTS0 (national) employement from EU -->
<!-- nat_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts0_employ.csv'), stringsAsFactors = FALSE) -->
<!-- # dim(nat_employ) #[1] 528    9 -->
<!-- # str(nat_employ) -->
<!-- ## read in Russian national  pouplation and employment -->
<!-- ru_data = read.csv(file.path(dir_liv, 'liv_data_database/naida_10_pe_1_Data_cleaned.csv'), sep=";",stringsAsFactors = FALSE) -->
<!-- # dim(ru_data) -->
<!-- # str(ru_data) -->
<!-- ## Read in EU population size -->
<!-- eu_pop = read.csv(file.path(dir_liv, 'liv_data_database/demo_gind_1_Data_cleaned.csv'), sep=";", stringsAsFactors = FALSE) -->
<!-- # str(eu_pop) -->
<!-- # dim(eu_pop) -->
<!-- # read in EU country abbreviations and names -->
<!-- eu_lookup = read.csv(file.path(dir_liv, 'EUcountrynames.csv'), sep=";")   -->
<!-- # dim(eu_lookup) -->
<!-- # str(eu_lookup) -->
<!-- ## read in BHI look up table -->
<!-- bhi_lookup = read.csv(file.path(dir_liv, "bhi_basin_country_lookup.csv"), sep=";",stringsAsFactors = FALSE) %>% -->
<!--             select(rgn_nam, BHI_ID) %>% -->
<!--             dplyr::rename(country= rgn_nam, -->
<!--                           rgn_id = BHI_ID) -->
<!-- ``` -->
#### Clean National EU employment data object

``` r
nat_employ1 = nat_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, country_abb = GEO, country = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes) %>%
                  mutate(country_abb = as.character(country_abb),
                         country = as.character(country),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries", ""))
                  
head(nat_employ1)


### check data flags
nat_employ1 %>% select(flag_notes) %>% distinct()
nat_employ1 %>% filter(flag_notes == "break in timeseries") # not a major concern

### remove flag_notes

nat_employ1 = nat_employ1 %>%
              select(-flag_notes)

## Select only Baltic countries and data 2000 to end
nat_employ2 = nat_employ1 %>%
              filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>%
          filter(year >=2000)

# dim(nat_employ2)  

nat_employ2 %>% select(country) %>% distinct()

### plot employment by country
ggplot(nat_employ2) +
  geom_point(aes(year, value)) +
  facet_wrap(~country) +
  ggtitle("Percent employed ")
```

![](liv_prep_files/figure-markdown_github/clean%20country%20data%20object-1.png)

``` r
## join with BHI ID

nat_employ3 = full_join(nat_employ2, bhi_lookup, by = 'country')
```

<!-- #### 6.1.3 Clean Russian data object -->
<!-- Russian employment and population is in "thousand persons", transform into total number of people -->
<!-- ```{r clean russian nat data object, message = FALSE} -->
<!-- ## divide population and employment into separate objects -->
<!-- ru_data = ru_data %>% -->
<!--           select(-UNIT) %>% -->
<!--           dplyr::rename(year = TIME,  -->
<!--                         country_abb = GEO, -->
<!--                         country = GEO_LABEL, -->
<!--                         unit = UNIT_LABEL, -->
<!--                         dat_descrip = NA_ITEM, -->
<!--                         value = Value, -->
<!--                          flag_notes = Flag.and.Footnotes) -->
<!-- ru_data %>% select(unit, dat_descrip) %>% distinct() -->
<!-- ru_pop = ru_data %>% -->
<!--          filter(dat_descrip == "Total population national concept") %>% -->
<!--          mutate(ru_pop = value *1000) %>% ##transform into total number of people from thousands of people -->
<!--          select(-value) -->
<!-- ru_employ = ru_data %>% -->
<!--          filter(dat_descrip == "Total employment domestic concept") %>% -->
<!--           mutate(ru_employ = value *1000) %>% ##transform into total number of people from thousands of people -->
<!--          select(-value) -->
<!-- ## check flags -->
<!-- ru_pop %>% select(flag_notes) %>% distinct() -->
<!-- ru_pop %>% filter(flag_notes == 'b' | flag_notes == 'e') ## estimated in 2012, 2013, 1989 break in time seires -->
<!-- ru_pop = ru_pop %>% -->
<!--          select(-flag_notes) -->
<!-- ru_employ %>% select(flag_notes) %>% distinct() ## none flagged -->
<!-- ru_employ = ru_employ %>% -->
<!--             select(-flag_notes) -->
<!-- ## Select only data from 2000 to end -->
<!-- ru_pop = ru_pop %>% -->
<!--          filter(year >=2000) -->
<!-- ru_employ= ru_employ %>% -->
<!--          filter(year >=2000) -->
<!-- ## Plot data -->
<!-- ## plop Russia employment -->
<!-- ggplot(ru_employ) + -->
<!--   geom_point(aes(year, ru_employ)) + -->
<!--   ylab("Number of people") + -->
<!--   ggtitle("Number of People Employed - Russia") -->
<!-- ``` -->
<!-- #### 6.1.4 Clean EU nat population data object -->
<!-- EU population size information:   -->
<!-- Population on 1 January: Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December . However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.   -->
<!-- [Source](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)   -->
<!-- ```{r clean national population data, message = FALSE} -->
<!-- ## EU countries -->
<!-- eu_pop2 = eu_pop %>% -->
<!--           select(-TIME_LABEL) %>% -->
<!--           dplyr::rename(year = TIME, -->
<!--                         country_abb = GEO, -->
<!--                         country= GEO_LABEL, -->
<!--                         unit = INDIC_DE, -->
<!--                         value = Value, -->
<!--                         flag_notes = Flag.and.Footnotes) %>% -->
<!--           filter(unit == "Population on 1 January - total " ) %>% # select this meauresure of population size -->
<!--           mutate(value = ifelse(value== ":", NA, value), -->
<!--                 value= as.numeric(value)) -->
<!-- ## select only Baltic countries and data since 2000 -->
<!-- eu_pop3 = eu_pop2 %>% -->
<!--           mutate(country = ifelse(country =="Germany (until 1990 former territory of the FRG)","Germany",country), -->
<!--                  country = ifelse(country =="Germany (including former GDR)","Germany",country), -->
<!--                  country_abb = ifelse(country_abb == "DE_TOT","DE",country_abb)) %>% -->
<!--           filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>% -->
<!--           filter(year >=2000) -->
<!--   dim(eu_pop3) ## Germany is duplicated because of GDR and FRG but in more recent years, value occurs twice ##144 6 -->
<!-- eu_pop3 = eu_pop3 %>% -->
<!--           distinct() -->
<!-- dim(eu_pop3) ##129 6 -->
<!-- str(eu_pop3)            -->
<!-- ## check data flags -->
<!-- # eu_pop3 %>% select(flag_notes) %>%distinct() -->
<!-- # eu_pop3 %>% filter(flag_notes == "b")  ## b = break in time series -- this should be fine -->
<!-- eu_pop3 = eu_pop3 %>% -->
<!--           select(-flag_notes) -->
<!-- ``` -->
<!-- ### 6.2 Transform EU data in number of people employed -->
<!-- Use 2005 population size. This is to be consistent with only have 2005 population size for the regional data. The same approach is used for ECO national data layer preparation.   -->
<!-- This will mean that the data differ slightly from the Russian employment which are provided as number of people and probably then reflect population size changes as well.   -->
<!-- However, because there is no regional Russian data, there is no Russian status calculation. -->
<!-- #### 6.2.1 Join EU national employment percent to population size from 2005 -->
<!-- ```{r join eu nat employ percent eu_pop3, message = FALSE} -->
<!-- nat_pop_2005 = eu_pop3 %>% -->
<!--                filter(year==2005) %>% -->
<!--                dplyr::rename(pop_2005 = value) %>% -->
<!--                select(country, pop_2005) -->
<!-- nat_employ3 = full_join(nat_employ2,nat_pop_2005, -->
<!--                         by="country") -->
<!-- ## number employed -->
<!-- nat_employ3 = nat_employ3 %>% -->
<!--               dplyr::rename(employ_rate = value) %>% -->
<!--               mutate(employ_pop = (employ_rate/100) * pop_2005) %>%  ## make sure to convert percentage to proportion -->
<!--               select(-employ_rate, -pop_2005,-unit) -->
<!-- ``` -->
<!-- ### 6.3 Join EU and Russian data -->
<!-- ### 6.3.1  Join EU and Russian data -->
<!-- ```{r join eu and russian nat employ data, message = FALSE} -->
<!-- colnames(ru_employ) -->
<!-- colnames(nat_employ3) -->
<!-- ## modify ru object -->
<!-- ru_employ = ru_employ %>% -->
<!--             select(-dat_descrip) %>% -->
<!--             dplyr::rename(employ_pop = ru_employ) -->
<!-- ## bind rows -->
<!-- nat_employ4 = bind_rows(nat_employ3, ru_employ) -->
<!-- ``` -->
<!-- #### 6.3.2 Plot joined EU and Russian employment data -->
<!-- ```{r plot joined EU and russian employment data, message = FALSE} -->
<!-- ggplot(nat_employ4) + -->
<!--   geom_point(aes(year, employ_pop, colour = country)) + -->
<!--   geom_line(aes(year, employ_pop, colour = country)) + -->
<!--   ylab("Number of people") + -->
<!--   ggtitle("Number of People Employed") -->
<!-- ``` -->
<!-- ### 6.3.3. Restrict to Final year 2014  -->
<!-- Same as the regional data -->
<!-- ```{r restrict national data last year, message = FALSE} -->
<!-- nat_employ4 = nat_employ4 %>% -->
<!--               filter( year < 2015) -->
<!-- ``` -->
<!-- ### 6.4 National data by BHI regions -->
<!-- #### 6.4.1 Join national data to BHI regions -->
<!-- ```{r join national data to BHI regions, message = FALSE} -->
<!-- rgn_nat_employ =  full_join(bhi_lookup,nat_employ4, -->
<!--                         by="country") -->
<!-- ``` -->
<!-- #### 6.4.2 Plot national data by BHI region -->
<!-- ```{r plot national data by BHI region, message = FALSE} -->
<!-- ggplot(rgn_nat_employ) + -->
<!--   geom_point(aes(year,employ_pop,colour=country),size=.7) + -->
<!--   facet_wrap(~rgn_id, scales="free_y") + -->
<!--   ggtitle("Number People Employed Nationally for each BHI region") -->
<!-- ``` -->
<!-- ### 6.5 Prepare national data layer for layer -->
<!-- #### 6.5.1 Prepare Object -->
<!-- ```{r prepare national object for layers, message = FALSE} -->
<!-- liv_national_employ = rgn_nat_employ %>% -->
<!--                      select(rgn_id, year, employ_pop) %>% -->
<!--                      arrange(rgn_id, year) -->
<!-- ### SAVE also for VISUALIZE -->
<!-- liv_nat_time_data = rgn_nat_employ %>% -->
<!--                     select(rgn_id,year,value = employ_pop) %>% -->
<!--                     mutate(unit= "employed people", -->
<!--                            bhi_goal="ECO", -->
<!--                            data_descrip = "National number of people employed (2005 pop size)") -->
<!-- write.csv(liv_nat_time_data, file.path(dir_baltic,'visualize/liv_nat_time_data.csv'),row.names=FALSE) -->
<!-- ``` -->
<!-- #### 6.5.2 Write to csv -->
<!-- ```{r write national layer to csv, message = FALSE} -->
<!-- write.csv(liv_national_employ, file.path(dir_layers,'liv_national_employ_bhi2015.csv'),row.names = FALSE) -->
<!-- ``` -->
7. Status and Trend calculation exploration
-------------------------------------------

Status and trend are calculated in functions.r but code is tested and explored here.

<!-- ### 7.1 Assign data layer -->
<!-- ```{r read in data layers for status and trend calc, message = FALSE} -->
<!--   liv_regional_employ -->
<!--   liv_national_employ  -->
<!-- ``` -->
<!-- ### 7.2 Set parameters -->
<!-- ```{r set parameters for status and trend calc, message = FALSE} -->
<!--  ## set lag window for reference point calculations -->
<!--   lag_win = 5  # 5 year lag -->
<!--   trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points) -->
<!--   bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend -->
<!-- ``` -->
### 7.1 Status calculation

#### Join regional and national employment data

``` r
## join regional and country employment rates
employ_compare = full_join(liv_regional_employ, 
                           dplyr::select(nat_employ3, 
                                  year, 
                                  rgn_id, 
                                  nat_employ_rate = value), 
                           by = c('year', 'rgn_id')) %>% 
  filter(year %in% 2010:2014) %>% 
  mutate(ratio = bhi_employ_rate/nat_employ_rate) 

## plot 
employ_compare_plot = ggplot(employ_compare) +
  geom_point(aes(x = year, y = ratio)) +
  facet_wrap(~rgn_id) +
  ggtitle('LIV status: BHI to national employment rate ratio')

print(employ_compare_plot)
```

![](liv_prep_files/figure-markdown_github/combine%20reg%20and%20nat%20employ%20rate-1.png)

#### Calcluate status

``` r
# set ref point and calculate scores for all years
liv_status_all_years = employ_compare %>% 
  group_by(rgn_id) %>% 
  mutate(ref = max(ratio) *1.1, 
         score = min(100, ratio/ref * 100)) 

# selecting most recent year of status - 2014
liv_status = liv_status_all_years %>% 
  filter(year == max(year)) %>% 
  dplyr::select(rgn_id, score) %>% 
  as.data.frame() %>% 
  complete(rgn_id = full_seq(rgn_id, 1)) # fill in the missing regions with status score of NA

# write_csv(liv_status, file.path(dir_layers, "liv_status_scores_bhi2015.csv"))


### old code: 

## LIV region: prepare for calculations with a lag
  # liv_region = liv_regional_employ %>%
  #   filter(year %in% 2010:2014)
   #  filter(year>= max(year) - 5) %>% #choose only most recent 5 years
   #  group_by(rgn_id) %>%
   #  arrange(year) %>%
   #  mutate(ref_val = max(employ)) %>% 
   #  ungroup() %>%
   #  mutate(rgn_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
   #  select(rgn_id,year,rgn_value) %>%
   # arrange(rgn_id,year)

# head( liv_region)
# dim(liv_region) ##222 3

# ## LIV country
#   liv_country =   liv_national_employ %>%
#     dplyr::rename(employ = employ_pop) %>%
#     filter(!is.na(employ)) %>%
#     group_by(rgn_id) %>%
#     mutate(year_ref = lag(year, lag_win, order_by=year),
#            ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
#     arrange(year) %>%
#     filter(year>= max(year)- lag_win) %>% #select only the previous 5 years from the max year
#     ungroup() %>%
#     mutate(cntry_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
#     select(rgn_id,year,cntry_value) %>%
#     arrange(rgn_id,year)
# 
#   head(liv_country)
#   dim(liv_country) ## 252  3
```

<!-- #### 7.3.2 Calculate status time series -->
<!-- ```{r calc liv status time series, message = FALSE} -->
<!-- ## calculate status -->
<!--   liv_status_calc = inner_join(liv_region,liv_country, by=c("rgn_id","year")) %>% #join region and country current/ref ratios ## inner_join because need to have both region and country values to calculate -->
<!--                mutate(Xliv = rgn_value/cntry_value) %>% #calculate status -->
<!--                mutate(status = pmin(1, Xliv)) # status calculated cannot exceed 1 -->
<!--   head(liv_status_calc) -->
<!--   dim(liv_status_calc) ## 222 6 -->
<!-- ``` -->
<!-- #### 7.3.3 Extract most recent year status -->
<!-- ```{r extract liv most recent year status, message = FALSE} -->
<!-- liv_status = liv_status_calc%>% -->
<!--               group_by(rgn_id) %>% -->
<!--               filter(year== max(year)) %>%       #select status as most recent year -->
<!--               ungroup() %>% -->
<!--               full_join(bhi_rgn, .,by="rgn_id") %>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data -->
<!--               mutate(score=round(status*100),   #scale to 0 to 100 -->
<!--                      dimension = 'status') %>% -->
<!--               select(region_id = rgn_id,score, dimension) #%>% -->
<!--               ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data -->
<!--                                     ##will this cause problems if there are regions that should be NA (because indicator is not applicable?) -->
<!-- head(liv_status) -->
<!-- ## what is max year -->
<!-- max_year_status= liv_status_calc%>% -->
<!--               group_by(rgn_id) %>% -->
<!--               filter(year== max(year)) %>%       #select status as most recent year -->
<!--               ungroup() %>% -->
<!--               select(rgn_id,year) -->
<!-- max_year_status %>% select(year) %>% distinct() ## all final years are 2014 -->
<!-- ``` -->
### 7.3.4 Which BHI regions have no status

Regions 19,22,30,33 have NA status.

Russian regions have NA status because no regional data (19,22,33)

Regions with no coast line have no status because not joined to a NUTS region (30)

`r  liv_status %>% filter(is.na(score)) #19,22,30,33`

### 7.3.1 Plot status

Status values in the time series are between 0 and 1.
There are no values for Russia because we do not have regional GDP data.
Status values for the most recent year (2014 for all regions) are transformed to value between 0 and 100

``` r
# ## plot liv status time series
# ggplot(liv_status_all_years) +
#   geom_point(aes(year,score)) +
#   facet_wrap(~rgn_id) +
#   ylim(0,1) +
#   ylab("Status") +
#   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
#                                    hjust=.5, vjust=.5, face = "plain"),
#         axis.text.y = element_text(size=6)) +
#   ggtitle("LIV status time series")

## plot liv status time series, less range on y-axis
ggplot(liv_status_all_years) +
  geom_point(aes(year,score)) +
  facet_wrap(~rgn_id) +
  ylim(80, 100) +
  ylab("Status") +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6)) +
  ggtitle("LIV status time series - different y-axis range")
```

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-1.png)

``` r
## plot final year (2014) status

ggplot(liv_status) +
  geom_point(aes(rgn_id,score), size=2) +
  ylim(80,100) +
  ylab("Status score") +
  xlab("BHI region") +
  ggtitle("LIV status score in 2014")
```

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-2.png)

### 7.4 Trend calculation

#### 7.4.1 Calculate Trend

``` r
  ## calculate trend for 5 years (5 data points)
  ## years are filtered in liv_region and liv_country, so not filtered for here
      liv_trend = liv_status_all_years %>%
        filter(year >= max(year - 5)) %>%                #select five years of data for trend
        filter(!is.na(score)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
        group_by(rgn_id) %>%
        # mutate(regr_length = n()) %>%                            #get the number of status years available for greggion
        # filter(regr_length == (5 + 1)) %>%                   #only do the regression for regions that have 5 data points
          do(mdl = lm(score ~ year, data = .)) %>%             # regression model to get the trend
            summarize(rgn_id = rgn_id,
                      score = coef(mdl)['year'] * 0.05) %>%
        ungroup() %>%
        tidyr::complete(rgn_id = full_seq(rgn_id, 1)) %>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
        mutate(score = round(score, 2),
               dimension = "trend") %>%
        select(rgn_id, dimension, score) %>%
        data.frame()

write_csv(liv_trend, file.path(dir_layers, "liv_trend_score_bhi2015.csv"))
```

#### 7.4.2 Which regions have NA trend?

19, 22, 30, and 33

``` r
liv_trend %>% filter(is.na(score)) ## 19,22,30,33
```

#### 7.4.3 Plot trend

``` r
ggplot(liv_trend) +
  geom_point(aes(rgn_id,score), size=2) +
  geom_hline(yintercept = 0) +
  ylim(-1,1) +
  ylab("Status score") +
  xlab("BHI region") +
  ggtitle("LIV 5 yr trend score")
```

![](liv_prep_files/figure-markdown_github/plot%20liv%20trend-1.png)

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

Marc sent the updated NUTS regions shape files for 2006 (on 9.2016).

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

10. Alternative data and Status calculation - Used for Status for now
---------------------------------------------------------------------

### 10.1 Alternative 1 - not incorporated

The [“Study on Blue Growth, Maritime Policy and the EU Strategy for the Baltic Sea Region”](https://webgate.ec.europa.eu/maritimeforum/node/3550) identified the potential for Blue Growth in each of the EU Member States of the Baltic Sea Region, and also provided detailed marine revenue and employment by sector and in each BHI country. Below is a trial to incorporate these data to LIV calculation, while using the same goal model.

We decided not to incorporate this data yet because of these two problems:

-   there is only one year of data, we couldn't establish a temporal reference point.
-   only six sectors that are identified as high-growth-potential have data, and thus provide incomplete data
-   *blue sectors employment rate* is very low (blue\_employment\_number / coastal\_population) is very low (~1%) compared with *national employment rate (~70%)*, so we couldn't compare these two as a LIV model

``` r
# notes for data calculated above:  
# nat_employ2: employment rate per country time series 
# nat_pop_2005: pop per country in 2005
# nuts2_pop_area2: BHI regional population 

# read in coastal employment data: 
coast_employ = read_csv(file.path(dir_liv, 'liv_data_database/marine_sector_employ_revenue_by_country.csv'))

# coastal population per country - sum of BHI population
coast_pop = nuts2_pop_area2 %>% 
  group_by(country) %>% 
  summarize(coast_pop = sum(pop) )

# join coastal employ and pop per country
coast_employ_rate = full_join(coast_pop, coast_employ, 
                        by = 'country') %>% 
  mutate(coast_rate = employ/coast_pop*100) %>% 
  dplyr::select(country, coast_rate)

# join coastal and national employ rate (2014)
employ_comp = full_join(coast_employ_rate, 
                        nat_employ2 %>% 
                          filter(year == '2014') %>% 
                          dplyr::select(country, nat_rate = value), 
                        by = 'country') %>% 
  mutate(ratio = coast_rate / nat_rate)

knitr::kable(employ_comp)

#     country coast_rate nat_rate       ratio
# 1   Denmark  0.6652809     72.8 0.009138474
# 2   Estonia  0.7302494     69.6 0.010492089
# 3   Finland  0.4813689     68.7 0.007006826
# 4   Germany  3.2293824     73.8 0.043758569
# 5    Latvia  1.3260321     66.3 0.020000483
# 6 Lithuania  0.1507039     65.7 0.002293819
# 7    Poland  1.1411735     61.7 0.018495519
# 8    Sweden  0.6502281     74.9 0.008681284

### EXTRA ###
# # compare coastal and national pop 
# pop_comp = full_join(coast_pop, nat_pop_2005) %>% 
#   mutate(ratio = coast_pop/pop_2005) 
```

### 10.2 Alternative 2 - not incorporated

We downloaded employment data by sector on the country level from the blue growth report supplemental tables - more detailed data than Alternative 1 . Saved in `prep/LIV/liv_data_database/BHI_employ_revenue_by_country_2010.csv`.

Reference point is set at 5% growth by 2020.

``` r
blue_growth_employ <- read_csv(file.path(dir_liv, 'liv_data_database/BHI_employ_revenue_by_country_2010.csv')) %>% 
  filter(!is.na(employment)) %>% 
  data.frame(.) %>% 
  select(country, employment) %>% 
  group_by(country) %>% 
  summarize(employ = sum(as.numeric(employment))*1000)

liv_status <- blue_growth_employ %>% 
  mutate(ref_point = employ*1.05, 
         score = employ/ref_point*100) %>% 
  full_join(bhi_lookup, by = 'country') %>% 
  select(rgn_id, score) 

# 19, 22, 33 have a score of NA because there was no data on Russia employment. 

#write_csv(liv_status, file.path(dir_layers, "liv_status_scores_bhi2015.csv"))
```

### 10.3 Alternative 3 - Used for now

We downloaded [Eurostat country-level employment rate and target employment rate](http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=0&language=en&pcode=t2020_10&tableSelection=1) from 2008 to 2012. We chose this time frame because LIV status, based on Blue Growth report, used 2010 data. So we wanted to keep the time frame similar.

This data is not specific to the blue sectors. However, it provided more accurate numbers than the original approach (derived from NUTS regional data), and a broader time frame and an accurate, country-specefic reference point than Alt. 2.

Data not available for Russia.

``` r
#### Status Calculation ####

# load data
euro_data = read_csv(file.path(dir_liv, 'liv_data_database/liv_employment_rate_Eurostat.csv')) %>% 
  select(country, 2:6, target) %>%  # choosing year 2008 - 2012 and ref point
  gather(year, emp_rate, 2:6)

# calculate status all years
liv_stat_3 = euro_data %>% 
  mutate(score = pmin(emp_rate/target * 100, 100)) %>% 
  select(country, year, score)

# plot status all years
plot_status_3 = ggplot(liv_stat_3) +
  geom_point(aes(year, score, color = country)) +
  facet_wrap(~country) +
  ggtitle("LIV Status by country - Alt. 3 with Eurostat employment rate data") +
  theme(plot.title = element_text(hjust = 0.5))

print(plot_status_3)
```

![](liv_prep_files/figure-markdown_github/alt.%203-1.png)

``` r
# select only most recent year (2012)
liv_stat_3_final = liv_stat_3 %>% 
  filter(year == 2012)

# match with BHI ID
liv_stat_3_bhi = full_join(liv_stat_3_final, bhi_lookup) 

# save layer in layers folder
write_csv(liv_stat_3_bhi, file.path(dir_layers, 'liv_status_scores_bhi2015.csv'))

#### Trend Calcuation ####

liv_trend_3 = liv_stat_3 %>% 
  group_by(country) %>% 
  do(mdl = lm(score~year, data = .)) %>% 
  summarize(country = country,
            score = coef(mdl)[2]*0.05)

liv_trend_3_bhi = full_join(liv_trend_3, bhi_lookup)

write_csv(liv_trend_3_bhi, file.path(dir_layers, 'liv_trend_scores_bhi2015.csv'))

# plot trend
liv_trend_3_plot = ggplot(liv_trend_3) +
  geom_point(aes(x = country, y = score)) +
  ggtitle("LIV trend by country - Alt. 3 with Eurostat employment rate data") +
  theme(plot.title = element_text(hjust = 0.5))

print(liv_trend_3_plot)
```

![](liv_prep_files/figure-markdown_github/alt.%203-2.png)