#FILTRO DE SOBEL EN GPU CON MEMORIA COMPARTIDA

Los registros y la memoria compartida son memorias variables que residen en la memoria global o constante y pueden ser accedidos muy rápidamente y altamente paralela.

Este algoritmo consiste en realizar el filtro de sobel con funciones en GPU utilizando memoria compartida, mediante la ayuda de kernels que nos brinda un método de paralelización con hilos y bloques para darle un mayor desempeño al proceso, se puede tener un máximo de 65365 bloques cada uno con un máximo de 1024 hilos, además también aplicamos el uso de memoria constante.

definimos globalmente la mascara y la mascara transpuesta para realizar los dos barridos y el ancho de la mascara.

En el main principal leemos nuestra imagen de entrada; inicializamos los vectores en CPU y GPU con memoria dinámica; copiamos del host al dispositivo los datos de la imagen; copiamos a memoria constante los valores de las máscaras; utilizamos 1024 hilos y el número de bloques es igual a (tamaño/32)*(alto/32); llamamos a los kernels gray, sobelX, sobelY y sobel para realizar la conversión en escala de grises, el barrido de sobel en X y Y, y sacar el filtro de sobel final respectivamente; copiamos del dispositivo al host los resultados de la imagen en grises y la imagen con filtro de sobel; establecemos las ventanas para visualizar los tres tipo de imagenes (normal, gris, sobel); establecemos en cada ventana su imagen correspondiente.

En el kernel gray recibimos la imagen normal, ancho, alto y una imagen de salida; recorremos la imagen normal y realizamos la transformación de colores en escala de grises; guardamos el resultado en la imagen de salida.

En el kernel sobelX recibimos la imagen en grises, ancho, alto, ancho de máscara y la imagen de salida; el método de memoria compartida crear submatrices y realiza el procedimiento cada n*n para obtimizarlo, establecemos la matriz compartida un tamaño un poco más grande que la matriz de entrada para capturar los elementos fantasmas de la convolución, cargamos los elementos fantasmas de izquierda, derecha y centro y los guardamos en la matriz con memoria compartida, sincronizamos hilos y realizamos el procedimiento de convolución accediendo a la matriz de memoria compartida para tener el mínimo acceso a memoria global y con la máscara asignada (si la máscara está transpuesta indica barrido en y); guardamos el resultado en la imagen de salida.

En el kernel sobelY recibimos la imagen en grises, ancho, alto, ancho de máscara y la imagen de salida; el método de memoria compartida crear submatrices y realiza el procedimiento cada n*n para obtimizarlo, establecemos la matriz compartida un tamaño un poco más grande que la matriz de entrada para capturar los elementos fantasmas de la convolución, cargamos los elementos fantasmas de izquierda, derecha y centro y los guardamos en la matriz con memoria compartida, sincronizamos hilos y realizamos el procedimiento de convolución accediendo a la matriz de memoria compartida para tener el mínimo acceso a memoria global y con la máscara asignada (si la máscara está transpuesta indica barrido en y); guardamos el resultado en la imagen de salida.

En el kernel sobel recibimos el filtro en x, el filtro en y, ancho, alto y la imagen de salida; aplicamos la formula raiz(filtroenx^2+filtroeny^2); guardamos el resultado en la matriz de salida.
