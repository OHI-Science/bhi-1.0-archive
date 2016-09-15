## create_rgns_complete.r
## by @jules32 Sept 14 2016
## called from `functions.r - FinalizeScores()`; will save 'spatial/regions_lookup_complete.csv'


## Identify regions to aggregate as eezs and basins ----

## lookup table for EEZ ids (named vector)
eez_lookup = c("SWE" = 1,
               "DNK" = 2,
               "DEU" = 3,
               "POL" = 4,
               "RUS" = 5,
               "LTU" = 6,
               "LVA" = 7,
               "EST" = 8,
               "FIN" = 9)

## join region labels with labels for EEZs and HELCOM Subbasins
rgns <- left_join(

  ## begin with region labels, as per usual...
  SelectLayersData(layers, layers=conf$config$layer_region_labels, narrow=T) %>%
    dplyr::select(region_id   = id_num,
                  region_name = val_chr),

  ## ...joined to the lookup table with basin and eez information
  read.csv('prep/bhi_basin_country_lookup.csv', sep = ';') %>% ## don't use readr::read_csv2 because decimals will be dropped
    dplyr::rename(region_id     = BHI_ID,
                  eez_name      = rgn_nam,
                  subbasin_name = Subbasin,
                  area_km2_rgn  = Area_km2) %>%

    ## for HELCOM sub-basin areas:: create numeric id and calculate area
    mutate(subbasin_id = as.integer(stringr::str_replace_all(HELCOM_ID, "SEA-0", 5))) %>%

    ## for EEZ areas:: create numeric id and calculate area
    mutate(eez_id = as.integer(stringr::str_c("30", eez_lookup[match(rgn_key, names(eez_lookup))]))),

  ## ...joined by region_id and select
  by = 'region_id') %>%
  select(region_id, region_name, area_km2_rgn, eez_id, eez_name, subbasin_id, subbasin_name)


## Create csv lookup of all regions, with headers to match layers/rgn_labels.csv ----
rgns_complete <- bind_rows(
  data_frame(region_id = 0, label = 'Baltic', type = 'GLOBAL'),          ## combine 0...
  rgns %>%                                           ## ...with BHI ids...
    mutate(label = as.character(region_name),
           type = 'bhi') %>%
    select(region_id = region_id, label, type),
  rgns %>%                                           ## ...with EEZ ids...
    distinct(eez_id, eez_name) %>%
    mutate(type = 'eez') %>%
    select(region_id = eez_id, label = eez_name, type),
  rgns %>%                                           ## ...with SUBBASIN ids
    distinct(subbasin_id, subbasin_name) %>%
    mutate(type = 'subbasin') %>%
    select(region_id = subbasin_id, label = subbasin_name, type))

## save csv lookup
write.csv(rgns_complete, 'spatial/regions_lookup_complete.csv', row.names=FALSE)
