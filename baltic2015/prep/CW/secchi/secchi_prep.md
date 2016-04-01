secchi\_prep
================

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

    ## Warning: package 'ggplot2' was built under R version 3.2.4

    ## Loading required package: DBI

``` r
dir_cw    = file.path(dir_prep, 'CW')
dir_secchi    = file.path(dir_prep, 'CW/secchi')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_secchi, 'secchi_prep.rmd')
```

Background on using Secchi
--------------------------

[HELCOM Water Clarity Core Indicator](http://www.helcom.fi/baltic-sea-trends/indicators/water-clarity) Mean Summer Secchi (June-September)

Secchi Data
-----------

### Data sources

ICES SMHI

**Duplicates in the Data**
ICES data contains profile data (eg temperature,but secchi is only measured once). Need only unique secchi records. It appears the SMHI also contains profiles. Also check to see if any SMHI data already in the ICES records.

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
         cruise= Cruise, station = Station, date= Date) %>%
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
    ##   supplier
    ## 1     ices
    ## 2     ices
    ## 3     ices
    ## 4     ices
    ## 5     ices
    ## 6     ices

``` r
smhi <- data2 %>% data.frame()%>%
  filter(!is.na(BHI_ID)) %>%
  rename(secchi = value) %>%
  select(bhi_id= BHI_ID, secchi, year= Year, month= Month, 
        lat= Latitude, lon= Longitude, 
         cruise = Provtagningstillfaelle.id, 
         station = Stationsnamn, date= Date) %>%
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
    ##         date supplier
    ## 1 2015-11-26     smhi
    ## 2 2015-11-26     smhi
    ## 3 2015-11-26     smhi
    ## 4 2015-11-26     smhi
    ## 5 2015-11-26     smhi
    ## 6 2015-11-03     smhi

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

Target values
-------------

These are the values that will be used as a reference point.

``` r
target <- readr::read_csv(file.path(dir_cw, "eutro_targets_HELCOM.csv"))
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

HELCOM HOLAS Basin
------------------

These basins are the relevant physical units.
Secchi data will be first assessed at this level and then assigned to BHI region. EEZ divisions may result in some BHI regions that have no data but they are physically the same basin as a BHI region with data.

``` r
basin_lookup = readr::read_csv(file.path(
  dir_prep,"baltic_rgns_to_bhi_rgns_lookup_holas.csv"))
basin_lookup=basin_lookup %>% select(bhi_id = rgn_id, basin_name)%>%
  mutate(basin_name = str_replace_all(basin_name,"_"," "))
```

Select summer data and plot
---------------------------

Months 6-9 (June, July, August, September) Years &gt;= 2000 Data is sparse for BHI regions 4,22,25

``` r
summer = allData %>% filter(month %in%c(6:9)) %>%
        filter(year >=2000)
head(summer)
```

    ## Source: local data frame [6 x 9]
    ## 
    ##   bhi_id secchi  year month     lat     lon cruise       date supplier
    ##    (int)  (dbl) (int) (int)   (dbl)   (dbl)  (chr)     (date)    (chr)
    ## 1      5    7.0  2000     8 55.8700 12.7500   26GT 2000-08-07     ices
    ## 2      1    8.0  2000     8 56.2300 12.3700   26GT 2000-08-07     ices
    ## 3      2    7.0  2000     8 56.5583 11.0300   26GT 2000-08-08     ices
    ## 4      2    6.3  2000     8 56.8567 10.7917   26GT 2000-08-08     ices
    ## 5      2   10.2  2000     8 57.3000 10.7450   26GT 2000-08-08     ices
    ## 6      2   13.2  2000     8 57.4300 10.7083   26GT 2000-08-08     ices

``` r
#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~bhi_id, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/select%20summer%20data-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~bhi_id)
```

![](secchi_prep_files/figure-markdown_github/select%20summer%20data-2.png)

Assign secchi data to a HOLAS basin
-----------------------------------

Data coverage appears substantially better at the basin scale. Some basins have missing data or limited data for the most recent years: Great Belt, Gulf of Riga, Kiel Bay

``` r
summer = summer %>% full_join(., basin_lookup, by="bhi_id")

#Plot
ggplot(summer) + geom_point(aes(month,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y")
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-1.png)

``` r
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y")
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/assign%20summer%20data%20to%20a%20HOLAS%20basin-2.png)

