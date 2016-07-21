## Note that some of the commands used below are from older R packages that we don't recommend using anymore (dcast, etc). Instead, use
## dplyr and tydr packages that have more streamlined functions to manipulate data. To learn those funtions:
## http://ohi-science.org/manual/#appendix-5-r-tutorials-for-ohi

## See functions.R of CHN (OHI-China) for how those functions are used in OHI+ assessments


FIS = function(layers, status_year){
 ## FIS code revised by Melanie Fraser
 ## added to functions.r by Jennifer Griffiths 7 June 2016


 ## Call Layers
  bbmsy = SelectLayersData(layers, layers='fis_bbmsy', narrow=T) %>%
            select(rgn_id = id_num,
                   stock = category,
                   year,
                   score= val_num) %>%
            mutate(metric ="bbmsy") %>%
            dplyr::rename(region_id = rgn_id)

  ffmsy = SelectLayersData(layers, layers='fis_ffmsy', narrow=T) %>%
          select(rgn_id = id_num,
                  stock = category,
                  year,
                  score= val_num) %>%
          mutate(metric= "ffmsy")%>%
          dplyr::rename(region_id = rgn_id)

  landings = SelectLayersData(layers, layers='fis_landings', narrow=T) %>%
             select(rgn_id =id_num,
                    stock = category,
                    year,
                    landings= val_num)%>%
            dplyr::rename(region_id = rgn_id)
#
#   #**********************#
#   ## TO TEST
  # library(dplyr)
  # library(tidyr)
  #
  # ## Directories
  # dir_baltic = '~/github/bhi/baltic2015'
  # dir_layers = file.path(dir_baltic, 'layers')
  # dir_prep   = file.path(dir_baltic, 'prep')
  # dir_fis = file.path(dir_prep, 'FIS')
  #
  # bbmsy = read.csv(file.path(dir_layers ,'fis_bbmsy_bhi2015.csv'))%>%
  #   mutate(metric ="bbmsy") %>%
  #   dplyr::rename(region_id = rgn_id)
  #
  # ffmsy = read.csv(file.path(dir_layers ,'fis_ffmsy_bhi2015.csv'))%>%
  #   mutate(metric ="ffmsy") %>%
  #   dplyr::rename(region_id = rgn_id)
  #
  # landings = read.csv(file.path(dir_layers ,'fis_landings_bhi2015.csv'))%>%
  #   dplyr::rename(region_id = rgn_id)



  ## combine bbmsy and ffmsy to single object

  metric.scores = rbind(bbmsy, ffmsy) %>%
                  select(region_id, stock, year, metric, score) %>%
                  mutate(metric = as.factor(metric))%>%
                   spread(metric, score)


  ###########################################################################
  ## STEP 1: converting B/Bmsy and F/Fmsy to F-scores
  ## see plot describing the relationship between these variables and scores
  ## this may need to be adjusted:
  ###########################################################################
  F_scores <- metric.scores %>%
    mutate(score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy+1.5), 0, NA),
           score = ifelse(bbmsy < 0.8 & ffmsy < (bbmsy - 0.2), ffmsy/(bbmsy-0.2), score),
           score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy + 0.2) & ffmsy < (bbmsy + 1.5), (bbmsy + 1.5 - ffmsy)/1.5, score),
           score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy - 0.2) & ffmsy < (bbmsy + 0.2), 1, score)) %>%
    mutate(score = ifelse(bbmsy >= 0.8 & ffmsy < 0.8, ffmsy/0.8, score),
           score = ifelse(bbmsy >= 0.8 & ffmsy >= 0.8 & ffmsy < 1.2, 1, score),
           score = ifelse(bbmsy >= 0.8 & ffmsy >= 1.2, (2.5 - ffmsy)/1.3, score)) %>%
    mutate(score = ifelse(score <= 0, 0.1, score)) %>%
    mutate(score_type = "F_score")
  ### NOTE: The reason the last score is 0.1 rather than zero is because
  ### scores can't be zero if using a geometric mean because otherwise, 1 zero
  ### results in a zero score.

  ###########################################################################
  ## STEP 2: converting B/Bmsy to B-scores
  ###########################################################################
  B_scores <- metric.scores %>%
    mutate(score = ifelse(bbmsy < 0.8 , bbmsy/0.8, NA),
           score = ifelse(bbmsy >= 0.8 & bbmsy < 1.5, 1, score),
           score = ifelse(bbmsy >= 1.5, (3.35 - bbmsy)/1.8, score)) %>%
    mutate(score = ifelse(score <= 0.1, 0.1, score)) %>%
    mutate(score = ifelse(score > 1, 1, score))%>%
    mutate(score_type = "B_score")

  ###########################################################################
  ## STEP 3: Averaging the F and B-scores to get the stock status score
  ###########################################################################
  status.scores <- rbind(B_scores, F_scores) %>%
    group_by(region_id, stock, year) %>%
    summarize(score = mean(score, na.rm=TRUE)) %>%
    data.frame()

  #############################################
  ## STEP 4: calculating the weights.
  #############################################

  ##### Subset the data to include only the most recent 10 years
  landings <- landings %>%
    filter(year %in% (max(landings$year)-9):max(landings$year))

  ## we use the average catch for each stock/region across all years
  ## to obtain weights
  weights <- landings %>%
    group_by(region_id, stock) %>%
    mutate(avgCatch = mean(landings)) %>%
    ungroup() %>%
    data.frame()

  ## each region/stock will have the same average catch across years:
  #filter(weights, region_id==3)

  ## determine the total proportion of catch each stock accounts for:
  weights <- weights %>%
    group_by(region_id, year) %>%
    mutate(totCatch = sum(avgCatch)) %>%
    ungroup() %>%
    mutate(propCatch = avgCatch/totCatch)

  #### The total proportion of landings for each region/year will sum to one:
  #filter(weights, region_id ==3, year==2014)

  ############################################################
  #####  STEP 5: Join scores and weights to calculate status
  ############################################################


  status <- weights %>%
    left_join(status.scores, by=c('region_id', 'year', 'stock'))%>%
    filter(!is.na(score)) %>%                    # remove missing data
    select(region_id, year, stock, propCatch, score)        # cleaning data


  ### Geometric mean weighted by proportion of catch in each region
  status <- status %>%
    group_by(region_id, year) %>%
    summarize(status = prod(score^propCatch)) %>%
    ungroup() %>%
    data.frame()

  ### To get trend, get slope of regression model based on most recent 5 years
  ### of data

  trend_years <- (max(status$year)-4):max(status$year)

  trend <- status %>%
    group_by(region_id) %>%
    filter(year %in% trend_years) %>%
    do(mdl = lm(status ~ year, data=.)) %>%
    summarize(region_id = region_id,
              trend = coef(mdl)['year'] * 5) %>%  ## trend multiplied by 5 to get prediction 5 years out
    ungroup() %>%
    mutate(trend = round(trend, 2))

   ### final formatting of status data:
  status <- status %>%
    filter(year == max(year)) %>%
    mutate(status = round(status * 100, 1)) %>%
    select(region_id, status)


  ############################################################
  #####  STEP 6: Assemble dimensions
  ############################################################

  scores = status %>%
    select(region_id,
           score = status)%>%
    mutate(dimension='status') %>%
    rbind(
      trend %>%
        select(region_id,
               score = trend) %>%
        mutate(dimension = 'trend')) %>%
    mutate(goal='FIS')
  return(scores)

} ## End FIS function


