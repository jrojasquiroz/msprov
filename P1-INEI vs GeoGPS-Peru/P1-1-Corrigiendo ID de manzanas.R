setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI")

library(readr)
mz_correo <- read_csv("data/Mz_PrincipalesCiudades.csv")
head(mz_correo)

#1.Seleccionamos las columnas que nos interesan
library(dplyr)
mz_correo=select(mz_correo,
                 ID, #para luego hacer el match con el gdf
                 UBIGEO,CODCCPP,CODZONA,
                 SUFZONA,CODMZNA,SUFMZNA)

#2.Uniremos las columnas en una sola. Pero como algunas filas
#de la columna SUFMZNA estan vacias (valores NA) es necesario
#crear una funciÃ³n que las omita.

paste_noNA <- function(x,sep=", ") {
  gsub(", " ,sep, toString(x[!is.na(x) & x!="" & x!="NA"] ) ) }
sep="" #le decimos que tipo de separador queremos. En este caso
#no queremos que haya ni un espacio.

#3.Ahora si creamos la columna que coincidira con los datos que
#bajemos directamente de redatam
library(tidyverse)
mz_correo$Mz <- apply( mz_correo[ , c(2:7) ] #las columnas que nos
                       #interesan estan entre la 2 y
                       #la 7
                       , 1,                    #no sÃ© para quÃ© es esto,
                       #venia en el ejemplo. No tocar.
                       paste_noNA , 
                       sep=sep)
head(mz_correo)

#4.Veamos si hay manzanas repetidas
duplis=data.frame(duplicated(mz_correo$Mz)) #ninguna duplicada

#4.Exportamos
library(openxlsx)
mz_correo2=select(mz_correo,ID,Mz)
write.csv(mz_correo2,"P1-INEI vs GeoGPS-Peru/P1-data/
          2-CodigoManzanasOficial.csv")
