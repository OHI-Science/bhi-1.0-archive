# Nutrient loads for pressure

rm(list = ls())

library(dplyr)    # install.packages('dplyr')   for data manipulation
library(tidyr)    # install.packages('tidyr')   for data manipulation
library(stringr)  # install.packages('stringr') for string manipulation
library(ggplot2)

## READING DATA ####

point <- read.table(file = '~/github/BHI-issues/raw_data/Nutrientload/point20131121.csv', header = TRUE, sep = ",")
river <- read.table(file = '~/github/BHI-issues/raw_data/Nutrientload/rivload131121.csv', header = TRUE, sep = ",")
p_ceiling <- read.table(file = '~/github/BHI-issues/raw_data/Nutrientload/P_ceilings.csv', header = TRUE, sep = ",", na.strings = 0)
n_ceiling <- read.table(file = '~/github/BHI-issues/raw_data/Nutrientload/N_ceilings.csv', header = TRUE, sep = ",", na.strings = 0)
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)

# Adding columns for country and basin based in rgn labels to be able to associate pressure for each basin to with rgn_id (using join)
rgn_labels = mutate(rgn_id, country = substring(label,1,3), basin = gsub(" ", "_", substring(label,7,)))

point =
  point %>%
  mutate(label = paste(substring(country,1,3), "-", gsub("_", " ", basin))) %>%
  filter(Year == 2010) %>%
  select(label, Year, TN_tons, TP_tons)
river =
  river %>%
  mutate(label = paste(substring(country,1,3), "-", gsub("_", " ", basin))) %>%
  filter(Year == 2010) %>%
  select(label, Year, TN_tons, TP_tons, TN_norm_tons, TP_norm_tons)

loads = full_join(river, point, by = "label")

# Replacing finer resolution basin names (HOLAS) with coarser resolution name (PLC)
# which basin load to use for Aland Sea and the Quark?
rgn_labels$label = gsub("*The Quark", "Bothnian Sea", rgn_labels$label)
rgn_labels$label = gsub("*Aland Sea", "Bothnian Sea", rgn_labels$label)
rgn_labels$label = gsub("*Eastern Gotland Basin", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*Western Gotland Basin", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*Northern Baltic Proper", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*Arkona Basin", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*Bornholm Basin", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*Gdansk Basin", "Baltic Proper", rgn_labels$label)
rgn_labels$label = gsub("*The Sound", "Danish Straits", rgn_labels$label)
rgn_labels$label = gsub("*Great Belt", "Danish Straits", rgn_labels$label)
rgn_labels$label = gsub("*Kiel Bay", "Danish Straits", rgn_labels$label)
rgn_labels$label = gsub("*Bay of Mecklenburg", "Danish Straits", rgn_labels$label)

rgn_labels$basin = sub("The_Quark", "Bothnian_Sea", rgn_labels$basin)
rgn_labels$basin = sub("Aland_Sea", "Bothnian_Sea", rgn_labels$basin)
rgn_labels$basin = sub("Eastern_Gotland_Basin", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("Western_Gotland_Basin", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("Northern_Baltic_Proper", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("Arkona_Basin", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("Bornholm_Basin", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("Gdansk_Bay", "Baltic_Proper", rgn_labels$basin)
rgn_labels$basin = sub("The_Sound", "Danish_Straits", rgn_labels$basin)
rgn_labels$basin = sub("Great_Belt", "Danish_Straits", rgn_labels$basin)
rgn_labels$basin = sub("Kiel_Bay", "Danish_Straits", rgn_labels$basin)
rgn_labels$basin = sub("Bay_of_Mecklenburg", "Danish_Straits", rgn_labels$basin)

# N and P ceilings
Pceiling =
  p_ceiling %>%
  gather(key = basin, value = p_ceiling, 2:8) %>%
  mutate(label = paste(substring(Country,1,3), "-", gsub("_", " ", basin)))
Nceiling =
  n_ceiling %>%
  gather(key = basin, value = n_ceiling, 2:8) %>%
  mutate(label = paste(substring(Country,1,3), "-", gsub("_", " ", basin)))


ref_point = select(full_join(Nceiling, Pceilings, by = "label"), label, p_ceiling, n_ceiling)


nu_pressure = full_join(loads, rgn_labels, by = "label")
nu_pressure = full_join(nu_pressure, ref_point, by = "label")
nu_pressure =
  nu_pressure %>%
  mutate(p = TP_norm_tons/p_ceiling, n = TN_norm_tons/n_ceiling) %>%
  select(rgn_id, Year.x, label, n, p)