MAR = function(layers){
  ##updated by Jennifer Griffiths 25Feb2016
  ##updated by Julie 26Feb2016
  ##updated by Jennifer Griffiths 29Feb2016 - make sure mar_status_score limited to status_years, change layer names
  ##updated by Jennifer Griffiths 29March2016 - added code for temporal reference point but this is commented out until final decision made
  ##updated by Jennifer Griffiths 05April2016 - made reference point temporal (removed spatial), made data unit tons of production, not per capita
  ##updated by Jennifer Griffiths 16June2016 - change code so areas with no data are NA for status (not zero)

  ##layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score


  ## select layers for MAR
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


  ## SETTING CONSTANTS
  rm_year = 4              #number of years to use when calculating the running mean smoother
  regr_length =5          # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
  future_year = 5          # the year at which we want the likely future status
  min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
  status_years = 2010:2014 #this was originally set in goals.csv
  lag_win = 5             # if use a 5 year moving window reference point (instead of spatial, use this lag)

  #####----------------------######
  ##harvest_tonnes has years without data but those years not present with NAs
  ##spread and gather data again which will result in all years present for all regions
  harvest_tonnes=harvest_tonnes%>%spread(key=year,value=tonnes)%>%
    gather(year, tonnes, -rgn_id,-species_code)%>%
    mutate(year=as.numeric(year))%>%  #make sure year is not a character
    arrange(rgn_id,year)

  ## Merge harvest (production) data with sustainability score
  ##calculate 4 year running mean
  ##this code updated by Lena to use dplyr functions not reshape2
  temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
    left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
    arrange(rgn_id, species) %>%
    group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
    mutate(rm = zoo::rollapply(data=tonnes, width=rm_year,FUN= mean, na.rm = TRUE, partial=TRUE),    #rm = running mean  #rm_year defined with constants (4 is value from original code)     # better done with zoo::rollmean? how to treat Na with that?
           sust_tonnes = rm * sust_coeff)

  ## now calculate total sust_tonnes per year  #only matters if multiple species
  ## remove code that made the data unit per capita

  temp2 = temp %>%    # temp2 is ry in the original version
    group_by(rgn_id, year) %>%
    summarise(sust_tonnes_sum = sum(sust_tonnes)) #this sums the harvest(production) across all species in a given region if multiple spp are present
    ## left_join(., popn_inland25km, by=c('rgn_id')) %>%  #apply 2005 pop data to all years
    ##mutate(mar_prod = sust_tonnes_sum) #tonnes per capita


  ###----------------------------###
  ##Calculate status using temporal reference point
  ## 5 year moving window (temporal ref by region)
  ## Xmar = Mar_current / Mar_ref
  ## if use this, need to decide if the production should be scaled per capita

  ##for complete region ID list
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(temp2$year)))

  ## Calculate status
  mar_status_score = temp2 %>% group_by(rgn_id)%>%
                mutate(year_ref= lag(year, lag_win, order_by=year),
                       ref_val = lag(sust_tonnes_sum, lag_win, order_by=year))%>% #create ref year and value which is value 5 years preceeding within a BHI region
                arrange(year)%>%
                ungroup()%>%
                filter(year %in% status_years) %>% #select status years
                mutate(status = pmin(1,sust_tonnes_sum/ref_val))%>% #calculate status per year
                select(rgn_id, year, status)%>%
                full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%  #join with complete rgn_id list
                arrange(rgn_id,year)

                ## use code chunk below if want regions with no data to have a score of 0, now have score of NA
                #%>%
                ##mutate(status, status = replace(status, is.na(status), 0))  #give NA value a 0

  ##Calculate score
  mar_status = mar_status_score%>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id,status) %>% #select last year of status for the score
    mutate(score = round(status*100,2))%>% #status is between 0-100
    ungroup()%>%
    select(rgn_id,score)

  ###----------------------------###
  ## Calulate trend
      ##regr_length = 5; there are 5 data points used to calculate the trend
  mar_trend= mar_status_score%>%group_by(rgn_id)%>%
    do(tail(. , n = regr_length)) %>% #select the years for trend calculate (regr_length # years from the end of the time series)
    #regr_length replaces the need to read in the trend_yrs from the csv file
    do({if(sum(!is.na(.$status)) >= min_regr_length)      #calculate trend only if X years of data (min_regr_length) in the last Y years of time serie (regr_length)
      data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year))) #future_year set in contants, this is the value 5 in the old code
      else data.frame(trend_score = NA)}) %>%
    ungroup()%>%
    mutate(trend_score=round(trend_score,2))

  #####----------------------######
  # return MAR scores
  scores = mar_status %>%
    select(region_id = rgn_id,
           score     = score) %>%
    mutate(dimension='status') %>%
    rbind(
      mar_trend %>%
        select(region_id = rgn_id,
               score     = trend_score) %>%
        mutate(dimension = 'trend')) %>%
    mutate(goal='MAR')
  return(scores)


} #end MAR function

