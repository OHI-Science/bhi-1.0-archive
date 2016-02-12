##Data prep -- TR -- Accommodation Stays

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

##########
###Clean accom.coast.data###

#are there coast data that are allocated to NUTS2 for BHI_relevant regions
accom.coast.bhi = accom.coast.data%>%filter(BHI_relevant=="NUTS2")%>% #only data associated with BHI_ID
  select(-starts_with("BHI"))%>%  #remove the BHI_IDs, deal with separately
  select(-TERRTYPO,-GEO_LABEL, -INDIC_TO,-INDIC_TO_LABEL,-UNIT,-UNIT_LABEL,-NACE_R2, -NACE_R2_LABEL,-TIME_LABEL)#reduce number of columns

accom.coast.bhi
#There is no NUTS2 data with Coastal info - must be at a higher spatial resolution


#work with all GEO units that have coastal and total info - get a percentage coastal see how it looks
accom.coast.data%>% select(-TERRTYPO,-GEO_LABEL, -INDIC_TO,-INDIC_TO_LABEL,-UNIT,-UNIT_LABEL,-NACE_R2, -NACE_R2_LABEL,-TIME_LABEL)%>%#reduce number of columns
  select(-starts_with("BHI"))%>% #remove BHI_ID, just look at the coastal data


#################################
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




