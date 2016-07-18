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
        -   [4.1 Read in Data](#read-in-data)
        -   [4.2 Explore and plot spatial data](#explore-and-plot-spatial-data)
        -   [4.3 Intersect trawling effort with BHI shapefiles](#intersect-trawling-effort-with-bhi-shapefiles)
        -   [4.4 Extract total hours effort by BHI region for each year](#extract-total-hours-effort-by-bhi-region-for-each-year)
        -   [4.5 Plot hours per BHI region](#plot-hours-per-bhi-region)
        -   [4.6 Plot hours/km2 per BHI region](#plot-hourskm2-per-bhi-region)
        -   [4.7](#section)

Bottom Trawling Pressure Layer
==============================

1. Background
-------------

2. Data
-------

### 2.1 Data sources

[HELCOM Pressures and Human Activities Map Service](http://maps.helcom.fi/website/Pressures/index.html) under 'Pressures and Human Activities' then 'Fisheries' then 'Effort' - Select 'Fishing Effort mobile bottom-contacting gear' - annual layers (2009-2013).

Downloaded on July 18, 2016 by Jennifer Griffiths.

**HELCOM metadata**
*The following text is copied directly from the [HELCOM metadata](http://maps.helcom.fi/website/getMetadata/htm/All/Fishing%20effort%20mobile%20bottom-contacting%20gear%202013.htm) file*
"This dataset describes fishing effort (hours/c-square) for mobile bottom-contacting gear based on VMS/Log book data processed by ICES Working Group on Spatial Fisheries Data (WGSFD).

HELCOM requires spatially explicit information on fishing activity affecting the Baltic Sea marine ecosystem for policy purposes. In order to obtain this information a joint ICES/HELCOM/OSPAR data call was issued to relevant authorities of contracting parties to deliver information on fishing activity based on VMS/Log book data. The raw data was submitted to ICES and processed to advice data products by ICES Working Group for Spatial Fisheries (WGSFD) as requested by HELCOM. Processing of the raw data requires specific resources, knowledge and guarantee of anonymity for specific vessels, thus the process was done by ICES WGSFD following Conditions for VMS data use. In 2015 ICES collated Vessel Monitoring System (VMS) and logbook data received; data from Russia were not received. ICES provided to HELCOM advice as fishing abrasion pressure maps as well as fishing effort maps.

The correct data product citation is following: [ICES. 2015. Fishing abrasion pressure maps for mobile bottom-contacting gears in HELCOM area](http://ices.dk/sites/pub/Publication%20Reports/Data%20outputs/HELCOM_mapping_fishing_intensity_and_effort_data_outputs_2015.zip).

**Data caveates**
When using the data for analysis/assessments the following caveats need to be taken into consideration:The methods for identifying fishing activity from the VMS data varied between countries; therefore there may be some country-specific biases that ICES cannot evaluate. Additionally, activities other than active towing of gear may have been incorrectly identified as fishing activity. This would have the effect of overestimating the apparent fishing intensity in ports and in areas used for passage.The data for 2012 and 2013 is not directly comparable to the data of previous years in the data call (2009–2011) due to the gradual increase in VMS-enabled vessels in the range of 12–15 m. This is likely to be most relevant when examining trends in effort for inshore areas.Many countries have substantial fleets of smaller vessels that are not equipped with VMS (The fishing abrasion pressure methodology is based on very broad assumptions in terms of the area affected by abrasion. A single speed and gear width was applied across each gear category in most cases, which can lead to both underestimates and overestimates in actual surface and subsurface abrasion.

### 2.2 Data attributes

#### 2.2.1 Units and Temporal attributes

Layers are yearly effort. Years 2009-2013 Units are in hours fished.

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




dir_trawl    = file.path(dir_prep, 'pressures/bottom_trawling')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_trawl, 'bottom_trawling_prep.rmd') 
```

### 4.1 Read in Data

``` r
## read in data...
```

### 4.2 Explore and plot spatial data

### 4.3 Intersect trawling effort with BHI shapefiles

### 4.4 Extract total hours effort by BHI region for each year

### 4.5 Plot hours per BHI region

### 4.6 Plot hours/km2 per BHI region

### 4.7
