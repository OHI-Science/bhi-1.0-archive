## PCB data prep

##script started by Lena Viktorsson



library(dplyr)
library(tidyr)
library(RMySQL)
library(ggplot2)

# --------------

#run your personal mysql config script to read in passcode

### MySQL commands
### IMPORTANT: whenever you open a MySQL connection with 'dbConnect' make sure that you close it directly after your querry!!!
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from filtered_merged_pcb_ID_assigned;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

# set date format, filter and select columns
map_data_pcb = filter(data, Year > 2000) %>%
  distinct(Latitude, Longitude) %>%
  select(BHI_ID, Source, Country, Station, Longitude, Latitude, Year, Date, Species, Variable, Value, Unit, TEF.adjusted.value)

pcb = data %>%
  mutate(Date2 = as.Date(Date, "%Y-%m-%d")) %>%
  # filter(Year > 2000) %>%
  select(Source, Country, Station, Year, Date2, BHI_ID, Species, Variable, Value, Unit, TEF.adjusted.value)



# write.csv(pcb, "~/github/bhi/baltic2015/prep/8_CW/pcb_temp.csv", row.names = F)

#### Plot to check data ####
# NOTES and QUESTIONS:
# High reported PCB values from ICES for BHI_ID 17 (Poland), can not be correct in relation to other data
# Incomplete data coverage, most data are from Swedish or Finish waters
# How do we work with the different CBXX variables, should they be summed?

unique(pcb$Variable)

cbPalette = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


# plot data in map
library('ggmap')
map = get_map(location = c(8.5, 53, 32, 67.5))


windows()
ggmap(map) +
  # ggplot() +  # also produces map, but unprojected points and no background.
  geom_point(data = filter(map_data), aes(x = Longitude, y = Latitude, color = Source), size = 3) +
  ggtitle('PCB data, from 2000-') +
  theme(title = element_text(size = 14),
        plot.title = element_text(size = 14, face = "bold")) +
  ggsave(file="C:/Users/lvikt/Dropbox/Baltic Health Index/Presentations, ppts/figures/figuresMarch2016_WS/CW_CON_map_pcb.pdf",
         width = 210, height = 297, units = "mm")

windows()
pcb %>% #filter(Source == "ICES") %>% #!grepl('P', Variable),
ggplot() +
  geom_point(aes(x = Date2, y = Value, colour = Variable, shape = Unit)) +
  facet_wrap(~BHI_ID, scales = "free_y")

windows()
pcb %>%
  ggplot() +
  aes(x = Date2, y = Value, colour = as.factor(BHI_ID), shape = Unit) +
  geom_point() +
  facet_wrap(~Variable, scales = "free_y")

## plot tef adjusted values
temp = filter(pcb, Year >= 2000)
if (anyNA(match(c(1:42), unique(temp$BHI_ID))) == T)
{    missing_id = data.frame(BHI_ID = which(is.na(match(c(1:42), unique(temp$BHI_ID))))) }
temp = bind_rows(missing_id, temp)

windows()
  ggplot() +
  geom_point(data = filter(pcb, Year >= 2000),
             aes(x = Year, y = TEF.adjusted.value, colour = Source), size = 2) +
#     geom_point(data = filter(pcb, Year >= 2000),
#                aes(x = Date2, y = Value, colour = 'Value'), shape = 1, size = 1) +
#     scale_color_manual('Type', values = c('tef' = cbPalette[2], 'value' = cbPalette[3])) +
    ylim(0, 0.03) +
    facet_wrap(~BHI_ID, ncol = 7) +
    ggtitle('PCB data, TEF adjusted') +
    theme(title = element_text(size = 14),
          plot.title = element_text(size = 14, face = "bold")) +
    ggsave(file="C:/Users/lvikt/Dropbox/Baltic Health Index/Presentations, ppts/figures/figuresMarch2016_WS/CW_CON_pcb_time_series_zoomY.pdf",
           width = 210, height = 297, units = "mm")
