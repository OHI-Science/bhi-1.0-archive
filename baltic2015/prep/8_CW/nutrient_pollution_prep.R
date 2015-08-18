# Loading and scaling eutrophication indicator data from HELCOM
# to be used as status and trend in functions.R

# SGNAme = taxon_name_key
 rm(list = ls())

library(dplyr)    # install.packages('dplyr')   for data manipulation
library(tidyr)    # install.packages('tidyr')   for data manipulation
library(stringr)  # install.packages('stringr') for string manipulation
#
# # set working directory
# getwd()
# setwd('~/github/bhi/baltic2015/prep/8_CW')
# list.files()
#
# # reading data ####

dip <- read.table(file = '~/github/BHI-issues/raw_data/DIP_JC.csv', header = TRUE, sep = ",")
nu_poll <- read.table(file = '~/github/BHI-issues/raw_data/nu_pollution.csv', header = TRUE, sep = ",")
targets <- read.table(file = "~/github/BHI-issues/raw_data/TARGETS_JC.csv", header = TRUE, sep = ",")
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)

# renaming basins to fit to rgn_id. ####
 # NB! TEMPORARY SOLUTION UNTIL WE HAVE DEFINITE DECISION ON BASINS.

dip =
  dip %>%
#    as.factor(Name) %>%
  rename(KT = Kattegat,
         BP = Baltic_Proper,
         GF = Gulf_of_Finland,
         GR = Gulf_of_Riga,
         AS = Aland_Sea,
         BS = Bothnian_Sea,
         BB = Bothnian_Bay,
         AR = Arkona_Basin,
         BH = Bornholm_Basin,
         DS = Danish_Straits) %>%
  gather(basin, value, -Name, -year) %>%
   arrange(Name)

# creating target value for Baltic Proper as a mean of EGB, WGB and NBP
BP =
targets %>%
   select(Eastern_Gotland_Basin, Western_Gotland_Basin, Northern_Baltic_Proper)
BP = rowMeans(BP)
 targets = mutate(targets, BP = BP)

targets =
  targets %>%
  rename(KT = Kattegat,
         GF = Gulf_of_Finland,
         GR = Gulf_of_Riga,
         AS = Aland_Sea,
         BS = Bothnian_Sea,
         BB = Bothnian_Bay,
         AR = Arkona_Sea,        #from here down different names than in nu_poll-file
         BH = Bornholm_Sea,
         SO = The_Sound,
         GB = Great_Belt,
         KB = Kiel_Bay,
         BM = Bay_of_Mecklenburg,
         GD = Gdansk_Basin,
         EG = Eastern_Gotland_Basin,
         WG = Western_Gotland_Basin,
         NB = Northern_Baltic_Proper,
         QK = The_Quark) %>%
   gather(basin, value, -Name) %>%
   rename(target = value)

## Calculting status as measured value divided by target
results =
   full_join(filter(targets, Name == "Winter_DIP"), dip, by = "basin") %>%
   mutate(status = value/target)

 # Add values for basins in the straits, the Sound and Western Baltic. ####
 # Using timeseries for Danish straits and target values for the Sound and the Great Belt.
 # TODO: use MB for GE-WB and KB for DE-WB
 fix.basin <- function(value_basin, target_basin, new_basin, var_name, val_df, target_df) {
   val_basin = filter(val_df, basin == value_basin)
   xx_target = as.numeric(select(filter(target_df, basin == target_basin & Name == var_name), target))
   xx_results =
     val_basin %>%
     mutate(status = value/xx_target, basin = new_basin, target = xx_target, value = NA)
 }
 SO_results = fix.basin("DS","SO","SO", "Winter_DIP",dip, targets)
 WB_results = fix.basin("DS","GB","WB", "Winter_DIP",dip, targets)

 # Normalize status to maximum status value in each basin.
 results =
   bind_rows(results, WB_results, SO_results) %>%
   group_by(basin) %>%
   mutate(norm_status = pmin(1,status/max(status, na.rm = T)), max_status = max(status, na.rm = T))


 # calculate trend from 2000 to latest data using lm().
 # Coefficient[[2]] give the slope and [[1]] the intercept ####
 future =
   results %>%
   group_by(basin) %>%
   filter(!is.na(norm_status)) %>%
   filter(year > 2000) %>%
   do(trend = lm(norm_status ~ year, data = .)) %>%
   do(tbl_df(data.frame(slope = coef(.$trend)[["year"]],
                 intercept = coef(.$trend)[["(Intercept)"]],
                 future_status = (coef(.$trend)[["year"]]*2016 + coef(.$trend)[["(Intercept)"]]) /
                   (coef(.$trend)[["year"]]*2011 + coef(.$trend)[["(Intercept)"]]),
                 basin = .$basin)))

 ## make final data tables for layers output ####

 trend_score =
   future %>%
   mutate(score = slope) %>%
   select(basin, score, slope)
 status_score =
   results %>%
   filter(!is.na(norm_status)) %>%
   group_by(basin) %>%
   filter(norm_status == last(norm_status)) %>%
   mutate(score = norm_status) %>%
   select(basin, score, norm_status)

 # join calculated scores to rgn_ids to get values for each region
 tmp = mutate(rgn_id, basin = as.table(matrix(unlist(strsplit(rgn_id$label, "_")), ncol = 2, byrow= T))[,2])

 status_score = full_join(tmp, status_score, by = "basin") %>%
#    mutate(score = pmin(status, 1)) %>%
   select(rgn_id, score) %>%
   filter(!is.na(rgn_id))

 trend_score = full_join(tmp, trend_score, by = "basin") %>%
   select(rgn_id, score) %>%
   filter(!is.na(rgn_id))

#  write csv files to layers folder ####
#  write.csv(status_score, "~/github/bhi/baltic2015/layers/cw_nu_status.csv", row.names = F)
#  write.csv(trend_score, "~/github/bhi/baltic2015/layers/cw_nu_trend.csv", row.names = F)


#### Plot to check data ####

# library(ggplot2)
 filter(results, !is.na(status)) %>%
   ggplot(aes(year, status, colour = basin)) + geom_point(aes(group = basin)) +
   theme(legend.position = "top") + guides(colour = guide_legend(nrow = 1)) +
   stat_smooth(method = "lm")

#  x = c(1970:2016)
#  df <- future %>%
#    filter(basin == "AR")
#    y <- df$slope*x + df$intercept
#  dt <- data.table(x, y) %>%
#    rename(year = x, status = y)
#
#  dtt <- filter(results, !is.na(status) & basin == "AR")
#  dttt <- right_join(dtt,dt, by = "year")
#
#    ggplot(aes(as.numeric(dttt$year), dttt$status.x)) +
#    geom_point(aes(group = basin)) +
#    geom_line(aes(x = year, y = status.y)) +
#    theme(legend.position = "top") + guides(colour = guide_legend(nrow = 1)) +
#    stat_smooth(method = "lm")

