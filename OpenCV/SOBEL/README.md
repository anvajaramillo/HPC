#FILTRO DE SOBEL CPU VS GPU

En este trabajo vamos a realizar el código de 4 algoritmos diferentes

* El primero está basado en realizar el filtro de sobel con funciones propias de OpenCv.
* El segundo está basado en realizar la escala de grises y filtro de sobel usando GPU con memoria global mediante el uso de hilos y bloques.
* El tercera está basado en realizar la escala de grises y filtro de sobel usando GPU con memoria constante mediante el uso de hilo y bloques.
* El cuerta está basado en realizar la escala de grises y filtro de sobel usando GPU con memoria constante y compartida mediante el uso de hilo y bloques.

En todos los casos se mide el tiempo que tarda en realizar el filtro de sobel. Dados los resultados podemos apreciar dos tablas, la primera nos muestra el tiempo que tarda cada algoritmo en realizar el filtro y la segunda nos muestra la aceleración respecto al tamaño de la imagen.

Tiempo de ejecución

Tamaño de la imagen | Tiempo CPU | Tiempo GPU Global | Tiempo GPU constante | Tiempo GPU compartida
----- | ----- | ----- | ----- | -----
200000 | 0,0107359 | 0,0011494 | 0,0010549 | 0,0010463
250000 | 0,0094819 | 0,0014255 | 0,0012963 | 0,0013012
300000 | 0,0095721 | 0,0016989 | 0,0015485 | 0,001541
350000 | 0,0128523 | 0,0019692 | 0,001762 | 0,0017634
400000 | 0,0154666 | 0,0022688 | 0,0020462 | 0,0020184
400000 | 0,0117291 | 0,0022387 | 0,0020267 | 0,0020672
500000 | 0,0143418 | 0,0026466 | 0,002391 | 0,0023826
600000 | 0,019837 | 0,0031015 | 0,0027931 | 0,0027781
700000 | 0,0174119 | 0,0036546 | 0,0032553 | 0,0032905
800000 | 0,0245736 | 0,0040797 | 0,003681 | 0,003658

Gráficas de tiempo 

![Tiempo de CPU](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/tsec.PNG)
![Tiempo de GPU memoria global](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/tglo.PNG)
![Tiempo de GPU memoria constante](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/tcons.PNG)
![Tiempo de GPU memoria compartida](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/tcomp.PNG)
![Gráfica de tiempos](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/tiempos.PNG)

Aceleración

Tamaño de la imagen | aceleración global | aceleración constante | aceleración compartida
----- | ----- | ----- | -----
200000 | 9,34043849 | 10,17717319 | 10,26082386
250000 | 6,651631007 | 7,314587673 | 7,28704273
300000 | 5,634292778 | 6,181530513 | 6,211615834
350000 | 6,526660573 | 7,29415437 | 7,288363389
400000 | 6,817083921 | 7,558694165 | 7,66280222
400000 | 5,239245991 | 5,787289683 | 5,673906734
500000 | 5,418952618 | 5,998243413 | 6,019390582
600000 | 6,39593745 | 7,102144571 | 7,140491703
700000 | 4,764379139 | 5,348785058 | 5,291566631
800000 | 6,023384072 | 6,675794621 | 6,717769273

Gráficas de aceleración

![Aceleración memoria global](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/aglo.PNG)
![Aceleración memoria constante](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/acons.PNG)
![Aceleración memoria compartida](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/acomp.PNG)
![Aceleraciones](https://github.com/anvajaramillo/HPC/blob/master/OpenCV/SOBEL/aceleraciones.PNG)

Conclusiones

* Los resultados del tiempo en CPU no presentan un crecimiento constante, sin embargo presenta una linea de tendencia creciente con la ecuación y = 2E-08x + 0,0043.
* Los tiempos de CPU no dependen solo del tamaño de la imagen, sino también de la complejidad de la mismas, es decir, de cuántos bordes posea la imagen.
* Los resultados del tiempo en Memoria Global, Constante y Compartida presentan tiempos muy similares.
* Los resultados del tiempo en Memoria Global, Constante y Compartida presenta un linea de tendencia creciente casi perfecta, demasiado ajustada a la ecuación y = 4E-09x + 0,0002.
* Los resultados del tiempo en GPU presenta una mejoría en optimización debido a que otorgan menos latencia en el desarrollo del algoritmo en comparación al desarrollo en CPU.
* La aceleración con Memoria Global, Constante y Compartida no presentan un decrecimiento constante, debido a que el tiempo de CPU varía según el tipo de imagen.
* La aceleración con Memoria Global, Constante y Compartida presenta una linea decreciente, lo que significa que al aumentar el tamaño de la imagen la acelaración disminuye.
* La acelaración de Memoria Constante y Compartida son muy similares, lo que implica que el desarrollo de técnicas de memoria compartidas no son muy aplicables en el filtro de sobel.
* La aceleración de Memoria Constante y Compartida presentan un comportamiento con la linea de tendencia y = -4E-06x + 8,6052.
* La aceleración de Memoria Global presenta un comportamiento con linea de tendencia y = -4E-06x + 7,8709.




