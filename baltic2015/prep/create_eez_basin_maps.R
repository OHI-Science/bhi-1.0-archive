## create_eez_basin_maps.r

## use maptools::unionSpatialPolygons to 'dissolve' the boundaries
## it won't preserve the data frame because there's not the same number of rows

## setup ----
library(tidyverse)
library(rgdal)
library(maptools)

dir_spatial <- path.expand('~/github/bhi/baltic2015/spatial')
rgns        <- read.csv(file.path(dir_spatial, 'regions_lookup_complete_wide.csv'))


## read in BHI spatial file
bhi  <-  rgdal::readOGR(
  dsn = dir_spatial,
  layer = 'rgn_offshore_gcs')

## join bhi@data with rgns information
bhi@data <- bhi@data %>%
  left_join(rgns %>%
              dplyr::rename(rgn_id  = region_id,
                            rgn_name = region_name), by = c('rgn_id', 'rgn_name'))

## EEZ: unite spatial polygons
ID <- bhi@data$eez_id - 300
bhi_eez <- unionSpatialPolygons(bhi, ID)

## now want to save it...
writeOGR(obj    = bhi_eez,
         dsn    = dir_spatial,
         layer  = 'BHI_as_EEZ',
         driver = 'ESRI Shapefile', overwrite=TRUE)
# Error in writeOGR(obj = bhi_eez, dsn = dir_spatial, layer = "BHI_as_EEZ",  :
#                     obj must be a SpatialPointsDataFrame, SpatialLinesDataFrame or
#                   SpatialPolygonsDataFrame



## SUBBASIN: unite spatial polygons
ID <- bhi@data$eez_id - 500
bhi_subbasin <- unionSpatialPolygons(bhi, ID)

