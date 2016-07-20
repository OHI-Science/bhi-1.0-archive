########################################################################
##
## Combine taxa data
##
######################################################################

library(dplyr)
library(tidyr)

benthos <- read.csv("baltic2015/prep/SPP/intermediate/benthos.csv")
birds <- read.csv("baltic2015/prep/SPP/intermediate/birds.csv")
fish <- read.csv("baltic2015/prep/SPP/intermediate/fish.csv")
macrophytes <- read.csv("baltic2015/prep/SPP/intermediate/macrophytes.csv")
mammals <- read.csv("baltic2015/prep/SPP/intermediate/mammals.csv")

## add taxa identifer to each object
benthos = benthos %>%
          mutate(taxa = "benthos")

birds = birds %>%
        mutate(taxa = "birds")

fish = fish %>%
       mutate(taxa = "fish")

macrophytes = macrophytes %>%
              mutate(taxa= "macrophytes")

mammals = mammals %>%
          mutate(taxa = "mammals")

## combine objects
data <- rbind(benthos, birds, fish, macrophytes, mammals)

write.csv(data, "baltic2015/prep/SPP/data/species_IUCN.csv", row.names=FALSE)
