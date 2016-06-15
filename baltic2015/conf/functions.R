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

}


MAR = function(layers){
  #updated by Jennifer Griffiths 25Feb2016
  #updated by Julie 26Feb2016
  #updated by Jennifer Griffiths 29Feb2016 - make sure mar_status_score limited to status_years, change layer names
  #updated by Jennifer Griffiths 29March2016 - added code for temporal reference point but this is commented out until final decision made
  #updated by Jennifer Griffiths 05April2016 - made reference point temporal (removed spatial), made data unit tons of production, not per capita

  #layers used: mar_harvest_tonnes, mar_harvest_species, mar_sustainability_score


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


  ## TEMP read in
  #  library(dplyr)
  #  library (tidyr)
  # harvest_tonnes = read.csv('~/github/bhi/baltic2015/layers/mar_harvest_tonnes_bhi2015.csv'); head(harvest_tonnes)
  # harvest_species = read.csv('~/github/bhi/baltic2015/layers/mar_harvest_species_bhi2015.csv'); head(harvest_species)
  # sustainability_score = read.csv('~/github/bhi/baltic2015/layers/mar_sustainability_score_bhi2015.csv'); head(sustainability_score)


  # SETTING CONSTANTS
  rm_year = 4              #number of years to use when calculating the running mean smoother
  regr_length =5          # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
  future_year = 5          # the year at which we want the likely future status
  min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
  status_years = 2010:2014 #this was originally set in goals.csv
  lag_win = 5             # if use a 5 year moving window reference point (instead of spatial, use this lag)

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
                arrange(rgn_id,year)%>%
                mutate(status, status = replace(status, is.na(status), 0))  #give NA value a 0

  #Calculate score
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


} #end mar function

FP = function(layers, scores){
  # weights
  w = rename(SelectLayersData(layers, layers='fp_wildcaught_weight', narrow=T),
             c('id_num'='region_id', 'val_num'='w_FIS')); head(w)

  # scores
  s = dcast(scores, region_id + dimension ~ goal, value.var='score', subset=.(goal %in% c('FIS','MAR') & !dimension %in% c('pressures','resilience'))); head(s)

  # combine
  d = merge(s, w)
  d$w_MAR = 1 - d$w_FIS
  d$score = apply(d[,c('FIS','MAR','w_FIS', 'w_MAR')], 1, function(x){ weighted.mean(x[1:2], x[3:4], na.rm=TRUE) })
  d$goal = 'FP'

  # return all scores
  return(rbind(scores, d[,c('region_id','goal','dimension','score')]))
}


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
        dplyr::select(rgn_id = id_num, dimension=category, score = val_num)

      ao_stock_slope = SelectLayersData(layers, layers='ao_stock_slope') %>%
        dplyr::select(rgn_id = id_num, dimension=category, score = val_num)


      ## status value if NA for status
        ## NA is because there has been no data, not because not applicable

        ## status score NA changed to zero

      ao_stock_status = ao_stock_status %>%
                        mutate(score = replace(score, is.na(score),0))

      ## trend calc
        future_year = 5  ## number of years in the future for trend

        ao_stock_trend = ao_stock_slope %>%
                          mutate(score = score* future_year)


      ## join status and trend
        ao_stock = full_join(ao_stock_status, ao_stock_trend, by = c('rgn_id','dimension','score')) %>%
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


  ## OLD AO function
  # function(layers,
  #          year_max,
  #          year_min=max(min(layers_data$year, na.rm=T), year_max - 10),
  #          Sustainability=1.0){
  #

#   ## based off of the HELCOM coastal fish indicator
#   ## ohi-Fiji used this approach, although they calculated the fish indicator within functions.r. (but conceptually is the same)
#   ## http://www.sciencedirect.com/science/article/pii/S2212041614001363
#   ## github.com/OHI-Science/ohi-fiji/blob/master/fiji2013/conf/functions.R
#
#
#   # cast data
#   layers_data = SelectLayersData(layers, targets='AO')
#
#   ry = rename(dcast(layers_data, id_num + year ~ layer, value.var='val_num',
#                     subset = .(layer %in% c('ao_need'))),
#               c('id_num'='region_id', 'ao_need'='need')); head(ry); summary(ry)
#
#   r = na.omit(rename(dcast(layers_data, id_num ~ layer, value.var='val_num',
#                            subset = .(layer %in% c('ao_access'))),
#                      c('id_num'='region_id', 'ao_access'='access'))); head(r); summary(r)
#
#   ry = merge(ry, r); head(r); summary(r); dim(r)
#
#   # model
#   ry = within(ry,{
#     Du = (1.0 - need) * (1.0 - access)
#     statusData = ((1.0 - Du) * Sustainability)
#   })
#
#   # status
#   r.status <- ry %>%
#     filter(year==year_max) %>%
#     select(region_id, statusData) %>%
#     mutate(status=statusData*100)
# summary(r.status); dim(r.status)
#
#   # trend
#   r.trend = ddply(subset(ry, year >= year_min), .(region_id), function(x)
#     {
#       if (length(na.omit(x$statusData))>1) {
#         # use only last valid 5 years worth of status data since year_min
#         d = data.frame(statusData=x$statusData, year=x$year)[tail(which(!is.na(x$statusData)), 5),]
#         trend = coef(lm(statusData ~ year, d))[['year']]*5
#       } else {
#         trend = NA
#       }
#       return(data.frame(trend=trend))
#     })
#
#   # return scores
#   scores = r.status %>%
#     select(region_id, score=status) %>%
#     mutate(dimension='status') %>%
#     rbind(
#       r.trend %>%
#         select(region_id, score=trend) %>%
#         mutate(dimension='trend')) %>%
#     mutate(goal='AO') # dlply(scores, .(dimension), summary)
#   return(scores)
#}

