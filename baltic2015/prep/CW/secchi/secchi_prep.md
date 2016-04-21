secchi\_prep
================

``` r
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
```

    ## Warning: package 'readr' was built under R version 3.2.4

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Warning: package 'ggplot2' was built under R version 3.2.4

    ## Loading required package: DBI

``` r
dir_cw    = file.path(dir_prep, 'CW')
dir_secchi    = file.path(dir_prep, 'CW/secchi')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_secchi, 'secchi_prep.rmd')
```

1. Background on using Secchi
-----------------------------

[HELCOM Water Clarity Core Indicator](http://www.helcom.fi/baltic-sea-trends/indicators/water-clarity) Mean Summer Secchi (June-September)
**HELCOM Good Environmental Status** "Good environmental status is measured in relation to scientifically based and commonly agreed sub-basin-wise target levels.

These GES boundaries were based on the results obtained in the TARGREV project (HELCOM 2013a), taking also advantage of the work carried out during the EUTRO PRO project (HELCOM 2009) and national work for WFD. The final targets were set through an expert evaluation process done by the intersessional activity on development of core eutrophication indicators (HELCOM CORE EUTRO) and the targets were adopted by the HELCOM Heads of Delegations 39/2012."

[Approaches and methods for eutrophication target setting in the Baltic Sea region](http://www.helcom.fi/Documents/Ministerial2013/Associated%20documents/Background/Eutorophication%20targets_BSEP133.pdf)

[Fleming-Lehtinen and Laamanen. 2012. Long-term changes in Secchi depth and the role of phytoplankton in explaining light attenuation in the Baltic Sea. Estuarine, Coastal, and Shelf Science 102-103:1-10](http://www.sciencedirect.com/science/article/pii/S0272771412000418)

[EUTRO-OPER](http://helcom.fi/helcom-at-work/projects/eutro-oper/) Making HELCOM Eutrophication Assessments operational. Check here for HELCOM status calculations and assessment. Included on this page is a link to the [Eutrophication Assessment Manual](http://helcom.fi/Documents/Eutrophication%20assessment%20manual.pdf)

2. Secchi Data
--------------

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

3. Data Prep
------------

### 3.1 Read in data

Prelimary filtering to remove duplicate values within datasets (eg profiles) and between datasets.
 - Check of initial smhi and ices datasets for observations from BHI regions 5 & 6 (The Sound) - region 5 all have a coastal designation. ICES data for region 6 includes both coastal and offshore but only 3 data points offshore from 2000- present. SMHI data contains no observations from region 6.

``` r
## read in secchi data
data1 = readr::read_csv(file.path(dir_secchi, 'secchi_data_database/ices_secchi.csv'))
data2 = readr::read_csv(file.path(dir_secchi, 'secchi_data_database/smhi_secchi.csv'))

## Data overview
dim(data1)
```

    ## [1] 215543     13

``` r
colnames(data1)
```

    ##  [1] ""                    "secchi"              "BHI_ID"             
    ##  [4] "Month"               "Year"                "Assessment_unit"    
    ##  [7] "HELCOM_COASTAL_CODE" "HELCOM_ID"           "Date"               
    ## [10] "Latitude"            "Longitude"           "Cruise"             
    ## [13] "Station"

``` r
str(data1)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    215543 obs. of  13 variables:
    ##  $                    : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ secchi             : num  2 3.5 3.5 4.5 4.5 3.1 3.1 1.8 1.8 2.5 ...
    ##  $ BHI_ID             : int  3 3 3 3 3 3 3 3 3 3 ...
    ##  $ Month              : int  6 8 8 12 12 4 4 6 6 8 ...
    ##  $ Year               : int  1972 1972 1972 1972 1972 1973 1973 1973 1973 1973 ...
    ##  $ Assessment_unit    : chr  "DEN-012" "DEN-012" "DEN-012" "DEN-012" ...
    ##  $ HELCOM_COASTAL_CODE: int  38 38 38 38 38 38 38 38 38 38 ...
    ##  $ HELCOM_ID          : chr  "SEA-002" "SEA-002" "SEA-002" "SEA-002" ...
    ##  $ Date               : POSIXct, format: "1972-06-06 12:00:00" "1972-08-01 12:00:00" ...
    ##  $ Latitude           : num  55.9 55.9 55.9 55.9 55.9 ...
    ##  $ Longitude          : num  9.91 9.91 9.91 9.91 9.91 ...
    ##  $ Cruise             : chr  "26ve" "26ve" "26ve" "26ve" ...
    ##  $ Station            : chr  "0008" "0009" "0009" "0010" ...

``` r
dim(data2)
```

    ## [1] 102790     13

``` r
colnames(data2)
```

    ##  [1] ""                          "value"                    
    ##  [3] "BHI_ID"                    "Month"                    
    ##  [5] "Year"                      "unit"                     
    ##  [7] "HELCOM_COASTAL_CODE"       "HELCOM_ID"                
    ##  [9] "Latitude"                  "Date"                     
    ## [11] "Longitude"                 "Provtagningstillfaelle.id"
    ## [13] "Stationsnamn"

``` r
str(data2)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    102790 obs. of  13 variables:
    ##  $                          : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ value                    : num  7 7 7 7 7 7 7 7 0.5 0.5 ...
    ##  $ BHI_ID                   : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Month                    : int  12 12 12 12 12 12 12 12 12 12 ...
    ##  $ Year                     : int  2015 2015 2015 2015 2015 2015 2015 2015 2015 2015 ...
    ##  $ unit                     : chr  "m" "m" "m" "m" ...
    ##  $ HELCOM_COASTAL_CODE      : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ HELCOM_ID                : chr  NA NA NA NA ...
    ##  $ Latitude                 : num  58.9 58.9 58.9 58.9 58.9 ...
    ##  $ Date                     : Date, format: "2015-12-03" "2015-12-03" ...
    ##  $ Longitude                : num  11.1 11.1 11.1 11.1 11.1 ...
    ##  $ Provtagningstillfaelle.id: int  6 6 6 6 6 6 6 6 135 135 ...
    ##  $ Stationsnamn             : chr  "KOSTERFJORDEN (NR16)" "KOSTERFJORDEN (NR16)" "KOSTERFJORDEN (NR16)" "KOSTERFJORDEN (NR16)" ...

``` r
## Initial filtering
ices <- data1 %>% data.frame()%>% filter(!is.na(BHI_ID)) %>%
  select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
         lat= Latitude, lon = Longitude, 
         cruise= Cruise, station = Station, date= Date, coast_code=HELCOM_COASTAL_CODE) %>%
  mutate(date = as.Date(date, format= "%Y-%m-%d"))%>%
  mutate(supplier = 'ices')
head(ices)
```

    ##   bhi_id secchi year month     lat    lon cruise station       date
    ## 1      3    2.0 1972     6 55.8517 9.9083   26ve    0008 1972-06-06
    ## 2      3    3.5 1972     8 55.8517 9.9083   26ve    0009 1972-08-01
    ## 3      3    3.5 1972     8 55.8517 9.9083   26ve    0009 1972-08-01
    ## 4      3    4.5 1972    12 55.8517 9.9083   26ve    0010 1972-12-04
    ## 5      3    4.5 1972    12 55.8517 9.9083   26ve    0010 1972-12-04
    ## 6      3    3.1 1973     4 55.8517 9.9083   26ve    0001 1973-04-12
    ##   coast_code supplier
    ## 1         38     ices
    ## 2         38     ices
    ## 3         38     ices
    ## 4         38     ices
    ## 5         38     ices
    ## 6         38     ices

``` r
smhi <- data2 %>% data.frame()%>%
  filter(!is.na(BHI_ID)) %>%
  rename(secchi = value) %>%
  select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
        lat= Latitude, lon= Longitude, 
         cruise = Provtagningstillfaelle.id, 
         station = Stationsnamn, date= Date, coast_code=HELCOM_COASTAL_CODE) %>%
  mutate(supplier = 'smhi', cruise = as.character(cruise))
head(smhi)
```

    ##   bhi_id secchi year month     lat     lon cruise            station
    ## 1      1      8 2015    11 56.5650 12.7200    311 Laholmsbukten (L9)
    ## 2      1      8 2015    11 56.5650 12.7200    311 Laholmsbukten (L9)
    ## 3      1      8 2015    11 56.5650 12.7200    311 Laholmsbukten (L9)
    ## 4      1      8 2015    11 56.5650 12.7200    311 Laholmsbukten (L9)
    ## 5      1      8 2015    11 56.5650 12.7200    311 Laholmsbukten (L9)
    ## 6      1      7 2015    11 57.6675 11.6867    105          DANAFJORD
    ##         date coast_code supplier
    ## 1 2015-11-26         41     smhi
    ## 2 2015-11-26         41     smhi
    ## 3 2015-11-26         41     smhi
    ## 4 2015-11-26         41     smhi
    ## 5 2015-11-26         41     smhi
    ## 6 2015-11-03         41     smhi

``` r
## Look for duplicate data

## is any data duplicated in ices itself
ices.duplicated = duplicated(ices)
sum(ices.duplicated==TRUE) #180841  ## MANY duplicates 
```

    ## [1] 180841

``` r
ices.duplicated = duplicated(select(ices,-station))
sum(ices.duplicated==TRUE) #180963  ## more duplicated when remove station columns
```

    ## [1] 180963

``` r
    ## it is not because of multiple cruises on same day and location
    ## tried by removing lat and lon and keeping station, fewer duplicates detected

## duplicates because ICES table includes deptp
new_ices = unique(select(ices,-station)); nrow(new_ices)  #take only unique records # 32896
```

    ## [1] 32896

``` r
## is any data duplicated in smhi itself
smhi.duplicated = duplicated(select(smhi, -station))
sum(smhi.duplicated==TRUE) #56938 ## MANY duplicates  ## removing station does not affect it
```

    ## [1] 56938

``` r
new_smhi = unique(select(smhi, -station)); nrow(new_smhi) #take only unique records # 10818
```

    ## [1] 10818

``` r
## use setdiff() to indentify data smhi not in ices
new_smhi = setdiff(select(new_smhi,-supplier,-cruise),select(new_ices,-supplier,-cruise)) %>%
            mutate(supplier = "smhi")
nrow(new_smhi) # 10357
```

    ## [1] 10357

``` r
## it appears 461 records are duplicates (if remove cruise and station)
## if date, lat, lon, secchi all match, I think they are duplicates

## Now create a new allData, bind only the new_smhi object to ices
allData = bind_rows(new_ices,new_smhi)
nrow(allData) # 43253
```

    ## [1] 43253

``` r
allData %>% select(year, month, date, cruise, lat, lon,secchi) %>% distinct() %>%nrow(.)  #43253
```

    ## [1] 43253

``` r
## what if remove cruise
allData %>% select(year, month, date, lat, lon,secchi) %>% distinct() %>%nrow(.)
```

    ## [1] 43253

``` r
# 43253 
```

### 3.2 Remove coastal observations

Select only data with coastal code "0"

``` r
dim(allData) #[1] 43253    10
```

    ## [1] 43253    10

``` r
## Do any observations have NA for coast_code
allData %>% filter(is.na(coast_code))
```

    ## Source: local data frame [3 x 10]
    ## 
    ##   bhi_id secchi  year month     lat     lon cruise       date coast_code
    ##    (int)  (dbl) (int) (int)   (dbl)   (dbl)  (chr)     (date)      (int)
    ## 1     37    3.5  2011     8 63.2823 19.1348     NA 2011-08-01         NA
    ## 2     41    1.4  2011     7 65.6695 22.3087     NA 2011-07-26         NA
    ## 3     37    1.5  2001     9 62.1893 17.5318     NA 2001-09-04         NA
    ## Variables not shown: supplier (chr)

``` r
  ## three observations with NA for the coast_code
  ## manually checked with google earth, these are all clearly coastal stations. but would be better to fix this assignment in the database

## What are coastal codes for The Sound (BHI regions 5,6)
##Region 6
allData %>% filter(bhi_id %in% 6) %>% select(bhi_id,year,date,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)
```

    ## Source: local data frame [24 x 7]
    ## 
    ##    bhi_id  year       date     lat     lon coast_code supplier
    ##     (int) (int)     (date)   (dbl)   (dbl)      (int)    (chr)
    ## 1       6  2007 2007-04-23 55.8517 12.6683          0     ices
    ## 2       6  2002 2002-02-14 55.8517 12.6683          0     ices
    ## 3       6  2002 2002-05-21 55.8083 12.7152          0     ices
    ## 4       6  1999 1999-01-19 56.1270 12.5170         39     ices
    ## 5       6  1998 1998-03-16 55.7002 12.6860         40     ices
    ## 6       6  1998 1998-03-30 55.7002 12.6860         40     ices
    ## 7       6  1998 1998-04-27 55.7002 12.6860         40     ices
    ## 8       6  1998 1998-05-18 55.8490 12.6795          0     ices
    ## 9       6  1998 1998-12-08 55.7000 12.7500         40     ices
    ## 10      6  1998 1998-03-19 55.6200 12.8700          0     ices
    ## ..    ...   ...        ...     ...     ...        ...      ...

``` r
    ## three observations in BHI region 6 after 2000
    ## Not summer observations
allData %>% filter(bhi_id %in% 6) %>% select(coast_code, supplier)%>%distinct(.)
```

    ## Source: local data frame [3 x 2]
    ## 
    ##   coast_code supplier
    ##        (int)    (chr)
    ## 1         40     ices
    ## 2          0     ices
    ## 3         39     ices

``` r
#Region 5
allData %>% filter(bhi_id %in% 5) %>% select(bhi_id,year,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)
```

    ## Source: local data frame [430 x 6]
    ## 
    ##    bhi_id  year     lat     lon coast_code supplier
    ##     (int) (int)   (dbl)   (dbl)      (int)    (chr)
    ## 1       5  2015 55.8667 12.7500         39     smhi
    ## 2       5  2014 55.8670 12.7500         39     ices
    ## 3       5  2014 56.2167 12.5167         39     smhi
    ## 4       5  2014 55.7850 12.9067         39     smhi
    ## 5       5  2014 55.6508 13.0350         39     smhi
    ## 6       5  2014 55.6867 13.0367         39     smhi
    ## 7       5  2014 55.8667 12.7500         39     smhi
    ## 8       5  2013 55.8670 12.7500         39     ices
    ## 9       5  2013 55.8667 12.7500         39     smhi
    ## 10      5  2012 55.8670 12.7500         39     ices
    ## ..    ...   ...     ...     ...        ...      ...

``` r
allData %>% filter(bhi_id %in% 5) %>% select(coast_code, supplier)%>%distinct(.)
```

    ## Source: local data frame [2 x 2]
    ## 
    ##   coast_code supplier
    ##        (int)    (chr)
    ## 1         39     ices
    ## 2         39     smhi

``` r
    ## All region 5 codes are coastal

## Filter data that are only offshore, coast_code == 0
allData = allData %>% filter(coast_code==0)

dim(allData)#14018    10 
```

    ## [1] 14018    10

``` r
## This is a substantial reduction in the number of observations
```

### 3.3 Target values

These are the values that will be used as a reference point.

``` r
target <- readr::read_csv(file.path(dir_secchi, "eutro_targets_HELCOM.csv"))
head(target)
```

    ## Source: local data frame [6 x 6]
    ## 
    ##                basin winter_din winter_dip summer_chl summer_secchi
    ##                (chr)      (dbl)      (dbl)      (dbl)         (dbl)
    ## 1           Kattegat        5.0       0.49        1.5           7.6
    ## 2          The_Sound        3.3       0.42        1.2           8.2
    ## 3         Great_Belt        5.0       0.59        1.7           8.5
    ## 4        Little_Belt        7.1       0.71        2.8           7.3
    ## 5           Kiel_Bay        5.5       0.57        2.0           7.4
    ## 6 Bay_of_Mecklenburg        4.3       0.49        1.8           7.1
    ## Variables not shown: oxy_debt (dbl)

``` r
#select just summer_seccchi target
target = target %>% select(basin, summer_secchi)%>%
        mutate(basin = str_replace_all(basin,"_"," "))
```

### 3.4 HELCOM HOLAS Basin

These basins are the relevant physical units.
Secchi data will be first assessed at this level and then assigned to BHI region. EEZ divisions may result in some BHI regions that have no data but they are physically the same basin as a BHI region with data.

``` r
basin_lookup = readr::read_csv(file.path(
  dir_secchi,"baltic_rgns_to_bhi_rgns_lookup_holas.csv"))
basin_lookup=basin_lookup %>% select(bhi_id = rgn_id, basin_name)%>%
  mutate(basin_name = str_replace_all(basin_name,"_"," "))
```

### 3.5 Select summer data and plot

    - Months 6-9 (June, July, August, September)  
    - Years >= 2000  
    - Data is sparse for BHI regions 4,22,25  
    - No data BHI regions 5 (all coastal), 6 (offshore observations rare after from 2000 and not in summer).  

``` r
summer = allData %>% filter(month %in%c(6:9)) %>%
        filter(year >=2000)
head(summer)
```

    ## Source: local data frame [6 x 10]
    ## 
    ##   bhi_id secchi  year month     lat     lon cruise       date coast_code
    ##    (int)  (dbl) (int) (int)   (dbl)   (dbl)  (chr)     (date)      (int)
    ## 1      1    8.0  2000     8 56.2300 12.3700   26GT 2000-08-07          0
    ## 2      2    7.0  2000     8 56.5583 11.0300   26GT 2000-08-08          0
    ## 3      2    6.3  2000     8 56.8567 10.7917   26GT 2000-08-08          0
    ## 4      2   10.2  2000     8 57.3000 10.7450   26GT 2000-08-08          0
    ## 5      2   13.2  2000     8 57.4300 10.7083   26GT 2000-08-08          0
    ## 6      2   13.0  2000     8 57.4650 10.9000   26GT 2000-08-08          0
    ## Variables not shown: supplier (chr)

``` r
#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~bhi_id, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/select%20summer%20data-1.png)<!-- -->

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~bhi_id)
```

![](secchi_prep_files/figure-markdown_github/select%20summer%20data-2.png)<!-- -->

### 3.6 Assign secchi data to a HOLAS basin

    - Data coverage appears better at the basin scale.  
    - With coastal data excluded, there are **no data points observed in the The Sound**  
    - Some basins have missing data or limited data for the most recent years: Aland Sea, Great Belt, Gulf of Riga, Kiel Bay, The Quark  

``` r
summer = summer %>% full_join(., basin_lookup, by="bhi_id")

#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~basin_name)
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-1.png)<!-- -->

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name)
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-2.png)<!-- -->

### 3.7 Restrict data to before 2014

    - The Sound does not appear in the plot - No Data
    - There are still basins with limited or not data from 2010 onwards (*Great Belt*) but this at least removes the potential for not having data reported in the past 2 years

``` r
summer = summer %>% filter(year < 2014)

#Plot
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/restrict%20data%20before%202014-1.png)<!-- -->

### 3.8 Evaluate number of stations sampled in each basin

Very different number of unique lat-lon locations by month and basin.
Sometimes lat-lon is not good to use because recording specific ship location which might be vary even though ship is at the same station. More duplicates were detected in the data however when station was not included, than when lat and lon were not included as the location identifier.

``` r
basin_summary = summer %>% group_by(basin_name,year,month)%>%
                select(year, month,lat,lon,basin_name)%>%
                summarise(loc_count = n_distinct(lat,lon))
basin_summary
```

    ## Source: local data frame [631 x 4]
    ## Groups: basin_name, year [?]
    ## 
    ##    basin_name  year month loc_count
    ##         (chr) (int) (int)     (int)
    ## 1   Aland Sea  2000     6         1
    ## 2   Aland Sea  2001     6         1
    ## 3   Aland Sea  2002     6         1
    ## 4   Aland Sea  2003     6         1
    ## 5   Aland Sea  2003     8         1
    ## 6   Aland Sea  2004     6         1
    ## 7   Aland Sea  2004     8         1
    ## 8   Aland Sea  2005     6         2
    ## 9   Aland Sea  2005     8         1
    ## 10  Aland Sea  2006     7         1
    ## ..        ...   ...   ...       ...

``` r
#plot sampling overview
ggplot(basin_summary) + geom_point(aes(year,loc_count, colour=factor(month)))+
  facet_wrap(~basin_name, scales ="free_y")+
  ylab("Number Sampling Locations")
```

![](secchi_prep_files/figure-markdown_github/samples%20and%20stations%20by%20basin-1.png)<!-- -->

### 3.9 Mean secchi Calculation

### 3.9.1 Calculate mean monthly value for each summer month

basin monthly mean = mean of all samples within month and basin

``` r
mean_months = summer %>% select(year, month,basin_name,secchi)%>%
              group_by(year,month,basin_name)%>%
              summarise(mean_secchi = round(mean(secchi,na.rm=TRUE),1))%>%
              ungroup()
head(mean_months)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##    year month            basin_name mean_secchi
    ##   (int) (int)                 (chr)       (dbl)
    ## 1  2000     6             Aland Sea         5.5
    ## 2  2000     6          Arkona Basin         7.8
    ## 3  2000     6        Bornholm Basin         6.8
    ## 4  2000     6          Bothnian Bay         5.4
    ## 5  2000     6          Bothnian Sea         5.3
    ## 6  2000     6 Eastern Gotland Basin         7.9

### 3.9.2 Plot mean monthly value by basin

    - Limited July sampling in a number of basins 
    - The Quark only sampled in June in early part of time series, August later half of time series.  

``` r
#Plot
ggplot(mean_months) + geom_point(aes(year,mean_secchi, colour=factor(month)))+
  geom_line(aes(year,mean_secchi, colour=factor(month)))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10))
```

    ## Warning: Removed 9 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/plot%20mean%20monthly-1.png)<!-- -->

### 3.9.3 Calculate summer mean secchi (basin)

basin summer mean = mean of basin monthly mean values

``` r
mean_months_summer = mean_months %>% select(year, basin_name,mean_secchi) %>%
                      group_by(year,basin_name)%>%
                      summarise(mean_secchi = round(mean(mean_secchi,na.rm=TRUE),1)) %>%
                      ungroup()  #in mean calculation all some months to have NA, ignore for that years calculation
```

### 3.9.4 Plot summer mean secchi

``` r
ggplot(mean_months_summer) + geom_point(aes(year,mean_secchi))+
  geom_line(aes(year,mean_secchi))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10))
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/plot%20mean%20summer%20secchi-1.png)<!-- -->

