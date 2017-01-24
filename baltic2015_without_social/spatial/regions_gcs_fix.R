library(rgdal)
library(leaflet)
library(geojsonio)
library(rmapshaper) # install_github("ateucher/rmapshaper")

if (basename(getwd()) != 'spatial') setwd('baltic2015/spatial')

gj_old = 'regions_gcs_old.geojson'
gj     = 'regions_gcs.geojson'
gj_s1  = 'regions_gcs_simple1x.geojson'
gj_s2  = 'regions_gcs_simple2x.geojson'

# test with leaflet plot
lplot = function(rgns){
  leaflet() %>%
    addProviderTiles('Stamen.TonerLite') %>%
    addPolygons(data = rgns,
                stroke = TRUE, opacity=0.5, weight=2, fillOpacity = 0.5, smoothFactor = 0.5,
                color = 'blue')
}


# fix by reading and writing old geojson
file.rename(gj, gj_old)
s0 = geojsonio::geojson_read(gj_old, what="sp")
lplot(s0)
writeOGR(s0, '.', 'regions_gcs', driver='ESRI Shapefile', overwrite_layer=T)
s1 = readOGR('.', 'regions_gcs')
lplot(s1)
geojson_write(s1, file=gj)
lplot(s0)

# simplify 1x
s2 = ms_simplify(
  s1, keep=0.05, method='vis', no_repair=F,
  keep_shapes=T, snap=T) #plot(s1, col='gray')
lplot(s2)
geojson_write(s2, file=gj_s1)

# simplify 2x
s3 = ms_simplify(
  s2, keep=0.05, method='vis', no_repair=F,
  keep_shapes=T, snap=T) #plot(s1, col='gray')
lplot(s3)
geojson_write(s3, file=gj_s2)

