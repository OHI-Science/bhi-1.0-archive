
source('~/github/bhi/baltic2015/pre_scores.R')

## source until added to ohicore
source('PrepSpatial.R')
source('PlotMap.r')
source('PlotMapMulti.r')
source('PlotFlowerMulti.R')



## Make Maps ----

## BHI regions
scores <- readr::read_csv('scores.csv') %>%
  filter(region_id < 300) %>%
  filter(goal %in% c('AO', 'BD', 'FP')) %>%
  filter(dimension == 'status')

# PlotMap(scores)
#
# PlotMapMulti(scores,
#              spatial_poly = NULL,
#              path_figures = 'TESTING_plotmap')


### Load package and data; truncate to a small subset for easy manipulation
source('plot_tmap.r')
source('plot_tmap_multi.r')

plot_tmap(scores %>% filter(goal == 'BD'))
plot_tmap_multi(scores,
             figs_dir = 'TESTING_plotmap')
