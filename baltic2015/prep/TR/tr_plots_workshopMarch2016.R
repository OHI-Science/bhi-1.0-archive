#TR plots - Workshop March 2016

#run the accommodation_stays_prep.r

#folder location for saving
fileexten="C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/"

theme_set(theme_bw()) #set ggplot theme

#save pdf
ggplot(bhi_coast_accom_total)+geom_point(aes(YEAR,BHI_stays_total)) +
  facet_wrap(~BHI_ID, scales="free")+
  ggtitle('BHI Coastal Total Nights Accommodation') +
  ylab("Total Nights")+
scale_x_continuous(breaks=seq(1990,2015,10)) +  #reduce number of years labels shown
ggsave(file=paste(fileexten,"tr_data_bhi_timeseries.pdf",sep=""),
       width = 297, height = 210, units = "mm")

#save windows metafile
ggplot(bhi_coast_accom_total)+geom_point(aes(YEAR,BHI_stays_total)) +
  facet_wrap(~BHI_ID, scales="free")+
  ggtitle('BHI Coastal Total Nights Accommodation') +
  ylab("Total Nights")+
  scale_x_continuous(breaks=seq(1990,2015,10)) +  #reduce number of years labels shown
  ggsave(file=paste(fileexten,"tr_data_bhi_timeseries.wmf",sep=""),
         width = 297, height = 210, units = "mm")


#plot percent coastal from NUTS1
#save pdf
ggplot(accom.coast.bhi)+
  geom_point(aes(factor(NUTS1_ID),(PERCENT_CST_MEAN*100),size=3), show.legend=FALSE)+
  ylab("Percent Coastal Stays")+
  xlab("NUTS2 Region ID")+
  ggsave(file=paste(fileexten,"tr_percent_coastal_nuts1.pdf",sep=""),
         width = 297, height = 210, units = "mm")

#save metafile
ggplot(accom.coast.bhi)+
  geom_point(aes(factor(NUTS1_ID),(PERCENT_CST_MEAN*100),size=3), show.legend=FALSE)+
  ylab("Percent Coastal Stays")+
  xlab("NUTS2 Region ID")+
  ggsave(file=paste(fileexten,"tr_percent_coastal_nuts1.wmf",sep=""))



#plot NUTS2 Regions to show where we have data
library(rgdal)


#BHI Data
BHIshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles",
                 "BHI_regions_plus_buffer_25km")

#NUTS2 Data
NUTS2shp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles",
                   "COAST_NUTS2_reprojected")


print(proj4string(BHIshp))
print(proj4string(NUTS2shp))

BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp2))

NUTS2shp2 = spTransform(NUTS2shp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(NUTS2shp2))


#plot pdf
pdf(paste(fileexten,"nuts2_bhi_regions.pdf", sep=""),paper="a4")
plot(NUTS2shp2,col="gray")
text(NUTS2shp2@data$NUTS_ID, col="black")
plot(BHIshp2, add =TRUE, col="light blue")
legend("bottomleft", legend=c("NUTS2","BHI"), fill=c("gray","light blue"), bty='n')
mtext("NUTS2 regions & BHI regions")
dev.off()

#plot metafile
win.metafile(paste(fileexten,"nuts2_bhi_regions.wmf", sep=""))
plot(NUTS2shp2,col="gray")
text(NUTS2shp2@data$NUTS_ID, col="black")
plot(BHIshp2, add =TRUE, col="light blue")
legend("bottomleft", legend=c("NUTS2","BHI"), fill=c("gray","light blue"), bty='n')
mtext("NUTS2 regions & BHI regions")
dev.off()




#still does not plot with ggplot
windows()
ggplot() +
  geom_polygon(data=BHIshp2,aes(x =long, y = lat, fill = id))

windows()
ggplot() +
  geom_polygon(data=NUTS2shp2,aes(x =long, y = lat, fill = id))
