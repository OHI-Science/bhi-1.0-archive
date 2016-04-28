# Ocean Health Index for the Baltic Sea [bhi]

## Learn More about the Baltic Health Index Project
[BHI at the Stockholm Resilience Centre](http://www.stockholmresilience.org/21/research/research-themes/marine/baltic-health-index.html)  
[BHI at the Baltic Sea Center in English](http://www.su.se/ostersjocentrum/english/baltic-eye/research/baltic-health-index)  
[BHI at the Baltic Sea Center in Swedish] (http://www.su.se/ostersjocentrum/baltic-eye/forskning/baltic-health-index)  

## Explore the BHI in Github
[Data preparation](https://github.com/OHI-Science/bhi/tree/draft/baltic2015/prep)  
[Functions for Calculating Status and Trend](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/conf/functions.R)  


### Build status of branches:

- [**draft**](https://github.com/OHI-Science/bhi/tree/draft)

  [![](https://api.travis-ci.org/OHI-Science/bhi.svg?branch=draft)](https://travis-ci.org/OHI-Science/bhi/branches)

- [**published**](https://github.com/OHI-Science/bhi/tree/published)

  not applicable (since merely a copy of a passing draft branch)  

- [**gh-pages**](https://github.com/OHI-Science/bhi/tree/gh-pages)

  [![](https://api.travis-ci.org/OHI-Science/bhi.svg?branch=gh-pages)](https://travis-ci.org/OHI-Science/bhi/branches)
  
  Note that a "build failing" for this gh-pages branch (ie the website) could simply mean a broken link was found.

- [**gh-pages**](https://github.com/OHI-Science/bhi/tree/app)

  not applicable (because deployment of the Shiny app is done by OHI-Science internally)

For more details, see below and http://ohi-science.org/bhi/docs.

## gh-pages: website

A "build failing" for the gh-pages branch could simply mean broken links were found.

To test the website locally, install [jekyll](http://jekyllrb.com/docs/installation/) and run:

```bash
jekyll serve --baseurl ''
```

To test links, install html-proofer (`sudo gem install html-proofer`) and run:

```bash
jekyll serve --baseurl ''
# Ctrl-C to stop
htmlproof ./_site
```
