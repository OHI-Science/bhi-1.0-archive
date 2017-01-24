climate\_change\_prep
================

Climate Change Pressure Layers
==============================

Raw data cleaning
-----------------

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
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
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Loading required package: DBI

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

dir_cc    = file.path(dir_prep, 'pressures/climate_change')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_cc, 'climate_change_prep.rmd') 
```

1. Background
-------------

The direct effects of climate change in the abiotic environment will be changes to water temperature and salinity. In the BHI framework, we will include sea surface temperature (SST), surface salinity (SS), and bottom water salinity (BWS) as climate change pressures. Depth of bottom water varies by basin

2. Data
-------

### 2.1 Data source

Data are from the [BALTSEM model](http://www.balticnest.org/balticnest/thenestsystem/baltsem.4.3186f824143d05551ad20ea.html), run by BÃ¤rbel MÃ¼ller Karulis from the Baltic Sea Centre at Stockholm University.

### 2.2 Data cleaning and extraction

Data from hindcast and future scenarios by basin need to be organized into separate SST and salinity files. These data will then be prepared in the subfolder 'temperature\_climatechange' and 'salinity\_climatechange'

Projection scenarios use BALTSEM results run with forcing from the [ECHAM5](http://www.mpimet.mpg.de/en/science/models/echam/) global climate model for the scenario A1b

3. Hindcast data organization
-----------------------------

### 3.1 Read in Hindcast data

``` r
## read in data...
hind_ar = read.csv(file.path(dir_cc, 'raw_data/Hydro_AR_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "AR") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_AR,
                        sal_surface = SALIN_O_5_AR, sal_deep = SALIN_50_AR)


hind_bb = read.csv(file.path(dir_cc, 'raw_data/Hydro_BB_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BB,
                        sal_surface = SALIN_O_5_BB, sal_deep = SALIN_110_BB)

hind_bn = read.csv(file.path(dir_cc, 'raw_data/Hydro_BN_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BN") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BN,
                        sal_surface = SALIN_O_5_BN, sal_deep = SALIN_97_BN)

hind_bs = read.csv(file.path(dir_cc, 'raw_data/Hydro_BS_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BS,
                        sal_surface = SALIN_O_5_BS, sal_deep = SALIN_220_BS)

hind_ck = read.csv(file.path(dir_cc, 'raw_data/Hydro_CK_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "CK") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_CK,
                        sal_surface = SALIN_O_5_CK, sal_deep = SALIN_125_CK)

hind_fb = read.csv(file.path(dir_cc, 'raw_data/Hydro_FB_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "FB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_FB,
                        sal_surface = SALIN_O_5_FB, sal_deep = SALIN_65_FB)

hind_gf = read.csv(file.path(dir_cc, 'raw_data/Hydro_GF_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GF") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GF,
                        sal_surface = SALIN_O_5_GF, sal_deep = SALIN_85_GF)

hind_gr = read.csv(file.path(dir_cc, 'raw_data/Hydro_GR_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GR") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GR,
                        sal_surface = SALIN_O_5_GR, sal_deep = SALIN_50_GR)

hind_gs = read.csv(file.path(dir_cc, 'raw_data/Hydro_GS_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GS,
                        sal_surface = SALIN_O_5_GS, sal_deep = SALIN_250_GS)

hind_os = read.csv(file.path(dir_cc, 'raw_data/Hydro_OS_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "OS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_OS,
                        sal_surface = SALIN_O_5_OS, sal_deep = SALIN_45_OS)

hind_sb = read.csv(file.path(dir_cc, 'raw_data/Hydro_SB_Hindcast.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "SB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_SB,
                        sal_surface = SALIN_O_5_SB, sal_deep = SALIN_55_SB)
```

### 3.2 Single object for hindcast data

``` r
hindcast = bind_rows(hind_ar, hind_bb,hind_bn,hind_bs,hind_ck,hind_fb,hind_gf,hind_gr,hind_gs,hind_os,hind_sb)
```

### 3.3 read in csv for linking baltsem names and holas basins

``` r
basin_lookup = read.csv(file.path(dir_cc,'baltsem_basins_lookup.csv'), sep=";")
```

### 3.4 join hindcast to basin\_lookup

``` r
dim(hindcast) # 495   5
```

    ## [1] 495   5

``` r
hindcast = hindcast %>%
           full_join(., basin_lookup, by = "basin_abb_baltsem") %>%
           filter(!is.na(basin_name_holas))
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factor and character
    ## vector, coercing into character vector

``` r
dim(hindcast) #767   8
```

    ## [1] 767   8

### 3.5 separate objects for sst, sal\_surf, sal\_deep

``` r
hind_sst = hindcast %>%
           select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                  year, sst_jul_aug)

hind_sal_surf = hindcast %>%
                select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                  year,sal_surface)


hind_sal_deep = hindcast %>%
                select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                year, sal_deep, salin_bottom_depth)
```

### 3.5 save hindcast objects

``` r
write.csv(hind_sst, file.path(dir_cc, 'temperature_climatechange/temp_data_database/hind_sst.csv'),row.names=FALSE)

write.csv(hind_sal_surf, file.path(dir_cc, 'salinity_climatechange/sal_data_database/hind_sal_surf.csv'),row.names=FALSE)

write.csv(hind_sal_deep, file.path(dir_cc, 'salinity_climatechange/sal_data_database/hind_sal_deep.csv'),row.names=FALSE)
```

4. Projection data organization
-------------------------------

### 4.1 Read in data from ECHAM5 projection

``` r
proj_ar = read.csv(file.path(dir_cc, 'raw_data/Hydro_AR_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "AR") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_AR,
                        sal_surface = SALIN_O_5_AR, sal_deep = SALIN_50_AR)

proj_bb = read.csv(file.path(dir_cc, 'raw_data/Hydro_BB_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BB,
                        sal_surface = SALIN_O_5_BB, sal_deep = SALIN_110_BB)

proj_bn = read.csv(file.path(dir_cc, 'raw_data/Hydro_BN_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BN") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BN,
                        sal_surface = SALIN_O_5_BN, sal_deep = SALIN_97_BN)

proj_bs = read.csv(file.path(dir_cc, 'raw_data/Hydro_BS_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "BS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_BS,
                        sal_surface = SALIN_O_5_BS, sal_deep = SALIN_220_BS)

proj_ck = read.csv(file.path(dir_cc, 'raw_data/Hydro_CK_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "CK") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_CK,
                        sal_surface = SALIN_O_5_CK, sal_deep = SALIN_125_CK)

proj_fb = read.csv(file.path(dir_cc, 'raw_data/Hydro_FB_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "FB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_FB,
                        sal_surface = SALIN_O_5_FB, sal_deep = SALIN_65_FB)

proj_gf = read.csv(file.path(dir_cc, 'raw_data/Hydro_GF_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GF") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GF,
                        sal_surface = SALIN_O_5_GF, sal_deep = SALIN_85_GF)

proj_gr = read.csv(file.path(dir_cc, 'raw_data/Hydro_GR_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GR") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GR,
                        sal_surface = SALIN_O_5_GR, sal_deep = SALIN_50_GR)

proj_gs = read.csv(file.path(dir_cc, 'raw_data/Hydro_GS_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "GS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_GS,
                        sal_surface = SALIN_O_5_GS, sal_deep = SALIN_250_GS)

proj_os = read.csv(file.path(dir_cc, 'raw_data/Hydro_OS_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "OS") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_OS,
                        sal_surface = SALIN_O_5_OS, sal_deep = SALIN_45_OS)

proj_sb = read.csv(file.path(dir_cc, 'raw_data/Hydro_SB_echam5_a1b_3_PLC55new_Demo.csv'), header=TRUE) %>%
          mutate(basin_abb_baltsem = "SB") %>%
          dplyr::rename(year=Year, sst_jul_aug =TEMP_O_5_JulAug_SB,
                        sal_surface = SALIN_O_5_SB, sal_deep = SALIN_55_SB)
```

### 4.2 Single object for projection data

``` r
projection = bind_rows(proj_ar, proj_bb,proj_bn,proj_bs,proj_ck,proj_fb,proj_gf,proj_gr,proj_gs,proj_os,proj_sb)
```

### 4.3 read in csv for linking baltsem names and holas basins

Have already done above

### 4.4 join projection to basin\_lookup

``` r
dim(projection) # 1551   5
```

    ## [1] 1551    5

``` r
projection = projection %>%
           full_join(., basin_lookup, by = "basin_abb_baltsem") %>%
           filter(!is.na(basin_name_holas))
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factor and character
    ## vector, coercing into character vector

``` r
dim(projection) #2399   8
```

    ## [1] 2399    8

### 4.5 separate objects for sst, sal\_surf, sal\_deep

``` r
proj_sst = projection %>%
           select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                  year, sst_jul_aug)

proj_sal_surf = projection %>%
                select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                  year,sal_surface)


proj_sal_deep = projection %>%
                select(basin_name_holas, basin_name_baltsem, basin_abb_baltsem,
                year, sal_deep, salin_bottom_depth)
```

### 4.5 save projection objects

``` r
write.csv(proj_sst, file.path(dir_cc, 'temperature_climatechange/temp_data_database/proj_sst.csv'),row.names=FALSE)

write.csv(proj_sal_surf, file.path(dir_cc, 'salinity_climatechange/sal_data_database/proj_sal_surf.csv'),row.names=FALSE)

write.csv(proj_sal_deep, file.path(dir_cc, 'salinity_climatechange/sal_data_database/proj_sal_deep.csv'),row.names=FALSE)
```