FP = function(layers, scores){

  # weights of FIS, MAR by rgn_id
  w <- SelectLayersData(layers, layers='fp_wildcaught_weight', narrow = TRUE) %>%
    select(region_id = id_num,
           w_FIS = val_num); head(w)

  # scores of FIS, MAR with appropriate weight
  s <- scores %>%
    filter(goal %in% c('FIS', 'MAR')) %>%
    filter(!(dimension %in% c('pressures', 'resilience'))) %>%
    left_join(w, by="region_id")  %>%
    mutate(w_MAR = 1 - w_FIS) %>%
    mutate(weight = ifelse(goal == "FIS", w_FIS, w_MAR))


  ## Some warning messages for potential mismatches in data:
  # NA score but there is a weight
  tmp <- filter(s, goal=='FIS' & is.na(score) & (!is.na(w_FIS) & w_FIS!=0) & dimension == "score")
  if(dim(tmp)[1]>0){
    warning(paste0("Check: these regions have a FIS weight but no score: ",
                   paste(as.character(tmp$region_id), collapse = ", ")))}

  tmp <- filter(s, goal=='MAR' & is.na(score) & (!is.na(w_MAR) & w_MAR!=0) & dimension == "score")
  if(dim(tmp)[1]>0){
    warning(paste0("Check: these regions have a MAR weight but no score: ",
                   paste(as.character(tmp$region_id), collapse = ", ")))}

  # score, but the weight is NA or 0
  tmp <- filter(s, goal=='FIS' & (!is.na(score) & score > 0) & (is.na(w_FIS) | w_FIS==0) & dimension == "score" & region_id !=0)
  if(dim(tmp)[1]>0){
    warning(paste0("Check: these regions have a FIS score but no weight: ",
                   paste(as.character(tmp$region_id), collapse = ", ")))}

  tmp <- filter(s, goal=='MAR' & (!is.na(score) & score > 0) & (is.na(w_MAR) | w_MAR==0) & dimension == "score" & region_id !=0)
  if(dim(tmp)[1]>0){
    warning(paste0("Check: these regions have a MAR score but no weight: ",
                   paste(as.character(tmp$region_id), collapse = ", ")))}

  ## summarize scores as FP based on MAR, FIS weight
  s <- s  %>%
    group_by(region_id, dimension) %>%
    summarize(score = weighted.mean(score, weight, na.rm=TRUE)) %>%
    mutate(goal = "FP") %>%
    ungroup() %>%
    select(region_id, goal, dimension, score) %>%
    data.frame()

  ## return all scores
  return(rbind(scores, s))
} ## End FP Function


