rm(list = ls())

library(dplyr)    # install.packages('dplyr')   for data manipulation
library(tidyr)    # install.packages('tidyr')   for data manipulation
library(stringr)  # install.packages('stringr') for string manipulation
library(ggplot2)  #                             for plotting
library(zoo)      #                             for timeseries

## READING DATA ####

# ICES <- read.table(file = '~/github/BHI-issues/raw_data/ICES/BALTIC_20151007.txt', header = TRUE, sep = ";")
#
# secchi <- ICES %>%
#    select(1:13, starts_with('Secchi')) %>%
#   rename(secchi = Secchi.Depth..m..METAVAR.DOUBLE) %>%
# #   mutate(date =  as.Date(yyyy.mm.ddThh.mm), month = format(date, "%m")) %>%
#   filter(!is.na(secchi))
#
# write.table(secchi, file = '~/github/BHI-issues/raw_data/ICES/ICES_secchi.csv', sep = ",", row.names = F)

secchi <- read.table(file = '~/github/BHI-issues/raw_data/ICES/ICES_secchi.csv', header = T, sep = ",")
secchi <- secchi %>%
  mutate(date =  as.Date(yyyy.mm.ddThh.mm), month = format(date, "%m")) #%>%

windows()
secchi %>%
  filter(grepl("DEN|SWE|FIN|GER|POL|RUS|LIT|LAT|EST", Assessment.Unit.METAVAR.TEXT), date > as.Date('1990-01-01')) %>%
  mutate(country = paste(substring(Assessment.Unit.METAVAR.TEXT, 1, 3))) %>%
  ggplot(aes(x=date, y=secchi, colour = Assessment.Unit.METAVAR.TEXT)) + geom_point(aes(group = Assessment.Unit.METAVAR.TEXT)) +
  xlim(as.Date(c('2000-01-01', '2014-01-01'))) +
  facet_wrap(~country, ncol = 3) +
  guides(col = guide_legend(ncol = 3))

# short = slice(ICES, 209900:210000)
# tmp  <- secchi %>%
#   select(1:13, starts_with('Secchi')) %>%
# #   rename(secchi = Secchi.Depth..m..METAVAR.DOUBLE) %>%
#   mutate(date =  as.Date(yyyy.mm.ddThh.mm), month = format(date, "%m"))





