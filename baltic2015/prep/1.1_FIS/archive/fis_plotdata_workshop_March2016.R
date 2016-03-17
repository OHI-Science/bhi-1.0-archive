##Plot FIS data for workshop

library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)
theme_set(theme_bw())
library(rgdal)

#Get Data
#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch accommodation stays data from database
t<-dbSendQuery(con, paste("select * from ICES_fish_ID_assigned;",sep=""))
ices_data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(ices_data) #ICES assessment data
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)



#folder location for saving
fileexten="C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/"

#plot SSB (spawning stock biomass) Cod
cod_data = ices_data%>% filter(Fish =="cod")
windows(30,20)
ggplot(cod_data) +
  geom_point(aes(Year, SSB, color = ICES_subdiv)) +
  ylab("Spawning Stock Biomass")+
  ggtitle("ICES Assessment Data - Cod")+
  scale_x_continuous(breaks=seq(1965,2015,10))+
  facet_wrap(~BHI_ID, scales = "free_y")


#use this
pdf(paste(fileexten,"cod_ices_data.pdf",sep=""), paper = "a4")
ggplot(cod_data) +
  geom_point(aes(Year, SSB, color = ICES_subdiv, size=2)) +
  geom_line(aes(Year, SSB, color = ICES_subdiv))+
  scale_colour_manual(values = c("green", "blue"))+
  ylab("Spawning Stock Biomass")+
  ggtitle("ICES Assessment Data - Cod")+
  scale_x_continuous(breaks=seq(1965,2015,10))
dev.off()

win.metafile(paste(fileexten,"cod_ices_data.wmf",sep=""))
ggplot(cod_data) +
  geom_point(aes(Year, SSB, color = ICES_subdiv, size=2)) +
  geom_line(aes(Year, SSB, color = ICES_subdiv))+
  scale_colour_manual(values = c("green", "blue"))+
  ylab("Spawning Stock Biomass")+
  ggtitle("ICES Assessment Data - Cod")+
  scale_x_continuous(breaks=seq(1965,2015,10))
dev.off()



#plot all spp
windows(30,20)
ggplot(ices_data) +
  geom_point(aes(Year, SSB, color=Fish)) +
  geom_line(aes(Year, SSB, color=Fish)) +
  ylab("Spawning Stock Biomass")+
  ggtitle("ICES Assessment Data - Cod")+
  scale_x_continuous(breaks=seq(1965,2015,10))+
  facet_wrap(~ICES_subdiv, scales = "free_y")



#ICES Shape files
ICESshp = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles",
                   "ICES_areas")
print(proj4string(ICESshp))
ICESshp2 = spTransform(ICESshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(ICESshp2))

#plot
plot(ICESshp2,col="gray") #plots all ICES regions


#Get ICES regions with data
ices_data%>% select(Fish,ICES_subdiv,ICES_ID_start, ICES_ID_end)%>%
                filter(Fish == "cod")%>%
                distinct(ICES_subdiv)

 cod_ices_areas=data.frame(ICES_area = seq(22,32,1))%>%
                mutate(Fish= rep("cod",length(ICES_area)), ICES_subdiv= ifelse(ICES_area <= 24,"22-24","25-32"))

 ices_data%>% select(Fish,ICES_subdiv,ICES_ID_start, ICES_ID_end)%>%
   filter(Fish == "her")%>%
   distinct(ICES_subdiv)

 her_ices_areas=data.frame(ICES_area = c(22,seq(25,32,1),28,30))%>%
   mutate(Fish= rep("her",length(ICES_area)), ICES_subdiv = c("22", rep("25-32",8), "28-1","30"))

 ices_data%>% select(Fish,ICES_subdiv,ICES_ID_start, ICES_ID_end)%>%
   filter(Fish == "spr")%>%
   distinct(ICES_subdiv)

 spr_ices_areas=data.frame(ICES_area = seq(22,32,1))%>%
   mutate(Fish= rep("spr",length(ICES_area)), ICES_subdiv = rep("22-32",length(ICES_area)))

 ices_areas_plot = bind_rows(cod_ices_areas,her_ices_areas,spr_ices_areas)%>%
                  mutate(ICES_area = as.character(ICES_area))%>%
                  mutate(ICES_area=replace(ICES_area,ICES_area=="28","28-1" ))%>%
                  mutate(cols = Fish)%>%
                  mutate(cols=replace(cols, cols=="cod", "blue"))%>%
                  mutate(cols=replace(cols,cols=="her","green"))%>%
                  mutate(cols=replace(cols,cols=="spr","yellow"))


 #merge ICES data with color data
 ICESshp2@data$ICES_area= as.character(ICESshp2@data$ICES_area)
 ICESshp2@data =  right_join(ICESshp2@data,ices_areas_plot,by="ICES_area") #only join areas that have data

 #remove the NA

 ICESshp2_cod = ICESshp2[ICESshp2@data$Fish =="cod",]

 #doesn't work for her or spr??
# ICESshp2_her = ICESshp2[ICESshp2@data$Fish =="her",]
 #ICESshp2_spr = ICESshp2[ICESshp2@data$Fish =="spr",]

###PLOT COD areas
 #replace cod cols
 ICESshp2_cod@data = ICESshp2_cod@data %>% mutate(cols=replace(cols, grepl("22|23|24",ICES_area), "green"))

pdf(paste(fileexten,"cod_areas_ices.pdf",sep=""), paper = "a4")
plot(ICESshp2, col="light gray")
plot(ICESshp2_cod,add=TRUE, col=ICESshp2_cod@data$cols)
legend("topleft", legend = c("22-24", "25-32"), fill=c("green","blue"),bty='n')
mtext("ICES cod assessment regions")
dev.off()

win.metafile(paste(fileexten,"cod_areas_ices.wmf", sep=""))
plot(ICESshp2, col="light gray")
plot(ICESshp2_cod,add=TRUE, col=ICESshp2_cod@data$cols)
legend("topleft", legend = c("22-24", "25-32"), fill=c("green","blue"),bty='n')
mtext("ICES cod assessment regions")
dev.off()

