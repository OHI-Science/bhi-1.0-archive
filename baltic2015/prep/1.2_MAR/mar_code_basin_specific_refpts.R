#this starts from "updated_MARgoal_code" line 96

####Basin Specific Ref pt (Eutrop basins v BothSea/Bay (nonEutroph))
temp3 = temp2%>%full_join(.,mar_basin_id,by="rgn_id") #now regions associated with basins

#get basin specific reference pt
ref_95pct_basin=temp3%>%ungroup()%>%
  group_by(basin_id)%>% select(rgn_id,year,mar_pop)%>%
  filter(year<=max(status_years))%>%
  summarise(ref_95pct=quantile(mar_pop,probs=0.95, na.rm=TRUE))

#find ID associated with the ref_95pct
ref_id_basin = temp3%>%ungroup()%>%
  group_by(basin_id)%>%
  filter(year<=max(status_years))%>%
  full_join(.,ref_95pct_basin, by="basin_id")%>%
  arrange(mar_pop) %>%
  filter(mar_pop >= ref_95pct)
cat(sprintf('95th percentile rgn_id for MAR ref pt Basin 1 is: %s\n', (ref_id_basin%>%ungroup()%>%filter(basin_id==1)%>%select(rgn_id)%>%summarise(first(rgn_id)))))
cat(sprintf('95th percentile rgn_id for MAR ref pt Basin 2 is: %s\n', (ref_id_basin%>%ungroup()%>%filter(basin_id==2)%>%select(rgn_id)%>%summarise(first(rgn_id)))))


# normalize data to reference value by basin
mar_status_score = temp3%>%ungroup()%>%
  filter(year<=max(status_years))%>%
  full_join(.,ref_95pct_basin, by="basin_id")%>%
  mutate(.,status =  pmin(1, mar_pop/ref_95pct)) %>%
  select(rgn_id, year, status)

#give mar_status_score all BHI regions, regions with no data receive NA for last year
bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(mar_status_score$year)))

mar_status_score = mar_status_score%>%ungroup()%>%
  full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%
  arrange(rgn_id,year)


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

