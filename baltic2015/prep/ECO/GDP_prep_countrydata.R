## Prep GDP country level data from Eurostat

#libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr) # install.packages("stringr")

## Eurostat data
## data read in from CSV currently
data = read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/ECO/gdp_country_eurostat.csv", header=TRUE,
                sep=";")
head(data)

#BHI ID and coutnry associations
bhi_country= read.csv("C:/Users/jgrif/Documents/github/bhi/baltic2015/prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv",
                      header=TRUE)

head(bhi_country)
bhi_country = bhi_country %>% select(rgn_id,cntry_name)%>%
              mutate(country_abb = ifelse(cntry_name=="Sweden","SE",
                                          ifelse(cntry_name=="Denmark","DK",
                                          ifelse(cntry_name=="Germany","DE",
                                          ifelse(cntry_name=="Poland","PL",
                                          ifelse(cntry_name== "Russia","RU",
                                          ifelse(cntry_name=="Lithuania","LT",
                                          ifelse(cntry_name=="Latvia", "LV",
                                          ifelse(cntry_name=="Estonia", "EE",
                                          ifelse(cntry_name=="Finland","FI",NA))))))))))


##----------------##
##Clean Eurostat data
data2 = data %>% select(TIME, GEO, GEO_LABEL, UNIT,Value, Flag.and.Footnotes)%>%
  dplyr::rename(year = TIME, country_abb = GEO, country=GEO_LABEL, unit = UNIT, gdp= Value) %>%
  filter(unit=="Current prices, million euro") %>% #filter only current prices
  filter(year >= 2000)%>% #work with only data from 2000 to present
  select(-unit)%>% #do not need this column
  mutate(country_abb= as.character(country_abb))%>% #change from factor to character
  group_by(country_abb)%>%
  arrange(year)%>%
  ungroup()

tail(data2)

## Merge Eurostat data with country names and BHI Id
data3 = left_join(bhi_country,data2,by="country_abb")
head(data3)
tail(data3)

## Check Flag.and.Footnotes
data3%>%filter(Flag.and.Footnotes!="") #no data flagged


#clean data
names(data3)

data4 = data3%>% select(rgn_id,year,gdp)%>%
  dplyr::rename(gdp_mio_euro=gdp)

str(data4)

bhi.gdp.country=data4
#data plotted below

#save to csv in layers
write.csv(bhi.gdp.country, "~/github/bhi/baltic2015/layers/le_gdp_country_bhi2015.csv", row.names = FALSE)



#########################
ggplot(bhi.gdp.country) + geom_point(aes(year,gdp_mio_euro))+
  facet_wrap(~rgn_id)
