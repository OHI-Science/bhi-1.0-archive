## common.r

## For common libraries, directories, functions etc.
## Call using source('~/github/bhi/baltic2015/prep/common.r')


## Libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)
library(stringr)
library(tools)

## Directories
dir_baltic = '~/github/bhi/baltic2015'
dir_layers = file.path(dir_baltic, 'layers')
dir_prep   = file.path(dir_baltic, 'prep')


## create_readme function will create a rawgit.com url
create_readme = function(dir = dir_secchi, file = 'secchi_prep.rmd') {

  # create rawgit.com url
  wd = file.path(dir, file)
  w  = str_split(wd, '/')
  fp = file.path('https://cdn.rawgit.com/OHI-Science', w[[1]][2], 'draft', w[[1]][3], w[[1]][4],
                 w[[1]][5], w[[1]][6], w[[1]][7],
                 paste0(file_path_sans_ext(w[[1]][8]), '.html'))

# rewrite template README.md
  readLines(file.path(dir_prep, 'README_prep_template.md')) %>%
    str_replace("here", paste0("[here](", fp, ")")) %>%
    writeLines(file.path(dir, 'README.md'))

}


