## eco_prep_database_call.r

## This file calls the data from the database and saves as a cvs in eco_data_database

## This file should be run prior to eco_prep.Rmd if data are updated in the database


##----------------------------------------------------#
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_eco    = file.path(dir_prep, 'ECO')
##----------------------------------------------------#




##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
    ## **update this date when code is run**
    ## 11 JULY 2016
##----------------------------------------------------#


##----------------------------------------------------#
## Get GDP data from database ##

## library(RMySQL) # required


## STEP 1:
      ##run your personal mysql config script to read in passcode


## STEP 2:
    ## Connect to the BHI database
      con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
      dbListTables(con) # shows all tables in the DB

      ##Fetch NUTS3 GDP data
      t<-dbSendQuery(con, paste("select * from nama_10r_3gdp_1_Data_download05_12_2016_joined;",sep=""))
      nuts3_gdp <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
      head(nuts3_gdp)
      tail(nuts3_gdp)
      dbClearResult(t) # clears selection (IMPORTANT!)


      ## Fetch NUTS0 (national) GDP data, EU countries
      t<-dbSendQuery(con, paste("select * from nama_10_gdp_1_Data;",sep=""))
      nuts0_gdp <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
      head(nuts0_gdp)
      tail(nuts0_gdp)
      dbClearResult(t) # clears selection (IMPORTANT!)


      ## Fetch Russian national GDP data
      t<-dbSendQuery(con, paste("select * from naida_10_gdp_1_Data_cleaned;",sep=""))
      ru_nat_gdp <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
      head(ru_nat_gdp)
      tail(ru_nat_gdp)
      dbClearResult(t) # clears selection (IMPORTANT!)

      ## Fetch Finnish population data from buffer
      t<-dbSendQuery(con, paste("select * from NUTS3_BHI_ID_Pop_density_in_buffer;",sep=""))
      fi_pop <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
      head(fi_pop)
      tail(fi_pop)

      ## select only 3 Finnish NUTS3
      fi_pop = fi_pop %>%
               filter(NUTS_ID %in% c("FI186","FI182","FI181", "FI1A3","FI1A2","FI1A1"))

      head(fi_pop)
      tail(fi_pop)


      dbClearResult(t) # clears selection (IMPORTANT!)



      ## CLOSE CONNECTION
      dbDisconnect(con) # closes connection (IMPORTANT!)

##----------------------------------------------------#



##----------------------------------------------------#
## Write data to csv ##
write.csv(nuts3_gdp, file.path(dir_eco, "eco_data_database/nuts3_gdp.csv"),row.names = FALSE)
write.csv(nuts0_gdp, file.path(dir_eco, "eco_data_database/nuts0_gdp.csv"),row.names = FALSE)
write.csv(ru_nat_gdp, file.path(dir_eco, "eco_data_database/ru_nat_gdp.csv"),row.names = FALSE)
write.csv(fi_pop, file.path(dir_eco, "eco_data_database/fi_pop.csv"),row.names = FALSE)

