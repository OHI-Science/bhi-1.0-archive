# rm(list = ls())

library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

# SETTING CONSTANTS
min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
regr_length = 10       # number of years to use for regression
future_year = 5        # the year at which we want the likely future status
min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!
n_rgns = 42            # Number of regions used

### read mysql config
# run your personal mysql config script to read in passcode

#### load whatever data you want to run through the script ####

## Secchi ##
values = read.csv("~/github/bhi/baltic2015/prep/8_CW/cw_nu_values.csv")
ref_point = read.csv("~/github/bhi/baltic2015/layers/cw_nu_secchi_targets.csv")

## GDP ##
status_score = read.csv("~/github/bhi/baltic2015/prep/6.2_ECO/le_gdp_tempbhi2015.csv") %>%
  rename(BHI_ID = rgn_id) %>%
  mutate(rgn_id = na.omit(as.numeric(unlist(strsplit(as.character(status_score$BHI_ID), "[^0-9]+"))))) %>%
  mutate(year = as.numeric(year), status = gdp_mio_euro)
  group_by(rgn_id, year)

#### normalize data according to goal function and set ref point ####
## secchi ##
  status_score =
  full_join(values, ref_points, by = 'rgn_id') %>%
  mutate(., status =  pmin(1, values/ref_point)) %>%
  select(rgn_id, year, status)
  # summarise_each(funs(last), rgn_id, status, trend)

## gdp - how do we normalise? ##

#### NA fill for missing regions ####
# creates data frame if any regions missing from input data
if (anyNA(match(c(1:n_rgns), unique(status_score$rgn_id))) == T)
{
  # creates data frame with the missing IDs. Finds missing region IDs by matching against a vector with regions IDs
  missing_id = data.frame(rgn_id = which(is.na(match(c(1:n_rgns), unique(status_score$rgn_id)))))
  status_score = bind_rows(missing_id, status_score)
}


#### calculate trend_score or set trend_score to NA ####
# Allows status_score timeseries to contain NA and/or have timeseries shorter than the min_regr_length (set at top of script)
# For regions that have data from min_year to with at least min_regr_length data points over the regr_length
trend =
  status_score %>%
  group_by(rgn_id) %>%
  do(tail(. , n = regr_length)) %>%
  do({if(sum(!is.na(.$status)) >= min_regr_length)
    data.frame(trend_score = coef(lm(status ~ year, .))['year'] * future_year) # or use: data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year)))
    else data.frame(trend_score = NA)}) %>%
  # mutate(trend_score = pmin(1, trend_score))


