## Test code for MAR sub-goal. Started with copying the code from functions.R
# packages needed, reshape2, dplyr

# layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score, mar_coastalpopn_inland25km, mar_trend_years
# how did the original renaming work using c('id_num'='rgn_id', 'category'='species_code', 'year'='year', 'val_num'='tonnes') ??
harvest_tonnes = rename(
  SelectLayersData(layers, layers='mar_harvest_tonnes', narrow=T),
  rgn_id = id_num, species_code = category, year = year, tonnes = val_num)
harvest_species = rename(
  SelectLayersData(layers, layers='mar_harvest_species', narrow=T),
  species_code = category, species = val_chr)
sustainability_score = rename(
  SelectLayersData(layers, layers='mar_sustainability_score', narrow=T),
  rgn_id = id_num, species = category, sust_coeff = val_num)
popn_inland25mi = rename(
  SelectLayersData(layers, layers='mar_coastalpopn_inland25km', narrow=T),
  rgn_id = id_num, year = year, pop_sum = val_num)
trend_years = rename(
  SelectLayersData(layers, layers='mar_trend_years', narrow=T),
  rgn_id = id_num, trend_yrs = val_chr)

# merging harvest data with sustainability score
# Original code needed reshape2 for dcast. I updated the to using join from dplyr instead of merge, it seems to be faster and gives identical result
temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
  left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
  arrange(rgn_id, species) %>%
  group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
  # summarise(n()); unique(temp$n)
  mutate(rm = zoo::rollapply(tonnes, 4, mean, na.rm = TRUE, partial=T),         # replace 4 with pre-defined constant! better done with zoo::rollmean? how to treat Na with that?
         sust_tonnes = rm * sust_coeff)

# now calculate total sust_tonnes per year and relate to pop density
temp2 = temp %>%            # temp2 is ry in the original version
  group_by(rgn_id, year) %>%
  summarise(sust_tonnes_sum = sum(sust_tonnes)) %>%
  left_join(., popn_inland25mi, by=c('rgn_id', 'year')) %>%
  mutate(mar_pop = sust_tonnes_sum/pop_sum)

# code above (from line 24) replaces this old code:
# original version
# rky = harvest_tonnes %>%
#   merge(harvest_species     , all.x=TRUE, by = 'species_code') %>%      #left_join(harvest_tonnes, harvest_species, by = 'species_code')
#   merge(sustainability_score, all.x=TRUE, by = c('rgn_id', 'species')) %>%
#   dcast(rgn_id + species + species_code + sust_coeff ~ year, value.var='tonnes', mean, na.rm=T) %>%
#   arrange(rgn_id, species)
#
# # x = csv_compare(rky, '1-rky')
#
# # smooth each species-country time-series using a running mean with 4-year window, excluding NAs from the 4-year mean calculation
# # TODO: simplify below with dplyr::group_by()
# yrs_smooth <- names(rky)[!names(rky) %in% c('rgn_id','species','species_code','sust_coeff')]
# rky_smooth = zoo::rollapply(t(rky[,yrs_smooth]), 4, mean, na.rm = TRUE, partial=T)
# rownames(rky_smooth) = as.character(yrs_smooth)
# rky_smooth = t(rky_smooth)
# rky = as.data.frame(cbind(rky[, c('rgn_id','species','species_code','sust_coeff')], rky_smooth)); head(rky)
# #  x = csv_compare(rky, '2-rky-smooth')  # DEBUG
#
# # melt
# m = melt(rky,
#          id=c('rgn_id', 'species', 'species_code', 'sust_coeff'),
#          variable.name='year', value.name='sm_tonnes'); head(m)
# #   m <- m %>%
# #     arrange(rgn_id, species)
# #   x = csv_compare(m, '3-m-melt')  # DEBUG
# # "Component “year”: 'current' is not a factor"
#
# # for each species-country-year, smooth mariculture harvest times the sustainability coefficient
# m = within(m, {
#   sust_tonnes = sust_coeff * sm_tonnes
#   year        = as.numeric(as.character(m$year))
# })
# #   m <- m %>%
# #     arrange(rgn_id, species)
# #   x = csv_compare(m, '4-m-within')  # DEBUG
#
# # merge the MAR and coastal human population data
# m = merge(m, popn_inland25mi, by=c('rgn_id','year'), all.x=T)
# #   m <- m %>%
# #     arrange(rgn_id, species, species_code)
# #   m_a = csv_compare(m, '5-m-merge')  # DEBUG
#
# # must first aggregate all weighted timeseries per region, before dividing by total population
# #   ry = ddply(m, .(rgn_id, year, popsum), summarize,
# #              sust_tonnes_sum = sum(sust_tonnes),
# #              mar_pop         = sum(sust_tonnes) / popsum[1]) # <-- PROBLEM using popsum[1] with ddply!!!
#
#
# # aggregate all weighted timeseries per region, and divide by coastal human population
# ry = m %>%
#   group_by(rgn_id, year) %>%
#   summarize(sust_tonnes_sum = sum(sust_tonnes)) %>%
#   merge(popn_inland25mi, by = c('rgn_id','year'), all.x=T) %>%
#   mutate(mar_pop = sust_tonnes_sum/pop_sum) %>%
#   select(rgn_id, year, pop_sum, sust_tonnes_sum, mar_pop)
# #  ry_b = csv_compare(ry, '6-ry-ddply')  # RIGHT
# #   ry_a = ry
# #   eq = all.equal(ry_a, ry_b)
# #   if (class(eq) == 'character') browser()

