#include <opencv/highgui.h>

int main(int argc, char** argv){
	
	//cargamos la imagen que le pasamos al programa como argumento
	//CV_LOAD_IMAGE_UNCHANGED nos permite cargar la imagen tal cual es
	IplImage* img = cvLoadImage(argv[1],CV_LOAD_IMAGE_UNCHANGED ); 
	
	//creamos una ventana con el nombre Imagen
	//el parámetro CV_WINDOW_AUTOSIZE nos permite que tenga el tamaño de la imagen automáticamente
	cvNamedWindow("Imagen",CV_WINDOW_AUTOSIZE);

	//mostramos la imagen en la ventana anteriormente creada
	cvShowImage("Imagen",img);

	//se queda esperando a que se presione una tecla
	cvWaitKey(0);

	//se libera el recurso de memoria donde está la imagen
	cvReleaseImage(&img);

	//destruimos la ventana
	cvDestroyWindow("Imagen");

}
