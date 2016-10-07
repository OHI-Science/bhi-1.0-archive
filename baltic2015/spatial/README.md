


## Simplification

Simplify per [ohirepos/README.md#GeoJSON Simplification · OHI-Science/ohirepos](https://github.com/OHI-Science/ohirepos/blob/master/inst/app/README.md#geojson-simplification).

According to `baltic2015/config.R`:

```r
geojson = 'spatial/regions_gcs.geojson'
```


```r
library(dplyr)
library(sp)
library(rgdal)
library(geojsonio)
library(rmapshaper) # install_github("ateucher/rmapshaper")

g0 = './baltic2015/spatial/regions_gcs.geojson'
g1 = './baltic2015/spatial/regions_rmapshaper-ms_simplify-1x_gcs.geojson'
g2 = './baltic2015/spatial/regions_rmapshaper-ms_simplify-2x_gcs.geojson'

# read original
s0 = readOGR(g0, 'OGRGeoJSON', verbose=F) #plot(s0, col='gray')

# simplify 1x
s1 = ms_simplify(
  s0, keep=0.05, method='vis', 
  keep_shapes=T, snap=T, explode=T, 
  force_FC=T) #plot(s1, col='gray')
geojson_write(s1, file=g1)

# simplify 2x
s2 = ms_simplify(s1) #plot(s2, col='gray')
geojson_write(s2, file=g2)
```
