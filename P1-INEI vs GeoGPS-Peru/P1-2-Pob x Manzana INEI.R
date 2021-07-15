setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI")

#1. Importamos el df de Nuevo Chimbote
library(readxl)
pobmz <- read_excel("rawdata/VIRGEN - Población - Manzanas INEI 2017 - copia.xlsx", 
                               skip = 5)
head(pobmz)
tail(pobmz)
names(pobmz)

#2.Elegimos las columnas y las filas que tienen la info que nos interesa
pobmz <- pobmz [2:4]
pobmz <- pobmz [1:226536,]

#3. Separamos la columna 'Manzana' para obtener el codigo exacto de cada manzana)
library(tidyr)
library(dplyr)
pobmz_f <- separate(pobmz, Manzana, c("Cod","Reg","Prov","Dist","Ubi"))
names(pobmz_f)

pobmz_f <- select(pobmz_f, 2, 7)

#6. Vemos si hay duplicados y los eliminamos
  #6.1.Buscamos duplicados
  n_occur <- data.frame(table(pobmz_f$Cod)) #crea un marco de datos con una lista de 'Cod' y el nÃºmero de veces que se repiten
  n_occur[n_occur$Freq > 1,] #nos dice quÃ© 'Cod' se repiten
  dup=pobmz_f[pobmz_f$Cod %in% n_occur$Var1[n_occur$Freq > 1],] #devuelve los registros con mÃ¡s de una aparicion
  dup=select(dup,Cod) #Hay 38 duplicados

  #6.2.Eliminamos duplicados
  pobmz_f_ok<-subset(
  pobmz_f,
  ave(Poblacion, #Primero pongo la columna que no quiero que se toque
      Cod,       #Ahora le indico la columna en la que quiero que busque duplicados
      FUN = length) == 1
  )

#7. Le cambiamos el nombre a la columna para luego hacer el match
#con el gdf sin problemas
names(pobmz_f_ok)[1]="Mz"  

#7. Exportamos
library(openxlsx)
write.csv(pobmz_f_ok,"P1-INEI vs GeoGPS-Peru/P1-data/
          3-PobMz_INEI_OK.csv")