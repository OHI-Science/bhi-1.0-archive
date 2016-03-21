## Test code for MAR sub-goal. Started with copying the code from functions.R
# packages needed, reshape2, dplyr

#libraries
library(dplyr)
library(tidyr)



#MAR sub-goal
#updated 23FEB2016 by Jennifer Griffiths
#comments from Julie 24Feb2016

#currently includes only 1 reference point option

#TO edit in other locations
#in goals.csv - remove status_years  # set here in the function instead

MAR = function(layers){
  #updated by Jennifer Griffiths 25Feb2016
  #updated by Julie 26Feb2016
  #updated by Jennifer Griffiths 29Feb2016 - make sure mar_status_score limited to status_years, change layer names

  #layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score, mar_coastalpopn2005_inland25km


  # select layers for MAR
  harvest_tonnes = SelectLayersData(layers, layers='mar_harvest_tonnes', narrow=T) %>%
    select(rgn_id = id_num,
           species_code = category,
           year,
           tonnes = val_num)

  harvest_species = SelectLayersData(layers, layers='mar_harvest_species', narrow=T) %>%
    select(species_code = category,
           species = val_chr)

  sustainability_score = SelectLayersData(layers, layers='mar_sustainability_score', narrow=T) %>%
    select(rgn_id = id_num,
           species = category,
           sust_coeff = val_num)

  popn_inland25km =SelectLayersData(layers, layers='mar_coastalpopn2005_inland25km', narrow=T) %>% #this is data only from 2005 for Baltic Region, Lena/Erik say ok to use one year data for all
    select(rgn_id = id_num,
           popsum = val_num)

  #read the data if working in the prep folder
  harvest_tonnes =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_tonnes_bhi2015.csv", header=TRUE)  #mariculture production data by species code
  harvest_species =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_species_bhi2015.csv", header=TRUE) #species code and species name
  sustainability_score = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_sustainability_score_bhi2015.csv",header=TRUE) #sustainability score by species code
  popn_inland25km =read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_coastalpopn2005_inland25km_bhi2015.csv",
                            header=TRUE)#2005 population for BHI inland regions. Apply to all years


  # SETTING CONSTANTS
  rm_year = 4              #number of years to use when calculating the running mean smoother
  regr_length =5          # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
  future_year = 5          # the year at which we want the likely future status
  min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
  status_years = 2005:2014 #this was originally set in goals.csv  #global set to 2007:2012 originally


  #####----------------------######
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
  temp2 = temp %>%    # temp2 is ry in the original version
    group_by(rgn_id, year) %>%
    summarise(sust_tonnes_sum = sum(sust_tonnes)) %>% #this sums the harvest(production) across all species in a given region if multiple spp are present
    left_join(., popn_inland25km, by=c('rgn_id')) %>%  #apply 2005 pop data to all years
    mutate(mar_pop = sust_tonnes_sum/popsum) #tonnes per capita

  #####----------------------######
  ###Baltic Wide Spatial Ref Pt
  # get reference quantile, searches for ref pt across all basins & all years defined in status_years
  ref_95pct = temp2%>% ungroup()%>%
    select(rgn_id,year,mar_pop)%>%
    filter(year<=max(status_years))%>%
    summarise(ref_95pct=quantile(mar_pop,probs=0.95, na.rm=TRUE))%>%
    as.numeric(.)
  #ref_95pct

  #find ID associated with the ref_95pct
  ref_id = temp2%>%ungroup()%>%
    filter(year<=max(status_years))%>%
    arrange(mar_pop) %>%
    filter(mar_pop >= ref_95pct)
  cat(sprintf('95th percentile rgn_id for MAR ref pt is: %s\n', ref_id$rgn_id[1]))


  #####----------------------######
  # Calculate the status for each year (year_value / ref_value) #only for status years specified
  mar_status_score = temp2%>%
    filter(year<=max(status_years))%>%
    mutate(.,status =  pmin(1, mar_pop/ref_95pct)) %>%
    select(rgn_id, year, status)

  #give mar_status_score all BHI regions, regions with no data receive NA for last year
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(mar_status_score$year)))

  mar_status_score = mar_status_score%>%ungroup()%>%
    full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%
    arrange(rgn_id,year)

  # select last year of data in timeseries for status #last year based on status years specified
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
    mutate(trend_score=round(trend_score,3))  #change round to 3 decimal places because trend values are very small

  #####----------------------######
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


} #end mar function

####Plot Status for all years
library(ggplot2)
#mar_status_score has status from 0-1
windows()
ggplot(mar_status_score)+geom_point(aes(factor(year),status*100),size=2.4) +
  facet_wrap(~rgn_id, scales="free_y")

####Plot Status year and trend value
windows()
ggplot(scores)+geom_point(aes(region_id,score, color=factor(region_id),size=3)) +
  facet_wrap(~dimension, scales="free")


