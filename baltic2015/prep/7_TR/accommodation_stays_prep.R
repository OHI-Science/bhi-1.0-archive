##Data prep -- TR -- Accommodation Stays

##Goal of data prep file
#have data on Total nights in accommodations by NUTS2 regions
#have percent coastal stays by NUTS1 regions
#get this percentage (averaged from 2012-2014)
#apply coastal percentage to the NUTS2 data #have not done
#For 3 danish regions (DK03,04,05) and one swedish region (SE22)- multiply the Total_nights_coastal*0.5 because have 2 coasts (baltic, non-baltic)
# Divide this by the coastal area of the NUTS2 region (km2 with 5km buffer inland ?), call this NAC  #have not done
#create Accom value (BHI_ID_value) for each region (r). contributions from NUTS2_ID (n)
##BHI_ID_value_r   =sum [ NAC_n * CoastalArea_n / CoastalPopDen_n] #have not done

library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
theme_set(theme_bw())
library(colorRamps)

#get accom data from database
library(RMySQL)


#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch accommodation stays data from database
t<-dbSendQuery(con, paste("select * from tour_occ_nin2_1_Data_ID_assigned;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
accom.data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(accom.data) #NUTS2 accommodation stays
dbClearResult(t) # clears selection (IMPORTANT!)

t<-dbSendQuery(con, paste("select * from tour_occ_nin2c_1_Data_ID_assigned;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
accom.coast.data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(accom.coast.data) #NUTS2 accommodation stays
dbClearResult(t) # clears selection (IMPORTANT!)

#fetch BHI-NUTS attributes
t<-dbSendQuery(con, paste("select * from AT_COAST_NUTS2_BHI_inland_25km_AT ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
nuts2_bhi_area<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(nuts2_bhi_area) #
dbClearResult(t) # clears selection (IMPORTANT!)

t<-dbSendQuery(con, paste("select * from AT_Pop_Density_BHI_inland_25km ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
popdensity2005_inland<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(popdensity2005_inland) #popdensity data
dbClearResult(t) # clears selection (IMPORTANT!)

dbDisconnect(con) # closes connection (IMPORTANT!)


#all data

glimpse(accom.data)

glimpse(accom.coast.data)

glimpse(nuts2_bhi_area)

glimpse(popdensity2005_inland)

#data type
unique(accom.data$INDIC_TO_LABEL)#"Nights spent, total"
unique(accom.data$NACE_R2_LABEL)#"Hotels; holiday and other short-stay accommodation; camping grounds, recreational vehicle parks and trailer parks"


###Clean accom.data###
#look at accommodation data which are BHI_relevant (e.g. NUTS2) - these data cover a large area and
#do not include only the coasts
accom.data.bhi = accom.data%>%filter(BHI_relevant=="NUTS2")%>% #only data associated with BHI_ID
  select(-starts_with("BHI")) %>%  #remove the BHI_IDs, deal with separately
  select(-TIME_LABEL,-GEO_LABEL, -INDIC_TO,-INDIC_TO_LABEL,-UNIT,-UNIT_LABEL,-NACE_R2, -NACE_R2_LABEL)

head(accom.data.bhi)
#change column names, replace colon with NA
colnames(accom.data.bhi)[1]="YEAR"
colnames(accom.data.bhi)[2]="NUTS2_ID"
colnames(accom.data.bhi)[3]="TotalNights"
accom.data.bhi[accom.data.bhi$TotalNights==":","TotalNights"]=NA
accom.data.bhi$TotalNights=as.numeric(accom.data.bhi$TotalNights)

glimpse(accom.data.bhi)
head(accom.data.bhi)

#order
accom.data.bhi=accom.data.bhi%>%arrange(NUTS2_ID,YEAR)


#Select BHI_ID Factors and NUTS2_ID, long data format, if factor is NA exlude because not BHI_ID & NUTS2 not associated
#because of map errors - some NUTS2_ID are erroneously associated with BHI_ID (e.g. region 27 has both LV00 and EE00, should only be LV00)
bhi.factor=accom.data %>%select(GEO,starts_with("BHI"))%>%
  select(-BHI_relevant)%>%
  gather(BHI_ID,FACTOR_NUTS2,-GEO)%>%
  filter(!is.na(FACTOR_NUTS2))%>%
  arrange(GEO,BHI_ID)
glimpse(bhi.factor)

colnames(bhi.factor)[1]="NUTS2_ID"

#not sure this is needed


##########
#clean up nuts2_bhi_area
#NUTS_Area [km2] = total NUTS area
#`25km buffer of NUTS_Area [km2]` =  size of the part of the NUTS area inside the respective 25km inland buffer of BHI region
#Buffer fraction of NUTS area: 25km NUTS area divided by total NUTS area

#to get the total area for each NUTS in the buffer (across all BHI_ID), need to sum `25km buffer of NUTS_Area [km2]


#keep NUTS_AREA & Buffer fraction so can get area of NUTS inside the buffer
nuts2_bhi_area2 = nuts2_bhi_area%>% select(NUTS_ID,`NUTS_Area [km2]`,`Buffer fraction of NUTS area`, `25km buffer of NUTS_Area [km2]`,BHI_ID)%>%
  rename(NUTS2_ID = NUTS_ID, NUTS_Area_km2 = `NUTS_Area [km2]`,
        NUTS_BHI_Area_km2 = `25km buffer of NUTS_Area [km2]`,
        NUTS_area_buffer_percent =`Buffer fraction of NUTS area`)%>%
      mutate(NUTS_Area_km2= as.numeric(NUTS_Area_km2), NUTS_BHI_Area_km2=as.numeric(NUTS_BHI_Area_km2),
             NUTS_area_buffer_percent=as.numeric(NUTS_area_buffer_percent) ) %>% #make numeric not character
            group_by(NUTS2_ID) %>%
          mutate(NUTS2_Area_25km2_buffer= sum(NUTS_BHI_Area_km2)) %>% #sum area for each NUTS_ID in each BHI buffer to get the total buffer area
            ungroup()

glimpse(nuts2_bhi_area2)

#check sum of area
nuts2_bhi_area2[nuts2_bhi_area2$NUTS2_ID=="SE22",]


#join accom.data.bhi with nuts2_bhi_area
#now NUTS2 accommodation data are associated with a BHI region and the area of the NUTS2 region associated with the BHI region
bhi.accom.join= left_join(accom.data.bhi,nuts2_bhi_area2, by="NUTS2_ID") #only keep BHI_IDs with regions that have data
glimpse(bhi.accom.join)

#join accom.data.bhi, bhi.factor to calculate GDP value per BHI_ID
#bhi.accom.join = full_join(accom.data.bhi, bhi.factor, by="NUTS2_ID")
#glimpse(bhi.accom.join)



#Plotting accommodation stays from the accomm.data (this does not separate coastal v. non-coastal)
#unique NUTS2_ID
unique(accom.data.bhi$NUTS2_ID)
#[1] "DK01" "DK02" "DK03" "DK04" "DK05" "DE80" "DEF0" "EE00" "LV00" "LT00" "PL42" "PL62" "PL63" "FI19" "FI20" "SE11" "SE12" "SE21" "SE22"
#[20] "SE23" "SE31" "SE32" "SE33

#plot number accommadations stays - each NUTS2 region
windows(50,30)
ggplot(accom.data.bhi)+geom_point(aes(YEAR,TotalNights)) +
  facet_wrap(~NUTS2_ID,scales = "free")


#plot each BHI region with applicable accomm stays
windows(50,30)
ggplot(bhi.accom.join )+geom_point(aes(YEAR,TotalNights, color=factor(NUTS2_ID))) +
  facet_wrap(~BHI_ID)

#plot by BHI region but divide by area associated with BHI region
windows(50,30)
ggplot(bhi.accom.join )+geom_point(aes(YEAR,(TotalNights/NUTS_BHI_Area_km2), color=factor(NUTS2_ID))) +
  facet_wrap(~BHI_ID, scales="free_y")

##########
###Clean accom.coast.data###

#are there coast data that are allocated to NUTS2 for BHI_relevant regions
#accom.coast.bhi = accom.coast.data%>%filter(BHI_relevant=="NUTS2")%>% #only data associated with BHI_ID
#  select(-starts_with("BHI"))%>%  #remove the BHI_IDs, deal with separately
#  select(-TERRTYPO,-GEO_LABEL, -INDIC_TO,-INDIC_TO_LABEL,-UNIT,-UNIT_LABEL,-NACE_R2, -NACE_R2_LABEL,-TIME_LABEL)#reduce number of columns
#accom.coast.bhi
##There is no NUTS2 data with Coastal info - must be at a higher spatial resolution


#Figure out what NUTS1 level each NUTS2 level is associated with - data only given at NUTS1 level
NUTS.levels =  accom.coast.data%>%filter(BHI_relevant=="NUTS2")%>% #only data associated with BHI_ID
  select(-starts_with("BHI"))%>%  #remove the BHI_IDs, deal with separately
  select(-TERRTYPO,-GEO_LABEL, -INDIC_TO,-INDIC_TO_LABEL,-UNIT,
         -UNIT_LABEL,-NACE_R2, -NACE_R2_LABEL,-TIME_LABEL) #reduce number of columns

colnames(NUTS.levels)[2]="NUTS2_ID" #rename column 1


NUTS.levels = NUTS.levels%>% mutate(NUTS1_ID = substr(NUTS2_ID,1,3))%>% #create NUTS1_ID, should be equal to the first 3 characters in NUTS2_ID
  select(-TERRTYPO_LABEL,-TIME,-Value,-Flag.and.Footnotes)%>% #get rid of extra columns
  distinct(NUTS1_ID,NUTS2_ID)
head(NUTS.levels)


#get coast-no coast accomm data associated with the NUTS1_IDs that are BHI relevant
#will apply the % coastal from NUTS1 regions to the NUTS2 data
accom.coast.data$Value = as.numeric(accom.coast.data$Value) #make Value numeric

accom.coast.bhi = left_join(NUTS.levels,
                            select(accom.coast.data,TERRTYPO,GEO,TIME,Value,Flag.and.Footnotes),
                            by=c("NUTS1_ID"="GEO")) %>%  #select the data from NUTS1
  group_by(NUTS2_ID,NUTS1_ID,TIME,Flag.and.Footnotes)%>%
  spread(TERRTYPO,Value)%>%
  summarise(PERCENT_CST=CST_A/TOTAL) #checked calculation by using mutate first
head(accom.coast.bhi)
glimpse(accom.coast.bhi)
print(accom.coast.bhi,n=300)

#check Flag.and.Footnotes - 'b' just stands for break in time series
accom.coast.bhi = select(accom.coast.bhi, -Flag.and.Footnotes)

#plot - check variation in percent coastal among years for NUTS1_ID regions
windows(50,30)
ggplot(accom.coast.bhi )+geom_point(aes(TIME,PERCENT_CST), size=3) +
  facet_wrap(~NUTS1_ID)+ ylim(0,1)+ xlim(2011.5,2014.5)
#very consistent - all have 2 or 3 years of data

#get single value across all years
accom.coast.bhi =accom.coast.bhi %>%
  group_by(NUTS2_ID,NUTS1_ID)%>%
  summarise(PERCENT_CST_MEAN = mean(PERCENT_CST, na.rm=TRUE))

accom.coast.bhi  #this can be used to convert NUTS2 data into the fraction that is Coastal



#################################
glimpse(bhi.accom.join)
accom.coast.bhi

####Apply the average percent coastal to all the NUTS2_ID data
total.night.coast =left_join(bhi.accom.join, accom.coast.bhi, by="NUTS2_ID" )%>% #join the bhi.accom.join to accom.coast.bhi
  mutate(TotalNightsCoast = TotalNights*PERCENT_CST_MEAN) #Calculate the coastal percentage of total Nights

windows(50,30)
ggplot(total.night.coast)+geom_point(aes(YEAR,TotalNightsCoast,color=NUTS2_ID)) +
  facet_wrap(~BHI_ID, scales="free")


#cut coastal stays by 50% for DK & SE regions with nonBaltic coasts included
#calculate the per km2 stays by NUTS region
#calculte the allocation to each BHI region
#the BHI regions have a few NUTS regions incorrectly assigned (need to correct but better to do by fixing map & NUTS allocation)

bhi.accom.join_adj = total.night.coast%>%
  mutate(TotalNightsCoastAdj =ifelse(grepl("DK03|DK04|DK05|SE23",NUTS2_ID), TotalNightsCoast*0.5,TotalNightsCoast))%>%

  #####For DK and SE (southwest) -- Need to reduce the # of stays because covering non-Baltic & Baltic Coasts?  Take 50%?
  ##DK03, DK04, and DK05 have both baltic and non-Baltic coast ##SE23 has Baltic and non-Baltic coast
  ##did this above

  mutate(TotNiCoaAdj_km2 = TotalNightsCoastAdj/(NUTS2_Area_25km2_buffer))%>%  #gives stays /km2 in the NUTS2 buffer region  #this is Nac at top of script

  mutate(BHI_stays =TotNiCoaAdj_km2*NUTS_BHI_Area_km2  ) #this is stays per Nuts km2 in the BHI_region

glimpse(bhi.accom.join_adj)

bhi_coast_accom_total=  bhi.accom.join_adj%>%
  select(BHI_ID, YEAR, BHI_stays)%>% #select only the relevant final columns
  group_by(BHI_ID,YEAR)%>% #group by year and BHI_ID
  summarise(BHI_stays_total = sum(BHI_stays)) #sum all stays with in BHI_ID region by year (across all NUTS2_ID)

glimpse(bhi_coast_accom_total)
tail(bhi_coast_accom_total)

windows(50,30)
ggplot(bhi_coast_accom_total)+geom_point(aes(YEAR,BHI_stays_total)) +
  facet_wrap(~BHI_ID, scales="free")

###THESE DATA ARE NOT ADJUSTED BY POP DENSITY - NEED TO DO THIS?


#column labels need to be:  rgn_id, year, value
tr_accom = bhi_coast_accom_total
colnames(tr_accom)=c("rgn_id","year","value")

#save as CSV
#



#################################
##Prep and test TR function for Functions.r
#based on ECO functions and Lena CW code

##QUESTIONS about function developed below that are not solved
#What time frame should be used?  If want to do trend on longer ts, also need status for longer ts
#If use a temporal ref pt (by region) what should it be?  If use t-5 value, then can't use a longer ts for status/trend
#Does it make sense to have a temporal ref pt? will this result in a 100 score and no trend?


#temp file for testing code
tr_accom = as.data.frame(matrix(NA,24,3))
tr_accom[,1]= rep(seq(1,4,1),6)
tr_accom[,2]= rep(seq(2010,2015,1),each=4)
tr_accom[,3]= unique(total.night.coast$TotalNightsCoast)[2:25]
colnames(tr_accom)=c("rgn_id","year","value")

TR = function(layers){

  #CoastalAccommodationNights data
  tr_accom  =  layers$data[['tr_accom']]

  # SETTING CONSTANTS
  #min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
  regr_length = 5       # number of years to use for regression
  future_year = 5        # the year at which we want the likely future status
  min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!
  ref_year = 4            #using a temporal reference point, use five year previous as a reference value
  #status_year = 2014    #select status of a particular year rather than arbitrary last year for each region

  #calculate status score for all years from annual values (this is based on the ECO function)

  tr_status_score = tr_accom %>%
    filter(!is.na(value)) %>%
    filter(year >= max(year, na.rm=FALSE) - ref_year) %>% # reference point is 5 years ago
    arrange(rgn_id, year) %>%
    group_by(rgn_id) %>%
    mutate(
      ref_year_value  = first(value)) %>%  #this selects the reference year value
    ungroup() %>%
    mutate(
      status  = pmin(value / ref_year_value, 1)) #calculate status

 # select last year of data in timeseries for status
  tr_status = tr_status_score %>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id, status) %>%  #this will be all same year because of code above selecting the max year
    mutate(status = pmin(100, status*100))
#
  # calculate trend based on status timeseries
  tr_trend =
     tr_status_score %>%
     group_by(rgn_id) %>%
      do(tail(. , n = regr_length)) %>% # calculate trend only if there is at least X years of data (min_regr_length) in the last Y years of time serie (regr_length)
      #for TR because have a temporal ref. point - this is a bit more difficult to implement than in CW
      #have to know ref year is included in the data
    do({if(sum(!is.na(.$status)) >= min_regr_length)
       data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year)))
          #data.frame(slope = coef(lm(status ~ year, .))['year'])
       else data.frame(trend_score = NA)})# %>%
    #mutate(trend_score = pmin(100, trend_score*100))

   # join status and trend to one dataframe
     r = full_join(tr_status, tr_trend, by = 'rgn_id') %>%
     dplyr::rename(region_id = rgn_id)

#   # return scores
  scores = rbind(
    within(r, {
      goal      = 'TR'
      dimension = 'status'
      score     = status}),
    within(r, {
      goal      = 'CW'
      dimension = 'trend'
      score     = trend_score}))[,c('region_id','goal','dimension','score')]
  return(scores)
}




