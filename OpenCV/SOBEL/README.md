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
