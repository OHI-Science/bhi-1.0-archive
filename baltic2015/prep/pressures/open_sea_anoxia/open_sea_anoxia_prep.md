open\_sea\_anoxia\_prep
================

-   [1. Background on open sea anoxia data](#background-on-open-sea-anoxia-data)
    -   [1.1 Why anoxia?](#why-anoxia)
-   [2. Anoxia data](#anoxia-data)
    -   [2.1 Data source](#data-source)
-   [3. Open sea anoxia spatial data scale](#open-sea-anoxia-spatial-data-scale)
-   [4. Open sea anoxia data extraction](#open-sea-anoxia-data-extraction)
    -   [4.1 Balic Proper anoxia data extraction](#balic-proper-anoxia-data-extraction)
    -   [4.2 Gulf of Finland anoxia data extraction](#gulf-of-finland-anoxia-data-extraction)
    -   [4.3 Combine anoxia data in all years](#combine-anoxia-data-in-all-years)
-   [Rescale Anoxia pressure data](#rescale-anoxia-pressure-data)
    -   [5.1 Current value](#current-value)
    -   [5.2 Max value](#max-value)
    -   [5.3 Min value](#min-value)
    -   [5.4 Combining Mean, Max, and Min values](#combining-mean-max-and-min-values)
    -   [5.5 Plot Mean, Max, and Min](#plot-mean-max-and-min)
    -   [5.6 Rescale Anoxia data and save data layer](#rescale-anoxia-data-and-save-data-layer)

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

4. Open sea anoxia data extraction
----------------------------------

Note, we may need to treat the Baltic Proper and the Gulf of Finland separately. In the Baltic Proper there is a strong halocline at 70m and it is the anoxic area below the halocline that is of interest (therefore we focus on areas with depths &gt;= 70). In the Gulf of Finland, there a less strong halocline and thermal stratification is important so we may have to think differently about which areas to focus on.

### 4.1 Balic Proper anoxia data extraction

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
plot(halocline_70, main = "area with depth of 70m or greater")
```

![](open_sea_anoxia_prep_files/figure-markdown_github/Baltic%20Proper%20anoxia%20data-1.png)

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

### 4.2 Gulf of Finland anoxia data extraction

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

### 4.3 Combine anoxia data in all years

``` r
setwd(file.path(dir_anox, 'O2_bottom_files'))

## Baltif Proper anoxia data in all years

BP_file_list = list.files(path = file.path(dir_anox, 'O2_bottom_files'),
                          pattern ="CodRVmap_.+[BP].csv")

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

Rescale Anoxia pressure data
----------------------------

### 5.1 Current value

-   Baltic Proper BHI regions = of the area &gt;= 70m deep the area with O2 &lt;0 mg⋅L−1
     - Use the mean area for the most recent 3 years (2012-2014)
-   Gulf of Finland BHI regions = of the total surface area in each BHI region, the area with O2 &lt;0 mg⋅L−1
     - Use the mean area for the most recent 3 years (2012-2014)

``` r
BP_current_anoxic_area = BP_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year %in% 2012:2014) %>%
  summarize(mean_area = mean(area_km2)) %>%
  ungroup()

GoF_current_anoxic_area = GoF_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year %in% 2012:2014) %>%
  summarize(mean_area = mean(area_km2)) %>%
  ungroup()
```

### 5.2 Max value

-   Baltic Proper BHI regions = of area &gt;= 70m depth, the maximum extent of area O2 &lt;0 mg⋅L−1 in last 10 years
-   Gulf of Finland BHI regions = of the surface area, the maximum extent of area O2 &lt;0 mg⋅L−1 in last 10 years

``` r
BP_max_anoxic_area = BP_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year %in% 2005:2014) %>%
  summarize(max_area = max(area_km2)) %>%
  ungroup()

GoF_max_anoxic_area = GoF_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year %in% 2005:2014) %>%
  summarize(max_area = max(area_km2)) %>%
  ungroup()
```

### 5.3 Min value

-   Baltic Proper BHI regions = of area &gt;= 70m deep the area with O2 &lt;0 mg⋅L−1 in 1906
-   Gulf of Finland BHI regions = total surface area, the area with O2 &lt;0 mg⋅L−1 in 1906

``` r
BP_min_anoxic_area = BP_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year == 1906) %>%
  summarize(min_area = min(area_km2)) %>%
  ungroup()

GoF_min_anoxic_area = GoF_anoxia_all_yr %>%
  group_by(BHI_ID) %>%
  filter(year == 1906) %>%
  summarize(min_area = min(area_km2)) %>%
  ungroup()
```

### 5.4 Combining Mean, Max, and Min values

``` r
# Baltic Proper

BP_anoxic_area = full_join(BP_current_anoxic_area, BP_max_anoxic_area, 
                           by = 'BHI_ID') %>%
  full_join(BP_min_anoxic_area, 
            by = 'BHI_ID')
  
# DT::datatable(BP_anoxic_area)

# Gulf of Finland

GoF_anoxic_area = full_join(GoF_current_anoxic_area, GoF_max_anoxic_area, 
                           by = 'BHI_ID') %>%
  full_join(GoF_min_anoxic_area, 
            by = 'BHI_ID')

# DT::datatable(GoF_anoxic_area)
```

### 5.5 Plot Mean, Max, and Min

``` r
## Baltic Proper 

bp_plot_data = BP_anoxic_area %>%
  gather(area_type, area, 2:4) 

bp_plot <- ggplot(bp_plot_data, aes(x = BHI_ID, y = area, fill = area_type)) +
 geom_bar(position="dodge", stat = "identity") +
 theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
 labs(title = 'Baltic Proper Anoxia data - Max, Min, and Mean',
      x = 'BHI region', 
      y = 'Area (km2)')

print(bp_plot)
```

![](open_sea_anoxia_prep_files/figure-markdown_github/plot%20mean%20max%20and%20min-1.png)

``` r
## Gulf of Finland

gof_plot_data = GoF_anoxic_area %>%
  gather(area_type, area, 2:4) 

gof_plot <- ggplot(gof_plot_data, aes(x = BHI_ID, y = area, fill = area_type)) +
 geom_bar(position="dodge", stat = "identity") +
 theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
 labs(title = 'Gulf of Finland Anoxia data - Max, Min, and Mean',
      x = 'BHI region', 
      y = 'Area (km2)')

print(gof_plot)
```

![](open_sea_anoxia_prep_files/figure-markdown_github/plot%20mean%20max%20and%20min-2.png)

### 5.6 Rescale Anoxia data and save data layer

Mean value was rescaled using max and min values, and was kept between 0 and 1.

``` r
anoxia_all_rgns = full_join(BP_anoxic_area, GoF_anoxic_area, 
                            by = c("BHI_ID", "mean_area", "max_area", "min_area")) %>%
  mutate(pressure_score = round((mean_area - min_area) / (max_area - min_area), 1), 
         pressure_score = str_replace_all(pressure_score, "NaN", "0")) %>%
  dplyr::select(rgn_id = BHI_ID, 
                pressure_score )

write_csv(anoxia_all_rgns, file.path(dir_layers, "hab_anoxia_bhi2015.csv"))
```
