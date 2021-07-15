##Análisis 2 (AN2)
#Obtenemos (1) Población provincial
#              vs. Fallecidos provinciales
#              Para la primera y segunda ola, y para ambas en conjunto
##Análisis 3 (AN3)
#          (2) Población provincial 
#              vs. Población urbana provincial

#Población provincial   =Población del distrito/Población de la provincia a la
#                        que pertenece.
#Fallecidos provinciales=Fallecidos por Covid-19 en el distrito/Fallecidos
#                        por Covid-19 en toda la provincia a la que pertenece
#Población urbana
#provincial             =Población urbana del distrito/Población urbana
#                        de la provincia a la que pertenece

setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI")
library(ggplot2)
library(dplyr)
library(readr)

###IMPORTAMOS ARCHIVOS NECESARIOS
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               ";", escape_double = FALSE, col_types = cols(FECHA_CORTE = col_date(format = "%Y%m%d"), 
                                                                            FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d")), 
                               trim_ws = TRUE)

pertenencia <- read_csv("rawdata/Distritos Provincias y Departamentos.csv", 
                        col_types = cols(IDPROV = col_double(), 
                                         CCDD = col_double()))
pertenencia=select(pertenencia, CODUBIGEO,IDPROV,CCDD)
names(pertenencia)[1]="UBIGEO"

#1.Para poder hacer una tabla dinamica, añadimos una columna
#que repite siempre el valor 1, que permite contar cada muerte
fallecidos_covid$Muertes <- rep(1)

#2.Identificamos dos nuevos df a partir de fechas de corte
ola1 <- fallecidos_covid %>%
  filter( FECHA_FALLECIMIENTO <= '2020-12-01')

ola2 <- fallecidos_covid %>%
  filter( FECHA_FALLECIMIENTO > '2020-12-01')

#3.Sumamos las muertes por ambas olas
mola1 <- ola1 %>%
  group_by(UBIGEO) %>%
  summarise(Muertes=sum(Muertes))
mola2 <- ola2%>%
  group_by(UBIGEO)%>%
  summarise(Muertes=sum(Muertes))
  #3.1.Les añadimos las provincias a los que pertenecen cada distrito
  mola1=merge(mola1,pertenencia,by="UBIGEO")
  mola2=merge(mola2,pertenencia,by="UBIGEO")

#4.Calculamos cuantas muertes por provincias hay
mprov1 <- mola1 %>%
  group_by(IDPROV) %>%
  summarise(MPROV=sum(Muertes))
mprov2 <- mola2 %>%
  group_by(IDPROV) %>%
  summarise(MPROV=sum(Muertes))

#5.Unimos al df
mola1=merge(mola1,mprov1,by="IDPROV")
mola2=merge(mola2,mprov2,by="IDPROV")

#6.Calculamos que porcentaje representan las muertes distritales
#sobre las muertes provinciales
mola1$MDPROV=mola1$Muertes/mola1$MPROV
mola2$MDPROV=mola2$Muertes/mola2$MPROV

#6.Calculamos el porcentaje de poblacion provincial de cada distrito
library(readxl)
pobd <- read_excel("rawdata/(PROCESADO) Poblacion Urbana y Total-Distritos INEI 2017.xlsx")
head(pobd)

pobd=merge(pobd,pertenencia,by="UBIGEO")

pobp <- read_excel("rawdata/(PROCESADO) Poblacion Total-Provincias INEI 2017.xlsx")

pobd=merge(pobd,pobp,by="IDPROV")
names(pobd)

names(pobd)[4]="PobD"
names(pobd)[7]="PobP"

pobd$PDPROV=pobd$PobD/pobd$PobP
names(pobd)
#7.Unimos en un df las variables que queremos analizar
an2=select(pobd,UBIGEO,PDPROV)

an2_ola1=merge(an2,mola1,by="UBIGEO")
an2_ola1=select(an2_ola1,UBIGEO,PDPROV,MDPROV)

an2_ola2=merge(an2,mola2,by="UBIGEO")
an2_ola2=select(an2_ola2,UBIGEO,PDPROV,MDPROV)

