## plot shape files
library(rgdal)
library(ggplot2)
library(colorRamps)
library(dplyr)
library(sp)
source('~/github/bhi/baltic2015/prep/common.r')

##---------------------------------------##
## READ IN SHAPEFILES##
##---------------------------------------##
## BHI shape file
BHIshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/BHI_shapefile_projected", "BHI_shapefile_projected")
BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp2))

plot(BHIshp2)

## BHI shapefile with buffer
BHIshp_buffer = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/BHI_shapefile_25km_buffer_projected", "BHI_shapefile_25km_buffer_projected")
BHIshp_buffer2 = spTransform(BHIshp_buffer, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp_buffer2))

plot(BHIshp_buffer2)


##  NUTS3 shapefile - 2006
NUTS3= readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/NUTS2006_Level_2_3", "NUTS2006_Level_3_reprojected")
NUTS3_2 = spTransform(NUTS3, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(NUTS3_2))

plot(NUTS3_2)


##  NUTS2 shapefile - 2006
NUTS2= readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/NUTS2006_Level_2_3", "NUTS2006_Level_2_reprojected")
NUTS2_2 = spTransform(NUTS2, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(NUTS2_2))

plot(NUTS2_2)

##---------------------------------------##
## PLOT BHI REGIONS and NUTS3 REGIONS ##
##---------------------------------------##

## get centroids of polygons for plotting labels
centroids_bhi <- getSpPPolygonsLabptSlots(BHIshp2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(BHI_ID = BHIshp2@data$BHI_ID)

centroids_nuts3 =getSpPPolygonsLabptSlots(NUTS3_2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(NUTS3_ID = NUTS3_2@data$NUTS_ID)

## plot NUTS3 and shapefile with buffer
png(file.path(dir_prep,"BHI_regions_NUTS3_withbuffer_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp_buffer2, col="red")
plot(BHIshp2, add=TRUE)
plot(NUTS3_2, add=TRUE)
text(centroids_nuts3$lon,centroids_nuts3$lat, labels=centroids_nuts3$NUTS3_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="red",cex=.5)
dev.off()

## plot NUTS3 and shapefile without buffer
png(file.path(dir_prep,"BHI_regions_NUTS3_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp2,col="red")
plot(NUTS3_2, add=TRUE)
text(centroids_nuts3$lon,centroids_nuts3$lat, labels=centroids_nuts3$NUTS3_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="black",cex=.5)
dev.off()


##---------------------------------------##
## PLOT BHI REGIONS and NUTS2 REGIONS ##
##---------------------------------------##

## get centroids of polygons for plotting labels
centroids_nuts2 =getSpPPolygonsLabptSlots(NUTS2_2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(NUTS2_ID = NUTS2_2@data$NUTS_ID)

## plot NUTS2 and shapefile with buffer
png(file.path(dir_prep,"BHI_regions_NUTS2_withbuffer_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp_buffer2, col="red")
plot(BHIshp2, add=TRUE)
plot(NUTS2_2, add=TRUE)
text(centroids_nuts2$lon,centroids_nuts2$lat, labels=centroids_nuts2$NUTS2_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="red",cex=.5)
dev.off()

## plot NUTS2 and shapefile without buffer
png(file.path(dir_prep,"BHI_regions_NUTS2_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp2,col="red")
plot(NUTS2_2, add=TRUE)
text(centroids_nuts2$lon,centroids_nuts2$lat, labels=centroids_nuts2$NUTS2_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="black",cex=.5)
dev.off()