Restrict data to before 2014
----------------------------

There are still basins with limited or not data from 2010 onwards but this at least removes the potential for not having data reported in the past 2 years

``` r
summer = summer %>% filter(year < 2014)

#Plot
ggplot(summer) + geom_point(aes(year,secchi, colour=supplier))+
  facet_wrap(~basin_name, scales ="free_y")
```

![](secchi_prep_files/figure-markdown_github/restrict%20data%20before%202014-1.png)

Evaluate number of stations sampled in each basin
-------------------------------------------------

Very different number of unique lat-lon locations by month and basin.
Sometimes lat-lon is not good to use because recording specific ship location which might be vary even though ship is at the same station. More duplicates were detected in the data however when station was not included, than when lat and lon were not included as the location identifier.

``` r
basin_summary = summer %>% group_by(basin_name,year,month)%>%
                select(year, month,lat,lon,basin_name)%>%
                summarise(loc_count = n_distinct(lat,lon))
basin_summary
```

    ## Source: local data frame [871 x 4]
    ## Groups: basin_name, year [?]
    ## 
    ##    basin_name  year month loc_count
    ##         (chr) (int) (int)     (int)
    ## 1   Aland Sea  2000     6         5
    ## 2   Aland Sea  2000     7         9
    ## 3   Aland Sea  2000     8        13
    ## 4   Aland Sea  2000     9        10
    ## 5   Aland Sea  2001     6         4
    ## 6   Aland Sea  2001     7         8
    ## 7   Aland Sea  2001     8        12
    ## 8   Aland Sea  2001     9         2
    ## 9   Aland Sea  2002     6         8
    ## 10  Aland Sea  2002     7        11
    ## ..        ...   ...   ...       ...

``` r
#plot sampling overview
ggplot(basin_summary) + geom_point(aes(year,loc_count, colour=factor(month)))+
  facet_wrap(~basin_name, scales ="free_y")+
  ylab("Number Sampling Locations")
```

![](secchi_prep_files/figure-markdown_github/samples%20and%20stations%20by%20basin-1.png)

How to model the data?
----------------------

Not all months are sampled in all years (see above plot). **Question is how to model:**
1. Take mean summer secchi, ignore that different months sampled in different years, just average the months that are sampled in any given year. Model by basin and year.
2. Take mean monthly value by year, model by basin + year + month. Average the modelled monthly value to get a summer mean.
3. Do the above but just model all the data points, don't take the mean value and instead use a random effect to account for location?
**Perhaps need to look at document describing HELCOM targets**, how do they calcalate the summer mean? Our calculations should be consistent with how target determined

Calculate mean monthly value for each summer month & overall mean
-----------------------------------------------------------------

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
    ## 1  2000     6             Aland Sea         4.3
    ## 2  2000     6          Arkona Basin         8.0
    ## 3  2000     6        Bornholm Basin         6.5
    ## 4  2000     6          Bothnian Bay         3.5
    ## 5  2000     6          Bothnian Sea         4.5
    ## 6  2000     6 Eastern Gotland Basin         7.9

``` r
#Plot
ggplot(mean_months) + geom_point(aes(year,mean_secchi, colour=factor(month)))+
  geom_line(aes(year,mean_secchi, colour=factor(month)))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10))
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](secchi_prep_files/figure-markdown_github/calculate%20summer%20secchi-1.png)

``` r
mean_months_summer = mean_months %>% select(year, basin_name,mean_secchi) %>%
                      group_by(year,basin_name)%>%
                      summarise(mean_secchi = round(mean(mean_secchi,na.rm=TRUE),1)) %>%
                      ungroup()  #in mean calculation all some months to have NA, ignore for that years calculation

ggplot(mean_months_summer) + geom_point(aes(year,mean_secchi))+
  geom_line(aes(year,mean_secchi))+
  facet_wrap(~basin_name)+
  scale_y_continuous(limits = c(0,10))
```

![](secchi_prep_files/figure-markdown_github/calculate%20summer%20secchi-2.png)

Next steps
----------

1.  Find out how mean secchi value determined for HELCOM core indicator
2.  Decide how to model data (see above) - will do a linear model (not a threshold approach with a logistic model)
