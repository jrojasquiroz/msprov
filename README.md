# Medidas sanitarias a nivel provincial, ¿un análisis correcto?
### Introducción

Por el momento, las medidas sanitarias que dicta el Gobierno Central se
hacen a nivel provincial, excepto por Lima Metropolitana. Entiendo que, debido a eso, los análisis que se realizan
para tomar estas decisiones se hacen al mismo nivel espacial.

![PCM-alerta-moderada](https://user-images.githubusercontent.com/34352451/125891745-34e73c7c-e8ad-41a3-ac3c-299fffccb922.png)

Sin embargo, no estoy tan seguro de que eso tenga sentido. A diferencia de Lima Metropolitana, en las demás provincias del país la población no comparte una única mancha urbana, sino que se distribuye de manera separada, como se puede ver en la siguiente imagen. De esta manera, el hecho de que dos distritos estén juntos no implica necesariamente que el flujo de personas, actividades y mercancías sea tan constante como lo puede ser en los distritos que conforman Lima Metropolitana. Y, por tanto, es posible que los patrones de contagios y muertes tampoco.

![SantaVSLima](https://user-images.githubusercontent.com/34352451/125891888-66edf6f9-bd02-4f59-957f-8902f030be68.jpeg)

![manchas urbanas aleatorias](https://user-images.githubusercontent.com/34352451/125897029-1a395281-be68-41bc-a182-98bffecc442b.jpeg)

¿Eso tiene relevancia para evaluar la situación sanitaria de una provincia? Mi impresión es que sí, porque los fallecidos por Covid-19 se suelen concentrar en entornos urbanos, posiblemente por condiciones propias de estos: actividades económicas en espacios cerrados, tugurización, o mayor movilidad de personas hacia el interior de estas y por tanto mayor aglomeración en comparación con entornos rurales.

![Poblacion urbana vs Fallecidos provinciales - General - version 3](https://user-images.githubusercontent.com/34352451/126086826-489a67b9-b7fe-459f-911f-f922fb2b298a.jpeg)

Dicho de otra manera, si la población en una determinada provincia se agrupa en unos cuantos distritos que conforman una ciudad, ¿no es posible que los contagios se comporten de la misma manera?

De ser así, ¿no sería más preciso evaluar la situación sanitaria de la *ciudad principal* de las provincias para dictar medidas al resto de ella? 

Lo que busco en este documento es comparar la tasa de mortalidad por Covid-19 de la *ciudad principal* de una provincia X con la tasa de mortalidad de la misma provincia. Y repetir el proceso para todas las provincias del país. De manera que pueda identificar aquellas provincias en las que existe un desfase entre estos indicadores.

Para lograrlo, me planteo (1) identificar ciudades principales en el país, (2) identificar qué distritos conforman cada ciudad, (3) calcular las muertes acumuladas por Covid-19 para cada ciudad principal, (4) hacer el mismo cálculo que en el paso anterior pero para las provincias, y (5) comparar las tasas obtenidas para cada ciudad principal con las de las provincias a las que pertenecen.

Esta metodología puede significar un aporte al momento de analizar condiciones epidemiológicas en el país debido a que permitiría afinar las medidas sanitarias a nivel provincial. No es común que especialistas de ramas ajenas a los estudios urbanos conozcan los riesgos de asumir que los límites administrativos responden al real funcionamiento de ciudades o regiones. 

De encontrarse una diferencia significativa entre la tasa de mortalidad de ciudades principales y las provincias en las que se encuentran, se podría (1) recomendar calcular otros indicadores epidemiológicos más complejos para corroborar el fenómeno, y (2) ajustar las medidas sanitarias provinciales evaluando sus *ciudades principales*.

### Metodología y fuentes de información

#### Identificación de ciudades principales

Identificar y delimitar ciudades no siempre es algo sencillo: la
literatura indica que pueden delimitarse tras la revisión de manchas
urbanas continuas, o preferiblemente conociendo flujos de movilidad
entre distintas manchas urbanas.

Para el Censo de 2017, INEI produjo cartografía con todas las manzanas
del país, cada una de ellas con su respectivo ID y por tanto con
información sobre cada una de las variables consideradas para el censo
(Población, Hogar y Vivienda)<sup id="a1">[1](#f1)</sup>. Esta nos permite aproximarnos de
manera bastante precisa a las manchas urbanas que existen en el
territorio y por tanto a identificar y delimitar ciudades hacia el
interior de cada provincia.

Sin embargo, con esta misma cartografía INEI ha identificado 92
*ciudades principales* en el país<sup id="a2">[2](#f2)</sup>, distribuídas en 76 provincias,
cada una con su respectiva delimitación. Llegué a ella porque, por
correo electrónico, solicité la cartografía de las manzanas del Censo de
2017 y me las enviaron por el mismo medio. La limitante es que no me
enviaron una descripción de la metodología que siguieron. De su
revisión, entiendo que toman en cuenta continuidad entre manchas urbanas
y relaciones económicas (y por tanto flujos de movilidad)<sup id="a3">[3](#f3)</sup>.

Como la intención es que este análisis sea preliminar,
asumiremos que la delimitación de INEI es la adecuada, haremos una limpieza sobre ella, y la utilizaremos para conocer que
distritos conforman cada *ciudad principal* del país. 

#### Fallecimientos por Covid-19

Utilizaremos la base de datos de
[NOTI-SINADEF](https://www.datosabiertos.gob.pe/dataset/fallecidos-por-covid-19-ministerio-de-salud-minsa),
elaborada por el Centro Nacional de Epidemiologia, prevención y Control
de Enfermedades del MINSA, que tiene datos sobre Fecha de Nacimiento,
Fecha de Fallecimiento, Sexo, Departamento, Provincia y Distrito de los
fallecidos por Covid-19. Hace poco más de un mes tuvo una actualización
en su metodología para sincerar las muertes por Covid-19 en el país.

Estos datos se agruparán por distritos una vez identificadas las
*ciudades principales* del país.

#### Replicabilidad

El proceso de obtención de cada uno de los datos se ha realizado en
Python, PyQGIS y R. Los scripts se comparten en la misma carpeta que
este documento.

El proceso para identificar ciudades principales y los distritos que las
conforman se puede revisar en los cuadernos [P1](https://github.com/jrojasquiroz/msprov/tree/main/P1-INEI%20vs%20GeoGPS-Peru), 
[1](https://github.com/jrojasquiroz/msprov/blob/main/1-Limpieza%20de%20datos.ipynb) y [2](https://github.com/jrojasquiroz/msprov/blob/main/2-Identificacion%20de%20ciudades%20principales.ipynb).

Para calcular las muertes acumuladas por *ciudad principal* y la
provincia a la que pertenecen se siguió el proceso descrito en el
[cuaderno 6](https://github.com/jrojasquiroz/msprov/blob/main/6-Ciudades%20vs%20Provincias.R).

### Resultados

Como se mencionó en el apartado anterior, he trabajado sobre la base de
las 92 ciudades principales identificadas por INEI. Tras la revisión de
su cartografía, limpieza de la misma y exclusión de Lima Metropolitana,
se pueden identificar 90 *ciudades principales* en el Perú, formadas por
245 distritos.

![Ciudades en el Peru sin Lima](https://user-images.githubusercontent.com/34352451/125891975-3366ab27-db75-495c-a2bd-d3fff4188f01.jpeg)

¿Qué características presentan? Poblacionalmente, más de la mitad de
estas *ciudades principales* acumulan más del 50% de todos los
habitantes de la provincia en la que se encuentran.

![Poblacion provincial en ciudades](https://user-images.githubusercontent.com/34352451/125892033-e9122f91-3305-46a6-a8a1-a9861b35ae37.png)

Además, más de la mitad de estas acumulan más del 50% de los
fallecimientos por Covid-19 registrados en la provincia en la que están
ubicadas.

![Fallecidos provinciales en ciudades](https://user-images.githubusercontent.com/34352451/125892056-b6511a2c-c53f-41c3-a8c0-84fa1546950a.png)

¿Existe una correlación? Aparentemente, sí. Es decir, a medida que las *ciudades*
acumulan más población provincial se observa una mayor acumulación de
fallecimientos por Covid-19 en esa ciudad de todos los registros
provinciales.

![Poblacion vs Fallecidos - Ciudades](https://user-images.githubusercontent.com/34352451/125892105-8e0ccc5a-a637-42eb-9cce-bebaa9b32424.png)

Luego de calcular la tasa de mortalidad por Covid-19 para cada *ciudad*,
elegimos una por provincia, específicamente aquella que tenga el valor
más alto dentro de su provincia, y la comparamos con la misma tasa de la
provincia a la que pertenece. De esta manera, finalmente analizamos 74
*ciudades principales*.

Los resultados indican que la tasa de mortalidad en la ciudad principal
es mayor que la tasa de mortalidad en la provincia a la que pertenece en
71 de esos casos.

¿Por cuánto? En 45 de los 71 casos, la *ciudad principal* muestra una tasa de mortalidad 15% más alta que la tasa de mortalidad
de la provincia a la que pertenece. 

![Diferencia mortalidad - Ciudad vs Provincia](https://user-images.githubusercontent.com/34352451/125892134-fba97b40-224c-418c-9bd5-1baac5472174.png)

### Conclusiones

La finalidad de este análisis era comparar las tasas de mortalidad de las *ciudades principales* del país con las de la provincia en la que
se ubican y poder identificar posibles desfases entre estas. Los resultados indican que la mayoría de provincias estudiadas (74 de 196 en todo el país) muestran una diferencia entre las tasas mencionadas, y que en más de la mitad de ellas esta diferencia es de por lo menos 15% y como máximo 150%.

Por tanto, los resultados sugieren la posibilidad de que los análisis epidemiológicos puedan hacerse a nivel de *ciudades principales* para luego
dictar medidas a nivel provincial. Esto debido a que los límites administrativos no necesariamente reflejan la realidad de dinámicas urbanas o regionales. 

En este caso, al analizarse la tasa de mortalidad, se necesitan dos valores, población y
fallecimientos; pero lo que está pasando es que los fallecimientos se
concentran en un grupo de distritos (*ciudad principal*), seguramente por tener características más
urbanas que el resto de los que conforman la provincia. Por tanto, los
distritos ‘periféricos’ de la provincia añaden población al cálculo pero
no fallecimientos, al menos no en gran medida, y por tanto ‘disimulan’
la situación sanitaria provincial.

Por supuesto, los análisis epidemiológicos se hacen con indicadores más
complejos que solo la tasa de mortalidad, por lo que el
siguiente paso debería ser discutir estos resultados con una
especialista en salud pública o epidemiología para confirmar su utilidad.

### Notas al pie

<b id="f1">1</b> Esta cartografía, aunque de manera no oficial, ha sido publicada íntegramente por la página GEO GPS Perú, y
puede descargarse desde
[aquí](https://www.geogpsperu.com/2020/07/manzanas-y-poblacion-de-todo-el-peru.html).[↩](#a1)

<b id="f2">2</b> Como mencioné en la introducción, creo que una de las razones para
considerar a una ciudad como principal es que concentren un porcentaje
importante de población provincial, y esto no pasa necesariamente en
todas las provincias del país. Por tanto, asumo que el hecho de que las
*ciudades principales* identificadas por INEI estén ubicadas solo en 76
provincias también es correcto.[↩](#a2)

<b id="f3">3</b> Un ejemplo de esto es el caso de Chimbote, donde yo vivo: toman en
cuenta como ciudad a las manchas urbanas de los distritos de Chimbote,
Nuevo Chimbote y Santa. Si solo revisáramos manchas urbanas continuas no
podríamos identificar que Chimbote y Nuevo Chimbote comparten un flujo
importante de personas porque están separadas por un río. Y lo mismo
entre Chimbote y Santa: físicamente no son manchas urbanas continuas
pero también comparten flujos de movilidad constantes por su cercanía
(10 min en auto) y actividades económicas.[↩](#a3)

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fjrojasquiroz%2Fmsprov&count_bg=%2379C83D&title_bg=%23555555&icon=microsoftacademic.svg&icon_color=%23D3CACA&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
