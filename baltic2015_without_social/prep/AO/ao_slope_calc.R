##-------------------------------------##
## TREND CALCULATIONS FOR AO STATIONS
#--------------------------------------##

##*******************##
## BACKGROUND

## CPUE time series are available for all stations used for the HELCOM coastal fish populations
## core indicators. These data were provided by Jens Olsson (FISH PRO II project). To calculate GES status,
## full time series were used. Therefore, only one status time point and cannot calculate trend of status
## over time. Instead, follow approach from Bergström et al 2016, but only focus on the final time period
## for the slope (2004-2013)

## Bergstrom et al. 2016. Long term changes in the status of coastal fish in the Baltic Sea. Estuarin,
## Coast and Shelf Science. 169:74-84

##*******************##
## METHOD
## 1.Select final time period of trend assessment (2004-2013)
## 2. Use time series from both indicators, Key Species and Functional groups. For functional groups,
##    include both cyprinid and piscivore time series.
## 3. For each time series:  square-root transform data, z-score, fit linear regression, extract slope
## 4. Within each time series group (key species, cyprinid, piscivore), take the mean slope for each group
##    within each basin
## 5. Within each basin take a mean functional group indicator slope (mean of cyprinid mean and piscivore mean)
## 6. For each basin take overall mean slope - mean of key species and functional group
## 7. Multiple by five for future year value?
## 8. Apply trend value for basin to all BHI regions (except in Gulf of Finland, do not apply Finnish site value
##    to Estonia and Russian regions.)

##*******************##
## IN THIS CODE
## Do steps 1-3 in this code, export slopes for each monitoring area. Slopes added to level 1
##  in database, extract slopes from database and finish up steps 4-8 in the ao_prep.rmd file
## Steps 1-3 are done here because we do not have permission to share the raw CPUE data.

##-------------------------------------##
## FILE SETUP
#--------------------------------------##
source('~/github/bhi/baltic2015/prep/common.r')
library(broom)
## set additional directories
dir_ao    = file.path(dir_prep, 'AO')


##-------------------------------------##
## DATA PREP
#--------------------------------------##
## Read in data
## TO DO - need data in database then update read in

cpue = read.csv('C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/DataDownloads/AO/ao_coastal_fish_cpue.csv',
sep=";")

dim(cpue)
str(cpue)
head(cpue)
tail(cpue)


## Select years 2004-2013
cpue = cpue %>%
        filter(year >= 2004 & year <= 2013)
cpue %>% select(year) %>% min()
cpue %>% select(year) %>% max()

## Plot raw data

ggplot(filter(cpue,core_indicator=="Key Species")) +
  geom_point(aes(year,cpue))+
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Key Species CPUE")

ggplot(filter(cpue,taxa=="Cyprinids")) +
  geom_point(aes(year,cpue))+
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Functional Group Cyprinids CPUE")

ggplot(filter(cpue,taxa=="Piscivores")) +
  geom_point(aes(year,cpue))+
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Functional Group Piscivores CPUE")

##-------------------------------------##
## DATA TRANSFORMATION
#--------------------------------------##

## square root transform and zscore each time series

cpue_trans = cpue %>%
              mutate(cpue_sqrt = sqrt(cpue))%>% ## square root transform the data
              group_by(Basin_HOLAS,Basin_assessment, country, monitoring_area,core_indicator,taxa) %>%
              mutate(cpue_mean = mean(cpue_sqrt, na.rm=TRUE),
                     cpue_sd = sd(cpue_sqrt, na.rm=TRUE),
                     cpue_z = ((cpue_sqrt - cpue_mean)/cpue_sd)) %>% ## zscore the transformed data, each time series zscored to itself
              ungroup()
cpue_trans

## check zscore  mean should = 0, sd should = 1
cpue_trans %>% select(monitoring_area,core_indicator,taxa,cpue_z)%>%
          group_by(monitoring_area,core_indicator,taxa)%>%
          summarise(mean_check = mean(cpue_z, na.rm=TRUE),
                    sd_check = sd(cpue_z, na.rm=TRUE)) %>%
          ungroup()%>%
          print(n=140)
    ##means are all very small values near to zero,sd are 1


## Plot sqrt transformed and zscored data
ggplot(filter(cpue_trans,core_indicator=="Key Species")) +
  geom_point(aes(year,cpue_z))+
  geom_hline(yintercept =0) +
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Key Species CPUE Sqrt Zscore")

ggplot(filter(cpue_trans,taxa=="Cyprinids")) +
  geom_point(aes(year,cpue_z))+
  geom_hline(yintercept =0) +
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Functional Group Cyprinids CPUE Sqrt Zscore")

ggplot(filter(cpue_trans,taxa=="Piscivores")) +
  geom_point(aes(year,cpue_z))+
  facet_wrap(~monitoring_area, scales="free_y")+
  ggtitle("Functional Group Piscivores CPUE Sqrt Zscore")


##-------------------------------------##
## FIT LM, extract slope
#--------------------------------------##
library(broom)

cpue_mdl = cpue_trans %>%
            select(Basin_HOLAS, country, monitoring_area,core_indicator,taxa, year, cpue_z)%>%
            group_by(Basin_HOLAS, country, monitoring_area,core_indicator,taxa) %>%
            do(mdl = lm(cpue_z ~ year, data = .)) %>%             # regression model to get the trend
            summarize(Basin_HOLAS =Basin_HOLAS,
                      country= country,
                      monitoring_area = monitoring_area,
                      core_indicator = core_indicator,
                      taxa = taxa,
                      slope = coef(mdl)['year'],
                      r2 = as.numeric(summary(mdl)['r.squared']),
                      nobs=nrow(augment(mdl)))%>%  ## augment() is from the broom library, extracts fits including data, rows of output matches number of obs used
            ungroup()

## Is the number of observations ever less than 5 for lm?
cpue_mdl %>% select(nobs) %>% min()  ## no min value is 5

## plot slope extracted with number of observations
ggplot(cpue_mdl) +
  geom_point(aes(Basin_HOLAS, slope,
                 colour=monitoring_area,shape=core_indicator,label=nobs),size=2)+
  geom_hline(yintercept =0) +
  geom_text(aes(Basin_HOLAS, slope,label=nobs),size=2)+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  guides(colour = "none") +
  ggtitle("lm slopes 2004-2013")


## plot without number of observations
ggplot(cpue_mdl) +
  geom_point(aes(Basin_HOLAS, slope,
                 colour=monitoring_area,shape=core_indicator),size=2)+
  geom_hline(yintercept =0) +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  guides(colour = "none") +
  ggtitle("lm slopes 2004-2013")


##-------------------------------------##
## SAVE AS CSV
#--------------------------------------##
str(cpue_mdl)

write.csv(cpue_mdl, file.path(dir_ao, 'ao_data_database/ao_cpue_slope.csv'), row.names=FALSE)
