# pre_calculate_scores

## This script does the pre-checks before running goal models and calculate
## dimension scores. It loads "ohicore", calls all goal functions and data
## layers in "conf" folder, and check that all data layers are registered
## properly.

## It is sourced from calculate_scores.r as well, but can be run on its own when
## you're working on individual goal models. After you register data layers for
## a goal, or make any changes to the data layers, source this script before
## running model-specific functions in functions.R.

if (!"ohicore" %in% (.packages())) {

# load required libraries
suppressWarnings(require(ohicore))

library(tidyr)
library(dplyr)

# set working directory to the scenario directory, ie containing conf and layers directories
setwd('~/github/bhi/baltic2015')

}

# load scenario configuration
conf = Conf('conf')

# run checks on scenario layers
CheckLayers('layers.csv', 'layers', flds_id=conf$config$layers_id_fields)

# load scenario layers
layers = Layers('layers.csv', 'layers')

