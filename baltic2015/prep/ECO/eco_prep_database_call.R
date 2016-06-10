## eco_prep_database_call.r

## This file calls the data from the database and saves as a cvs in eco_data_database

## This file should be run prior to eco_prep.Rmd if data are updated in the database


##----------------------------------------------------#

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories

dir_eco    = file.path(dir_prep, 'ECO')


## UPDATE when data updated in database



#
# #get GDP data from database
# library(RMySQL)
#
# #run your personal mysql config script to read in passcode
#
# #connect to the BHI database
# con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
# dbListTables(con) # shows all tables in the DB
#
# #fetch GPD data from database, use BHI_relevant = 'NUTS3' should draw only NUTS3 data with is associated with a BHI region (database also contains some NUTS2)
# t<-dbSendQuery(con, paste("select * from nama_10r_3gdp_ID_assigned where BHI_relevant = 'NUTS3';",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
# data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
# head(data) #GPD data
# dbClearResult(t) # clears selection (IMPORTANT!)
# dbDisconnect(con) # closes connection (IMPORTANT!)
#
# #data object overview and clean-up
# glimpse(data)
