tr\_prep.rmd
================

-   [Prepare Data Layers for Tourism and Recreation (TR) Goal](#prepare-data-layers-for-tourism-and-recreation-tr-goal)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Regional Accommodation Stays Data](#regional-accommodation-stays-data)
        -   [2.1 Regional Accommodation Stays Coastal/Non-Coastal Data](#regional-accommodation-stays-coastalnon-coastal-data)
    -   [3. Goal Model](#goal-model)
        -   [3.1 Status Calculation](#status-calculation)
        -   [3.2 Trend calculation](#trend-calculation)
    -   [4. Data Layer Preparation](#data-layer-preparation)
        -   [4.1 Data clean and organize](#data-clean-and-organize)
        -   [4.2 Join datasets](#join-datasets)
        -   [4.3 Proportion coastal stays at the NUTS1 level](#proportion-coastal-stays-at-the-nuts1-level)
        -   [4.4 Apply proportion coastal to NUTS2 time series data](#apply-proportion-coastal-to-nuts2-time-series-data)
        -   [4.5 Determine NUTS2 population allocation among BHI regions](#determine-nuts2-population-allocation-among-bhi-regions)
    -   [5. Prepare and Save Data Layers](#prepare-and-save-data-layers)
        -   [5.2 Write layer to csv](#write-layer-to-csv)
    -   [6. Explore Status and Trend calculation](#explore-status-and-trend-calculation)
        -   [6.2 Set Parameters](#set-parameters)
        -   [6.3 Calculate status](#calculate-status)
        -   [6.4 Plot Status](#plot-status)
        -   [6.5 Calculate Trend](#calculate-trend)
        -   [6.6 Plot trend](#plot-trend)
        -   [6.7Plot trend and status together](#plot-trend-and-status-together)
    -   [7. Issues or Concerns](#issues-or-concerns)
        -   [7.1 Shapefile assignment issues](#shapefile-assignment-issues)
        -   [7.2 Name discrepancies between datasets](#name-discrepancies-between-datasets)
        -   [7.3 Spatial resolution of coastal allocation.](#spatial-resolution-of-coastal-allocation.)

Prepare Data Layers for Tourism and Recreation (TR) Goal
========================================================

1. Background
-------------

2. Data
-------

### 2.1 Regional Accommodation Stays Data

Eurostat dataset on Nights spent at tourist accommodation establishments by all NUTS regions with the finest scale spatial resolution at NUTS2. [tour\_occ\_nin2](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=tour_occ_nin2&lang=en)

Download Date: 10 Feb 2016, Download By: Jennifer Griffiths

[Metadata](http://ec.europa.eu/eurostat/cache/metadata/en/tour_occ_esms.htm)

Selected all Geographic areas (includes NUTS0, NUTS1, NUTS2)

Selected all accommodation categories combined:Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks

Select all years available: 1990-2014

Missing data indicated by colon (:)

### 2.1 Regional Accommodation Stays Coastal/Non-Coastal Data

Eurostat dataset on Nights spent at tourist accommodation establishments by coastal and non-coastal area from 2012 onwards. These were download for all avaialable region levels. [tour\_occ\_nin2c](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=tour_occ_nin2c&lang=en)
Download Date: 10 Feb 2016, Download By: Jennifer Griffiths

[Metadata](http://ec.europa.eu/eurostat/cache/metadata/en/tour_occ_esms.htm)

Selected all Geographic areas (includes NUTS0, NUTS1, NUTS2)

Selected all accommodation categories combined:Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks

Selected Total, and split between Coastal & non-coastal regions

Selected years available: 2012-2014

Missing data indicated by colon (:)

3. Goal Model
-------------

### 3.1 Status Calculation

Xtr = a\_r / a\_ref\_r
a\_r = number of nights spent in coastal accommodations in BHI region r
a\_ref\_r = a\_r - 5

r = BHI region
a\_r = (proportion population in 25km buffer in nuts2 association with r) x a\_c
n = NUTS2 region
a\_c = coastal accommodation stays in NUTS2 region n
a\_c = a\_n x c\_n1
a\_n = accomodation stays in NUTS2 region\_n
c\_n1 = mean proportion of accommodations stays that are coastal at the NUTS1 level

### 3.2 Trend calculation

Linear regression fit to the most recent 5 status years.

4. Data Layer Preparation
-------------------------

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


dir_tr    = file.path(dir_prep, 'TR')



## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_tr, 'tr_prep.rmd') 
```

### 4.1 Data clean and organize

#### 4.1.1 Read in data

``` r
## read in data...
## accomodation stays time series by NUTS region
accom = read.csv(file.path(dir_tr, "tr_data_database/accom.csv"),stringsAsFactors = FALSE)
dim(accom)
```

    ## [1] 11250    55

``` r
## accomodation stays for 2012-2014 by NUTS region divided by the coastal and non-coastal fractions
accom_coast = read.csv(file.path(dir_tr, "tr_data_database/accom_coast.csv"),stringsAsFactors = FALSE)
dim(accom_coast)
```

    ## [1] 4050   57

``` r
## NUTS2 population and area by BHI region fraction
nuts2_pop_area = read.csv(file.path(dir_tr, "tr_data_database/nuts2_pop_area.csv"), stringsAsFactors = FALSE)
dim(nuts2_pop_area)
```

    ## [1] 72 13

``` r
## european country names and abbreviations
eu_names = read.csv(file.path(dir_prep,"EUcountrynames.csv"),sep=";", stringsAsFactors =FALSE)
```

#### 4.1.2 Clean Data

##### 4.1.2.1 Acommodation stays time series

``` r
## Acommodation stays time series
str(accom)
```

    ## 'data.frame':    11250 obs. of  55 variables:
    ##  $ TIME              : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ TIME_LABEL        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ GEO               : chr  "EU28" "EU27" "BE" "BE1" ...
    ##  $ GEO_LABEL         : chr  "European Union (28 countries)" "European Union (27 countries)" "Belgium" "Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest" ...
    ##  $ INDIC_TO          : chr  "B006" "B006" "B006" "B006" ...
    ##  $ INDIC_TO_LABEL    : chr  "Nights spent, total" "Nights spent, total" "Nights spent, total" "Nights spent, total" ...
    ##  $ UNIT              : chr  "NR" "NR" "NR" "NR" ...
    ##  $ UNIT_LABEL        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ NACE_R2           : chr  "I551-I553" "I551-I553" "I551-I553" "I551-I553" ...
    ##  $ NACE_R2_LABEL     : chr  "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" ...
    ##  $ Value             : chr  ":" ":" "31605550" ":" ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...
    ##  $ BHI_relevant      : chr  NA NA NA NA ...
    ##  $ BHI_ID_1          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_2          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_3          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_4          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_5          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_6          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_7          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_8          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_9          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_10         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_11         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_12         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_13         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_14         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_15         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_16         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_17         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_18         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_19         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_20         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_21         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_22         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_23         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_24         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_25         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_26         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_27         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_28         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_29         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_30         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_31         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_32         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_33         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_34         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_35         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_36         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_37         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_38         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_39         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_40         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_41         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_42         : num  NA NA NA NA NA NA NA NA NA NA ...

``` r
## need to remove the BHI_ID columns - these are from an old join to the BHI shapefile, not relevant now.
## need to rename columns
## these data contain all NUTS levels from level 2 up, need to have them be just NUTS2 -- will do this when join to NUTS2 population data, will then have only the NUTS2 from the shapefile. 
## value has : for NA, fix
accom1 = accom %>%
         select(-contains("BHI"), - TIME_LABEL,-UNIT,-INDIC_TO, -NACE_R2 ) %>% ## remove BHI related columns, and other columns that are not needed
         dplyr::rename(year = TIME,
                       nuts = GEO, 
                       nuts_name = GEO_LABEL,
                       dat_descrip = INDIC_TO_LABEL,
                       unit = UNIT_LABEL,
                       dat_descrip2 = NACE_R2_LABEL,
                       value = Value,
                       flag_notes = Flag.and.Footnotes)%>%
          mutate(value = ifelse(value == ":", NA, value))%>%
          mutate(value = as.numeric(value))%>%
  mutate(dat_descrip = "Nights spent total",
                      dat_descrip2 = "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" )## fix so no commas or semi-colons

str(accom1)
```

    ## 'data.frame':    11250 obs. of  8 variables:
    ##  $ year        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ nuts        : chr  "EU28" "EU27" "BE" "BE1" ...
    ##  $ nuts_name   : chr  "European Union (28 countries)" "European Union (27 countries)" "Belgium" "Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest" ...
    ##  $ dat_descrip : chr  "Nights spent total" "Nights spent total" "Nights spent total" "Nights spent total" ...
    ##  $ unit        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ dat_descrip2: chr  "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" ...
    ##  $ value       : num  NA NA 31605550 NA NA ...
    ##  $ flag_notes  : chr  "" "" "" "" ...

``` r
## check flags
accom1 %>% select(flag_notes) %>% distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          c
    ## 3          e
    ## 4          u
    ## 5         be
    ## 6          b

``` r
accom1 %>% filter(flag_notes %in% c("c","e","u","be","b"))%>% select(year, nuts,value, flag_notes) #very few apply to Baltic countries, u is biggest concern = "low reliability"
```

    ##     year nuts      value flag_notes
    ## 1   1994 PT15         NA          c
    ## 2   1995 PT15         NA          c
    ## 3   1996 PT15         NA          c
    ## 4   1997 PT15         NA          c
    ## 5   1998 PT15         NA          c
    ## 6   1999  PT2         NA          c
    ## 7   1999 PT20         NA          c
    ## 8   1999  PT3         NA          c
    ## 9   1999 PT30         NA          c
    ## 10  1999 CH04         NA          c
    ## 11  2000  PT2         NA          c
    ## 12  2000 PT20         NA          c
    ## 13  2000  PT3         NA          c
    ## 14  2000 PT30         NA          c
    ## 15  2001  PT2         NA          c
    ## 16  2001 PT20         NA          c
    ## 17  2001  PT3         NA          c
    ## 18  2001 PT30         NA          c
    ## 19  2007 EU28 2352043082          e
    ## 20  2007 EU27 2313724244          e
    ## 21  2007   IE         NA          u
    ## 22  2007  IE0         NA          u
    ## 23  2008 EU28 2337334320          e
    ## 24  2008 EU27 2298802248          e
    ## 25  2008   IE         NA          u
    ## 26  2008  IE0         NA          u
    ## 27  2009 EU28 2289338820          e
    ## 28  2009 EU27 2251854199          e
    ## 29  2009   IE         NA          u
    ## 30  2009  IE0         NA          u
    ## 31  2010 EU28 2395948566          e
    ## 32  2010 EU27 2358939384          e
    ## 33  2010   IE         NA          u
    ## 34  2010  IE0         NA          u
    ## 35  2010  UKL         NA          u
    ## 36  2010  UKM         NA          u
    ## 37  2011 EU28 2476060092          e
    ## 38  2011 EU27 2436809302          e
    ## 39  2011   IE         NA          u
    ## 40  2011  IE0         NA          u
    ## 41  2011 IE01         NA          u
    ## 42  2011 IE02         NA          u
    ## 43  2011  FR9         NA          u
    ## 44  2011 FR91         NA          u
    ## 45  2011 FR92         NA          u
    ## 46  2011 FR94         NA          u
    ## 47  2012   IE   28884907         be
    ## 48  2012  IE0   28884907         be
    ## 49  2012   EL   80566672          e
    ## 50  2012  EL1   17249161          e
    ## 51  2012 EL11    1979378          e
    ## 52  2012 EL12   12432494          e
    ## 53  2012 EL13     331998          e
    ## 54  2012 EL14    2505291          e
    ## 55  2012  EL2   16708670          e
    ## 56  2012 EL21    1336119          e
    ## 57  2012 EL22    9553714          e
    ## 58  2012 EL23    1571623          e
    ## 59  2012 EL24    1486993          e
    ## 60  2012 EL25    2760221          e
    ## 61  2012  EL3    6133202          e
    ## 62  2012 EL30    6133202          e
    ## 63  2012  EL4   40475639          e
    ## 64  2012 EL41    1722967          e
    ## 65  2012 EL42   19772657          e
    ## 66  2012 EL43   18980015          e
    ## 67  2012   HR   62183925          b
    ## 68  2012  HR0   62183925          b
    ## 69  2012 HR03   59855870          b
    ## 70  2012 HR04    2328055          b
    ## 71  2012   LV    3546736          b
    ## 72  2012  LV0    3546736          b
    ## 73  2012 LV00    3546736          b
    ## 74  2012   LT    5741252          b
    ## 75  2012  LT0    5741252          b
    ## 76  2012 LT00    5741252          b
    ## 77  2012   LU    2543830          b
    ## 78  2012  LU0    2543830          b
    ## 79  2012 LU00    2543830          b
    ## 80  2012   HU   23169533          b
    ## 81  2012  HU1    8267517          b
    ## 82  2012 HU10    8267517          b
    ## 83  2012  HU2    9856976          b
    ## 84  2012 HU21    2700068          b
    ## 85  2012 HU22    4649091          b
    ## 86  2012 HU23    2507817          b
    ## 87  2012  HU3    5045040          b
    ## 88  2012 HU31    1837221          b
    ## 89  2012 HU32    1866326          b
    ## 90  2012 HU33    1341493          b
    ## 91  2012   RO   19091379          b
    ## 92  2012  RO1    5753526          b
    ## 93  2012 RO11    2105177          b
    ## 94  2012 RO12    3648349          b
    ## 95  2012  RO2    6078090          b
    ## 96  2012 RO21    1676402          b
    ## 97  2012 RO22    4401688          b
    ## 98  2012  RO3    4002707          b
    ## 99  2012 RO31    1764261          b
    ## 100 2012 RO32    2238446          b
    ## 101 2012  RO4    3257056          b
    ## 102 2012 RO41    1502277          b
    ## 103 2012 RO42    1754779          b
    ## 104 2012   SI    9406009          b
    ## 105 2012  SI0    9406009          b
    ## 106 2012 SI01    4074219          b
    ## 107 2012 SI02    5331790          b
    ## 108 2012   UK  303564528          b
    ## 109 2012  UKC    8350176          b
    ## 110 2012 UKC1    1945471          b
    ## 111 2012 UKC2    6404705          b
    ## 112 2012  UKD   27011728          b
    ## 113 2012 UKD1    9399842          b
    ## 114 2012 UKD3    6128672          b
    ## 115 2012 UKD4    5484192          b
    ## 116 2012 UKD6    2231462          b
    ## 117 2012 UKD7    3767560          b
    ## 118 2012  UKE   19201074          b
    ## 119 2012 UKE1    2642410          b
    ## 120 2012 UKE2   10312821          b
    ## 121 2012 UKE3    2295336          b
    ## 122 2012 UKE4    3950507          b
    ## 123 2012  UKF   14064601          b
    ## 124 2012 UKF1    5624704          b
    ## 125 2012 UKF2    3289672          b
    ## 126 2012 UKF3    5150225          b
    ## 127 2012  UKG   13840553          b
    ## 128 2012 UKG1    4502958          b
    ## 129 2012 UKG2    2888897          b
    ## 130 2012 UKG3    6448699          b
    ## 131 2012  UKH   18699192          b
    ## 132 2012 UKH1   13755880          b
    ## 133 2012 UKH2    2670062          b
    ## 134 2012 UKH3    2273249          b
    ## 135 2012  UKI   60746359          b
    ## 136 2012 UKI1   44825602          b
    ## 137 2012 UKI2   15920757          b
    ## 138 2012  UKJ   33638637          b
    ## 139 2012 UKJ1    9040586          b
    ## 140 2012 UKJ2    9963023          b
    ## 141 2012 UKJ3    9079451          b
    ## 142 2012 UKJ4    5555577          b
    ## 143 2012  UKK   46569396          b
    ## 144 2012 UKK1    9223493          b
    ## 145 2012 UKK2   11799160          b
    ## 146 2012 UKK3   13161809          b
    ## 147 2012 UKK4   12384935          b
    ## 148 2012  UKL   22423745          b
    ## 149 2012 UKL1   17273407          b
    ## 150 2012 UKL2    5150338          b
    ## 151 2012  UKM   35179443          b
    ## 152 2012 UKM2   16022706          b
    ## 153 2012 UKM3    7238996          b
    ## 154 2012 UKM5    2704858          b
    ## 155 2012 UKM6    9212882          b
    ## 156 2012  UKN    3839625          b
    ## 157 2012 UKN0    3839625          b
    ## 158 2012   LI     141042          b
    ## 159 2012  LI0     141042          b
    ## 160 2012 LI00     141042          b
    ## 161 2012   ME    9151236          b
    ## 162 2012  ME0    9151236          b
    ## 163 2012 ME00    9151236          b
    ## 164 2013 EU28 2641595112          e
    ## 165 2013 EU27 2577176820          e
    ## 166 2013   IE   28286434          e
    ## 167 2013  IE0   28286434          e
    ## 168 2013   NL   96074132          b
    ## 169 2013  NL1   12635032          b
    ## 170 2013 NL11    1323719          b
    ## 171 2013 NL12    5162879          b
    ## 172 2013 NL13    6148434          b
    ## 173 2013  NL2   18422582          b
    ## 174 2013 NL21    5490652          b
    ## 175 2013 NL22   10515234          b
    ## 176 2013 NL23    2416696          b
    ## 177 2013  NL3   43697757          b
    ## 178 2013 NL31    2763343          b
    ## 179 2013 NL32   22467095          b
    ## 180 2013 NL33    9485952          b
    ## 181 2013 NL34    8981367          b
    ## 182 2013  NL4   21318761          b
    ## 183 2013 NL41   10481395          b
    ## 184 2013 NL42   10837364          b
    ## 185 2014 EU28 2682392679          e
    ## 186 2014 EU27 2612714203          e
    ## 187 2014   IE   29166382          e
    ## 188 2014  IE0   29166382          e
    ## 189 2014 IE01    7402448          e
    ## 190 2014 IE02   21763934          e
    ## 191 2014   EL   95116396          e
    ## 192 2014  EL5   18546954          e
    ## 193 2014 EL51    2896028          e
    ## 194 2014 EL52   13626518          e
    ## 195 2014 EL53     378935          e
    ## 196 2014 EL54    1645473          e
    ## 197 2014  EL6   20966204          e
    ## 198 2014 EL61    2819744          e
    ## 199 2014 EL62   11319653          e
    ## 200 2014 EL63    1779832          e
    ## 201 2014 EL64    1642532          e
    ## 202 2014 EL65    3404443          e
    ## 203 2014  EL3    8354162          e
    ## 204 2014 EL30    8354162          e
    ## 205 2014  EL4   47249076          e
    ## 206 2014 EL41    2301571          e
    ## 207 2014 EL42   22319510          e
    ## 208 2014 EL43   22627995          e

``` r
accom1 %>% filter(flag_notes %in% c("u","bu"))%>% select(year, nuts,value, flag_notes) ##not baltic countries
```

    ##    year nuts value flag_notes
    ## 1  2007   IE    NA          u
    ## 2  2007  IE0    NA          u
    ## 3  2008   IE    NA          u
    ## 4  2008  IE0    NA          u
    ## 5  2009   IE    NA          u
    ## 6  2009  IE0    NA          u
    ## 7  2010   IE    NA          u
    ## 8  2010  IE0    NA          u
    ## 9  2010  UKL    NA          u
    ## 10 2010  UKM    NA          u
    ## 11 2011   IE    NA          u
    ## 12 2011  IE0    NA          u
    ## 13 2011 IE01    NA          u
    ## 14 2011 IE02    NA          u
    ## 15 2011  FR9    NA          u
    ## 16 2011 FR91    NA          u
    ## 17 2011 FR92    NA          u
    ## 18 2011 FR94    NA          u

``` r
accom1 = accom1 %>%
        select(-flag_notes)
```

##### 4.1.2.2 Coastal / non-coastal data

Clean to get NUTS1 - higher resolution available for some areas (parts of Finland, German, Poland) but is not consistent. However, NUTS1 does differ among countries. In Denmark, Estonia, Latvia, and Lithuania: NUTS1 is the entire country. *Note for Denmark this means non-Baltic coast is included*
In Finland, Aland is one region and the rest of the country is another.
In Sweden there are 3 regions in the entire country, and 1 region includes non-Baltic coast, all have substantial inland area.
Germany and Poland each have 2 regions that are NUTS1 that border the Baltic.

![See NUTS1 locations here](nuts1_regions_eurostat_image.png?raw=true)

``` r
## Coastal / non-coastal data
## need to remove the BHI_ID columns - these are from an old join to the BHI shapefile, not relevant now.
## need to rename columns
## these data are at multiple spatial resolutions, need to figure out finest scale resolution, export and do manually.  Differs by country. Also differs within Germany
str(accom_coast)
```

    ## 'data.frame':    4050 obs. of  57 variables:
    ##  $ TERRTYPO          : chr  "TOTAL" "TOTAL" "TOTAL" "TOTAL" ...
    ##  $ TERRTYPO_LABEL    : chr  "Total" "Total" "Total" "Total" ...
    ##  $ GEO               : chr  "HR" "HR0" "HR03" "HR04" ...
    ##  $ GEO_LABEL         : chr  "Croatia" "Hrvatska" "Jadranska Hrvatska" "Kontinentalna Hrvatska" ...
    ##  $ INDIC_TO          : chr  "B006" "B006" "B006" "B006" ...
    ##  $ INDIC_TO_LABEL    : chr  "Nights spent, total" "Nights spent, total" "Nights spent, total" "Nights spent, total" ...
    ##  $ UNIT              : chr  "NR" "NR" "NR" "NR" ...
    ##  $ UNIT_LABEL        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ NACE_R2           : chr  "I551-I553" "I551-I553" "I551-I553" "I551-I553" ...
    ##  $ NACE_R2_LABEL     : chr  "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" ...
    ##  $ TIME              : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
    ##  $ TIME_LABEL        : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
    ##  $ Value             : chr  "62183925" "62183925" "59855870" "2328055" ...
    ##  $ Flag.and.Footnotes: chr  "b" "b" "b" "b" ...
    ##  $ BHI_relevant      : chr  NA NA NA NA ...
    ##  $ BHI_ID_1          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_2          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_3          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_4          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_5          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_6          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_7          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_8          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_9          : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_10         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_11         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_12         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_13         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_14         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_15         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_16         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_17         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_18         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_19         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_20         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_21         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_22         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_23         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_24         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_25         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_26         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_27         : num  NA NA NA NA NA ...
    ##  $ BHI_ID_28         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_29         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_30         : logi  NA NA NA NA NA NA ...
    ##  $ BHI_ID_31         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_32         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_33         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_34         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_35         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_36         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_37         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_38         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_39         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_40         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_41         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ BHI_ID_42         : num  NA NA NA NA NA NA NA NA NA NA ...

``` r
accom_coast1 = accom_coast %>%
         select(-contains("BHI"),-TERRTYPO, - TIME_LABEL,-UNIT,-INDIC_TO, -NACE_R2 ) %>% ## remove BHI related columns, and other columns that are not needed
         dplyr::rename(year = TIME,
                       nuts = GEO, 
                       nuts_name = GEO_LABEL,
                       location = TERRTYPO_LABEL,
                       dat_descrip = INDIC_TO_LABEL,
                       unit = UNIT_LABEL,
                       dat_descrip2 = NACE_R2_LABEL,
                       value = Value,
                       flag_notes = Flag.and.Footnotes)%>%
          mutate(value = ifelse(value == ":", NA, value))%>%
          mutate(value = as.numeric(value))

str(accom_coast1)
```

    ## 'data.frame':    4050 obs. of  9 variables:
    ##  $ location    : chr  "Total" "Total" "Total" "Total" ...
    ##  $ nuts        : chr  "HR" "HR0" "HR03" "HR04" ...
    ##  $ nuts_name   : chr  "Croatia" "Hrvatska" "Jadranska Hrvatska" "Kontinentalna Hrvatska" ...
    ##  $ dat_descrip : chr  "Nights spent, total" "Nights spent, total" "Nights spent, total" "Nights spent, total" ...
    ##  $ unit        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ dat_descrip2: chr  "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" "Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks" ...
    ##  $ year        : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
    ##  $ value       : num  62183925 62183925 59855870 2328055 3546736 ...
    ##  $ flag_notes  : chr  "b" "b" "b" "b" ...

``` r
accom_coast %>% select(TERRTYPO, TERRTYPO_LABEL)%>% distinct()
```

    ##   TERRTYPO   TERRTYPO_LABEL
    ## 1    TOTAL            Total
    ## 2    CST_A     Coastal area
    ## 3   NCST_A Non-coastal area

``` r
## figure out which are the NUTS1 abbreviations from the other NUTS level abbreviations, select only NUTS1
accom_coast2 = accom_coast1 %>%
               mutate(country_abb = substr(nuts,1,2))%>% ## set up country abbreviation
               left_join(., eu_names, by="country_abb")%>% ## join to eu country names
               filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden", country))%>% ## select only Baltic countries to make it easier
               mutate(dat_descrip = "Nights spent total",
                      dat_descrip2 = "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" ) %>% ## fix so no commas or semi-colons
                mutate(nuts0 = substr(nuts,1,2),
                       nuts1 = substr(nuts,1,3),
                       nuts1 = ifelse(nuts0==nuts1,NA,nuts1),
                       nuts_select = ifelse(nuts1==nuts,1,0)) %>% ## select data that are NUTS1
                filter(nuts_select ==1 ) %>% 
                select(-nuts_select,-nuts,-nuts0,-nuts_name) 
               
  
                     
## check flags
accom_coast2 %>% select(flag_notes)%>%distinct() ## b
```

    ##   flag_notes
    ## 1          b
    ## 2

``` r
accom_coast2 %>% filter(flag_notes =="b") ## just for 2012 for LV and LT
```

    ##   location        dat_descrip   unit
    ## 1    Total Nights spent total Number
    ## 2    Total Nights spent total Number
    ##                                                                                                             dat_descrip2
    ## 1 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 2 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ##   year   value flag_notes country_abb   country nuts1
    ## 1 2012 3546736          b          LV    Latvia   LV0
    ## 2 2012 5741252          b          LT Lithuania   LT0

``` r
accom_coast2 = accom_coast2 %>%
               select(-flag_notes) %>%
               select(country,country_abb,nuts1,year,location,value,unit,dat_descrip,dat_descrip2)

head(accom_coast2)
```

    ##     country country_abb nuts1 year location    value   unit
    ## 1    Latvia          LV   LV0 2012    Total  3546736 Number
    ## 2 Lithuania          LT   LT0 2012    Total  5741252 Number
    ## 3   Denmark          DK   DK0 2012    Total 28040235 Number
    ## 4   Denmark          DK   DK0 2013    Total 28500837 Number
    ## 5   Denmark          DK   DK0 2014    Total 29646899 Number
    ## 6   Germany          DE   DE1 2012    Total 39595692 Number
    ##          dat_descrip
    ## 1 Nights spent total
    ## 2 Nights spent total
    ## 3 Nights spent total
    ## 4 Nights spent total
    ## 5 Nights spent total
    ## 6 Nights spent total
    ##                                                                                                             dat_descrip2
    ## 1 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 2 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 3 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 4 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 5 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 6 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks

##### 4.1.2.3 NUTS2 population data

``` r
## nuts2 population data
str(nuts2_pop_area)
```

    ## 'data.frame':    72 obs. of  13 variables:
    ##  $ BHI_ID                          : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ NUTS_ID                         : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ PopTot                          : int  116851 702394 266145 355373 175718 270701 413955 962944 605097 226701 ...
    ##  $ PopUrb                          : int  90965 657250 205041 275556 119983 225142 355931 856951 555111 150569 ...
    ##  $ PopRur                          : int  25886 45142 61102 79811 55739 45557 58027 105995 49991 76131 ...
    ##  $ PopTot_density_in_buffer_per_km2: num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ PopUrb_density_in_buffer_per_km2: num  7.82 2.26 14.1 8.5 2.94 ...
    ##  $ PopRur_density_in_buffer_per_km2: num  2.225 0.155 4.203 2.461 1.364 ...
    ##  $ CNTR_CODE                       : chr  "SE" "SE" "DK" "DK" ...
    ##  $ rgn_nam                         : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ Subbasin                        : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ HELCOM_ID                       : chr  "SEA-001" "SEA-001" "SEA-001" "SEA-001" ...
    ##  $ NUTS3_area_in_BHI_buffer_km2    : num  11636 290554 14538 32425 40858 ...

``` r
nuts2_pop_area1 = nuts2_pop_area %>%
                  select(-PopUrb,-PopRur,-PopUrb_density_in_buffer_per_km2,-PopRur_density_in_buffer_per_km2, -HELCOM_ID) %>%
                  dplyr::rename(rgn_id = BHI_ID,
                                nuts2 = NUTS_ID,
                                pop = PopTot,
                                pop_km2 = PopTot_density_in_buffer_per_km2,
                                country_abb= CNTR_CODE,
                                country = rgn_nam,
                                basin = Subbasin,
                                area = NUTS3_area_in_BHI_buffer_km2) ## this last column has NUTS3 in name, but is for NUTS2 data

str(nuts2_pop_area1)
```

    ## 'data.frame':    72 obs. of  8 variables:
    ##  $ rgn_id     : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ nuts2      : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ pop        : int  116851 702394 266145 355373 175718 270701 413955 962944 605097 226701 ...
    ##  $ pop_km2    : num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ country_abb: chr  "SE" "SE" "DK" "DK" ...
    ##  $ country    : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ basin      : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ area       : num  11636 290554 14538 32425 40858 ...

#### 4.1.3 Check NUTS2 names from Finland

Shapefiles have names from 2006, check accom1 and accom\_coast1 to see if the names have been updated, will need to fix. ![Map of old NUTS2 names for GUlf of Finland](BHI_regions_NUTS2_plot.png?raw=true)
![Map of new NUTS2 names for GUlf of Finland](new_FI_nuts2.png?raw=true)

``` r
accom1 %>% filter(grepl("FI",nuts))%>% select(nuts, nuts_name)%>% distinct()
```

    ##   nuts             nuts_name
    ## 1   FI               Finland
    ## 2  FI1          Manner-Suomi
    ## 3 FI19           Länsi-Suomi
    ## 4 FI1B      Helsinki-Uusimaa
    ## 5 FI1C           Etelä-Suomi
    ## 6 FI1D Pohjois- ja Itä-Suomi
    ## 7  FI2                 Åland
    ## 8 FI20                 Åland

``` r
## These are the newer region names : FI1B, FI1C, FI1D

accom_coast1 %>% filter(grepl("FI",nuts))%>% select(nuts, nuts_name)%>% distinct()
```

    ##   nuts             nuts_name
    ## 1   FI               Finland
    ## 2  FI1          Manner-Suomi
    ## 3 FI19           Lnsi-Suomi
    ## 4 FI1B      Helsinki-Uusimaa
    ## 5 FI1C           Etel-Suomi
    ## 6 FI1D Pohjois- ja It-Suomi
    ## 7  FI2                 land
    ## 8 FI20                 land

``` r
## These are the newer region names : FI1B, FI1C, FI1D

nuts2_pop_area1 %>% filter(grepl("FI",nuts2))%>% select(nuts2)%>% distinct()
```

    ##   nuts2
    ## 1  FI18
    ## 2  FI20
    ## 3  FI19
    ## 4  FI1A

``` r
## These are the older region names: FI18, FI1A

## Challenge because of coasts
## FI1C is associated with both the Gulf of Finland and the Aland Sea. FI1B has a small fraction associated with Aland Sea, the rest is Gulf of Finland

## Old FI18, contains both FI1C and FI1B.  May need to combine data from the new regions, and apply fraction from the older region.  Helsinki is in FI1B, which would assign almost entirely to BHI 32 and whereas FI1C would divide more equally btween BHI 36 and BHI 32. Therefore, combining these regions in order to apply the division generated from the old region may have a different result.

## old FI1A seems to be the same along the coast as the new FI1D but new FI1D covers inland areas previously in FI13

## Do this after joining accom and accom_coast with the nuts2_pop_area data, will have to add these regions back in.
```

#### 4.1.4 Check for incorrectly assigned NUTS2 regions to BHI regions and fix

Note - (as in NUTS3 assignment issues see ECO), BHI region 21 not assigned to any NUTS2 regions - despite clear association with PL63. PL63 split only between BHI 17 and BHI 18

``` r
## write to csv, fix manually, re-import csv
misassigned_nuts2 = nuts2_pop_area1 %>% select(nuts2,country,rgn_id)

#write.csv(misassigned_nuts2 , file.path(dir_tr, "misassigned_nuts2.csv"), row.names=FALSE)

## read in corrected assignments

corrected_nuts2 = read.csv(file.path(dir_tr,"misassigned_nuts2_manually_corrected.csv"),sep=";",stringsAsFactors = FALSE)


## join nuts2_pop_area1 with corrected data and fix

nuts2_pop_area2 = nuts2_pop_area1 %>%
                  full_join(., corrected_nuts2,
                            by=c("rgn_id","nuts2","country"))%>%
                 select(-country,-rgn_id,-incorrect,-BHI_ID_manual, -X.country_manual)%>%
                 dplyr::rename(country =X.correct_country,
                               rgn_id = X.correct_BH_ID)%>%
                  select(rgn_id,nuts2,country,country_abb,basin,pop,pop_km2,area) %>%
                  group_by(rgn_id, nuts2, country,country_abb,basin)%>%
                  summarise(pop =sum(pop),
                            pop_km2 = sum(pop_km2),
                            area = sum(area)) %>% ## some regions occurr twice because of correcting the assignment, sum to get single value for each region
                  ungroup()


str(nuts2_pop_area2)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    59 obs. of  8 variables:
    ##  $ rgn_id     : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ nuts2      : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ country    : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ country_abb: chr  "SE" "SE" "DK" "DK" ...
    ##  $ basin      : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ pop        : int  116851 702394 266145 355373 175718 270701 413955 1000216 605097 226701 ...
    ##  $ pop_km2    : num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ area       : num  11636 290554 14538 32425 40858 ...

### 4.2 Join datasets

#### 4.2.1 Join accom times series with nuts pop and area

Join data with inner join, this will exclude Finland areas with name mismatches. Fix Finnish data and add back into the dataset

``` r
accom_nuts1 = inner_join(accom1, nuts2_pop_area2,
                         by=c("nuts"="nuts2"))%>%
              dplyr::rename(nuts2 = nuts)

dim(accom1)##11250     8
```

    ## [1] 11250     7

``` r
dim(nuts2_pop_area2) ## 60 8
```

    ## [1] 59  8

``` r
dim(accom_nuts1) ##1400  14
```

    ## [1] 1375   14

``` r
str(accom_nuts1) ## this is now missing the Finnish data where there are name discrepancies
```

    ## 'data.frame':    1375 obs. of  14 variables:
    ##  $ year        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ nuts2       : chr  "DK01" "DK01" "DK01" "DK01" ...
    ##  $ nuts_name   : chr  "Hovedstaden" "Hovedstaden" "Hovedstaden" "Hovedstaden" ...
    ##  $ dat_descrip : chr  "Nights spent total" "Nights spent total" "Nights spent total" "Nights spent total" ...
    ##  $ unit        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ dat_descrip2: chr  "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" ...
    ##  $ value       : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ rgn_id      : int  2 6 12 15 2 3 7 9 12 3 ...
    ##  $ country     : chr  "Denmark" "Denmark" "Denmark" "Denmark" ...
    ##  $ country_abb : chr  "DK" "DK" "DK" "DK" ...
    ##  $ basin       : chr  "Kattegat" "The Sound" "Arkona Basin" "Bornholm Basin" ...
    ##  $ pop         : int  266145 1245898 1136201 44406 355373 413955 14518 24841 499769 1000216 ...
    ##  $ pop_km2     : num  18.31 106.16 201.2 5.91 10.96 ...
    ##  $ area        : num  14538 11736 5647 7517 32425 ...

``` r
## Get Finnish data renamed so that accommodating and population data match
fi_accom_newnuts = accom1 %>%
                   filter(nuts %in% c("FI1C","FI1B", "FI1D"))
fi_accom_newnuts
```

    ##    year nuts             nuts_name        dat_descrip   unit
    ## 1  1990 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 2  1990 FI1C           Etelä-Suomi Nights spent total Number
    ## 3  1990 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 4  1991 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 5  1991 FI1C           Etelä-Suomi Nights spent total Number
    ## 6  1991 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 7  1992 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 8  1992 FI1C           Etelä-Suomi Nights spent total Number
    ## 9  1992 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 10 1993 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 11 1993 FI1C           Etelä-Suomi Nights spent total Number
    ## 12 1993 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 13 1994 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 14 1994 FI1C           Etelä-Suomi Nights spent total Number
    ## 15 1994 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 16 1995 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 17 1995 FI1C           Etelä-Suomi Nights spent total Number
    ## 18 1995 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 19 1996 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 20 1996 FI1C           Etelä-Suomi Nights spent total Number
    ## 21 1996 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 22 1997 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 23 1997 FI1C           Etelä-Suomi Nights spent total Number
    ## 24 1997 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 25 1998 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 26 1998 FI1C           Etelä-Suomi Nights spent total Number
    ## 27 1998 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 28 1999 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 29 1999 FI1C           Etelä-Suomi Nights spent total Number
    ## 30 1999 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 31 2000 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 32 2000 FI1C           Etelä-Suomi Nights spent total Number
    ## 33 2000 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 34 2001 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 35 2001 FI1C           Etelä-Suomi Nights spent total Number
    ## 36 2001 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 37 2002 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 38 2002 FI1C           Etelä-Suomi Nights spent total Number
    ## 39 2002 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 40 2003 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 41 2003 FI1C           Etelä-Suomi Nights spent total Number
    ## 42 2003 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 43 2004 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 44 2004 FI1C           Etelä-Suomi Nights spent total Number
    ## 45 2004 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 46 2005 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 47 2005 FI1C           Etelä-Suomi Nights spent total Number
    ## 48 2005 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 49 2006 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 50 2006 FI1C           Etelä-Suomi Nights spent total Number
    ## 51 2006 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 52 2007 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 53 2007 FI1C           Etelä-Suomi Nights spent total Number
    ## 54 2007 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 55 2008 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 56 2008 FI1C           Etelä-Suomi Nights spent total Number
    ## 57 2008 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 58 2009 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 59 2009 FI1C           Etelä-Suomi Nights spent total Number
    ## 60 2009 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 61 2010 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 62 2010 FI1C           Etelä-Suomi Nights spent total Number
    ## 63 2010 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 64 2011 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 65 2011 FI1C           Etelä-Suomi Nights spent total Number
    ## 66 2011 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 67 2012 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 68 2012 FI1C           Etelä-Suomi Nights spent total Number
    ## 69 2012 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 70 2013 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 71 2013 FI1C           Etelä-Suomi Nights spent total Number
    ## 72 2013 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ## 73 2014 FI1B      Helsinki-Uusimaa Nights spent total Number
    ## 74 2014 FI1C           Etelä-Suomi Nights spent total Number
    ## 75 2014 FI1D Pohjois- ja Itä-Suomi Nights spent total Number
    ##                                                                                                              dat_descrip2
    ## 1  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 2  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 3  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 4  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 5  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 6  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 7  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 8  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 9  Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 10 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 11 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 12 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 13 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 14 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 15 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 16 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 17 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 18 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 19 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 20 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 21 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 22 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 23 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 24 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 25 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 26 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 27 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 28 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 29 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 30 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 31 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 32 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 33 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 34 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 35 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 36 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 37 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 38 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 39 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 40 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 41 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 42 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 43 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 44 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 45 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 46 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 47 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 48 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 49 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 50 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 51 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 52 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 53 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 54 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 55 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 56 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 57 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 58 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 59 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 60 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 61 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 62 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 63 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 64 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 65 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 66 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 67 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 68 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 69 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 70 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 71 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 72 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 73 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 74 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ## 75 Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks
    ##      value
    ## 1       NA
    ## 2       NA
    ## 3       NA
    ## 4       NA
    ## 5       NA
    ## 6       NA
    ## 7       NA
    ## 8       NA
    ## 9       NA
    ## 10      NA
    ## 11      NA
    ## 12      NA
    ## 13      NA
    ## 14      NA
    ## 15      NA
    ## 16      NA
    ## 17      NA
    ## 18      NA
    ## 19      NA
    ## 20      NA
    ## 21      NA
    ## 22      NA
    ## 23      NA
    ## 24      NA
    ## 25      NA
    ## 26      NA
    ## 27      NA
    ## 28      NA
    ## 29      NA
    ## 30      NA
    ## 31      NA
    ## 32      NA
    ## 33      NA
    ## 34      NA
    ## 35      NA
    ## 36      NA
    ## 37      NA
    ## 38      NA
    ## 39      NA
    ## 40      NA
    ## 41      NA
    ## 42      NA
    ## 43 3893556
    ## 44 2764856
    ## 45 5878889
    ## 46 4039603
    ## 47 2855012
    ## 48 6193297
    ## 49 4352332
    ## 50 3055593
    ## 51 6450557
    ## 52 4596333
    ## 53 3174401
    ## 54 6762071
    ## 55 4742367
    ## 56 3170281
    ## 57 6985724
    ## 58 4468786
    ## 59 2984620
    ## 60 6736802
    ## 61 4856835
    ## 62 3013145
    ## 63 6857807
    ## 64 5194606
    ## 65 3213509
    ## 66 6994805
    ## 67 5262273
    ## 68 3300686
    ## 69 7163485
    ## 70 5103405
    ## 71 3271657
    ## 72 7348441
    ## 73 5127059
    ## 74 3158150
    ## 75 7220641

``` r
fi_nuts_oldnuts = nuts2_pop_area2 %>%
                  filter(nuts2 %in% c("FI18","FI1A"))

fi_nuts_oldnuts
```

    ## Source: local data frame [4 x 8]
    ## 
    ##   rgn_id nuts2 country country_abb           basin     pop     pop_km2
    ##    <int> <chr>   <chr>       <chr>           <chr>   <int>       <dbl>
    ## 1     32  FI18 Finland          FI Gulf of Finland 1421112  236.949480
    ## 2     36  FI18 Finland          FI       Aland Sea  410642    1.114912
    ## 3     38  FI18 Finland          FI    Bothnian Sea    6305    1.672771
    ## 4     42  FI1A Finland          FI    Bothnian Bay  367526 2839.664384
    ## Variables not shown: area <dbl>.

``` r
## assign old nuts names to accom data
fi_accom_newnuts1 = fi_accom_newnuts %>%
                    mutate(nuts_old = ifelse(nuts == "FI1C","FI18",
                                      ifelse(nuts == "FI1B", "FI18",
                                      ifelse(nuts == "FI1D", "FI1A",""))),
                           nuts_name_old= ifelse(nuts == "FI1C" | nuts == "FI1B","old region",nuts_name ))%>%
                    select(-nuts, -nuts_name)%>%
                    dplyr::rename(nuts=nuts_old,
                                  nuts_name = nuts_name_old)%>%
                    group_by(year,nuts,nuts_name,dat_descrip,unit,dat_descrip2)%>%
                    summarise(value = sum(value))%>% ## combine all data from contributing sources into old FI unit
                    ungroup()
                        
head(fi_accom_newnuts1) ## there are NA but were NA for all regions in those years
```

    ## Source: local data frame [6 x 7]
    ## 
    ##    year  nuts             nuts_name        dat_descrip   unit
    ##   <int> <chr>                 <chr>              <chr>  <chr>
    ## 1  1990  FI18            old region Nights spent total Number
    ## 2  1990  FI1A Pohjois- ja Itä-Suomi Nights spent total Number
    ## 3  1991  FI18            old region Nights spent total Number
    ## 4  1991  FI1A Pohjois- ja Itä-Suomi Nights spent total Number
    ## 5  1992  FI18            old region Nights spent total Number
    ## 6  1992  FI1A Pohjois- ja Itä-Suomi Nights spent total Number
    ## Variables not shown: dat_descrip2 <chr>, value <dbl>.

``` r
## join fi accom to fi pop and area

fi_accom_correct_nuts = full_join(fi_accom_newnuts1, fi_nuts_oldnuts,
                          by=c("nuts"="nuts2"))%>%
                          dplyr::rename(nuts2=nuts)%>%
                          select(year,nuts2,nuts_name,dat_descrip,unit,dat_descrip2,
                                 value,rgn_id,country,country_abb,basin, pop,
                                 pop_km2,area)



### bind to rest of data
colnames(fi_accom_correct_nuts)
```

    ##  [1] "year"         "nuts2"        "nuts_name"    "dat_descrip" 
    ##  [5] "unit"         "dat_descrip2" "value"        "rgn_id"      
    ##  [9] "country"      "country_abb"  "basin"        "pop"         
    ## [13] "pop_km2"      "area"

``` r
colnames(accom_nuts1)
```

    ##  [1] "year"         "nuts2"        "nuts_name"    "dat_descrip" 
    ##  [5] "unit"         "dat_descrip2" "value"        "rgn_id"      
    ##  [9] "country"      "country_abb"  "basin"        "pop"         
    ## [13] "pop_km2"      "area"

``` r
accom_nuts2 = bind_rows(accom_nuts1, fi_accom_correct_nuts)
```

#### 4.2.2 Plot and check joined accom times series with nuts pop and area

``` r
ggplot(accom_nuts2)+
  geom_point(aes(year,value, colour=nuts2))+
  geom_line(aes(year,value, colour=nuts2))+
  facet_wrap(~country, scale="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series accommodation stays NUTS2")
```

    ## Warning: Removed 465 rows containing missing values (geom_point).

    ## Warning: Removed 459 rows containing missing values (geom_path).

![](tr_prep_files/figure-markdown_github/plot%20accom_nuts2%20joined%20data-1.png)

#### 4.2.3 Check to see if BHI regions are missing

``` r
accom_nuts2 %>% select(rgn_id)%>%distinct()%>%arrange(rgn_id)
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
    ## 20     23
    ## 21     24
    ## 22     25
    ## 23     26
    ## 24     27
    ## 25     28
    ## 26     29
    ## 27     31
    ## 28     32
    ## 29     34
    ## 30     35
    ## 31     36
    ## 32     37
    ## 33     38
    ## 34     39
    ## 35     40
    ## 36     41
    ## 37     42

``` r
## there are 37 regions

##missing: 19,21, 22,30,33

## expected missing - 19,22, and 33 from Russia
## 21 from Poland because not assigned
## 30 has no coastline
```

#### 4.2.4 Join accom\_coast data with nuts pop and area

Using Level 1, this means the Finnish mismatches are not relevant here

``` r
## Join to nuts area and population data
## first create nuts1 level for nuts pop and ear
nuts2_pop_area3 = nuts2_pop_area2 %>%
                  mutate(nuts1 = substr(nuts2,1,3),
                  nutslevel_pop = nuts2)%>%
                  select(-nuts2)
                    



## Join
accom_coast_nuts = accom_coast2 %>%
                          inner_join(., nuts2_pop_area3,
                                     by =c("country","country_abb","nuts1"))
          




## are there BHI regions missing?
accom_coast_nuts %>% select(rgn_id)%>% distinct() %>% arrange(rgn_id)
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
    ## 20     23
    ## 21     24
    ## 22     25
    ## 23     26
    ## 24     27
    ## 25     28
    ## 26     29
    ## 27     31
    ## 28     32
    ## 29     34
    ## 30     35
    ## 31     36
    ## 32     37
    ## 33     38
    ## 34     39
    ## 35     40
    ## 36     41
    ## 37     42

``` r
## 37 regions

##missing are:

## Russia 19, 22,33

## Poland no data assigned 21

## No coastal area 30
```

#### 4.2.5 Plot coastal and noncoastal stays at NUTS1 level

``` r
ggplot(accom_coast_nuts)+
  geom_point(aes(year,value, shape=location,colour=nuts1))+
  scale_shape_manual(values=c(0,17,8))+
  facet_wrap(~country)+
  ylab("Total Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Accommodation Stays by Location Type at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20coastal%20noncoastal%20stays%20nuts1-1.png)

#### 4.2.6 Plot separate countries coastal and noncoastal stays at NUTS1 level

For countries with more than 1 NUTS1 region

``` r
## Finland
ggplot(filter(accom_coast_nuts, country=="Finland"))+
  geom_point(aes(year,value, shape=location,colour=nuts1))+
  scale_shape_manual(values=c(0,17,8))+
  facet_wrap(~nuts1)+
  ylab("Total Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("FI Accommodation Stays by Location Type at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20coastal%20noncoastal%20stays%20nuts1%20countries%20separate-1.png)

``` r
## Sweden
ggplot(filter(accom_coast_nuts, country=="Sweden"))+
  geom_point(aes(year,value, shape=location,colour=nuts1))+
  scale_shape_manual(values=c(0,17,8))+
  facet_wrap(~nuts1)+
  ylab("Total Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("SE Accommodation Stays by Location Type at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20coastal%20noncoastal%20stays%20nuts1%20countries%20separate-2.png)

``` r
## Poland
ggplot(filter(accom_coast_nuts, country=="Poland"))+
  geom_point(aes(year,value, shape=location,colour=nuts1))+
  scale_shape_manual(values=c(0,17,8))+
  facet_wrap(~nuts1)+
  ylab("Total Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PL Accommodation Stays by Location Type at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20coastal%20noncoastal%20stays%20nuts1%20countries%20separate-3.png)

``` r
##Germany
ggplot(filter(accom_coast_nuts, country=="Germany"))+
  geom_point(aes(year,value, shape=location,colour=nuts1))+
  scale_shape_manual(values=c(0,17,8))+
  facet_wrap(~nuts1)+
  ylab("Total Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("DE Accommodation Stays by Location Type at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20coastal%20noncoastal%20stays%20nuts1%20countries%20separate-4.png)

### 4.3 Proportion coastal stays at the NUTS1 level

#### 4.3.1 Calculate Proportion coastal

``` r
accom_coast_nuts1 = accom_coast_nuts %>%
                    select(-dat_descrip,-dat_descrip2,-unit)%>%
                    mutate(location = ifelse(location == "Total","total",
                                      ifelse(location == "Coastal area","coastal","noncoastal")))%>%
                    spread(location,value)%>%
                    mutate(prop_coastal = coastal/total)%>%
                    select(-coastal,-total,-noncoastal, -pop,-pop_km2,-area)%>%
                    mutate(year = as.numeric(year))
```

#### 4.3.2 Plot proportion coastal NUTS1 accommodation stays

Very consistent across the three years

``` r
ggplot(accom_coast_nuts1)+
  geom_point(aes(year,prop_coastal,colour=nuts1))+
  facet_wrap(~country)+
  ylim(0,1)+
  ylab("Proportion Total Nights Coastal")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Proportion Coastal Accommodation Stays at NUTS1 level")
```

![](tr_prep_files/figure-markdown_github/plot%20nuts1%20proportion%20coastal-1.png)

#### 4.3.3 Mean proportion coastal for each NUTS1 over the three years

``` r
accom_coast_nuts2 = accom_coast_nuts1 %>%
                    select(-year,-nutslevel_pop)%>%
                    group_by(country,country_abb,nuts1,rgn_id,
                             basin)%>%
                    summarise(mean_prop_coastal = mean(prop_coastal, na.rm=TRUE))
```

#### 4.3.4 Plot Mean proportion coastal accommodation stays for each NUTS1

``` r
ggplot(accom_coast_nuts2)+
  geom_point(aes(country,mean_prop_coastal,colour=nuts1),size=2.5)+
  ylim(0,1)+
  ylab("Mean Proportion Total Nights Coastal")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Proportion Coastal Accommodation Stays at NUTS1 level (2012-2014)")
```

![](tr_prep_files/figure-markdown_github/Plot%20Mean%20proportion%20coastal%20for%20each%20NUTS1-1.png)

### 4.4 Apply proportion coastal to NUTS2 time series data

#### 4.4.1 Create a NUTS1 column for joining

``` r
str(accom_nuts2)
```

    ## 'data.frame':    1475 obs. of  14 variables:
    ##  $ year        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ nuts2       : chr  "DK01" "DK01" "DK01" "DK01" ...
    ##  $ nuts_name   : chr  "Hovedstaden" "Hovedstaden" "Hovedstaden" "Hovedstaden" ...
    ##  $ dat_descrip : chr  "Nights spent total" "Nights spent total" "Nights spent total" "Nights spent total" ...
    ##  $ unit        : chr  "Number" "Number" "Number" "Number" ...
    ##  $ dat_descrip2: chr  "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" "Hotels and holiday and other short-stay accommodation and camping grounds recreational vehicle parks and trailer parks" ...
    ##  $ value       : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ rgn_id      : int  2 6 12 15 2 3 7 9 12 3 ...
    ##  $ country     : chr  "Denmark" "Denmark" "Denmark" "Denmark" ...
    ##  $ country_abb : chr  "DK" "DK" "DK" "DK" ...
    ##  $ basin       : chr  "Kattegat" "The Sound" "Arkona Basin" "Bornholm Basin" ...
    ##  $ pop         : int  266145 1245898 1136201 44406 355373 413955 14518 24841 499769 1000216 ...
    ##  $ pop_km2     : num  18.31 106.16 201.2 5.91 10.96 ...
    ##  $ area        : num  14538 11736 5647 7517 32425 ...

``` r
accom_nuts3 = accom_nuts2 %>%
              mutate(nuts1 = substr(nuts2,1,3))
```

#### 4.4.2 Join timeseries and mean proportion coastal

``` r
accom_nuts4 = inner_join(accom_nuts3,accom_coast_nuts2,
                        by=c("country","country_abb","basin","rgn_id","nuts1"))%>%
              filter(year>=2000) %>% ## select only data from 2000 onwards
              select(country,country_abb,nuts1,nuts2,nuts_name,
                     rgn_id,basin,year,value,mean_prop_coastal,pop,pop_km2,area)%>%
              dplyr::rename(night_stays = value)
```

#### 4.4.3 Apply proportional coastal to the times series

``` r
accom_nuts5 = accom_nuts4%>%
              mutate(night_stays_coastal = night_stays * mean_prop_coastal)
```

#### 4.4.4 Plot coastal night stays times series

``` r
ggplot(accom_nuts5)+
  geom_point(aes(year,night_stays_coastal,colour=nuts1))+
  facet_wrap(~country)+
  ylab("Coastal Total Night Stays NUTS2")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Coastal Total Night Stays NUTS2 level")
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/Plot%20coastal%20night%20stays%20times%20series-1.png)

### 4.5 Determine NUTS2 population allocation among BHI regions

#### 4.5.1 Identify total NUTS2 population in the 25km buffer

Sum across BHI regions associated with a NUTS2. This is the same for all years as population data comes from a single year.

``` r
nuts2_buffer_pop= accom_nuts5 %>%
                  select(nuts2,pop,area)%>%
                  distinct()%>% ## because duplicated for each year
                  group_by(nuts2)%>%
                  summarise(pop_nuts2 = sum(pop),
                            area_nuts2 = sum(area))%>%
                  ungroup()
```

#### 4.5.2 Join the total NUTS2 area and population to the per BHI region data

``` r
accom_nuts6  = nuts2_buffer_pop %>%
                  full_join(., accom_nuts5, by="nuts2")
```

#### 4.5.3 Calculate the population fraction in a BHI region from a NUTS2 out of the NUTS2 total buffer population

``` r
accom_nuts6 = accom_nuts6 %>%
              mutate(bhi_pop_prop = pop / pop_nuts2)
```

#### 4.5.4 Plot the population fraction for each region

``` r
ggplot(accom_nuts6)+
  geom_point(aes(country,bhi_pop_prop,colour=nuts1))+
  facet_wrap(~rgn_id)+
  ylab("Population proportion")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("Proportion of NUTS2 population for each BHI region")
```

![](tr_prep_files/figure-markdown_github/plot%20the%20population%20fraction%20for%20bhi%20regions-1.png)

``` r
ggplot(accom_nuts6)+
  geom_point(aes(rgn_id,bhi_pop_prop,colour=nuts1))+
  facet_wrap(~country)+
  ylab("Population proportion")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("Proportion of NUTS2 population for each BHI region")
```

![](tr_prep_files/figure-markdown_github/plot%20the%20population%20fraction%20for%20bhi%20regions-2.png)

#### 4.6 Calculate BHI night stays

#### 4.6.1 Caclulate stays in BHI regions based on population allocation

``` r
accom_nuts7 = accom_nuts6 %>%
              select(-pop_nuts2,-area_nuts2,-nuts1,-nuts2,-nuts_name,-night_stays,-mean_prop_coastal,
                     pop,-pop_km2,-area) %>%
              mutate(night_stays_coastal_allocated = night_stays_coastal * bhi_pop_prop) %>%
              select(-night_stays_coastal,-bhi_pop_prop)%>%
              group_by(country,country_abb,basin, rgn_id,year)%>%
              summarise(bhi_coastal_stays = sum(night_stays_coastal_allocated),
                        bhi_pop = sum(pop, na.rm=TRUE))%>%
              ungroup()%>%
              mutate(bhi_coastal_stays_per_cap = bhi_coastal_stays/bhi_pop)
              
head(accom_nuts7)
```

    ## Source: local data frame [6 x 8]
    ## 
    ##   country country_abb        basin rgn_id  year bhi_coastal_stays bhi_pop
    ##     <chr>       <chr>        <chr>  <int> <int>             <dbl>   <int>
    ## 1 Denmark          DK Arkona Basin     12  2000           3361141 1635970
    ## 2 Denmark          DK Arkona Basin     12  2001           3398123 1635970
    ## 3 Denmark          DK Arkona Basin     12  2002           3455499 1635970
    ## 4 Denmark          DK Arkona Basin     12  2003           3482953 1635970
    ## 5 Denmark          DK Arkona Basin     12  2004           3611861 1635970
    ## 6 Denmark          DK Arkona Basin     12  2005           3755690 1635970
    ## Variables not shown: bhi_coastal_stays_per_cap <dbl>.

#### 4.6.2 Plot BHI night stays

``` r
ggplot(accom_nuts7)+
  geom_point(aes(year,bhi_coastal_stays))+
  facet_wrap(~rgn_id, scales="free_y")+
  ylab("Number of Nights")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("BHI Coastal Stays")
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20bhi%20night%20stays-1.png)

``` r
ggplot(accom_nuts7)+
  geom_point(aes(year,bhi_coastal_stays_per_cap))+
  facet_wrap(~rgn_id, scales="free_y")+
  ylab("Number of Nights Per Capita")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("BHI Coastal Stays Per Capita")
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20bhi%20night%20stays-2.png)

``` r
ggplot(accom_nuts7)+
  geom_point(aes(year,bhi_coastal_stays_per_cap, colour=factor(rgn_id)))+
  facet_wrap(~country, scales="free_y")+
  ylab("Number of Nights Per Capita")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("BHI Coastal Stays Per Capita")
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20bhi%20night%20stays-3.png)

5. Prepare and Save Data Layers
-------------------------------

Use per capita night stays \#\#\# 5.1 Prepare layer

``` r
tr_layer = accom_nuts7 %>%
            select(rgn_id,year,bhi_coastal_stays_per_cap)%>%
            arrange(rgn_id,year)

## check max year
tr_layer %>% select(rgn_id,year)%>% filter(!is.na(year)) %>% group_by(rgn_id) %>% summarise(max_year= max(year)) %>% ungroup() %>% print(n=42)
```

    ## Source: local data frame [37 x 2]
    ## 
    ##    rgn_id max_year
    ##     <int>    <int>
    ## 1       1     2014
    ## 2       2     2014
    ## 3       3     2014
    ## 4       4     2014
    ## 5       5     2014
    ## 6       6     2014
    ## 7       7     2014
    ## 8       8     2014
    ## 9       9     2014
    ## 10     10     2014
    ## 11     11     2014
    ## 12     12     2014
    ## 13     13     2014
    ## 14     14     2014
    ## 15     15     2014
    ## 16     16     2014
    ## 17     17     2014
    ## 18     18     2014
    ## 19     20     2014
    ## 20     23     2014
    ## 21     24     2014
    ## 22     25     2014
    ## 23     26     2014
    ## 24     27     2014
    ## 25     28     2014
    ## 26     29     2014
    ## 27     31     2014
    ## 28     32     2014
    ## 29     34     2014
    ## 30     35     2014
    ## 31     36     2014
    ## 32     37     2014
    ## 33     38     2014
    ## 34     39     2014
    ## 35     40     2014
    ## 36     41     2014
    ## 37     42     2014

``` r
## last year is 2014 for all regions!
```

### 5.2 Write layer to csv

``` r
write.csv(tr_layer, file.path(dir_layers,"tr_accommodation_stays_bhi2015.csv"),row.names = FALSE)
```

6. Explore Status and Trend calculation
---------------------------------------

Moving window reference \#\#\# 6.1 Read in layers

``` r
tr_layer 
```

    ## Source: local data frame [555 x 3]
    ## 
    ##    rgn_id  year bhi_coastal_stays_per_cap
    ##     <int> <int>                     <dbl>
    ## 1       1  2000                  7.741518
    ## 2       1  2001                  7.972017
    ## 3       1  2002                  8.525023
    ## 4       1  2003                  9.085089
    ## 5       1  2004                  8.706518
    ## 6       1  2005                  8.961763
    ## 7       1  2006                  9.485306
    ## 8       1  2007                  9.541751
    ## 9       1  2008                  9.387226
    ## 10      1  2009                  9.745505
    ## ..    ...   ...                       ...

### 6.2 Set Parameters

``` r
# set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend
```

### 6.3 Calculate status

``` r
## calculate status time series
tr_status_score = tr_layer %>%
    dplyr::rename(nights = bhi_coastal_stays_per_cap) %>%
    filter(!is.na(nights)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(nights, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = nights/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value)%>%
    mutate(status = pmin(1,rgn_value)) ## if regions have no data, are not included here, final year will be included below

 ## select last year of data in timeseries for status
  tr_status = tr_status_score %>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id, status) %>%  #this will be all same year because of code above selecting the max year
    full_join(bhi_rgn, .,by="rgn_id")%>% #all regions now listed, have NA for for status
    mutate(score = status*100,
            dimension = 'status') %>% ##scale to 0 to 100
     select(region_id = rgn_id,score, dimension)
```

### 6.4 Plot Status

``` r
## plot tr status time series
ggplot(tr_status_score)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(0,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("TR status time series")
```

![](tr_prep_files/figure-markdown_github/plot%20tr%20status-1.png)

``` r
## plot tr status time series, less range on y-axis
ggplot(tr_status_score)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(.8,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("TR status time series - different y-axis range")
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20tr%20status-2.png)

``` r
## plot final year (2014) status

ggplot(tr_status)+
  geom_point(aes(region_id,score), size=2)+
  ylim(0,100)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("TR status score in 2014")
```

    ## Warning: Removed 5 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20tr%20status-3.png)

### 6.5 Calculate Trend

``` r
  ## calculate trend for 5 years (5 data points)
  ## years are filtered tr_status_score
      tr_trend = tr_status_score %>%
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

### 6.6 Plot trend

``` r
ggplot(tr_trend)+
  geom_point(aes(region_id,score), size=2)+
  geom_hline(yintercept = 0)+
  ylim(-1,1)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("TR 5 yr trend score")
```

    ## Warning: Removed 5 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20tr%20trend-1.png)

### 6.7Plot trend and status together

``` r
plot_tr = bind_rows(tr_status,tr_trend)

ggplot(plot_tr)+
  geom_point(aes(region_id,score),size=2.5)+
  facet_wrap(~dimension, scales = "free_y")+
  ylab("Score")+
  ggtitle("TR Status and Trend")
```

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](tr_prep_files/figure-markdown_github/plot%20tr%20trend%20and%20status%20together-1.png)

7. Issues or Concerns
---------------------

### 7.1 Shapefile assignment issues

#### 7.2.1 Able to fix manually

See \#\#\#\# 4.1.4 \#\#\#\# 7.2.2 Not able to fix mannually BHI region 21 not assigned to any NUTS2 regions - despite clear association with PL63. PL63 split only between BHI 17 and BHI 18

### 7.2 Name discrepancies between datasets

#### 7.2.1 Finnish NUTS2 renamed

See \#\#\#\# 4.1.3 Shapefiles have names from 2006, accommodation datasets have newer names ![Map of old NUTS2 names for GUlf of Finland](BHI_regions_NUTS2_plot.png?raw=true)
![Map of new NUTS2 names for GUlf of Finland](new_FI_nuts2.png?raw=true)

Challenge because of coasts: New FI1C is associated with both the Gulf of Finland and the Aland Sea. New FI1B has a small fraction associated with Aland Sea, the rest is Gulf of Finland. Old FI18, contains both FI1C and FI1B.

Old FI1A seems to be the same along the coast as the new FI1D but new FI1D covers inland areas previously in FI13

Solution: Combine data from the new regions (FI1C and FI1B), and apply population fraction from the older region (FI18). Apply FI1A old fraction to new (FI1D)

Downsides to this solution: Helsinki is in FI1B, which would assign almost entirely to BHI 32 and whereas FI1C would divide more equally btween BHI 36 and BHI 32. Therefore, combining these regions in order to apply the division generated from the old region may have a different result.

### 7.3 Spatial resolution of coastal allocation.

Differs among countries. Within Germany, NUTS area available differs.