#8.Graficamos
ggplot(an2_ola1) +
  aes(x = PDPROV, y = MDPROV) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(method="lm", se=T) +
  xlab("Poblacion provincial (%)") +
  ylab("Fallecidos provinciales (%)")+
  labs(
    title = "Primera ola",
    subtitle = "A nivel distrital"#,
    #caption = "caption"
  ) +
  ylim(0,1L)+
  theme_minimal()+ #esto le pone el fondo blanco
  theme(axis.title = element_text(size = 17),
        axis.text = element_text(size = 13.5),
        plot.title = element_text(size = 18.5),
        plot.subtitle = element_text(size = 17.5))

ggplot(an2_ola2) +
  aes(x = PDPROV, y = MDPROV) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(method="lm", se=T) +
  xlab("Poblacion provincial (%)") +
  ylab("Fallecidos provinciales (%)")+
  labs(
    title = "Segunda ola",
    subtitle = "A nivel distrital"#,
    #caption = "caption"
  )+
  ylim(0,1L)+
  theme_minimal()+ #esto le pone el fondo blanco
  theme(axis.title = element_text(size = 17),
        axis.text = element_text(size = 13.5),
        plot.title = element_text(size = 18.5),
        plot.subtitle = element_text(size = 17.5))

###Lo que vemos es que en ambas olas las muertes se concentran en aquellos
#distritos con mayor poblacion dentro de su provincia

#9.Ahora calculamos lo mismo pero para ambas olas juntas
dosolas <- fallecidos_covid %>%
  group_by(UBIGEO) %>%
  summarise(Muertes=sum(Muertes))

dosolas=merge(dosolas,pertenencia,by="UBIGEO")

mprov <- dosolas %>%
  group_by(IDPROV) %>%
  summarise(MPROV=sum(Muertes))

dosolas=merge(dosolas,mprov,by="IDPROV")

dosolas$MDPROV=dosolas$Muertes/dosolas$MPROV

an2_dosolas=merge(an2,dosolas,by="UBIGEO")
an2_dosolas=select(an2_dosolas,UBIGEO,PDPROV,MDPROV)

ggplot(an2_dosolas) +
  aes(x = PDPROV, y = MDPROV) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(method="lm", se=T) +
  xlab("Poblacion provincial (%)") +
  ylab("Fallecidos provinciales (%)")+
  labs(
    title = "Primera y segunda ola",
    subtitle = "A nivel distrital"#,
    #caption = "Fuente: NOTI-SINADEFINEI"
  )+
  ylim(0L, 1L)+
  theme_minimal()+ #esto le pone el fondo blanco
  theme(axis.title = element_text(size = 17),
        axis.text = element_text(size = 13.5),
        plot.title = element_text(size = 18.5),
        plot.subtitle = element_text(size = 17.5))

#10.Ahora,¿son los distritos en donde hay mayor poblacion provincial (PDPROV)
#aquellos en los que existe mayor poblacion urbana provincial?
pxd <- read_excel("rawdata/(PROCESADO) Poblacion Urbana y Total-Distritos INEI 2017.xlsx")

names(pxd)
pxd=select(pxd,UBIGEO,PobUrb)

pxd=merge(pxd,pertenencia,by="UBIGEO")

puprov <- pxd %>%
  group_by(IDPROV) %>%
  summarise(PobUrbPROV=sum(PobUrb))

pxd=merge(pxd,puprov,by="IDPROV")

pxd$PUPROV=pxd$PobUrb/pxd$PobUrbPROV

an3=select(pxd,UBIGEO,PUPROV)
an3=merge(an3,pobd)

names(an3)

an3=select(an3,UBIGEO,PUPROV,PDPROV)
an3=merge(an3,pertenencia) #para ubicarnos mejor
names(an3)
an3=select(an3,UBIGEO,IDPROV,PUPROV,PDPROV)

ggplot(an3) +
  aes(x = PDPROV, y = PUPROV) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(method="lm", se=T) +
  xlab("Poblacion provincial (%)") +
  ylab("Poblacion urbana provincial (%)")+
  labs(
    title = "Poblacion total vs. Poblacion urbana",
    subtitle = "A nivel distrital"#,
    #caption = "caption"
  )+
  ylim(0,1L)+
  theme_minimal()+ #esto le pone el fondo blanco
  theme(axis.title = element_text(size = 17),
        axis.text = element_text(size = 13.5),
        plot.title = element_text(size = 18.5),
        plot.subtitle = element_text(size = 17.5))