NP = function(scores, layers, year_max, debug=F){
  # TODO: add smoothing a la PLoS 2013 manuscript
  # TODO: move goal function code up to np_harvest_usd-peak-product-weight_year-max-%d.csv into ohiprep so layer ready already for calculating pressures & resilience

  # FIS status
  FIS_status =  scores %>%
    filter(goal=='FIS' & dimension=='status') %>%
    select(rgn_id=region_id, score)

  # layers
  rgns         = layers$data[['rgn_labels']]
  h_tonnes     = layers$data[['np_harvest_tonnes']]
  h_tonnes_rel = layers$data[['np_harvest_tonnes_relative']]
  h_usd        = layers$data[['np_harvest_usd']]
  h_usd_rel    = layers$data[['np_harvest_usd_relative']]
  h_w          = layers$data[['np_harvest_product_weight']]
  r_cyanide    = layers$data[['np_cyanide']]
  r_blast      = layers$data[['np_blast']]
  hab_extent   = layers$data[['hab_extent']]

  # extract habitats used
  hab_coral = hab_extent %>%
    filter(habitat=='coral') %>%
    select(rgn_id, km2)
  hab_rky   = hab_extent %>%
    filter(habitat=='rocky_reef') %>%
    select(rgn_id, km2)

  if (debug & !file.exists('temp')) dir.create('temp', recursive=T)

  # merge harvest in tonnes and usd
  h =
    join_all(
      list(
        h_tonnes,
        h_tonnes_rel,
        h_usd,
        h_usd_rel),
      by=c('rgn_id','product','year'),
      type='full') %>%
    left_join(
      h_w %>%
        select(rgn_id, product, usd_peak_product_weight=weight),
      by=c('rgn_id','product')) %>%
    left_join(
      rgns %>%
        select(rgn_id, rgn_name=label),
      by='rgn_id') %>%
    select(
      rgn_name, rgn_id, product, year,
      tonnes, tonnes_rel,
      usd, usd_rel,
      usd_peak_product_weight) %>%
    arrange(rgn_id, product, year) %>%
    group_by(rgn_id, product)

  if (debug){
    # write out data
    write.csv(h, sprintf('temp/%s_NP_1-harvest-rgn-year-product_data.csv', basename(getwd())), row.names=F, na='')
  }

  # area for poducts having single habitats for exposure
  a = rbind_list(
    # corals in coral reef
    h %>%
      filter(product=='corals') %>%
      left_join(
        hab_coral %>%
          filter(km2 > 0) %>%
          select(rgn_id, km2), by='rgn_id'),
    # seaweeds in rocky reef
    h %>%
      filter(product=='seaweeds') %>%
      left_join(
        hab_rky %>%
          filter(km2 > 0) %>%
          select(rgn_id, km2), by='rgn_id'))

  # area for products in both coral and rocky reef habitats: shells, ornamentals, sponges
  b = h %>%
    filter(product %in% c('shells', 'ornamentals','sponges')) %>%
    left_join(
      hab_coral %>%
        filter(km2 > 0) %>%
        select(rgn_id, coral_km2=km2),
      by='rgn_id') %>%
    left_join(
      hab_rky %>%
        filter(km2 > 0) %>%
        select(rgn_id, rky_km2=km2),
      by='rgn_id') %>%
    rowwise() %>%
    mutate(
      km2 = sum(c(rky_km2, coral_km2), na.rm=T)) %>%
    group_by(rgn_id, product) %>%
    filter(km2 > 0)

  # exposure: combine areas, get tonnes / area, and rescale with log transform
  E =
    rbind_list(
      a,
      b %>%
        select(-rky_km2, -coral_km2)) %>%
    mutate(
      exposure_raw = ifelse(tonnes > 0 & km2 > 0, tonnes / km2, 0)) %>%
    group_by(product) %>%
    mutate(
      exposure_product_max = max(exposure_raw, na.rm=T)) %>%
    ungroup() %>%
    mutate(
      exposure = log(exposure_raw + 1) / log(exposure_product_max + 1))

  # add exposure for fish_oil
  E =
    rbind_list(
      E,
      h %>%
        filter(product=='fish_oil') %>%
        left_join(
          FIS_status %>%
            mutate(
              exposure = score/100) %>%
            select(rgn_id, exposure),
          by='rgn_id'))

  if (debug){
    cat('Regions without FIS_status having harvest values:\n')
    E %>%
      filter(product=='fish_oil' & is.na(exposure)) %>%
      group_by(rgn_name) %>%
      summarize(n=n())
    #         rgn_name  n
    # 1        Bonaire  9
    # 2       DISPUTED 12
    # 3           Saba  9
    # 4 Sint Eustatius  9
  }

  # assign fish_oil exposure to 0 if missing FIS status
  E = E %>% mutate(
    exposure = ifelse(is.na(exposure), 0, exposure))

  # risk for ornamentals set to 1 if blast or cyanide fishing present, based on Nature 2012 code
  #  despite Nature 2012 Suppl saying Risk for ornamental fish is set to the "relative intensity of cyanide fishing"
  r_orn = r_cyanide %>%
    filter(!is.na(score) & score > 0) %>%
    select(rgn_id, cyanide=score) %>%
    merge(
      r_blast %>%
        filter(!is.na(score) & score > 0) %>%
        select(rgn_id, blast=score),
      all=T) %>%
    mutate(
      ornamentals = 1)

  # risk as binary
  R =
    # fixed risk: corals (1), sponges (0) and shells (0)
    data.frame(
      rgn_id  = rgns$rgn_id,
      corals  = 1,
      sponges = 0,
      shells  = 0) %>%
    # ornamentals
    left_join(
      r_orn %>%
        select(rgn_id, ornamentals),
      by = 'rgn_id')  %>%
    mutate(
      ornamentals = ifelse(is.na(ornamentals), 0, ornamentals)) %>%
    melt(id='rgn_id', variable.name='product', value.name='risk')

  # join Exposure (with harvest) and Risk
  D = E %>%
    left_join(
      R,
      by=c('rgn_id','product'))
  D$sustainability = 1 - rowMeans(D[,c('exposure','risk')], na.rm=T)

  if (debug){
    # show NAS
    cat('NAs between exposure and risk\n')
    table(mutate(D, risk_na=is.na(risk), exposure_na=is.na(exposure)) %>% select(product, risk_na, exposure_na))
    # , , exposure_na = FALSE
    #
    #              risk_na
    # product       FALSE TRUE
    #   corals       1347    0
    #   fish_oil        0 2689
    #   ornamentals  2515    0
    #   seaweeds        0 1977
    #   shells       1142    0
    #   sponges      1208    0
  }

  # calculate rgn-product-year status
  D = mutate(D, product_status = tonnes_rel * sustainability) %>%
    filter(rgn_name != 'DISPUTED')

  # aggregate across products to rgn-year status, weighting by usd_rel
  S = D %>%
    group_by(rgn_name, rgn_id, year) %>%
    filter(!is.na(product_status) & !is.na(usd_peak_product_weight)) %>%
    #select(rgn_name, rgn_id, year, product_status, usd_peak_product_weight) %>%
    summarize(
      status = weighted.mean(product_status, usd_peak_product_weight)) %>%
    filter(!is.na(status)) %>% # 1/0 produces NaN
    ungroup()

  if (debug){
    # write out data
    write.csv(D, sprintf('temp/%s_NP_2-rgn-year-product_data.csv', basename(getwd())), row.names=F, na='')
    write.csv(S, sprintf('temp/%s_NP_3-rgn-year_status.csv', basename(getwd())), row.names=F, na='')
  }

  # get status
  status = S %>%
    filter(year==year_max & !is.na(status)) %>%
    mutate(
      dimension = 'status',
      score     = round(status,4) * 100) %>%
    select(rgn_id, dimension, score) %>%
    arrange(rgn_id) # 30 status==NAs for year_max==2011
  stopifnot(min(status$score, na.rm=T)>=0, max(status$score, na.rm=T)<=100)

  # trend based on 5 intervals (6 years of data)
  trend = S %>%
    filter(year <= year_max & year > (year_max - 5) & !is.na(status)) %>%
    arrange(rgn_id, year) %>%
    group_by(rgn_id) %>%
    do(mdl = lm(status ~ year, data=.)) %>%
    summarize(
      rgn_id    = rgn_id,
      dimension = 'trend',
      score     = max(-1, min(1, coef(mdl)[['year']] * 5)))
  stopifnot(min(trend$score)>=-1, max(trend$score)<=1)

  # return scores
  scores_NP =
    rbind_list(
      status,
      trend) %>%
    mutate(
      goal = 'NP') %>%
    select(goal, dimension, region_id=rgn_id, score) %>%
    arrange(goal, dimension, region_id)
  # scores_NP %>% filter(region_id==136)
  return(scores_NP)
}

