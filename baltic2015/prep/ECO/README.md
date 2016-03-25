# Prep GDP data for ECO goal

## Data

### Regional Data

`GDP_prep.R` prepares data; requires access to BHI database. 

Prepping Eurostat regional (NUTS3) GDP data for Eco sub-goal
current data (02/19/2016) are nominal GDP data. Currently does not include full German time series. 

Eurostat Database names
 
- [nama_10r_3gdp](http://ec.europa.eu/eurostat/data/database?p_auth=EgN81qAf&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=nama_10r_3gdp)


### Country Level data
Prepping Eurostat Country GDP data for Eco sub-goal
current data (downloaded 03-22-2016) are nominal GDP data. 

Eurostat Database names
 -[nama_10_gdp](http://ec.europa.eu/eurostat/data/database?p_auth=sHLAepWT&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=nama_10_gdp)
 
`GDP_prep_countrydata.R` prepares data


## Goal Model

'Xeco = (GDP_Region_c/GDP_Region_r)/(GDP_Country_c/GDP_Country_r)  
'c = current year, r=reference year  '
'reference point is a moving window (single year value)
'Region is the BHI region which is comprised of GDP data from the associated NUTS3 regions
'data can be in nominal GDP because is a ratio value (adjusting by a deflator would cancel out)  
'each BHI region is composed by one or more NUTS3 regions, these are allocated by population density from each NUTS3 region associated with a given BHI region

## Considerations

Data from each NUTS3 region assigned to BHI region by equally splitting NUTS3 value by number of associated BHI_IDs. This needs to be updated to allocate by the fraction of the population density in the NUTS3 area associated with the BHI_ID (within the 25km inland buffer)
