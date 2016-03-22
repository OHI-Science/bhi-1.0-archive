## Note that some of the commands used below are from older R packages that we don't recommend using anymore (dcast, etc). Instead, use
## dplyr and tydr packages that have more streamlined functions to manipulate data. To learn those funtions:
## http://ohi-science.org/manual/#appendix-5-r-tutorials-for-ohi

## See functions.R of CHN (OHI-China) for how those functions are used in OHI+ assessments


FIS = function(layers, status_year){
  # status_year is defined in goals.csv
  # layers used: fis_meancatch, fis_b_bmsy, fis_proparea_saup2rgn

  # catch data
  c = SelectLayersData(layers, layers='fis_meancatch', narrow=T) %>%
    select(
      fao_saup_id    = id_chr,
      taxon_name_key = category,
      year,
      catch          = val_num)

  # separate out the region ids:
  c$fao_id    <- as.numeric(sapply(strsplit(as.character(c$fao_saup_id), "_"), function(x)x[1]))
  c$saup_id   <- as.numeric(sapply(strsplit(as.character(c$fao_saup_id), "_"), function(x)x[2]))
  c$TaxonName <- sapply(strsplit(as.character(c$taxon_name_key), "_"), function(x)x[1])
  c$TaxonKey  <- as.numeric(sapply(strsplit(as.character(c$taxon_name_key), "_"), function(x)x[2]))
  c$catch     <- as.numeric(c$catch)
  c$year      <- as.numeric(as.character(c$year))
  #Create Identifier for linking assessed stocks with country-level catches
  c$stock_id <- paste(as.character(c$TaxonName),
                      as.character(c$fao_id), sep="_")

  # equations (Halpern et al 2012 suppl, and the Halpern et al 2014 PlosONE US assessment)
  # xFIS=sum w(i)*((F´+B´)/2)
  #
  # B´=(B(i)/BMSY(i)/0.8)   if B/BMSY < 0.8
  #   = 1                   if 0.8 <= B/BMSY  <1.5
  #   = (Max(B/BMSY)-(B/BMSY))/1.8) if B/BMSY => 1.5 , max B/BMSY is the maximum B/BMSY value observed of a particular species over the entire time series
  #  in Schwermer = ((B/BMSY)/1.8) if B/BMSY => 1.5
  #
  # F´= 0                        if B/BMSY<0.8 and F/FMSY>B/BMSY+1.5
  #   = ((F/FMSY)/(B/BMSY)-0.2)  if  B/BMSY<0.8 and F/FMSY<B/BMSY-0.2
  #   = ((B/BMSY)+1.5-(F/FMSY))/1.5 if B/BMSY<0.8 and B/BMSY+0.2 < F/FMSY<B/BMSY+1.5
  #   = 1                            if B/BMSY<0.8 and B/BMSY-0.2 <= F/FMSY<B/BMSY+0.2
  #   = (F/FMSY)/0.8                if B/BMSY =>0.8 and F/FMSY<0.8
  #   = 1                           if B/BMSY=>0.8 and 0.8<=F/FMSY<1.2
  #   = (Max(F/FMSY)-(F/FMSY)/1.3           if B/BMSY=>0.8 and F/FMSY=>1.2, max F/FMSY is the maximum F/FMSY value observed of a particular species over the entire time series,
  #                                          The 1.3 value was chosen because the lowest possible value for F/Fmsy is 1.2 (ffmsy>=1.2), and (2.5 - 1.2)/1.3 = 1, establishing the high score of 1.
  #
  #
  # w(i)= (mean B(i))/(Sum (B))     mean spawning stock biomass odf species i in relation to total Spawning stock bioass within the region


##########################################################

  # b_bmsy data
  b = SelectLayersData(layers, layer='fis_b_bmsy', narrow=T) %>%
    select(
      fao_id         = id_num,
      TaxonName      = category,
      year,
      bmsy           = val_num)
  # Identifier taxa/fao region:
  b$stock_id <- paste(b$TaxonName, b$fao_id, sep="_")
  b$bmsy     <- as.numeric(b$bmsy)
  b$fao_id   <- as.numeric(as.character(b$fao_id))
  b$year     <- as.numeric(as.character(b$year))


  # area data for saup to rgn conversion
  a = layers$data[['fis_proparea_saup2rgn']] %>%
    select(saup_id, rgn_id, prop_area)
  a$prop_area <- as.numeric(a$prop_area)
  a$saup_id   <- as.numeric(as.character(a$saup_id))
  a$rgn_id    <- as.numeric(as.character(a$rgn_id))

  # ------------------------------------------------------------------------
  # STEP 1. Merge the species status data with catch data
  #     AssessedCAtches: only taxa with catch status data
  # -----------------------------------------------------------------------
  AssessedCatches <- join(b, c,
                          by=c("stock_id", "year"), type="inner")

  # b,c by stock_id

  # include only taxa with species-level data
  AssessedCatches <- AssessedCatches[as.numeric(AssessedCatches$TaxonKey)>=600000, ]
  AssessedCatches$penalty <- 1

  # ------------------------------------------------------------------------
  # STEP 2. Estimate status data for catch taxa without species status
  #     UnAssessedCatches: taxa with catch status data
  # -----------------------------------------------------------------------
  UnAssessedCatches <- c[!(c$year %in% AssessedCatches$year &
                             c$stock_id %in% AssessedCatches$stock_id), ]

  # 2a.  Join UnAssessedCatches data to the b_bmsy summaries for each FAO/Year

  # Average status data for assessed stocks by FAO region for each year.
  # This is used as the starting estimate for unassesed stocks
  # Here, the Median b_bmsy was chosen for TaxonKey >= 600000
  # and Min b_bmsy for TaxonKey < 600000
  #  *************NOTE *****************************
  #  Using the minimum B/BMSY score as an starting point
  #  for the estimate of B/BMSY for unassessed taxa not
  #  identified to species level is very conservative.
  #  This is a parameter that can be changed.
  #  ***********************************************
  b_summary <- ddply(b, .(fao_id, year), summarize,
                     Medianb_bmsy=quantile(as.numeric(bmsy), probs=c(0.5)),
                     Minb_bmsy=min(as.numeric(bmsy)))

  UnAssessedCatches <- join(UnAssessedCatches, b_summary, by=c("fao_id", "year"),
                            type="left", match="all")

#  UnAssessedCatches <- UnAssessedCatches[!(is.na(UnAssessedCatches$Medianb_bmsy)), ] #added 8/21/2014 due to changes in b/bmsy data created NAs here

#   ## Troubleshooting:
#   head(UnAssessedCatches[is.na(UnAssessedCatches$Medianb_bmsy), ])
#   tmp <- UnAssessedCatches[is.na(UnAssessedCatches$Medianb_bmsy), ]
#   unique(tmp$fao_id)
#   saups <- unique(tmp$saup_id)
#   unique(tmp$stock_id)
#   a[a$saup_id %in% saups,]
#
#   ggplot(tmp, aes(x=year, y=catch, group=saup_id, color=saup_id)) +
#     geom_point() +
#     geom_line() +
#     facet_wrap( ~ stock_id, ncol=9, scale="free")
#
  # 2b.  Create a penalty variable based on taxa level:
  UnAssessedCatches$TaxonPenaltyCode <- substring(UnAssessedCatches$TaxonKey,1,1)

  # 2c. Create a penalty table for taxa not identified to species level
  #  *************NOTE *****************************
  #  In some cases, it may make sense to alter the
  #  penalty for not identifying fisheries catch data to
  #  species level.
  #  ***********************************************
  penaltyTable <- data.frame(TaxonPenaltyCode=1:6,
                             penalty=c(0.01, 0.25, 0.5, 0.8, 0.9, 1))
  # 2d.Merge with data
  UnAssessedCatches <- join(UnAssessedCatches, penaltyTable, by="TaxonPenaltyCode")

  # ------------------------------------------------------------------------
  # STEP 3. Calculate score for all taxa based on status (b/bmsy) and taxa
  # -----------------------------------------------------------------------

  #  *************NOTE *****************************
  #  These values can be altered
  #  ***********************************************
  alpha <- 0.5
  beta <- 0.25
  lowerBuffer <- 0.95
  upperBuffer <- 1.05

  ## Function to calculate score for different scenarios:
  score <- function(data, variable){
    #data <- AssessedCatches
    #variable <- "bmsy"
    ifelse(data[ ,variable]*data[, "penalty"]<lowerBuffer,
           data[ ,variable]*data[, "penalty"],
           ifelse(data[ ,variable]*data[, "penalty"]>upperBuffer,
                  ifelse(1-alpha*(data[ ,variable]*data[, "penalty"]
                                  -upperBuffer)>beta,
                         1-alpha*(data[ ,variable]*data[, "penalty"]-upperBuffer),beta),
                  1))
  }

  AssessedCatches$score <- score(data=AssessedCatches, variable="bmsy")

  # Median is used to calculate score for species with Taxon 6 coding
  UnAssessedCatchesT6 <- subset(UnAssessedCatches, penalty==1)
  UnAssessedCatchesT6$score <- score(UnAssessedCatchesT6, "Medianb_bmsy")

  UnAssessedCatches <- subset(UnAssessedCatches, penalty!=1)
  UnAssessedCatches$score <- score(UnAssessedCatches, "Medianb_bmsy")

  AllScores <- rbind(AssessedCatches[,c("TaxonName", "TaxonKey", "year", "fao_id", "saup_id", "catch","score")],
                  UnAssessedCatchesT6[,c("TaxonName", "TaxonKey", "year", "fao_id", "saup_id", "catch","score")],
                  UnAssessedCatches[,c("TaxonName", "TaxonKey", "year", "fao_id", "saup_id", "catch","score")])

  # ------------------------------------------------------------------------
  # STEP 4. Calculate status for each saup_id region
  # -----------------------------------------------------------------------

  # 4a. To calculate the weight (i.e, the relative catch of each stock per saup_id),
  # the mean catch of taxon i is divided by the
  # sum of mean catch of all species in region r, which is calculated as:

  smc <- ddply(.data = AllScores, .(year, saup_id), summarize,
               SumCatch = sum(catch))
  AllScores<-join(AllScores,smc,by=c("year","saup_id"))
  AllScores$wprop<-AllScores$catch/AllScores$SumCatch


  #  4b. The "score" and "weight" values per taxon per SAUP region are used to
  #    calculate a geometric weighted mean across taxa for each saup_id region
  geomMean <- ddply(.data = AllScores, .(saup_id, year), summarize, status_saup = prod(score^wprop))

  # ------------------------------------------------------------------------
  # STEP 5. Convert status from saup spatial scale to OHI spatial scale
  # -----------------------------------------------------------------------
  # In many cases the ohi reporting regions are comprised of multiple saup regions.
  # To correct for this, the proportion of each saup area of the total area of the
  # OHI region was calculated. This was used to calculate Status from the Status_saup.
  # This type of adjustment is omitted if the data were collected at the same spatial
  # scale as the collecting region.

  # Join region names/ids to Geom data
  geomMean <- join(a, geomMean, type="inner", by="saup_id") # merge km2 of shelf area with status results

  # weighted mean scores
  StatusData <- ddply(.data = geomMean, .(rgn_id, year), summarize, Status = sum(status_saup*prop_area))

  # 2013 status is based on 2011 data (most recent data)
  status = StatusData %>%
    filter(year==status_year) %>%
    mutate(
      score     = round(Status*100),
      dimension = 'status') %>%
    select(region_id=rgn_id, dimension, score)

  # ------------------------------------------------------------------------
  # STEP 6. Calculate trend
  # -----------------------------------------------------------------------
  trend = ddply(StatusData, .(rgn_id), function(x){
    mdl = lm(Status ~ year, data=x)
    data.frame(
      score     = round(coef(mdl)[['year']] * 5, 2),
      dimension = 'trend')}) %>%
    select(region_id=rgn_id, dimension, score)
  # %>% semi_join(status, by='rgn_id')

  # assemble dimensions
  scores = rbind(status, trend) %>% mutate(goal='FIS')
  return(scores)
}


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
  # get reference quantile, searches for ref pt across all basins & all years less than or equal to status_years
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
  # Calculate the status for each year (year_value / ref_value) #all years less than or equal to status_years
  mar_status_score = temp2%>%
    filter(year<=max(status_years))%>%
    mutate(.,status =  pmin(1, mar_pop/ref_95pct)) %>%
    select(rgn_id, year, status)

  #give mar_status_score all BHI regions, regions with no data receive NA for last year
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(mar_status_score$year)))

  mar_status_score = mar_status_score%>%ungroup()%>%
    full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%
    arrange(rgn_id,year)

  # select last year of data in timeseries for status #last year based on max of status years specified
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


