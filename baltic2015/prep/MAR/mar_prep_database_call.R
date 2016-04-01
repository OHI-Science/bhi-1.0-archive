## mar_prep_database_call.r

## This file calls the data from the database and saves as a cvs in mar_data_database

## This file should be run prior to mar_prep.Rmd if data are updated in the database


##----------------------------------------------------#

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_mar    = file.path(dir_prep, 'MAR')


## 1. access the database with MySQL()



## 2. extract data

## Mar production
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB
t<-dbSendQuery(con, paste("select * from mar_data_production_ID_assigned ;",sep=""))
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data)
mar_data_production= data
write.csv(mar_data_production, file.path(dir_mar, 'mar_data_database/mar_data_production.csv'))
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

## Mar lookup
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="metafiles",host=conf[,3], port=3306) # sets up the connection
t<-dbSendQuery(con, paste("select * from mar_data_lookuptable ;",sep=""))
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data)
mar_data_lookuptable= data
write.csv(mar_data_lookuptable, file.path(dir_mar, 'mar_data_database/mar_data_lookuptable.csv'))
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

## Population density
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB
t<-dbSendQuery(con, paste("select * from AT_Pop_Density_BHI_inland_25km ;",sep=""))
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data)
pop_density = data
write.csv(pop_density, file.path(dir_mar, 'mar_data_database/pop_density.csv'))
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)


