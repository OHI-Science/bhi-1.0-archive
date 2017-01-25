## mpa_prep_database_call.r


## TO DO -- update this file when data in database, right now have simply copied correct csv into the mpa_data_database folder




## This file calls the data from the database and saves as a cvs in mpa_data_database

## This file should be run prior to lsp_prep.Rmd if data are updated in the database

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_lsp    = file.path(dir_prep, 'LSP')



## 1. access the database with MySQL()
