illegal\_oil\_prep
================

-   [Prep of Illegal Oil Spill pressure data layer](#prep-of-illegal-oil-spill-pressure-data-layer)
    -   [1 Data](#data)
    -   [2. Pressure model](#pressure-model)
        -   [2.1 Current conditions](#current-conditions)
        -   [2.2 Rescaling 0 to 1](#rescaling-0-to-1)
    -   [3. Data Layer preparation](#data-layer-preparation)
        -   [Data prep setup](#data-prep-setup)
        -   [Read in data and explore](#read-in-data-and-explore)
        -   [Calculate pressure scores](#calculate-pressure-scores)

Prep of Illegal Oil Spill pressure data layer
=============================================

### 1 Data

Data were downloaded from [HELCOM's Baltic Sea Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html). Data were under the tab 'Maritime & Response' then 'Illegal Oil Discharges'

Data were downloaded on 17 March 2016.

Data are available from 1998-2014.

Data are listed with a location (lat, lon) and a Estimated spill volume. Sometimes spill area is also provided.

2. Pressure model
-----------------

Assign all spill locations a BHI ID. Sum the total volume of illegal oil spilled in each BHI region in each year.

Calculate the volume spilled per region surface area

Note- Exclude reported spills with volume

Provide summary of total oil spills reported per year per BHI region, number reported with volumes per year per BHI region

### 2.1 Current conditions

Mean volume spilled in each BHI region 2009-2014 / region surface area

### 2.2 Rescaling 0 to 1

min value = 0

max value = max annual volume spilled / per surface area *spatial reference*

3. Data Layer preparation
-------------------------

Steps:

1.  Get a BHI region assignment for all oil spill reports - do this by overlaying lat, lon locations with BHI shapefile
2.  Get volume spilled by year by BHI region (also visualize number of spills per year per BHI region, number of spills with zero volumne reported)
3.  Get current conditions, find max value, rescale data to between 0 and 1
4.  Export and register data layer

#### Data prep setup

``` r
## Libraries

library(tidyverse) # install.packages('tidyverse')
library(RMySQL)
library(tools)
library(rprojroot) # install.packages('rprojroot')
library(rgdal)  # install.packages('rgdal')
library(raster) # install.packages('raster')
library(rgeos)  # install.packages('rgeos')

source('~/github/bhi/baltic2015/prep/common.r')

## rprojroot
root <- rprojroot::is_rstudio_project

## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') 

## directory setup to the server at NCEAS; contact NCEAS if you need to run this file. 
dir_M <- c('Windows' = '//mazu.nceas.ucsb.edu/ohi',
           'Darwin'  = '/Volumes/ohi',    ### connect (cmd-K) to smb://mazu/ohi
           'Linux'   = '/home/shares/ohi')[[ Sys.info()[['sysname']] ]]

if (Sys.info()[['sysname']] != 'Linux' & !file.exists(dir_M)){
  
  warning(sprintf("The Mazu directory dir_M set in src/R/common.R does not exist. Do you need to mount Mazu: %s?", dir_M))

}

dir_shp <- file.path(dir_M, 'git-annex/Baltic')

dir_oil    = file.path(dir_prep, 'pressures/illegal_oil_discharge')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_oil, 'illegal_oil_prep.rmd') 
```

#### Read in data and explore

``` r
## read in BHI shape file
bhi = rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'BHI_MCG_shapefile')),
                     layer = 'BHI_MCG_11052016')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

``` r
# bhi@proj4string  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 

# list files in illegal oil data base
# list.files(file.path(dir_shp, "Illegal_Oil_Discharges"))

## read in Illegal Oil Discharge file
  
oil = rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Illegal_Oil_Discharges')),
                     layer = 'IllegalOilDischarges')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Illegal_Oil_Discharges", layer: "IllegalOilDischarges"
    ## with 4338 features
    ## It has 20 fields

``` r
oil_data = oil@data

write_csv(oil_data, file.path(dir_oil, "oil_data_raw.csv"))

# oil@proj4string
#  +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs 

# years covered: 
# unique(oil_data$Year)
# 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014

bhi = spTransform(bhi, CRS("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs"))


## plot data
plot(oil); plot(bhi, border = "grey", main = "Illegal Oil Discharges and BHI regions overlay", add = TRUE); legend('bottom', c("BHI regions", " Illegal Oil Discharges"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "black"), text.font = 1, box.lty = 0 )
```

![](illegal_oil_prep_files/figure-markdown_github/read%20in%20data-1.png)

``` r
## intersect with BHI regions
oil_bhi_intersect = raster::intersect(oil, bhi)
# plot(oil_bhi_intersect)
# head(oil_bhi_intersect@data)
```

#### Calculate pressure scores

``` r
## read in oil data, calculate average vol/area
data = oil_bhi_intersect@data[,-1] %>% #get rid of duplicated column, otherwise select doesn't work...
  dplyr::select(BHI_ID,
                year = Year, 
                volume = EstimVol_m, # m3
                area_km2 = Area_km2) %>% 
  filter(year %in% 2009:2014) %>% 
  group_by(BHI_ID, year, area_km2) %>% 
  summarize(total_vol = sum(volume*(10^(-9)))) %>% # total annual vol of each year in km3
  ungroup() %>% 
  group_by(BHI_ID, area_km2) %>% 
  summarize(ave_vol = mean(total_vol)) %>% # average vol 2009-2014
  ungroup() %>% 
  mutate(score = ave_vol/area_km2, 
         min_score = min(score), 
         max_score = max(score))   # ave_vol / area

# calculate pressure scores 
oil_pressure = data %>% 
  mutate(pressure_score = round((score-min_score)/(max_score - min_score), 2)) %>% 
  dplyr::select(rgn_id = BHI_ID, 
                pressure_score) %>% 
  complete(rgn_id = full_seq(rgn_id, 1))

# save in layers folder
write_csv(oil_pressure, file.path(dir_layers, 'hab_illegal_oil_bhi2015.csv'))
```
