#MULTIPLICAR MATRICES CPU VS GPU

En este trabajo vamos a realizar el codigo de tres algoritmos diferentes.

* El primero está basado en el llenado de dos matrices y multiplicación de las mismas usando CPU.
* El segundo está basado en el llenado de dos matrices usando CPU, y la multiplicación de las mismas usando GPU solo con el uso de hilos y bloques.
* El tercero está basado en el llenado de dos matrices usando CPU, y la multiplicación de las misma en GPU con el uso de hilos, bloques y memoria compartida.

En todos los casos se mide el tiempo que se tarda en realizar la multiplicacion, dados lo resultado podemos apreciar dos gráficas la primera nos muestra el tiempo que tarda cada algoritmo en realizar la operación y la segunda nos muestra la aceleración respecto al tamaño de las matrices, la cual va creciendo a medida que aumenta el tamaño.
