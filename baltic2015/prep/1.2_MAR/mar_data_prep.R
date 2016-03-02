##MAR data prep

#libraries
library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
library(colorRamps)
library(RMySQL)


##Production Data
##Data collected by Ginnette
##Data currently for SE,FI, DK
##read data directly in from csv until put in the database, then need to update
##need to update when Ginnette provides the regional data source in the file
##export csv files to layers folder

##Population data
## data from 25km buffer from database
##also need to extract and export as csv to layers folder

####---------------------------------######
##Production Data
#read in data
mar_dat = read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Mariculture/mar_rainbow_production_data.csv",
                   header=TRUE, sep=";")
mar_dat

glimpse(mar_dat)

#SpeciesCode_CountrySpecific - because data from country databases, Rainbow Trout spp code differs by country
#ISSCAAP_FAO, TAXOCODE_FAO,3A_CODE_FAO are the FAO codes associated with the species http://www.fao.org/fishery/collection/asfis/en

#plot data
windows(50,30)
ggplot(mar_dat)+geom_point(aes(Year,Production, colour=factor(SpeciesCode_CountrySpecific))) +
  facet_wrap(~BHI_ID,scales = "free")

#some BHI_ID regions have contribution from more than one land based area
##some multiple time series from all years, some from just some years


#sum all production with each BHI region by year
mar_tot = mar_dat%>% group_by(BHI_ID,Year, ISSCAAP_FAO, Unit,Sust_coeff_SE)%>%
  summarise(TotProduction = sum(Production))%>%
  arrange(BHI_ID,Year)%>%
  print(n=50)

windows(50,30)
ggplot(mar_tot)+geom_point(aes(factor(Year),TotProduction),size=2) +
  facet_wrap(~BHI_ID, scale="free_y")


#######
#prepare data for MAR code
#Export to layers folder
mar_harvest_tonnes_bhi2015 = mar_tot%>%ungroup()%>%
  select(BHI_ID,ISSCAAP_FAO, Year,TotProduction)
colnames(mar_harvest_tonnes_bhi2015)=c("rgn_id","species_code","year","tonnes")
head(mar_harvest_tonnes_bhi2015)
write.csv(mar_harvest_tonnes_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_harvest_tonnes_bhi2015.csv",row.names=FALSE)

#create species code for csv
#"species_code","species"
mar_harvest_species_bhi2015 = mar_dat%>%select(ISSCAAP_FAO,CommonName)%>%
  distinct(ISSCAAP_FAO,CommonName)
colnames(mar_harvest_species_bhi2015)=c("species_code","species")

write.csv(mar_harvest_species_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_harvest_species_bhi2015.csv",row.names=FALSE)

#create the sustainability csv
#"rgn_id","species","sust_coeff"
mar_sustainability_score_bhi2015= mar_dat%>%select(BHI_ID,CommonName,Sust_coeff_SE)%>%
    distinct(BHI_ID,CommonName,Sust_coeff_SE)%>%
    arrange(BHI_ID)
colnames(mar_sustainability_score_bhi2015)=c("rgn_id","species","sust_coeff")
write.csv(mar_sustainability_score_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_sustainability_score_bhi2015.csv",row.names=FALSE)

#create a basin id file to do alternative reference pts
#only in prep folder, not implemented in the main function now
mar_basin_id=read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Mariculture/region_basin_to_change_ref_pts.csv", header=TRUE,sep=";")
mar_basin_id
#write.csv (mar_basin_id,"C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_basin_id_bhi2015.csv",row.names=FALSE)

#trend files not used, now set in code


####---------------------------------######
#Population data
#here consider using population data from the 25km buffer for year 2005
#read in BHI population data from the 25km inland buffer
#data source http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html
#

#run your personal mysql config script to read in passcode

#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch GPD data from database, use BHI_relevant = 'NUTS3' should draw only NUTS3 data with is associated with a BHI region (database also contains some NUTS2)
t<-dbSendQuery(con, paste("select * from AT_Pop_Density_BHI_inland_25km ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data) #GPD data
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

bhi_pop = data%>%select(BHI_ID, `Total Population in 25km Buffer`)%>%
    rename(., rgn_id=BHI_ID, popsum=`Total Population in 25km Buffer`)
bhi_pop

#write to layers folder to use in the function
write.csv (bhi_pop,"C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_coastalpopn2005_inland25km_bhi2015.csv",row.names=FALSE)



#plot and compare to global data source
#global data
popn_inland25mi = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/layers/mar_coastalpopn_inland25km_sc2014-raster.csv",
header=TRUE) #population per region

bhi_pop2= bhi_pop%>%rename(popsum2005=popsum)

#merge data
popcompare = full_join(popn_inland25mi, bhi_pop2, by="rgn_id")
windows()
ggplot(popcompare)+geom_point(aes(factor(year),popsum, color="red")) +
  geom_point(aes(factor(year),popsum2005))+
  facet_wrap(~rgn_id, scales="free")

##the data from the global file look really weird! better to use the value from the 2005 year from Erik's raster


