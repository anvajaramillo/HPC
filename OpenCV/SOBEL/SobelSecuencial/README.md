#FILTRO DE SOBEL CON FUNCIONES DE OPENCV

Este algoritmo consiste en utilizar funciones propias de la libreria OpenCv.

Primero leemos nuestra imagen de entrada; utilizamos la función GaussioanBlur para convoluciones la imagen leida con el kerlnel de Gauss; utilizamos la función cvtColor para generar la imagen de salida en GaussianBlur en escala de grises; después utilizamos la función Sobel para aplicar el filtro de sobel haciendo un barrido en x y seguido aplicamos valor absolotu con la función convertScaleAbs con la cual obtendremos un cambio en la profundidad de la matriz; repetimos el procedimiento anterior haciendo un barrido en y; por último utilizamos la función addWeighted(src1,alpha,src2,beta,gamma,dst) que recibe el valor absoluto anterior de los dos barridos y retorna la imagen con filtro de sobel aplicando la formula dst = src1*alpha + src2*beta + gamma.
Segundo establecemos 3 ventanas: la primera para visualizar la imagen normal, la segundo para visualizar la imagen en escala de grises y la tercera para visualizar la imagen con filtro de sobel.
Por último establecemos en cada ventana su imagen correspondiente.