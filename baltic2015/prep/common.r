## common.r

## For common libraries, directories, functions etc.
## Call using source('~/github/bhi/baltic2015/prep/common.r')


## Libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)

## Directories
dir_baltic = '~/github/bhi/baltic2015'
dir_layers = file.path(dir_baltic, 'layers')
dir_prep   = file.path(dir_baltic, 'prep')

