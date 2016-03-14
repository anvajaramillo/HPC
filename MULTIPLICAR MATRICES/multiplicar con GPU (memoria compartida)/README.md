#MULTIPLICAR MATRICES EN GPU CON MEMORIA COMPARTIDA


Este algoritmo consiste en describir dos funciones una para llenado y la otra para multiplicar,con la diferencia en que la función multiplicar se genera mediante un kernel de GPU.

El kernel realiza un método de paralelización con hilos y bloques para darle un mayor desempeño al proceso que necesitamos, se puede tener un máximo de 65365 bloques cada uno con un máximo de 1024 hilos, además, utilizamos el método de memoria compartida para crear submatrices y realizar el procedimiento cada n*n para optimizar el proceso. 
Para este procedimiento primero se debe asignar el número n que va a repetir el proceso, y segundo la dimensión de la matriz que debe ser en propoción a n, después recorremos la matriz hasta el n que asignamos y vamos recorriendo por segmentos las matrices a sumar y asignandolas a memoria compartida, por último utilizamos los valores que se encuentran memoria compartida para resolver la operación matemática y asignar el resultado a memoria global.

En el main principal inicializamos los vectores en CPU con memoria dinámica y procedemos a llamar la función de llenado, seguido inicializamos los vectores en GPU.

Inicializamos el tamaño de cada bloque en 32, este dato es utilizado para un bloque de una dimensión.
Para inicializar matrices (2 dimensiones) utilizamos la función dim3 de cuda que proporciona los valores hasta en 3 dimensiones.
La dimensión de los bloques la inicializamos como blockSize * blockSize, la dimensión del tamaño de la grilla la inicializamos como columnas/blockSize * columnas/blockSize.

Inicializamos el medidor de tiempo y copiamos los datos de la CPU a la GPU, y llamamos al kerner multiplicar, el resultado almacenado en la GPU se copia a la CPU, cuando se haya completado el procedimiento mostramos en pantalla el tiempo que tardó en realizar la operación.

Estos datos se utilizan para realizar la fórmula de aceleración x=ts/tp, donde tp es el valor que toma la GPU en realizar la ejecución de la multiplicación.

