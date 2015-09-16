# Loading and scaling eutrophication indicator data from HELCOM
# to be used as status and trend in functions.R
rm(list = ls())

library(dplyr)    # install.packages('dplyr')   for data manipulation
library(tidyr)    # install.packages('tidyr')   for data manipulation
library(stringr)  # install.packages('stringr') for string manipulation
library(ggplot2)

## READING DATA ####

dip <- read.table(file = '~/github/BHI-issues/raw_data/DIP_JC.csv', header = TRUE, sep = ",")
nu_poll <- read.table(file = '~/github/BHI-issues/raw_data/nu_pollution.csv', header = TRUE, sep = ",")
targets <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets.csv", header = TRUE, sep = ",")
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)

# Adding columns for country and basin based on rgn labels to be able to associate scores for each basin to with rgn_id (using join)
rgn_labels = mutate(rgn_id, country = substring(label,1,3), basin = gsub(" ", "_", substring(label,7,)))

 targets =
   targets %>%
   rename(Winter_DIP = winter_dip, basin = Basin) #%>%

## renaming basins to fit to rgn_id. ####
 # NB! TEMPORARY SOLUTION UNTIL WE HAvE DATA FOR ALL BASINS.

dip =
  dip %>%
   gather(basin, value, -Name, -year) %>%
   arrange(Name)

 duplicate.basin <- function(value_basin, val_df, new_basin) {
   val_basin = filter(val_df, basin == value_basin)
   xx_results =
     val_basin %>%
     mutate(basin = new_basin)
 }

 dip = bind_rows(dip,
                duplicate.basin("Baltic_Proper", dip, "Eastern_Gotland_Basin"),
                duplicate.basin("Baltic_Proper", dip, "Western_Gotland_Basin"),
                duplicate.basin("Baltic_Proper", dip, "Northern_Baltic_Proper"),
                duplicate.basin("Danish_Straits", dip, "The_Sound"),
                duplicate.basin("Danish_Straits", dip, "Great_Belt"))

## Calculting status as measured value divided by target ####
  results =
   left_join(select(targets, Winter_DIP, basin), dip, by = "basin") %>%
   rename(target = Winter_DIP) %>%
   group_by(basin) %>%
   mutate(status = value/target, inv_status = target/value) %>%
   mutate(inv_status = pmin(1, inv_status))

## make final data tables for layers output ####
 # Set latest years status as basins status
 # Calculate trend from 2000 to latest data using lm(). Coefficient[[2]] give the slope and [[1]] the intercept.
 # Calculate future_score as "predicted" status in 2016            / (slope*2011 + intercept)
 scores =
   results %>%
   group_by(basin) %>%
   filter(!is.na(inv_status)) %>% filter(year > 2000) %>%
   mutate(status_score = last(inv_status)) %>%
   select(basin, status_score, inv_status, year) %>%
   do(trend = lm(inv_status ~ year, data = .), status_score = last(.$inv_status)) %>%
   mutate(slope = summary(trend)$coeff[2], intercept = summary(trend)$coeff[1]) %>%
   mutate(future_score = pmin(1, (slope*2016 + intercept))) %>%                       ## how to do this? with or without intercept
   select(-trend)

scores$status_score = unlist(scores$status_score)

 # join calculated scores to rgn_ids to get values for each region
 scores = full_join(rgn_labels, scores, by = "basin") %>%
   select(rgn_id, label, status_score, future_score, slope) %>%
   filter(!is.na(rgn_id))

#  write csv files to layers folder ####
#  write.csv(status_score, "~/github/bhi/baltic2015/layers/cw_nu_status.csv", row.names = F)
#  write.csv(trend_score, "~/github/bhi/baltic2015/layers/cw_nu_trend.csv", row.names = F)

## CHECKING DATA ####
windows()
results %>%
  ggplot(aes(x = year, y = inv_status, colour = "inv_status")) + geom_point(aes(group = basin)) +
  geom_point(aes(x = year, y = status, colour = "status")) +
  geom_point(aes(x = year, y = value, colour = "value")) +
  geom_line(aes(x = year, y = target, colour = "target")) +
  facet_wrap(~ basin, ncol = 3, scales = "free_y")
