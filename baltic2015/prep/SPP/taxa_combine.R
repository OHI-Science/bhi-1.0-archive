########################################################################
##
## Combine taxa datat
##
######################################################################

library(dplyr)
library(tidyr)

benthos <- read.csv("baltic2015/prep/SPP/intermediate/benthos.csv")
birds <- read.csv("baltic2015/prep/SPP/intermediate/birds.csv")
fish <- read.csv("baltic2015/prep/SPP/intermediate/fish.csv")
macrophytes <- read.csv("baltic2015/prep/SPP/intermediate/macrophytes.csv")
mammals <- read.csv("baltic2015/prep/SPP/intermediate/mammals.csv")

data <- rbind(benthos, birds, fish, macrophytes, mammals)

write.csv(data, "baltic2015/prep/SPP/data/species_IUCN.csv", row.names=FALSE)
