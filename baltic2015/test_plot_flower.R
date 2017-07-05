## Testing mhi's plot_flower_local.R

## visualize scores ----

## source from ohibc until added to ohicore, see https://github.com/OHI-Science/ohibc/blob/master/regionHoweSound/ohibc_howesound_2016.Rmd
source('https://raw.githubusercontent.com/OHI-Science/ohibc/master/src/R/common.R')
source('https://raw.githubusercontent.com/OHI-Science/mhi/master/region2017/plot_flower_local.R')

## regions info

rgns_complete <- read.csv('spatial/regions_lookup_complete.csv')
rgn_names <- read.csv('spatial/regions_lookup_complete.csv') %>%
  dplyr::rename(rgn_id = region_id)

## BHI regions
rgns <- rgns_complete %>%
  filter(type %in% c('bhi', 'GLOBAL'))
rgns_to_plot <- rgns$region_id

regions <- rgns %>%
  select(region_id, region_name = rgn_name)

## set figure name
regions <- regions %>%
 mutate(flower_png = sprintf('reports/figures/BHI_regions/test/flower_%s.png',
                       str_replace_all(region_name, ' ', '_')))


## save flower plot for each region
for (i in regions$region_id) { # i = 0

  ## fig_name to save
  fig_name <- regions$flower_png[regions$region_id == i]

  ## scores info
  score_df <- scores %>%
    filter(dimension == 'score') %>%
    filter(region_id == i)

  ## Casey's modified flower plot
  plot_obj <- plot_flower(score_df,
                          filename    = fig_name,
                          goals_csv   = 'conf/goals.csv',
                          incl_legend = TRUE)

}

