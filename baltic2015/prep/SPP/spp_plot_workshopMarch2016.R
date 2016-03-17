##Plot BD for workshop

#single spp shp file

library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())
library(ggmap)
library(rgdal)
library(RColorBrewer)


#folder location for saving
fileexten="C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/"


Mtruncata = readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles",
                   "Join_Benthic_invertebrates")

colnames(Mtruncata@data)
# [1] "FID_1"      "CELLCODE"   "Abra_prism" "Agrypnetes" "Alderia_mo" "Amauropsis" "Amphipholi" "Atelecyclu" "Boreotroph"
# [10] "Clelandell" "Cliona_cel" "Corophium_" "Corystes_c" "Cryptonica" "Ekmania_ba" "E_clathrat" "E_clathrus" "E_turtonis"
# [19] "Eurydice_p" "Euspira_pa" "G_angulosu" "G_inaequic" "Deshayesor" "H_tenuis"   "H_tubicola" "Hippasteri" "Hippolyte_"
# [28] "I_dorsette" "I_phalangi" "Lekansepha" "Limnoria_l" "Macoma_cal" "M_mutica"   "M_pubipenn" "Modiolus_m" "Monoporeia"
# [37] "Mya_trucat" "Myosotella" "Nucula_nuc" "Orcherstia" "Palaemonet" "Parvicardi" "Pelanoia_c" "Pleurogoni" "Pontoporei"
# [46] "Roxania_ut" "Sabella_pa" "Saduria_en" "Scrobicula" "Skeneopsis" "Solaster_e" "Stomphia_c" "Talitrus_s" "Thia_scute"
# [55] "Upogebia_s" "Vitreolina"



##very large files

print(proj4string(Mtruncata))

Mtruncata2 = spTransform(Mtruncata, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(Mtruncata2))

Mtrun_data = Mtruncata2@data
head(Mtrun_data)
unique(Mtrun_data$FID_1) #thousands of unique

plot(Mtruncata2)

ggplot()+geom_polygon(data=Mtruncata2,aes(x =long, y = lat, fill = id))

ggplot()+geom_point(data=Mtruncata2,aes(x =long, y = lat, fill = id))
