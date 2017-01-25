##########
#fetch BHI-NUTS3 attributes
#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

t<-dbSendQuery(con, paste("select * from AT_COAST_NUTS3_BHI_inland_25km_AT ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
nuts3_bhi_area<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(nuts3_bhi_area) #
dbClearResult(t) # clears selection (IMPORTANT!)


#clean up nuts3_bhi_area
#NUTS_Area [km2] = total NUTS area
#`25km buffer of NUTS_Area [km2]` =  size of the part of the NUTS area inside the respective 25km inland buffer of BHI region
#Buffer fraction of NUTS area: 25km NUTS area divided by total NUTS area

#to get the total area for each NUTS in the buffer (across all BHI_ID), need to sum `25km buffer of NUTS_Area [km2]


#keep NUTS_AREA & Buffer fraction so can get area of NUTS inside the buffer
nuts3_bhi_area2 = nuts3_bhi_area%>% select(NUTS_ID,`NUTS_Area [km2]`,`Buffer fraction of NUTS area`, `25km buffer of NUTS_Area [km2]`,BHI_ID)%>%
  rename(nuts3_ID = NUTS_ID, NUTS_Area_km2 = `NUTS_Area [km2]`,
         NUTS_BHI_Area_km2 = `25km buffer of NUTS_Area [km2]`,
         NUTS_area_buffer_percent =`Buffer fraction of NUTS area`)%>% #rename columns
        mutate(NUTS_Area_km2= as.numeric(NUTS_Area_km2), NUTS_BHI_Area_km2=as.numeric(NUTS_BHI_Area_km2),
         NUTS_area_buffer_percent=as.numeric(NUTS_area_buffer_percent), BHI_ID=as.numeric(BHI_ID) )%>% #make numeric not character
         group_by(nuts3_ID) %>%
         mutate(nuts3_Area_25km2_buffer= sum(NUTS_BHI_Area_km2)) %>% #sum area for each NUTS_ID in each BHI buffer to get the total buffer area
  ungroup()

glimpse(nuts3_bhi_area2)



