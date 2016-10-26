secchi\_prep
================

-   [Nutrient subgoal data layer prep - Secchi data](#nutrient-subgoal-data-layer-prep---secchi-data)
    -   [1. Background on using Secchi](#background-on-using-secchi)
    -   [2. Secchi Data](#secchi-data)
        -   [2.1 Data sources](#data-sources)
        -   [2.2 Data Cleaning and decision-making](#data-cleaning-and-decision-making)
    -   [3. Data Prep](#data-prep)
        -   [3.1 Read in data](#read-in-data)
        -   [3.2 Remove coastal observations](#remove-coastal-observations)
        -   [3.3 Target values](#target-values)
        -   [3.4 HELCOM HOLAS Basin](#helcom-holas-basin)
        -   [3.5 dplyr::select summer data and plot](#dplyrselect-summer-data-and-plot)
        -   [3.6 Assign secchi data to a HOLAS basin](#assign-secchi-data-to-a-holas-basin)
        -   [3.7 Restrict data to before 2014](#restrict-data-to-before-2014)
        -   [3.8 Evaluate number of stations sampled in each basin](#evaluate-number-of-stations-sampled-in-each-basin)
        -   [3.9 Mean secchi Calculation](#mean-secchi-calculation)
        -   [3.9.1 Calculate mean monthly value for each summer month](#calculate-mean-monthly-value-for-each-summer-month)
        -   [3.9.2 Plot mean monthly value by basin](#plot-mean-monthly-value-by-basin)
        -   [3.9.3 Calculate summer mean secchi (basin)](#calculate-summer-mean-secchi-basin)
        -   [3.9.4 Plot summer mean secchi](#plot-summer-mean-secchi)
        -   [3.9.5 Plot summer secchi with target values indicated](#plot-summer-secchi-with-target-values-indicated)
    -   [4. Status and Trend explostatusn](#status-and-trend-explostatusn)
        -   [4.1 Goal Model & Trend](#goal-model-trend)
        -   [4.2 What year will the status be calculated for for each basin?](#what-year-will-the-status-be-calculated-for-for-each-basin)
        -   [4.3 Calculate status](#calculate-status)
        -   [4.4 Plot Basin status over time](#plot-basin-status-over-time)
        -   [4.5 Plot BHI region status and trend values](#plot-bhi-region-status-and-trend-values)
        -   [4.6 Save csv files](#save-csv-files)
    -   [5. Next steps](#next-steps)
-   [6. Rescale Mean secchi data and recalculate status](#rescale-mean-secchi-data-and-recalculate-status)
-   [7. Trial: add Anoxia data to Nutrient calculations (NUT)](#trial-add-anoxia-data-to-nutrient-calculations-nut)

Nutrient subgoal data layer prep - Secchi data
==============================================

``` r
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

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

[EUTRO-OPER](http://helcom.fi/helcom-at-work/projects/eutro-oper/) Making HELCOM Eutrophication Assessments opestatusnal. Check here for HELCOM status calculations and assessment. Included on this page is a link to the [Eutrophication Assessment Manual](http://helcom.fi/Documents/Eutrophication%20assessment%20manual.pdf)

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

Some data points do not have a BHI ID assigned. Appears that almost all have a coastal code that != 0. If they are very close to the coast - they may fall outside the BHI shapefile. Because we exclude all sites that are coastal - only one site will have to have BHI added manually.

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
ices <- data1 %>% data.frame()%>%
  dplyr::select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
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
##which ices data have BHI_ID of NA
ices.na <- ices %>%
           filter(is.na(bhi_id))
  
    dim(ices.na) # 1684   11
```

    ## [1] 1684   11

``` r
    ices.na.loc = ices.na %>% dplyr::select(lat,lon) %>% distinct() ## unique locations
    dim(ices.na.loc) # 86  2
```

    ## [1] 86  2

``` r
    ices.na %>% dplyr::select(coast_code)%>% distinct()  ## at least one location is off shore
```

    ##    coast_code
    ## 1          42
    ## 2          38
    ## 3          14
    ## 4           9
    ## 5          13
    ## 6           5
    ## 7          37
    ## 8          34
    ## 9          17
    ## 10          0
    ## 11         20
    ## 12          6

``` r
    ices.na %>% filter(coast_code==0)
```

    ##   bhi_id secchi year month     lat     lon cruise station       date
    ## 1     NA    2.5 2002     8 57.8562 24.3058   LAAN    0183 2002-08-07
    ## 2     NA    2.5 2002     8 57.8562 24.3058   LAAN    0183 2002-08-07
    ##   coast_code supplier
    ## 1          0     ices
    ## 2          0     ices

``` r
    ## will need to manally add BHI id for site with NA and coastal code of 0



smhi <- data2 %>% data.frame()%>%
  rename(secchi = value) %>%
  dplyr::select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
        lat= Latitude, lon= Longitude, 
         cruise = Provtagningstillfaelle.id, 
         station = Stationsnamn, date= Date, coast_code=HELCOM_COASTAL_CODE) %>%
  mutate(supplier = 'smhi', cruise = as.character(cruise))
head(smhi)
```

    ##   bhi_id secchi year month     lat     lon cruise              station
    ## 1     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ## 2     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ## 3     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ## 4     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ## 5     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ## 6     NA      7 2015    12 58.8683 11.1033      6 KOSTERFJORDEN (NR16)
    ##         date coast_code supplier
    ## 1 2015-12-03         NA     smhi
    ## 2 2015-12-03         NA     smhi
    ## 3 2015-12-03         NA     smhi
    ## 4 2015-12-03         NA     smhi
    ## 5 2015-12-03         NA     smhi
    ## 6 2015-12-03         NA     smhi

``` r
## is na smhi
smhi.na <- smhi %>%
           filter(is.na(bhi_id))
  
    dim(smhi.na) # 35034    11
```

    ## [1] 35034    11

``` r
    smhi.na.loc = smhi.na %>% dplyr::select(lat,lon) %>% distinct() ## unique locations
    dim(smhi.na.loc) #615   2
```

    ## [1] 615   2

``` r
    smhi.na %>% dplyr::select(coast_code)%>% distinct()  ## none are offshore
```

    ##    coast_code
    ## 1          NA
    ## 2          18
    ## 3          27
    ## 4          41
    ## 5           8
    ## 6           6
    ## 7          11
    ## 8           4
    ## 9           2
    ## 10         22

``` r
    smhi.na %>% filter(coast_code==0)
```

    ##  [1] bhi_id     secchi     year       month      lat        lon       
    ##  [7] cruise     station    date       coast_code supplier  
    ## <0 rows> (or 0-length row.names)

``` r
    ## no coastal code of zero




## Look for duplicate data

## is any data duplicated in ices itself
ices.duplicated = duplicated(ices)
sum(ices.duplicated==TRUE) #181855  ## MANY duplicates 
```

    ## [1] 181855

``` r
ices.duplicated = duplicated(dplyr::select(ices,-station))
sum(ices.duplicated==TRUE) #181977 ## more duplicated when remove station columns
```

    ## [1] 181977

``` r
    ## it is not because of multiple cruises on same day and location
    ## tried by removing lat and lon and keeping station, fewer duplicates detected

## duplicates because ICES table includes deptp
new_ices = unique(dplyr::select(ices,-station)); nrow(new_ices)  #take only unique records # 33566
```

    ## [1] 33566

``` r
## is any data duplicated in smhi itself
smhi.duplicated = duplicated(dplyr::select(smhi, -station))
sum(smhi.duplicated==TRUE) #85691 ## MANY duplicates  ## removing station does not affect it
```

    ## [1] 85691

``` r
new_smhi = unique(dplyr::select(smhi, -station)); nrow(new_smhi) #take only unique records # 17099
```

    ## [1] 17099

``` r
## use setdiff() to indentify data smhi not in ices
new_smhi = setdiff(dplyr::select(new_smhi,-supplier,-cruise), dplyr::select(new_ices,-supplier,-cruise)) %>%
            mutate(supplier = "smhi")
nrow(new_smhi) #  16627
```

    ## [1] 16627

``` r
## it appears 461 records are duplicates (if remove cruise and station)
## if date, lat, lon, secchi all match, I think they are duplicates

## Now create a new allData, bind only the new_smhi object to ices
allData = bind_rows(new_ices,new_smhi)
nrow(allData) # 50193
```

    ## [1] 50193

``` r
allData %>% dplyr::select(year, month, date, cruise, lat, lon,secchi) %>% distinct() %>%nrow(.)  #50193
```

    ## [1] 50193

``` r
## what if remove cruise
allData %>% dplyr::select(year, month, date, lat, lon,secchi) %>% distinct() %>%nrow(.)
```

    ## [1] 50193

``` r
# 50193
```

### 3.2 Remove coastal observations

Select only data with coastal code "0"

``` r
dim(allData) #[1]  50193    10
```

    ## [1] 50193    10

``` r
## Do any observations have NA for coast_code
allData %>% filter(is.na(coast_code) & is.na(bhi_id)) %>% dim() # 3567   10
```

    ## [1] 3567   10

``` r
allData %>% filter(is.na(coast_code) & !is.na(bhi_id)) %>% dim() #  3 10
```

    ## [1]  3 10

``` r
  ## 3567 observations with no coast_code or BHI_ID, all from SMHI, are 292 distinct locations
      loc_no_coastcode_nobhi =allData %>% 
                                filter(is.na(coast_code) & is.na(bhi_id))%>%
                                dplyr::select(lat,lon)%>%
                                  distinct()
     
        ## check locations
         library('ggmap')
        map = get_map(location = c(8.5, 53, 32, 67.5))
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false

``` r
         plot_map1 = ggmap(map) +
          geom_point(aes(x=lon, y=lat), data=loc_no_coastcode_nobhi,size = 2.5)
      
          plot_map1
```

![](secchi_prep_files/figure-markdown_github/remove%20coastal%20data%20points-1.png)

``` r
      ## these locations are very coastal or outside of the Baltic Sea
    
  ##3 observations with NA for the coast_code but have BHI_ID
     loc_no_coastcode_bhi =  allData %>% 
                              filter(is.na(coast_code) & !is.na(bhi_id)) %>% 
                              dplyr::select(lat,lon)%>%
                              distinct()
      
     plot_map2 = ggmap(map) +
      geom_point(aes(x=lon, y=lat), data=loc_no_coastcode_bhi,size = 2.5)
      
      plot_map2
```

![](secchi_prep_files/figure-markdown_github/remove%20coastal%20data%20points-2.png)

``` r
      ## these are clearly coastal stations
  
      
## What are coastal codes for The Sound (BHI regions 5,6)
##Region 6
allData %>% filter(bhi_id %in% 6) %>% dplyr::select(bhi_id,year,date,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)
```

    ##    bhi_id year       date     lat     lon coast_code supplier
    ## 1       6 2007 2007-04-23 55.8517 12.6683          0     ices
    ## 2       6 2002 2002-02-14 55.8517 12.6683          0     ices
    ## 3       6 2002 2002-05-21 55.8083 12.7152          0     ices
    ## 4       6 1999 1999-01-19 56.1270 12.5170         39     ices
    ## 5       6 1998 1998-03-16 55.7002 12.6860         40     ices
    ## 6       6 1998 1998-03-30 55.7002 12.6860         40     ices
    ## 7       6 1998 1998-04-27 55.7002 12.6860         40     ices
    ## 8       6 1998 1998-05-18 55.8490 12.6795          0     ices
    ## 9       6 1998 1998-12-08 55.7000 12.7500         40     ices
    ## 10      6 1998 1998-03-19 55.6200 12.8700          0     ices
    ## 11      6 1998 1998-07-21 55.6200 12.8700          0     ices
    ## 12      6 1992 1992-08-31 56.1300 12.5100         39     ices
    ## 13      6 1991 1991-02-26 56.1280 12.5200         39     ices
    ## 14      6 1991 1991-06-16 56.1300 12.5120         39     ices
    ## 15      6 1990 1990-04-19 56.1300 12.5100         39     ices
    ## 16      6 1990 1990-09-25 56.1300 12.5100         39     ices
    ## 17      6 1988 1988-06-01 55.9000 12.6370          0     ices
    ## 18      6 1988 1988-06-02 55.9000 12.6370          0     ices
    ## 19      6 1988 1988-06-02 55.9130 12.6370          0     ices
    ## 20      6 1988 1988-06-02 55.7850 12.7130          0     ices
    ## 21      6 1988 1988-06-03 55.7850 12.7130          0     ices
    ## 22      6 1988 1988-06-06 55.7850 12.7130          0     ices
    ## 23      6 1988 1988-06-07 55.7850 12.7130          0     ices
    ## 24      6 1988 1988-06-07 55.9130 12.6370          0     ices

``` r
    ## three observations in BHI region 6 after 2000
    ## Not summer observations
allData %>% filter(bhi_id %in% 6) %>% dplyr::select(coast_code, supplier)%>%distinct(.)
```

    ##   coast_code supplier
    ## 1         40     ices
    ## 2          0     ices
    ## 3         39     ices

``` r
#Region 5
allData %>% filter(bhi_id %in% 5) %>% dplyr::select(bhi_id,year,lat, lon,coast_code, supplier)%>% arrange(desc(year))%>%distinct(.)
```

    ##     bhi_id year     lat     lon coast_code supplier
    ## 1        5 2015 55.8667 12.7500         39     smhi
    ## 2        5 2014 55.8670 12.7500         39     ices
    ## 3        5 2014 56.2167 12.5167         39     smhi
    ## 4        5 2014 55.7850 12.9067         39     smhi
    ## 5        5 2014 55.6508 13.0350         39     smhi
    ## 6        5 2014 55.6867 13.0367         39     smhi
    ## 7        5 2014 55.8667 12.7500         39     smhi
    ## 8        5 2013 55.8670 12.7500         39     ices
    ## 9        5 2013 55.8667 12.7500         39     smhi
    ## 10       5 2012 55.8670 12.7500         39     ices
    ## 11       5 2012 55.7850 12.9067         39     smhi
    ## 12       5 2012 55.6508 13.0350         39     smhi
    ## 13       5 2012 55.6867 13.0367         39     smhi
    ## 14       5 2012 56.2167 12.5167         39     smhi
    ## 15       5 2012 55.8667 12.7500         39     smhi
    ## 16       5 2011 55.8670 12.7500         39     ices
    ## 17       5 2011 55.7850 12.9067         39     smhi
    ## 18       5 2011 55.6508 13.0350         39     smhi
    ## 19       5 2011 55.6867 13.0367         39     smhi
    ## 20       5 2011 56.2167 12.5167         39     smhi
    ## 21       5 2011 55.8667 12.7500         39     smhi
    ## 22       5 2010 55.8700 12.7500         39     ices
    ## 23       5 2010 55.8670 12.7500         39     ices
    ## 24       5 2010 55.7850 12.9067         39     smhi
    ## 25       5 2010 55.6508 13.0350         39     smhi
    ## 26       5 2010 55.6867 13.0367         39     smhi
    ## 27       5 2010 56.2167 12.5167         39     smhi
    ## 28       5 2010 55.8667 12.7500         39     smhi
    ## 29       5 2009 55.8700 12.7500         39     ices
    ## 30       5 2009 55.8670 12.7500         39     ices
    ## 31       5 2009 55.7850 12.9067         39     smhi
    ## 32       5 2009 55.6508 13.0350         39     smhi
    ## 33       5 2009 55.6867 13.0367         39     smhi
    ## 34       5 2009 55.8667 12.7500         39     smhi
    ## 35       5 2009 56.2167 12.5167         39     smhi
    ## 36       5 2008 55.8700 12.7500         39     ices
    ## 37       5 2008 55.8670 12.7500         39     ices
    ## 38       5 2008 56.2167 12.5167         39     smhi
    ## 39       5 2008 55.7850 12.9067         39     smhi
    ## 40       5 2008 55.6508 13.0350         39     smhi
    ## 41       5 2008 55.6867 13.0367         39     smhi
    ## 42       5 2008 55.8667 12.7500         39     smhi
    ## 43       5 2007 55.8700 12.7500         39     ices
    ## 44       5 2007 55.8670 12.7500         39     ices
    ## 45       5 2007 55.8667 12.7500         39     smhi
    ## 46       5 2007 56.2167 12.5167         39     smhi
    ## 47       5 2007 55.7850 12.9067         39     smhi
    ## 48       5 2007 55.6508 13.0350         39     smhi
    ## 49       5 2007 55.6867 13.0367         39     smhi
    ## 50       5 2006 55.8700 12.7500         39     ices
    ## 51       5 2006 55.8652 12.7485         39     ices
    ## 52       5 2006 55.8663 12.7488         39     ices
    ## 53       5 2006 55.8673 12.7497         39     ices
    ## 54       5 2006 55.8658 12.7490         39     ices
    ## 55       5 2006 55.8670 12.7478         39     ices
    ## 56       5 2006 55.8640 12.7487         39     ices
    ## 57       5 2006 55.8612 12.7490         39     ices
    ## 58       5 2006 55.8608 12.7502         39     ices
    ## 59       5 2006 55.8660 12.7477         39     ices
    ## 60       5 2006 55.8615 12.7493         39     ices
    ## 61       5 2006 55.8618 12.7493         39     ices
    ## 62       5 2006 55.8645 12.7483         39     ices
    ## 63       5 2006 55.8602 12.7502         39     ices
    ## 64       5 2006 55.8620 12.7500         39     ices
    ## 65       5 2006 55.8615 12.7507         39     ices
    ## 66       5 2006 55.8615 12.7495         39     ices
    ## 67       5 2006 55.8617 12.7483         39     ices
    ## 68       5 2006 55.8622 12.7490         39     ices
    ## 69       5 2006 55.8612 12.7502         39     ices
    ## 70       5 2006 55.8612 12.7505         39     ices
    ## 71       5 2006 55.8608 12.7507         39     ices
    ## 72       5 2006 55.8600 12.7497         39     ices
    ## 73       5 2006 55.8623 12.7495         39     ices
    ## 74       5 2006 55.8613 12.7498         39     ices
    ## 75       5 2006 55.8613 12.7495         39     ices
    ## 76       5 2006 55.8608 12.7505         39     ices
    ## 77       5 2006 55.8615 12.7498         39     ices
    ## 78       5 2006 55.8670 12.7500         39     ices
    ## 79       5 2006 56.2167 12.5167         39     smhi
    ## 80       5 2006 55.7850 12.9067         39     smhi
    ## 81       5 2006 55.6508 13.0350         39     smhi
    ## 82       5 2006 55.6867 13.0367         39     smhi
    ## 83       5 2006 55.8667 12.7500         39     smhi
    ## 84       5 2005 55.8700 12.7500         39     ices
    ## 85       5 2005 55.8668 12.7493         39     ices
    ## 86       5 2005 55.8700 12.7482         39     ices
    ## 87       5 2005 55.8660 12.7483         39     ices
    ## 88       5 2005 55.8665 12.7482         39     ices
    ## 89       5 2005 55.8663 12.7482         39     ices
    ## 90       5 2005 55.8660 12.7477         39     ices
    ## 91       5 2005 55.8670 12.7472         39     ices
    ## 92       5 2005 55.8658 12.7487         39     ices
    ## 93       5 2005 55.8663 12.7477         39     ices
    ## 94       5 2005 55.8673 12.7485         39     ices
    ## 95       5 2005 55.8687 12.7500         39     ices
    ## 96       5 2005 55.8780 12.7492         39     ices
    ## 97       5 2005 55.8663 12.7487         39     ices
    ## 98       5 2005 55.8662 12.7483         39     ices
    ## 99       5 2005 55.8662 12.7493         39     ices
    ## 100      5 2005 55.8687 12.7490         39     ices
    ## 101      5 2005 55.8727 12.7487         39     ices
    ## 102      5 2005 55.8663 12.7480         39     ices
    ## 103      5 2005 55.8700 12.7480         39     ices
    ## 104      5 2005 55.8688 12.7490         39     ices
    ## 105      5 2005 55.8683 12.7490         39     ices
    ## 106      5 2005 55.8665 12.7488         39     ices
    ## 107      5 2005 55.8653 12.7480         39     ices
    ## 108      5 2005 55.8665 12.7493         39     ices
    ## 109      5 2005 55.8725 12.7490         39     ices
    ## 110      5 2005 55.8683 12.7483         39     ices
    ## 111      5 2005 55.8662 12.7477         39     ices
    ## 112      5 2005 55.8662 12.7492         39     ices
    ## 113      5 2005 55.8700 12.7488         39     ices
    ## 114      5 2005 55.8655 12.7495         39     ices
    ## 115      5 2005 55.8658 12.7483         39     ices
    ## 116      5 2005 55.8660 12.7487         39     ices
    ## 117      5 2005 55.8670 12.7500         39     ices
    ## 118      5 2005 55.7947 12.8605         39     ices
    ## 119      5 2005 56.2167 12.5167         39     smhi
    ## 120      5 2005 55.7850 12.9067         39     smhi
    ## 121      5 2005 55.6508 13.0350         39     smhi
    ## 122      5 2005 55.6867 13.0367         39     smhi
    ## 123      5 2005 55.8667 12.7500         39     smhi
    ## 124      5 2004 55.8700 12.7500         39     ices
    ## 125      5 2004 55.8658 12.7492         39     ices
    ## 126      5 2004 55.8700 12.7483         39     ices
    ## 127      5 2004 55.8670 12.7482         39     ices
    ## 128      5 2004 55.8700 12.7493         39     ices
    ## 129      5 2004 55.8678 12.7472         39     ices
    ## 130      5 2004 55.8700 12.7490         39     ices
    ## 131      5 2004 55.8675 12.7488         39     ices
    ## 132      5 2004 55.8670 12.7475         39     ices
    ## 133      5 2004 55.8660 12.7483         39     ices
    ## 134      5 2004 55.8680 12.7472         39     ices
    ## 135      5 2004 55.8658 12.7483         39     ices
    ## 136      5 2004 55.8663 12.7485         39     ices
    ## 137      5 2004 55.8655 12.7488         39     ices
    ## 138      5 2004 55.8662 12.7492         39     ices
    ## 139      5 2004 55.8657 12.7478         39     ices
    ## 140      5 2004 55.8665 12.7475         39     ices
    ## 141      5 2004 55.8663 12.7482         39     ices
    ## 142      5 2004 55.8672 12.7485         39     ices
    ## 143      5 2004 55.8657 12.7480         39     ices
    ## 144      5 2004 55.8670 12.7493         39     ices
    ## 145      5 2004 55.8662 12.7495         39     ices
    ## 146      5 2004 55.8657 12.7488         39     ices
    ## 147      5 2004 55.8665 12.7482         39     ices
    ## 148      5 2004 55.8700 12.7487         39     ices
    ## 149      5 2004 55.8672 12.7480         39     ices
    ## 150      5 2004 55.8647 12.7482         39     ices
    ## 151      5 2004 55.8668 12.7485         39     ices
    ## 152      5 2004 55.8658 12.7487         39     ices
    ## 153      5 2004 55.8648 12.7478         39     ices
    ## 154      5 2004 55.8670 12.7500         39     ices
    ## 155      5 2004 56.2167 12.5167         39     smhi
    ## 156      5 2004 55.7850 12.9067         39     smhi
    ## 157      5 2004 55.6517 13.0350         39     smhi
    ## 158      5 2004 55.6867 13.0367         39     smhi
    ## 159      5 2004 55.8667 12.7500         39     smhi
    ## 160      5 2003 55.8700 12.7500         39     ices
    ## 161      5 2003 55.8655 12.7497         39     ices
    ## 162      5 2003 55.8665 12.7485         39     ices
    ## 163      5 2003 55.8660 12.7483         39     ices
    ## 164      5 2003 55.8657 12.7487         39     ices
    ## 165      5 2003 55.8663 12.7482         39     ices
    ## 166      5 2003 55.8617 12.7497         39     ices
    ## 167      5 2003 55.8652 12.7482         39     ices
    ## 168      5 2003 55.8653 12.7483         39     ices
    ## 169      5 2003 55.8658 12.7485         39     ices
    ## 170      5 2003 55.8668 12.7488         39     ices
    ## 171      5 2003 55.8655 12.7482         39     ices
    ## 172      5 2003 55.8620 12.7495         39     ices
    ## 173      5 2003 55.8670 12.7482         39     ices
    ## 174      5 2003 55.8668 12.7500         39     ices
    ## 175      5 2003 55.8668 12.7527         39     ices
    ## 176      5 2003 55.8658 12.7478         39     ices
    ## 177      5 2003 55.8657 12.7482         39     ices
    ## 178      5 2003 55.8653 12.7480         39     ices
    ## 179      5 2003 55.8652 12.7483         39     ices
    ## 180      5 2003 55.8663 12.7490         39     ices
    ## 181      5 2003 55.8647 12.7482         39     ices
    ## 182      5 2003 55.8660 12.7482         39     ices
    ## 183      5 2003 55.8673 12.7485         39     ices
    ## 184      5 2003 55.8672 12.7482         39     ices
    ## 185      5 2003 55.8700 12.7485         39     ices
    ## 186      5 2003 55.8663 12.7485         39     ices
    ## 187      5 2003 55.8665 12.7497         39     ices
    ## 188      5 2003 55.8668 12.7480         39     ices
    ## 189      5 2003 55.8662 12.7485         39     ices
    ## 190      5 2003 55.8662 12.7478         39     ices
    ## 191      5 2003 55.8650 12.7493         39     ices
    ## 192      5 2003 55.8660 12.7488         39     ices
    ## 193      5 2003 55.8700 12.7482         39     ices
    ## 194      5 2003 55.8678 12.7482         39     ices
    ## 195      5 2003 55.8670 12.7500         39     ices
    ## 196      5 2003 56.2167 12.5167         39     smhi
    ## 197      5 2003 55.7850 12.9067         39     smhi
    ## 198      5 2003 55.6517 13.0350         39     smhi
    ## 199      5 2003 55.6867 13.0367         39     smhi
    ## 200      5 2003 55.8667 12.7500         39     smhi
    ## 201      5 2002 55.8700 12.7500         39     ices
    ## 202      5 2002 55.8670 12.7483         39     ices
    ## 203      5 2002 55.8655 12.7478         39     ices
    ## 204      5 2002 55.8665 12.7480         39     ices
    ## 205      5 2002 55.8673 12.7487         39     ices
    ## 206      5 2002 55.8670 12.7477         39     ices
    ## 207      5 2002 55.8662 12.7483         39     ices
    ## 208      5 2002 55.8658 12.7483         39     ices
    ## 209      5 2002 55.8655 12.7482         39     ices
    ## 210      5 2002 55.8510 12.7433         39     ices
    ## 211      5 2002 55.8662 12.7485         39     ices
    ## 212      5 2002 55.8665 12.7478         39     ices
    ## 213      5 2002 55.8648 12.7492         39     ices
    ## 214      5 2002 55.8658 12.7478         39     ices
    ## 215      5 2002 55.8672 12.7485         39     ices
    ## 216      5 2002 55.8665 12.7485         39     ices
    ## 217      5 2002 55.8655 12.7477         39     ices
    ## 218      5 2002 55.8658 12.7487         39     ices
    ## 219      5 2002 55.8668 12.7488         39     ices
    ## 220      5 2002 55.8648 12.7490         39     ices
    ## 221      5 2002 55.8662 12.7480         39     ices
    ## 222      5 2002 55.8663 12.7478         39     ices
    ## 223      5 2002 55.8663 12.7487         39     ices
    ## 224      5 2002 55.8657 12.7487         39     ices
    ## 225      5 2002 55.8657 12.7483         39     ices
    ## 226      5 2002 55.8663 12.7483         39     ices
    ## 227      5 2002 55.8700 12.7483         39     ices
    ## 228      5 2002 55.8648 12.7482         39     ices
    ## 229      5 2002 55.8650 12.7485         39     ices
    ## 230      5 2002 55.8665 12.7482         39     ices
    ## 231      5 2002 55.8675 12.7483         39     ices
    ## 232      5 2002 55.8665 12.7477         39     ices
    ## 233      5 2002 55.8655 12.7490         39     ices
    ## 234      5 2002 55.8688 12.7480         39     ices
    ## 235      5 2002 55.8668 12.7493         39     ices
    ## 236      5 2002 55.8660 12.7483         39     ices
    ## 237      5 2002 55.8652 12.7487         39     ices
    ## 238      5 2002 55.8670 12.7500         39     ices
    ## 239      5 2002 56.2167 12.5167         39     smhi
    ## 240      5 2002 55.7850 12.9067         39     smhi
    ## 241      5 2002 55.6508 13.0350         39     smhi
    ## 242      5 2002 55.6867 13.0367         39     smhi
    ## 243      5 2002 55.8667 12.7500         39     smhi
    ## 244      5 2001 55.8700 12.7500         39     ices
    ## 245      5 2001 55.8657 12.7482         39     ices
    ## 246      5 2001 55.8670 12.7477         39     ices
    ## 247      5 2001 55.8658 12.7473         39     ices
    ## 248      5 2001 55.8623 12.7498         39     ices
    ## 249      5 2001 55.8668 12.7492         39     ices
    ## 250      5 2001 55.8670 12.7492         39     ices
    ## 251      5 2001 55.8700 12.7492         39     ices
    ## 252      5 2001 55.8665 12.7493         39     ices
    ## 253      5 2001 55.8672 12.7485         39     ices
    ## 254      5 2001 55.8660 12.7480         39     ices
    ## 255      5 2001 55.8668 12.7482         39     ices
    ## 256      5 2001 55.8653 12.7488         39     ices
    ## 257      5 2001 55.8660 12.7487         39     ices
    ## 258      5 2001 55.8653 12.7480         39     ices
    ## 259      5 2001 55.8700 12.7487         39     ices
    ## 260      5 2001 55.8700 12.7478         39     ices
    ## 261      5 2001 55.8665 12.7487         39     ices
    ## 262      5 2001 55.8660 12.7488         39     ices
    ## 263      5 2001 55.8673 12.7490         39     ices
    ## 264      5 2001 55.8665 12.7482         39     ices
    ## 265      5 2001 55.8662 12.7490         39     ices
    ## 266      5 2001 55.8700 12.7483         39     ices
    ## 267      5 2001 55.8672 12.7473         39     ices
    ## 268      5 2001 55.8672 12.7487         39     ices
    ## 269      5 2001 55.8670 12.7485         39     ices
    ## 270      5 2001 55.8660 12.7473         39     ices
    ## 271      5 2001 55.8665 12.7497         39     ices
    ## 272      5 2001 55.8653 12.7478         39     ices
    ## 273      5 2001 55.8658 12.7497         39     ices
    ## 274      5 2001 55.8652 12.7482         39     ices
    ## 275      5 2001 55.8672 12.7443         39     ices
    ## 276      5 2001 55.8673 12.7475         39     ices
    ## 277      5 2001 55.8672 12.7483         39     ices
    ## 278      5 2001 55.8657 12.7483         39     ices
    ## 279      5 2001 55.8665 12.7492         39     ices
    ## 280      5 2001 55.8665 12.7488         39     ices
    ## 281      5 2001 55.8670 12.7500         39     ices
    ## 282      5 2001 55.7850 12.9067         39     smhi
    ## 283      5 2001 56.2167 12.5167         39     smhi
    ## 284      5 2001 55.6508 13.0350         39     smhi
    ## 285      5 2001 55.8667 12.7500         39     smhi
    ## 286      5 2001 55.6867 13.0367         39     smhi
    ## 287      5 2000 55.8700 12.7500         39     ices
    ## 288      5 2000 55.8673 12.7485         39     ices
    ## 289      5 2000 55.8670 12.7497         39     ices
    ## 290      5 2000 55.8665 12.7487         39     ices
    ## 291      5 2000 55.8647 12.7470         39     ices
    ## 292      5 2000 55.8662 12.7488         39     ices
    ## 293      5 2000 55.8680 12.7478         39     ices
    ## 294      5 2000 55.8655 12.7495         39     ices
    ## 295      5 2000 55.8668 12.7483         39     ices
    ## 296      5 2000 55.8662 12.7487         39     ices
    ## 297      5 2000 55.8662 12.7480         39     ices
    ## 298      5 2000 55.8670 12.7485         39     ices
    ## 299      5 2000 55.8657 12.7487         39     ices
    ## 300      5 2000 55.8657 12.7482         39     ices
    ## 301      5 2000 55.8663 12.7483         39     ices
    ## 302      5 2000 55.8653 12.7490         39     ices
    ## 303      5 2000 55.8658 12.7478         39     ices
    ## 304      5 2000 55.8643 12.7490         39     ices
    ## 305      5 2000 55.8652 12.7495         39     ices
    ## 306      5 2000 55.8672 12.7487         39     ices
    ## 307      5 2000 55.8660 12.7480         39     ices
    ## 308      5 2000 55.8658 12.7480         39     ices
    ## 309      5 2000 55.8655 12.7478         39     ices
    ## 310      5 2000 55.8663 12.7480         39     ices
    ## 311      5 2000 55.8668 12.7490         39     ices
    ## 312      5 2000 55.8700 12.7482         39     ices
    ## 313      5 2000 55.8658 12.7477         39     ices
    ## 314      5 2000 55.8665 12.7480         39     ices
    ## 315      5 2000 55.8665 12.7485         39     ices
    ## 316      5 2000 55.8657 12.7475         39     ices
    ## 317      5 2000 55.8642 12.7535         39     ices
    ## 318      5 2000 55.8658 12.7487         39     ices
    ## 319      5 2000 55.8655 12.7480         39     ices
    ## 320      5 2000 55.8665 12.7493         39     ices
    ## 321      5 2000 55.6470 12.9550         39     ices
    ## 322      5 2000 55.8670 12.7500         39     ices
    ## 323      5 2000 56.2167 12.5167         39     smhi
    ## 324      5 2000 55.6508 13.0350         39     smhi
    ## 325      5 2000 55.6867 13.0367         39     smhi
    ## 326      5 2000 55.7850 12.9067         39     smhi
    ## 327      5 2000 55.8667 12.7500         39     smhi
    ## 328      5 2000 55.6467 12.9550         39     smhi
    ## 329      5 1999 55.8663 12.7495         39     ices
    ## 330      5 1999 55.8677 12.7493         39     ices
    ## 331      5 1999 55.8700 12.7507         39     ices
    ## 332      5 1999 55.8670 12.7488         39     ices
    ## 333      5 1999 55.8660 12.7495         39     ices
    ## 334      5 1999 55.8678 12.7493         39     ices
    ## 335      5 1999 55.8660 12.7502         39     ices
    ## 336      5 1999 55.8673 12.7488         39     ices
    ## 337      5 1999 55.8700 12.7492         39     ices
    ## 338      5 1999 55.8647 12.7505         39     ices
    ## 339      5 1999 55.8675 12.7503         39     ices
    ## 340      5 1999 55.8675 12.7497         39     ices
    ## 341      5 1999 55.8662 12.7507         39     ices
    ## 342      5 1999 55.8673 12.7495         39     ices
    ## 343      5 1999 55.8675 12.7493         39     ices
    ## 344      5 1999 55.8662 12.7492         39     ices
    ## 345      5 1999 55.8663 12.7488         39     ices
    ## 346      5 1999 55.8670 12.7495         39     ices
    ## 347      5 1999 55.8673 12.7497         39     ices
    ## 348      5 1999 55.8657 12.7488         39     ices
    ## 349      5 1999 55.8700 12.7505         39     ices
    ## 350      5 1999 55.8657 12.7513         39     ices
    ## 351      5 1999 55.8670 12.7507         39     ices
    ## 352      5 1999 55.8620 12.7515         39     ices
    ## 353      5 1999 55.8665 12.7503         39     ices
    ## 354      5 1999 55.8663 12.7485         39     ices
    ## 355      5 1999 55.8647 12.7510         39     ices
    ## 356      5 1999 55.8653 12.7498         39     ices
    ## 357      5 1999 55.8678 12.7495         39     ices
    ## 358      5 1999 55.8663 12.7478         39     ices
    ## 359      5 1999 55.8677 12.7490         39     ices
    ## 360      5 1999 55.8645 12.7495         39     ices
    ## 361      5 1999 55.8670 12.7500         39     ices
    ## 362      5 1999 55.7700 12.7970         39     ices
    ## 363      5 1999 55.5980 12.8580         39     ices
    ## 364      5 1998 55.8700 12.7500         39     ices
    ## 365      5 1998 55.8670 12.7503         39     ices
    ## 366      5 1998 55.8668 12.7487         39     ices
    ## 367      5 1998 55.8688 12.7487         39     ices
    ## 368      5 1998 55.8702 12.7478         39     ices
    ## 369      5 1998 55.8660 12.7503         39     ices
    ## 370      5 1998 55.8700 12.7495         39     ices
    ## 371      5 1998 55.8660 12.7500         39     ices
    ## 372      5 1998 55.8670 12.7495         39     ices
    ## 373      5 1998 55.8700 12.7492         39     ices
    ## 374      5 1998 55.8677 12.7497         39     ices
    ## 375      5 1998 55.8663 12.7485         39     ices
    ## 376      5 1998 55.8668 12.7495         39     ices
    ## 377      5 1998 55.8675 12.7505         39     ices
    ## 378      5 1998 55.8677 12.7503         39     ices
    ## 379      5 1998 55.8677 12.7490         39     ices
    ## 380      5 1998 55.8655 12.7490         39     ices
    ## 381      5 1998 55.8658 12.7507         39     ices
    ## 382      5 1998 55.8672 12.7490         39     ices
    ## 383      5 1998 55.8662 12.7477         39     ices
    ## 384      5 1998 55.8680 12.7490         39     ices
    ## 385      5 1998 55.8658 12.7500         39     ices
    ## 386      5 1998 55.8678 12.7495         39     ices
    ## 387      5 1998 55.8672 12.7493         39     ices
    ## 388      5 1998 55.8657 12.7483         39     ices
    ## 389      5 1998 55.8682 12.7493         39     ices
    ## 390      5 1998 55.8675 12.7497         39     ices
    ## 391      5 1998 55.8800 12.7500         39     ices
    ## 392      5 1998 55.5980 12.8580         39     ices
    ## 393      5 1998 55.8670 12.7500         39     ices
    ## 394      5 1997 55.8670 12.7500         39     ices
    ## 395      5 1996 55.8670 12.7500         39     ices
    ## 396      5 1995 55.8670 12.7500         39     ices
    ## 397      5 1994 55.8700 12.7500         39     ices
    ## 398      5 1994 55.8670 12.7500         39     ices
    ## 399      5 1993 55.8670 12.7500         39     ices
    ## 400      5 1993 55.8000 12.8500         39     ices
    ## 401      5 1993 56.2370 12.3920         39     ices
    ## 402      5 1992 55.9920 12.6920         39     ices
    ## 403      5 1992 55.8670 12.7500         39     ices
    ## 404      5 1992 55.7700 12.7970         39     ices
    ## 405      5 1992 55.6470 12.9550         39     ices
    ## 406      5 1991 55.7700 12.7970         39     ices
    ## 407      5 1991 55.8670 12.7500         39     ices
    ## 408      5 1991 55.9920 12.6920         39     ices
    ## 409      5 1991 55.6470 12.9550         39     ices
    ## 410      5 1990 56.1020 12.5850         39     ices
    ## 411      5 1990 55.9920 12.6920         39     ices
    ## 412      5 1990 55.8670 12.7500         39     ices
    ## 413      5 1990 55.7700 12.7970         39     ices
    ## 414      5 1990 55.6470 12.9550         39     ices
    ## 415      5 1989 55.8670 12.7500         39     ices
    ## 416      5 1989 55.7700 12.7970         39     ices
    ## 417      5 1989 55.6470 12.9550         39     ices
    ## 418      5 1989 56.1020 12.5850         39     ices
    ## 419      5 1989 55.9920 12.6920         39     ices
    ## 420      5 1988 55.8670 12.7500         39     ices
    ## 421      5 1988 55.7700 12.7970         39     ices
    ## 422      5 1988 55.6470 12.9550         39     ices
    ## 423      5 1988 56.2552 12.4343         39     ices
    ## 424      5 1988 56.2552 12.4342         39     ices
    ## 425      5 1988 56.2873 12.4443         39     ices
    ## 426      5 1988 55.9920 12.6920         39     ices
    ## 427      5 1988 55.7320 12.9200         39     ices
    ## 428      5 1988 55.7550 12.8780         39     ices
    ## 429      5 1988 55.5920 12.8420         39     ices
    ## 430      5 1988 56.1020 12.5850         39     ices

``` r
allData %>% filter(bhi_id %in% 5) %>% dplyr::select(coast_code, supplier)%>%distinct(.)
```

    ##   coast_code supplier
    ## 1         39     ices
    ## 2         39     smhi

``` r
    ## All region 5 codes are coastal



## Filter data that are only offshore, coast_code == 0
allData = allData %>% filter(coast_code==0)

dim(allData)#14019    10 
```

    ## [1] 14019    10

``` r
## This is a substantial reduction in the number of observations

## find data points without BHI ID
allData %>% filter(is.na(bhi_id))  ##manual check is just barely within Latvian EEZ so is region 27
```

    ##   bhi_id secchi year month     lat     lon cruise       date coast_code
    ## 1     NA    2.5 2002     8 57.8562 24.3058   LAAN 2002-08-07          0
    ##   supplier
    ## 1     ices

``` r
allData = allData %>%
          mutate(bhi_id = ifelse(is.na(bhi_id),27, bhi_id))
allData %>% filter(is.na(bhi_id))  
```

    ##  [1] bhi_id     secchi     year       month      lat        lon       
    ##  [7] cruise     date       coast_code supplier  
    ## <0 rows> (or 0-length row.names)

### 3.3 Target values

These are the values that will be used as a reference point.

``` r
target <- readr::read_csv(file.path(dir_secchi, "eutro_targets_HELCOM.csv"))
head(target)
```

    ## # A tibble: 6 x 6
    ##                basin winter_din winter_dip summer_chl summer_secchi
    ##                <chr>      <dbl>      <dbl>      <dbl>         <dbl>
    ## 1           Kattegat        5.0       0.49        1.5           7.6
    ## 2          The_Sound        3.3       0.42        1.2           8.2
    ## 3         Great_Belt        5.0       0.59        1.7           8.5
    ## 4        Little_Belt        7.1       0.71        2.8           7.3
    ## 5           Kiel_Bay        5.5       0.57        2.0           7.4
    ## 6 Bay_of_Mecklenburg        4.3       0.49        1.8           7.1
    ## # ... with 1 more variables: oxy_debt <dbl>

``` r
#select just summer_seccchi target
target = target %>% dplyr::select(basin, summer_secchi)%>%
        mutate(basin = str_replace_all(basin,"_"," "))
```

### 3.4 HELCOM HOLAS Basin

These basins are the relevant physical units.
Secchi data will be first assessed at this level and then assigned to BHI region. EEZ divisions may result in some BHI regions that have no data but they are physically the same basin as a BHI region with data.

``` r
basin_lookup = read.csv(file.path(dir_secchi,'bhi_basin_country_lookup.csv'), sep=";")
basin_lookup=basin_lookup %>% dplyr::select(bhi_id = BHI_ID, basin_name=Subbasin)
```

### 3.5 dplyr::select summer data and plot

    - Months 6-9 (June, July, August, September)  
    - Years >= 2000  
    - Data is sparse for BHI regions 4,22,25  
    - No data BHI regions 5 (all coastal), 6 (offshore observations rare after from 2000 and not in summer).  

``` r
summer = allData %>% filter(month %in%c(6:9)) %>%
        filter(year >=2000)
head(summer)
```

    ##   bhi_id secchi year month     lat     lon cruise       date coast_code
    ## 1      1    8.0 2000     8 56.2300 12.3700   26GT 2000-08-07          0
    ## 2      2    7.0 2000     8 56.5583 11.0300   26GT 2000-08-08          0
    ## 3      2    6.3 2000     8 56.8567 10.7917   26GT 2000-08-08          0
    ## 4      2   10.2 2000     8 57.3000 10.7450   26GT 2000-08-08          0
    ## 5      2   13.2 2000     8 57.4300 10.7083   26GT 2000-08-08          0
    ## 6      2   13.0 2000     8 57.4650 10.9000   26GT 2000-08-08          0
    ##   supplier
    ## 1     ices
    ## 2     ices
    ## 3     ices
    ## 4     ices
    ## 5     ices
    ## 6     ices

``` r
#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~bhi_id, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/dplyr::select%20summer%20data-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~bhi_id)
```

![](secchi_prep_files/figure-markdown_github/dplyr::select%20summer%20data-2.png)

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

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name)
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-2.png)

### 3.7 Restrict data to before 2014

    - The Sound does not appear in the plot - No Data
    - There are still basins with limited or not data from 2010 onwards (*Great Belt*) but this at least removes the potential for not having data reported in the past 2 years

``` r
summer = summer %>% filter(year < 2014)

#Plot
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/restrict%20data%20before%202014-1.png)

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

### 3.8 Evaluate number of stations sampled in each basin

Very different number of unique lat-lon locations by month and basin.
Sometimes lat-lon is not good to use because recording specific ship location which might be vary even though ship is at the same station. More duplicates were detected in the data however when station was not included, than when lat and lon were not included as the location identifier.

``` r
basin_summary = summer %>% group_by(basin_name,year,month)%>%
                dplyr::select(year, month,lat,lon,basin_name)%>%
                summarise(loc_count = n_distinct(lat,lon))
basin_summary
```

    ## Source: local data frame [631 x 4]
    ## Groups: basin_name, year [?]
    ## 
    ##    basin_name  year month loc_count
    ##        <fctr> <int> <int>     <int>
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
    ## # ... with 621 more rows

``` r
#plot sampling overview
ggplot(basin_summary) + geom_point(aes(year,loc_count, colour=factor(month)))+
  facet_wrap(~basin_name, scales ="free_y")+
  ylab("Number Sampling Locations")
```

![](secchi_prep_files/figure-markdown_github/samples%20and%20stations%20by%20basin-1.png)

### 3.9 Mean secchi Calculation

### 3.9.1 Calculate mean monthly value for each summer month

basin monthly mean = mean of all samples within month and basin

``` r
mean_months = summer %>% dplyr::select(year, month,basin_name,secchi)%>%
              group_by(year,month,basin_name)%>%
              summarise(mean_secchi = round(mean(secchi,na.rm=TRUE),1))%>%
              ungroup()
head(mean_months)
```

    ## # A tibble: 6 x 4
    ##    year month            basin_name mean_secchi
    ##   <int> <int>                <fctr>       <dbl>
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

![](secchi_prep_files/figure-markdown_github/plot%20mean%20monthly-1.png)

### 3.9.3 Calculate summer mean secchi (basin)

basin summer mean = mean of basin monthly mean values

``` r
mean_months_summer = mean_months %>% dplyr::select(year, basin_name,mean_secchi) %>%
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

![](secchi_prep_files/figure-markdown_github/plot%20mean%20summer%20secchi-1.png)

### 3.9.5 Plot summer secchi with target values indicated

Horizontal lines are HELCOM target values.

``` r
secchi_target = left_join(mean_months_summer,target, by=c("basin_name" = "basin"))%>%
                dplyr::rename(target_secchi = summer_secchi)
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

``` r
head(secchi_target)
```

    ## # A tibble: 6 x 4
    ##    year         basin_name mean_secchi target_secchi
    ##   <int>              <chr>       <dbl>         <dbl>
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

![](secchi_prep_files/figure-markdown_github/summer%20secchi%20with%20target-1.png)

4. Status and Trend explostatusn
--------------------------------

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

    ## # A tibble: 16 x 2
    ##                basin_name last_year
    ##                     <chr>     <int>
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
    ## # ... with 1 more rows

``` r
##which are not in 2013
last_year %>% filter(last_year < 2013)
```

    ## # A tibble: 5 x 2
    ##        basin_name last_year
    ##             <chr>     <int>
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

    ## # A tibble: 214 x 4
    ##     year            basin_name mean_secchi target_secchi
    ##    <int>                 <chr>       <dbl>         <dbl>
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
    ## # ... with 204 more rows

``` r
## Calculate basin status
  ## Xnut = basin_mean/basin_target
  
  basin_status = secchi_target %>%
                 mutate(., status =  pmin(1, mean_secchi/target_secchi)) %>%
      dplyr::select(basin_name, year, status)
  
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
                dplyr::select(rgn_id = bhi_id, dimension, score=status)
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

``` r
    bhi_trend = left_join(basin_lookup,basin_trend, by="basin_name") %>%
                 mutate(score = round(trend_score,2),
                        dimension = "trend")%>%
                dplyr::select(rgn_id = bhi_id, dimension, score )
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

### 4.4 Plot Basin status over time

Basin status is initially a value between 0 - 1. Calculated for each year between 2000 and 2013.

``` r
ggplot(basin_status) + geom_point((aes(year,status)))+
  facet_wrap(~basin_name) +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))
```

![](secchi_prep_files/figure-markdown_github/plot%20basin%20status-1.png)

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

![](secchi_prep_files/figure-markdown_github/bhi%20status%20and%20trend%20plot-1.png)

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

6. Rescale Mean secchi data and recalculate status
==================================================

Rescaled to manipulate the status scores with different transformations:

*score = mean/target*

Decay:

transformation\_1 = score^2 transformation\_2 = score^4

Logistic:

transformation\_3 = 1/(1+ exp(-(score - 0.5)/0.1)) transformation\_4 = 1/(1+ exp(-(score - 0.7)/0.08))

Note: decided that these transformations do not contribute to better representation of the status scores. We will stick to the original scores.

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
```

![](secchi_prep_files/figure-markdown_github/testing%20non%20linear%20weighting-1.png)

``` r
 ## setup to plot different tranformations using PlotMap function

 source('~/github/bhi/baltic2015/PlotMap.r')
 source('~/github/bhi/baltic2015/PrepSpatial.R') 
```

    ## Loading required package: sp

    ## Checking rgeos availability: TRUE

    ## rgdal: version: 1.1-10, (SVN revision 622)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.1.0, released 2016/04/25
    ##  Path to GDAL shared files: /usr/share/gdal/2.1
    ##  Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
    ##  Path to PROJ.4 shared files: (autodetected)
    ##  Linking to sp version: 1.2-3

``` r
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
```

    ## Loading required package: gpclib

    ## General Polygon Clipper Library for R (version 1.5-5)
    ##  Type 'class ? gpc.poly' for help

``` r
gpclibPermit()
```

    ## [1] TRUE

``` r
 plot_transf_1 =  PlotMap(bhi_status_1, map_title = expression('Transformation 1: status = (mean/target)' ^ 2), 
                           rgn_poly        = PrepSpatial(path.expand('~/github/bhi/baltic2015/spatial/regions_gcs.geojson')))
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/home/mendes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

![](secchi_prep_files/figure-markdown_github/testing%20non%20linear%20weighting-2.png)

``` r
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
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/home/mendes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

![](secchi_prep_files/figure-markdown_github/testing%20non%20linear%20weighting-3.png)

``` r
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
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/home/mendes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

![](secchi_prep_files/figure-markdown_github/testing%20non%20linear%20weighting-4.png)

``` r
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

    ## OGR data source with driver: GeoJSON 
    ## Source: "/home/mendes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

![](secchi_prep_files/figure-markdown_github/testing%20non%20linear%20weighting-5.png)

7. Trial: add Anoxia data to Nutrient calculations (NUT)
========================================================

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
