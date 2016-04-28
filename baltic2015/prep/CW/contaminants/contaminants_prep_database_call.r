##-------------------------------------------##
## FILE: contaminants_prep_database_call.r
##-------------------------------------------##

##-------------------------------------------##
## READ ME:
## This file calls the data from the database and saves as a cvs in contaminants_data_database
## This file should be run prior to contaminants_prep.Rmd if data are updated in the database

##-------------------------------------------##
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')


##-------------------------------------------##
## Extract ICES pcb herring data from database

##-------------------------------------------##
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from ices_herring_pcb_cleaned_ID_assigned;")
data1 <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)

dbDisconnect(con) # closes connection (IMPORTANT!)

head(data1)

## Save as csv file to
write_csv(data1, file.path(dir_con, 'contaminants_data_database/ices_herring_pcb.csv'))


