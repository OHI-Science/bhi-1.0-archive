Clean Water (CW) - Nutrient (NUT) Subgoal Data Preparation
================

-   [1. Background](#background)
    -   [Goal Description](#goal-description)
    -   [Model & Data](#model-data)
    -   [Reference points](#reference-points)
    -   [Considerations for *BHI 2.0*](#considerations-for-bhi-2.0)
    -   [Other information](#other-information)
-   [2. Secchi Data Prep](#secchi-data-prep)
    -   [2.1 Data sources](#data-sources)
    -   [2.2 Data Cleaning and decision-making](#data-cleaning-and-decision-making)
-   [3. Goal Model](#goal-model)
-   [4. Data Prep](#data-prep)
    -   [4.1 Read in data](#read-in-data)
    -   [4.2 Remove coastal observations](#remove-coastal-observations)
    -   [4.3 Reference points](#reference-points-1)
    -   [4.4 HELCOM HOLAS Basin](#helcom-holas-basin)
    -   [4.5 Select summer data and plot](#select-summer-data-and-plot)
    -   [4.6 Assign secchi data to a HOLAS basin](#assign-secchi-data-to-a-holas-basin)
    -   [4.7 Restrict data to before 2014](#restrict-data-to-before-2014)
    -   [4.8 Evaluate number of stations sampled in each basin](#evaluate-number-of-stations-sampled-in-each-basin)
    -   [4.9 Mean secchi Calculation](#mean-secchi-calculation)
-   [5. Status Calculation](#status-calculation)
    -   [5.1 Explore status years](#explore-status-years)
    -   [5.2 Calculate status for each basin](#calculate-status-for-each-basin)
-   [6. Calculate Trend](#calculate-trend)
-   [7. Plot Status and Trend](#plot-status-and-trend)
    -   [Plot basin status](#plot-basin-status)
    -   [Plot BHI region status and trend values](#plot-bhi-region-status-and-trend-values)
    -   [Save csv files](#save-csv-files)
-   [8. Further questions](#further-questions)
-   [9. Transform status](#transform-status)
-   [10. Trial: add Anoxia data to Nutrient calculations (NUT)](#trial-add-anoxia-data-to-nutrient-calculations-nut)

1. Background
-------------

### Goal Description

The Nutrient sub-goal of the Clean Water goal captures the degree to which local waters are affected by eutrophication. **For the BHI two eutrophication indicators were included: Secchi depth and hypoxic area**. Secchi depth is used as a proxy for water clarity, which reflects nutrient level in the water. Hypoxic area represents the long-term effects of human activities on nutrient levels and water quality. Both indicators are used as [core indicators](http://www.helcom.fi/baltic-sea-trends/indicators/water-clarity) for eutrophication by HELCOM.

### Model & Data

To calculate the status of the Nutrient sub-goal the geometric mean of both the Secchi depth status and the hypoxic area status have been calculated for Bornholm Basin, Western Gotland Basin, Eastern Gotland Basin, Northern Baltic Proper and Gulf of Finland. For the other basins only the Secchi depth has been used to calculate the nutrient status.

-   [Mean Summer Secchi depth (June-September) data from ICES database](http://www.ices.dk/marine-data/Pages/default.aspx).
-   [Hypoxic area data published by Carstensen et al. 2014](http://www.pnas.org/content/111/15/5628.abstract). Deep water anoxia are defined as O2 level &lt;2 mg⋅L−1. It represents the long-term effects of human activities on nutrient levels and water quality. We used deep water anoxia only for the following basins: Bornholm Basin, Western Gotland Basin, Eastern Gotland Basin, Northern Baltic Proper and Gulf of Finland.

### Reference points

**Secchi depth reference points** are set based on the results obtained in the TARGREV project (HELCOM 2013a), taking advantage of the work carried out during the EUTRO PRO project (HELCOM 2009) and national work for WFD. The final targets were set through an expert evaluation process done by the intersessional activity on development of core eutrophication indicators (HELCOM CORE EUTRO) and the targets were adopted by the HELCOM Heads of Delegations.

-   [Approaches and methods for eutrophication target setting in the Baltic Sea region](http://www.helcom.fi/Documents/Ministerial2013/Associated%20documents/Background/Eutorophication%20targets_BSEP133.pdf)
-   [Fleming-Lehtinen and Laamanen. 2012. Long-term changes in Secchi depth and the role of phytoplankton in explaining light attenuation in the Baltic Sea. Estuarine, Coastal, and Shelf Science 102-103:1-10](http://www.sciencedirect.com/science/article/pii/S0272771412000418)
-   [EUTRO-OPER](http://helcom.fi/helcom-at-work/projects/eutro-oper/). Included on this page is a link to the [Eutrophication Assessment Manual](http://helcom.fi/Documents/Eutrophication%20assessment%20manual.pdf)

**The hypoxic area reference point** is set to be the hypoxic area of each basin in 1906.

### Considerations for *BHI 2.0*

### Other information

*external advisors/goalkeepers: Christoph Humborg*

2. Secchi Data Prep
-------------------

The following sections of the document focuses on Secchi data preparation. Anoxia preparation is documented [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/pressures/open_sea_anoxia/open_sea_anoxia_prep.md).

### 2.1 Data sources

**ICES**
Data extracted from database and sent by Hjalte Parner.
\* "extraction from our database classified into HELCOM Assessment Units – HELCOM sub basins with coastal WFD water bodies or water types"

**SMHI**
Downloaded from [SMHI Shark database](http://www.smhi.se/klimatdata/oceanografi/havsmiljodata/marina-miljoovervakningsdata) on 23 February 2016 by Lena Viktorsson.
\* Download notes: datatyp: Physical and Chemical; Parameter: secchi depth
Lena did not exclude any data when she downloaded it.

### 2.2 Data Cleaning and decision-making

**Duplicates in the Data**
ICES data contains profile data (eg temperature,but secchi is only measured once). Need only unique secchi records. It appears the SMHI also contains profiles. Also check to see if any SMHI data already in the ICES records.

**Coastal data**
- non-coastal (offshore) data are flagged with the code "0" under the column *"HELCOM\_COASTAL\_CODE"*
- HOLAS basin shape files with coastal and non-coastal areas were overlayed with the secchi sampling locations, all locations were flagged with a code indicating coastal or offshore.
- Coastal data are removed from the analysis.
- This should result in a similar dataset used as Fleming-Lehtinen and Laamanen 2012 (see map).

**Sampling frequency** *Can / should these data decisions be implemented? We have not implemented this so far*
Fleming-Lehtinen and Laamanen (2012) do the following:
- If several observations were made on the same day in the vicinity of one another, they set max observation to 1 per day.
- If trips were made with objective to study seasonal algae blooms, a maximum of two observations were accepted to avoid bias.

3. Goal Model
-------------

**Status**

Status = Summer Mean Secchi values / Reference point

-   Summar Mean Secchi values = mean secchi values June - September
-   Reference point = HELCOM-set target values

**Trend**

The trend is calculated based on a linear regression of past 10 years of status.

In our approach here, we use a 10 year period to calculate the trend with a minimum of 5 data points. In most cases, the BHI framework uses a 5 year period for the trend, but as secchi is a slow response variable, we use a longer time period.
The trend value is the slope (m) of the linear regression multiplied by the year of future interest (5 years from status year) and this value is constrained to between -1 and 1.

4. Data Prep
------------

### 4.1 Read in data

Prelimary filtering to remove duplicate values within datasets (eg profiles) and between datasets.

Check initial smhi and ices datasets for observations from BHI regions 5 & 6 (The Sound) - region 5 all have a coastal designation. ICES data for region 6 includes both coastal and offshore but only 3 data points offshore from 2000- present. SMHI data contains no observations from region 6.

Some data points do not have a BHI ID assigned. Appears that almost all have a coastal code that != 0. If they are very close to the coast - they may fall outside the BHI shapefile. Because we exclude all sites that are coastal - only one site will have to have BHI added manually.

``` r
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
```

    ## Warning: package 'tidyr' was built under R version 3.3.2

``` r
dir_cw    = file.path(dir_prep, 'CW')
dir_secchi    = file.path(dir_prep, 'CW/nutrient')

## add a README.md to the prep directory 
create_readme(dir_secchi, 'nutrient_prep.rmd')
```

``` r
## read in secchi data
data1 = readr::read_csv(file.path(dir_secchi, 'secchi_data_database/ices_secchi.csv'))
data2 = readr::read_csv(file.path(dir_secchi, 'secchi_data_database/smhi_secchi.csv'))

# Data overview
dim(data1)
colnames(data1)
str(data1)

dim(data2)
colnames(data2)
str(data2)

## Initial filtering
ices <- data1 %>% data.frame()%>%
  dplyr::select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
         lat= Latitude, lon = Longitude, 
         cruise= Cruise, station = Station, date= Date, coast_code=HELCOM_COASTAL_CODE) %>%
  mutate(date = as.Date(date, format= "%Y-%m-%d"))%>%
  mutate(supplier = 'ices')
head(ices)


##which ices data have BHI_ID of NA
ices.na <- ices %>%
           filter(is.na(bhi_id))
  
    dim(ices.na) # 1684   11
    ices.na.loc = ices.na %>% dplyr::select(lat,lon) %>% distinct() ## unique locations
    dim(ices.na.loc) # 86  2
    ices.na %>% dplyr::select(coast_code)%>% distinct()  ## at least one location is off shore
    ices.na %>% filter(coast_code==0)

    ## will need to manally add BHI id for site with NA and coastal code of 0



smhi <- data2 %>% data.frame()%>%
  rename(secchi = value) %>%
  dplyr::select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
        lat= Latitude, lon= Longitude, 
         cruise = Provtagningstillfaelle.id, 
         station = Stationsnamn, date= Date, coast_code=HELCOM_COASTAL_CODE) %>%
  mutate(supplier = 'smhi', cruise = as.character(cruise))
head(smhi)

## is na smhi
smhi.na <- smhi %>%
           filter(is.na(bhi_id))
  
    dim(smhi.na) # 35034    11
    smhi.na.loc = smhi.na %>% dplyr::select(lat,lon) %>% distinct() ## unique locations
    dim(smhi.na.loc) #615   2
    smhi.na %>% dplyr::select(coast_code)%>% distinct()  ## none are offshore
    smhi.na %>% filter(coast_code==0)
    ## no coastal code of zero


## Look for duplicate data

## is any data duplicated in ices itself
ices.duplicated = duplicated(ices)
sum(ices.duplicated==TRUE) #181855  ## MANY duplicates 

ices.duplicated = duplicated(dplyr::select(ices,-station))
sum(ices.duplicated==TRUE) #181977 ## more duplicated when remove station columns
    ## it is not because of multiple cruises on same day and location
    ## tried by removing lat and lon and keeping station, fewer duplicates detected

## duplicates because ICES table includes deptp
new_ices = unique(dplyr::select(ices,-station)); nrow(new_ices)  #take only unique records # 33566


## is any data duplicated in smhi itself
smhi.duplicated = duplicated(dplyr::select(smhi, -station))
sum(smhi.duplicated==TRUE) #85691 ## MANY duplicates  ## removing station does not affect it
new_smhi = unique(dplyr::select(smhi, -station)); nrow(new_smhi) #take only unique records # 17099

## use setdiff() to indentify data smhi not in ices
new_smhi = setdiff(dplyr::select(new_smhi,-supplier,-cruise), dplyr::select(new_ices,-supplier,-cruise)) %>%
            mutate(supplier = "smhi")
nrow(new_smhi) #  16627
## it appears 461 records are duplicates (if remove cruise and station)
## if date, lat, lon, secchi all match, I think they are duplicates

## Now create a new allData, bind only the new_smhi object to ices
allData = bind_rows(new_ices,new_smhi)
nrow(allData) # 50193
allData %>% dplyr::select(year, month, date, cruise, lat, lon,secchi) %>% distinct() %>%nrow(.)  #50193

## what if remove cruise
allData %>% dplyr::select(year, month, date, lat, lon,secchi) %>% distinct() %>%nrow(.)
# 50193
```

### 4.2 Remove coastal observations

Select only data with coastal code "0"

``` r
dim(allData) #[1]  50193    10

## Do any observations have NA for coast_code
allData %>% filter(is.na(coast_code) & is.na(bhi_id)) %>% dim() # 3567   10
allData %>% filter(is.na(coast_code) & !is.na(bhi_id)) %>% dim() #  3 10
  
## 3567 observations with no coast_code or BHI_ID, all from SMHI, are 292 distinct locations
loc_no_coastcode_nobhi =allData %>% 
  filter(is.na(coast_code) & is.na(bhi_id))%>%
  dplyr::select(lat,lon)%>%
  distinct()

## check locations
library('ggmap')
map = get_map(location = c(8.5, 53, 32, 67.5))

# plot_map1 = ggmap(map) +
#   geom_point(aes(x=lon, y=lat), data=loc_no_coastcode_nobhi,size = 2.5)
# 
# plot_map1
## these locations are very coastal or outside of the Baltic Sea

##3 observations with NA for the coast_code but have BHI_ID
loc_no_coastcode_bhi =  allData %>% 
  filter(is.na(coast_code) & !is.na(bhi_id)) %>% 
  dplyr::select(lat,lon)%>%
  distinct()

# plot_map2 = ggmap(map) +
#   geom_point(aes(x=lon, y=lat), data=loc_no_coastcode_bhi,size = 2.5)
# 
# plot_map2
## these are clearly coastal stations


## What are coastal codes for The Sound (BHI regions 5,6)
##Region 6
allData %>% filter(bhi_id %in% 6) %>% dplyr::select(bhi_id,year,date,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)
    ## three observations in BHI region 6 after 2000
    ## Not summer observations
allData %>% filter(bhi_id %in% 6) %>% dplyr::select(coast_code, supplier)%>%distinct(.)

#Region 5
allData %>% filter(bhi_id %in% 5) %>% dplyr::select(bhi_id,year,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)

allData %>% filter(bhi_id %in% 5) %>% dplyr::select(coast_code, supplier)%>%distinct(.)
    ## All region 5 codes are coastal



## Filter data that are only offshore, coast_code == 0
allData = allData %>% filter(coast_code==0)

dim(allData)#14019    10 

## This is a substantial reduction in the number of observations

## find data points without BHI ID
allData %>% filter(is.na(bhi_id))  ##manual check is just barely within Latvian EEZ so is region 27

allData = allData %>%
          mutate(bhi_id = ifelse(is.na(bhi_id),27, bhi_id))
allData %>% filter(is.na(bhi_id))  
```

### 4.3 Reference points

These are the values that will be used as a reference point.

``` r
target <- readr::read_csv(file.path(dir_secchi, "eutro_targets_HELCOM.csv"))
head(target)

#select just summer_seccchi target
target = target %>% dplyr::select(basin, summer_secchi)%>%
        mutate(basin = str_replace_all(basin,"_"," "))
```

### 4.4 HELCOM HOLAS Basin

These basins are the relevant physical units.
Secchi data will be first assessed at this level and then assigned to BHI region. EEZ divisions may result in some BHI regions that have no data but they are physically the same basin as a BHI region with data.

``` r
basin_lookup = read.csv(file.path(dir_secchi,'bhi_basin_country_lookup.csv'), sep=";")
basin_lookup=basin_lookup %>% dplyr::select(bhi_id = BHI_ID, basin_name=Subbasin)
```

### 4.5 Select summer data and plot

We chose Months 6-9 (June, July, August, September) and Years &gt;= 2000

Data is sparse for BHI regions 4,22,25.

No data BHI regions 5 (all coastal), 6 (offshore observations rare after from 2000 and not in summer).

``` r
summer = allData %>% filter(month %in%c(6:9)) %>%
        filter(year >=2000)
head(summer)



#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~bhi_id, scales ="free_y")
```

![](nutrient_prep_files/figure-markdown_github/dplyr::select%20summer%20data-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~bhi_id)
```

![](nutrient_prep_files/figure-markdown_github/dplyr::select%20summer%20data-2.png)

### 4.6 Assign secchi data to a HOLAS basin

Data coverage appears better at the basin scale.

With coastal data excluded, there are **no data points observed in the The Sound**

Some basins have missing data or limited data for the most recent years: Aland Sea, Great Belt, Gulf of Riga, Kiel Bay, The Quark.

``` r
summer = summer %>% full_join(., basin_lookup, by="bhi_id")

#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~basin_name)
```

![](nutrient_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name)
```

![](nutrient_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-2.png)

### 4.7 Restrict data to before 2014

The Sound does not appear in the plot because there is no data.

There are still basins with limited or not data from 2010 onwards (*Great Belt*) but this at least removes the potential for not having data reported in the past 2 years.

``` r
summer = summer %>% filter(year < 2014)

#Plot
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y") 
```

![](nutrient_prep_files/figure-markdown_github/restrict%20data%20before%202014-1.png)

``` r
## SAVE DATA FOR VISUALIZE

nut_space_data = summer %>%
                 dplyr::select(lat,lon)%>%
                 distinct()%>%
                 mutate(data_descrip = "summer secchi unique sampling locations 2000-2013",
                        bhi_goal = "NUT")

write.csv(nut_space_data, file.path(dir_baltic,'visualize/nut_space_data.csv'),row.names=FALSE)

nut_time_data = summer %>%
                dplyr::select(rgn_id=bhi_id,basin=basin_name,year,variable=month,value=secchi)%>%
                mutate(unit="secchi depth m",
                       data_descrip = "summer secchi observations",
                       bhi_goal ="NUT")


write.csv(nut_time_data, file.path(dir_baltic,'visualize/nut_time_data.csv'),row.names=FALSE)
```

### 4.8 Evaluate number of stations sampled in each basin

Very different number of unique lat-lon locations are found by month and basin.

Sometimes lat-lon is not good to use because recording specific ship location which might be vary even though ship is at the same station. More duplicates were detected in the data however when station was not included, than when lat and lon were not included as the location identifier.

``` r
basin_summary = summer %>% group_by(basin_name,year,month)%>%
                dplyr::select(year, month,lat,lon,basin_name)%>%
                summarise(loc_count = n_distinct(lat,lon))
#basin_summary

#plot sampling overview
ggplot(basin_summary) + geom_point(aes(year,loc_count, colour=factor(month)))+
  facet_wrap(~basin_name, scales ="free_y")+
  ylab("Number Sampling Locations") +
  ggtitle("Number of Stations sampled in each basin")
```

![](nutrient_prep_files/figure-markdown_github/samples%20and%20stations%20by%20basin-1.png)

### 4.9 Mean secchi Calculation

#### Calculate mean monthly value for each summer month

basin monthly mean = mean of all samples within month and basin

``` r
mean_months = summer %>% dplyr::select(year, month,basin_name,secchi)%>%
              group_by(year,month,basin_name)%>%
              summarise(mean_secchi = round(mean(secchi,na.rm=TRUE),1))%>%
              ungroup()
# head(mean_months)
```

#### Plot mean monthly value by basin

There are limited July sampling in a number of basins

The Quark only sampled in June in early part of time series, August later half of time series.

``` r
ggplot(mean_months) + geom_point(aes(year,mean_secchi, colour=factor(month)))+
  geom_line(aes(year,mean_secchi, colour=factor(month)))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10)) +
  ggtitle("Mean Monthly Secchi")
```

![](nutrient_prep_files/figure-markdown_github/plot%20mean%20monthly-1.png)

#### Calculate summer mean secchi (basin)

basin summer mean = mean of basin monthly mean values

``` r
mean_months_summer = mean_months %>% dplyr::select(year, basin_name,mean_secchi) %>%
                      group_by(year,basin_name)%>%
                      summarise(mean_secchi = round(mean(mean_secchi,na.rm=TRUE),1)) %>%
                      ungroup()  #in mean calculation all some months to have NA, ignore for that years calculation
```

#### Plot summer mean secchi

``` r
ggplot(mean_months_summer) + geom_point(aes(year,mean_secchi))+
  geom_line(aes(year,mean_secchi))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10)) +
  ggtitle("Mean Summer Secchi")
```

![](nutrient_prep_files/figure-markdown_github/plot%20mean%20summer%20secchi-1.png)

#### Plot summer secchi with target values indicated

Horizontal lines are HELCOM target values.

``` r
secchi_target = left_join(mean_months_summer,target, by=c("basin_name" = "basin"))%>%
                dplyr::rename(target_secchi = summer_secchi)
# head(secchi_target)

ggplot(secchi_target) + geom_point(aes(year,mean_secchi))+
  geom_line(aes(year,target_secchi))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10)) +
  ggtitle("Mean Summer Secchi against Targe values")
```

![](nutrient_prep_files/figure-markdown_github/summer%20secchi%20with%20target-1.png)

5. Status Calculation
---------------------

### 5.1 Explore status years

All basins have data for 2013, which will be used as the status year, except for five basins:

-   Aland Sea, Great Belt, Gulf of Finland, Gulf of Riga, and The Quark

For these five basins, their most recent year's data is used for current status calculations.

``` r
## get the last year of non-NA data
last_year = secchi_target%>%
            filter(!is.na(mean_secchi))%>%
            group_by(basin_name)%>%
            summarise(last_year = last(year)) %>%
            print(n=15)

##which are not in 2013
last_year %>% filter(last_year < 2013)

#        basin_name last_year
# 1       Aland Sea      2012
# 2      Great Belt      2009
# 3 Gulf of Finland      2012
# 4    Gulf of Riga      2012
# 5       The Quark      2012
```

### 5.2 Calculate status for each basin

**Status calculation with raw (non-modeled) mean summer secchi by basin**

Status must be calculated in data prep because it's calculated on the basin level and then applied to all regions.

``` r
## Define constants for status calculation

  min_year = 2000        # earliest year to use as a start for regr_length timeseries
                          ##data already filtered for 
  regr_length = 10       # number of years to use for regression
  future_year = 5        # the year at which we want the likely future status
  min_regr_length = 5    # min actual number of years with data to use for regression.

  
## Basin data with target
  secchi_target
  
  
## Calculate basin status = basin_mean/basin_target
  
  basin_status = secchi_target %>%
                 mutate(., status =  pmin(1, mean_secchi/target_secchi)) %>%
      dplyr::select(basin_name, year, status)

## Assign basin status to BHI regions
  
    bhi_status = basin_status %>%
                group_by(basin_name)%>%
                summarise_each(funs(last), basin_name, status)%>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(status*100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                mutate(dimension = 'status') %>%
                dplyr::select(rgn_id = bhi_id, dimension, score=status)
```

6. Calculate Trend
------------------

``` r
## Calculate basin trend
  
  basin_trend =
    basin_status %>%
    group_by(basin_name) %>%
    do(tail(. , n = regr_length)) %>%  # calculate trend only if there is at least X years of data (min_regr_length) in the last Y years of time serie (regr_length)
    do({if(sum(!is.na(.$status)) >= min_regr_length)
    data.frame(trend_score = 
                 max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year)))
         else data.frame(trend_score = NA)}) %>%
    ungroup() 

  ## Assign basin trend to BHI regions
                
    bhi_trend = left_join(basin_lookup,basin_trend, by="basin_name") %>%
                 mutate(score = round(trend_score,2),
                        dimension = "trend")%>%
                dplyr::select(rgn_id = bhi_id, dimension, score )
```

7. Plot Status and Trend
------------------------

### Plot basin status

Basin status is initially a value between 0 - 1. Calculated for each year between 2000 and 2013.

``` r
ggplot(basin_status) + geom_point((aes(year,status)))+
  facet_wrap(~basin_name) +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))
```

![](nutrient_prep_files/figure-markdown_github/plot%20basin%20status-1.png)

### Plot BHI region status and trend values

Status values can range from 0-100 -- this is the status for the *most recent* year. In most cases this is 2013.

No status or trend for 5 or 6 - these are The Sound, which had no data.

``` r
ggplot(full_join(bhi_status,bhi_trend, by=c("rgn_id","dimension","score"))) + geom_point(aes(rgn_id,score),size=2)+
  facet_wrap(~dimension, scales="free_y")+
  xlab("BHI region")
```

![](nutrient_prep_files/figure-markdown_github/bhi%20status%20and%20trend%20plot-1.png)

### Save csv files

These csv files will be used as a first cut for the secchi status and trend. **Files to save**
1. Status and trend for each BHI region based on the basin level calculations

``` r
## Write csv files to layers
    readr::write_csv(bhi_status, 
                 file.path(dir_layers, "cw_nu_status_bhi2015.csv"))
    
    readr::write_csv(bhi_trend, 
                 file.path(dir_layers, "cw_nu_trend_bhi2015.csv"))
```

8. Further questions
--------------------

**Trend calculation**
1. Have calculated the trend using data spanning 10 years (minimum of 5 data points). Is it agreed that we should use the longer time window for the trend?

**No Observations for The Sound**
1. The Sound has no summer offshore observations after 2000 in either ICES or SMHI data.
- How is it evaluated by HOLAS?
- BHI regions are 5 & 6. 5 is all coastal, 6 has both coastal and offshore observations before 2000 and from 2000 forward, 3 offshore observations in spring (not summer).

9. Transform status
-------------------

We tried different transformations to the status scores to represent the scores. However, we decided that these transformations do not contribute to better representation of the status scores. We will stick to the original scores. Different transformations are recorded below:

**Decay**:

-   transformation\_1 = score^2
-   transformation\_2 = score^4

**Logistic**:

-   transformation\_3 = 1/(1+ exp(-(score - 0.5)/0.1))
-   transformation\_4 = 1/(1+ exp(-(score - 0.7)/0.08))

``` r
## non-linear transformation: decay and logisitic

## decay: 
## high interests in general. scores are always disproprotionally low. 
## status_1 & status_2 = ratio^m
## m_1 = 2
## m_2 = 4

## logistic:
## status_3 & status_4 = 1/(1 + exp( -(ratio - a)/b))
## a_3 = 0.5, b_3 = 0.1 -> medium-interests: water quality considered bad when secchi depth <50% of target value and are given disproportionally bad scores. 
## a_4 = 0.7, b_4 = 0.08 -> high-interests: water quality considered bad when secchi depth <80% of target value and are given disproportionally bad scores. 

## general comparison of decay and logistic

basin_status_rescaled = data.frame(ratio = seq(0, 1, 0.1)) %>%
  mutate(linear = ratio,
         transformation_1 = ratio^2,
         transformation_2 = ratio^4,
         transformation_3 = 1/(1+ exp(-(ratio - 0.5)/0.1)),
         transformation_4 = 1/(1+ exp(-(ratio - 0.7)/0.08))) %>% 
  gather(key = transformation, value = status, 2:6)

plot_rescaled = qplot(x = ratio, y = status, color = transformation, data =  basin_status_rescaled, geom = "point") +
  geom_line(stat = "identity", position = "identity") +
  labs(title = 'Example non-linear transformations of Nutrients status score',
      x = 'Non-transformed status score (mean_secchi/target_secchi)', 
      y = 'Transformed status score',
      fill = 'Transformation')

print(plot_rescaled)


 ## setup to plot different tranformations using PlotMap function

 source('~/github/bhi/baltic2015/PlotMap.r')
 source('~/github/bhi/baltic2015/PrepSpatial.R') 
 #install.packages('maptools')
 #install.packages('broom')

## transformation 1: status = (mean_secchi/target_secchi) ^ 2

 basin_status_orig = secchi_target %>%
                 mutate(ratio =  pmin(1, mean_secchi/target_secchi)) %>%
      dplyr::select(basin_name, year, ratio)

 bhi_status_1 = basin_status_orig %>%
                group_by(basin_name) %>%
                summarise_each(funs(last), basin_name, ratio) %>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(ratio^2*100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                # mutate(dimension = 'status') %>%
                dplyr::select(rgn_id = bhi_id, score=status)
 
 if (!require(gpclib)) install.packages("gpclib", type="source")
gpclibPermit()

 plot_transf_1 =  PlotMap(bhi_status_1, map_title = expression('Transformation 1: status = (mean/target)' ^ 2), 
                           rgn_poly        = PrepSpatial(path.expand('~/github/bhi/baltic2015/spatial/regions_gcs.geojson')))
                          # fig_path       = path.expand('~/github/bhi/baltic2015/prep/CW/secchi/transformation_figs')) 
                      
  
 ## transformation 2: status =  (mean_secchi/target_secchi) ^ 4

  bhi_status_2 = basin_status_orig %>%
                group_by(basin_name) %>%
                summarise_each(funs(last), basin_name, ratio) %>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(ratio^4*100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                # mutate(dimension = 'status') %>%
                dplyr::select (rgn_id = bhi_id, score=status)

 plot_transf_2 =  PlotMap(bhi_status_2, map_title = expression('Transforamtion 2: status = (mean/target)' ^ 4), 
                           rgn_poly = PrepSpatial(path.expand('~/github/bhi/baltic2015/spatial/regions_gcs.geojson')))


 ## transformation 3: status = 1/(1+ exp(-(mean/target - 0.5)/0.1))

 bhi_status_3 = basin_status_orig %>%
                group_by(basin_name) %>%
                summarise_each(funs(last), basin_name, ratio) %>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(1/(1+ exp(-(ratio - 0.5)/0.1)) *100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                # mutate(dimension = 'status') %>%
                dplyr::select (rgn_id = bhi_id, score=status)

 plot_transf_3 =  PlotMap(bhi_status_3, 
                          map_title = 'Transformation 3: \n status = 1/(1+ exp(-(mean/target - 0.5)/0.1))', 
                          rgn_poly = PrepSpatial(path.expand('~/github/bhi/baltic2015/spatial/regions_gcs.geojson')))



## transformation 4: status = 1/(1+ exp(-(mean/target - 0.7)/0.08))

 bhi_status_4 = basin_status_orig %>%
                group_by(basin_name) %>%
                summarise_each(funs(last), basin_name, ratio) %>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(1/(1+ exp(-(ratio - 0.7)/0.08)) *100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                # mutate(dimension = 'status') %>%
                dplyr::select (rgn_id = bhi_id, score=status)

 plot_transf_4 =  PlotMap(bhi_status_4,  
                          map_title = 'Transformation 4: \n status = 1/(1+ exp(-(mean/target - 0.7)/0.08))', 
                           rgn_poly = PrepSpatial(path.expand('~/github/bhi/baltic2015/spatial/regions_gcs.geojson')))
```

10. Trial: add Anoxia data to Nutrient calculations (NUT)
=========================================================

``` r
# will move to functions.R

anoxia_status = read_csv(file.path(dir_layers, 'hab_anoxia_bhi2015.csv')) %>% 
    mutate(anoxia_score = (1-pressure_score) *100 ) %>% 
    dplyr::select(rgn_id, anoxia_score)

nut_status = full_join(dplyr::select(bhi_status, 
                                     rgn_id, 
                                     secchi_score = score), 
                       anoxia_status, 
                       by = 'rgn_id') %>% 
  mutate(nut_status = mean(c(anoxia_score,  secchi_score), na.rm = F) )
```