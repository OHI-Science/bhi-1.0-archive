library(package = plyr)
library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

# SETTING CONSTANTS
min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
regr_length = 10       # number of years to use for regression
future_year = 5        # the year at which we want the likely future status
min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!

### read mysql config
# run your personal mysql config script to read in passcode

#### load whatever data you want to run through the script ####


#### NA fill for missing regions ####
# creates data frame if any regions missing from input data
if (anyNA(match(c(1:nrow(rgn_id)), unique(status_score$rgn_id))) == T)
{
  # creates data frame with the missing IDs. Finds missing region IDs by matching against a vector with regions IDs
  missing_id = data.frame(rgn_id = which(is.na(match(c(1:nrow(rgn_id)), unique(status_score$rgn_id)))))
}
status_score = bind_rows(missing_id, status_score)

#### calculate trend_score or set trend_score to NA ####
# Allows status_score timeseries to contain NA and/or have timeseries shorter than the min_regr_length (set at top of script)
# For regions that have data from min_year to with at least min_regr_length data points over the regr_length
trend =
  status_score %>%
  group_by(rgn_id) %>%
  do(tail(. , n = regr_length)) %>%
  do({if(sum(!is.na(.$status)) >= min_regr_length)
    data.frame(trend_score = coef(lm(status ~ year, .))[2] * future_year)
    else data.frame(trend = NA)})