CS = function(layers){

  # layers
  lyrs = list('rk' = c('hab_health' = 'health',
                       'hab_extent' = 'extent',
                       'hab_trend'  = 'trend'))
  lyr_names = sub('^\\w*\\.','', names(unlist(lyrs)))

  # cast data
  D = SelectLayersData(layers, layers=lyr_names)
  rk = rename(dcast(D, id_num + category ~ layer, value.var='val_num', subset = .(layer %in% names(lyrs[['rk']]))),
              c('id_num'='region_id', 'category'='habitat', lyrs[['rk']]))

  # limit to CS habitats
  rk = subset(rk, habitat %in% c('seagrass'))

  # assign extent of 0 as NA
  rk$extent[rk$extent==0] = NA

  # status
  r.status = ddply(na.omit(rk[,c('region_id','habitat','extent','health')]), .(region_id), summarize,
                   goal = 'CS',
                   dimension = 'status',
                   score = min(1, sum(extent * health) / sum(extent)) * 100)

  # trend
  r.trend = ddply(na.omit(rk[,c('region_id','habitat','extent','trend')]), .(region_id), summarize,
                  goal = 'CS',
                  dimension = 'trend',
                  score = sum(extent * trend) / sum(extent) )

  # return scores
  scores = cbind(rbind(r.status, r.trend))
  return(scores)
}


CP = function(layers){

  # sum mangrove_offshore1km + mangrove_inland1km = mangrove to match with extent and trend
  m = layers$data[['hab_extent']] %>%
    filter(habitat %in% c('mangrove_inland1km','mangrove_offshore1km')) %>%
    select(rgn_id, habitat, km2)

  if (nrow(m) > 0){
    m = m %>%
      group_by(rgn_id) %>%
      summarize(km2 = sum(km2, na.rm=T)) %>%
      mutate(habitat='mangrove') %>%
      ungroup()
  }

  # join layer data
  d =
    join_all(
      list(
        layers$data[['hab_health']] %>%
          select(rgn_id, habitat, health),

        layers$data[['hab_trend']] %>%
          select(rgn_id, habitat, trend),

        # for habitat extent
        rbind_list(

          # do not use all mangrove
          layers$data[['hab_extent']] %>%
            filter(!habitat %in% c('mangrove','mangrove_inland1km','mangrove_offshore1km')) %>%
            select(rgn_id, habitat, km2),

          # just use inland1km and offshore1km
          m)),

      by=c('rgn_id','habitat'), type='full') %>%
    select(rgn_id, habitat, km2, health, trend)

  # limit to CP habitats and add rank
  habitat.rank = c('coral'            = 4,
                   'mangrove'         = 4,
                   'saltmarsh'        = 3,
                   'seagrass'         = 1,
                   'seaice_shoreline' = 4)

  d = d %>%
    filter(habitat %in% names(habitat.rank)) %>%
    mutate(
      rank = habitat.rank[habitat],
      extent = ifelse(km2==0, NA, km2))

  if (nrow(d) > 0){
    # status
    scores_CP = d %>%
      filter(!is.na(rank) & !is.na(health) & !is.na(extent)) %>%
      group_by(rgn_id) %>%
      summarize(
        score = pmin(1, sum(rank * health * extent) / (sum(extent) * max(rank)) ) * 100,
        dimension = 'status')

    # trend
    d_trend = d %>%
      filter(!is.na(rank) & !is.na(trend) & !is.na(extent))
    if (nrow(d_trend) > 0 ){
      scores_CP = rbind_list(
        scores_CP,
        d_trend %>%
          group_by(rgn_id) %>%
          summarize(
            score = sum(rank * trend * extent) / (sum(extent)* max(rank)),
            dimension = 'trend'))
    }

    scores_CP = scores_CP %>%
      mutate(
        goal = 'CP') %>%
      select(region_id=rgn_id, goal, dimension, score)
  } else {
    scores_CP = data.frame(
      goal      = character(0),
      dimension = character(0),
      region_id = integer(0),
      score     = numeric())
  }

  # return scores
  return(scores_CP)
}