AO = function(layers){
    ## AO Goal has thre components stock status, access, need
    ## Currently BHI only addresses the stock  status

    ## updated 9 May 2016 Jennifer Griffiths

    ##----------------------------##
    ## STOCK STATUS SUB-COMPONENT

    ## Status is calculated in the file ao_prep.rmd because calculated on the HOLAS basin scale
    ##  and applied to BHI regions

    ## The slope of the trend is also calculated in ao_prep.rmd on the HOLAS basin scale and
    ##  applied to BHI regions
          ## the slope is not yet modified by the future year of interest (5 years from now)


    ## read in layers

      ao_stock_status = SelectLayersData(layers, layers='ao_stock_status') %>%
        dplyr::select(rgn_id = id_num, dimension=category, score = val_num) %>%
        mutate(dimension = as.character(dimension))

      ao_stock_slope = SelectLayersData(layers, layers='ao_stock_slope') %>%
        dplyr::select(rgn_id = id_num, dimension=category, score = val_num)%>%
        mutate(dimension = as.character(dimension))


      ## status value if NA for status
        ## NA is because there has been no data, not because not applicable
        ## decision is to leave as NA (eg not replace with 0)


      ## trend calc
        future_year = 5  ## number of years in the future for trend

        ao_stock_trend = ao_stock_slope %>%
                          mutate(score = score* future_year)


      ## join status and trend
        ao_stock = bind_rows(ao_stock_status, ao_stock_trend)%>%
          dplyr::rename(region_id = rgn_id)


        ##----------------------------##
        ## OTHER sub-components

        ## if have access or need data layers, bring in here


        ##----------------------------##
        ## AO SCORE object


        scores = ao_stock %>%
          mutate(goal   = 'AO')

        return(scores)

} ## END AO function


CS = function(layers){

  ### TO DO......Add layers when finalized

  ## Select Layers

  ## Status

  ## Trend



  ## proxy scores

  scores = bind_rows(data.frame(region_id = seq(1,42,1),
                                dimension = as.character(rep("status",42)),
                                score = rep (100, 42)),
                     data.frame(region_id = seq(1,42,1),
                                dimension = as.character(rep("trend",42)),
                                score = rep (0, 42))
  ) %>%
    mutate(goal = 'CS')


  # return scores


  return(scores)
}## End CS function



