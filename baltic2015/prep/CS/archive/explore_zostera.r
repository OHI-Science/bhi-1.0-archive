## read in Zostera data

# libraries
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(rgdal)
library(raster)

dir_zostera = '~/github/bhi/baltic2015/prep/4_CS/Zostera_marina'


z = readOGR(dsn = path.expand(dir_zostera),
        layer = 'Join_macrophytes')

plot(z)
y <- z[, "Z_marina"]
y@data$Z_marina <- ifelse(y@data$Z_marina == 0, NA, y@data)
plot(y)

d = z@data

summary(d)

zostera = d %>%
  dplyr::select(CELLCODE, Z_marina) %>%
  filter(Z_marina !=0)

