## Test code for MAR sub-goal. Started with copying the code from functions.R
# packages needed, reshape2, dplyr

#libraries
library(dplyr)
library(tidyr)



#MAR sub-goal
#updated 23FEB2016 by Jennifer Griffiths
#currently includes only 1 reference point option

#TO edit in other locations
#in goals.csv - remove status_years  # set here in the function instead


MAR = function(layers){  ##   #the function to call
    # layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score, mar_coastalpopn_inland25km

#call the layers in the function  #uncomment when in functions.csv
    # how did the original renaming work using c('id_num'='rgn_id', 'category'='species_code', 'year'='year', 'val_num'='tonnes') ??
      #I think renaming under call from SelectLayersData should be removed

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


#read in from local csv files for testing
harvest_tonnes =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_tonnes_bhi2015.csv",
                 header=TRUE)  #mariculture production data by species code
harvest_species =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_species_bhi2015.csv",
                 header=TRUE) #species code and species name
sustainability_score = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_sustainability_score_bhi2015.csv",
                       header=TRUE) #sustainability score by species code
popn_inland25mi = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_coastalpopn_inland25km_sc2014-raster.csv",
                   header=TRUE) #population per region


# SETTING CONSTANTS
rm_year = 4              #number of years to use when calculating the running mean smoother
regr_length =5          # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
future_year = 5          # the year at which we want the likely future status
min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
status_years = 2005:2014 #this was originally set in goals.csv  #global set to 2007:2012 originally



#harvest_tonnes has years without data but those years not present with NAs
#spread and gather data again which will result in all years present for all regions
harvest_tonnes=harvest_tonnes%>%spread(key=year,value=tonnes)%>%
  gather(year, tonnes, -rgn_id,-species_code)%>%
  mutate(year=as.numeric(year))%>%  #make sure year is not a character
  arrange(rgn_id,year)

# Merge harvest (production) data with sustainability score
#calculate 4 year running mean
#this code updated by Lena to use dplyr functions not reshape2
temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
  left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
  arrange(rgn_id, species) %>%
  group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
  mutate(rm = zoo::rollapply(data=tonnes, width=rm_year,FUN= mean, na.rm = TRUE, partial=TRUE),    #rm = running mean  #rm_year defined with constants (4 is value from original code)     # better done with zoo::rollmean? how to treat Na with that?
         sust_tonnes = rm * sust_coeff)

# now calculate total sust_tonnes per year  #only matters if multiple species
#relate to pop density

    #popn_inland25mi is missing data for areas 42 and 40 (Finland)
    #very temporary fix - assign 42 = SE 41 and 40 = SE 39
        pop.temp = popn_inland25mi%>%filter(rgn_id%in% c(39,41))%>%
             mutate(rgn_id = replace(rgn_id, which(rgn_id==39), 40))%>%  #assign region 40 to 39's values
             mutate(rgn_id = replace(rgn_id, which(rgn_id==41), 42)) #assign region 42 to 41's values
        popn_inland25mi = popn_inland25mi%>%full_join(.,pop.temp, by=c("rgn_id","year","popsum")) %>% #add regions 40 and 42 with temp values taken from Sweden
             filter(!is.na(popsum))#remove the NA years 16,39,42

temp2 = temp %>%    # temp2 is ry in the original version
  group_by(rgn_id, year) %>%
  summarise(sust_tonnes_sum = sum(sust_tonnes)) %>% #this sums the harvest(production) across all species in a given region if multiple spp are present
  left_join(., popn_inland25mi, by=c('rgn_id', 'year')) %>%
  mutate(mar_pop = sust_tonnes_sum/popsum) #tonnes per capita


# get reference quantile, searches for ref pt across all years defined in status_years
ref_95pct = temp2%>% ungroup()%>%
    select(rgn_id,year,mar_pop)%>%
    filter(year<=max(status_years))%>%
    summarise(ref_95pct=quantile(mar_pop,probs=0.95, na.rm=TRUE))%>%
    as.numeric(.)

ref_95pct #result agrees with old code


#find ID associated with the ref_95pct
ref_id = temp2%>%ungroup()%>%
  filter(year<=max(status_years))%>%
  arrange(mar_pop) %>%
  filter(mar_pop >= ref_95pct)
cat(sprintf('95th percentile rgn_id for MAR ref pt is: %s\n', ref_id$rgn_id[1]))  #result agrees with old code


# normalize data #
mar_status_score = temp2%>%
  mutate(.,status =  pmin(1, mar_pop/ref_95pct)) %>%
  select(rgn_id, year, status)   #status values agree with old code

# select last year of data in timeseries for status
mar_status = mar_status_score %>%
  group_by(rgn_id) %>%
  summarise_each(funs(last), rgn_id, status) %>%
  mutate(status = round(status*100,2))  #took away pmin piece that Lena has used in this code in CW func


#calulate trend - update MAR code based on Lena template code
    #original code has option to exclude last year status year from the trend calculation
    #if exclude last year, trend calc was for 5 status years, but if did not was for 6
    # if I sent regr_length = 6, then I can reproduce the old code results for trend_years = '5_yrs
    #but to me this is very inconsistent with the other approach, so will set regr_length = 5
mar_trend= mar_status_score%>%group_by(rgn_id)%>%
  do(tail(. , n = regr_length)) %>% #select the years for trend calculate (regr_length # years from the end of the time series)
                                    #regr_length replaces the need to read in the trend_yrs from the csv file
  do({if(sum(!is.na(.$status)) >= min_regr_length)      #calculate trend only if X years of data (min_regr_length) in the last Y years of time serie (regr_length)
    data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year))) #future_year set in contants, this is the value 5 in the old code
    else data.frame(trend_score = NA)}) %>%
    ungroup()%>%
    mutate(trend_score=round(trend_score,2))

# return MAR scores
scores = mar_status %>%
  select(region_id = rgn_id,
         score     = status) %>%
  mutate(dimension='status') %>%
  rbind(
    mar_trend %>%
      select(region_id = rgn_id,
             score     = trend_score) %>%
      mutate(dimension = 'trend')) %>%
  mutate(goal='MAR')
return(scores)

##scores right now does not include any regions for which we did not have data #need a final step that adds those regions with NA?

}  #uncomment when add to functions.r #end of MAR function
