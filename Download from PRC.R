# Este script se descarga en CSV las brechas de seguridad reportadas en la wweb www.privacyrights.org
# y los deja en un archivo rds llamado PRTOLAL.rds dentro de la carpeta ./Data
# Si no existe, crea el directorio "PRdatos" para dejar archivos del proceso y
# el archivo resultado (PRTotal.Rda)
if(!file.exists("data")){
  dir.create("data")
}
setwd("./data")
# Pasar las URL de las consultas por a?os
# Al hacer la consulta de todos los a?os junto da time-out, y se hace en consultas mas ligeras.
URL2017 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=2434"
URL2016 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=2257"
URL2015 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=2122"
URL2014 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=1473"
URL2013 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=1153"
URL2012 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=513"
URL2011 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=306"
URL2010 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=276"
URL2009 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=275"
URL2008 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=274" 
URL2007 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=273"
URL2006 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=272"
URL2005 <- "https://www.privacyrights.org/data-breaches/Privacy_Rights_Clearinghouse-Data-Breaches-Export.csv?title=&breach_type[0]=285&breach_type[1]=268&breach_type[2]=267&breach_type[3]=264&breach_type[4]=265&breach_type[5]=266&breach_type[6]=269&breach_type[7]=270&org_type[0]=260&org_type[1]=262&org_type[2]=261&org_type[3]=259&org_type[4]=257&org_type[5]=258&org_type[6]=263&taxonomy_vocabulary_11_tid[0]=271"
# Descargar los CSV por a?os
download.file(URL2017,destfile = "PR2017.csv")
download.file(URL2016,destfile = "PR2016.csv")
download.file(URL2015,destfile = "PR2015.csv")
download.file(URL2014,destfile = "PR2014.csv")
download.file(URL2013,destfile = "PR2013.csv")
download.file(URL2012,destfile = "PR2012.csv")
download.file(URL2011,destfile = "PR2011.csv")
download.file(URL2010,destfile = "PR2010.csv")
download.file(URL2009,destfile = "PR2009.csv")
download.file(URL2008,destfile = "PR2008.csv")
download.file(URL2007,destfile = "PR2007.csv")
download.file(URL2006,destfile = "PR2006.csv")
download.file(URL2005,destfile = "PR2005.csv")
# Pasar los CSV a R mediante data frames
PR2017 <- read.csv("PR2017.csv")
PR2016 <- read.csv("PR2016.csv")
PR2015 <- read.csv("PR2015.csv")
PR2014 <- read.csv("PR2014.csv")
PR2013 <- read.csv("PR2013.csv")
PR2012 <- read.csv("PR2012.csv")
PR2011 <- read.csv("PR2011.csv")
PR2010 <- read.csv("PR2010.csv")
PR2009 <- read.csv("PR2009.csv")
PR2008 <- read.csv("PR2008.csv")
PR2007 <- read.csv("PR2007.csv")
PR2006 <- read.csv("PR2006.csv")
PR2005 <- read.csv("PR2005.csv")
# Unir los data frames anuales en un unico data frame (PRtotal)
PRtotal <- merge(PR2017,PR2017,all="TRUE")
PRtotal <- merge(PRtotal,PR2016,all="TRUE")
PRtotal <- merge(PRtotal,PR2015,all="TRUE")
PRtotal <- merge(PRtotal,PR2014,all="TRUE")
PRtotal <- merge(PRtotal,PR2013,all="TRUE")
PRtotal <- merge(PRtotal,PR2012,all="TRUE")
PRtotal <- merge(PRtotal,PR2011,all="TRUE")
PRtotal <- merge(PRtotal,PR2010,all="TRUE")
PRtotal <- merge(PRtotal,PR2009,all="TRUE")
PRtotal <- merge(PRtotal,PR2008,all="TRUE")
PRtotal <- merge(PRtotal,PR2007,all="TRUE")
PRtotal <- merge(PRtotal,PR2006,all="TRUE")
PRtotal <- merge(PRtotal,PR2005,all="TRUE")
# Si el equipo no esta en ingles as.Date no reconoce los meses
# Salvamos la variable LC_TIME original del equipo
env_pc <- Sys.getlocale("LC_TIME")
# Cambiamos LC_TIME a ingles
Sys.setlocale("LC_TIME","ENGLISH")
# Formateamos las fechas
PRtotal[,"Date.Made.Public"] <- as.Date(PRtotal[,"Date.Made.Public"],"%b %d, %Y")
# Dejamos el valor de LC_TIME original.
Sys.setlocale("LC_TIME",env_pc)
# Salvamos el data frame
saveRDS(PRtotal, file="PRTotal.RDS")
# Borramos archivos csv temporales PR20??.csv
file.remove(dir(pattern = "PR20[0-9][0-9].csv"))
setwd("..")
