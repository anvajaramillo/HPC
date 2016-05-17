#include <cv.h>
#include <highgui.h>
#include <time.h>

using namespace cv;

int main(int argc, char **argv){

	char* imageName = argv[1];
	Mat image, imageSobel;
  image = imread(imageName, 1);

	 Mat gray_image_opencv, grad_x, abs_grad_x, grad_y, abs_grad_y;
	 
	 clock_t start = clock();
	 
	 GaussianBlur(image, image, Size(3,3),0,0,BORDER_DEFAULT);
   cvtColor(image, gray_image_opencv, CV_BGR2GRAY);
   
   Sobel(gray_image_opencv,grad_x,CV_8UC1,1,0,3,1,0,BORDER_DEFAULT);
  convertScaleAbs(grad_x, abs_grad_x);
    
  Sobel(gray_image_opencv,grad_y,CV_16S,1,0,3,1,0,BORDER_DEFAULT);
  convertScaleAbs(grad_y, abs_grad_y);
  
  addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, imageSobel );
  
  printf("%f\n", ((double)clock() - start) / CLOCKS_PER_SEC);

  namedWindow("Image Color", CV_WINDOW_AUTOSIZE);
  namedWindow("Image Gray", CV_WINDOW_AUTOSIZE);
  namedWindow("Image Sobel", CV_WINDOW_AUTOSIZE);
  
  imshow("Image Color",image);
  imshow("Image Gray",gray_image_opencv);
  imshow("Image Sobel",imageSobel);
  
  waitKey(0);
  
  return 0;

}
