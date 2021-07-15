##Análisis 4 (AN4)
#Obtenemos dos df que nos permiten conocer:
#(1)Fallecidos por cada 100.000 habitantes por ciudad*(MPond_Ciud)
#(2)Fallecidos por cada 100.000 habitantes de la provincia a la que
#   pertenece la ciudad* (MPond_Prov)
#(3)Porcentaje que representa la población de la ciudad* respecto
#   de la población de toda la provincia (PCPROV)
#(4)Diferencia entre (1) y (2) (DIFMP)
#(5)Porcentaje que representa DIFMP sobre MPond_Prov (DIFMP_PR)
#*En realidad es sobre los distritos que conforman las ciudades

#1.Uno de los df es para todas las ciudades (an4, que tiene hasta el paso 4)
#2.El otro es solo para las ciudades con el indicador de mortalidad
#  más alto de cada provincia (an4_2, que tiene hasta el paso 5)

#En ambos casos se excluye a Lima Metropolitana (que incluye provincia de
#Lima y Callao)

setwd("G:/Mi unidad/Documentos personales/Muertes Covid-19 por Áreas urbanas - Perú/1-Cálculos previos con límites INEI")
library(ggplot2)
library(dplyr)
library(readr)
library(readxl)

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

ciudades <- read_csv("data/6-ciudades_final.csv", 
                     col_types = cols(CODDPTO = col_double(), 
                                      IDPROV = col_double()))
head(ciudades)
ciudades=select(ciudades,CIUDAD,CODUBIGEO)
names(ciudades)[2]="UBIGEO"

pobd <- read_excel("rawdata/(PROCESADO) Poblacion Urbana y Total-Distritos INEI 2017.xlsx")

pobp <- read_excel("rawdata/(PROCESADO) Poblacion Total-Provincias INEI 2017.xlsx")

#1.Primero jalamos los datos de pob por distrito
pobd=select(pobd,UBIGEO,PobTot)

#2.Ahora unimos fallecidos y ciudades a las que pertenecen
fallecidos_covid$Muertes=rep(1)
mxc=merge(fallecidos_covid,ciudades,by="UBIGEO")

#3.Agrupamos muertes por ciudad
mxc <- mxc %>%
  group_by(CIUDAD) %>%
  summarise(Muertes=sum(Muertes))

#4.Calculamos poblacion x ciudad
pxc=merge(pobd,ciudades,by="UBIGEO")

pxc <- pxc %>%
  group_by(CIUDAD) %>%
  summarise(PobTot=sum(PobTot))

#5.Unimos lo obtenido en pasos 3 y 4 para ponderar fallecidos
mxc=merge(mxc,pxc,by="CIUDAD")
mxc$MuertesPond=mxc$Muertes/mxc$PobTot*100000

#6.Excluiremos de los analisis a LIMA METROPOLITANA
mxc <- mxc %>%
  filter(CIUDAD != "LIMA METROPOLITANA Y CALLAO")

#7.Ahora calcularemos las muertes de cada provincia, de manera
#que luego pueda compararse con la de su ciudad principal
fallecidos_covid=merge(fallecidos_covid,pertenencia,by="UBIGEO")

mxp <- fallecidos_covid %>%
  group_by(IDPROV) %>%
  summarise(Muertes=sum(Muertes))

mxp=merge(mxp,pobp,by="IDPROV")

mxp$MPond_Prov=mxp$Muertes/mxp$PobTot*100000

#8.Ahora creamos un df que tenga (1)muertes por ciudad principal y 
#(2)muertes en las provincias en las que las ciudades principales
#se ubican
ciudades=merge(ciudades,pertenencia,by="UBIGEO")
cpertenencia <- ciudades %>% distinct(CIUDAD,IDPROV, .keep_all = TRUE)
cpertenencia=select(cpertenencia,CIUDAD,IDPROV)
cpertenencia <- cpertenencia %>%
  filter(CIUDAD != "LIMA METROPOLITANA Y CALLAO")

an4=merge(mxc,cpertenencia,by="CIUDAD") #Aparecen 91 registros cuando deberían
                                        #ser solo 90. Esto pasa pq Huancayo
                                        #agarra por poco a dos provincias. Aunque
                                        #se ubica principalmente en la 1201.
                                        #Por tanto, eliminamos la 1209
an4 <- an4 %>%
  filter(IDPROV != 1209)

an4 <- an4 %>%
  select(CIUDAD,Muertes,MuertesPond,IDPROV) 

names(an4)[2]="M_Ciud"
names(an4)[3]="MPond_Ciud"

an4=merge(an4,mxp,by="IDPROV")
names(an4)

an4=select(an4,CIUDAD,M_Ciud,MPond_Ciud,IDPROV,Muertes,MPond_Prov)
names(an4)[5]="M_Prov"