TR = function(layers, year_max, debug=FALSE, pct_ref=90){

  # formula:
  #   E = Ed / (L - (L*U))
  #   Sr = (S-1)/5
  #   Xtr = E * Sr
  #
  # Ed = Direct employment in tourism (tr_jobs_tourism): ** this has not been gapfilled. We thought it would make more sense to do at the status level.
  # L = Total labor force (tr_jobs_total)
  # U = Unemployment (tr_unemployment) 2013: max(year)=2011; 2012: max(year)=2010
  # so E is tourism  / employed
  # S = Sustainability index (tr_sustainability)
  #
  # based on model/GL-NCEAS-TR_v2013a: TRgapfill.R, TRcalc.R...
  # spatial gapfill simply avg, not weighted by total jobs or country population?
  # scenario='eez2013'; year_max = c(eez2012=2010, eez2013=2011, eez2014=2012)[scenario]; setwd(sprintf('~/github/ohi-global/%s', scenario))

  # get regions
  rgns = layers$data[[conf$config$layer_region_labels]] %>%
    select(rgn_id, rgn_label = label)

  # merge layers and calculate score
  d = layers$data[['tr_jobs_tourism']] %>%
    select(rgn_id, year, Ed=count) %>%
    arrange(rgn_id, year) %>%
    merge(
      layers$data[['tr_jobs_total']] %>%
        select(rgn_id, year, L=count),
      by=c('rgn_id','year'), all=T) %>%
    merge(
      layers$data[['tr_unemployment']] %>%
        select(rgn_id, year, U=percent) %>%
        mutate(U = U/100),
      by=c('rgn_id','year'), all=T) %>%
    merge(
      layers$data[['tr_sustainability']] %>%
        select(rgn_id, S_score=score),
      by=c('rgn_id'), all=T)  %>%
    mutate(
      E     = Ed / (L - (L * U)),
      S     = (S_score - 1) / 5,
      Xtr   = E * S ) %>%
    merge(rgns, by='rgn_id') %>%
    select(rgn_id, rgn_label, year, Ed, L, U, S, E, Xtr)

  # feed NA for subcountry regions without sufficient data (vs global analysis)
  if (conf$config$layer_region_labels!='rgn_global' & sum(!is.na(d$Xtr))==0) {
    scores_TR = rbind_list(
      rgns %>%
        select(region_id = rgn_id) %>%
        mutate(
          goal      = 'TR',
          dimension = 'status',
          score     = NA),
      rgns %>%
        select(region_id = rgn_id) %>%
        mutate(
          goal      = 'TR',
          dimension = 'trend',
          score     = NA))
    return(scores_TR)
  }

#   if (debug){
#     # compare with pre-gapfilled data
#     if (!file.exists('temp')) dir.create('temp', recursive=T)
#
#     # cast to wide format (rows:rgn, cols:year, vals: Xtr) similar to original
#     d_c = d %>%
#       filter(year %in% (year_max-5):year_max) %>%
#       dcast(rgn_id ~ year, value.var='Xtr')
#     write.csv(d_c, sprintf('temp/%s_TR_0-pregap_wide.csv', basename(getwd())), row.names=F, na='')
#
#     o = read.csv(file.path(dir_neptune_data, '/model/GL-NCEAS-TR_v2013a/raw/TR_status_pregap_Sept23.csv'), na.strings='') %>%
#       melt(id='rgn_id', variable.name='year', value.name='Xtr_o') %>%
#       mutate(year = as.integer(sub('x_TR_','', year, fixed=T))) %>%
#       arrange(rgn_id, year)
#
#     vs = o %>%
#       merge(
#         expand.grid(list(
#           rgn_id = rgns$rgn_id,
#           year   = 2006:2011)),
#         by=c('rgn_id', 'year'), all=T) %>%
#       merge(d, by=c('rgn_id','year')) %>%
#       mutate(Xtr_dif = Xtr - Xtr_o) %>%
#       select(rgn_id, rgn_label, year, Xtr_o, Xtr, Xtr_dif, E, Ed, L, U, S) %>%
#       arrange(rgn_id, year)
#     write.csv(vs, sprintf('temp/%s_TR_0-pregap-vs_details.csv', basename(getwd())), row.names=F, na='')
#
#     vs_rgn = vs %>%
#       group_by(rgn_id) %>%
#       summarize(
#         n_notna_o   = sum(!is.na(Xtr_o)),
#         n_notna     = sum(!is.na(Xtr)),
#         dif_avg     = mean(Xtr, na.rm=T) - mean(Xtr_o, na.rm=T),
#         Xtr_2011_o  = last(Xtr_o),
#         Xtr_2011    = last(Xtr),
#         dif_2011    = Xtr_2011 - Xtr_2011_o) %>%
#       filter(n_notna_o !=0 | n_notna!=0) %>%
#       arrange(desc(abs(dif_2011)), Xtr_2011, Xtr_2011_o)
#     write.csv(vs_rgn, sprintf('temp/%s_TR_0-pregap-vs_summary.csv', basename(getwd())), row.names=F, na='')
#   }

  # get georegions for gapfilling
  georegions = layers$data[['rgn_georegions']] %>%
    dcast(rgn_id ~ level, value.var='georgn_id')
  georegion_labels =  layers$data[['rgn_georegion_labels']] %>%
    mutate(level_label = sprintf('%s_label', level)) %>%
    dcast(rgn_id ~ level_label, value.var='label') %>%
    left_join(
      layers$data[['rgn_labels']] %>%
        select(rgn_id, v_label=label),
      by='rgn_id')

  # setup data for georegional gapfilling (remove Antarctica rgn_id=213)
  if (!file.exists('temp')) dir.create('temp', recursive=T)
  csv = sprintf('temp/%s_TR_1-gapfill-georegions.csv', basename(getwd()))
  if (conf$config$layer_region_labels=='rgn_global'){
    d_g = gapfill_georegions(
      data              = d %>%
        filter(rgn_id!=213) %>%
        select(rgn_id, year, Xtr),
      fld_id            = 'rgn_id',
      fld_value         = 'Xtr',
      fld_weight        = NULL,
      georegions        = georegions,
      ratio_weights     = FALSE,
      georegion_labels  = georegion_labels,
      r0_to_NA          = TRUE,
      attributes_csv    = csv)

    # regions with Travel Warnings at http://travel.state.gov/content/passports/english/alertswarnings.html
    rgn_travel_warnings = c('Djibouti'=46, 'Eritrea'=45, 'Somalia'=44, 'Mauritania'=64)
    # TODO: check if regions with travel warnings are gapfilled (manually checked for 2013)
    d_g = rbind_list(
      d_g %>%
        filter(!rgn_id %in% rgn_travel_warnings),
      d_g %>%
        filter(rgn_id %in% rgn_travel_warnings) %>%
        mutate(
          Xtr = 0.1 * Xtr))
  } else {
    d_g = d
  }

  # filter: limit to 5 intervals (6 years worth of data)
  #   NOTE: original 2012 only used 2006:2010 whereas now we're using 2005:2010
  d_g_f = d_g %>%
    filter(year %in% (year_max - 5):year_max)

  # rescale for
  #   status: 95 percentile value across all regions and filtered years
  #   trend: use the value divided by max bc that way it's rescaled but not capped to a lower percentile (otherwise the trend calculated for regions with capped scores, i.e. those at or above the percentile value, would be spurious)

  d_q_yr  =
    d_g_f %>%
    group_by(year) %>%
    summarize(
      Xtr_q = quantile(Xtr, probs=pct_ref/100, na.rm=T))
    # year     Xtr_q
    # 2006 0.06103857
    # 2007 0.06001672
    # 2008 0.06222823
    # 2009 0.05563864
    # 2010 0.05811622
    # 2011 0.05893174

  Xtr_max = max(d_g_f$Xtr, na.rm=T)

  # print the reference point--incomplete
#   d_g_f_ref = d_g_f_r %>%
#     filter(Xtr >= Xtr_max)
#   cat(sprintf('the %f percentile for TR is for rgn_id=%f', pct_ref,

  d_g_f_r = d_g_f %>%
    left_join(d_q_yr, by='year') %>%
    mutate(
      Xtr_rq  = ifelse(Xtr / Xtr_q > 1, 1, Xtr / Xtr_q), # rescale to qth percentile, cap at 1
      Xtr_rmax = Xtr / Xtr_max )                         # rescale to max value
  if (debug){
    write.csv(d_g_f_r, sprintf('temp/%s_TR_2-filtered-rescaled.csv', basename(getwd())), row.names=F, na='')
  }

  # calculate trend
  d_t = d_g_f_r %>%
    filter(!is.na(Xtr_rmax)) %>%
    arrange(year, rgn_id) %>%
    group_by(rgn_id) %>%
    do(mod = lm(Xtr_rmax ~ year, data = .)) %>%
    do(data.frame(
      rgn_id = .$rgn_id,
      dimension = 'trend',
      score = max(min(coef(.$mod)[['year']] * 5, 1), -1)))

  # get status (as last year's value)
  d_s = d_g_f_r %>%
    arrange(year, rgn_id) %>%
    group_by(rgn_id) %>%
    summarize(
      dimension = 'status',
      score = last(Xtr_rq) * 100)

  # bind rows
  d_b = rbind(d_t, d_s) %>%
    mutate(goal = 'TR')

  if (conf$config$layer_region_labels=='rgn_global'){
    # assign NA for uninhabitated islands
    unpopulated = layers$data[['le_popn']] %>%
      group_by(rgn_id) %>%
      filter(count==0) %>%
      select(rgn_id)
    d_b$score = ifelse(d_b$rgn_id %in% unpopulated$rgn_id, NA, d_b$score)

    # replace North Korea value with 0
    d_b$score[d_b$rgn_id == 21] = 0
  }

  # final scores
  scores = d_b %>%
    select(region_id=rgn_id, goal, dimension, score)

  if (debug){

    # compare with original scores
    csv_o = file.path(dir_neptune_data, 'git-annex/Global/NCEAS-OHI-Scores-Archive/scores/scores.Global2013.www2013_2013-10-09.csv')
    o = read.csv(csv_o, na.strings='NA', row.names=1) %>%
      filter(goal %in% c('TR') & dimension %in% c('status','trend') & region_id!=0) %>%
      select(goal, dimension, region_id, score_o=score)

    vs = scores %>%
      merge(o, all=T, by=c('goal','dimension','region_id')) %>%
      merge(
        rgns %>%
          select(region_id=rgn_id, region_label=rgn_label),
        all.x=T) %>%
      mutate(
        score_dif    = score - score_o,
        score_notna  =  is.na(score)!=is.na(score_o)) %>%
      #filter(abs(score_dif) > 0.01 | score_notna == T) %>%
      arrange(desc(dimension), desc(abs(score_dif))) %>%
      select(dimension, region_id, region_label, score_o, score, score_dif)

    # output comparison
    write.csv(vs, sprintf('temp/%s_TR_3-scores-vs.csv', basename(getwd())), row.names=F, na='')

  }

  return(scores)
}


