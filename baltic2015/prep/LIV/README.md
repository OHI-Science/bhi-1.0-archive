# Prep Employment data for LIV goal

## Data

### Data Prep

### Data sources
**Employment rates**
[Eurostat table lfst_r_lfe2emprt](http://ec.europa.eu/eurostat/data/database?p_auth=BgwyNWIM&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=lfst_r_lfe2emprt)

**Parameters Included**  
- Ages 15-64  
- Both sexes  
- Years 1999-2014  
- NUTS0 (country) and NUTS2 (regional)  

Downloaded 31 March 2016  

**Metadata overview**  
The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.   

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonisation, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi_esms, see paragraph 21.1.).  

The EU-LFS is designed to give accurate quarterly information at national level as well as annual information at NUTS 2 regional level and the compilation of these figures is well specified in the regulation. Microdata including the NUTS 2 level codes are provided by all the participating countries with a good degree of geographical comparability, which allows the production and dissemination of a complete set of comparable indicators for this territorial level.  

[Link for more metadata](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm)

**Data flags** 
#Data flags

b 	break in time series  
c 	confidential  
d 	definition differs, see metadata  
e 	estimated  
f 	forecast  
i 	see metadata (phased out)  
n 	not significant  
p 	provisional  
r 	revised  


## Goal model
Xliv = (Employment_Region_c/Employment_Region_r)/(Employment_Country_c/Employment_Country_r)  
* c = current year, r=reference year  
* reference point is a moving window (single year value)  
* Region is the BHI region - number of employed persons associated in the BHI region  
* Each BHI region is composed by one or more NUTS2 regions.  
   * NUTS2 employment percentage multipled by the by population in the 25km inland buffer associated with a BHI region.  Sum across all associated with a BHI region to get the total employed people in the BHI region.
* For Country data, need to also get population size so can have total number of people employed, not percent employed

