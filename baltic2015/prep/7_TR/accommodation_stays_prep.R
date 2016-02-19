##Data prep -- TR -- Accommodation Stays

##Goal of data prep file
#have data on Total nights in accommodations by NUTS2 regions
#have percent coastal stays by NUTS1 regions
#get this percentage (averaged from 2012-2014) and apply to the NUTS2 data #have not done
# Divide this by the coastal area of the NUTS2 region (km2 with 5km buffer inland ?), call this NAC  #have not done
#create Accom value (BHI_ID_value) for each region (r). contributions from NUTS2_ID (n)
##BHI_ID_value_r   =sum [ NAC_n * CoastalArea_n / CoastalPopDen_n] #have not done

library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
library(colorRamps)

#get GDP data from database
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

dbDisconnect(con) # closes connection (IMPORTANT!)


#all data

glimpse(accom.data)

glimpse(accom.coast.data)

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


#Select BHI_ID Factors and NUTS3_ID, long data format, if factor is NA exlude because not BHI_ID & NUTS3 not associated
bhi.factor=accom.data %>%select(GEO,starts_with("BHI"))%>%
  select(-BHI_relevant)%>%
  gather(BHI_ID,FACTOR_NUTS2,-GEO)%>%
  filter(!is.na(FACTOR_NUTS2))%>%
  arrange(GEO,BHI_ID)
glimpse(bhi.factor)

colnames(bhi.factor)[1]="NUTS2_ID"

#join data.nuts3, bhi.factor to calculate GDP value per BHI_ID
bhi.accom.join = full_join(accom.data.bhi, bhi.factor, by="NUTS2_ID")
glimpse(bhi.accom.join)


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
ggplot(bhi.accom.join )+geom_point(aes(YEAR,TotalNights, color=NUTS2_ID)) +
  facet_wrap(~BHI_ID,scales = "free")


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
####Apply the average percent coastal to all the NUTS2_ID data

glimpse(bhi.accom.join)
accom.coast.bhi


total.night.coast =left_join(bhi.accom.join, accom.coast.bhi, by="NUTS2_ID" )%>% #join the bhi.accom.join to accom.coast.bhi
  mutate(TotalNightsCoast = TotalNights*PERCENT_CST_MEAN) #Calculate the coastal percentage of total Nights

windows(50,30)
ggplot(total.night.coast)+geom_point(aes(YEAR,TotalNightsCoast,color=NUTS2_ID)) +
  facet_wrap(~BHI_ID, scales="free")


#####Divide by NUTS2_ID coastal area (calculating NAC from equation at top of script)


####Calculate BHI region value



#save as
#tr_accom.csv



#################################
#Prep and test TR function for Functions.r

TR = function(layers, year_max){


  # SETTING CONSTANTS
  min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
  regr_length = 10       # number of years to use for regression
  future_year = 5        # the year at which we want the likely future status
  min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!



  #CoastalAccommodationNights data
  # gdp, wages, jobs and workforce_size data
  tr_accom  =  layers$data[['tr_accom']]

#this is Lena's CW code
#adapt to TR

  #calculate status
  #Ref level is value five years previous for each region

  # normalize data #

#   #this is CW
#   status_score =
#     full_join(s, r, by = 'rgn_id') %>%
#     mutate(., status =  pmin(1, values/ref_point)) %>%
#     select(rgn_id, year, status)
#
#
#   # select last year of data in timeseries for status
#   status = status_score %>%
#     group_by(rgn_id) %>%
#     summarise_each(funs(last), rgn_id, status) %>%  #UPDATE set summarise to give status for a set year instead of last in timeseries
#     mutate(status = pmin(100, status*100))
#   # calculate trend based on status timeseries
#   trend =
#     status_score %>%
#     group_by(rgn_id) %>%
#     do(tail(. , n = regr_length)) %>%
#     # calculate trend only if there is at least X years of data (min_regr_length) in the last Y years of time serie (regr_length)
#     do({if(sum(!is.na(.$status)) >= min_regr_length)
#       data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year)))
#       # data.frame(slope = coef(lm(status ~ year, .))['year'])
#       else data.frame(trend_score = NA)}) #%>%
#   # mutate(trend_score = pmin(100, trend_score*100))
#
#   # join status and trend to one dataframe
#   r = full_join(status, trend, by = 'rgn_id') %>%
#     dplyr::rename(region_id = rgn_id)
#
#   # return scores
#   scores = rbind(
#     within(r, {
#       goal      = 'CW'
#       dimension = 'status'
#       score     = status}),
#     within(r, {
#       goal      = 'CW'
#       dimension = 'trend'
#       score     = trend_score}))[,c('region_id','goal','dimension','score')]
#   return(scores)
# }