TR = function(layers){
  ## updated 11 July 2016 by Jennifer Griffiths

  ##-------------------------------------------------------------------##
  ## Select layers
  tr_layer = SelectLayersData(layers, layers='tr_accommodation_stays') %>%
  dplyr::select(rgn_id = id_num, year, bhi_coastal_stays_per_cap = val_num)
  ##-------------------------------------------------------------------##

  ##-------------------------------------------------------------------##
  ## Set Parameters
  ## set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend
  ##-------------------------------------------------------------------##


  ##-------------------------------------------------------------------##
  ## CALCULATE STATUS ##

  ## calculate status time series
  tr_status_score = tr_layer %>%
    dplyr::rename(nights = bhi_coastal_stays_per_cap) %>%
    filter(!is.na(nights)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(nights, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = nights/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value)%>%
    mutate(status = pmin(1,rgn_value)) ## if regions have no data, are not included here, final year will be included below

  ## select last year of data in timeseries for status
  tr_status = tr_status_score %>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id, status) %>%  #this will be all same year because of code above selecting the max year
    full_join(bhi_rgn, .,by="rgn_id")%>% #all regions now listed, have NA for for status
    mutate(score = status*100,
           dimension = 'status') %>% ##scale to 0 to 100
    select(region_id = rgn_id,score, dimension)
  ##-------------------------------------------------------------------##


  ##-------------------------------------------------------------------##
  ## CALCULATE TREND

  ## calculate trend for 5 years (5 data points)
  ## years are filtered tr_status_score
  tr_trend = tr_status_score %>%
    filter(year >= max(year - trend_yr))%>%                #select five years of data for trend
    filter(!is.na(status)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
    group_by(rgn_id) %>%
    mutate(regr_length = n())%>%                            #get the number of status years available for greggion
    filter(regr_length == (trend_yr + 1))%>%                   #only do the regression for regions that have 5 data points
    do(mdl = lm(status ~ year, data = .)) %>%             # regression model to get the trend
    summarize(rgn_id = rgn_id,
              score = coef(mdl)['year'] * lag_win)%>%
    ungroup() %>%
    full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
    mutate(score = round(score, 2),
           dimension = "trend") %>%
    select(region_id = rgn_id, dimension, score) %>%
    data.frame()
  ##-------------------------------------------------------------------##

  ##-------------------------------------------------------------------##
  ## FINAL OBJECT

  ## create scores and rbind status and trend scores
  scores = tr_status %>%
    bind_rows(.,tr_trend) %>%
    mutate(goal='TR')

  return(scores)
  ##-------------------------------------------------------------------##
} ## end TR function


LIV = function(layers){

  ## Updated 11 July 2016 by Jennifer Griffiths

  ##-------------------------------------------------##
  ## Select Layers
  liv_regional_employ = SelectLayersData(layers, layers='liv_regional_employ') %>%
    dplyr::select(rgn_id = id_num, year,  employ_pop_bhi= val_num)


  liv_national_employ = SelectLayersData(layers, layers='liv_national_employ') %>%
    dplyr::select(rgn_id = id_num, year,  employ_pop= val_num)
  ##-------------------------------------------------##


  ##-------------------------------------------------##
  ###Set parameters
  ## set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend
  ##-------------------------------------------------##


  ##-------------------------------------------------##
  ### STATUS CALCULATION

  ### prepare region and country layers

  ## LIV region: prepare for calculations with a lag
  liv_region = liv_regional_employ %>%
    dplyr::rename(employ = employ_pop_bhi) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value) %>%
    arrange(rgn_id,year)


  ## LIV country
  liv_country =   liv_national_employ %>%
    dplyr::rename(employ = employ_pop) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(cntry_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,cntry_value) %>%
    arrange(rgn_id,year)

  ## Calculate status time series
  ## calculate status
  liv_status_calc = inner_join(liv_region,liv_country, by=c("rgn_id","year"))%>% #join region and country current/ref ratios ## inner_join because need to have both region and country values to calculate
    mutate(Xliv = rgn_value/cntry_value)%>% #calculate status
    mutate(status = pmin(1, Xliv)) # status calculated cannot exceed 1

  ## Extract most recent year status
  liv_status = liv_status_calc%>%
    group_by(rgn_id)%>%
    filter(year== max(year))%>%       #select status as most recent year
    ungroup()%>%
    full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data
    mutate(score=round(status*100),   #scale to 0 to 100
           dimension = 'status')%>%
    select(region_id = rgn_id,score, dimension) #%>%
  ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
  ##will this cause problems if there are regions that should be NA (because indicator is not applicable?)

  ##-------------------------------------------------##


  ##-------------------------------------------------##
  ##  CALCULATE TREND

  ## calculate trend for 5 years (5 data points)
  ## years are filtered in liv_region and liv_country, so not filtered for here
  liv_trend = liv_status_calc %>%
    filter(year >= max(year - trend_yr))%>%                #select five years of data for trend
    filter(!is.na(status)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
    group_by(rgn_id) %>%
    mutate(regr_length = n())%>%                            #get the number of status years available for greggion
    filter(regr_length == (trend_yr + 1))%>%                   #only do the regression for regions that have 5 data points
    do(mdl = lm(status ~ year, data = .)) %>%             # regression model to get the trend
    summarize(rgn_id = rgn_id,
              score = coef(mdl)['year'] * lag_win)%>%
    ungroup() %>%
    full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
    mutate(score = round(score, 2),
           dimension = "trend") %>%
    select(region_id = rgn_id, dimension, score) %>%
    data.frame()
  ##-------------------------------------------------##


  ##-------------------------------------------------##
  ## FINAL SCORES OBEJCT
  ## create scores and rbind to other goal scores
  scores = liv_status %>%
    bind_rows(.,liv_trend) %>%
    mutate(goal='LIV')

  return(scores)




  return(scores)
} ## End LIV function


ECO = function(layers){

  ## Status model: Xeco = (GDP_Region_c/GDP_Region_r)/(GDP_Country_c/GDP_Country_r)

  ## Updated 7 July 2016, Jennifer Griffiths. If there is no data for status or trend, is NA


  ## read in data
  ## in data prep, year range included is selected
    ##if different time periods exisit for region and country, NAs for status will be produced
  le_gdp_region   = SelectLayersData(layers, layers='le_gdp_region') %>%
    dplyr::select(rgn_id = id_num, year, rgn_gdp_per_cap = val_num)

  le_gdp_country  = SelectLayersData(layers, layers='le_gdp_country') %>%
    dplyr::select(rgn_id = id_num, year, nat_gdp_per_cap = val_num)


  ## temp readin TODO: SelectLayers()
  # library(dplyr)
  # le_gdp_region = read.csv('~/github/bhi/baltic2015/layers/le_gdp_region_bhi2015.csv'); head(le_gdp_region)
  # le_gdp_country = read.csv('~/github/bhi/baltic2015/layers/le_gdp_country_bhi2015.csv'); head(le_gdp_country)

  ## set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend

  ## ECO region: prepare for calculations with a lag
  eco_region = le_gdp_region %>%
    dplyr::rename(gdp = rgn_gdp_per_cap) %>%
    filter(!is.na(gdp)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(gdp, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = gdp/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value)

  ## ECO country
  eco_country = le_gdp_country %>%
    dplyr::rename(gdp = nat_gdp_per_cap) %>%
    filter(!is.na(gdp)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(gdp, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(cntry_value = gdp/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,cntry_value)

  ## calculate status
  eco_status_calc = full_join(eco_region,eco_country, by=c("rgn_id","year"))%>% #join region and country current/ref ratios
               mutate(Xeco = rgn_value/cntry_value)%>% #calculate status
               mutate(status = pmin(1, Xeco)) # status calculated cannot exceed 1

  eco_status = eco_status_calc%>%
    group_by(rgn_id)%>%
    filter(year== max(year))%>%       #select status as most recent year
    ungroup()%>%
    full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status
    mutate(score=round(status*100),   #scale to 0 to 100
           dimension = 'status')%>%
    select(region_id = rgn_id,score, dimension)

  ## this is where could change NA value of status to zero
  #%>%
  ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
  ##will this cause problems if there are regions that should be NA (because indicator is not applicable?)


  ## calculate trend for 5 years (5 data points)
      ## years are filtered in eco_region and eco_country, so not filtered for here
      eco_trend = eco_status_calc %>%
        filter(year >= max(year - trend_yr))%>%                #select five years of data for trend
        filter(!is.na(status)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
        group_by(rgn_id) %>%
        mutate(regr_length = n())%>%                            #get the number of status years available for greggion
        filter(regr_length == (trend_yr + 1))%>%                   #only do the regression for regions that have 5 data points
          do(mdl = lm(status ~ year, data = .)) %>%             # regression model to get the trend
            summarize(rgn_id = rgn_id,
                      score = coef(mdl)['year'] * lag_win)%>%
        ungroup() %>%
        full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
        mutate(score = round(score, 2),
               dimension = "trend") %>%
        select(region_id = rgn_id, dimension, score) %>%
        data.frame()


  ## create scores and rbind to other goal scores
  scores = eco_status %>%
    bind_rows(.,eco_trend) %>%
    mutate(goal='ECO')

   return(scores)

} ## End ECO function


LE = function(scores, layers){

  # calculate LE scores
  scores.LE = scores %>%
    filter(goal %in% c('LIV','ECO') & dimension %in% c('status','trend','score','future')) %>%
    dcast(region_id + dimension ~ goal, value.var='score') %>%
    mutate(score = rowMeans(cbind(ECO, LIV), na.rm=T)) %>%
    select(region_id, dimension, score) %>%
    mutate(goal  = 'LE')

  # rbind to all scores
  scores = scores %>%
    rbind(scores.LE)

  # return scores
  return(scores)
} ## End LE function


ICO = function(layers){
    ## UPDATED 22 June 2016 Jennifer Griffiths

  ## Select layers

  ##
  ico_status   = SelectLayersData(layers, layers='ico_status') %>%
    dplyr::select(rgn_id = id_num, score = val_num)


  ## ICO STATUS
    ## Status is calculated in ico_prep.rmd because calculated by basin and then applied to BHI regions

  ## add dimension to object
  ico_status = ico_status %>%
               dplyr::rename(region_id =rgn_id) %>%
               mutate(dimension = 'status',
                      score = score* 100)

  ## ICO TREND
   ## No data to calculate as trend, set as NA

  ico_trend = data.frame(region_id = seq(1,42,1),
                     score = rep(NA,42),
                     dimension = rep('trend',42))

  ## Return scores
  scores = bind_rows(ico_status,
                     ico_trend)%>%
            mutate(goal   = 'ICO')

  return(scores)


} ## end ICO function


LSP = function(layers){

  ## TO DO......Add layers when finalized

  ## Select Layers

    ## Status

    ## Trend



    ## proxy scores

        scores = bind_rows(data.frame(region_id = seq(1,42,1),
                          dimension = as.character(rep("status",42)),
                          score = rep (100, 42)),
                          data.frame(region_id = seq(1,42,1),
                                     dimension = as.character(rep("trend",42)),
                                     score = rep (0, 42))
                            ) %>%
                  mutate(goal = 'LSP')


  # return scores


    return(scores)
} ## End LSP function


SP = function(scores){

  s <- scores %>%
    filter(goal %in% c('ICO','LSP'),
           dimension %in% c('status', 'trend', 'future', 'score')) %>%
    group_by(region_id, dimension) %>%
    summarize(score = mean(score, na.rm=TRUE)) %>%
    ungroup() %>%
    arrange(region_id) %>%
    mutate(goal = "SP") %>%
    select(region_id, goal, dimension, score) %>%
    data.frame()

  # return all scores
  return(rbind(scores, s))
} ## End SP function


NUT = function(layers){
  #####----------------------######
  ## NUT Status - Secchi data
  #####----------------------######
  ## UPDATE 5April2016 - Jennifer Griffiths - NUT status calculated in Secchi prep

  ## NUT status and trend calculated in prep file because calculated for HOLAS basins
  ## Basin status and trend are then assigned to BHI regions
  ## Status is calculated for more recent year (prior to 2014). This is 2013 for most regions
  ## but not for all (some 2012,2011)
  ## Trend is calculated over a 10 year period with a minimum of 5 years of data
  ## expect slow response time in secchi observation so use longer time window for trend

  ## Read in from csv to test
  #cw_nu_status= read.csv('~github/bhi/baltic2015/layers/cw_nu_status_bhi2015.csv')
  #cw_nu_trend= read.csv('~github/bhi/baltic2015/layers/cw_nu_trend_bhi2015.csv')


  cw_nu_status   = SelectLayersData(layers, layers='cw_nu_status') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)

  cw_nu_trend  = SelectLayersData(layers, layers='cw_nu_trend') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)


  # rbind NUT status and trend to one dataframe
  scores = cw_nu_status %>%
    rbind(cw_nu_trend) %>%
    mutate(goal = 'NUT') %>%
    dplyr::select(goal,
                  dimension,
                  region_id = rgn_id,
                  score) %>%
    arrange(dimension,region_id)

  return(scores)
  #####----------------------######

} ## End NUT Function

TRA = function(layers){
  #####----------------------######
  ## Trash
  #####----------------------######

  ## UDPATE 11May2016 - Jennifer Griffiths - TRA status included

  ## TO DO
  ## Solve how to deal with no TRA trend for TRA future status and for overall CW trend

  ## Status calcuated in prep file
  ## reference points set and calculated in /prep/CW/trash/trash_prep.rmd

  ## Read in csv to test
  #cw_tra_score = read.csv('~github/bhi/baltic2015/layers/po_trash_bhi2015.csv')

  cw_tra_score = SelectLayersData(layers, layers='po_trash') %>%
    dplyr::select(rgn_id = id_num, score = val_num)

  cw_tra_status = cw_tra_score %>%
    mutate(score = round((1 - score)*100)) ## status is 1 - pressure, status is 0-100

  ## no TRA trend
  ## this is a problem - need to solve. 7 July 2016
  ##If is NA, no future status is calculated. If is zero, is problematic for overal CW trend.


  ## create scores variable
  scores = cw_tra_status %>%
    mutate(dimension= "status",
           goal = 'TRA') %>%
    dplyr::select(goal,
                  dimension,
                  region_id = rgn_id,
                  score) %>%
    arrange(dimension,region_id)

  #debug JSL, temporary
  # scores = scores %>%
  #   rbind(cw_tra_status %>%
  #   mutate(dimension= "status",
  #          goal = 'TRA') %>%
  #   dplyr::select(goal,
  #                 dimension,
  #                 region_id = rgn_id,
  #                 score) %>%
  #   arrange(dimension,region_id))

  return(scores)
} ## END TRA function

CON = function(layers){
  #####----------------------######
  ## Contaminants
  #####----------------------######
  ## UDPATE 11May2016 - Jennifer Griffiths - CON ICES6 added from contaminants_prep,
  ##TODO
  ## add other CON components
  ## UPDATE 14 JULY 2016 - Jennifer Griffiths
  ## CON dioxin indicator added
  ## function mean_NAall added so that NA not NaN produced from arithmetic mean of a vector of NA
  ## UPDATE 21 JULY 2016 -Jennifer Griffiths, PFOS indicator added

  ## Function to deal with cases where want to take the arithmetic mean of a vector of NA values, will return NA instead of NaN

  mean_NAall = function(x){

    if(sum(is.na(x))==length(x)){mean_val = NA
    }else{mean_val =mean(x,na.rm=TRUE) }
    return(mean_val)
  }


  ## 3 Indicators for contaminants: ICES6, Dioxin, PFOS

  ## 3 indicators will be averaged (arithmetic mean) for status and trend (if trend for more than ICES6)

  ## ICES6

  cw_con_ices6_status   = SelectLayersData(layers, layers='cw_con_ices6_status') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num) %>%
    mutate(dimension = as.character(dimension))

  cw_con_ices6_trend  = SelectLayersData(layers, layers='cw_con_ices6_trend') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num) %>%
    mutate(dimension = as.character(dimension))

  ##Join ICES6
  cw_con_ices6 = cw_con_ices6_status %>%
    rbind(cw_con_ices6_trend) %>%
    dplyr::rename(region_id = rgn_id)%>%
    mutate(indicator = "ices6")

  ##Dioxin
  cw_con_dioxin_status   = SelectLayersData(layers, layers='cw_con_dioxin_status') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)%>%
    mutate(dimension = as.character(dimension))

  cw_con_dioxin_trend  = SelectLayersData(layers, layers='cw_con_dioxin_trend') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)%>%
    mutate(dimension = as.character(dimension))

  ##Join dioxin
  cw_con_dioxin = full_join(cw_con_dioxin_status,cw_con_dioxin_trend, by = c('rgn_id','dimension','score')) %>%
    dplyr::rename(region_id = rgn_id)%>%
    mutate(indicator = "dioxin")

  ##PFOS
  cw_con_pfos_status   = SelectLayersData(layers, layers='cw_con_pfos_status') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)%>%
    mutate(dimension = as.character(dimension))

  cw_con_pfos_trend  = SelectLayersData(layers, layers='cw_con_pfos_trend') %>%
    dplyr::select(rgn_id = id_num, dimension=category, score = val_num)%>%
    mutate(dimension = as.character(dimension))

  ##Join pfos
  cw_con_pfos = full_join(cw_con_pfos_status,cw_con_pfos_trend, by = c('rgn_id','dimension','score')) %>%
    dplyr::rename(region_id = rgn_id)%>%
    mutate(indicator = "pfos")



  ##Join all indicators
  cw_con = bind_rows(cw_con_ices6, cw_con_dioxin, cw_con_pfos)


  ## Average CON indicators for Status and Trend
  cw_con = cw_con %>%
    select(-indicator) %>%
    group_by(region_id,dimension)%>%
    summarise(score = mean_NAall(score))%>% ## If there is an NA, skip over now, if all are NA, NA not NaN returned
    ungroup() %>%
    mutate(subcom = 'CON')%>%
    arrange(dimension,region_id)

  ## create scores variable
  scores = cw_con %>%
    mutate(goal = 'CON') %>%
    dplyr::select(goal,
                  dimension,
                  region_id,
                  score) %>%
    arrange(dimension,region_id)


  return(scores)

}  ## END CON Function

