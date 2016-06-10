## liv_prep_database_call.r

## This file calls the data from the database and saves as a cvs in liv_data_database

## This file should be run prior to liv_prep.Rmd if data are updated in the database


##----------------------------------------------------#

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories

dir_liv    = file.path(dir_prep, 'LIV')


## UPDATE when data updated in database

