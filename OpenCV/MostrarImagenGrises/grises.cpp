#include <cv.h>
#include <highgui.h>

using namespace cv;

int main(int argc, char **argv){

	char* imageName = argv[1];
	Mat image;
  image = imread(imageName, 1);


	 Mat gray_image_opencv, grad_x, abs_grad_x;
   cvtColor(image, gray_image_opencv, CV_BGR2GRAY);
   Sobel(gray_image_opencv,grad_x,CV_8UC1,1,0,3,1,0,BORDER_DEFAULT);
  convertScaleAbs(grad_x, abs_grad_x);
  
  namedWindow("Image Color", WINDOW_NORMAL);
  namedWindow("Image Gray", WINDOW_NORMAL);
  
  imshow("Image Color",image);
  imshow("Image Gray",gray_image_opencv);
  
  waitKey(0);
  
  return 0;

}