LIV = function(layers){

  # TODO: completely do this; currently just a copy of ECO function

  ## read in data
  le_gdp_region   = SelectLayersData(layers, layers='le_gdp_region') %>%
    dplyr::select(rgn_id = id_num, year, gdp_mio_euro = val_num)

  le_gdp_country  = SelectLayersData(layers, layers='le_gdp_country') %>%
    dplyr::select(rgn_id = id_num, year, gdp_mio_euro = val_num)


  ## temp readin TODO: SelectLayers()
  # library(dplyr)
  # le_gdp_region = read.csv('~/github/bhi/baltic2015/layers/le_gdp_region_bhi2015.csv'); head(le_gdp_region)

  ## set lag window for calculations
  lag_win = 5

  ## ECO region: prepare for calculations with a lag
  eco_region = le_gdp_region %>%
    dplyr::rename(gdp = gdp_mio_euro) %>%
    filter(!is.na(gdp)) %>%
    group_by(rgn_id) %>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(gdp, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)

  ## calculate status
  eco_status = eco_region %>%
    # join this to eco_country and calculate. the following is for testing
    select(rgn_id,
           status = gdp)

  ## calculate trend
  eco_trend = eco_status %>%
    # calculate trend. the following is for testing
    select(rgn_id,
           trend = status) # need to calculate trend

  ## create scores and rbind to other goal scores
  scores = eco_status %>%
    select(region_id = rgn_id,
           score     = status) %>%
    mutate(dimension='status') %>%
    rbind(
      eco_trend %>%
        select(region_id = rgn_id,
               score     = trend) %>%
        mutate(dimension = 'trend')) %>%
    mutate(goal='LIV')

    ## delete; this is temporary for testing
    scores = rbind(
      data.frame(
        region_id = 1:42,
        score = 0,
        dimension = 'status'),
      data.frame(
        region_id = 1:42,
        score = 0,
        dimension = 'trend')) %>%
    mutate(goal = 'LIV')


  return(scores)
}

