library(ggmap)
library(ggplot2)


#Fichero de datos (sin lon ni lat)
getInfo <- readRDS("./PrivacyShieldShiny/data/generalInfo.rds")

#Guardamos la columna necesaria y extraemos Valores nulos
getCities <- getInfo$City[!is.na(getInfo$City)]

#Obtenemos Lon y Lat de los elementos mediante queries de Google
locationCities <- geocode(as.character(getCities), source = 'google')

#Guardamos la información en un fichero RDS
saveRDS(locationCities, file="PrivacyShieldShiny/data/Location.rds")