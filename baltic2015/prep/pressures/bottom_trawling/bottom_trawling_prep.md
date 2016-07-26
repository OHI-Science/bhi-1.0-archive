bottom\_trawling\_prep
================

-   [Bottom Trawling Pressure Layer](#bottom-trawling-pressure-layer)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Data sources](#data-sources)
        -   [2.2 Data attributes](#data-attributes)
    -   [3. Pressure Model](#pressure-model)
        -   [3.1 Current pressure data](#current-pressure-data)
        -   [3.2 Rescale data](#rescale-data)
        -   [3.3. Potential issues with pressure model](#potential-issues-with-pressure-model)
    -   [4. Prepare bottom trawl pressure layer](#prepare-bottom-trawl-pressure-layer)
        -   [4.1 Read in Data and Explore](#read-in-data-and-explore)
        -   [plot trawling efforts with BHI boundaries](#plot-trawling-efforts-with-bhi-boundaries)
        -   [4.2 Intersect trawling effort with BHI shapefiles](#intersect-trawling-effort-with-bhi-shapefiles)
        -   [4.4 Extract total fishing hours by BHI region for each year](#extract-total-fishing-hours-by-bhi-region-for-each-year)
        -   [4.5 Plot hours per BHI region](#plot-hours-per-bhi-region)
        -   [4.7](#section)

Bottom Trawling Pressure Layer
==============================

1. Background
-------------

2. Data
-------

### 2.1 Data sources

[HELCOM Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html) under 'Pressures and Human Activities' then 'Fisheries' then 'Effort' - Select 'Fishing Effort mobile bottom-contacting gear' - annual layers (2010-2013).

Downloaded on July 18, 2016 by Jennifer Griffiths.

**HELCOM metadata**
*The following text is copied directly from the [HELCOM metadata](http://maps.helcom.fi/website/getMetadata/htm/All/Fishing%20effort%20mobile%20bottom-contacting%20gear%202013.htm) file*
"This dataset describes fishing effort (hours/c-square) for mobile bottom-contacting gear based on VMS/Log book data processed by ICES Working Group on Spatial Fisheries Data (WGSFD).

HELCOM requires spatially explicit information on fishing activity affecting the Baltic Sea marine ecosystem for policy purposes. In order to obtain this information a joint ICES/HELCOM/OSPAR data call was issued to relevant authorities of contracting parties to deliver information on fishing activity based on VMS/Log book data. The raw data was submitted to ICES and processed to advice data products by ICES Working Group for Spatial Fisheries (WGSFD) as requested by HELCOM. Processing of the raw data requires specific resources, knowledge and guarantee of anonymity for specific vessels, thus the process was done by ICES WGSFD following Conditions for VMS data use. In 2015 ICES collated Vessel Monitoring System (VMS) and logbook data received; data from Russia were not received. ICES provided to HELCOM advice as fishing abrasion pressure maps as well as fishing effort maps.

The correct data product citation is following: [ICES. 2015. Fishing abrasion pressure maps for mobile bottom-contacting gears in HELCOM area](http://ices.dk/sites/pub/Publication%20Reports/Data%20outputs/HELCOM_mapping_fishing_intensity_and_effort_data_outputs_2015.zip).

**Data caveates**
When using the data for analysis/assessments the following caveats need to be taken into consideration:The methods for identifying fishing activity from the VMS data varied between countries; therefore there may be some country-specific biases that ICES cannot evaluate. Additionally, activities other than active towing of gear may have been incorrectly identified as fishing activity. This would have the effect of overestimating the apparent fishing intensity in ports and in areas used for passage.The data for 2012 and 2013 is not directly comparable to the data of previous years in the data call (2010–2011) due to the gradual increase in VMS-enabled vessels in the range of 12–15 m. This is likely to be most relevant when examining trends in effort for inshore areas. Many countries have substantial fleets of smaller vessels that are not equipped with VMS (The fishing abrasion pressure methodology is based on very broad assumptions in terms of the area affected by abrasion. A single speed and gear width was applied across each gear category in most cases, which can lead to both underestimates and overestimates in actual surface and subsurface abrasion.

### 2.2 Data attributes

#### 2.2.1 Units and Temporal attributes

Layers are yearly effort. Years 2010-2013 Units are in hours fished.

#### 2.2.2 Spatial reference information

*Provided in the HELCOM file*
Spatial Reference, ArcGIS coordinate system

Type: Projected
Geographic coordinate reference:GCS\_ETRS\_1989
Projection: ETRS\_1989\_LAEA

Coordinate reference details:
Well-known identifier:3035
X origin: -8426600
Y origin: -9526700
XY scale: 10000
Z origin: 0
Z scale: 1
M origin: 0
M scale: 1
XY tolerance: 0.001
Z tolerance: 0.001
M tolerance: 0.001
High precision: true
Latest well-known identifier: 3035
Well-known text: PROJCS\["ETRS\_1989\_LAEA",GEOGCS\["GCS\_ETRS\_1989",DATUM\["D\_ETRS\_1989",SPHEROID\["GRS\_1980",6378137.0,298.257222101\]\],PRIMEM\["Greenwich",0.0\],UNIT\["Degree",0.0174532925199433\]\],PROJECTION\["Lambert\_Azimuthal\_Equal\_Area"\],PARAMETER\["False\_Easting",4321000.0\],PARAMETER\["False\_Northing",3210000.0\],PARAMETER\["Central\_Meridian",10.0\],PARAMETER\["Latitude\_Of\_Origin",52.0\],UNIT\["Meter",1.0\],AUTHORITY\["EPSG",3035\]\]

3. Pressure Model
-----------------

Overlay trawl effort with BHI shape files so can assign effort per each BHI region.

### 3.1 Current pressure data

Use most recent year: 2013
Xtrawl\_r\_y = sum hours within a BHI region in each year *y* in each region *r* / area of BHI region *r* (hours/km2)

### 3.2 Rescale data

Calculate Xtrawl\_r\_y for all data years.

min value = 0

max value = max(Xtrawl\_r\_y) in any area
*It should be discussed with the team if this is okay, or if think even higher pressure in the past, should take pressure\_max = max(XtrawL\_r\_y) x 1.2 or some greater percentage?*

### 3.3. Potential issues with pressure model

See data caveats above in section 2.1. In earlier years, fewer VMS enabled ships, thus fishing effort maybe higher in later years simply because not captured by data. Think about max value (see comment above).

4. Prepare bottom trawl pressure layer
--------------------------------------

### 4.1 Read in Data and Explore

``` r
## directory setup
dir_M <- c('Windows' = '//mazu.nceas.ucsb.edu/ohi',
           'Darwin'  = '/Volumes/ohi',    ### connect (cmd-K) to smb://mazu/ohi
           'Linux'   = '/home/shares/ohi')[[ Sys.info()[['sysname']] ]]

if (Sys.info()[['sysname']] != 'Linux' & !file.exists(dir_M)){
  warning(sprintf("The Mazu directory dir_M set in src/R/common.R does not exist. Do you need to mount Mazu: %s?", dir_M))
  # TODO: @jennifergriffiths reset dir_M to be where the SRC hold your shapefiles
}

dir_shp <- file.path(dir_M, 'git-annex/Baltic')

# list.files(file.path(dir_shp, 'Bottom_trawling_pressure'))
# contains data from 2009 to 2013

## read in bottom trawling pressure data from 2010

trawling_raw_2009 <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bottom_trawling_pressure')),
                      layer = 'HELCOM_effort_year_MBCG_VMS_2009')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bottom_trawling_pressure", layer: "HELCOM_effort_year_MBCG_VMS_2009"
    ## with 5276 features
    ## It has 6 fields

``` r
trawling_raw_2010 <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bottom_trawling_pressure')),
                      layer = 'HELCOM_effort_year_MBCG_VMS_2010')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bottom_trawling_pressure", layer: "HELCOM_effort_year_MBCG_VMS_2010"
    ## with 5195 features
    ## It has 6 fields

``` r
trawling_raw_2011 <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bottom_trawling_pressure')),
                      layer = 'HELCOM_effort_year_MBCG_VMS_2011') 
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bottom_trawling_pressure", layer: "HELCOM_effort_year_MBCG_VMS_2011"
    ## with 5291 features
    ## It has 6 fields

``` r
trawling_raw_2012 <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bottom_trawling_pressure')),
                      layer = 'HELCOM_effort_year_MBCG_VMS_2012') 
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bottom_trawling_pressure", layer: "HELCOM_effort_year_MBCG_VMS_2012"
    ## with 4839 features
    ## It has 6 fields

``` r
trawling_raw_2013 <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bottom_trawling_pressure')),
                      layer = 'HELCOM_effort_year_MBCG_VMS_2013') 
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bottom_trawling_pressure", layer: "HELCOM_effort_year_MBCG_VMS_2013"
    ## with 5025 features
    ## It has 6 fields

``` r
##  extract crs_trawling for scaling 

# trawling_raw_2010@proj4string
# +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs 
crs_trawling = CRS("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs")

## read in bhi shape files
bhi = rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'BHI_MCG_shapefile')),
                      layer = 'BHI_MCG_11052016')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

``` r
bhi_data = bhi@data

## change bhi coord. system to the same as trawling efforts
bhi = spTransform(bhi, crs_trawling)
```

### plot trawling efforts with BHI boundaries

``` r
par(mfrow = c(5, 1), mar = c(1,1,1,1))

plot(trawling_raw_2009, col = 'blue', border = "blue"); plot(bhi, border = "grey", main = "BHI regions and Trawling Efforts overlay", add = TRUE); legend('bottomright', c("BHI regions", "Trawling efforts  (2010)"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "blue"), text.font = 1, box.lty = 0 )

plot(trawling_raw_2010, col = 'blue', border = "blue"); plot(bhi, border = "grey", main = "BHI regions and Trawling Efforts overlay", add = TRUE); legend('bottomright', c("BHI regions", "Trawling efforts (2010)"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "blue"), text.font = 1, box.lty = 0 )

plot(trawling_raw_2011, col = 'blue', border = "blue"); plot(bhi, border = "grey", main = "BHI regions and Trawling Efforts overlay", add = TRUE); legend('bottomright', c("BHI regions", "Trawling efforts (2011)"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "blue"), text.font = 1, box.lty = 0 )

plot(trawling_raw_2012, col = 'blue', border = "blue"); plot(bhi, border = "grey", main = "BHI regions and Trawling Efforts overlay", add = TRUE); legend('bottomright', c("BHI regions", "Trawling efforts (2012)"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "blue"), text.font = 1, box.lty = 0 )

plot(trawling_raw_2013, col = 'blue', border = "blue"); plot(bhi, border = "grey", main = "BHI regions and Trawling Efforts overlay", add = TRUE); legend('bottomright', c("BHI regions", "Trawling efforts (2013)"), lty = c(1,1), lwd = c(2.5, 2.5, 2.5), col = c("grey", "blue"), text.font = 1, box.lty = 0 )
```

![](bottom_trawling_prep_files/figure-markdown_github/plot%20data-1.png)

### 4.2 Intersect trawling effort with BHI shapefiles

### 4.4 Extract total fishing hours by BHI region for each year

### 4.5 Plot hours per BHI region

``` r
setwd(file.path(dir_trawl, 'temp_data'))

hours_per_area_file_list = list.files(path= file.path(dir_trawl, 'temp_data'),
                            pattern="hours_per_area_[0-9]+.csv")

for (i in hours_per_area_file_list) {
   
dat = read_csv(hours_per_area_file_list[1])

plot(dat, main = "Total fishing hours per km2 per region")


## didn't work coz each year contains different number of rows/rgions
# for (i in 2:length(hours_per_area_file_list)) {
#   
#  d = read_csv(hours_per_area_file_list[i]) 
#  dat = rbind(dat, d) %>%
#    mutate(year = substr(hours_per_area_file_list[i], 16, 19))
# 
# }

# hours_per_area_all = dat
  
}
```

![](bottom_trawling_prep_files/figure-markdown_github/plot%20hours%20per%20region-1.png)

### 4.7
