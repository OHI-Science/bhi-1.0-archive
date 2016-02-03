library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)

gdp = read.csv("~/github/BHI-issues/raw_data/Eutrostat/nama_10r_3gdp.csv", stringsAsFactors = F, na.strings = ":")
NUTS = read.csv("~/github/BHI-issues/factors/COAST_NUTS3.csv")

gdp =  rename(gdp, NUTS_ID = geo.time)

temp = left_join(NUTS, gdp, by = 'NUTS_ID') %>%
  gather('year','value', -c(1:6)) %>%
  mutate(year = as.numeric(gsub('X', '', year)))

