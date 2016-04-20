## nutrient_load_prep_database_call.r

## This file calls the data from the database and saves as a cvs in nutrient_data_database

##Source and create directories
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_pressures    = file.path(dir_prep, 'pressures')
dir_nutprep   = file.path(dir_prep, 'pressures/nutrient_load')

## 1. access the database with MySQL()


## 2. extract data
#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_0",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch data from database,
##Nload
t<-dbSendQuery(con, paste("select * from N_basin_load;",sep=""))
data1<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data1) #data
dbClearResult(t) # clears selection (IMPORTANT!)

##P load
t<-dbSendQuery(con, paste("select * from P_basin_load ;",sep=""))
data2<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data2) #data
dbClearResult(t) # clears selection (IMPORTANT!)

##Load targets
t<-dbSendQuery(con, paste("select * from N_P_load_targets;",sep=""))
data3<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data3) #data
dbClearResult(t) # clears selection (IMPORTANT!)


dbDisconnect(con) # closes connection (IMPORTANT!)


##Write to csv
## Save as csv file to
write.csv(data1, file.path(dir_nutprep , 'nutrient_data_database/N_basin_load.csv'),row.names=FALSE)
write.csv(data2, file.path(dir_nutprep , 'nutrient_data_database/P_basin_load.csv'),row.names=FALSE)
write.csv(data3, file.path(dir_nutprep , 'nutrient_data_database/N_P_load_targets.csv'),row.names=FALSE)