ECO = function(layers){

  ## Status model: Xeco = (GDP_Region_c/GDP_Region_r)/(GDP_Country_c/GDP_Country_r)



  ## read in data
  ## in data prep, year range included is selected
    ##if different time periods exisit for region and country, NAs for status will be produced
  le_gdp_region   = SelectLayersData(layers, layers='le_gdp_region') %>%
    dplyr::select(rgn_id = id_num, year, gdp_mio_euro = val_num)

  le_gdp_country  = SelectLayersData(layers, layers='le_gdp_country') %>%
    dplyr::select(rgn_id = id_num, year, gdp_mio_euro = val_num)


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
    dplyr::rename(gdp = gdp_mio_euro) %>%
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
    dplyr::rename(gdp = gdp_mio_euro) %>%
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
              full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data
              mutate(score=round(status*100),   #scale to 0 to 100
                     dimension = 'status')%>%
              select(region_id = rgn_id,score, dimension)%>%
              mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
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

}


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
}


ICO = function(layers){

  # layers
  lyrs = c('ico_spp_extinction_status' = 'risk_category',
           'ico_spp_popn_trend'        = 'popn_trend')

  # cast data ----
  layers_data = SelectLayersData(layers, layers=names(lyrs))
  rk = rename(dcast(layers_data, id_num + category ~ layer, value.var='val_chr'),
              c('id_num'='region_id', 'category'='sciname', lyrs))

  # lookup for weights status
  w.risk_category = c('LC' = 0,
                      'NT' = 0.2,
                      'VU' = 0.4,
                      'EN' = 0.6,
                      'CR' = 0.8,
                      'EX' = 1)

  # lookup for population trend
  w.popn_trend = c('Decreasing' = -0.5,
                   'Stable'     =  0,
                   'Increasing' =  0.5)

  # status
  r.status = rename(ddply(rk, .(region_id), function(x){
    mean(1 - w.risk_category[x$risk_category], na.rm=T) * 100 }),
                    c('V1'='score'))

  # trend
  r.trend = rename(ddply(rk, .(region_id), function(x){
    mean(w.popn_trend[x$popn_trend], na.rm=T) }),
                   c('V1'='score'))

  # return scores
  s.status = cbind(r.status, data.frame('dimension'='status'))
  s.trend  = cbind(r.trend , data.frame('dimension'='trend' ))
  scores = cbind(rbind(s.status, s.trend), data.frame('goal'='ICO'))
  return(scores)

}

