# load required libraries
suppressWarnings(require(ohicore))
library(tidyr)

# set working directory to the scenario directory, ie containing conf and layers directories
setwd('~/github/bhi/baltic2015')

# load scenario configuration
conf = Conf('conf')

# run checks on scenario layers
CheckLayers('layers.csv', 'layers', flds_id=conf$config$layers_id_fields)

# load scenario layers
layers = Layers('layers.csv', 'layers')

# calculate scenario scores
scores = CalculateAll(conf, layers, debug=T)
write.csv(scores, 'scores.csv', na='', row.names=F)

# merge to published branch (to display on app)

merge_branches = F

if (merge_branches) {
  # switch to draft branch and get latest
  system('git checkout draft')
  system('git commit -m "committing draft branch"')
  system('git pull')
  # merge published with the draft branch
  system('git checkout published')
  system('git merge draft')
  system('git push origin published')

  # switch to draft branch and get latest
  system('git checkout draft; git pull')
}