### 3.9.5 Plot summer secchi with target values indicated

Horizontal lines are HELCOM target values.

``` r
secchi_target = left_join(mean_months_summer,target, by=c("basin_name" = "basin"))%>%
                dplyr::rename(target_secchi = summer_secchi)
head(secchi_target)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##    year         basin_name mean_secchi target_secchi
    ##   (int)              (chr)       (dbl)         (dbl)
    ## 1  2000          Aland Sea         5.5           6.9
    ## 2  2000       Arkona Basin         8.0           7.2
    ## 3  2000 Bay of Mecklenburg         6.7           7.1
    ## 4  2000     Bornholm Basin         7.0           7.1
    ## 5  2000       Bothnian Bay         2.5           5.8
    ## 6  2000       Bothnian Sea         2.8           6.8

``` r
ggplot(secchi_target) + geom_point(aes(year,mean_secchi))+
  geom_line(aes(year,target_secchi))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10))
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/summer%20secchi%20with%20target-1.png)<!-- -->

4. Status and Trend exploration
-------------------------------

### 4.1 Goal Model & Trend

**The Goal Model is how the status is calculated**
Xnut\_b = mean\_summer\_secchi\_y\_b / Reference point\_r

mean\_summer\_secchi\_y = mean summer secchi in year (y) in a basin (b) Reference point = HELCOM target for that basin