AO = function(layers,
              year_max,
              year_min=max(min(layers_data$year, na.rm=T), year_max - 10),
              Sustainability=1.0){

  ## based off of the HELCOM coastal fish indicator
  ## ohi-Fiji used this approach, although they calculated the fish indicator within functions.r. (but conceptually is the same)
  ## http://www.sciencedirect.com/science/article/pii/S2212041614001363
  ## github.com/OHI-Science/ohi-fiji/blob/master/fiji2013/conf/functions.R


  # cast data
  layers_data = SelectLayersData(layers, targets='AO')

  ry = rename(dcast(layers_data, id_num + year ~ layer, value.var='val_num',
                    subset = .(layer %in% c('ao_need'))),
              c('id_num'='region_id', 'ao_need'='need')); head(ry); summary(ry)

  r = na.omit(rename(dcast(layers_data, id_num ~ layer, value.var='val_num',
                           subset = .(layer %in% c('ao_access'))),
                     c('id_num'='region_id', 'ao_access'='access'))); head(r); summary(r)

  ry = merge(ry, r); head(r); summary(r); dim(r)

  # model
  ry = within(ry,{
    Du = (1.0 - need) * (1.0 - access)
    statusData = ((1.0 - Du) * Sustainability)
  })

  # status
  r.status <- ry %>%
    filter(year==year_max) %>%
    select(region_id, statusData) %>%
    mutate(status=statusData*100)
summary(r.status); dim(r.status)

  # trend
  r.trend = ddply(subset(ry, year >= year_min), .(region_id), function(x)
    {
      if (length(na.omit(x$statusData))>1) {
        # use only last valid 5 years worth of status data since year_min
        d = data.frame(statusData=x$statusData, year=x$year)[tail(which(!is.na(x$statusData)), 5),]
        trend = coef(lm(statusData ~ year, d))[['year']]*5
      } else {
        trend = NA
      }
      return(data.frame(trend=trend))
    })

  # return scores
  scores = r.status %>%
    select(region_id, score=status) %>%
    mutate(dimension='status') %>%
    rbind(
      r.trend %>%
        select(region_id, score=trend) %>%
        mutate(dimension='trend')) %>%
    mutate(goal='AO') # dlply(scores, .(dimension), summary)
  return(scores)
}

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
    group_by(rgn_id)%>%
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
    mutate(goal='ECO')

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
    mutate(goal = 'ECO')

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
  ## UPDATED 2016-02-15, Lena
  ## TODO ##
  # make new ref point csv file with correct header.
  # add contaminants, trash and secchi depth as subgoals and then calculate CW scores as arithmetric mean of those scores.
  ##

  ## Trash ideas
  ## Use Jambeck et al 2015: http://science.sciencemag.org/content/347/6223/768.full
  ## baltic2015/prep/CW/trash_prep.r

  min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
  regr_length = 10       # number of years to use for regression
  future_year = 5        # the year at which we want the likely future status
  min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!
  n_rgns = 42            # Number of regions used

 s = layers$data[['cw_nu_values']]
 r = layers$data[['cw_nu_secchi_targets']]

