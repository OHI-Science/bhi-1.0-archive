open\_sea\_anoxia\_prep
================

-   [1. Background on open sea anoxia data](#background-on-open-sea-anoxia-data)
    -   [1.1 Why anoxia?](#why-anoxia)
-   [2. Anoxia data](#anoxia-data)
    -   [2.1 Data source](#data-source)
-   [3. Open sea anoxia spatial data scale](#open-sea-anoxia-spatial-data-scale)
-   [4. Open sea anoxia data rescaling](#open-sea-anoxia-data-rescaling)
    -   [4.1 Balic Proper rescaling](#balic-proper-rescaling)
    -   [4.2 Gulf of Finland rescaling:](#gulf-of-finland-rescaling)
    -   [4.1 Current value](#current-value)
    -   [4.2 Max value](#max-value)
    -   [4.3 Min value](#min-value)
    -   [4.5 Combining Mean, Max, and Min values](#combining-mean-max-and-min-values)
-   [5. Open Sea Anoxia layer prep](#open-sea-anoxia-layer-prep)

1. Background on open sea anoxia data
-------------------------------------

### 1.1 Why anoxia?

2. Anoxia data
--------------

### 2.1 Data source

#### 2.1.1 Anoxia data layer

These data are from [Carstensen et al. 2014](http://www.pnas.org/content/111/15/5628.abstract). Jacob Carstensen provided dbf files containing O2 (mg⋅L−1) for a series of years for the Baltic Proper and the Gulf of Finland.

Other areas are not included in this study but at the present time have no anoxia problems - therefore they will recieve a pressure value of 0.

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

## libraries
library(dplyr)
library(rgdal)  # install.packages('rgdal')
```

    ## rgdal: version: 1.1-10, (SVN revision 622)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.1.0, released 2016/04/25
    ##  Path to GDAL shared files: /usr/share/gdal/2.1
    ##  Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
    ##  Path to PROJ.4 shared files: (autodetected)
    ##  Linking to sp version: 1.2-3

``` r
library(raster) # install.packages('raster')
library(rgeos)  # install.packages('rgeos')
```

    ## rgeos version: 0.3-19, (SVN revision 524)
    ##  GEOS runtime version: 3.5.0-CAPI-1.9.0 r4084 
    ##  Linking to sp version: 1.2-3 
    ##  Polygon checking: TRUE

#### 2.1.2 Bathymetry

Downloaded from [HELCOM](http://maps.helcom.fi/website/mapservice/index.html) 28 April 2016 by Thorsten Blenckner

``` r
## read in bathymetry raster data
bathymetry = raster::raster(file.path(dir_M, 'git-annex/Baltic/anoxia/Baltic_Sea_Bathymetry_Database_v091.tif'))
# anox
# plot(bathymetry)
```

3. Open sea anoxia spatial data scale
-------------------------------------

We will work on the BHI region scale. O2 rasters and Batlic bathymetry will be overlayed on BHI regions. Different approaches will be used for BHI regions in the Baltic Proper and in the Gulf of Finland.

In "baltic\_rgns\_to\_bhi\_rgns\_lookup\_holas\_basins.csv" in "~2015\_sea\_anoxia" the BHI regions associated with the Baltic Proper and Gulf of Finland are listed.

``` r
  # install.packages('foreign')
  # library(foreign)

anox_file_list = list.files(path= file.path(dir_shp, 'anoxia'),
                            pattern="CodRVmap_")

  bal_proj = CRS("+init=epsg:32634 +proj=utm +zone=34 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
  bal_res = 1000
  dir_temp = make_path('baltic2015/prep/pressures/open_sea_anoxia/O2_bottom_files')

for (anox_file in anox_file_list) {
   
  # anox_file = 'CodRVmap_1906.dbf'
  anox = foreign::read.dbf(file.path(dir_shp, 'anoxia', anox_file))  %>%
       dplyr::select(x_utm, y_utm, O2_bottom) # head(anox) 

  t <- raster::rasterFromXYZ( anox, res = bal_res, crs = bal_proj) 
  # plot(t)
  
  rast_file = file.path(dir_temp, paste0(file_path_sans_ext(anox_file), ".tif"))
  writeRaster(t, rast_file,  overwrite=TRUE)
  
}
```

    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'
    ## Field name: '_TYPE_' changed to: 'X_TYPE_'

4. Open sea anoxia data rescaling
---------------------------------

Note, we may need to treat the Baltic Proper and the Gulf of Finland separately. In the Baltic Proper there is a strong halocline at 70m and it is the anoxic area below the halocline that is of interest (therefore we focus on areas with depths &gt;= 70). In the Gulf of Finland, there a less strong halocline and thermal stratification is important so we may have to think differently about which areas to focus on.

### 4.1 Balic Proper rescaling

``` r
# isolate Baltic Proper and Gulf of Finland

## inspect BHI regions ----
bhi <- rgdal::readOGR(dsn = path.expand(file.path(dir_shp, 'BHI_MCG_shapefile')),
                      layer = 'BHI_MCG_11052016') 
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

``` r
## subset Baltic Proper (BP) and Gulf of Finland (GoF) regions, and rasterize them to the same coor system and resolution as O2_bottom files. 

O2_raster = raster::raster(file.path(dir_anox, 'O2_bottom_files', 'CodRVmap_2014.tif'))

GoF = bhi %>%
   subset(Subbasin == "Gulf of Finland") %>%
  spTransform(bal_proj) %>%
  rasterize(O2_raster, field = 'BHI_ID') #plot(GoF)

BP = bhi %>% 
  subset(!Subbasin == "Gulf of Finland") %>%
  spTransform(bal_proj) %>%
  rasterize(O2_raster, field = 'BHI_ID') #plot(BP)

# create bathymetry mask: remove cells with depth higher than -70 m

halocline_70 = bathymetry 
halocline_70[halocline_70 > -70] = NA

halocline_70 = projectRaster(halocline_70, O2_raster) # transform to the same projection as O2 data
plot(halocline_70)
```

![](open_sea_anoxia_prep_files/figure-markdown_github/anoxia%20rescaling-1.png)

``` r
# Loop for each O2_bottom tif file, mask with halocline_70

O2_file_list = list.files(path = file.path(dir_anox, 'O2_bottom_files'),
                          pattern ="CodRVmap_[0-9]+\\.tif")

for (i in O2_file_list){

## read in file 
## test: i = 'CodRVmap_2014.tif'
O2_bottom = raster::raster(file.path(dir_anox, 'O2_bottom_files', i))

## select area with O2<0 
O2_below_0 = O2_bottom
O2_below_0[O2_below_0 >= 0] = NA
# plot(O2_below_0)
# plot(halocline_70, add=T)

#### for 1906 and 1955, file coord system are different from bal_proj. To change them to the same coor system:  
if (i == 'CodRVmap_1906.tif' | i =='CodRVmap_1955.tif' ) {
  
  O2_below_0 = O2_below_0 %>% projectRaster(halocline_70)
  
}

## mask with depth >70m and BP 
O2_below_70 = mask(O2_below_0, halocline_70) %>%
  mask(BP)
# plot(O2_below_70)

## Calcualte the total area within each BP BHI region
# since we know cell resolution of O2_below_70 is 1000 x 1000 m, we can just count number of cells per region and sum

# use zonal to get statistics per 'zone' - in this case we have rasterized our BHI polygon to 1000x1000m cells, with BHI_ID as cell values. This acts as a zone layer
# that can be used to extract different information (mean, max, min, count, sum) for rasters of the same res and crs.
area_rgn <- zonal(O2_below_70, BP, fun='count') %>%
  data.frame(.) %>%
  dplyr::select(BHI_ID = zone, 
         area_km2 = count) %>%
  mutate(year = substr(i, 10, 13)) # add year

write_csv(data.frame(area_rgn), file.path(dir_temp, paste0(file_path_sans_ext(i), '_BP.csv')))

}
```

### 4.2 Gulf of Finland rescaling:

``` r
O2_file_list = list.files(path = file.path(dir_anox, 'O2_bottom_files'),
                          pattern ="CodRVmap_[0-9]+\\.tif")

for (i in O2_file_list){

## read in O2 file 
## test: i = 'CodRVmap_1906.tif'
O2_bottom = raster::raster(file.path(dir_anox, 'O2_bottom_files', i))

## select area with O2<0 
O2_below_0 = O2_bottom
O2_below_0[O2_below_0 >= 0] = NA
# plot(O2_below_0)

#### for 1906 and 1955, file coord system are different from the rest of the O2 files. To change them to the same coor system:  
if (i == 'CodRVmap_1906.tif' | i =='CodRVmap_1955.tif' ) {
  
  O2_below_0 = O2_below_0 %>% projectRaster(O2_raster)
  #plot(O2_below_0)
}

## mask with GoF
O2_below_0_GoF = mask(O2_below_0, GoF) 
# plot(O2_below_0_GoF)

## Calcualte the total area within each BP BHI region
# since we know cell resolution of O2_below_70 is 1000 x 1000 m, we can just count number of cells per region and sum. 
# use zonal to get statistics per 'zone' - in this case we have rasterized our BHI polygon to 1000x1000m cells, with BHI_ID as cell values. This acts as a zone layer
# that can be used to extract different information (mean, max, min, count, sum) for rasters of the same res and crs.

area_rgn <- zonal(O2_below_0_GoF, GoF, fun='count') %>%
  data.frame(.) %>%
  dplyr::select(BHI_ID = zone, 
         area_km2 = count) %>%
  mutate(year = substr(i, 10, 13)) # add year

write_csv(data.frame(area_rgn), file.path(dir_temp, paste0(file_path_sans_ext(i), '_GoF.csv')))

}
```

Combine anoxia data in all years for Gulf of Finland and Baltic Proper

``` r
## Baltif Proper anoxia data in all years

BP_file_list = list.files(path = file.path(dir_anox, 'O2_bottom_files'),
                          pattern ="CodRVmap_.+[BP].csv")

setwd(file.path(dir_anox, 'O2_bottom_files'))

dat = read_csv(BP_file_list [1])

for (i in 2:length(BP_file_list )) {
 d = read_csv(BP_file_list[i]) 
 dat = rbind(dat, d) 

}

BP_anoxia_all_yr = dat

## Gulf of Finland anoxia data in all years

GoF_file_list = list.files(path = file.path(dir_anox, 'O2_bottom_files'),
                          pattern ="CodRVmap_.+[GoF].csv")

dat = read_csv(GoF_file_list[1])

for (i in 2:length(GoF_file_list)) {
 d = read_csv(GoF_file_list[i]) 
 dat = rbind(dat, d) 

}

GoF_anoxia_all_yr = dat

## reset working directory
setwd(file.path('~/github/bhi'))
```

### 4.1 Current value

    - Baltic Proper BHI regions =  of the area >= 70m deep the area with O2 <0 mg⋅L−1  
        - Use the mean area for the most recent 3 years (2012-2014)  
    - Gulf of Finland BHI regions = of the total surface area in each BHI region, the area with O2 <0 mg⋅L−1  
        - Use the mean area for the most recent 3 years (2012-2014)  
        

``` r
BP_current_anoxic_area = BP_anoxia_all_yr %>%
  filter(year == 2012:2014) %>%
  group_by(BHI_ID) %>%
  summarize(mean_area = mean(area_km2)) %>%
  ungroup()

GoF_current_anoxic_area = GoF_anoxia_all_yr %>%
    filter(year == 2012:2014) %>%
  group_by(BHI_ID) %>%
  summarize(mean_area = mean(area_km2)) %>%
  ungroup()
```

### 4.2 Max value

    - Baltic Proper BHI regions =  of area >= 70m depth, the maximum extent of area O2 <0 mg⋅L−1 in last 10 years  
    - Gulf of Finland BHI regions = of the surface area, the maximum extent of area O2 <0 mg⋅L−1 in last 10 years  

    ## Warning in c(1906L, 1906L, 1906L, 1906L, 1906L, 1906L, 1906L, 1906L,
    ## 1906L, : longer object length is not a multiple of shorter object length

    ## Warning in c(1906L, 1906L, 1906L, 1931L, 1931L, 1931L, 1955L, 1955L,
    ## 1955L, : longer object length is not a multiple of shorter object length

### 4.3 Min value

     - Baltic Proper BHI regions =  of area >= 70m deep the area with O2 <0 mg⋅L−1  in 1906  
     - Gulf of Finland BHI regions = total surface area, the area with O2 <0 mg⋅L−1  in 1906

### 4.5 Combining Mean, Max, and Min values

![](open_sea_anoxia_prep_files/figure-markdown_github/Combine%20value-1.png)![](open_sea_anoxia_prep_files/figure-markdown_github/Combine%20value-2.png)

5. Open Sea Anoxia layer prep
-----------------------------

UTM 34 North.
