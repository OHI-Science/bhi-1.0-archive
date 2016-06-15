##MAR plots for workshop
#libraries
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())
library(ggmap)
library(rgdal)
library(RColorBrewer)

#map of data coverage
#data time series
#status and trend results


#run "mar_data_prep" without exporting csv files
#run Updated_MARgoal_code

#then plot

#folder location for saving
fileexten="C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/"


#plot data
ggplot(harvest_tonnes)+geom_point(aes(factor(year),tonnes),size=2) +
  facet_wrap(~rgn_id, scale="free_y")+
  xlab("Year")+
  ggtitle("Rainbow Trout Production (tons) by BHI Region")+
  scale_x_discrete(breaks=seq(2005,2014,5)) +  #reduce number of years labels shown
ggsave(file=paste(fileexten,"mar_data_timeseries.pdf",sep=""),
       width = 210, height = 297, units = "mm")

ggplot(harvest_tonnes)+geom_point(aes(factor(year),tonnes),size=2) +
  facet_wrap(~rgn_id, scale="free_y")+
  xlab("Year")+
  ggtitle("Rainbow Trout Production (tons) by BHI Region")+
  scale_x_discrete(breaks=seq(2005,2014,5)) +  #reduce number of years labels shown
  ggsave(file=paste(fileexten,"mar_data_timeseries.wmf",sep=""),
         width = 210, height = 297, units = "mm")

#for Map get shape files
#get shape files of bhi regions
shpData = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles",
                  layer="BHI_regions_plus_buffer_25km", stringsAsFactors = FALSE)

#basic plot of shape files
plot(shpData,col="grey")
plot(shpData,col=gray(shpData@data$BHI_ID/42))

proj4string(shpData)
shpData2 = spTransform(shpData, CRS("+init=epsg:4326"))

#plot reprojected data
plot(shpData2,col=gray(shpData@data$BHI_ID/42))

#try with ggplot - does not work
ggplot()+geom_polygon(data=shpData,aes(x =long, y = lat,color=id))
ggplot()+geom_polygon(data=shpData2,aes(x =long, y = lat,fill="id"))

#fortify shape file to data frame and re-associate data,
#shpData2.f = shpData2 %>% fortify(.)%>%data.frame(.)%>%mutate(id=as.integer(id))

#join to score results to plot
# shp_hasdata = right_join(shpData2.f, shpData2@data, by=c("id"="BHI_ID")) %>% #must get the data associated with the shape files (id names)
#   full_join(., scores, by=c("id"="region_id"))%>% #assign scores &trend
#   mutate(score = replace(score, !is.na(score), 1))
#
# ggplot(data=shp_hasdata) + geom_polygon(aes(x =long, y = lat, group=group, fill=score))
#
#get map for ggpmap
#map = get_map(location = c(8.5, 53, 32, 67.5))


#plot a map with bhi areas with data

#get data as 1 or NA and assign colors
col.label = c("blue", "gray")
levels = c(1,NA)
bhi_hasdata = scores%>%select(region_id,score,dimension)%>%
  filter(dimension=="status")%>%
  mutate(score = replace(score, !is.na(score), 1))%>%  #now have either value 1 or NA
  select(region_id,score)%>%
  mutate(cols=score)%>%
  mutate(cols=replace(cols,!is.na(cols),"blue"))%>%
  mutate(cols=replace(cols,is.na(cols), "gray"))

#assign these attributes to the shape file
shpData2@data= full_join(shpData2@data,bhi_hasdata,by=c("BHI_ID"="region_id"))

pdf(paste(fileexten,"mar_data_map.pdf",sep=""),paper="a4")
plot(shpData2, col=shpData2@data$cols)
legend("bottomleft", legend=c("Data","No Data"), fill=c("blue","gray"), bty='n')
mtext("MAR data availability - Rainbow Trout Production")
dev.off()

win.metafile(paste(fileexten,"mar_data_map.wmf",sep=""))
plot(shpData2, col=shpData2@data$cols)
legend("bottomleft", legend=c("Data","No Data"), fill=c("blue","gray"), bty='n')
mtext("MAR data availability - Rainbow Trout Production")
dev.off()


############################
#Plot Results
#this makes sure y axis go from 0-100 for status and -1 - 1 for trend
ylims=data.frame(region_id=as.integer(rep(1,4)),dimension =c("status","status","trend","trend"),score=c(0,100,-1,1))

####Plot Status for all years
#mar_status_score has status from 0-1
windows()
ggplot(mar_status_score)+geom_point(aes(factor(year),status*100),size=2.4) +
  facet_wrap(~rgn_id)+
  scale_x_discrete(breaks=seq(2005,2014,5))+ #reduce number of years labels shown
ggsave(file=paste(fileexten,"mar_status_timeseries.pdf",sep=""),
       width = 210, height = 297, units = "mm")

####Plot Status year and trend value

windows()
ggplot()+
  geom_point(data=ylims, aes(x=region_id, y= score), color = "white", size=0, show.legend=FALSE)+
  geom_point(data=scores,aes(x=region_id,y=score, color=factor(region_id),size=3)) +
    ggtitle("Status and trend scores Subgoal = MAR") +
  facet_wrap(~dimension, ncol=2, drop=FALSE,scales="free")+
  ggsave(file=paste(fileexten,"mar_status_trend.pdf",sep=""),
         width = 210, height = 297, units = "mm")


#plot map with status value
shpData2_status= shpData2
shpData2_status@data =  full_join(shpData2_status@data,filter(scores, dimension=="status"),by=c("BHI_ID"="region_id"))



pdf(paste(fileexten,"mar_data_map.pdf",sep=""),paper="a4")
plot(shpData2, col=shpData2@data$cols)
legend("bottomleft", legend=c("Data","No Data"), fill=c("blue","gray"), bty='n')
mtext("MAR data availability - Rainbow Trout Production")
dev.off()

