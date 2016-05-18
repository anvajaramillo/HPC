#FILTRO DE SOBEL EN GPU CON MEMORIA GLOBAL

La memoria global puede transferir datos del codigo del host para y desde el dispositivo, como ilustrando flechas bidireccionales entre la memoria y el host.

Este algoritmo consiste en realizar el filtro de sobel con funciones en GPU utilizando memoria global, mediante la ayuda de kernels que nos brinda un método de paralelización con hilos y bloques para darle un mayor desempeño al proceso, se puede tener un máximo de 65365 bloques cada uno con un máximo de 1024 hilos.

En el main principal leemos nuestra imagen de entrada; inicializamos los vectores en CPU y GPU con memoria dinámica; copiamos del host al dispositivo los datos de la imagen y las máscaras que vamos a utilizar para el filtro; utilizamos 1024 hilos y el número de bloques es igual a (tamaño/32)*(alto/32); llamamos a los kernels gray, sobelX_Y y sobel para realizar la conversión en escala de grises, el barrido de sobel en X y Y, y sacar el filtro de sobel final respectivamente; copiamos del dispositivo al host los resultados de la imagen en grises y la imagen con filtro de sobel; establecemos las ventanas para visualizar los tres tipo de imagenes (normal, gris, sobel); establecemos en cada ventana su imagen correspondiente.

En el kernel gray recibimos la imagen normal, ancho, alto y una imagen de salida; recorremos la imagen normal y realizamos la transformación de colores en escala de grises; guardamos el resultado en la imagen de salida.

En el kernel sobelX_Y recibimos la imagen en grises, ancho, alto, ancho de máscara, máscara y la imagen de salida; realizamos el procedimiento de convolución para obtener el filtro en el barrido que se indica con la máscara (si la máscara está transpuesta indica barrido en y); guardamos el resultado en la imagen de salida.

En el kernel sobel recibimos el filtro en x, el filtro en y, ancho, alto y la imagen de salida; aplicamos la formula raiz(filtroenx^2+filtroeny^2); guardamos el resultado en la matriz de salida.
