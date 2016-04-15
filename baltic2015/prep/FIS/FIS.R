##################################
## fisheries
## MRF Feb 17 2016
##################################
library(dplyr)
library(tidyr)

## Directories
dir_baltic = '~/github/bhi/baltic2015'
dir_layers = file.path(dir_baltic, 'layers')
dir_prep   = file.path(dir_baltic, 'prep')
dir_fis = file.path(dir_prep, 'FIS')

scores <- read.csv(file.path(dir_fis,
'data/FIS_scores.csv')) %>%
  spread(metric, score)

###########################################################################
## STEP 1: converting bbmsy and ffmsy to scores
## see plot describing the relationship between these variables and scores
## this may need to be adjusted:
###########################################################################
scores <- scores %>%
  mutate(score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy+1.5), 0, NA),
         score = ifelse(bbmsy < 0.8 & ffmsy < (bbmsy - 0.2), ffmsy/(bbmsy-0.2), score),
         score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy + 0.2) & ffmsy < (bbmsy + 1.5), (bbmsy + 1.5 - ffmsy)/1.5, score),
         score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy - 0.2) & ffmsy < (bbmsy + 0.2), 1, score)) %>%
  mutate(score = ifelse(bbmsy >= 0.8 & ffmsy < 0.8, ffmsy/0.8, score),
         score = ifelse(bbmsy >= 0.8 & ffmsy >= 0.8 & ffmsy < 1.2, 1, score),
         score = ifelse(bbmsy >= 0.8 & ffmsy >= 1.2, (2.5 - ffmsy)/1.3, score)) %>%
  mutate(score = ifelse(score <= 0, 0.1, score))
### NOTE: The reason the last score is 0.1 rather than zero is because
### scores can't be zero if using a geometric mean because otherwise, 1 zero
### results in a zero score.

#############################################
## STEP 2: cacluting the weights.
#############################################

landings <- read.csv(file.path(dir_fis,'data/FIS_landings.csv'))

##### Subset the data to include only the most recent 10 years
landings <- landings %>%
  filter(year %in% (max(landings$year)-9):max(landings$year))


## we use the average catch for each stock/region across all years
## to obtain weights
weights <- landings %>%
  group_by(region_id, stock) %>%
  mutate(avgCatch = mean(landings)) %>%
  ungroup() %>%
  data.frame()

## each region/stock will have the same average catch across years:
filter(weights, region_id==3)

## determine the total proportion of catch each stock accounts for:
weights <- weights %>%
  group_by(region_id, year) %>%
  mutate(totCatch = sum(avgCatch)) %>%
  ungroup() %>%
  mutate(propCatch = avgCatch/totCatch)

#### The total proportion of landings for each region/year will sum to one:
filter(weights, region_id ==3, year==2014)

############################################################
#####  STEP 3: Join scores and weights to calculate status
############################################################

status <- weights %>%
  left_join(scores, by=c('region_id', 'year', 'stock')) %>%
  filter(!is.na(score)) %>%                    # remove missing data
  select(region_id, year, stock, propCatch, score)        # cleaning data


### Geometric mean weighted by proportion of catch in each region
status <- status %>%
  group_by(region_id, year) %>%
  summarize(status = prod(score^propCatch)) %>%
  ungroup() %>%
  data.frame()

### To get trend, get slope of regression model based on most recent 5 years
### of data

##TODO where is the object status_trend_data????
trend_years <- (max(status_trend_data$year)-4):max(status_trend_data$year)

trend <- status %>%
  group_by(region_id) %>%
  filter(year %in% trend_years) %>%
  do(mdl = lm(status ~ year, data=.)) %>%
  summarize(region_id = region_id,
            trend = coef(mdl)['year'] * 5) %>%  ## trend multiplied by 5 to get prediction 5 years out
  ungroup() %>%
  mutate(trend = round(trend, 2))

# can do a check to make sure it looks right:
data.frame(filter(status, region_id==3))

lm(c(0.8811878, 0.9390962, 0.9390962, 0.7916069, 0.7145114) ~ trend_years)
-0.04808 * 5
## results match....looks like everything went well!

### final formatting of status data:
status <- status %>%
  filter(year == max(year)) %>%
  mutate(status = round(status * 100, 1)) %>%
  select(region_id, status)


##### save the data (eventually these steps will be incorporated into the OHI toolbox)
write.csv(status, "data/FIS_status.csv", row.names=FALSE)
write.csv(trend, "data/FIS_trend.csv", row.names = FALSE)



##############################################
## Read in the status and trend csv for plotting
status = read.csv(file.path(dir_fis,
                   'data/FIS_status.csv'))
trend = read.csv(file.path(dir_fis,
                            'data/FIS_trend.csv'))

library(ggplot2)

windows()
par(mfrow=c(1,2), mar=c(1,1,1,1), oma=c(2,2,2,2))
plot(status~region_id, data=status)

par(new=FALSE)
plot(trend~region_id, data=trend)
