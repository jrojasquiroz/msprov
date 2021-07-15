setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI/")

library(plotly)
library(ggplot2)
library(dplyr)
library(readr)
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               ";", escape_double = FALSE, col_types = cols(FECHA_CORTE = col_date(format = "%Y%m%d"), 
                                                                            FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d")), 
                               trim_ws = TRUE)
head(fallecidos_covid)

fallecidos_covid$Muertes <- rep(1)

#Obtenemos fallecimientos en todo el país por fechas
olas<- fallecidos_covid %>%
  group_by(FECHA_FALLECIMIENTO) %>%
  summarise(Muertes=sum(Muertes))

#Graficamos
grafico <- ggplot(olas) +
  aes(x = FECHA_FALLECIMIENTO, y = Muertes) +
  geom_line(size = 0.5, colour = "#112446") +
  theme_minimal()

ggplotly(grafico)


#Fecha de corte: 
#PRIMERA OLA: 2020-03-03 hasta 2020-12-01
#SEGUNDA OLA: 2020-12-01 hasta 2021-07-07