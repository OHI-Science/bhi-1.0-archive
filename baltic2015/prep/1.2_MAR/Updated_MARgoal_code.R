## Test code for MAR sub-goal. Started with copying the code from functions.R
# packages needed, reshape2, dplyr

#libraries
library(dplyr)
library(tidyr)

# layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score, mar_coastalpopn_inland25km, mar_trend_years
# how did the original renaming work using c('id_num'='rgn_id', 'category'='species_code', 'year'='year', 'val_num'='tonnes') ??
# harvest_tonnes = rename(
#   SelectLayersData(layers, layers='mar_harvest_tonnes', narrow=T),
#   rgn_id = id_num, species_code = category, year = year, tonnes = val_num)
# harvest_species = rename(
#   SelectLayersData(layers, layers='mar_harvest_species', narrow=T),
#   species_code = category, species = val_chr)
# sustainability_score = rename(
#   SelectLayersData(layers, layers='mar_sustainability_score', narrow=T),
#   rgn_id = id_num, species = category, sust_coeff = val_num)
# popn_inland25mi = rename(
#   SelectLayersData(layers, layers='mar_coastalpopn_inland25km', narrow=T),
#   rgn_id = id_num, year = year, pop_sum = val_num)
# trend_years = rename(
#   SelectLayersData(layers, layers='mar_trend_years', narrow=T),
#   rgn_id = id_num, trend_yrs = val_chr)


#read in from local csv files

harvest_tonnes =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_tonnes_bhi2015.csv",
                 header=TRUE)


harvest_species =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_species_bhi2015.csv",
                 header=TRUE)


sustainability_score = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_sustainability_score_bhi2015.csv",
                       header=TRUE)


popn_inland25mi = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_coastalpopn_inland25km_sc2014-raster.csv",
                   header=TRUE)


trend_years =  read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_trend_years_gl2014.csv",
               header=TRUE)

##this is with columns that are not renamed (names are as csv), the SelectDataLayers renames, I think the renaming is not clear


# merging harvest data with sustainability score
# Original code needed reshape2 for dcast. I updated the to using join from dplyr instead of merge, it seems to be faster and gives identical result
temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
  left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
  arrange(rgn_id, species) %>%
  group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
  # summarise(n()); unique(temp$n)
  mutate(rm = zoo::rollapply(data=tonnes, width=4,FUN= mean, na.rm = TRUE, partial=TRUE),    #rm = running mean     # replace 4 with pre-defined constant! better done with zoo::rollmean? how to treat Na with that?
         sust_tonnes = rm * sust_coeff)

# now calculate total sust_tonnes per year and relate to pop density, #only matters if multiple species
temp2 = temp %>%            # temp2 is ry in the original version
  group_by(rgn_id, year) %>%
  summarise(sust_tonnes_sum = sum(sust_tonnes)) %>%
  left_join(., popn_inland25mi, by=c('rgn_id', 'year')) %>%
  mutate(mar_pop = sust_tonnes_sum/popsum)
#temp2 has nrow=203, ry has nrow=220 ---these are supposed to be the same, is this while ref_95pct is different?

#for debugging
#write.csv(temp2,"C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/NewCodeMarPop.csv")

# get reference quantile based on argument years
# status_years is stored in goal.csv and was set to 2007:2012 originally
#for this code set here until decision made and either fix code or update goals.csv
status_years = 2007:2012

ref_95pct = temp2%>% ungroup()%>%
    select(rgn_id,year,mar_pop)%>%
    filter(year<=max(status_years))%>%
    summarise(ref_95pct=quantile(mar_pop,probs=0.95, na.rm=TRUE))%>%
    as.numeric(ref_95pct)
ref_95pct  #0.02366602  #value obtained by old code, is not the same 0.02293772

    # quantile(subset(temp2, year <= max(status_years), mar_pop, drop=T), 0.95, na.rm=T)
    #  x = csv_compare(ref_95pct, '7-ref95pct-quantile')  # DEBUG

#find ID associated with the ref_95pct
ref_id = temp2%>%filter(year<=max(status_years))%>%
  arrange(mar_pop) %>%
  filter(mar_pop >= ref_95pct)

#old
ry %>%
  filter(year <=max(status_years)) %>%
  arrange(mar_pop) %>%
  filter(mar_pop >= 0.02293772)

# identify reference rgn_id
# ry_ref = ry %>%
#   filter(year <=max(status_years)) %>%
#   arrange(mar_pop) %>%
#   filter(mar_pop >= ref_95pct)
# cat(sprintf('95th percentile rgn_id for MAR ref pt is: %s\n', ry_ref$rgn_id[1])) # rgn_id 25 = Thailand

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
