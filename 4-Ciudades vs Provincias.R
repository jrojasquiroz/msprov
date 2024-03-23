##Analisis 4 (AN4)
#Obtenemos dos df que nos permiten conocer:
#(1)Fallecidos por cada 100.000 habitantes por ciudad*(MPond_Ciud)
#(2)Fallecidos por cada 100.000 habitantes de la provincia a la que
#   pertenece la ciudad* (MPond_Prov)
#(3)Porcentaje que representa la poblaci?n de la ciudad* respecto
#   de la poblaci?n de toda la provincia (PCPROV)
#(4)Diferencia entre (1) y (2) (DIFMP)
#(5)Porcentaje que representa DIFMP sobre MPond_Prov (DIFMP_PR)
#(6)Desfase porcentual entre ciudad y provincia (PR)
#*En realidad es sobre los distritos que conforman las ciudades

#Se excluye a Lima y Callao

{library(ggplot2)
library(dplyr)
library(readr)
library(readxl)
library(plotly)
library(extrafont) #para usar la fuente de letra que yo quiera
}

###IMPORTAMOS ARCHIVOS NECESARIOS
fallecidos_covid <- read_delim("rawdata/fallecidos_covid.csv", 
                               delim = ";", escape_double = FALSE, col_types = cols(FECHA_FALLECIMIENTO = col_date(format = "%Y%m%d"), 
                                                                                    UBIGEO = col_double()), trim_ws = TRUE)
fecha_inicio <- as.Date("2020-03-03")
fecha_fin <- as.Date("2021-08-16")

fallecidos_covid <- subset(fallecidos_covid, FECHA_FALLECIMIENTO >= fecha_inicio & 
                           FECHA_FALLECIMIENTO <= fecha_fin)


pertenencia <- read_csv("rawdata/Distritos Provincias y Departamentos.csv", 
                        col_types = cols(IDPROV = col_double(), 
                                         CCDD = col_double()))
pertenencia=select(pertenencia, CODUBIGEO,IDPROV,CCDD)
names(pertenencia)[1]="UBIGEO"

ciudades <- read_excel("data/ciudades_final.xlsx")
head(ciudades)
ciudades=select(ciudades,CIUDAD,CODUBIGEO)
names(ciudades)[2]="UBIGEO"

#1. Jalamos estos dos archivos que provienen del conteo de Redatam
pobd <- read_excel("rawdata/pobxdist.xlsx")
pobp <- read_excel("rawdata/pobxprov.xlsx")

names(pobd)[1]="UBIGEO"
names(pobd)[2]="PobTot"

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
mxc$MuertesPond=mxc$Muertes/mxc$PobTot*10000
 
#7.Ahora calcularemos las muertes de cada provincia, de manera
#que luego pueda compararse con la de su ciudad principal
fallecidos_covid=merge(fallecidos_covid,pertenencia,by="UBIGEO")

mxp <- fallecidos_covid %>%
  group_by(IDPROV) %>%
  summarise(Muertes=sum(Muertes))

mxp=merge(mxp,pobp,by="IDPROV")

mxp$MPond_Prov=mxp$Muertes/mxp$PobTot*10000

#8.Ahora creamos un df que tenga (1)muertes por ciudad principal y 
#(2)muertes en las provincias en las que las ciudades principales
#se ubican
ciudades=merge(ciudades,pertenencia,by="UBIGEO")
cpertenencia <- ciudades %>% distinct(CIUDAD,IDPROV, .keep_all = TRUE)
cpertenencia=select(cpertenencia,CIUDAD,IDPROV)

an4=merge(mxc,cpertenencia,by="CIUDAD") #Aparecen 91 registros cuando deber?an
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

an4=merge(an4,pxc,by="CIUDAD") #El PobTot final corresponde a la poblacion de
                               #la ciudad.

#11.Me he dado cuenta que en algunas provincias existen mas de una
#ciudad principal. Por tanto, voy a elegir solo a la ciudad principal
#con la tasa de mortalidad mas alta y luego rehacer los graficos.
an4_2<-an4 %>% 
  group_by(IDPROV) %>% 
  top_n(1, MPond_Ciud)

  #11.1. Y ademas calculo un nuevo indicador, que creo que pondera
  #mejor la diferencia de mortalidad entre ciudad y provincia. Este es
  #DIFMP/MPond_Prov
  an4_2$DIFMP_PR=an4_2$DIFMP/an4_2$MPond_Prov
  an4_2$PR=(an4_2$MPond_Ciud-an4_2$MPond_Prov)/an4_2$MPond_Prov*100
  
  
  ####ESTE ES EL GRAFICO FINAL DEL PAPER
  g1<-ggplot(an4_2, aes(reorder(CIUDAD,PR), PR)) +
  geom_bar(stat = "identity", 
           #alpha=0.9, 
           width = 0.75,
           position="identity") +
  coord_flip() +  
  xlab("") +
  ylab("Desfase de la tasa de mortalidad por COVID-19 de la ciudad 
    con la de su provincia (%)")+
    theme_classic()+
    theme(panel.grid.major.x = element_line(color = "#c2c2c2",size=0.3))+
    theme(panel.grid.minor.x = element_line(color = "#c2c2c2",size=0.3))+
    theme(axis.title = element_text(size = 9,family="Work Sans Light"))+
    theme(axis.text = element_text(size=6.5, family="Work Sans Light"))
  
  g1
  ggplotly(g1)
  
  ggsave(
    "data/imagenes/Desfase porcentual.jpg",
    plot = embed_fonts(plot1),
    width = 16,
    height = 16,
    units="cm",
    dpi = 800,
  )
  
  #############

  ######
  #Pob prov. vs. Fallecidos prov. POR CIUDAD
  g2 <- ggplot(an4) +
    aes(x = PCPROV, y = MCPROV) +
    theme_classic() +
    ylim(0, 100L) + xlim(0, 100L) +
    geom_point(aes(size = PobTot), alpha = 0.3) +
    scale_size(range = c(1, 10)) +
    xlab("Población provincial (%)*") +
    ylab("Fallecidos provinciales (%)**") +
    labs(
      caption = "*Población de la ciudad dividido por la población de su provincia\n**Fallecidos por COVID-19 en la ciudad dividido por los fallecidos por COVID-19 en su provincia"
    ) +
    theme(
      axis.title = element_text(size = 9, family = "Work Sans Light"),
      axis.text = element_text(size = 9, family = "Work Sans Light"),
      plot.caption = element_text(size = 9, family = "Work Sans Light", hjust = 0),
      legend.position = "none"
    )
  
  g2
  
  ggsave(
    "data/imagenes/Poblacion vs Fallecidos - Ciudades.jpg",
    plot = g2,
    width = 16,
    height = 16,
    units="cm",
    dpi = 800,
  )
  
  #############  
  #Para ver el tipo de letras que tenemos windowsFonts()

#12. Exporto el resultado para verlo en detalle en Excel
writexl::write_xlsx(an4,"data/an4.xlsx")
writexl::write_xlsx(an4_2,"data/desfase porcentual.xlsx")
  