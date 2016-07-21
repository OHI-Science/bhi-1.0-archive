cs\_prep
================

-   [Carbon Storage (CS) Data prep](#carbon-storage-cs-data-prep)
    -   [1. Background on Zostera data](#background-on-zostera-data)
        -   [1.1 Why Zostera data](#why-zostera-data)
        -   [1.2 Zostera species in the Baltic Sea](#zostera-species-in-the-baltic-sea)
        -   [1.3 Related publications](#related-publications)
    -   [2. Data source](#data-source)
        -   [1.1 Download information](#download-information)
        -   [2.2 Additional background](#additional-background)
    -   [3. CS goal model overview](#cs-goal-model-overview)
        -   [3.1 Status](#status)
        -   [3.2 Trend](#trend)
    -   [4. Layer prep](#layer-prep)
        -   [4.1 Read in data](#read-in-data)
        -   [4.2 Explore and plot data](#explore-and-plot-data)
        -   [4.3 Intersect the BHI shapefiles and zostera data](#intersect-the-bhi-shapefiles-and-zostera-data)
        -   [4.4 Status Calcuation](#status-calcuation)

Carbon Storage (CS) Data prep
=============================

1. Background on Zostera data
-----------------------------

### 1.1 Why Zostera data

### 1.2 Zostera species in the Baltic Sea

### 1.3 Related publications

[Boström et al 2014](http://onlinelibrary.wiley.com/doi/10.1002/aqc.2424/abstract)

[HELCOM Red List Biotope Information Sheet](http://helcom.fi/Red%20List%20of%20biotopes%20habitats%20and%20biotope%20complexe/HELCOM%20Red%20List%20AA.H1B7,%20AA.I1B7,%20AA.J1B7,%20AA.M1B7.pdf)

2. Data source
--------------

### 1.1 Download information

[HELCOM Marine Spatial Planning Map Service](http://maps.helcom.fi/website/msp/index.html)
Select - Marine Spatial Planning - Ecology - Ecosystem Health status
Data layer - "Zostera Meadows"
Downloaded on 10 May 2016 by Jennifer Griffiths

[Metadata link](http://maps.helcom.fi/website/getMetadata/htm/All/Zostera%20meadows.htm)

### 2.2 Additional background

*Notes from Joni Kaitaranta (HELCOM)*: According to the Zostera meadows metadata there is many data sources. The dataset was compiled in 2009-2010 for the HOLAS I assessment so the dataset is not very recent. Major source was Boström et al. 2003. In: Spalding et al. World Atlas of Seagrasses but there was also national e.g. from NERI Denmark downloaded in 2009 from a URL that is no longer valid.

*Data Structure*: Is unclear, spatial files need to be reviewed. Is it just points, or does it include areal coverage of Zostera. Data observations are accompanies by either "dense" or "sparse."

3. CS goal model overview
-------------------------

### 3.1 Status

X\_cs\_region = Current\_area\_Zostera\_meadows\_region / Reference\_pt\_region

Reference\_pt\_region = Current\_area\_Zostera\_meadows \* 1.25
This is based upon ["During the last 50 years the distribution of the Zostera marina biotope has declined &gt;25%. The biotope has declined to varying extents in the different Baltic Sea regions."](http://helcom.fi/Red%20List%20of%20biotopes%20habitats%20and%20biotope%20complexe/HELCOM%20Red%20List%20AA.H1B7,%20AA.I1B7,%20AA.J1B7,%20AA.M1B7.pdf)

**If data are not areal coverage**: if data are simply points of presence, need to rethink goal model

### 3.2 Trend

Use the trend of NUT subcomponent for CW goal (e.g. secchi status trend).

Read the file in from 'layers' and resave as the CS trend for layers.

4. Layer prep
-------------

### 4.1 Read in data

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
```

### 4.2 Explore and plot data

We explored the Zostera data and see how that matches with the BHI region shape files. They seem to overlap well.

``` r
## read in Zostera data
cs_data <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'Bostera_meadows')),
                          layer = 'Zostera meadows')  
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/Bostera_meadows", layer: "Zostera meadows"
    ## with 5960 features
    ## It has 8 fields

``` r
#plot(cs_data, col = cs_data@data$coverage )
#head(cs_data@data) 

#  cs_data@proj4string: 
#  +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs 

## plot data: bhi regions and Zostera
bhi <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'BHI_MCG_shapefile')),
                      layer = 'BHI_MCG_11052016')
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

``` r
bhi_transform = spTransform(bhi, cs_data@proj4string) # transform bhi to the same coordinate system; bhi from lsp_prep. need to expand here. 

plot(bhi_transform, col = 'light blue', border = "grey", main = "BHI regions and Meadows intersect"); plot(cs_data, col = 'blue', add = TRUE) 
```

![](cs_prep_files/figure-markdown_github/explore%20data-1.png)

``` r
# system.time({cs_bhi_intersect <- raster::intersect(cs_data, bhi_transform)})
```

### 4.3 Intersect the BHI shapefiles and zostera data

The zostera data contains areal extent that matches well with the BHI regions. The graph below shows overlay of zostera data with BHI region shape file - each blue cross is a sampling site with coordinates and coverage type (dense, sparse, or NA).

**Problem**: The area listed in the Bostera file only contained the lcoation of each sampling point, but not the area of vegetation coverage. The area data seems to be the total area of the BHI region. Therefore, we can't calculate the total area of Bostera as planned.

``` r
cs_bhi_intersect = sp::over(cs_data, bhi_transform)
# head(cs_bhi_intersect)
# plot(cs_bhi_intersect)

cs_bhi_data = cbind(cs_bhi_intersect, cs_data@data) %>%
  dplyr::select(country = rgn_nam, BHI_ID, Area_km2, coverage) %>%
  filter(!is.na(country))

DT::datatable(cs_bhi_data)
```

![](cs_prep_files/figure-markdown_github/intersect%20and%20save%20csv-1.png)

``` r
# save data as csv
# write_csv(cs_bhi_data, file.path(dir_cs, 'cs_bhi_data.csv'))
```

### 4.4 Status Calcuation

Two appraoches to calculat the status of Carbon storage according to coverage types.

1.  weigh the coverage types: NA, sparse, and dense (as 0, 0.5, and 1), and average the weights
2.  no weights, and all presence (eg sparse or dense) = 1

Original plan to set up the reference point:

"During the last 50 years the distribution of the Zostera marina biotope has declined &gt;25%. The biotope has declined to varying extents in the different Baltic Sea regions. The decline in the southern areas of the Baltic Sea begun almost 100 years ago, however there is not enough reliable information to classify the biotope under A3 which requires data or inference as to the decline in quantity over the last 150 years. There are two alternatives to reference point.

1.  Could use current extent x 1.25 applied equally to all BHI regions as a reference point?'
2.  use the current extent of zostera meadows (total area) in each BHI region. Use status as that extent\*weight of threat level (by BHI region only). Therefore if zostera not threatened in a BHI region - score is 100 because full extent is not threatened. If threatened, score is lower?"

TODO: decide what to do with area data. See section 4.3.

``` r
cov_type_wt = data.frame(coverage = c("NA", "sparse", "dense"), 
                         weight = c(1, 0.5, 1))

cs_with_wt = cs_bhi_data %>%
  full_join(cov_type_wt, 
            by = "coverage")
```

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factors with different levels, coercing to character vector

``` r
DT::datatable(cs_with_wt)
```

![](cs_prep_files/figure-markdown_github/status%20Alt%201%20Ref%20Alt%201-1.png)
