## MAR data prep

## this replaces earlier prep code because it starts with the raw data, rather than with data allocated
## already to BHI region manually

## data are currently loaded via csv but this will need to be changed to the database one they are uploaded

#Libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)

#############################################################
##-------------------------##
## Read in data

lookup = read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Mariculture/mar_data_database/mar_data_lookuptable.csv",
                  header=TRUE,sep=";")
head(lookup)

mar_data = read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Mariculture/mar_data_database/mar_data_production.csv",
                    header=TRUE,sep=";")
head(mar_data)

##-------------------------##

