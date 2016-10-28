Invasive Species pressure layer prep
================

-   [Layer prep](#layer-prep)

Data: number of invasives species introduction events per country from [Aquanis website](http://www.corpi.ku.lt/databases/index.php/aquanis)

Score = \#\_of\_species\_introduction\_event / reference\_point

Reference point: 10 introduction events. With no additional information, this is an arbitrary number set for now.

Layer prep
----------

``` r
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

source('~/github/bhi/baltic2015/prep/common.r')

dir_invasives = file.path(dir_prep, 'pressures/invasive_spp')

## add a README.md to the prep directory 
create_readme(dir_invasives, 'invasives_prep.rmd')
```

``` r
country_score = read_csv(file.path(dir_invasives, "sp_invasives_raw.csv")) %>% 
  mutate(ref_pt = 10, 
         score = min(1, num_invasive/ref_pt))

#     country num_invasive ref_pt score
# 1   Denmark           37     10     1
# 2   Estonia           34     10     1
# 3   Finland           45     10     1
# 4   Germany           64     10     1
# 5    Latvia           40     10     1
# 6 Lithuania           33     10     1
# 7    Poland           58     10     1
# 8    Russia           82     10     1
# 9    Sweden           49     10     1

bhi_rgn_lookup = read.csv(file.path(dir_prep, "bhi_basin_country_lookup.csv"), sep = ";") %>% 
  select(country = rgn_nam, BHI_ID)

bhi_score = full_join(country_score, bhi_rgn_lookup, by = 'country') %>% 
  select(rgn_id = BHI_ID, 
         pressure_score = score)

write_csv(bhi_score, file.path(dir_layers, "sp_invasives_bhi2015.csv"))
```
