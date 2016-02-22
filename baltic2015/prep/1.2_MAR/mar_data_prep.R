##MAR data prep

#libraries
library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
library(colorRamps)

##Data collected by Ginnette
##Data currently for SE,FI, DK
##read data directly in from csv until put in the database, then need to update
##need to update when Ginnette provides the regional data source in the file


#read in data
mar_dat = read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Mariculture/RainbowTroutProductionSE_FI_DK.csv",
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
#prepare data for MAR code  #export only to prep folder first
mar_harvest_tonnes_bhi2015 = mar_tot%>%ungroup()%>%
  select(BHI_ID,ISSCAAP_FAO, Year,TotProduction)
colnames(mar_harvest_tonnes_bhi2015)=c("rgn_id","species_code","year","tonnes")
head(mar_harvest_tonnes_bhi2015)
#write.csv(mar_harvest_tonnes_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_tonnes_bhi2015.csv",row.names=FALSE)

#create species code for csv
#"species_code","species"
mar_harvest_species_bhi2015 = mar_dat%>%select(ISSCAAP_FAO,CommonName)%>%
  distinct(ISSCAAP_FAO,CommonName)
colnames(mar_harvest_species_bhi2015)=c("species_code","species")
#write to csv in the prep folder
#write.csv(mar_harvest_species_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_harvest_species_bhi2015.csv",row.names=FALSE)

#create the sustainability csv
#"rgn_id","species","sust_coeff"
mar_sustainability_score_bhi2015= mar_dat%>%select(BHI_ID,CommonName,Sust_coeff_SE)%>%
    distinct(BHI_ID,CommonName,Sust_coeff_SE)
colnames(mar_sustainability_score_bhi2015)=c("rgn_id","species","sust_coeff")
#write.csv(mar_sustainability_score_bhi2015, "C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/1.2_MAR/mar_sustainability_score_bhi2015.csv",row.names=FALSE)

#use the pop and trend files from global assessment