LSP = function(layers, ref_pct_cmpa=30, ref_pct_cp=30, status_year, trend_years){

lyrs = list('r'  = c('rgn_area_inland1km'   = 'area_inland1km',
                       'rgn_area_offshore3nm' = 'area_offshore3nm'),
              'ry' = c('lsp_prot_area_offshore3nm' = 'cmpa',
                        'lsp_prot_area_inland1km'   = 'cp'))
  lyr_names = sub('^\\w*\\.','', names(unlist(lyrs)))

  # cast data ----
  d = SelectLayersData(layers, layers=lyr_names)
  r  = rename(dcast(d, id_num ~ layer, value.var='val_num', subset = .(layer %in% names(lyrs[['r']]))),
              c('id_num'='region_id', lyrs[['r']]))
  ry = rename(dcast(d, id_num + year ~ layer, value.var='val_num', subset = .(layer %in% names(lyrs[['ry']]))),
              c('id_num'='region_id', lyrs[['ry']]))

  # fill in time series from first year specific region_id up to max year for all regions and generate cumulative sum
  yr.max = max(max(ry$year), status_year)
  r.yrs = ddply(ry, .(region_id), function(x){
    data.frame(region_id=x$region_id[1],
               year=min(x$year):yr.max)
    })
  r.yrs = merge(r.yrs, ry, all.x=T)
  r.yrs$cp[is.na(r.yrs$cp)]     = 0
  r.yrs$cmpa[is.na(r.yrs$cmpa)] = 0
  r.yrs = within(r.yrs, {
    cp_cumsum    = ave(cp  , region_id, FUN=cumsum)
    cmpa_cumsum  = ave(cmpa, region_id, FUN=cumsum)
    pa_cumsum    = cp_cumsum + cmpa_cumsum
  })

  # get percent of total area that is protected for inland1km (cp) and offshore3nm (cmpa) per year
  # and calculate status score
  r.yrs = merge(r.yrs, r, all.x=T); head(r.yrs)
  r.yrs = within(r.yrs,{
    pct_cp    = pmin(cp_cumsum   / area_inland1km   * 100, 100)
    pct_cmpa  = pmin(cmpa_cumsum / area_offshore3nm * 100, 100)
    prop_protected    = ( pmin(pct_cp / ref_pct_cp, 1) + pmin(pct_cmpa / ref_pct_cmpa, 1) ) / 2
  })

  # extract status based on specified year
  r.status = r.yrs %>%
    filter(year==status_year) %>%
    select(region_id, status=prop_protected) %>%
    mutate(status=status*100)
head(r.status)

  # calculate trend
  r.trend = ddply(subset(r.yrs, year %in% trend_years), .(region_id), function(x){
    data.frame(
      trend = min(1, max(0, 5 * coef(lm(prop_protected ~ year, data=x))[['year']])))})

  # return scores
  scores = rbind.fill(
    within(r.status, {
      goal      = 'LSP'
      dimension = 'status'
      score     = status}),
    within(r.trend, {
      goal      = 'LSP'
      dimension = 'trend'
      score     = trend}))
  return(scores[,c('region_id','goal','dimension','score')])
}

SP = function(scores){

  d = within(
    dcast(
      scores,
      region_id + dimension ~ goal, value.var='score',
      subset=.(goal %in% c('ICO','LSP') & !dimension %in% c('pressures','resilience')))
    , {
      goal = 'SP'
      score = rowMeans(cbind(ICO, LSP), na.rm=T)})


  # return all scores
  return(rbind(scores, d[,c('region_id','goal','dimension','score')]))
}


CW = function(layers){
  ## UPDATE 5April2016 - Jennifer Griffiths - NUT status calculated in Secchi prep
  ## UDPATE 11May2016 - Jennifer Griffiths - CON ICES6 added from contaminants_prep, TRA status included
  ## UPDATE 15June 2016 - Jennifer Griffiths - update CW status and trend calculation for CW
          ## only have 1 status point for CON, TRA (therefore can not take a CW status as geometric mean with many points over time)
          ## Calculate geometric mean of 1 status for current status
          ## calculate arithmetic mean of NUT and CON trend for the CW trend (because have 0, NA, and neg. values in trend, cannot use geometric mean)

  ##TODO
      ## add other CON components


  #################################
  #####----------------------######
  ## NUT Status - Secchi data
  #####----------------------######

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


    # join NUT status and trend to one dataframe
    cw_nu = full_join(cw_nu_status, cw_nu_trend, by = c('rgn_id','dimension','score')) %>%
            dplyr::rename(region_id = rgn_id) %>%
            mutate(subcom = 'NUT') %>%  ##Label subcompoent with nut so can average later
            arrange(dimension,region_id)
    #####----------------------######

  #################################
  #####----------------------######
  ## Trash
  #####----------------------######
    ## Status calcuated in prep file
    ## reference points set and calculated in /prep/CW/trash/trash_prep.rmd

    ## Read in csv to test
       #cw_tra_score = read.csv('~github/bhi/baltic2015/layers/po_trash_bhi2015.csv')

    cw_tra_score = SelectLayersData(layers, layers='po_trash') %>%
      dplyr::select(rgn_id = id_num, score = val_num)

    cw_tra_status = cw_tra_score %>%
                    mutate(score = round((1 - score)*100)) ## status is 1 - pressure, status is 0-100

    ## no TRA trend

    cw_tra = cw_tra_status %>%
            dplyr::rename(region_id = rgn_id) %>%
            mutate(dimension= "status",
                   subcom = 'TRA') %>%  ##Label subcompoent with TRA so can average later
            arrange(dimension,region_id)

  #################################
  #####----------------------######
  ## Contaminents
  #####----------------------######
    ## 3 Indicators for contaminants: ICES6, Dioxin, PFOS

    ## 3 indicators will be averaged (arithmetic mean) for status and trend (if trend for more than ICES6)

    ## ICES6
    ## read in csv to test
      #cw_con_ices6_status= read.csv('~github/bhi/baltic2015/layers/cw_con_ices6_status_bhi2015.csv')
      #cw_con_ices6_trend= read.csv('~github/bhi/baltic2015/layers/cw_con_ices6_trend_bhi2015.csv')

    cw_con_ices6_status   = SelectLayersData(layers, layers='cw_con_ices6_status') %>%
      dplyr::select(rgn_id = id_num, dimension=category, score = val_num)

    cw_con_ices6_trend  = SelectLayersData(layers, layers='cw_con_ices6_trend') %>%
      dplyr::select(rgn_id = id_num, dimension=category, score = val_num)

       ##Join ICES6
          cw_con_ices6 = full_join(cw_con_ices6_status,cw_con_ices6_trend, by = c('rgn_id','dimension','score')) %>%
                         dplyr::rename(region_id = rgn_id)%>%
                         mutate(indicator = "ices6")


    ##Dioxin
      ## TO DO...

    ##PFOS
      ## TO DO...


    ## TODO.....DECIDE IF KEEP NA or TRANSFORM TO ZERO


    ##Join all indicators
        #cw_con = full_join(cw_con_ices6, cw_con_dioxin, cw_con_pfos)

        cw_con = cw_con_ices6

      ## Average CON indicators for Status and Trend

      cw_con = cw_con %>%
              select(-indicator) %>%
              group_by(region_id,dimension)%>%
              summarise(score = mean(score, na.rm =TRUE))%>% ## If there is an NA, skip over now
              ungroup() %>%
              mutate(subcom = 'CON')%>%
              arrange(dimension,region_id)


  #####----------------------######
  ## CW status & CW Trend

      ## Status is the geometric mean of NUT, CON, TRA status for most recent year
      ## Trend is the geometric mean of NUT, CON trend - consequences is if one trend value is 0, geometric mean is zero

      ##
      scores = full_join(cw_nu, cw_con, by= c("region_id", "dimension", "score", "subcom"))%>%
               full_join(.,cw_tra, by= c("region_id", "dimension", "score", "subcom")) %>%
               select(-subcom)%>%
               arrange(dimension,region_id)%>%
               group_by(region_id,dimension) %>%
               mutate(score = ifelse(dimension == "status",exp(mean(log(score),na.rm=TRUE)),
                                    mean(score,na.rm=TRUE)))%>%## Geometric mean for status (if there is an NA, ignore); arithmetic mean for trend, ignore NA
               ungroup()%>%
               distinct()%>%
               mutate(score = ifelse(dimension=="status", round(score),round(score,2))) ## round score for status with no decimals, score for trend 2 decimals



      # return scores
        scores = scores %>%
                  mutate(goal   = 'CW')

      return(scores)
}


