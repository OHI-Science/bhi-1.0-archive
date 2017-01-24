########################################################
## DATA PREP - LIV
########################################################
#Libraries
library(dplyr)
library(tidyr)
library(RMySQL)
library(ggplot2)

########################################################
##----------------------------------#
## NUTS2 Employment - BHI Regions
##----------------------------------#

## Read data from local csv until in the database

e_nuts2 = read.csv("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/Employment/cleaned/lfst_r_lfe2emprt_1_Data_NUTS2_cleaned.csv",
                   sep=";", header=TRUE)
head(e_nuts2)
colnames(e_nuts2)

## Next steps

## Filter by NUTS2 associated with BHI regions
    ## Need NUTS2 - BHI lookup table (need from new shapefiles)
## Check Flag.and.Footnotes

## Plot raw data from NUTS2

## NUTS2 BHI pop fractions by NUTS2

## Employment * Population

## Sum for each BHI region



##----------------------------------#
## NUTS0 Employment
##----------------------------------#
