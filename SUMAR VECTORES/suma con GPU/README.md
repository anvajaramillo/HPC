#SUMA VECTORES CON PROCESOS EN GPU

Este algoritmo consiste en describir dos funciones una para llenado y la otra para sumar,con la diferencia en que la función sumar se general mediante un kernel de GPU, con esta función vamos a realizar un método de paralelización con hilos y bloques para darle un mayor desempeño al proceso que necesitamos, se puede tener un máximo de 65365 bloques cada uno con un máximo de 1024 hilos.

En el main principal inicializamos los vectores en CPU con memoria dinámica y procedemos a llamar la función de llenado, seguido inicializamos los vectores en GPU.

Inicializamos el tamaño de cada bloque en 1024 y calculamos cuantos bloques necesitamos para el tamaño de vector que queremos.

Inicializamos el medidor de tiempo y copiamos los datos de la CPU a la GPU, y llamamos al kerner sumar, el resultado almacenado en la GPU se copia a la CPU, cuando se haya completado el procedimiento mostramos en pantalla el tiempo que tardó en realizar la operación.

Estos datos se utilizan para realizar la fórmula de aceleración x=ts/tp, donde tp es el valor que toma la GPU en realizar la ejecución de la suma.