CW = function(scores){
  #####----------------------######
  ## CW status & CW Trend

  ## UPDATE 15June 2016 - Jennifer Griffiths - update CW status and trend calculation for CW
  ## only have 1 status point for CON, TRA (therefore can not take a CW status as geometric mean with many points over time)
  ## Calculate geometric mean of 1 status for current status
  ## calculate arithmetic mean of NUT and CON trend for the CW trend (because have 0, NA, and neg. values in trend, cannot use geometric mean)


  ## Status is the geometric mean of NUT, CON, TRA status for most recent year
  ## trend in the arithmetic mean of NUT, CON, TRA trend because can not deal with 0 values in geometric mean

  ### function to calculate geometric mean:
  geometric.mean2 <- function (x, na.rm = TRUE) {
    if (is.null(nrow(x))) {
      exp(mean(log(x), na.rm = TRUE))
    }
    else {
      exp(apply(log(x), 2, mean, na.rm = na.rm))
    }
  }

  ## Function to deal with cases where want to take the arithmetic mean of a vector of NA values, will return NA instead of NaN
  mean_NAall = function(x){

    if(sum(is.na(x))==length(x)){mean_val = NA
    }else{mean_val =mean(x,na.rm=TRUE) }
    return(mean_val)
  }

  ## subset CW subgoals
  scores_cw <- scores %>%
    filter(goal %in% c('NUT', 'TRA', 'CON')) %>%
    arrange(dimension,region_id)

  ## Calculate geometric mean for status, arithmetic mean for trend (ignore NAs)
  ## NOTE to @jennifergriffiths: there are still several 'NaN's, perhaps because of TRA?
  ## 7 July 2016 - Think have fixed the NaN problem with the function mean_NAall()
  ## also, rounding score doesn't seem to work here; ends up with .00 precision. maybe round later?

  ## July 21, 2016 @jules32 after discussing with @Melsteroni.
  ## Calculate CW as a geometric mean from NUT, CON, and TRA
  ## for only 3 dimensions: status, likely future state and score. Other 'supragoals' (SP, FP, LE) would
  ## also calculate trend, and would do this as a simple mean (excluding pressures and resilience since
  ## the mean of those variables makes less sense). But here, geometric mean of trend also makes less sense, so exclude.
  ## take the
  s <- scores_cw %>%
    filter(dimension %in% c('status', 'future', 'score')) %>%
    group_by(region_id, dimension) %>%
    summarize(score = round(geometric.mean2(score, na.rm=TRUE))) %>% # round status to 0 decimals
    ungroup() %>%
    arrange(region_id) %>%
    mutate(goal = "CW") %>%
    select(region_id, goal, dimension, score) %>%
    data.frame()

  ## return all scores
  return(rbind(scores, s))
} ## End CW function


