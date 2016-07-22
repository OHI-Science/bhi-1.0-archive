mar\_rep
================

-   [Preparation of Mariculture (MAR) subgoal data layer](#preparation-of-mariculture-mar-subgoal-data-layer)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Data sources](#data-sources)
        -   [2.2 Production regions and BHI assignments](#production-regions-and-bhi-assignments)
    -   [3. Data Layer Preparation](#data-layer-preparation)
        -   [3.1 Read in data](#read-in-data)
        -   [3.1 Plot the data by country's mar\_region](#plot-the-data-by-countrys-mar_region)
        -   [3.2 FAO data](#fao-data)
        -   [4.3 Combined country production data and FAO data for Germany](#combined-country-production-data-and-fao-data-for-germany)
        -   [4.4 Use mar\_lookup to allocate production among BHI regions](#use-mar_lookup-to-allocate-production-among-bhi-regions)
        -   [4.5 Create objects to save to put in layers, save a csv](#create-objects-to-save-to-put-in-layers-save-a-csv)
        -   [Population density data](#population-density-data)
    -   [MAR Goal Model](#mar-goal-model)
    -   [Calculate MAR status and trend](#calculate-mar-status-and-trend)
    -   [Plot status and trend as a figure](#plot-status-and-trend-as-a-figure)
    -   [Plot MAR status time series](#plot-mar-status-time-series)
    -   [Plot status as a map](#plot-status-as-a-map)

Preparation of Mariculture (MAR) subgoal data layer
===================================================

``` r
## source common libraries, directories, functions, etc
# Libraries
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
## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')

source('~/github/bhi/baltic2015/prep/common.r')
dir_mar    = file.path(dir_prep, 'MAR')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_mar, 'mar_prep.rmd')
```

1. Background
-------------

2. Data
-------

Rainbow trout production
Date were compiled primarily by Ginnette Flores Carmenate

### 2.1 Data sources

Data from country databases or reports
**Sweden** \[Jorbruksverket\] (<http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Jord--och-skogsbruk-fiske/Vattenbruk/Vattenbruk/>)

**Denmark** [Danish Agrifish Agency (Ministry of Environment and Food of Denmark)](http://agrifish.dk/fisheries/fishery-statistics/aquaculture-statistics/#c32851)

**On locations from NaturErhvervstyrelsen** The North Sea is very rough, hence there is no sea farms located in the North Sea side of Denmark, and the data on our home page only includes farms placed in the waters you are interested in. There is a map in this [report](http://www.akvakultur.dk/akvakultur%20i%20DK.htm) showing sea farms in Denmark. It’s a bit old (2003), but area wise it haven’t changed much.

Finland [Natural Resources Institute](http://statdb.luke.fi/PXWeb/pxweb/fi/LUKE/LUKE__06%20Kala%20ja%20riista__02%20Rakenne%20ja%20tuotanto__10%20Vesiviljely/?tablelist=true&rxid=5211d344-451e-490d-8651-adb38df626e1)

--Data were available as total marine production by region. Data were also available as total production per fish species. Rainbow trout dominated the total fish production. Ginnette converted the total production by region to rainbow trout production by region by using the country wide percent rainbow trout of the marine production in each year. (The other minor contributions to total production were European whitefish, Trout, other species, Roe of rainbow trout, roe of european whitefish).

**All other** Production data for Germany were obtained from the [FAO FishStatJ](http://www.fao.org/fishery/statistics/software/fishstatj/en#downlApp) Global workspace, Aquaculture Production (Quantities and values) 1950-2014 (Release date: March 2016).
Download 15 June 2016

Data were downloaded for all nine Baltic countries. The Baltic sea falls within the [aquaculture area to 'Atlantic, Northeast'](http://www.fao.org/fishery/cwp/handbook/h/en). The environment type was required to be *Brackish* to be considered Baltic Sea production.

Sustainability Coefficient The SMI is the average of the three subindices traditionally used in the OHI framework. Trujillo's study included 13 subindices in total but only 3 of them are relevant for assessing the sustainability of mariculture : waster water treatment, usage of fishmeal and hatchery vs wild origin of seeds. Since Rainbow trout SMI is only included for Sweden. The mean value 5.3 was rescaled between 0-1 to 0.53. This value is then applied to Denmark and Finland.

Trujillo, P., (2008). Using a mariculture sustainability index to rank countries’ performance. Pp. 28-56 In: Alder, J. and D. Pauly (eds.). 2008. A comparative assessment of biodiversity, fisheries and aquaculture in 53 countries’ Exclusive Economic Zones.’ Fisheries Centre Research Reports. Fisheries Centre, University of British Columbia

### 2.2 Production regions and BHI assignments

BHI regions were assigned to the country production reporting regions by Ginnette visually linking the two for Sweden, Denmark, and Finland.

Production for Germany was split equally among all German BHI regions.

#### 2.2.1 HELCOM map of coastal aquaculture

[HELCOM Map Service Baltic Sea Pressures and Human activities](http://maps.helcom.fi/website/Pressures/index.html) has a data layer showing coastal aquaculture sites (under 'Pressures','Land-based pollution', 'Coastal Aquaculture'). This appears to be outdated as Denmark say is has no marine aquaculture, Latvia has no reported brackish aquaculture to the FAO for several decades, and no German sites are shown (although minimal brackish water aquaculture is reported)

3. Data Layer Preparation
-------------------------

Data are stored in the BHI database
`mar_prep_database_call.r` extracts data files from the database and stores data as csv files in folder mar\_data\_database
**Need to make sure csv files are rewritten if database updated!!**

### 3.1 Read in data

``` r
##-------------------------##
## Read in data

lookup =  read.csv(file.path(dir_mar, 'mar_data_database/mar_data_lookuptable.csv'), sep=";")
head(lookup)
```

    ##   country      mar_region BHI
    ## 1  Sweden Norra ostkusten  41
    ## 2  Sweden Norra ostkusten  39
    ## 3  Sweden Norra ostkusten  37
    ## 4  Sweden Sodra ostkusten  35
    ## 5  Sweden Sodra ostkusten  29
    ## 6  Sweden Sodra ostkusten  26

``` r
production = read.csv(file.path(dir_mar,'mar_data_database/mar_data_production.csv'))
 head(production)
```

    ##   X country  mar_region year production unit          latin_name
    ## 1 1 Denmark Hovedstaden 2006       2071  ton Oncorhynchus mykiss
    ## 2 2 Denmark Hovedstaden 2007       2364  ton Oncorhynchus mykiss
    ## 3 3 Denmark Hovedstaden 2008       2288  ton Oncorhynchus mykiss
    ## 4 4 Denmark Hovedstaden 2009         NA  ton Oncorhynchus mykiss
    ## 5 5 Denmark Hovedstaden 2010         NA  ton Oncorhynchus mykiss
    ## 6 6 Denmark Hovedstaden 2011         NA  ton Oncorhynchus mykiss
    ##     common_name ISSCAAP_FAO TAXOCODE_FAO X3A_CODE_FAO country_spp_code
    ## 1 Rainbow Trout          23   1230100909          TRR              216
    ## 2 Rainbow Trout          23   1230100909          TRR              216
    ## 3 Rainbow Trout          23   1230100909          TRR              216
    ## 4 Rainbow Trout          23   1230100909          TRR              216
    ## 5 Rainbow Trout          23   1230100909          TRR              216
    ## 6 Rainbow Trout          23   1230100909          TRR              216
    ##   Sust_coeff Notes BHI_ID_1 BHI_ID_2 BHI_ID_3 BHI_ID_4 BHI_ID_5 BHI_ID_6
    ## 1       0.53             NA        1       NA       NA       NA        1
    ## 2       0.53             NA        1       NA       NA       NA        1
    ## 3       0.53             NA        1       NA       NA       NA        1
    ## 4       0.53             NA        1       NA       NA       NA        1
    ## 5       0.53             NA        1       NA       NA       NA        1
    ## 6       0.53             NA        1       NA       NA       NA        1
    ##   BHI_ID_7 BHI_ID_8 BHI_ID_9 BHI_ID_10 BHI_ID_11 BHI_ID_12 BHI_ID_13
    ## 1       NA       NA       NA        NA        NA         1        NA
    ## 2       NA       NA       NA        NA        NA         1        NA
    ## 3       NA       NA       NA        NA        NA         1        NA
    ## 4       NA       NA       NA        NA        NA         1        NA
    ## 5       NA       NA       NA        NA        NA         1        NA
    ## 6       NA       NA       NA        NA        NA         1        NA
    ##   BHI_ID_14 BHI_ID_15 BHI_ID_16 BHI_ID_17 BHI_ID_18 BHI_ID_19 BHI_ID_20
    ## 1        NA         1        NA        NA        NA        NA        NA
    ## 2        NA         1        NA        NA        NA        NA        NA
    ## 3        NA         1        NA        NA        NA        NA        NA
    ## 4        NA         1        NA        NA        NA        NA        NA
    ## 5        NA         1        NA        NA        NA        NA        NA
    ## 6        NA         1        NA        NA        NA        NA        NA
    ##   BHI_ID_21 BHI_ID_22 BHI_ID_23 BHI_ID_24 BHI_ID_25 BHI_ID_26 BHI_ID_27
    ## 1        NA        NA        NA        NA        NA        NA        NA
    ## 2        NA        NA        NA        NA        NA        NA        NA
    ## 3        NA        NA        NA        NA        NA        NA        NA
    ## 4        NA        NA        NA        NA        NA        NA        NA
    ## 5        NA        NA        NA        NA        NA        NA        NA
    ## 6        NA        NA        NA        NA        NA        NA        NA
    ##   BHI_ID_28 BHI_ID_29 BHI_ID_30 BHI_ID_31 BHI_ID_32 BHI_ID_33 BHI_ID_34
    ## 1        NA        NA        NA        NA        NA        NA        NA
    ## 2        NA        NA        NA        NA        NA        NA        NA
    ## 3        NA        NA        NA        NA        NA        NA        NA
    ## 4        NA        NA        NA        NA        NA        NA        NA
    ## 5        NA        NA        NA        NA        NA        NA        NA
    ## 6        NA        NA        NA        NA        NA        NA        NA
    ##   BHI_ID_35 BHI_ID_36 BHI_ID_37 BHI_ID_38 BHI_ID_39 BHI_ID_40 BHI_ID_41
    ## 1        NA        NA        NA        NA        NA        NA        NA
    ## 2        NA        NA        NA        NA        NA        NA        NA
    ## 3        NA        NA        NA        NA        NA        NA        NA
    ## 4        NA        NA        NA        NA        NA        NA        NA
    ## 5        NA        NA        NA        NA        NA        NA        NA
    ## 6        NA        NA        NA        NA        NA        NA        NA
    ##   BHI_ID_42
    ## 1        NA
    ## 2        NA
    ## 3        NA
    ## 4        NA
    ## 5        NA
    ## 6        NA

``` r
fao = read.csv(file.path(dir_mar, 'mar_data_database/all_baltic_fao_cleaned.csv'), sep=";")
head(fao)
```

    ##              country   species_ASFIS
    ## 1             Sweden     Blue mussel
    ## 2 Russian Federation Sea mussels nei
    ## 3            Denmark    European eel
    ## 4            Denmark    European eel
    ## 5            Germany          Turbot
    ## 6            Germany Clams, etc. nei
    ##   aquaculture_area_FAO_major_fishing_area   environment unit X1950 X1951
    ## 1                     Atlantic, Northeast        Marine    t   500   500
    ## 2                     Atlantic, Northeast        Marine    t            
    ## 3                     Atlantic, Northeast        Marine    t            
    ## 4                     Atlantic, Northeast Brackishwater    t            
    ## 5                     Atlantic, Northeast        Marine    t            
    ## 6                     Atlantic, Northeast        Marine    t            
    ##   X1952 X1953 X1954 X1955 X1956 X1957 X1958 X1959 X1960 X1961 X1962 X1963
    ## 1   600   300   300   300   400   400   500   600   500   500   800   800
    ## 2                                                                        
    ## 3                                                                        
    ## 4                                                                        
    ## 5                                                                        
    ## 6                                                                        
    ##   X1964 X1965 X1966 X1967 X1968 X1969 X1970 X1971 X1972 X1973 X1974 X1975
    ## 1   600   500   700   500   500   400   200   100     0     0    58    32
    ## 2                                                                        
    ## 3                                                                        
    ## 4                                                                        
    ## 5                                                                        
    ## 6                                                                        
    ##   X1976 X1977 X1978 X1979 X1980 X1981 X1982 X1983 X1984 X1985 X1986 X1987
    ## 1    42    30    45    41    39   557  1548  1580  1278   415   325  2556
    ## 2                                                    NA    NA    NA    NA
    ## 3                                                     0     0     0     0
    ## 4                                                    NA    NA    NA    NA
    ## 5                                                    NA    NA    NA    NA
    ## 6                                                     0     0     0     0
    ##   X1988 X1989 X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999
    ## 1   858   241  1163  1643  1353   737  2095  1521  1821  1425   455   925
    ## 2     0     0     0     0     0    56    35   300   600   700   200   100
    ## 3     0     0     0     0     0     0     0     0     0     0     0     0
    ## 4    NA    NA    NA          NA          NA    NA    NA    NA    NA    NA
    ## 5    NA     1     1     0     0     0     0     0     0     0     0     0
    ## 6     0     0     0     0     0     0     0  1191   110     0     0     0
    ##   X2000 X2001 X2002 X2003 X2004 X2005 X2006 X2007 X2008  X2009  X2010
    ## 1   443  1444  1382  1742  1435  1069  1791  1168  1911   2125   1382
    ## 2    98   101    55     0     0     0     0     0     0      0      0
    ## 3     0     0   145   103   104    71   918   742    82 1021.8 1000 F
    ## 4    NA    NA    NA    43    44   720    NA     0     0      0       
    ## 5     0     0     2    NA    58    68    60    60     0      0      0
    ## 6     0     0     0     0     0     0     0     0     0      0      0
    ##   X2011 X2012 X2013 X2014
    ## 1  1470  1308  1702  1746
    ## 2     0     0   800   600
    ## 3 800 F 661.1            
    ## 4                        
    ## 5                        
    ## 6     0     0     0

### 3.1 Plot the data by country's mar\_region

Data from country databases (DK, FI, SE)
This is the scale of data reported

``` r
ggplot(production)+geom_point(aes(year, production)) +
facet_wrap(~mar_region, scales="free_y")
```

    ## Warning: Removed 15 rows containing missing values (geom_point).

![](mar_prep_files/figure-markdown_github/plot%20raw%20data-1.png)

### 3.2 FAO data

Evaluate FAO data for countries without data from country specific databases.
1. Is there brackish production between 2005 - 2014?
2. Is it rainbow trout or similar?

#### 3.2.1 FAO data organization

``` r
## filter country and environment
fao1 = fao %>%
        filter(country != "Sweden" & country != "Finland" & country != "Denmark")%>% ## filter out countries with national data
        filter(environment == "Brackishwater") ## select only brackish water production

## restrict columns to years of interest
fao2 = fao1 %>%
       select(country:unit,X2005:X2014)

str(fao2) ## mix of integer and factor in columns ## F indicates "estimated"
```

    ## 'data.frame':    3 obs. of  15 variables:
    ##  $ country                                : Factor w/ 10 levels "Denmark","Estonia",..: 4 4 7
    ##  $ species_ASFIS                          : Factor w/ 60 levels "","Arctic char",..: 25 44 29
    ##  $ aquaculture_area_FAO_major_fishing_area: Factor w/ 3 levels "","Atlantic, Northeast",..: 2 2 3
    ##  $ environment                            : Factor w/ 4 levels "","Brackishwater",..: 2 2 2
    ##  $ unit                                   : Factor w/ 2 levels "","t": 2 2 2
    ##  $ X2005                                  : int  25 21 NA
    ##  $ X2006                                  : int  15 20 NA
    ##  $ X2007                                  : Factor w/ 77 levels "","0","1","1000",..: 15 26 1
    ##  $ X2008                                  : Factor w/ 79 levels "","0","1","10",..: 2 40 1
    ##  $ X2009                                  : Factor w/ 98 levels "","0","0.1","0.1 F",..: 2 26 1
    ##  $ X2010                                  : Factor w/ 97 levels "","0","0.04",..: 2 28 1
    ##  $ X2011                                  : Factor w/ 99 levels "","0","0.03",..: 1 49 1
    ##  $ X2012                                  : Factor w/ 103 levels "","0","0.02",..: 1 56 1
    ##  $ X2013                                  : Factor w/ 105 levels "","0","0.01",..: 1 44 1
    ##  $ X2014                                  : Factor w/ 105 levels "","0","0.02",..: 1 42 1

``` r
## make all data columns character; gather
fao3 = fao2 %>%
       mutate(X2005 = as.character(X2005),
              X2006 = as.character(X2006),
              X2007 = as.character(X2007),
              X2008 = as.character(X2008),
              X2009 = as.character(X2009),
              X2010 = as.character(X2010),
              X2011 = as.character(X2011),
              X2012 = as.character(X2012),
              X2013 = as.character(X2013),
              X2014 = as.character(X2014)) %>%
       gather(year,production,-country,-species_ASFIS,-aquaculture_area_FAO_major_fishing_area,-environment,-unit)%>%
      mutate(data_flag = ifelse(grepl("F",production),"estimated",""))%>% ##note the estimated data
      mutate(production = str_replace(production,"F","")) %>% ## remove characters from production
     mutate(production = as.numeric(production))%>% # make into number
      mutate(year =str_replace(year,"X",""),
             year= as.numeric(year))%>% ## remove x from year and make numeric
      arrange(country, year, species_ASFIS)
```

#### 3.2.2 Plot FAO data for countries with data 2005-2014

``` r
ggplot(fao3)+
  geom_point(aes(year,production, colour= species_ASFIS))+
  facet_wrap(~country)+
  ggtitle("FAO Brackish water production (tons) 2005-2014")
```

    ## Warning: Removed 14 rows containing missing values (geom_point).

![](mar_prep_files/figure-markdown_github/plot%20fao%20data%20raw-1.png)

#### 4.2.3 Select Germany rainbow trout timeseries

``` r
fao_de = fao3 %>%
        filter(country=="Germany" & species_ASFIS =="Rainbow trout") %>%
        mutate(country= as.character(country),
               species_ASFIS = as.character(species_ASFIS),
               aquaculture_area_FAO_major_fishing_area = as.character(aquaculture_area_FAO_major_fishing_area),
               environment = as.character(environment),
               unit = as.character(unit))
str(fao_de)
```

    ## 'data.frame':    10 obs. of  8 variables:
    ##  $ country                                : chr  "Germany" "Germany" "Germany" "Germany" ...
    ##  $ species_ASFIS                          : chr  "Rainbow trout" "Rainbow trout" "Rainbow trout" "Rainbow trout" ...
    ##  $ aquaculture_area_FAO_major_fishing_area: chr  "Atlantic, Northeast" "Atlantic, Northeast" "Atlantic, Northeast" "Atlantic, Northeast" ...
    ##  $ environment                            : chr  "Brackishwater" "Brackishwater" "Brackishwater" "Brackishwater" ...
    ##  $ unit                                   : chr  "t" "t" "t" "t" ...
    ##  $ year                                   : num  2005 2006 2007 2008 2009 ...
    ##  $ production                             : num  21 20 20 22 14 14 26 30 22 20
    ##  $ data_flag                              : chr  "" "" "" "" ...

### 4.3 Combined country production data and FAO data for Germany

``` r
## select only production columns (no BHI_ID columns)
production1 = production %>%
              select(country:Sust_coeff)

colnames(production1)
```

    ##  [1] "country"          "mar_region"       "year"            
    ##  [4] "production"       "unit"             "latin_name"      
    ##  [7] "common_name"      "ISSCAAP_FAO"      "TAXOCODE_FAO"    
    ## [10] "X3A_CODE_FAO"     "country_spp_code" "Sust_coeff"

``` r
## rename fao_de columns
fao_de = fao_de %>%
         select(-species_ASFIS,-aquaculture_area_FAO_major_fishing_area,-environment,-data_flag)%>%
         mutate(mar_region = "FAO_Germany",
                unit = "ton",
                latin_name = "Oncorhynchus mykiss",
                common_name = "Rainbow Trout",
                ISSCAAP_FAO = 23,
                TAXOCODE_FAO = 1230100909,
                X3A_CODE_FAO = "TRR",
                country_spp_code = NA,
                Sust_coeff = 0.53)%>%
        select(country, mar_region,year, production,unit,latin_name,common_name,
               ISSCAAP_FAO, TAXOCODE_FAO,X3A_CODE_FAO,country_spp_code,Sust_coeff )
str(fao_de)
```

    ## 'data.frame':    10 obs. of  12 variables:
    ##  $ country         : chr  "Germany" "Germany" "Germany" "Germany" ...
    ##  $ mar_region      : chr  "FAO_Germany" "FAO_Germany" "FAO_Germany" "FAO_Germany" ...
    ##  $ year            : num  2005 2006 2007 2008 2009 ...
    ##  $ production      : num  21 20 20 22 14 14 26 30 22 20
    ##  $ unit            : chr  "ton" "ton" "ton" "ton" ...
    ##  $ latin_name      : chr  "Oncorhynchus mykiss" "Oncorhynchus mykiss" "Oncorhynchus mykiss" "Oncorhynchus mykiss" ...
    ##  $ common_name     : chr  "Rainbow Trout" "Rainbow Trout" "Rainbow Trout" "Rainbow Trout" ...
    ##  $ ISSCAAP_FAO     : num  23 23 23 23 23 23 23 23 23 23
    ##  $ TAXOCODE_FAO    : num  1.23e+09 1.23e+09 1.23e+09 1.23e+09 1.23e+09 ...
    ##  $ X3A_CODE_FAO    : chr  "TRR" "TRR" "TRR" "TRR" ...
    ##  $ country_spp_code: logi  NA NA NA NA NA NA ...
    ##  $ Sust_coeff      : num  0.53 0.53 0.53 0.53 0.53 0.53 0.53 0.53 0.53 0.53

``` r
### bind_rows of production and fao_de

production2 = bind_rows(production1, fao_de)
```

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

    ## Warning in bind_rows_(x, .id): binding factor and character vector,
    ## coercing into character vector

#### 4.3.1 Plot combined data by country

``` r
ggplot(production2)+
  geom_point(aes(year,production, colour=mar_region))+
  geom_line(aes(year,production, colour=mar_region))+
  facet_wrap(~country, scales="free_y")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Rainbow Trout Production by Country")
```

    ## Warning: Removed 15 rows containing missing values (geom_point).

    ## Warning: Removed 10 rows containing missing values (geom_path).

![](mar_prep_files/figure-markdown_github/plot%20combined%20data-1.png)

``` r
### save for visualize
mar_countryrgn_time_data = production2 %>%
                           select(year, value = production,
                                  unit, mar_region)%>%
                           mutate(bhi_goal ="MAR",
                                  data_descrip = "Rainbow trout production by country region")

write.csv(mar_countryrgn_time_data, file.path(dir_baltic, 'visualize/mar_countryrgn_time_data.csv'),row.names = FALSE)
```

### 4.4 Use mar\_lookup to allocate production among BHI regions

Allocate data equally from mar\_region to all associated BHI region.
Do not have any additional information that would allow us to make this allocation based on known production distribution.

``` r
## create a conversion factor for each mar_region
lookup = lookup%>%
         group_by(mar_region)%>%
         mutate(rgn_factor = round((1/n_distinct(BHI)),2))%>%
         ungroup()
lookup
```

    ## Source: local data frame [35 x 4]
    ## 
    ##    country         mar_region   BHI rgn_factor
    ##     <fctr>             <fctr> <int>      <dbl>
    ## 1   Sweden    Norra ostkusten    41       0.33
    ## 2   Sweden    Norra ostkusten    39       0.33
    ## 3   Sweden    Norra ostkusten    37       0.33
    ## 4   Sweden    Sodra ostkusten    35       0.33
    ## 5   Sweden    Sodra ostkusten    29       0.33
    ## 6   Sweden    Sodra ostkusten    26       0.33
    ## 7   Sweden Syd och vastkusten    14       0.25
    ## 8   Sweden Syd och vastkusten    11       0.25
    ## 9   Sweden Syd och vastkusten     5       0.25
    ## 10  Sweden Syd och vastkusten     1       0.25
    ## ..     ...                ...   ...        ...

``` r
## join lookup to production

prod_allot = full_join(lookup, production2, by=c("country","mar_region"))%>%
            select(mar_region,BHI, year, production, rgn_factor,common_name,ISSCAAP_FAO,Sust_coeff)%>%
            mutate(prod_allot = production*rgn_factor)%>%  #get production fraction for each BHI region
            select(-mar_region)%>%
            group_by(BHI,year,common_name,ISSCAAP_FAO, Sust_coeff)%>%
            summarise(prod_tot = sum(prod_allot,na.rm=TRUE))%>%  #get production per BHI region - more than one
            ungroup()
```

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

#### 4.4.1 Plot production per BHI region

``` r
ggplot(prod_allot)+
  geom_line(aes(year, prod_tot))+
  geom_point(aes(year, prod_tot), size=0.75)+
  facet_wrap(~BHI, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Production (tons) by BHI region")
```

![](mar_prep_files/figure-markdown_github/plot%20production%20by%20bhi%20region-1.png)

``` r
### save for visualize
mar_rgn_time_data = prod_allot %>%
                           select(year, value = prod_tot,
                                   rgn_id = BHI)%>%
                           mutate(bhi_goal ="MAR",
                                  unit= "ton",
                                  data_descrip = "Rainbow trout production allocated to BHI region")

write.csv(mar_rgn_time_data, file.path(dir_baltic, 'visualize/mar_rgn_time_data.csv'),row.names = FALSE)
```

### 4.5 Create objects to save to put in layers, save a csv

3 layers: mar\_harvest\_tonnes, mar\_harvest\_species,mar\_sustainability\_score

Regions with no data - BHI regions not associated with Sweden, Finland, Denmark, Germany have no data. This is because there is no production.

The regions will be assigned an NA. Therefore, MAR will not contribute to the overall FP goal score. A counter argument could be made that some of these regions have the capacity for production, therefore they should receive a score of zero when having no production.

``` r
## mar_harvest_tonnes
mar_harvest_tonnes= prod_allot %>% select(BHI,ISSCAAP_FAO,year,prod_tot)%>%
                    dplyr::rename(rgn_id=BHI,species_code=ISSCAAP_FAO, year=year,tonnes=prod_tot)
head(mar_harvest_tonnes)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##   rgn_id species_code  year tonnes
    ##    <int>        <dbl> <dbl>  <dbl>
    ## 1      1           23  2005  74.75
    ## 2      1           23  2006  55.00
    ## 3      1           23  2007  65.25
    ## 4      1           23  2008  62.50
    ## 5      1           23  2009  59.25
    ## 6      1           23  2010  39.00

``` r
is.na(mar_harvest_tonnes$tonnes)
```

    ##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [133] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [144] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [155] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [166] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [177] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [188] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [199] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [210] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [221] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [232] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [243] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [254] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

``` r
write.csv(mar_harvest_tonnes, 
                 file.path(dir_layers, "mar_harvest_tonnes_bhi2015.csv"),row.names=FALSE)



## mar_harvest_species
mar_harvest_species= prod_allot %>%select(ISSCAAP_FAO,common_name)%>%
                    distinct(ISSCAAP_FAO,common_name)%>%
                    mutate(common_name=as.character(common_name))%>%
                    dplyr::rename(species_code=ISSCAAP_FAO, species=common_name)

write.csv(mar_harvest_species, 
                 file.path(dir_layers, "mar_harvest_species_bhi2015.csv"),row.names=FALSE)



## mar_sustainability_score
mar_sustainability_score = prod_allot %>% select(BHI,common_name,Sust_coeff)%>%
                          mutate(common_name=as.character(common_name))%>%
                          distinct(.)%>%
                          dplyr::rename(rgn_id=BHI,species=common_name, sust_coeff=Sust_coeff)

write.csv(mar_sustainability_score,
                 file.path(dir_layers, "mar_sustainability_score_bhi2015.csv"),row.names=FALSE)
```

### Population density data

MAR code from OHI uses production/per capita
This code creates a csv of the population density data (2005) from 25km inland buffer.
Code in functions.r is where the decision is made whether or not to use it.

``` r
bhi_pop = readr::read_csv(file.path(dir_mar,'mar_data_database/pop_density.csv'))
# head(bhi_pop)

  
## clean up and save layer
bhi_pop =bhi_pop %>%
  dplyr::select(rgn_id = BHI_ID, 
                popsum = `Total Population in 25km Buffer`)
bhi_pop
```

    ## Source: local data frame [42 x 2]
    ## 
    ##    rgn_id  popsum
    ##     <int>   <int>
    ## 1       1  852713
    ## 2       2 1754535
    ## 3       3 1971018
    ## 4       4  191278
    ## 5       5  801791
    ## 6       6 1381111
    ## 7       7   24035
    ## 8       8  654326
    ## 9       9   33074
    ## 10     10 1239349
    ## ..    ...     ...

``` r
## write to layers folder to use in the function
readr::write_csv(bhi_pop, 
                 file.path(dir_layers, "mar_coastalpopn2005_inland25km_bhi2015.csv"))
```

MAR Goal Model
--------------

Xmar = Current\_value /ref\_point

-   Data are allocated to BHI region by taking the production from a country production region and dividing it equally among associated BHI regions.
-   In goal calculation, data are taken as 4 year running mean
-   Data unit is tons of production
-   Reference point is temporal, 5 year moving window

Calculate MAR status and trend
------------------------------

Calculate MAR status and trend to get feedback. Code here is copied from functions.r

``` r
##data
  harvest_tonnes = mar_harvest_tonnes
  harvest_species = mar_harvest_species
  sustainability_score = mar_sustainability_score

  # SETTING CONSTANTS
  rm_year = 4     #number of years to use when calculating the running mean smoother
  regr_length =5   # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
  future_year = 5    # the year at which we want the likely future status
  min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
  status_years = 2010:2014 #this was originally set in goals.csv
  lag_win = 5        # if use a 5 year moving window reference point (instead of spatial, use this lag)

  #####----------------------######
  #harvest_tonnes has years without data but those years not present with NAs
  #spread and gather data again which will result in all years present for all regions
  harvest_tonnes=harvest_tonnes%>%spread(key=year,value=tonnes)%>%
    gather(year, tonnes, -rgn_id,-species_code)%>%
    mutate(year=as.numeric(year))%>%  #make sure year is not a character
    arrange(rgn_id,year)

  # Merge harvest (production) data with sustainability score
  #calculate 4 year running mean
  #this code updated by Lena to use dplyr functions not reshape2
  temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
    left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
    arrange(rgn_id, species) %>%
    group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
    mutate(rm = zoo::rollapply(data=tonnes, width=rm_year,FUN= mean, na.rm = TRUE, partial=TRUE),    #rm = running mean  #rm_year defined with constants (4 is value from original code)     # better done with zoo::rollmean? how to treat Na with that?
           sust_tonnes = rm * sust_coeff)

  # now calculate total sust_tonnes per year  #only matters if multiple species
  ## remove code that made the data unit per capita

  temp2 = temp %>%    # temp2 is ry in the original version
    group_by(rgn_id, year) %>%
    summarise(sust_tonnes_sum = sum(sust_tonnes)) #this sums the harvest(production) across all species in a given region if multiple spp are present
    ## left_join(., popn_inland25km, by=c('rgn_id')) %>%  #apply 2005 pop data to all years
    ##mutate(mar_prod = sust_tonnes_sum) #tonnes per capita


  ###----------------------------###
  ##Calculate status using temporal reference point
  ## 5 year moving window (temporal ref by region)
  ## Xmar = Mar_current / Mar_ref
  ## if use this, need to decide if the production should be scaled per capita

  ##for complete region ID list
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(temp2$year)))

  ## Calculate status
  mar_status_score = temp2 %>% group_by(rgn_id)%>%
                mutate(year_ref= lag(year, lag_win, order_by=year),
                       ref_val = lag(sust_tonnes_sum, lag_win, order_by=year))%>% #create ref year and value which is value 5 years preceeding within a BHI region
                arrange(year)%>%
                ungroup()%>%
                filter(year %in% status_years) %>% #select status years
                mutate(status = pmin(1,sust_tonnes_sum/ref_val))%>% #calculate status per year
                select(rgn_id, year, status)%>%
                full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%  #join with complete rgn_id list
                arrange(rgn_id,year) ##%>%  ## comment out replace NA with zero, keep as NA for now
               ## mutate(status, status = replace(status, is.na(status), 0))  #give NA value a 0

  #Calculate score
  mar_status = mar_status_score%>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id,status) %>% #select last year of status for the score
    mutate(score = round(status*100,2))%>% #status is between 0-100
    ungroup()%>%
    select(rgn_id,score)

  ###----------------------------###
  ## Calulate trend
      ##regr_length = 5; there are 5 data points used to calculate the trend
  mar_trend= mar_status_score%>%group_by(rgn_id)%>%
    do(tail(. , n = regr_length)) %>% #select the years for trend calculate (regr_length # years from the end of the time series)
    #regr_length replaces the need to read in the trend_yrs from the csv file
    do({if(sum(!is.na(.$status)) >= min_regr_length)      #calculate trend only if X years of data (min_regr_length) in the last Y years of time serie (regr_length)
      data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year))) #future_year set in contants, this is the value 5 in the old code
      else data.frame(trend_score = NA)}) %>%
    ungroup()%>%
    mutate(trend_score=round(trend_score,2))

  #####----------------------######
  # return MAR scores
  scores = mar_status %>%
    select(region_id = rgn_id,
           score     = score) %>%
    mutate(dimension='status') %>%
    rbind(
      mar_trend %>%
        select(region_id = rgn_id,
               score     = trend_score) %>%
        mutate(dimension = 'trend')) %>%
    mutate(goal='MAR')
  scores
```

    ## Source: local data frame [84 x 4]
    ## 
    ##    region_id  score dimension  goal
    ##        <int>  <dbl>     <chr> <chr>
    ## 1          1  56.12    status   MAR
    ## 2          2  94.73    status   MAR
    ## 3          3 100.00    status   MAR
    ## 4          4 100.00    status   MAR
    ## 5          5  56.12    status   MAR
    ## 6          6   6.99    status   MAR
    ## 7          7 100.00    status   MAR
    ## 8          8 100.00    status   MAR
    ## 9          9 100.00    status   MAR
    ## 10        10 100.00    status   MAR
    ## ..       ...    ...       ...   ...

Plot status and trend as a figure
---------------------------------

**Status** is a value between 0 and 100.
**Trend** is a value between -1 and 1.

``` r
par(mfrow=c(1,2), mar=c(1,2.5,1,1), oma=c(2,2,2,2), mgp=c(1.5,.5,0))
plot(score~rgn_id, data=mar_status,cex=1, pch=19,
     xlim=c(0,43), ylim=c(0,102),
     xlab="", ylab= "Current Status", 
     cex.axis=.7, cex.lab=0.8)

plot(trend_score~rgn_id, data=mar_trend,cex=1,pch=19,
     xlim=c(0,43), ylim=c(-1,1),
     xlab="", ylab= "Trend", 
     cex.axis=.7, cex.lab=0.8)
  abline(h=0)
mtext("BHI Region", side=1, line=.5, outer=TRUE, cex=.8)
mtext("MAR Status and Trend", side=3, line=.5, outer=TRUE, cex=1.2)
```

![](mar_prep_files/figure-markdown_github/plot%20status,%20trend-1.png)

Plot MAR status time series
---------------------------

This is the time series use to calculate the trend.
Each years status is based on a 4 year running mean of production and a reference point five years before.

``` r
# Plot MAR status over time

ggplot(filter(mar_status_score, !is.na(status))) + 
  geom_point(aes(year,status*100))+
  facet_wrap(~rgn_id)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("MAR Status 5 Years by BHI region (exclude regions with NA status")
```

![](mar_prep_files/figure-markdown_github/plot%20status%20time%20series-1.png)

Plot status as a map
--------------------

    ## Warning: package 'rgdal' was built under R version 3.2.5

    ## Loading required package: sp

    ## Warning: package 'sp' was built under R version 3.2.5

    ## rgdal: version: 1.1-10, (SVN revision 622)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.0.1, released 2015/09/15
    ##  Path to GDAL shared files: C:/R-3.2.3/library/rgdal/gdal
    ##  GDAL does not use iconv for recoding strings.
    ##  Loaded PROJ.4 runtime: Rel. 4.9.1, 04 March 2015, [PJ_VERSION: 491]
    ##  Path to PROJ.4 shared files: C:/R-3.2.3/library/rgdal/proj
    ##  Linking to sp version: 1.2-3

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", layer: "BHI_regions_plus_buffer_25km"
    ## with 42 features
    ## It has 1 fields

    ## Warning in readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/
    ## BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", : Z-dimension
    ## discarded

    ## [1] "+proj=longlat +init=epsg:4326 +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

**Note that areas recieve a score of zero where there is no production**

``` r
## Assign colors to BHI ID based on score - these bins are not even, not sure how to do a gradient
## 0 - 24
## 25 - 49
## 50 - 74
## 75 - 100

mar_status_colors = mar_status %>% 
                        mutate(cols = ifelse(is.na(score) == TRUE, "grey",
                                      ifelse(score == 0, "red",
                                      ifelse(score > 0 & score < 25, "orange1",
                                      ifelse(score >= 25 & score < 50, "yellow2",
                                      ifelse(score >= 50 & score < 75, "light blue",
                                      ifelse(score >= 75 & score <=100, "blue", "grey")))))))




BHIshp2@data = BHIshp2@data %>% full_join(.,mar_status_colors, by=c("BHI_ID"= "rgn_id"))
head(BHIshp2@data)
```

    ##   BHI_ID  score       cols
    ## 1      1  56.12 light blue
    ## 2      2  94.73       blue
    ## 3      3 100.00       blue
    ## 4      4 100.00       blue
    ## 5      5  56.12 light blue
    ## 6      6   6.99    orange1

``` r
## PLOT
par(mfrow=c(1,2), mar=c(.5,.2,.5,.2), oma=c(0,0,4,0))
  
plot(BHIshp2, col=BHIshp2@data$cols, main = "score 1")
 plot(c(1,2,3),c(1,2,3), type='n', fg="white",bg="white", xaxt='n',yaxt='n')
  legend("center", 
         legend=c("0", "1 - 24", "25 - 49", "50 - 74", "75 -100"), 
         fill=c("red","orange1","yellow2","light blue", "blue"), bty='n', cex=1.5)

    mtext("MAR Current Status", side = 3, outer=TRUE, line=1.5)
```

![](mar_prep_files/figure-markdown_github/Current%20status%20map-1.png)
