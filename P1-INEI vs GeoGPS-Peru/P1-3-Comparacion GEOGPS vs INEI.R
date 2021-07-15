setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI/")

library(readr)
pobjuansyo <- read_csv("P1-INEI vs GeoGPS-Peru/P1-data/5-PobJuanSuyo.csv")
pobinei <- read_csv("P1-INEI vs GeoGPS-Peru/P1-data/4-Mzs-Poblacion-Oficial-INEI")

library(dplyr)
pobjuansyo=select(pobjuansyo,Mz,T_TOTAL)
pobinei=select(pobinei,Mz,Poblacion) #son 174362 manzanas en las ciudades
                                     #principales. Pero no todas tienen
                                     #info de poblacion al descargar de 
                                     #REDATAM.
pobinei_<-pobinei%>%
  filter( Poblacion >= 0)            #solo 98486 (56%) tienen info de poblacion

##Queremos ver si estas 984486 manzanas tienen la misma info
##que GeoGPS-Peru. De ser asi, podriamos asumir como vÃ¡lida esa fuente
##y tener poblacion para todas las 174362 manzanas.

#1.Primero uniremos ambas columnas en una sola.

paste_noNA <- function(x,sep=", ") {
  gsub(", " ,sep, toString(x[!is.na(x) & x!="" & x!="NA"] ) ) }
sep="-"

#pobinei_$Comparar <- apply( pobinei_[,c(1:2)],1, paste_noNA,sep=sep)
#pobjuansyo$Comparar <- apply( pobjuansyo[,c(1:2)],1, paste_noNA,sep=sep)
#pobinei_=select(pobinei_,Mz,Poblacion)
#pobjuansyo=select(pobjuansyo,Mz,T_TOTAL)

#2.Unimos a un solo df
names(pobjuansyo)[2]="Poblacion"
prueba=rbind(pobinei_,pobjuansyo)

#3.Ahora eliminamos duplicados.
#Si la info de las 98486 manzanas coincide entre INEI y GeoGPS-Peru, 
#el df 'prueba' deberia arrojar 576444 - 984486 = 477958 manzanas.
library(dplyr)
prueba2 <- prueba %>% distinct

#El resultado es 477864. Es decir, de 98486 manzanas de las que se tiene
#informacion oficial de INEI, 984392 tienen la misma informacion en 
#GeoGPS-Peru. Esto representa el 99.99045%.

#477958-477864=94
#984486-94=984392
#984392/984486*100=99.99045