Xnut\_bhi\_region = Xnut\_b
*Each BHI region will receive the status value of the HOLAS basin it belongs to*

**Trend** The trend is calculated based on a linear regression.
Status\_b ~ m\*Year + intercept
In our approach here, we use a 10 year period to calculate the trend with a minimum of 5 data points. In most cases, the BHI framework uses a 5 year period for the trend, but as secchi is a slow response variable, we use a longer time period.
The trend value is the slope (m) of the linear regression multiplied by the year of future interest (5 years from status year) and this value is constrained to between -1 and 1.

### 4.2 What year will the status be calculated for for each basin?

    - This is if there is no temporal gapfilling.  
    - Most basins can have the status calculated for **2013** with the **exception** of: *Aland Sea (2012)*, *Great Belt (2011)*, *Gulf of Finland (2012), *Gulf of Riga (2012)*, *The Quark (2012)*  
    - No data for the Sound  
    - One option is no gap filling and calculating the status for differenet final years and over a different 5 year period

``` r
## get the last year of non-NA data
last_year = secchi_target%>%
            filter(!is.na(mean_secchi))%>%
            group_by(basin_name)%>%
            summarise(last_year = last(year)) %>%
            print(n=15)
```

    ## Source: local data frame [16 x 2]
    ## 
    ##                basin_name last_year
    ##                     (chr)     (int)
    ## 1               Aland Sea      2012
    ## 2            Arkona Basin      2013
    ## 3      Bay of Mecklenburg      2013
    ## 4          Bornholm Basin      2013
    ## 5            Bothnian Bay      2013
    ## 6            Bothnian Sea      2013
    ## 7   Eastern Gotland Basin      2013
    ## 8            Gdansk Basin      2013
    ## 9              Great Belt      2009
    ## 10        Gulf of Finland      2012
    ## 11           Gulf of Riga      2012
    ## 12               Kattegat      2013
    ## 13               Kiel Bay      2013
    ## 14 Northern Baltic Proper      2013
    ## 15              The Quark      2012
    ## ..                    ...       ...

