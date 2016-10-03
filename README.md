# Ocean Health Index for the Baltic Sea [bhi]

## Learn More about the Baltic Health Index Project
[BHI at the Stockholm Resilience Centre](http://www.stockholmresilience.org/research/research-themes/marine/baltic-health-index.html)  
[BHI at the Baltic Sea Center in English](http://www.su.se/ostersjocentrum/english/baltic-eye/research/baltic-health-index)  
[BHI at the Baltic Sea Center in Swedish] (http://www.su.se/ostersjocentrum/baltic-eye/forskning/baltic-health-index)  

## BHI overview

### Where we work
[The Baltic Sea](https://www.google.se/maps/place/Baltic+Sea/@59.4373514,10.9290745,5z/data=!3m1!4b1!4m5!3m4!1s0x46f4d7d988201b2b:0xb43097ae8474cb3!8m2!3d58.487952!4d19.863281)

### BHI regions
BHI regions are based upon Baltic Sea basins used in the HELCOM HOLAS assessement and the exclusive economic zones of the nations surrounding the Baltic Sea. Each of the 42 BHI regions belongs to a single bio-physcial basin and is associated with a single nation.  

![BHI regions](baltic2015/prep/BHI_regions_plot.png?raw=true)  

## Explore the BHI in Github
[Data preparation](https://github.com/OHI-Science/bhi/tree/draft/baltic2015/prep)  
[Functions for Calculating Status and Trend](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/conf/functions.R)  
[Video on Following BHI progress in Github](https://www.youtube.com/watch?v=u5BRx05Wmwo)



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