#9.Creo que hay algo que aun falta: el porcentaje de poblacion provincial
#que vive en estas ciudades (en realidad, en los distritos en los que
#se ubican estas ciudades)
pobc=merge(ciudades,pobd,by="UBIGEO")

pobc <- pobc %>%
  group_by(CIUDAD) %>%
  summarise(PobCiud=sum(PobTot))

cpertenencia <- cpertenencia %>%
  filter(IDPROV != 1209)

pobc=merge(pobc,cpertenencia,by="CIUDAD")

pobc=merge(pobc,pobp,by="IDPROV")
names(pobc)
names(pobc)[4]="PobProv"

pobc$PCPROV=pobc$PobCiud/pobc$PobProv*100

#10.Ahora si unimos lo obtenido en el paso 9 al df 'an4'
an4=merge(an4,pobc,by="CIUDAD")
names(an4)

an4=select(an4,CIUDAD,M_Ciud,MPond_Ciud,
           IDPROV.x,M_Prov,MPond_Prov,PCPROV)

names(an4)[4]="IDPROV"

an4$DIFMP=an4$MPond_Ciud-an4$MPond_Prov
an4$MCPROV=an4$M_Ciud/an4$M_Prov*100

#11.Graficamos
ggplot(an4, aes(reorder(CIUDAD,DIFMP),MPond_Prov)) +
  geom_segment( aes(x=CIUDAD, xend=CIUDAD, y=MPond_Prov, yend=MPond_Ciud), color="grey") +
  geom_point( aes(x=CIUDAD, y=MPond_Prov), color=rgb(0.2,0.7,0.1,0.5), size=3 ) +
  geom_point( aes(x=CIUDAD, y=MPond_Ciud), color=rgb(0.7,0.2,0.1,0.5), size=3 ) +
  coord_flip()+
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("")

ggplot(an4, aes(reorder(CIUDAD,DIFMP), DIFMP)) +
  geom_bar(stat = "identity") +
  theme(text = element_text(size=6.5)) +
  coord_flip()

ggplot(an4) +
  aes(x = PCPROV, y = an4$MPond_Ciud/an4$MPond_Prov) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  geom_smooth(span = 0.75) +
  theme_minimal()

#12.Me he dado cuenta que en algunas provincias existen mas de una
#ciudad principal. Por tanto, voy a elegir solo a la ciudad principal
#con la tasa de mortalidad mas alta y luego rehacer los graficos.
an4_2<-an4 %>% 
  group_by(IDPROV) %>% 
  top_n(1, MPond_Ciud)

  #11.1. Y ademas calculo un nuevo indicador, que creo que pondera
  #mejor la diferencia de mortalidad entre ciudad y provincia. Este es
  #DIFMP/MPond_Prov
  an4_2$DIFMP_PR=an4_2$DIFMP/an4_2$MPond_Prov
  
  library(plotly)
  
  ggplot(an4_2, aes(reorder(CIUDAD,DIFMP_PR), DIFMP_PR)) +
  geom_bar(stat = "identity") +
  coord_flip() +  
  xlab("") +
  ylab("(Mortalidad de la ciudad principal - Mortalidad de la provincia) ÷ Mortalidad de la provincia")+
    theme_minimal()+ #esto le pone el fondo blanco
    theme(axis.title = element_text(size = 14))+
    theme(axis.text = element_text(size=6.3))
  
  #11.2. Hacemos algunos gráficos adicionales
  ggplot(an4, aes(reorder(CIUDAD,PCPROV), PCPROV)) +
    geom_bar(stat = "identity") +
    coord_flip() +  
    xlab("") +
    ylab("Población provincial (%)")+
    theme_minimal()+ #esto le pone el fondo blanco
    theme(axis.title = element_text(size = 14))+
    theme(axis.text = element_text(size=6.3))
  
  
  ggplot(an4, aes(reorder(CIUDAD,MCPROV), MCPROV)) +
    geom_bar(stat = "identity") +
    coord_flip() +  
    xlab("") +
    ylab("Fallecidos provinciales (%)")+
    theme_minimal()+ #esto le pone el fondo blanco
    theme(axis.title = element_text(size = 14))+
    theme(axis.text = element_text(size=6.3))
  
  ggplot(an4) +
    aes(x = PCPROV, y = MCPROV) +
    geom_point(shape = "circle", size = 1.5, colour = "#112446") +
    theme_minimal()+
    geom_smooth(method="lm", se=T)+
    ylim(0,100L)+xlim(0,100L)+
    xlab("Poblacion provincial (%)") +
    ylab("Fallecidos provinciales (%)")+
    labs(
      title = 
        "¿Aquellas ciudades que acumulan población provincial también acumulan fallecimientos
por Covid-19?")+
    theme(axis.title = element_text(size = 17),
          axis.text = element_text(size = 13.5),
          plot.title = element_text(size = 18.5))
  
  head(an4)
  