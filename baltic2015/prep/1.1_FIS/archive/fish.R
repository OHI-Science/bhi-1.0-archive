#################################
## Baltic Fisheries
## MRF Feb 17 2016
#################################
library(tidyr)
library(dplyr)

catch <- read.csv('archive/fis_catch.csv')
catch <- gather(catch, 'stock', 'catch', -Year) %>%
  select(year=Year, stock, catch)
write.csv(catch, 'data/fis_catch.csv', row.names=FALSE)

status <- read.csv('archive/fis_status.csv') %>%
  gather("metric", "score", c(B.BMSY, F.FMSY)) %>%
  select(year=Year, stock=taxa, metric, score) %>%
  mutate(metric = ifelse(metric=='B.BMSY', 'bbmsy', 'ffmsy'))
write.csv(status, 'data/fis_status.csv', row.names=FALSE)
