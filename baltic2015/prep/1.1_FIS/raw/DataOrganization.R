###################################
## converting fisheries regions
## to Baltic regions
## MRF: March 16 2016
###################################
library(dplyr)
library(tidyr)

### ICES to Baltic region conversion
regions <- read.csv("raw/ICES_fish_ID_assigned.csv") %>%
  select(Fish, ICES_subdiv, BHI_ID) %>%
  unique() %>%
  arrange(Fish, ICES_subdiv) %>%
  mutate(ICES_subdiv = gsub("-", "", ICES_subdiv)) %>%
  mutate(ICES_subdiv = ifelse(ICES_subdiv == 22, "3a22", ICES_subdiv)) %>%
  mutate(ICES_subdiv = ifelse(ICES_subdiv==28.1, "riga", ICES_subdiv))

write.csv(regions, "intermediate/ICES_2_BHI.csv", row.names=FALSE)

### Formatting score data  (FFmsy and BBmsy)
score <- read.csv("../intermediate/fis_status.csv") 
table(score$stock)

score <- score %>%
  separate(stock, c("Fish", "ICES_subdiv")) %>%
  left_join(regions, by=c("Fish", "ICES_subdiv")) %>%
  mutate(stock = paste(Fish, ICES_subdiv, sep="_")) %>%
  select(region_id=BHI_ID, stock, year, metric, score)
  
write.csv(score, "data/FIS_scores.csv", row.names=FALSE)


### Formatting catch data
catch <- read.csv("BalticLandings.csv") %>%
  gather("stock", "landings", -1) %>%
  mutate(stock = as.character(stock)) %>%
  mutate(stock = ifelse(stock=="her_28.1", "her_riga", stock)) %>%
  separate(stock, c("Fish", "ICES_subdiv")) %>%
  mutate(stock = paste(Fish, ICES_subdiv, sep="_"))

catch <- catch %>%
  left_join(regions, by=c("Fish", "ICES_subdiv")) %>%
  select(region_id=BHI_ID, stock, year=Year, landings)
write.csv(catch, "data/FIS_landings.csv", row.names=FALSE)
