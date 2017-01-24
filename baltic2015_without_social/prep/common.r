## common.r

## For common libraries, directories, functions etc.
## Call using source('~/github/bhi/baltic2015/prep/common.r')


## Libraries
library(tidyverse) # install.packages('tidyverse') # installs dplyr, tidyr, ggplot2 and more
library(RMySQL)
library(stringr)
library(tools)
library(ggmap) # install.packages('ggmap')

## Directories
dir_baltic = '~/github/bhi/baltic2015'
dir_layers = file.path(dir_baltic, 'layers')
dir_prep   = file.path(dir_baltic, 'prep')



## create_readme function will provide a link to the github_document .md file
## created in the *_prep.rmd files
create_readme = function(dir, file) {

  # if statement so don't overwrite existing README.md
  if (!file.exists(file.path(dir, 'README.md'))) {

    # create rawgit.com url
    repo = 'bhi'
    wd   = file.path(dir, file)
    w    = str_split(wd, repo)
    fp   = paste0('https://github.com/OHI-Science/', repo, '/blob/draft',
                   file_path_sans_ext(w[[1]][2]), '.md')

    # rewrite template README.md
    readLines(file.path(dir_prep, 'README_prep_template.md')) %>%
      str_replace("here", paste0("[here](", fp, ")")) %>%
      writeLines(file.path(dir, 'README.md'))

  }
}

## example of how to fill in the function
## dir = dir_secchi, file = 'secchi_prep.rmd'

