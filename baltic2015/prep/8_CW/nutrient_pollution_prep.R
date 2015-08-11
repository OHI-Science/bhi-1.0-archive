# Loading and scaling eutrophication indicator data from HELCOM
# to be used as status and trend in functions.R

# SGNAme = taxon_name_key
 rm(list = ls())

# library(dplyr)    # install.packages('dplyr')   for data manipulation
# library(tidyr)    # install.packages('tidyr')   for data manipulation
# library(stringr)  # install.packages('stringr') for string manipulation
#
# # set working directory
# getwd()
# setwd('baltic2015/prep/8_CW')
# list.files()
#
# # reading data

DIP <- read.table(file = 'DIP_JC.csv', header = TRUE, sep = ",")
TARGETS <- read.table(file = "TARGETS_JC.csv", header = TRUE, sep = ",")
rgn_id <- read.table(file = "rgn_id.csv", header = TRUE, sep = ",")

# renaming basins to fit to rgn_id. NB! TEMPORARY SOLUTION UNTIL WE HAVE DEFINITE DECISION ON BASINS.

DIP =
  DIP %>%
  rename(KT = Kattegat,
         BP = Baltic_Proper,
         GF = Gulf_of_Finland,
         GR = Gulf_of_Riga,
         AA = Aland_Sea,
         BS = Bothnian_Sea,
         BB = Bothnian_Bay,
         AR = Arkona_Basin,
         BH = Bornholm_Basin,
         DS = Danish_Straits) %>%
  gather(basin, value, -Name, -year)

# creating target value for Baltic Proper as a mean of EGB, WGB and NBP
BP =
TARGETS %>%
   select(Eastern_Gotland_Basin, Western_Gotland_Basin, Northern_Baltic_Proper)
BP = rowMeans(BP)
 TARGETS = mutate(TARGETS, BP = BP)

TARGETS =
  TARGETS %>%
#    rowMeans(select(Eastern_Gotland_Basin, Western_Gotland_Basin, Northern_Baltic_Proper))) %>%
  rename(KT = Kattegat,
         GF = Gulf_of_Finland,
         GR = Gulf_of_Riga,
         AA = Aland_Sea,
         BS = Bothnian_Sea,
         BB = Bothnian_Bay,
         AR = Arkona_Sea,        #from here down different names than in DIP-file
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
#  TARGETS =
#    rename(TARGETS, target = value)


#
#  TARGETS %>%
#    group_by(Name) %>%
#    filter(basin %in% c('EG','WG','NB')) %>%
#    summarise(mean(value)) %>%
#    mutate(basin = "BP") %>%

## Calculting status as measured value divided by target

results =
   full_join(filter(TARGETS, Name == 'Winter_DIP'), DIP, by = "basin")
results =
   results %>%
#    rename(TARGETS = value.x, value = value.y) %>%
   mutate(status = value/target)

 # Add values for basins in the straits, the Sound and Western Baltic.
 # Using timeseries for Danish straits and target values for the Sound and the Great Belt.
 # TODO: use MB for GE-WB and KB for DE-WB
 DS = filter(DIP, basin == "DS")
 SO_target = as.numeric(select(filter(TARGETS, basin == "SO" & Name == "Winter_DIP"),target))
 GB_target = as.numeric(select(filter(TARGETS, basin == "GB" & Name == "Winter_DIP"),target))
 WB_results =
   DS %>%
   mutate(status = value/GB_target, basin = "WB", target = GB_target, value = NA)
 SO_results =
   DS %>%
   mutate(status = value/SO_target, basin = "SO", target = SO_target, value = NA)

 results = bind_rows(results, WB_results, SO_results)

 short_results =
   results %>%
   group_by(basin) %>%
   filter(!is.na(status) & year == 2011)

 # calculate trend using lm(). Coefficient[[2]] give the slope and [[1]] the intercept
 future =
   filter(results, !is.na(status)) %>%
   group_by(basin) %>%
   do(trend = lm(status ~ year, data = .)) %>%
#    do(data.frame(var = names(coef(.$trend)),
#                  coef = coef(.$trend),
#                  basin = .$basin)) %>%
   do(data.frame(slope = coef(.$trend)[["year"]],
                 intercept = coef(.$trend)[["(Intercept)"]],
                 future_status = coef(.$trend)[["year"]]*2016))


# library(ggplot2)
 filter(results, !is.na(status)) %>%
   ggplot(aes(year, status, colour=basin)) + geom_point(aes(group=basin)) +
   theme(legend.position="top") + guides(colour = guide_legend(nrow = 1))


