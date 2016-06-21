##########################################
## PLOT BHI region map
#########################################

## 21 June 2016

## use updated shapefiles



## libraries
library(rgdal)
library(ggplot2)
library(colorRamps)
library(dplyr)
source('~/github/bhi/baltic2015/prep/common.r')



## Shapefile


BHIshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/BHI_shapefile", "BHI_shapefile")
BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp2))
BHIshp2@data$colors = rainbow(n=42)

poly.coord =coordinates(BHIshp2)%>% data.frame()%>%
            dplyr::rename(lon=X1, lat=X2)%>%
            mutate(BHI_ID = BHIshp2@data$BHI_ID)



##plot2
png(file.path(dir_prep,"BHI_regions_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp2)
text(poly.coord$lon, poly.coord$lat, labels=poly.coord$BHI_ID, col="red", cex=.8)
dev.off()



