#include <cv.h>
#include <cv.h>
#include <highgui.h>
#include <time.h>
#include <cuda.h>
#include <math.h>

#define RED 2
#define GREEN 1
#define BLUE 0

using namespace cv;

__device__ unsigned char clamp(int value){
    if(value < 0)
        value = 0;
    else
        if(value > 255)
            value = 255;
    return (unsigned char)value;
}

__global__ void gray(unsigned char *imageNormal, int width, int height, unsigned char *imageGray){
	int row = blockIdx.y*blockDim.y+threadIdx.y;
	int col = blockIdx.x*blockDim.x+threadIdx.x;

	if((row < height) && (col < width)){
		imageGray[row*width+col] = imageNormal[(row*width+col)*3+RED]*0.299 + imageNormal[(row*width+col)*3+GREEN]*0.587 + imageNormal[(row*width+col)*3+BLUE]*0.114;
	}
}

__global__ void sobelX_Y(unsigned char *imageGray, int width, int height, unsigned int maskWidth, char *mask, unsigned char *imageSobel){
	unsigned int row = blockIdx.y*blockDim.y+threadIdx.y;
	unsigned int col = blockIdx.x*blockDim.x+threadIdx.x;

	int value = 0;
	int n_start_point_row = row - (maskWidth/2);
	int n_start_point_col = col - (maskWidth/2);

	for(int i = 0; i < maskWidth; i++){
		for(int j = 0; j < maskWidth; j++){
			if((n_start_point_col+j >= 0 && n_start_point_col+j < width) && (n_start_point_row+i >= 0 && n_start_point_row+i < height)){
				value += imageGray[(n_start_point_row+i)*width+(n_start_point_col+j)] * mask[i*maskWidth+j];
			}
		}
	}
	imageSobel[row*width+col] = clamp(value);

}

__global__ void sobel(unsigned char *imageSobelX, unsigned char *imageSobelY, int width, int height, unsigned char *imageSobel){
	unsigned int row = blockIdx.y*blockDim.y+threadIdx.y;
	unsigned int col = blockIdx.x*blockDim.x+threadIdx.x;

	if((row < height) && (col < width)){
		imageSobel[row* width+col] = __powf((__powf(imageSobelX[row*width+col],2) + __powf(imageSobelY[row*width+col],2)),0.5);
	}

}


int main(int argc, char **argv){
	char h_mask[] = {-1,0,1,-2,0,2,-1,0,1};
	char h_maskt[] = {-1,-2,-1,0,0,0,1,2,1};
	char *d_mask, *d_maskt;
	char *imageName = argv[1];
	unsigned char *h_imageNormal, *d_imageNormal, *d_imageGray, *h_imageGray; 
	unsigned char *h_imageSobel, *d_imageSobel, *d_imageSobelX, *d_imageSobelY;

	Mat image;
	image = imread(imageName,1);

	Size s = image.size();
	int width = s.width;
	int height = s.height;
	int size = sizeof(unsigned char)*width*height*image.channels();
	int sizeGray = sizeof(unsigned char)*width*height;

	h_imageNormal = (unsigned char*)malloc(size);
	h_imageGray = (unsigned char*)malloc(sizeGray);
	h_imageSobel = (unsigned char*)malloc(sizeGray);

	cudaMalloc((void**)&d_imageNormal,size);
	cudaMalloc((void**)&d_imageGray,sizeGray);
	cudaMalloc((void**)&d_imageSobel,sizeGray);
	cudaMalloc((void**)&d_imageSobelX,sizeGray);
	cudaMalloc((void**)&d_imageSobelY,sizeGray);
	cudaMalloc((void**)&d_mask,sizeof(char)*9);
	cudaMalloc((void**)&d_maskt,sizeof(char)*9);

	h_imageNormal = image.data;

	cudaMemcpy(d_imageNormal,h_imageNormal,size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_mask,h_mask,sizeof(char)*9,cudaMemcpyHostToDevice);
	cudaMemcpy(d_maskt,h_maskt,sizeof(char)*9,cudaMemcpyHostToDevice);

	int blockSize = 32;
	dim3 dimBlock(blockSize,blockSize,1);
	dim3 dimGrid(ceil(width/float(blockSize)),ceil(height/float(blockSize)),1);

	gray<<<dimGrid,dimBlock>>>(d_imageNormal,width,height,d_imageGray);
	cudaDeviceSynchronize();
	sobelX_Y<<<dimGrid,dimBlock>>>(d_imageGray,width,height,3,d_mask,d_imageSobelX);
	sobelX_Y<<<dimGrid,dimBlock>>>(d_imageGray,width,height,3,d_maskt,d_imageSobelY);
	sobel<<<dimGrid,dimBlock>>>(d_imageSobelX,d_imageSobelY,width,height,d_imageSobel);
	
	cudaMemcpy(h_imageGray,d_imageGray,sizeGray,cudaMemcpyDeviceToHost);
	cudaMemcpy(h_imageSobel,d_imageSobel,sizeGray,cudaMemcpyDeviceToHost);

	Mat gray_image;
    gray_image.create(height,width,CV_8UC1);
    gray_image.data = h_imageGray;

    Mat sobel_image;
    sobel_image.create(height,width,CV_8UC1);
    sobel_image.data = h_imageSobel;

    namedWindow(imageName, CV_WINDOW_AUTOSIZE);
    namedWindow("Gray Image CUDA", CV_WINDOW_AUTOSIZE);
    namedWindow("Sobel Image OpenCV", CV_WINDOW_AUTOSIZE);

    imshow(imageName,image);
    imshow("Gray Image CUDA", gray_image);
    imshow("Sobel Image OpenCV",sobel_image);

    waitKey(0);

    cudaFree(d_imageNormal);
    cudaFree(d_imageGray);
    cudaFree(d_imageSobel);
    cudaFree(d_imageSobelX);
    cudaFree(d_imageSobelY);
    cudaFree(d_mask);
    cudaFree(d_maskt);

    free(h_imageNormal);
    free(h_imageGray);
    free(h_imageSobel);

    return 0;
}
