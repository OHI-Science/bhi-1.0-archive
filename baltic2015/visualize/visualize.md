visualize
================

-   [Visualize data dimensions and goals outcomes](#visualize-data-dimensions-and-goals-outcomes)
    -   [Source functions](#source-functions)
    -   [Set local directory for pdf output](#set-local-directory-for-pdf-output)
    -   [AO Goal](#ao-goal)
    -   [CON subgoal](#con-subgoal)
    -   [NUT subgoal](#nut-subgoal)
    -   [TRA subgoal](#tra-subgoal)
    -   [ECO subgoal](#eco-subgoal)
    -   [FIS subgoal](#fis-subgoal)
    -   [ICO subgoal](#ico-subgoal)
    -   [LIV subgoal](#liv-subgoal)
    -   [TR subgoal](#tr-subgoal)
    -   [MAR subgoal](#mar-subgoal)
    -   [BD](#bd)
-   [GOALS](#goals)
    -   [CW](#cw)
    -   [FP](#fp)
    -   [LE](#le)
    -   [SP](#sp)
    -   [Plot Pressure and resilience data layers](#plot-pressure-and-resilience-data-layers)

Visualize data dimensions and goals outcomes
============================================

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
library(ggmap)
library(RMySQL)
```

    ## Loading required package: DBI

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')

## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = rprojroot::is_rstudio_project)


dir_baltic = make_path('baltic2015')
dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')


# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))

dir_vis    = file.path(dir_baltic,'visualize')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_vis, 'visualize.rmd')
```

Source functions
----------------

``` r
source(file.path(dir_baltic, 'PlotMap.r'))
source(file.path(dir_baltic, 'PrepSpatial.r'))
```

    ## Loading required package: sp

    ## Checking rgeos availability: TRUE

    ## rgdal: version: 1.1-10, (SVN revision 622)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 1.11.4, released 2016/01/25
    ##  Path to GDAL shared files: /Library/Frameworks/R.framework/Versions/3.3/Resources/library/rgdal/gdal
    ##  Loaded PROJ.4 runtime: Rel. 4.9.1, 04 March 2015, [PJ_VERSION: 491]
    ##  Path to PROJ.4 shared files: /Library/Frameworks/R.framework/Versions/3.3/Resources/library/rgdal/proj
    ##  Linking to sp version: 1.2-3

``` r
source(file.path(dir_vis,'visualize_functions.r'))
```

Set local directory for pdf output
----------------------------------

``` r
# pdf_dir = c("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/Output")
pdf_dir = c("/Users/julialowndes/Dropbox/NCEAS_Julie/OHI_Regional/OHI_Baltic/_documentation/visualize_reports")
```

AO Goal
-------

``` r
## set values and location
goal_select = "AO"

##data

##space data
space_data = read.csv(file.path(dir_vis,'ao_space_data.csv'), stringsAsFactors = FALSE)

## time data
## no time series

#value_data
value_data = read.csv(file.path(dir_vis,'ao_value_data.csv'), stringsAsFactors = FALSE)
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal==goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
      plot_datalocation_latlon(space_data)
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=hybrid&language=en-EN&sensor=false

``` r
      ## plot raw values single time period by staton
      plot_datavalue(value_data, variable=TRUE)
      
      ##plot raw times series by station
      #plot_datatime (time_data, "station", variable=TRUE)
      
      ##plot raw time series by basin
      #plot_datatime (time_data, "basin", variable=TRUE)
      
      ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal("resilience", goal_select)
```

    ## Warning: Removed 9 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

CON subgoal
-----------

``` r
## set values and location
goal_select = "CON"
ind= c("pcb", "dioxin", "pfos")

##data
space_pcb= read.csv(file.path(dir_vis,'con_pcb_space_data.csv'), stringsAsFactors = FALSE)
space_diox= read.csv(file.path(dir_vis,'con_dioxin_space_data.csv'), stringsAsFactors = FALSE)
space_pfos= read.csv(file.path(dir_vis,'con_pfos_space_data.csv'), stringsAsFactors = FALSE)


#time_data
time_pcb= read.csv(file.path(dir_vis,'con_pcb_time_data.csv'), stringsAsFactors = FALSE)
time_diox= read.csv(file.path(dir_vis,'con_dioxin_time_data.csv'), stringsAsFactors = FALSE)
time_pfos= read.csv(file.path(dir_vis,'con_pfos_time_data.csv'), stringsAsFactors = FALSE)

  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
        plot_datalocation_latlon(space_pcb)
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=hybrid&language=en-EN&sensor=false

``` r
        plot_datalocation_latlon(space_diox)
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)
    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=hybrid&language=en-EN&sensor=false

``` r
        plot_datalocation_latlon(space_pfos)
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)
    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=hybrid&language=en-EN&sensor=false

``` r
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
   
      plot_datatime(time_pcb, facet_type= "station",variable =FALSE)
      
      plot_datatime(time_diox, facet_type= "station",variable =TRUE)
```

    ## Warning: Removed 26 rows containing missing values (geom_point).

``` r
      plot_datatime(time_pfos, facet_type= "station",variable =FALSE)
```

    ## Warning: Removed 32 rows containing missing values (geom_point).

``` r
      ##plot raw time series by basin
       plot_datatime(time_pcb, facet_type= "basin",variable =FALSE)
      
      plot_datatime(time_diox, facet_type= "basin",variable =TRUE)
```

    ## Warning: Removed 26 rows containing missing values (geom_point).

``` r
      plot_datatime(time_pfos, facet_type= "basin",variable =FALSE)
```

    ## Warning: Removed 32 rows containing missing values (geom_point).

``` r
      ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal("resilience", goal_select)
```

    ## Warning: Removed 27 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

NUT subgoal
-----------

``` r
## set values and location
goal_select = "NUT"


##data
space_data= read.csv(file.path(dir_vis,'nut_space_data.csv'), stringsAsFactors = FALSE)


#time_data
time_data= read.csv(file.path(dir_vis,'nut_time_data.csv'), stringsAsFactors = FALSE)

  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
        plot_datalocation_latlon(space_data)
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=hybrid&language=en-EN&sensor=false

``` r
      ## plot raw values single time period by staton
      #NA
      
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       plot_datatime (time_data, facet_type= "basin",variable =TRUE)
      
       ##plot raw times series by rgn_id
      ## NA 
       
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

TRA subgoal
-----------

``` r
## set values and location
goal_select = "TRA"

##space data
##NA

## value data
value_data= read.csv(file.path(dir_vis,'tra_value_data.csv'), stringsAsFactors = FALSE)


#time_data
##NA
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
       plot_datavalue(value_data, variable=FALSE)
      
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

ECO subgoal
-----------

``` r
## set values and location
goal_select = "ECO"

##space data
##NA

## value data
##NA


#time_data
time_data_rgn = read.csv(file.path(dir_baltic, 'visualize/eco_rgn_time_data.csv'), stringsAsFactors=FALSE)

time_data_nat = read.csv(file.path(dir_baltic, 'visualize/eco_nat_time_data.csv'), stringsAsFactors=FALSE)
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       plot_datatime (time_data_rgn, facet_type= "rgn_id", variable =FALSE)
       plot_datatime (time_data_nat, facet_type= "rgn_id", variable =FALSE)
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

``` r
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 18 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

FIS subgoal
-----------

``` r
## set values and location
goal_select = "FIS"

##space data
##NA

## value data
##NA


#time_data
time_data_bbmsy = read.csv(file.path(dir_baltic, 'visualize/fis_bbmsy_time_data.csv'), stringsAsFactors=FALSE)

time_data_ffmsy = read.csv(file.path(dir_baltic, 'visualize/fis_ffmsy_time_data.csv'), stringsAsFactors=FALSE)
  
time_data_landings = read.csv(file.path(dir_baltic, 'visualize/fis_landings_time_data.csv'), stringsAsFactors=FALSE)
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       plot_datatime (time_data_bbmsy, facet_type= "ices", variable =FALSE)
       plot_datatime (time_data_ffmsy, facet_type= "ices", variable =FALSE)
       plot_datatime (time_data_landings, facet_type= "ices", variable =FALSE)
       
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 18 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

ICO subgoal
-----------

``` r
## set values and location
goal_select = "ICO"

##space data
##NA

## value data
# value_threat= read.csv(file.path(dir_vis,'ico_threat_value_data.csv'), stringsAsFactors = FALSE)
value_dist= read.csv(file.path(dir_vis,'ico_dist_value_data.csv'), stringsAsFactors = FALSE)

#time_data
##NA
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
    
      plot_datavalue(value_dist, variable=TRUE)
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
      
      ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 18 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

LIV subgoal
-----------

``` r
## set values and location
goal_select = "LIV"

##space data
##NA

## value data
##NA


#time_data
time_data_rgn = read.csv(file.path(dir_baltic, 'visualize/liv_rgn_time_data.csv'), stringsAsFactors=FALSE)

time_data_nat = read.csv(file.path(dir_baltic, 'visualize/liv_nat_time_data.csv'), stringsAsFactors=FALSE)
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       plot_datatime (time_data_rgn, facet_type= "rgn_id", variable =FALSE)
```

    ## Warning: Removed 69 rows containing missing values (geom_point).

``` r
       plot_datatime (time_data_nat, facet_type= "rgn_id", variable =FALSE)
```

    ## Warning: Removed 9 rows containing missing values (geom_point).

``` r
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

TR subgoal
----------

``` r
## set values and location
goal_select = "TR"

##space data
##NA

## value data
##NA


#time_data
time_data = read.csv(file.path(dir_baltic, 'visualize/tr_time_data.csv'), stringsAsFactors=FALSE)

##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       plot_datatime (time_data, facet_type= "rgn_id", variable =FALSE)
```

    ## Warning: Removed 24 rows containing missing values (geom_point).

``` r
       ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

``` r
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 21 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

MAR subgoal
-----------

``` r
## set values and location
goal_select = "MAR"

##space data
##NA

## value data
##NA


#time_data
time_data_countryrgn = read.csv(file.path(dir_baltic, 'visualize/mar_countryrgn_time_data.csv'), stringsAsFactors=FALSE)
time_data_rgn = read.csv(file.path(dir_baltic, 'visualize/mar_rgn_time_data.csv'), stringsAsFactors=FALSE)

##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
      #NA
      
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
       plot_datatime (time_data_countryrgn, facet_type= "mar_region", variable =FALSE)
```

    ## Warning: Removed 15 rows containing missing values (geom_point).

``` r
      plot_datatime (time_data_rgn, facet_type= "rgn_id", variable =FALSE)
      
      ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

BD
--

SPP results for BD

``` r
## set values and location
goal_select = "BD"

##space data
##NA

## value data
value_dist= read.csv(file.path(dir_vis,'spp_dist_value_data.csv'), stringsAsFactors = FALSE)
value_dist_threat= read.csv(file.path(dir_vis,'spp_dist_threat_value_data.csv'), stringsAsFactors = FALSE)

#time_data
##NA
  
##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)%>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

      ##plot raw spatial
       ##NA
 
      
      ## plot raw values single time period by staton
    
      plot_datavalue(value_dist, variable=TRUE)
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

``` r
      plot_datavalue(value_dist_threat, variable=TRUE)
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

``` r
      ##plot raw times series by station
      ## NA 
      
      ##plot raw time series by basin
       ##NA
      
       ##plot raw times series by rgn_id
      
      ##plot pressure data layers and weights for goal
      plotPressuresResilienceGoal ("pressures", goal_select)
      
      ##plot resilience data layers and weights for goal
      plotPressuresResilienceGoal ("resilience", goal_select)
```

    ## Warning: Removed 27 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

GOALS
=====

CW
--

``` r
##goal_select
goal_select = "CW"

## set parameters for subgoal comparison
count_goals = 3
subgoal_abb = c("NUT","CON","TRA")

##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)
scores_filter =scores %>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

    ##plot subgoal and goal all dimensions
    plotSubgoalsGoal(count_goals, scores, subgoal_abb,goal_select)
```

    ## Warning: Removed 204 rows containing missing values (geom_point).

``` r
    ##plot subgoal and goal all dimensions, barplot
    plotSubgoalsGoal_bar(count_goals, scores, subgoal_abb,goal_select)
    
    ##plot subgoal relationship by dimensions
    plotSubgoalRelationship(count_goals, scores, subgoal_abb,goal_select)
```

    ## Warning: Removed 93 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores_filter,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

FP
--

``` r
##goal_select
goal_select = "FP"

## set parameters for subgoal comparison
count_goals = 2
subgoal_abb = c("FIS","MAR")

##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)
scores_filter =scores %>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

    ##plot subgoal and goal all dimensions
    plotSubgoalsGoal(count_goals, scores, subgoal_abb,goal_name =goal_select)
```

    ## Warning: Removed 152 rows containing missing values (geom_point).

``` r
     ##plot subgoal and goal all dimensions, barplot
    plotSubgoalsGoal_bar(count_goals, scores, subgoal_abb,goal_select)
   
    ##plot subgoal relationship by dimensions
    plotSubgoalRelationship(count_goals, scores, subgoal_abb,goal_select)
```

    ## Warning: Removed 68 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores_filter,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

LE
--

``` r
##goal_select
goal_select = "LE"

## set parameters for subgoal comparison
count_goals = 2
subgoal_abb = c("ECO","LIV")

##Scores
scores = read.csv(file.path(dir_baltic,'scores.csv'),stringsAsFactors =FALSE)
scores_filter =scores %>%
              filter(goal== goal_select)


##-------------------------------------------##
## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

    ##plot subgoal and goal all dimensions
    plotSubgoalsGoal(count_goals, scores, subgoal_abb,goal_select)
```

    ## Warning: Removed 159 rows containing missing values (geom_point).

``` r
     ##plot subgoal and goal all dimensions, barplot
    plotSubgoalsGoal_bar(count_goals, scores, subgoal_abb,goal_select)
   
    ##plot subgoal relationship by dimensions
    plotSubgoalRelationship(count_goals, scores, subgoal_abb,goal_select)
```

    ## Warning: Removed 35 rows containing missing values (geom_point).

``` r
      ##plot Map of Each score type
      plotScoreTypes(scores_filter,goal_select)
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

    ## OGR data source with driver: GeoJSON 
    ## Source: "/Users/julialowndes/github/bhi/baltic2015/spatial/regions_gcs.geojson", layer: "OGRGeoJSON"
    ## with 42 features
    ## It has 2 fields

    ## Warning: 1: Polygon object 12 area -0.94185

    ## Warning: 1: Polygon object 17 area -2.30055

    ## Warning: 1: Polygon object 26 area -4.57812

    ## Warning: 1: Polygon object 29 area -2.99902

    ## Warning: 1: Polygon object 35 area -0.512022

    ## Warning: 1: Polygon object 36 area -2.36377

    ## Warning: 1: Polygon object 37 area -5.42523

    ## Warning: 1: Polygon object 39 area -0.598902

    ## Warning: 1: Polygon object 4 area -0.0125568

    ## Warning: 1: Polygon object 6 area -0.0876581

``` r
dev.off() ## Finish PDF
```

    ## quartz_off_screen 
    ##                 2

SP
--

Plot Pressure and resilience data layers
----------------------------------------

``` r
goal_select ="PressureResilience"

## Save PDF of Plots

pdf(paste(pdf_dir,"/output_",goal_select,".pdf", sep=""))

## plot pressures
plotPressuresResilience(type="pressures")
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

``` r
##plot resilience
plotPressuresResilience(type="resilience")
```

    ## Warning: Removed 39 rows containing missing values (geom_point).

``` r
dev.off()
```

    ## quartz_off_screen 
    ##                 2