``` r
##which are not in 2013
last_year %>% filter(last_year < 2013)
```

    ## Source: local data frame [5 x 2]
    ## 
    ##        basin_name last_year
    ##             (chr)     (int)
    ## 1       Aland Sea      2012
    ## 2      Great Belt      2009
    ## 3 Gulf of Finland      2012
    ## 4    Gulf of Riga      2012
    ## 5       The Quark      2012

### 4.3 Calculate status

**Status calculation with raw (non-modeled) mean summer secchi by basin**
Status must be calculated in data prep because calculation for a basin and then applied to all regions.
*Status code based on code Lena Viktorsson developed for functions.r*

``` r
## Define constants for status calculation

  min_year = 2000        # earliest year to use as a start for regr_length timeseries
                          ##data already filtered for 
  regr_length = 10       # number of years to use for regression
  future_year = 5        # the year at which we want the likely future status
  min_regr_length = 5    # min actual number of years with data to use for regression.

  
## Basin data with target
  secchi_target
```

    ## Source: local data frame [214 x 4]
    ## 
    ##     year            basin_name mean_secchi target_secchi
    ##    (int)                 (chr)       (dbl)         (dbl)
    ## 1   2000             Aland Sea         5.5           6.9
    ## 2   2000          Arkona Basin         8.0           7.2
    ## 3   2000    Bay of Mecklenburg         6.7           7.1
    ## 4   2000        Bornholm Basin         7.0           7.1
    ## 5   2000          Bothnian Bay         2.5           5.8
    ## 6   2000          Bothnian Sea         2.8           6.8
    ## 7   2000 Eastern Gotland Basin         6.6           7.6
    ## 8   2000          Gdansk Basin         6.7           6.5
    ## 9   2000            Great Belt         6.9           8.5
    ## 10  2000       Gulf of Finland         4.8           5.5
    ## ..   ...                   ...         ...           ...

