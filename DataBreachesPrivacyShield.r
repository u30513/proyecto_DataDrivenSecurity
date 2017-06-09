install.packages("stringdist")
library(stringdist)
Inds <- readRDS("./data/industriesDataFrame.rds")
#OtherInds <- readRDS("./data/OtherEntitiesDataFrame.rds")
PRTotal <- readRDS("./data/PRTotal.rds")
# ELiminar empresas repetidas de Inds y PRTotal
Inds <- Inds[which(!duplicated(Inds$CompanyName)),]
PRTotal <- PRTotal[which(!duplicated(PRTotal$Company)),]
# OtherInds <- OtherInds[which(!duplicated(OtherInds)),]
# Busqueda por Filtro
#IndsPR <- Inds[Inds$CompanyName %in% PRTotal$Company,]
# Busquedas con varias distancias, la maxdist=2 da unos resultados aceptables, ya tiene una tasa de error apreciable,
# pero tambien tiene una tasa de exito a tener en cuenta.
#IndsPRAmatchD1 <-  Inds[which(!is.na(amatch(Inds$CompanyName,PRTotal$Company,maxDist=1))),]
IndsPRAmatchD2 <-  PRTotal[which(!is.na(amatch(PRTotal$Company,Inds$CompanyName,maxDist=2))),]
#IndsPRAmatchD3 <-  Inds[which(!is.na(amatch(Inds$CompanyName,PRTotal$Company,maxDist=3))),]
#IndsPRAmatchD4 <-  Inds[which(!is.na(amatch(Inds$CompanyName,PRTotal$Company,maxDist=4))),]
saveRDS(IndsPRAmatchD2,file="./data/DataBreachesPrivacyShield.rds")