BD = function(layers){
  ## BD goal now has no subgoals; it is only species.
  ## Updated by Jennifer Griffiths 7 July 2016
  ## BD status calculated in spp_prep file because calculated by basin and then applied to BHI regions
      ## Status is the geometric mean of each taxa group status by basin
      ## No Trend, have NA as placeholder


  ## Call Layers
  ## status
  bd_status = SelectLayersData(layers, layers='bd_spp_status', narrow=T) %>%
    select(rgn_id = id_num,
           dimension = category,
           score= val_num)

  ##trend
    ## no trend layer


  ## Finalize status and trend
      status = bd_status %>%
            dplyr::rename(region_id=rgn_id) %>%
            mutate(score = round(score*100))


    ## place holder for trend
      trend = data.frame(region_id = seq(1,42,1), score = rep(NA,42), dimension =rep("trend",42))


    ######################################################
    ## Scores combined
    ######################################################
     # scores
      scores = bind_rows(status, trend)%>%
           mutate(goal = 'BD')

      return(scores)
} ## End BD Function


FinalizeScores = function(layers, conf, scores){

  # get regions
  rgns = SelectLayersData(layers, layers=conf$config$layer_region_labels, narrow=T)

  # add NAs to missing combos (region_id, goal, dimension)
  d = expand.grid(list(score_NA  = NA,
                       region_id = c(rgns[,'id_num'], 0),
                       dimension = c('pressures','resilience','status','trend','future','score'),
                       goal      = c(conf$goals$goal, 'Index')), stringsAsFactors=F); head(d)
  d = subset(d,
             !(dimension %in% c('pressures','resilience','trend') & region_id==0) &
             !(dimension %in% c('pressures','resilience','status','trend') & goal=='Index'))
  scores = merge(scores, d, all=T)[,c('goal','dimension','region_id','score')]

  # order
  scores = arrange(scores, goal, dimension, region_id)

  # round scores
  scores$score = round(scores$score, 2)

  return(scores)
}
