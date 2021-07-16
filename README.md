# Medidas sanitarias a nivel provincial, ¿un análisis correcto?
### Introducción

Por el momento, las medidas sanitarias que dicta el Gobierno central se
hacen a nivel provincial, excepto por Lima Metropolitana. Entiendo (y
esto puede ser un error) que, debido a eso, los análisis que se realizan
para tomar estas decisiones se hacen al mismo nivel espacial.

![PCM-alerta-moderada](https://user-images.githubusercontent.com/34352451/125891745-34e73c7c-e8ad-41a3-ac3c-299fffccb922.png)

Sin embargo, a diferencia de Lima Metropolitana, existen provincias en
las que la población no está distribuida uniformemente al interior de
estas. Ni tampoco su mancha urbana.

![SantaVSLima](https://user-images.githubusercontent.com/34352451/125891888-66edf6f9-bd02-4f59-957f-8902f030be68.jpeg)

Como se puede ver, en Lima Metropolitana sí tiene sentido analizar la
población en su conjunto porque está ubicada en una sola mancha urbana,
que comparte actividades y flujos de movilidad hacia su interior de
manera más homogénea que en la provincia del Santa, por citar un
ejemplo.

La situación de Santa es la misma para todas las provincias: tienen una
mancha urbana y distribuición poblacional discontinua.

![manchas urbanas aleatorias](https://user-images.githubusercontent.com/34352451/125897029-1a395281-be68-41bc-a182-98bffecc442b.jpeg)

Y en algunas provincias existen manchas urbanas (llamésmoles centros
poblados en adelante) que concentran más de la mitad de la población
provincial, y que por su tamaño y densidad poblacional, pueden presentar
características que pueden entenderse como más riesgosas para la
transmisión del SARS-CoV-2 en comparación con los demás centros poblados
que conforman una provincia: mayores aglomeraciones, mayor movilidad
hacia su interior, actividades económicas en espacios cerrados,
hacinamiento. Este tipo de centros poblados, que podemos llamar ciudades
principales, podrían ser lugares en los que se concentren contagios y
muertes por la enfermedad dentro de las provincias.

![p2](https://user-images.githubusercontent.com/34352451/125891942-e7a816c5-4c24-4445-976e-41fa105c90d5.jpg)

Por tanto, mi duda es si, al momento de decidir medidas sanitarias, es
correcto seguir analizando a todas las provincias como un conjunto, o si
más bien debería analizarse su ciudad principal para dictar medidas al
resto de la provincia.

En adelante lo que haré será (1) identificar ciudades principales en el
país, (2) identificar qué distritos conforman cada ciudad, (3) calcular
las muertes acumuladas por Covid-19 para cada ciudad principal, (4)
hacer el mismo cálculo que en el paso anterior pero para las provincias,
y (5) comparar las tasas obtenidas para cada ciudad principal con las de
las provincias a las que pertenecen.

Esto con la finalidad de ver si en realidad existe un desfase entre los
indicadores para una ciudad principal con los de la provincia a la que
pertenece. De existir una diferencia significativa creo que sí valdría
la pena mostrar los resultados a una especialista en epidemiología o
salud pública para discutir su relevancia.

### Metodología y fuentes de información

#### Identificación de ciudades principales

Identificar y delimitar ciudades no siempre es algo sencillo: la
literatura indica que pueden delimitarse tras la revisión de manchas
urbanas continuas, o preferiblemente conociendo flujos de movilidad
entre distintas manchas urbanas.

Para el Censo de 2017, INEI produjo cartografía con todas las manzanas
del país, cada una de ellas con su respectivo ID y por tanto con
información sobre cada una de las variables consideradas para el censo
(Población, Hogar y Vivienda) <sup id="a1">[1](#f1)</sup>. Esta nos permite aproximarnos de
manera bastante precisa a las manchas urbanas que existen en el
territorio y por tanto a identificar y delimitar ciudades hacia el
interior de cada provincia.

Sin embargo, con esta misma cartografía INEI ha identificado 92
*ciudades principales* en el país <sup id="a2">[2](#f2)</sup>, distribuídas en 76 provincias ,
cada una con su respectiva delimitación. Llegué a ella porque, por
correo electrónico, solicité la cartografía de las manzanas del Censo de
2017 y me las enviaron por el mismo medio. La limitante es que no me
enviaron una descripción de la metodología que siguieron. De su
revisión, entiendo que toman en cuenta continuidad entre manchas urbanas
y relaciones económicas (y por tanto flujos de movilidad)<sup id="a3">[3](#f3)</sup>.

Lo que haré será utilizar esta cartografía para conocer qué distritos
conforman cada mancha urbana.

#### Fallecimientos por Covid-19

Utilizaré la base de datos de
[NOTI-SINADEF](https://www.datosabiertos.gob.pe/dataset/fallecidos-por-covid-19-ministerio-de-salud-minsa),
elaborada por el Centro Nacional de Epidemiologia, prevención y Control
de Enfermedades del MINSA, que tiene datos sobre Fecha de Nacimiento,
Fecha de Fallecimiento, Sexo, Departamento, Provincia y Distrito de los
fallecidos por Covid-19. Hace poco más de un mes tuvo una actualización
en su metodología para sincerar las muertes por Covid-19 en el país.

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

Como se mencionó en la introducción, hemos trabajado sobre la base de
las 92 ciudades principales identificadas por INEI. Tras la revisión de
su cartografía, limpieza de la misma y exclusión de Lima Metropolitana,
hemos identificado 90 *ciudades principales* en el Perú, formadas por
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

¿Por cuanto? En 45 de las 74 *ciudades principales*, la diferencia entre estas
tasas representa más del 15% de la mortalidad provincial.

![Diferencia mortalidad - Ciudad vs Provincia](https://user-images.githubusercontent.com/34352451/125892134-fba97b40-224c-418c-9bd5-1baac5472174.png)

### Conclusiones

La motivación para hacer este análisis era corroborar si tiene sentido
que para dictar medidas sanitarias los análisis epidemiológicos se hagan
a nivel provincial, teniendo en cuenta el hecho de que la distribución
poblacional de muchas provincias no es homogénea, sino que suele estar
distribuida de manera ‘entrecortada’.

Mi sospecha era que, al no tener una distribución homogénea, la
población se concentra en unos pocos puntos (ciudades), y por tanto las
dinámicas de movilidad, de trabajo y de contagio puedan seguir el mismo
patrón.

Los resultados indican que la mayor parte de las *ciudades principales*
del país acumulan la mayor proporción de población de su provincia. Y a
su vez las mayores tasas de mortalidad.

Las tasas de mortalidad necesitan de dos valores, población y
fallecimientos; pero lo que está pasando es que los fallecimientos se
concentran en una ciudad, seguramente por tener características más
urbanas que el resto de distritos de la provincia. Por tanto, los
distritos ‘periféricos’ de la provincia añaden población al cálculo pero
no fallecimientos, al menos no en gran medida, y por tanto ‘disimulan’
la situación sanitaria provincial.

Esto podría indicar que, al momento de determinar las condiciones
sanitarias de estas provincias (74 de un total de 196 en el país) podría
ser mejor analizar sus ciudades principales para dictar medidas
sanitarias en toda la provincia.

Por supuesto, los análisis epidemiológicos se hacen con indicadores más
complejos que solo la tasa de mortalidad, por tanto creo que el
siguiente paso debería ser discutir estos resultados con una
especialista en salud pública o epidemiología, confirmar su utilidad, y
definir una metodología para identificar *ciudades principales* en todas
las provincias del país.

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