HAB = function(layers){

  # get layer data
  d =
    join_all(
      list(

        layers$data[['hab_health']] %>%
          select(rgn_id, habitat, health),

        layers$data[['hab_trend']] %>%
          select(rgn_id, habitat, trend),

        layers$data[['hab_extent']] %>%
          select(rgn_id, habitat, extent=km2)),

      by=c('rgn_id','habitat'), type='full') %>%
    select(rgn_id, habitat, extent, health, trend)

  # limit to habitats used for HAB, create extent presence as weight
  d = d %>%
    filter(habitat %in% c('coral','mangrove','saltmarsh','seaice_edge','seagrass','soft_bottom')) %>%
    mutate(
      w  = ifelse(!is.na(extent) & extent > 0, 1, NA)) %>%
    filter(!is.na(w)) %>%
    group_by(rgn_id)

  # calculate scores
  scores_HAB = rbind_list(
    # status
    d %>%
      filter(!is.na(health)) %>%
      summarize(
        score = pmin(1, sum(w * health) / sum(w)) * 100,
        dimension = 'status'),
    # trend
    d %>%
      filter(!is.na(trend)) %>%
      summarize(
        score =  sum(w * trend) / sum(w),
        dimension = 'trend')) %>%
    mutate(
      goal = 'HAB') %>%
    select(region_id=rgn_id, goal, dimension, score)

  # return scores
  return(scores_HAB)
}


SPP = function(layers){
  ## Updated by Jennifer Griffiths 8 June 2016


  ## Call Layers
  spp_div = SelectLayersData(layers, layers='spp_div_vuln', narrow=T) %>%
    select(rgn_id = id_num,
           species_name = category,
           weights= val_num)

  ######################################################
  ## Status calculation
  ######################################################

  ##sum the weights for each BHI region
  sum_wi = spp_div %>%
    group_by(rgn_id)%>%
    summarise(sum_wi =sum(weights))%>%
    ungroup()

  ## count the number of species in each BHI region
  sum_spp = spp_div %>%
            select(rgn_id,species_name)%>%
            dplyr::count(rgn_id)

  ## Calculate status
  ## sum of weights / total number of species
  spp_status = full_join(sum_wi,sum_spp, by="rgn_id") %>%
    mutate(wi_spp = sum_wi/n,
           status = 1 - wi_spp)


  #### Scale lower end to zero if 75% extinct
  ## Currently, no species labeled extinct but will set up code in case used in the future

  ## calculate percent extinct in each region
  ##spp_ex = data3 %>%
            ##filter(weights == 1) %>%
            ##select(rgn_id, species_name)%>%
            ##count(rgn_id) %>%
            ##dplyr::rename(n_extinct = n)
  ## join number extinct to spp_status and calculate %
  ## spp_status = spp_status %>%
                  ##left_join(., spp_ex, by="rgn_id") %>%
                  ##mutate(percent_extinct = n_extinct/n) %>%
                  ##mutate(status = ifelse(percent_extinct >=0.75, 0, status))

    ## finalize Status

    status = spp_status %>%
            select(rgn_id, status) %>%
            dplyr::rename(region_id=rgn_id,
                          score = status)%>%
            mutate(score = round(score*100),
                   dimension = "status")

    ######################################################
    ## Trend calculation
    ######################################################

     ## TO DO, decide on trend calculation

     ## place holder for trend
      trend = data.frame(region_id = seq(1,42,1), score = rep(0,42), dimension =rep("trend",42))


    ######################################################
    ## Scores combined
    ######################################################
     # scores
      scores = bind_rows(status, trend)%>%
           mutate(goal = 'SPP')

      return(scores)
}


BD = function(scores){

  d = within(
    dcast(
      scores,
      region_id + dimension ~ goal, value.var='score',
      subset=.(goal %in% c('HAB','SPP') & !dimension %in% c('pressures','resilience'))),
    {
      goal = 'BD'
      score = rowMeans(cbind(HAB, SPP), na.rm=T)})

  # return all scores
  return(rbind(scores, d[,c('region_id','goal','dimension','score')]))
}

PreGlobalScores = function(layers, conf, scores){

  # get regions
  rgns = SelectLayersData(layers, layers=conf$config$layer_region_labels, narrow=T)

  # limit to just desired regions and global (region_id==0)
  scores = subset(scores, region_id %in% c(rgns[,'id_num'], 0))

  # apply NA to Antarctica
  id_ant = subset(rgns, val_chr=='Antarctica', id_num, drop=T)
  scores[scores$region_id==id_ant, 'score'] = NA

  return(scores)
}

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
