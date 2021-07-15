##Análisis 1 (AN1)
#Obtenemos (1)Población urbana distrital (total, sin ponderar) vs.
#             Fallecidos distritales (totales, sin ponderar)
#          (2)Población urbana distrital(como % del total de población)
#             vs. Fallecidos distritales (por cada 100.000 habitantes)


setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI/")

library(ggplot2)
library(dplyr)
library(readr)
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               ";", escape_double = FALSE, col_types = cols(FECHA_CORTE = col_date(format = "%Y%m%d"), 
                                                                            FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d")), 
                               trim_ws = TRUE)
head(fallecidos_covid)

#1.Para poder hacer una tabla dinamica, añadimos una columna
#que repite siempre el valor 1, que permite contar cada muerte
fallecidos_covid$Muertes <- rep(1)

#2.Sumamos las muertes por distrito
mxd <- fallecidos_covid %>%
  group_by(UBIGEO) %>%
  summarise(Muertes=sum(Muertes))

#3.Importamos la poblacion por distrito
library(readxl)
pobxdist <- read_excel("rawdata/(PROCESADO) Poblacion Urbana y Total-Distritos INEI 2017.xlsx")
head(pobxdist)

#4.Unimos los df
an1=merge(pobxdist,mxd,by="UBIGEO")

#5.Calculamos las muertes ponderadas por 100.000 hab
an1$MuertesPond=an1$Muertes/an1$PobTot*100000

#6.Graficamos
ggplot(an1) +
  aes(x = PobUrb, y = Muertes) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  labs(x = "Poblacion urbana", y = "Fallecidos por Covid-19") +
  geom_smooth(method="lm", se=T) +
  theme_minimal()
#Esto es con datos totales, no ponderado por poblacion total

ggplot(an1) +
  aes(x = PobUrb_PR, y = MuertesPond) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(method="lm", se=T) +
  labs(x = "Poblacion urbana (%)", y = "Fallecidos por Covid-19 (x100.000 habs)") +
  theme_minimal() +
  ylim(0L, 4000L) +
  xlim(0L,   100L)
#se excluye el distrito 150716 por ser un outlier en el eje Y