``` r
## Calculate basin status
  ## Xnut = basin_mean/basin_target
  
  basin_status = secchi_target %>%
                 mutate(., status =  pmin(1, mean_secchi/target_secchi)) %>%
      select(basin_name, year, status)
  
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

  
  ## Assign basin status and trend to BHI regions
    bhi_status = basin_status %>%
                group_by(basin_name)%>%
                summarise_each(funs(last), basin_name, status)%>% #select last year of data for status in each basin (this means status year differs by basin)
                mutate(status = round(status*100))%>% #status is whole number 0-100
                ungroup()%>%
                left_join(basin_lookup,.,by="basin_name")%>% #join bhi regions to basins
                mutate(dimension = 'status') %>%
                select (rgn_id = bhi_id, dimension, score=status)
                
  
    bhi_trend = left_join(basin_lookup,basin_trend, by="basin_name") %>%
                 mutate(score = round(trend_score,2),
                        dimension = "trend")%>%
                select(rgn_id = bhi_id, dimension, score )
```

### 4.4 Plot Basin status over time

Basin status is initially a value between 0 - 1. Calculated for each year between 2000 and 2013.

``` r
ggplot(basin_status) + geom_point((aes(year,status)))+
  facet_wrap(~basin_name) +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))
```

![](secchi_prep_files/figure-markdown_github/plot%20basin%20status-1.png)<!-- -->