# normalize data #
status_score =
  full_join(s, r, by = 'rgn_id') %>%
  mutate(., status =  pmin(1, values/ref_point)) %>%
  select(rgn_id, year, status)

# select last year of data in timeseries for status
status = status_score %>%
  group_by(rgn_id) %>%
  summarise_each(funs(last), rgn_id, status) %>%  #UPDATE set summarise to give status for a set year instead of last in timeseries
  mutate(status = pmin(100, status*100))

# calculate trend based on status timeseries
trend =
  status_score %>%
  group_by(rgn_id) %>%
  do(tail(. , n = regr_length)) %>%
  # calculate trend only if there is at least X years of data (min_regr_length) in the last Y years of time serie (regr_length)
  do({if(sum(!is.na(.$status)) >= min_regr_length)
    data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year)))
    # data.frame(slope = coef(lm(status ~ year, .))['year'])
    else data.frame(trend_score = NA)}) #%>%
  # mutate(trend_score = pmin(100, trend_score*100))

# join status and trend to one dataframe
r = full_join(status, trend, by = 'rgn_id') %>%
  dplyr::rename(region_id = rgn_id)

  # return scores
  scores = rbind(
    within(r, {
      goal      = 'CW'
      dimension = 'status'
      score     = status}),
    within(r, {
      goal      = 'CW'
      dimension = 'trend'
      score     = trend_score}))[,c('region_id','goal','dimension','score')]
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

  # scores
  scores = cbind(rename(SelectLayersData(layers, layers=c('spp_status'='status','spp_trend'='trend'), narrow=T),
                      c(id_num='region_id', layer='dimension', val_num='score')),
               data.frame('goal'='SPP'))
  scores = mutate(scores, score=ifelse(dimension=='status', score*100, score))
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
