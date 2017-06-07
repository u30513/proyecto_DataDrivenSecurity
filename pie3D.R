library(plotrix)

#Agrupamos y sumamos los sectores
occurences<-table(unlist(getInfo$Industry))

#Ordenamos los resultados de mayor a menor
occurences <- sort(occurences, decreasing = TRUE)

#Creamos los niveles del gráfico
lbls <- c("Information and Communications Technology (39%)", "Not provided by privacyshield.gov (29%)", "Business and Professional Services (15%)", "Healthcare (5%)")

#Generamos el gráfico
pie3D(occurences,labels=lbls,explode=0.5, main="Privacy Shield main Industries")
