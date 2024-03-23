library(plotly)
library(ggplot2)
library(dplyr)
library(readr)

#Importamos
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               ";", escape_double = FALSE, col_types = cols(FECHA_CORTE = col_date(format = "%Y%m%d"), 
                                                                            FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d")), 
                               trim_ws = TRUE)
head(fallecidos_covid)

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

#Para calcular final de segunda ola calculamos 
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

#Fecha de corte: 
#PRIMERA OLA: 2020-03-03 hasta 2021-08-16