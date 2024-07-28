## ¿Qué hacemos en este cuaderno?
#Defino el periodo de estudio de la investigación. Desde el inicio 
#se tenía claro que sería desde el inicio de la pandemia hasta el final
#de la segunda ola de fallecimientos, por lo que es necesario definir 
#exactamente cuándo termina esta.

#Para ello, se ha seguido la metodología de 
#[Pandey et al. (2022, p. 6)](https://www.nature.com/articles/s42949-022-00071-z).


## Iniciamos
#Al igual que con los cuadernos de Python, es necesario setear un 
#directorio de trabajo.
setwd("G:/Mi unidad/Documentos personales/1-Investigaciones y análisis/Perú una país de provincias/revisión 1")

## Cargo las librerías
library(plotly)
library(ggplot2)
library(dplyr)
library(readr)

## Importamos
#Empezamos cargando el archivo que viene de NOTI-SINADEF con la 
#cantidad de fallecidos diarios en todo el país.
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               ";", escape_double = FALSE, col_types = cols(FECHA_CORTE = col_date(format = "%Y%m%d"), 
                                                                            FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d")), 
                               trim_ws = TRUE)
head(fallecidos_covid)

## Manejamos el dataset
#Creo una columna que asuma que cada fila se cuente como 
#un fallecimiento
fallecidos_covid$Muertes <- rep(1)

#Filtramos datos para que no sean de Lima y Callao
fallecidos_covid <- fallecidos_covid %>%
                    filter(PROVINCIA != "LIMA")%>%
                    filter(PROVINCIA != "CALLAO")

#Obtenemos fallecimientos por fechas
olas<- fallecidos_covid %>%
  group_by(FECHA_FALLECIMIENTO) %>%
  summarise(Muertes=sum(Muertes))

#Graficamos
grafico <- ggplot(olas) +
  aes(x = FECHA_FALLECIMIENTO, y = Muertes) +
  geom_line(size = 0.5, colour = "#112446") +
  theme_minimal()

ggplotly(grafico)

#Ahora que ya tenemos el gráfico, procedemos a reproducir la 
#metodología de Pandey et al. (2022). Para ello será necesario 
#identificar el valor de *h*, *H1* y *h1* de la segunda ola.
olasf <- olas[olas$FECHA_FALLECIMIENTO >= as.Date("2021-08-01") & 
               olas$FECHA_FALLECIMIENTO <= as.Date("2022-01-15"),]

olasf2 <- olas[olas$FECHA_FALLECIMIENTO >= as.Date("2021-03-27") & 
                olas$FECHA_FALLECIMIENTO <= as.Date("2021-06-01"),]

# Obtener la fecha con menor cantidad de contagios
h <- olasf$FECHA_FALLECIMIENTO[which.min(olasf$Muertes)] #10
H1 <- olasf2$FECHA_FALLECIMIENTO[which.max(olasf2$Muertes)] #494

h1 <- 0.05*(494-10)+10 #Tiene que ser mayor o igual al resultado
#El final de la segunda ola de fallecimientos fuera de Lima
#y Callao seria el 2021-08-16 con 34 fallecidos.

#Por tanto, las fechas de corte son el 2020-03-03 (inicio de 
#fallecimientos) y el 2021-08-16 (final de segunda ola).