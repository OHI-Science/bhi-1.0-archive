nutrient\_load\_prep
================

-   [Prep Nutrient Load Pressure Layers](#prep-nutrient-load-pressure-layers)
-   [1. Background on Nutrient Load Pressures](#background-on-nutrient-load-pressures)
-   [2. Data Sources](#data-sources)
    -   [2.1 N & P Loads](#n-p-loads)
    -   [2.2 Maximum Allowable Inputs (MAI)](#maximum-allowable-inputs-mai)
    -   [2.3 Data scale](#data-scale)
-   [3. Data rescaling decisions](#data-rescaling-decisions)
-   [4. Read in all data](#read-in-all-data)
-   [5. Nitrogen Layer Prep](#nitrogen-layer-prep)
    -   [5.1 Combine N\_load with Target N\_load](#combine-n_load-with-target-n_load)
    -   [5.2 Plot time series of load by basin with target indicated](#plot-time-series-of-load-by-basin-with-target-indicated)
    -   [5.3 Calculate current N load pressure](#calculate-current-n-load-pressure)
    -   [5.4 Rescale the N load pressure](#rescale-the-n-load-pressure)
    -   [5.5 Plot normalized N load pressure score by basin](#plot-normalized-n-load-pressure-score-by-basin)
    -   [5.6 Assign basin pressure value to BHI regions](#assign-basin-pressure-value-to-bhi-regions)
    -   [5.7 Plot map of N pressure score by BHI region](#plot-map-of-n-pressure-score-by-bhi-region)
-   [6. Phosphorus Layer Prep](#phosphorus-layer-prep)
    -   [6.1 Combine P\_load with Target P\_load](#combine-p_load-with-target-p_load)
    -   [6.2 Plot time series of load by basin with target indicated](#plot-time-series-of-load-by-basin-with-target-indicated-1)
    -   [6.3 Calculate current P load pressure](#calculate-current-p-load-pressure)
    -   [6.4 Rescale the P load pressure](#rescale-the-p-load-pressure)
    -   [6.5 Plot normalized P load pressure score by basin](#plot-normalized-p-load-pressure-score-by-basin)
    -   [6.6 Assign basin P pressure value to BHI regions](#assign-basin-p-pressure-value-to-bhi-regions)
    -   [6.7 Plot map of P pressure score by BHI region](#plot-map-of-p-pressure-score-by-bhi-region)
-   [Save data as csv in Layers](#save-data-as-csv-in-layers)

Prep Nutrient Load Pressure Layers
----------------------------------

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




dir_nutprep = make_path('baltic2015/prep/pressures/nutrient_load')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_nutprep, 'nutrient_load_prep.rmd') 
```

1. Background on Nutrient Load Pressures
----------------------------------------

External loads of nitrogen and phosphorus into the Baltic Sea. Loads include land-based and atmospheric sources and are normalized for river flow.

[HELCOM Core Indicator- Inputs of Nitrogen and Phosphorus to the Baltic Sea Sea](http://www.helcom.fi/baltic-sea-trends/indicators/inputs-of-nitrogen-and-phosphorus-to-the-basins)

2. Data Sources
---------------

Data provided by Bo Gustafsson.
Data are official HELCOM reported data.

### 2.1 N & P Loads

Actual total (e.g. air and waterborne (direct and point source discharges)) annual input of nitrogren and phosphorous (tonnes) can be accessed [here](http://helcom.fi/helcom-at-work/projects/completed-projects/plc-5-5/). As loads are very sensitive to runoff, we use the flow-normalized input values. These data are plotted as the solid black line in Figure 3 under [Results - HELCOM Core Indicator Inputs of Nitrogen and Phosphorus to the basins](http://www.helcom.fi/baltic-sea-trends/indicators/inputs-of-nitrogen-and-phosphorus-to-the-basins/results/)

### 2.2 Maximum Allowable Inputs (MAI)

MAI values for each basin are found in [Summary report on the development of revised Maximum Allowable Inputs (MAI) and updated Country Allocated Reduction Targets (CART) of the Baltic Sea Action Plan](http://www.helcom.fi/Documents/Ministerial2013/Associated%20documents/Supporting/Summary%20report%20on%20MAI-CART.pdf) in Table 3, p. 8.

These same MAI values are also presented on under [Results - HELCOM Core Indicator Inputs of Nitrogen and Phosphorus to the basins](http://www.helcom.fi/baltic-sea-trends/indicators/inputs-of-nitrogen-and-phosphorus-to-the-basins/results/)

### 2.3 Data scale

Assessment of N & P loads and the setting of MAI were done for 7 Baltic Sea basins: Baltic Proper, Kattegat, Danish Straits, Gulf of Riga, Gulf of Finland, Bothnian Sea, Bothnian Bay.
These basins are larger than the HOLAS basins used define the BHI regions. The pressure score will be calculated at the assessment scale and then all BHI regions within an assessment basin will receive the same pressure value.

3. Data rescaling decisions
---------------------------

In discussions with BO Gustafsson, we have made the following decisions.
*Current pressure* = the mean load in each basin during the most recent three year assessment period for HELCOM (2010-2012).
*Min value* = the minimum value is when there is no pressure on the system, this is scaled to the MAI for each basin.
*Max value* = the maximum value is the highest load to each basin over the reference period used for determining MAI (1997-2003).

4. Read in all data
-------------------

``` r
## read in N load
n_load = read.csv(file.path(dir_nutprep, 'nutrient_data_database/N_basin_load.csv'))
head(n_load)
```

    ##   year        basin                        variable tonnes
    ## 1 1995 Bothnian Bay total normalized nitrogen input  55478
    ## 2 1996 Bothnian Bay total normalized nitrogen input  57469
    ## 3 1997 Bothnian Bay total normalized nitrogen input  57834
    ## 4 1998 Bothnian Bay total normalized nitrogen input  59849
    ## 5 1999 Bothnian Bay total normalized nitrogen input  57353
    ## 6 2000 Bothnian Bay total normalized nitrogen input  59996

``` r
str(n_load)
```

    ## 'data.frame':    126 obs. of  4 variables:
    ##  $ year    : int  1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 ...
    ##  $ basin   : Factor w/ 7 levels "Baltic Proper",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ variable: Factor w/ 1 level "total normalized nitrogen input": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ tonnes  : int  55478 57469 57834 59849 57353 59996 60046 56625 63118 60619 ...

``` r
dim(n_load)
```

    ## [1] 126   4

``` r
n_load = n_load %>% 
        mutate(basin = as.character(basin),
               variable = as.character(variable))


## read in P load
p_load = read.csv(file.path(dir_nutprep, 'nutrient_data_database/P_basin_load.csv'))
head(p_load)
```

    ##   year        basin                          variable tonnes
    ## 1 1995 Bothnian Bay total normalized phosphorus input   3125
    ## 2 1996 Bothnian Bay total normalized phosphorus input   2325
    ## 3 1997 Bothnian Bay total normalized phosphorus input   3431
    ## 4 1998 Bothnian Bay total normalized phosphorus input   2838
    ## 5 1999 Bothnian Bay total normalized phosphorus input   2621
    ## 6 2000 Bothnian Bay total normalized phosphorus input   2791

``` r
str(p_load)
```

    ## 'data.frame':    126 obs. of  4 variables:
    ##  $ year    : int  1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 ...
    ##  $ basin   : Factor w/ 7 levels "Baltic Proper",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ variable: Factor w/ 1 level "total normalized phosphorus input": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ tonnes  : int  3125 2325 3431 2838 2621 2791 2628 2318 2478 2537 ...

``` r
p_load = p_load %>% 
        mutate(basin = as.character(basin),
               variable = as.character(variable))


## read in Maximum allowable inputs (MAI)
mai = read.csv(file.path(dir_nutprep, 'nutrient_data_database/N_P_load_targets.csv'))
head(mai)
```

    ##             basin maximum_allowable_input                        variable
    ## 1    Bothnian Bay                   57622 total normalized nitrogen input
    ## 2    Bothnian Sea                   79372 total normalized nitrogen input
    ## 3   Baltic Proper                  325000 total normalized nitrogen input
    ## 4 Gulf of Finland                  101800 total normalized nitrogen input
    ## 5    Gulf of Riga                   88417 total normalized nitrogen input
    ## 6  Danish Straits                   65998 total normalized nitrogen input

``` r
str(mai)
```

    ## 'data.frame':    14 obs. of  3 variables:
    ##  $ basin                  : Factor w/ 7 levels "Baltic Proper",..: 2 3 1 5 6 4 7 2 3 1 ...
    ##  $ maximum_allowable_input: int  57622 79372 325000 101800 88417 65998 74000 2675 2773 7360 ...
    ##  $ variable               : Factor w/ 2 levels "total normalized nitrogen input",..: 1 1 1 1 1 1 1 2 2 2 ...

``` r
mai = mai %>%
      mutate(basin = as.character(basin),
             variable = as.character(variable))

## Read in lookup table for basins to bhi_regions
basin_lookup = read.csv(file.path(dir_nutprep, 'bhi_basin_country_lookup_load_basins.csv'), sep=";", stringsAsFactors = FALSE)
basin_lookup = basin_lookup %>% 
               select(rgn_id=BHI_ID, cntry_name=rgn_nam,
                      basin_name_holas=Subbasin,basin_name_loads)%>%
               mutate(cntry_name = as.character(cntry_name),
                      basin_name_holas = as.character(basin_name_holas),
                      basin_name_loads= as.character(basin_name_loads))

basin_lookup
```

    ##    rgn_id cntry_name       basin_name_holas basin_name_loads
    ## 1       1     Sweden               Kattegat         Kattegat
    ## 2       2    Denmark               Kattegat         Kattegat
    ## 3       3    Denmark             Great Belt   Danish Straits
    ## 4       4    Germany             Great Belt   Danish Straits
    ## 5       5     Sweden              The Sound         Kattegat
    ## 6       6    Denmark              The Sound         Kattegat
    ## 7       7    Denmark               Kiel Bay   Danish Straits
    ## 8       8    Germany               Kiel Bay   Danish Straits
    ## 9       9    Denmark     Bay of Mecklenburg   Danish Straits
    ## 10     10    Germany     Bay of Mecklenburg   Danish Straits
    ## 11     11     Sweden           Arkona Basin    Baltic Proper
    ## 12     12    Denmark           Arkona Basin    Baltic Proper
    ## 13     13    Germany           Arkona Basin    Baltic Proper
    ## 14     14     Sweden         Bornholm Basin    Baltic Proper
    ## 15     15    Denmark         Bornholm Basin    Baltic Proper
    ## 16     16    Germany         Bornholm Basin    Baltic Proper
    ## 17     17     Poland         Bornholm Basin    Baltic Proper
    ## 18     18     Poland           Gdansk Basin    Baltic Proper
    ## 19     19     Russia           Gdansk Basin    Baltic Proper
    ## 20     20     Sweden  Eastern Gotland Basin    Baltic Proper
    ## 21     21     Poland  Eastern Gotland Basin    Baltic Proper
    ## 22     22     Russia  Eastern Gotland Basin    Baltic Proper
    ## 23     23  Lithuania  Eastern Gotland Basin    Baltic Proper
    ## 24     24     Latvia  Eastern Gotland Basin    Baltic Proper
    ## 25     25    Estonia  Eastern Gotland Basin    Baltic Proper
    ## 26     26     Sweden  Western Gotland Basin    Baltic Proper
    ## 27     27     Latvia           Gulf of Riga     Gulf of Riga
    ## 28     28    Estonia           Gulf of Riga     Gulf of Riga
    ## 29     29     Sweden Northern Baltic Proper    Baltic Proper
    ## 30     30    Finland Northern Baltic Proper    Baltic Proper
    ## 31     31    Estonia Northern Baltic Proper    Baltic Proper
    ## 32     32    Finland        Gulf of Finland  Gulf of Finland
    ## 33     33     Russia        Gulf of Finland  Gulf of Finland
    ## 34     34    Estonia        Gulf of Finland  Gulf of Finland
    ## 35     35     Sweden              Aland Sea     Bothnian Sea
    ## 36     36    Finland              Aland Sea     Bothnian Sea
    ## 37     37     Sweden           Bothnian Sea     Bothnian Sea
    ## 38     38    Finland           Bothnian Sea     Bothnian Sea
    ## 39     39     Sweden              The Quark     Bothnian Bay
    ## 40     40    Finland              The Quark     Bothnian Bay
    ## 41     41     Sweden           Bothnian Bay     Bothnian Bay
    ## 42     42    Finland           Bothnian Bay     Bothnian Bay

5. Nitrogen Layer Prep
----------------------

### 5.1 Combine N\_load with Target N\_load

### 5.2 Plot time series of load by basin with target indicated

``` r
ggplot(n_load2) +
  geom_point(aes(year,tonnes))+
  geom_line(aes(year,maximum_allowable_input))+
  facet_wrap(~basin, scales ="free_y")
```

![](nutrient_load_prep_files/figure-markdown_github/nload%20ts%20plot-1.png)

### 5.3 Calculate current N load pressure

These values are the same as those found in [Table 1a](http://www.helcom.fi/baltic-sea-trends/indicators/inputs-of-nitrogen-and-phosphorus-to-the-basins/results/) in the column "Average norm. N input 2010-2012".

``` r
n_current = n_load2 %>% 
            filter(year %in% c(2010,2011,2012)) %>% # select three year assessment period
            select (basin, tonnes) %>%
            group_by(basin) %>%
            summarise(n_current = round(mean(tonnes))) %>% #mean load per basin in 3 year period
            ungroup()
n_current
```

    ## Source: local data frame [7 x 2]
    ## 
    ##             basin n_current
    ##             <chr>     <dbl>
    ## 1   Baltic Proper    370012
    ## 2    Bothnian Bay     56962
    ## 3    Bothnian Sea     72846
    ## 4  Danish Straits     53544
    ## 5 Gulf of Finland    116568
    ## 6    Gulf of Riga     91257
    ## 7        Kattegat     63685

### 5.4 Rescale the N load pressure

Data layer needs to be rescaled between 0 (min pressure) and 1 (max pressure).

``` r
n_min = n_load2%>% 
        select(basin,maximum_allowable_input)%>%
        distinct(.)%>%
        dplyr::rename(n_min = maximum_allowable_input)

n_max = n_load2 %>% 
        filter(year%in% 1993:2003)%>%
        select(year, basin, tonnes)%>%
        group_by(basin)%>%
        summarise(n_max = max(tonnes))%>%
        ungroup()
        
## to normalize data: normalized = (x-min(x))/(max(x)-min(x))

n_current_score = n_current %>%
                  full_join(., n_min, by="basin")%>%
                  full_join(.,n_max, by="basin") %>%
                  mutate(n_score = pmax(0,(n_current - n_min) / (n_max - n_min)))%>%
                  select(basin, round(n_score,2))
```

### 5.5 Plot normalized N load pressure score by basin

``` r
par(mar=c(3,2,2,2), oma=c(5,1,1,1))
plot(n_score~c(1:length(n_score)), data=n_current_score,
     xlab="", ylab="N Load Pressure Score",
     xaxt='n',
     pch=19, cex = 1.3,
     ylim=c(-.05,1))
axis(side=1, at=c(seq(1,nrow(n_current_score),1)), labels=n_current_score$basin,
     las=2, cex.axis=.7)
mtext("Basin",side=1, outer=TRUE, line=3)
```

![](nutrient_load_prep_files/figure-markdown_github/nload%20score%20normalized%20basin%20plot-1.png)

### 5.6 Assign basin pressure value to BHI regions

``` r
po_nload = full_join(n_current_score, basin_lookup, by=c("basin"="basin_name_loads"))%>%
              select(rgn_id,n_score) %>%
              dplyr::rename(pressure_score = n_score)
```

### 5.7 Plot map of N pressure score by BHI region

``` r
## BHI Data
library(rgdal)
```

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

``` r
BHIshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", "BHI_regions_plus_buffer_25km")
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", layer: "BHI_regions_plus_buffer_25km"
    ## with 42 features
    ## It has 1 fields

    ## Warning in readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/
    ## BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", : Z-dimension
    ## discarded

``` r
BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp2))
```

    ## [1] "+proj=longlat +init=epsg:4326 +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

``` r
## colors
library(colorRamps)
colfunc <- colorRampPalette(c("royalblue","springgreen", "yellow","red"))
cols10 = colfunc(10)

##Make a copy of the shapefile for plotting

BHIshp_plot = BHIshp2

##join scores to shape file data
BHIshp_plot@data = BHIshp_plot@data %>% left_join(., po_nload, by=c("BHI_ID"= "rgn_id"))
head(BHIshp_plot@data)
```

    ##   BHI_ID pressure_score
    ## 1      1              0
    ## 2      2              0
    ## 3      3              0
    ## 4      4              0
    ## 5      5              0
    ## 6      6              0

``` r
##assign colors to scores
BHIshp_plot@data = BHIshp_plot@data %>%
                mutate(cols = ifelse(pressure_score == 0 , "white",
                              ifelse(pressure_score > 0 & pressure_score <= 0.1, cols10[1], 
                              ifelse(pressure_score > 0.1 & pressure_score <= 0.2,cols10[2],
                              ifelse(pressure_score > 0.2 & pressure_score <= 0.3,cols10[3],
                              ifelse(pressure_score > 0.3 & pressure_score <= 0.4,cols10[4],
                              ifelse(pressure_score > 0.4 & pressure_score <= 0.5,cols10[5],
                              ifelse(pressure_score > 0.5 & pressure_score <= 0.6,cols10[6],
                              ifelse(pressure_score > 0.6 & pressure_score <= 0.7,cols10[7],
                              ifelse(pressure_score > 0.7 & pressure_score <= 0.8,cols10[8],
                              ifelse(pressure_score > 0.8 & pressure_score <= 0.9,cols10[9],
                              ifelse(pressure_score > 0.9 & pressure_score <= 1,cols10[10], NA))))))))))))

head(BHIshp_plot@data)
```

    ##   BHI_ID pressure_score  cols
    ## 1      1              0 white
    ## 2      2              0 white
    ## 3      3              0 white
    ## 4      4              0 white
    ## 5      5              0 white
    ## 6      6              0 white

``` r
plot(BHIshp_plot, col= BHIshp_plot@data$cols,
     main="N Load Pressure")
legend("bottomright", ncol=3, fill=c("white",cols10), 
       legend=c("0",">0-0.1","0.1-0.2","0.2-0.3","0.3-0.4","0.4-0.5","0.5-0.6","0.6-0.7","0.7-0.8","0.8-0.9","0.9-1.0"), title="Pressure Value", cex=.7,bty='n')
```

![](nutrient_load_prep_files/figure-markdown_github/N%20pressure%20on%20map-1.png)

6. Phosphorus Layer Prep
------------------------

### 6.1 Combine P\_load with Target P\_load

``` r
p_load2 = p_load %>% left_join(., mai, by=c("basin", "variable"))
```

### 6.2 Plot time series of load by basin with target indicated

``` r
ggplot(p_load2) +
  geom_point(aes(year,tonnes))+
  geom_line(aes(year,maximum_allowable_input))+
  facet_wrap(~basin, scales ="free_y")
```

![](nutrient_load_prep_files/figure-markdown_github/pload%20ts%20plot-1.png)

### 6.3 Calculate current P load pressure

These values are the same as those found in [Table 1b](http://www.helcom.fi/baltic-sea-trends/indicators/inputs-of-nitrogen-and-phosphorus-to-the-basins/results/) in the column "Average norm. N input 2010-2012".

``` r
p_current = p_load2 %>% 
            filter(year %in% c(2010,2011,2012)) %>% # select three year assessment period
            select (basin, tonnes) %>%
            group_by(basin) %>%
            summarise(p_current = round(mean(tonnes))) %>% #mean load per basin in 3 year period
            ungroup()
p_current
```

    ## Source: local data frame [7 x 2]
    ## 
    ##             basin p_current
    ##             <chr>     <dbl>
    ## 1   Baltic Proper     14651
    ## 2    Bothnian Bay      2824
    ## 3    Bothnian Sea      2527
    ## 4  Danish Straits      1514
    ## 5 Gulf of Finland      6478
    ## 6    Gulf of Riga      2341
    ## 7        Kattegat      1546

### 6.4 Rescale the P load pressure

Data layer needs to be rescaled between 0 (min pressure) and 1 (max pressure).

``` r
p_min = p_load2%>% 
        select(basin,maximum_allowable_input)%>%
        distinct(.)%>%
        dplyr::rename(p_min = maximum_allowable_input)

p_max = p_load2 %>% 
        filter(year%in% 1993:2003)%>%
        select(year, basin, tonnes)%>%
        group_by(basin)%>%
        summarise(p_max = max(tonnes))%>%
        ungroup()
        
## to normalize data: normalized = (x-min(x))/(max(x)-min(x))

p_current_score = p_current %>%
                  full_join(., p_min, by="basin")%>%
                  full_join(.,p_max, by="basin") %>%
                  mutate(p_score = pmax(0,(p_current - p_min) / (p_max - p_min)))%>%
                  select(basin, round(p_score,2))
```

### 6.5 Plot normalized P load pressure score by basin

``` r
par(mar=c(3,2,2,2), oma=c(5,1,1,1))
plot(p_score~c(1:length(p_score)), data=p_current_score,
     xlab="", ylab="N Load Pressure Score",
     xaxt='n',
     pch=19, cex = 1.3,
     ylim=c(-.05,1))
axis(side=1, at=c(seq(1,nrow(p_current_score),1)), labels=p_current_score$basin,
     las=2, cex.axis=.7)
mtext("Basin",side=1, outer=TRUE, line=3)
```

![](nutrient_load_prep_files/figure-markdown_github/pload%20score%20normalized%20basin%20plot-1.png)

### 6.6 Assign basin P pressure value to BHI regions

``` r
po_pload = full_join(p_current_score, basin_lookup, by=c("basin"="basin_name_loads"))%>%
              select(rgn_id,p_score) %>%
              dplyr::rename(pressure_score = p_score)
```

### 6.7 Plot map of P pressure score by BHI region

``` r
## This is already run for N

## BHI Data
# library(rgdal)
# BHIshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", "BHI_regions_plus_buffer_25km")
# BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
# print(proj4string(BHIshp2))
# 
# ## colors
# library(colorRamps)
# colfunc <- colorRampPalette(c("royalblue","springgreen", "yellow","red"))
# cols10 = colfunc(10)

##Make a copy of the shapefile for plotting

BHIshp_plotP = BHIshp2

##join scores to shape file data
BHIshp_plotP@data = BHIshp_plotP@data %>% left_join(., po_pload, by=c("BHI_ID"= "rgn_id"))
head(BHIshp_plotP@data)
```

    ##   BHI_ID pressure_score
    ## 1      1              0
    ## 2      2              0
    ## 3      3              0
    ## 4      4              0
    ## 5      5              0
    ## 6      6              0

``` r
##assign colors to scores
BHIshp_plotP@data = BHIshp_plotP@data %>%
                mutate(cols = ifelse(pressure_score == 0 , "white",
                              ifelse(pressure_score > 0 & pressure_score <= 0.1, cols10[1], 
                              ifelse(pressure_score > 0.1 & pressure_score <= 0.2,cols10[2],
                              ifelse(pressure_score > 0.2 & pressure_score <= 0.3,cols10[3],
                              ifelse(pressure_score > 0.3 & pressure_score <= 0.4,cols10[4],
                              ifelse(pressure_score > 0.4 & pressure_score <= 0.5,cols10[5],
                              ifelse(pressure_score > 0.5 & pressure_score <= 0.6,cols10[6],
                              ifelse(pressure_score > 0.6 & pressure_score <= 0.7,cols10[7],
                              ifelse(pressure_score > 0.7 & pressure_score <= 0.8,cols10[8],
                              ifelse(pressure_score > 0.8 & pressure_score <= 0.9,cols10[9],
                              ifelse(pressure_score > 0.9 & pressure_score <= 1,cols10[10], NA))))))))))))

head(BHIshp_plotP@data)
```

    ##   BHI_ID pressure_score  cols
    ## 1      1              0 white
    ## 2      2              0 white
    ## 3      3              0 white
    ## 4      4              0 white
    ## 5      5              0 white
    ## 6      6              0 white

``` r
plot(BHIshp_plotP, col= BHIshp_plotP@data$cols,
     main="P Load Pressure")
legend("bottomright", ncol=3, fill=c("white",cols10), 
       legend=c("0",">0-0.1","0.1-0.2","0.2-0.3","0.3-0.4","0.4-0.5","0.5-0.6","0.6-0.7","0.7-0.8","0.8-0.9","0.9-1.0"), title="Pressure Value", cex=.7,bty='n')
```

![](nutrient_load_prep_files/figure-markdown_github/P%20pressure%20on%20map-1.png)

Save data as csv in Layers
--------------------------

Save pressure data as csv in layers folder.
Register layers in layers.csv

``` r
write.csv(po_nload , file.path(dir_layers, 'po_nload_bhi2015.csv'), row.names=FALSE)
write.csv(po_pload , file.path(dir_layers, 'po_pload_bhi2015.csv'), row.names=FALSE)
```
