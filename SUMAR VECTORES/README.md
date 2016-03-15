#SUMAR VECTORES CPU VS GPU

En este trabajo vamos a realizar el codigo de dos algoritmos diferentes.

* El primero está basado en el llenado de dos vectores y suma de los mismos usando CPU.
* El segundo está basado en el llenado de dos vectores usando CPU, y la suma de los mismo usando GPU.

En ambos casos se mide el tiempo que se tarda el realizar la suma, dados lo resultado podemos apreciar dos gráficas la primera nos muestra el tiempo que tarda cada algoritmo en realizar la operación y la segunda nos muestra la aceleración respecto al tamaño de las matrices, la cual va creciendo a medida que aumenta el tamaño.
que aumenta el tamaño.

Tamaño del vector | Tiempo de CPU | Tiempo de GPU
----- | ----- | -----
1.000.000 | 0,002361 | 0,001768
5.000.000 | 0,011711 | 0,0082985
10.000.000 | 0,023462 | 0,0164565
15.000.000 | 0,035157 | 0,024672
20.000.000 | 0,046874 | 0,032756
25.000.000 | 0,0586535 | 0,040979
30.000.000 | 0,070289 | 0,0490235
35.000.000 | 0,0821855 | 0,057243
40.000.000 | 0,093661 | 0,065412
45.000.000 | 0,105899 | 0,0734805
50.000.000 | 0,1171525 | 0,0818475
55.000.000 | 0,1288465 | 0,089585
60.000.000 | 0,1406515 | 0,0979245
65.000.000 | 0,152217 | 0,1067265

![Tiempos de ejecución](https://github.com/anvajaramillo/HPC/blob/master/SUMAR%20VECTORES/tiempos.PNG)


Tamaño del vector | Aceleracion
----- | -----
1.000.000 | 1,33540724
5.000.000 | 1,411218895
10.000.000 | 1,425698052
15.000.000 | 1,424975681
20.000.000 | 1,431005007
25.000.000 | 1,431306279
30.000.000 | 1,433781758
35.000.000 | 1,435730133
40.000.000 | 1,431862655
45.000.000 | 1,441185076
50.000.000 | 1,431350988
55.000.000 | 1,438259753
60.000.000 | 1,436325945
65.000.000 | 1,426234347

![Aceleracion](https://github.com/anvajaramillo/HPC/blob/master/SUMAR%20VECTORES/aceleracion.PNG)

