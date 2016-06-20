## Plotting LSP Status

## 20 June 2016

## Libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')
library(stringr) # install.packages("stringr")

# source
source('~/github/bhi/baltic2015/prep/common.r') #for create_readme() function

## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')
dir_prep = make_path('baltic2015/prep') # replaces  file.path(dir_baltic, 'layers')

dir_lsp   = file.path(dir_prep, 'LSP')



## Plot preliminary LSP status results - calculated by country and then applied to BHI regions

##
lsp_status = read.csv(file.path(dir_lsp,'lsp_status_by_rgn.csv'))

lsp_status = lsp_status %>%
              arrange(rgn_id)

ggplot(lsp_status)+
  geom_point(aes(rgn_id,score), size=2)+
  ylim(0,100)+
  ggtitle("LSP status")



### THIS look up may be wrong - multiple status per country
## READ in country_region_lookup so can plot by status by country
#
# country_lookup = read.csv(file.path(dir_lsp,'country_region_lookup.csv'),sep=";", stringsAsFactors = FALSE)
#
# country_lookup = country_lookup %>%
#                  arrange(rgn_id)
#
# ## This does not work ---
#
# ## Join country and status
# lsp_status_rgn = full_join(lsp_status, country_lookup, by="rgn_id")
#
# %>%
#                  dplyr::select(country, score)%>%
#                  distinct()
#
# ggplot(lsp_status_rgn)+
#   geom_point(aes(country,score), size=2)+
#   ylim(0,100)+
#   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
#                                   hjust=.5, vjust=.5, face = "plain"))+
#   ggtitle("LSP status")