### 4.5 Plot BHI region status and trend values

    - Status values can range from 0-100 -- this is the status for the *most recent* year. In most cases this is 2013.  
    - Trend values can be between -1 to 1
    - No status or trend for 5 or 6 - these are The Sound

``` r
ggplot(full_join(bhi_status,bhi_trend, by=c("rgn_id","dimension","score"))) + geom_point(aes(rgn_id,score),size=2)+
  facet_wrap(~dimension, scales="free_y")+
  xlab("BHI region")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/bhi%20status%20and%20trend%20plot-1.png)<!-- -->

### 4.6 Save csv files

These csv files will be used as a first cut for the secchi status and trend. **Files to save**
1. Status and trend for each BHI region based on the basin level calculations

``` r
## Write csv files to layers
    readr::write_csv(bhi_status, 
                 file.path(dir_layers, "cw_nu_status_bhi2015.csv"))
    
    readr::write_csv(bhi_trend, 
                 file.path(dir_layers, "cw_nu_trend_bhi2015.csv"))
```

5. Next steps
-------------

**Trend calculation**
1. Have calculated the trend using data spanning 10 years (minimum of 5 data points). Is it agreed that we should use the longer time window for the trend?

**No Observations for The Sound**
1. The Sound has no summer offshore observations after 2000 in either ICES or SMHI data.
 - How is it evaluated by HOLAS?
 - BHI regions are 5 & 6. 5 is all coastal, 6 has both coastal and offshore observations before 2000 and from 2000 forward, 3 offshore observations in spring (not summer).

**Should/How to model the data?**
Not all months are sampled in all years (see above plot).
If model, do a linear model.
*Linear model options* 1. Take mean summer secchi, ignore that different months sampled in different years, just average the months that are sampled in any given year. Model by basin and year.
2. Take mean monthly value by year, model by basin + year + month. Average the modelled monthly value to get a summer mean.
3. Do the above but just model all the data points, don't take the mean value and instead use a random effect to account for location?
