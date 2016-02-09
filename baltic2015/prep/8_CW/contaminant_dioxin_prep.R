##Data prep -- CW --Contaminants -- Dioxins

library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
library(colorRamps)

#get GDP data from database
library(RMySQL)

#run your personal mysql config script to read in passcode

#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch GPD data from database
t<-dbSendQuery(con, paste("select * from filtered_merged_dioxins_ID_assigned;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data) #GPD data
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)


#all dioxin data
data
glimpse(data)

#make Date column a date type
data$Date = as.Date(data$Date, "%d/%m/%y")

#plot each station as separate plot, color by variable
windows(50,30)
ggplot(data, aes(Year, Value, colour=Variable)) +
  geom_point(aes(group =Variable)) + facet_wrap(~Station,scales = "free")+
  xlim(c(1990,2013))
  #very different data coverage by station over time

#plot each variable as separate plot, color by station
windows(50,30)
ggplot(data, aes(Year, Value, colour=Station)) +
  geom_point(aes(group =Station)) + facet_wrap(~Variable,scales = "free")+
  xlim(c(1990,2013))
  #value magnitude differs among variables and among locations

#plot data by BHI_ID (many are not assingned)
windows(50,30)
ggplot(data, aes(Year, Value, colour=Variable)) +
  geom_point(aes(group =Variable)) + facet_wrap(~BHI_ID,scales = "free")+
  xlim(c(1990,2013))
  #9 BHI_ID with data, plus 1 plot of all unassigned
  #all BHI_ID with data are from Sweden
  #so are data not assigned


