#MULTIPLICAR MATRICES CPU VS GPU

En este trabajo vamos a realizar el código de tres algoritmos diferentes.

* El primero está basado en el llenado de dos matrices y multiplicación de las mismas usando CPU.
* El segundo está basado en el llenado de dos matrices usando CPU, y la multiplicación de las mismas usando GPU solo con el uso de hilos y bloques.
* El tercero está basado en el llenado de dos matrices usando CPU, y la multiplicación de las misma en GPU con el uso de hilos, bloques y memoria compartida.

En todos los casos se mide el tiempo que se tarda en realizar la multiplicación. Dados lo resultado podemos apreciar dos gráficas, la primera nos muestra el tiempo que tarda cada algoritmo en realizar la operación y la segunda nos muestra la aceleración respecto al tamaño de las matrices, la cual va creciendo a medida que aumenta el tamaño de la matriz.

Tiempos de ejecución

Tamaño de la matriz | Tiempo de CPU | Tiempo de GPU sin tiling | Tiempo de GPU con tiling
----- | ----- | ----- | -----
36864 | 0,031983 | 0,000269 | 0,000149
147456 | 0,343113 | 0,001329 | 0,000679
331776 | 1,023222 | 0,00439 | 0,001853
589824 | 3,102085 | 0,010455 | 0,003841
921600 | 6,227297 | 0,020073 | 0,007006
1327104 | 9,528048 | 0,032957 | 0,011949
1806336 | 15,495643 | 0,052056 | 0,0181
2310144 | 18,411695 | 0,071664 | 0,022977
2985984 | 33,566638 | 0,107124 | 0,034143
3686400 | 56,18743 | 0,146748 | 0,045724

Gráficas de tiempo

![Tiempo CPU](https://github.com/anvajaramillo/HPC/blob/master/MULTIPLICAR%20MATRICES/tiempocpu.PNG)

![Tiempo GPU](https://github.com/anvajaramillo/HPC/blob/master/MULTIPLICAR%20MATRICES/tiempogpu.PNG)


Aceleración

Tamaño de la matriz | Aceleración sin tiling | Aceleración con tiling
----- | ----- | -----
36864 | 118,8959108 | 214,6510067
147456 | 258,1738149 | 505,3210604
331776 | 233,0801822 | 552,1975175
589824 | 296,7082736 | 807,6243166
921600 | 310,2325014 | 888,851984
1327104 | 289,1054404 | 797,3929199
1806336 | 297,6725642 | 856,1128729
2310144 | 256,9169318 | 801,309788
2985984 | 313,3437698 | 983,1191752
3686400 | 382,8837872 | 1228,838903

Gráficas de aceleración

![Aceleración sin tiling](https://github.com/anvajaramillo/HPC/blob/master/MULTIPLICAR%20MATRICES/aceleracionsintiling.PNG)

![Aceleración con tiling](https://github.com/anvajaramillo/HPC/blob/master/MULTIPLICAR%20MATRICES/aceleracioncontiling.PNG)

![Aceleración](https://github.com/anvajaramillo/HPC/blob/master/MULTIPLICAR%20MATRICES/aceleracion.PNG)


Conclusiones

* Los resultados de GPU con uso de la técnica tiling (memoria compartida) son los más óptimos; sus tiempos se originan gracias al proceso de acceder lo menos posible a memoria global, lo cual aumenta el aprovechamiento de recursos y maximiza la eficiencia de ejecución; es decir, al utilizar el proceso de poner los datos en memoria compartida estamos brindando un acceso de datos más rápido, además se continua utilizando el método de paralelización con hilos y bloques que ayudan a realizar varias tareas simultáneamente optimizando el uso  del tiempo.
* Los resultados de GPU sin tiling ocupa el segundo lugar; podemos comprobar que la técnica de paralelización promueve un mejor uso del tiempo, sin embargo, al poner los datos en memoria global ocasiona una pequeña latencia cuando se accede a los mismos.
* Los resultados con CPU proporcionan el tiempo de ejecución más lento; dado que la resolución del algoritmo se basa en un procedimiento secuencial es decir desarrolla las tareas una después de otra, sin lugar a duda genera más demora al terminar la ejecución del algoritmo. Esta latencia no es de notar mucho cuando se trata de acceder a tamaños de matrices muy pequeños, sin embargo, al exigir un mayor esfuerzo se va viendo el crecimiento del tiempo de ejecución.
* La aceleración aumenta al aumentar el tamaño del vector; esto se debe a la exigencia que va pidiendo el algoritmo; dado que si el tamaño de la matriz es más grande las operaciones que se deben de hacer son más complejas y requieren de más recursos. 
	Matemáticamente sí tenemos el límite x=lim(ts→∞)⁡(ts/tp); donde x = aceleración; tp = tiempo ejecución GPU; tiempo ejecución CPU.
	Reemplazando tendríamos x=⁡(∞/tp) lo que daría como resultado x=∞, comprobando que la aceleración aumenta exponencialmente al aumentar el tamaño del vector lo cual ocasiona tiempos de CPU muy grandes.