# Clean waters data preparation

There are three sub-components for Clean Water in BHI: *Contaminants, Nutrients,and Trash*. We are using sub-components so that all are weighted equally (and have the same weights across regions) in their contribution to the goal score. Each sub-component, however, will have a unique set of pressures and resilience.  

**Status and Trend**  
Each of the 3 sub-components will have a status calculation that is averaged for an overall goal status. It may not be possible to calculate a trend for each sub-component. In this case, the trend from a single sub-component will be used for the overall status trend.  

## Sub-component prep  
For this goal, sub-components will be prepped from the raw data to status and trend calculations in the prep folders. This is because functions.r requires having values for all regions when data are selected from layers.  Our status calculations are not all done on the region level (some are done by basin, e.g. nutrients (secchi)) and therefore it will not make sense to do the status and trends calculations in functions.r

### Contaminants
[See `contaminants_prep.rmd` for information on indicators, data, and data prep.](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/CW/contaminants/contaminants_prep.md)  

Our intention is to use three equally weighted indicators to capture different dimensions of toxicity: total 6-PCB concentration, dioxin and dioxin-like toxicity equivalent, PFOS.  


### Nutrients
[See `secchi_prep.rmd` for information on indicators, data, and data prep.](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/CW/secchi/secchi_prep.md)  

[See `anoixa_prep.rmd` for information on data and data prep](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/pressures/open_sea_anoxia/open_sea_anoxia_prep.md)

For this goal we will use mean summer secchi (relative to the HELCOM target) and open sea anoxia to measure the nutrient sub-component status and trend.  

### Trash
[See `trash/README.rmd` `trash_prep.rmd` for more details.](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/CW/trash/trash_prep.rmd)  

For this goal we use modelled estimates of mismanaged trash entering the ocean to assess the trash sub-component.  


### Sub-components not included
**Pathogens**
Not identified as a wide-spread problem in the Baltic and not included.  



# Pressure layers currently prepped in CW folder