# get reference quantile based on argument years
# status_years is stored in goal.csv and was set to 2007:2012 originally
status_years = 2007:2012
ref_95pct = quantile(subset(ry, year <= max(status_years), mar_pop, drop=T), 0.95, na.rm=T)
#  x = csv_compare(ref_95pct, '7-ref95pct-quantile')  # DEBUG

# identify reference rgn_id
ry_ref = ry %>%
  filter(year <=max(status_years)) %>%
  arrange(mar_pop) %>%
  filter(mar_pop >= ref_95pct)
cat(sprintf('95th percentile rgn_id for MAR ref pt is: %s\n', ry_ref$rgn_id[1])) # rgn_id 25 = Thailand

ry = within(ry, {
  status = ifelse(mar_pop / ref_95pct > 1,
                  1,
                  mar_pop / ref_95pct)})
status <- subset(ry, year == max(status_years), c('rgn_id', 'status'))
status$status <- round(status$status*100, 2)
#   x = csv_compare(ry, '8-ry-within')  # DEBUG

# get list where trend is only to be calculated up to second-to-last-year
# species where the last year of the time-series was 2010, and the same value was copied over to 2011
# i.e. it was gapfilled using the previous year

# get MAR trend
ry = merge(ry, trend_years, all.x=T)
yr_max = max(status_years)
trend = ddply(ry, .(rgn_id), function(x){  # x = subset(ry, rgn_id==5)
  yrs = ifelse(x$trend_yrs=='4_yr',
               (yr_max-5):(yr_max-1), # 4_yr
               (yr_max-5):(yr_max))   # 5_yr
  y = subset(x, year %in% yrs & !is.na(status))
  # added condition for aus repo since rgns 7 & 9 have no data
  if (nrow(y) > 1){
    trend = round(max(min(lm(status ~ year, data=y)$coefficients[['year']] * 5, 1), -1), 2)
  } else {
    trend = NA
  }
  return(data.frame(trend))
})

# return scores
scores = status %>%
  select(region_id = rgn_id,
         score     = status) %>%
  mutate(dimension='status') %>%
  rbind(
    trend %>%
      select(region_id = rgn_id,
             score     = trend) %>%
      mutate(dimension = 'trend')) %>%
  mutate(goal='MAR')
