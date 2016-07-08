# install_ohicore.r

# Instructions to sucessfully work with the OHI Toolbox
  # 1. Update R. Download the latest version at http://cran.r-project.org.
  # 2. Update RStudio. RStudio is optional, but highly recommended. Download the latest version at http://www.rstudio.com/products/rstudio/download
  # 3. Run the following as a one-time install:

## delete any existing version of `ohicore`
for (p in c('ohicore')){
  if (p %in% rownames(installed.packages())){
    lib = subset(as.data.frame(installed.packages()), Package==p, LibPath, drop=T)
    remove.packages(p, lib)
  }
}

## install dependencies
for (p in c('devtools', 'git2r')){
  if (!require(p, character.only=T)){
    install.packages(p)
    require(p, character.only=T)
  }
}

## install most current version of ohicore -- don't worry about the warnings. But make sure there are no errors.
devtools::install_github('ohi-science/ohicore')
