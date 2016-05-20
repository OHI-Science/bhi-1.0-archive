lsp\_prep
================

``` r
## Libraries
library(readr)
library(dplyr)
```

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
library(ggplot2)
library(RMySQL)
```

    ## Loading required package: DBI

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')

# source
source('~/github/bhi/baltic2015/prep/common.r') #for create_readme() function

## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')
dir_prep = make_path('baltic2015/prep') # replaces  file.path(dir_baltic, 'layers')

# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))


dir_lsp   = file.path(dir_prep, 'LSP')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_lsp, 'lsp_prep.rmd') 
```

1. Background on MPA data
-------------------------

### 1.1 Why MPAs?

2. MPA data
-----------

### 2.1 Data source

#### 2.1.1 Shapefiles of MPA area

Shapefiles of current MPA areas were downloaded from [HELCOM MPAs Map Service](http://mpas.helcom.fi/apex/f?p=103:17::::::).
 - Need to confirm date downloaded and date these data were last updated.

#### 2.1.2 Management plan status csv

The status of the management plans associated with each MPA were downloaded from HELCOM's \[MPA database\] (<http://mpas.helcom.fi/apex/f?p=103:40>::::::) under the *Management Plans* tab. Data were downloaded on 15 April 2016.
 - Key columns in this csv file are "Site name" (MPA name) and "Management Plan status"

There are three levels of management plan status that can be assigned to each MPA: *No plan*, *In development*, *Implemented*.

A challenge is that each MPA can have multiple management plans associated with it. There is no limit to the number of plans not an ability to assess their relative importance. Different management plans for the same MPA can have different levels of implementation.

\*\*How to use this information*?*

3. LSP goal model overview
--------------------------

### 3.1 Status

Xlsp\_country = sum(w\_i \* MPA area)\_m / Reference\_pt\_country
 - Numerator is the sum over all MPAs within a country's EEZ of the MPA area weighted by the management status.
 - w\_i = value between 0 -1
 - Need to assign weights to levels of management status.
 - **One option**: *No plan* = 0.3, *In development* = .6, *Implemented* = 1.0. **NEED FEEDBACK** - Each country's status is applied to all BHI regions associated with that country.

Reference\_pt\_country = 10% of the area in a country's EEZ is designated as an MPA and is 100% managed = 10% area country's EEZ
 - This is based on the Convention on Biodiversity [target](https://www.cbd.int/sp/targets/rationale/target-11/)

### 3.2 Trend

##### 3.2.1 Alternative 1

MPA dbf contains the date the MPA was established. Therefore, we can calculate the cumulative area over time that are MPAs. We can fit a cum. area ~ year. Calculate cumulative area from ealiest year of MPA established (1976) but for trend use the most recent 10 year period (2004 - 2013)? It appears that countries mostly designate MPAs in chunks.

Only allow a positive slope since countries are not removing mpas? This would be automatic since regressing cumulative area on year (and have no info on areas removed). Also, if country reaches 10% goal, then the rate at which new area is added should go to zero. Then it is okay to have zero slope because the status will not decline in future - the required area has been allocated and status can only improve if all areas are managed. Then score of 100 is achieved.

Cum\_area\_y = sum of all MPA areas established from year 1 to year y

Cum\_area\_y = m\*year\_y + b; m = slope

Trend = Future\_year \* m ; future\_year = 5

How to rescale trend? If all values are between 0-1, do we need to rescale?

#### 3.2.2 Alterative 2

There is limited information on MPA area from previous assessments. Need to read historic overview provided in [Baltic Sea Environment Proceedings NO. 124B Towards an ecologically coherent network of well-managed Marine Protected Areas](http://www.helcom.fi/lists/publications/bsep124b.pdf). Use this for the trend? If area increasing, get positive trend?

4. MPA data prep
----------------

Prep data layer

Read in MPA and BHI regions shapefiles
--------------------------------------

Also, get them in the same coordinate reference system for the Baltic.

The MPA file is in the [LAEA coordinate reference system](http://spatialreference.org/ref/epsg/etrs89-etrs-laea/).

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 42 
    ## extent      : 9.420778, 30.34708, 53.60164, 65.90708  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 6
    ## names       : rgn_nam, rgn_key,              Subbasin, HELCOM_ID, BHI_ID,   Area_km2 
    ## min values  : Denmark,     DEU,             Aland Sea,   SEA-001,      1, 10369.1132 
    ## max values  :  Sweden,     SWE, Western Gotland Basin,   SEA-017,      9,  9800.2440

![](lsp_prep_files/figure-markdown_github/read%20in%20shapefiles-1.png)

    ##      rgn_nam rgn_key               Subbasin HELCOM_ID BHI_ID   Area_km2
    ## 0    Denmark     DNK           Arkona Basin   SEA-006     12  6272.5337
    ## 1    Denmark     DNK     Bay of Mecklenburg   SEA-005      9  1144.2930
    ## 2    Denmark     DNK         Bornholm Basin   SEA-007     15  7152.7984
    ## 3    Denmark     DNK             Great Belt   SEA-002      3 10369.1132
    ## 4    Denmark     DNK               Kattegat   SEA-001      2 15300.7000
    ## 5    Denmark     DNK               Kiel Bay   SEA-004      7  1208.8762
    ## 6    Denmark     DNK              The Sound   SEA-003      6   588.3871
    ## 7    Estonia     EST  Eastern Gotland Basin   SEA-009     25  5414.0565
    ## 8    Estonia     EST        Gulf of Finland   SEA-013     34  8426.0446
    ## 9    Estonia     EST           Gulf of Riga   SEA-011     28 10774.5533
    ## 10   Estonia     EST Northern Baltic Proper   SEA-012     31 11841.3991
    ## 11   Finland     FIN              Aland Sea   SEA-014     36 12405.6854
    ## 12   Finland     FIN           Bothnian Bay   SEA-017     42 14930.9047
    ## 13   Finland     FIN           Bothnian Sea   SEA-015     38 28136.7885
    ## 14   Finland     FIN        Gulf of Finland   SEA-013     32  9549.6773
    ## 15   Finland     FIN Northern Baltic Proper   SEA-012     30  9800.2440
    ## 16   Finland     FIN              The Quark   SEA-016     40  4932.9967
    ## 17   Germany     DEU           Arkona Basin   SEA-006     13  7071.4978
    ## 18   Germany     DEU     Bay of Mecklenburg   SEA-005     10  3438.8220
    ## 19   Germany     DEU         Bornholm Basin   SEA-007     16  2566.8109
    ## 20   Germany     DEU             Great Belt   SEA-002      4   140.9888
    ## 21   Germany     DEU               Kiel Bay   SEA-004      8  2079.4797
    ## 22    Latvia     LVA  Eastern Gotland Basin   SEA-009     24 20977.5849
    ## 23    Latvia     LVA           Gulf of Riga   SEA-011     27  7993.9179
    ## 24 Lithuania     LTU  Eastern Gotland Basin   SEA-009     23  6139.7394
    ## 25    Poland     POL         Bornholm Basin   SEA-007     17 17334.9726
    ## 26    Poland     POL  Eastern Gotland Basin   SEA-009     21 11013.8982
    ## 27    Poland     POL           Gdansk Basin   SEA-008     18  3682.8357
    ## 28    Russia     RUS  Eastern Gotland Basin   SEA-009     22  9466.3010
    ## 29    Russia     RUS           Gdansk Basin   SEA-008     19  2138.4146
    ## 30    Russia     RUS        Gulf of Finland   SEA-013     33 11571.5986
    ## 31    Sweden     SWE              Aland Sea   SEA-014     35  2703.0566
    ## 32    Sweden     SWE           Arkona Basin   SEA-006     11  4226.4476
    ## 33    Sweden     SWE         Bornholm Basin   SEA-007     14 15096.6004
    ## 34    Sweden     SWE            Bothian Sea   SEA-015     37 31735.9081
    ## 35    Sweden     SWE           Bothnian Bay   SEA-017     41 17335.8296
    ## 36    Sweden     SWE  Eastern Gotland Basin   SEA-009     20 21941.0076
    ## 37    Sweden     SWE               Kattegat   SEA-001      1  6739.5362
    ## 38    Sweden     SWE Northern Baltic Proper   SEA-012     29 17728.4017
    ## 39    Sweden     SWE              The Quark   SEA-016     39  3215.7150
    ## 40    Sweden     SWE              The Sound   SEA-003      5   612.6651
    ## 41    Sweden     SWE  Western Gotland Basin   SEA-010     26 27456.0569

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/bhi_MPA", layer: "HELCOM_MPAs"
    ## with 163 features
    ## It has 14 fields

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 163 
    ## extent      : 4283563, 5403758, 3389128, 4802074  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs 
    ## variables   : 14
    ## names       : BSPA_ID,                       Name,                                             WebLink, Country,             Location_S, MPA_Status, AreaTot_Ha, AreaMar_Ha,  N2K_Site,  Date_Est,                                                            BSPALink,                                                          N2000Link, Shape_area,   Shape_len 
    ## min values  :     101, Adler Grund og Rønne Banke,                           http://slowinskipn.pl/pl/, Denmark,        Both EEZ and TW, Designated,   10007.00,       0.00,  1332-301, 10.9.2009, http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=101, http://natura2000.eea.europa.eu/Natura2000/SDF.aspx?site=DE1123393,  100093073,  100635.861 
    ## max values  :      95,               Zatoka Pucka, http://www.ymparisto.fi/download.asp?contenid=75089,  Sweden, Territorial Water (TW),    Managed,   98400.00,   98958.00, SE-082075, 9.11.2009,  http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=95, http://natura2000.eea.europa.eu/Natura2000/SDF.aspx?site=SE-082075,  983908429,   99747.035

![](lsp_prep_files/figure-markdown_github/read%20in%20shapefiles-2.png)

    ##   BSPA_ID                                              Name
    ## 0     163 Curonian Spit State National Park (southern part)
    ## 1     164       Vistula Spit Landscape Park (northern part)
    ## 2     166                               Kurgalsky Peninsula
    ## 3     294                                        Vyborgskii
    ## 4     197                           Lebyazhy Nature Reserve
    ## 5     196                                 Berezovye Islands
    ##                    WebLink Country             Location_S MPA_Status
    ## 0 http://www.park-kosa.ru/  Russia Territorial Water (TW) Designated
    ## 1                     <NA>  Russia Territorial Water (TW) Designated
    ## 2                     <NA>  Russia Territorial Water (TW) Designated
    ## 3     http://www.paslo.ru/  Russia Territorial Water (TW) Designated
    ## 4                     <NA>  Russia Territorial Water (TW) Designated
    ## 5                     <NA>  Russia Territorial Water (TW) Designated
    ##   AreaTot_Ha AreaMar_Ha N2K_Site   Date_Est
    ## 0    6621.00       0.00     <NA>  6.11.1987
    ## 1    4000.00       0.00     <NA>       <NA>
    ## 2   59950.00   38400.00     <NA>  20.7.2000
    ## 3   11304.10    6941.00     <NA>  29.3.1976
    ## 4    6344.65    5298.35     <NA>   3.4.2007
    ## 5   55295.00   47020.00     <NA> 26.12.1996
    ##                                                              BSPALink
    ## 0 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=163
    ## 1 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=164
    ## 2 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=166
    ## 3 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=294
    ## 4 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=197
    ## 5 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=196
    ##   N2000Link Shape_area Shape_len
    ## 0      <NA>   75077431  90536.49
    ## 1      <NA>   34002742  54118.88
    ## 2      <NA>  506797452 228930.02
    ## 3      <NA>  109451486  64435.96
    ## 4      <NA>   77454505  73983.29
    ## 5      <NA>  536047061 115101.23

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 42 
    ## extent      : 4283762, 5442611, 3397830, 4818369  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs 
    ## variables   : 6
    ## names       : rgn_nam, rgn_key,              Subbasin, HELCOM_ID, BHI_ID,   Area_km2 
    ## min values  : Denmark,     DEU,             Aland Sea,   SEA-001,      1, 10369.1132 
    ## max values  :  Sweden,     SWE, Western Gotland Basin,   SEA-017,      9,  9800.2440

Intersect BHI and HELCOM\_MPA polygons
--------------------------------------

MPA regions were divided by with BHI region shape file, and thus we were able to calculate the total MPA area within each BHI region.

TODO: intersecting the two data files created 184 duplicates of the 42 regions... I removed them for now, but I need to dig deeper to find out why that happene and if that in any way affected the accuracy of the data.

![](lsp_prep_files/figure-markdown_github/intersect%20BHI%20adn%20MPA-1.png)

    ## Warning in RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid"): Ring Self-
    ## intersection at or near point 4785962.2438000003 4180281.4374000002

    ##     user   system  elapsed 
    ## 2147.892    1.052 2149.445

![](lsp_prep_files/figure-markdown_github/intersect%20BHI%20adn%20MPA-2.png)

    ##   BSPA_ID                                              Name
    ## 1     163 Curonian Spit State National Park (southern part)
    ## 2     164       Vistula Spit Landscape Park (northern part)
    ## 3     166                               Kurgalsky Peninsula
    ## 4     166                               Kurgalsky Peninsula
    ## 5     294                                        Vyborgskii
    ## 6     197                           Lebyazhy Nature Reserve
    ##                    WebLink Country             Location_S MPA_Status
    ## 1 http://www.park-kosa.ru/  Russia Territorial Water (TW) Designated
    ## 2                     <NA>  Russia Territorial Water (TW) Designated
    ## 3                     <NA>  Russia Territorial Water (TW) Designated
    ## 4                     <NA>  Russia Territorial Water (TW) Designated
    ## 5     http://www.paslo.ru/  Russia Territorial Water (TW) Designated
    ## 6                     <NA>  Russia Territorial Water (TW) Designated
    ##   AreaTot_Ha AreaMar_Ha N2K_Site  Date_Est
    ## 1    6621.00       0.00     <NA> 6.11.1987
    ## 2    4000.00       0.00     <NA>      <NA>
    ## 3   59950.00   38400.00     <NA> 20.7.2000
    ## 4   59950.00   38400.00     <NA> 20.7.2000
    ## 5   11304.10    6941.00     <NA> 29.3.1976
    ## 6    6344.65    5298.35     <NA>  3.4.2007
    ##                                                              BSPALink
    ## 1 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=163
    ## 2 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=164
    ## 3 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=166
    ## 4 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=166
    ## 5 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=294
    ## 6 http://bspa.helcom.fi/flow/bspa.tammi.sites.update.general.1?Id=197
    ##   N2000Link Shape_area Shape_len rgn_nam rgn_key              Subbasin
    ## 1      <NA>   75077431  90536.49  Russia     RUS Eastern Gotland Basin
    ## 2      <NA>   34002742  54118.88  Russia     RUS          Gdansk Basin
    ## 3      <NA>  506797452 228930.02 Estonia     EST       Gulf of Finland
    ## 4      <NA>  506797452 228930.02  Russia     RUS       Gulf of Finland
    ## 5      <NA>  109451486  64435.96  Russia     RUS       Gulf of Finland
    ## 6      <NA>   77454505  73983.29  Russia     RUS       Gulf of Finland
    ##   HELCOM_ID BHI_ID  Area_km2
    ## 1   SEA-009     22  9466.301
    ## 2   SEA-008     19  2138.415
    ## 3   SEA-013     34  8426.045
    ## 4   SEA-013     33 11571.599
    ## 5   SEA-013     33 11571.599
    ## 6   SEA-013     33 11571.599

I did not read the read in MPA management plan status file from "~/github/bhi/baltic2015/prep/LSP/mpa\_data\_database/MPA\_management\_plans\_20160415.csv"
