library(package = plyr)
library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

# SETTING CONSTANTS
min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
regr_length = 10       # number of years to use for regression
future_year = 5        # the year at which we want the likely future status
min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!

### read mysql config
# run your personal mysql config script to read in passcode

### MySQL commands
### IMPORTANT: whenever you open a MySQL connection with 'dbConnect' make sure that you close it directly after your querry!!!
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID` from ICES_secchi_ID_assigned;") #  where `HELCOM_COASTAL_CODE` > 0
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

# Load rgn_id file from repository

rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rename(rgn_id, BHI_ID = rgn_id) %>%
  mutate(basin = gsub(" ", "_", substring(label,7)))

# load target levels set by HELCOM ????MOVE THIS DATA TO SERVER????
target <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets.csv", header = TRUE, sep = ",", stringsAsFactors = F)
target <- full_join(target, rgn_id, by = 'basin')

data <- data %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  filter(!is.na(BHI_ID))
sort(unique(data$BHI_ID))

data2 = full_join(data, rgn_id, by = 'BHI_ID') %>%
  mutate(country = paste(substring(label, 1, 3)))
  # full_join(., select(target, -basin, -label), by = 'BHI_ID')
sort(unique(data2$BHI_ID))

summer_secchi_all <-
  data2 %>%
  filter(Month %in% c(6:9)) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin)) %>%
  mutate(status = pmin(1, secchi/target))
sort(unique(summer_secchi_all$BHI_ID))

# val_basin = filter(summer_secchi_all, BHI_ID == 5)
# val_basin$BHI_ID = 6

# function to gapfill region (nodata_BHI_ID) with NA using adjecent region (value_BHI_ID & val_df)
  duplicate.data <- function(value_BHI_ID, val_df, nodata_BHI_ID) {
    temp = filter(val_df, BHI_ID == value_BHI_ID)
    temp$BHI_ID = nodata_BHI_ID
    return(temp)
  }

# Give NA regions data from adjecent basin
#   summer_secchi_all = bind_rows(summer_secchi_all,
#                                 duplicate.data(5, summer_secchi_all, 6),     # DK Sound = SE Sound
#                                 duplicate.data(36, summer_secchi_all, 35),   # SE Aland Sea = FI Aland Sea
#                                 duplicate.data(13, summer_secchi_all, 11))   # SE Arkona = GE Arkona
#
#   summer_secchi_all = filter(summer_secchi_all, label != 'Den - The Sound')

  status_score = summer_secchi_all %>%
    group_by(BHI_ID) %>%
    # summarise_each(funs(last), BHI_ID, status) %>%  # leaves only the last status score in the data frame
    rename(rgn_id = BHI_ID) %>%
    select(rgn_id, year, status) %>%
    filter(year >= min_year) %>%
    ungroup(.)

  unique(status_score$rgn_id)

############ START SOLVING THIS!!!!!!!!!!! ################################
  # find which BHI_ID are missing data and set to NA
  if (anyNA(match(c(1:nrow(rgn_id)), unique(status_score$rgn_id))) == T)
    {
    missing_id = data.frame(rgn_id = which(is.na(match(c(1:nrow(rgn_id)), unique(status_score$rgn_id)))))
    # temp = data.frame(x = missing_id, y = min_year, z = NA)
    # temp = data.frame(colnames(status_score)[1] = missing_id, colnames(status_score)[2] = min_year, colnames(status_score)[3] = NA))
    #     temp = status_score %>%
#       filter(rgn_id == 1) %>%
#       mutate(status = NA, rgn_id = missing_id)
  }

status_score = bind_rows(missing_id, status_score)

#### TEST SECTION TO PREPARE THE TREND CALCULATION TO BE DONE IN FUNCTIONS.R ####
  # Trying to get it to work with dplyr instead of plyr package

 # First as in AO goal in functions.R using plyr
  test = ddply(subset(summer_secchi_all, year >= 2005), .(BHI_ID), function(x)
  {
   if (length(na.omit(x$score)) > 1) {
     # creates data frame d with status score and year only, by BHI_ID
     # tail tells it to use only the last x(5) years of status data in each BHI_ID
     d = data.frame(statusData = x$score, year = x$year)[tail(which(!is.na(x$score)), 5), ]
     # calculates linear trend over the 5 years in d and sets trend score to the extrapolated status score in 5 years from last year of d
     trend = coef(lm(statusData ~ year, d))[['year']] * 5
     } else {
       trend = NA
     }
   return(data.frame(trend = trend))
   })

  # Second trying to do the same thing with dplyr, the code does not build a data frame in test2 (as plyr is doing in test). Instead I only get the last value
 test2 =
   summer_secchi_all %>%
   group_by(BHI_ID) %>%
   filter(year >= 2005) %>%
   (function(x)
     {
     if (length(na.omit(x$score)) > 1) {
       # creates data frame d with status score and year only, by BHI_ID
       # tail tells it to use only the last x(5) years of status data in each BHI_ID
       d = data.frame(statusData = x$score, year = x$year)[tail(which(!is.na(x$score)), 5), ]
       # calculates linear trend over the 5 years in d and sets trend score to the extrapolated status score in 5 years from last year of d
       trend = coef(lm(statusData ~ year, d))[['year']] * 5
     } else {
       trend = NA
     }
     return(data.frame(trend = trend))
   })

 #OK, this works for data with no NA. Added setting min_year, regr_length and future_year outside statement
 # group by rgn_id, then make linear regression over 10 years when there are at least 5 years with data from min_year to max_year
 test3 =
   status_score %>%
   # filter(!is.na(rgn_id)) %>%       # This should already be done before the data comes here
   group_by(rgn_id) %>%
   filter(year >= min_year) %>%
   do(tail(. , n = regr_length)) %>%
   do(mod = lm(status ~ year, data = .)) %>%
   # do(mod = summary(lm(status ~ year, data = .))) %>%         #have not tried this output yet
   mutate(trend_score = summary(mod)$coeff[2] * future_year) %>%
   select(-mod)

 # Allow status_score timeseries to contain NA and/or have timeseries shorter than the min_regr_length (set at top of script)
 # For regions that have data from min_year to with at least min_regr_length data points over the regr_length
 test4 =
   status_score %>%
   group_by(rgn_id) %>%
   mutate(temp = sum(is.na(status))) %>% # just to check, remove once done
   mutate(temp2 = length(status)) %>% # just to check, remove once done
   do(tail(. , n = regr_length)) %>%
   do({if(sum(!is.na(.$status)) >= min_regr_length)
     data.frame(trend = coef(lm(status ~ year, .))[2] * future_year)
     else data.frame(trend = NA)})


#    do(mod = lm(status ~ year, data = .)) %>%
#    #    mutate(trend_score = summary(mod)$coeff[2] * future_year) %>%
#    # select(-mod) %>%
#    mutate(if (sum(is.na(status)) <= 5)
#    {trend = coef(lm(status ~ year, .))[2] * future_year},
#    # {trend = trend_score},
#    if (sum(is.na(status)) > 5){trend_score = NA})


#  do({if(all(is.na(.$v3))|all(is.na(.$v4)))
#    data.frame(slope=NA)
#    else data.frame(slope=coef(lm(v3~v4, .))[2])})

 # do(mod = lm(status ~ year, data = .)) %>%
 # select(-mod) %>%
 # trend_score = summary(mod)$coeff[2] * future_year},
 # select(-mod)
 #    } else {
 #        mutate(trend_score = NA)
 #      }

 #  mutate(if (sum(is.na(status)) <= 5){trend_score = summary(mod)$coeff[2] * future_year},
 #         if (sum(is.na(status)) > 5){trend_score = NA}) %>%


#compare results
windows()
plot(x = test$trend, y = test3$trend_score)

########################## EXAMPLE FROM ECO IN gye REPO ###############################################
#  do(mdl = lm(rev_adj ~ year, data=.)) %>%
#    summarize(
#      weight = weight,
#      rgn_id = rgn_id,
#      sector = sector,
#      # TODO: consider how the units affect trend; should these be normalized? cap per sector or later?
#      sector_trend = pmax(-1, pmin(1, coef(mdl)[['year']] * 5))) %>%
#    # get weighted mean across sectors per region


########################### EXAMPLE CODE FROM AO IN FUNCTIONS.R #######################################
#     # trend
#     r.trend = ddply(subset(ry, year >= year_min), .(region_id), function(x)
#     {
#       if (length(na.omit(x$statusData))>1) {
#         # use only last valid 5 years worth of status data since year_min
#         d = data.frame(statusData=x$statusData, year=x$year)[tail(which(!is.na(x$statusData)), 5),]
#         trend = coef(lm(statusData ~ year, d))[['year']]*5
#       } else {
#         trend = NA
#       }
#       return(data.frame(trend=trend))
#     })
#######################################################################################################

#  write csv files to layers folder ####
#  spara = F
#  if (spara == T)
#  {write.csv(status_score, "~/github/bhi/baltic2015/layers/cw_nu_status.csv", row.names = F)
#    write.csv(summer_secchi_all, "~/github/bhi/baltic2015/prep/8_CW/cw_nu_status.csv", row.names = F)}

#### plot to check data ####

summer_secchi_coastal <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  # mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

summer_secchi_opensea <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

windows()
ggplot(summer_secchi_coastal) +
  geom_point(aes(x = year, y = secchi, color = label)) +
#   geom_point(data = filter(data, HELCOM_COASTAL_CODE > 0), aes(x = Year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~label) +
  ggtitle("Coastal areas")

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi), color = 'blue') +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi), color = 'red') +
  geom_point(data = summer_secchi_all, aes(x = year, y = secchi), color = 'green') +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~label, ncol = 6, drop = F)

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi, color = country)) +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~basin, ncol = 6, drop = F)

windows()
ggplot() +
  geom_point(data = summer_secchi_all, aes(x = year, y = score, color = country)) +
  xlim(2005, 2015) +
  ylim(0,1) +
  facet_wrap(~BHI_ID, ncol = 6, drop = F)

windows()
ggplot() +
  geom_point(data = data2, aes(x = Year, y = secchi, color = as.factor(BHI_ID))) +
  xlim(1995, 2015) +
  ylim(0,1) +
  facet_wrap(~country, ncol = 3, drop = F)
