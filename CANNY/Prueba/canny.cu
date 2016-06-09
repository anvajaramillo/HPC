#include <cv.h>
#include <highgui.h>
#include <math.h>
#include <stdio.h>
#include <unistd.h> 
#include <stdlib.h> 
#include <iostream>
#include <string>
#include <cuda.h>

using namespace cv;

#define RED 2
#define GREEN 1
#define BLUE 0

#define MASK_WIDTH_M 3
#define MASK_WIDTH_S 5

#define TILE_SIZE 32	//tamaño de las submatrices
    
__constant__ char d_M[MASK_WIDTH_M*MASK_WIDTH_M];
__constant__ char d_Mt[MASK_WIDTH_M*MASK_WIDTH_M];
__constant__ char d_S[MASK_WIDTH_S*MASK_WIDTH_S];

__device__ unsigned char clamp(int value)
{
    if(value < 0)
        value = 0;
    else
        if(value > 255)
            value = 255;
    return (unsigned char)value;
}

__global__ void img2gray(unsigned char *imgOutput, unsigned char *imgInput, int width, int height)
{
    int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;

    if((row < height) && (col < width)){
        imgOutput[row * width + col] = imgInput[(row * width + col) * 3 + RED] * 0.299 + imgInput[(row * width + col) * 3 + GREEN] * 0.587 + imgInput[(row * width + col) * 3 + BLUE] * 0.114;
    }   
    
}

__global__ void gauss(unsigned char *imgOutput, int maskWidth, unsigned char *imgInput, int width, int height)
{
    int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;
    
	int Pvalue = 0;
    int N_start_point_row = row - (maskWidth/2);
    int N_start_point_col = col - (maskWidth/2);

    if((row < height) && (col < width)){
        for(int i = 0; i < maskWidth; i++){
		  		for(int j = 0; j < maskWidth; j++ ){
		  		    if((N_start_point_col + j >=0 && N_start_point_col + j < width)
		  		            &&(N_start_point_row + i >=0 && N_start_point_row + i < height)){
		  		        Pvalue += imgInput[(N_start_point_row + i)*width+(N_start_point_col + j)] * d_S[i*maskWidth+j];
		  		    }
		  		}
        }
        imgOutput[row * width + col] = clamp(Pvalue/159);
    }
}

__global__ void sobelGradX(unsigned char *imgOutput, int maskWidth, unsigned char *imgInput, int width, int height)
{
	__shared__ float N_ds[TILE_SIZE][TILE_SIZE]; //se establecen la submatriz y queda en memoria compartida		
		
    int y = blockIdx.y * TILE_SIZE + threadIdx.y;
    int x = blockIdx.x * TILE_SIZE + threadIdx.x;
    
    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int row = by * TILE_SIZE + ty;
    int col = bx * TILE_SIZE + tx;
    
    int Pvalue = 0;
    int N_start_point_row = row - (maskWidth/2);
    int N_start_point_col = col - (maskWidth/2);

    for(int m = 0; m < col / TILE_SIZE; m=m+1){
    	
    	N_ds[ty][tx] = imgInput[row*width + m*TILE_SIZE + tx];
    	__syncthreads(); 
    
        for(int i = 0; i < maskWidth; i++){
					for(int j = 0; j < maskWidth; j++ ){
							if((N_start_point_col + j >=0 && N_start_point_col + j < width)
							        &&(N_start_point_row + i >=0 && N_start_point_row + i < height)){						    
							    Pvalue += N_ds[N_start_point_row + i][N_start_point_col + j] * d_M[i*maskWidth+j];
							}
					}
				}	
				if (y < height && x < width)
					imgOutput[(y * width + x)] = clamp(Pvalue);
				__syncthreads(); 
    }    
    
}

__global__ void sobelGradY(unsigned char *imgOutput, int maskWidth, unsigned char *imgInput, int width, int height)
{
    int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;

    int Pvalue = 0;
    int N_start_point_row = row - (maskWidth/2);
    int N_start_point_col = col - (maskWidth/2);

    if((row < height) && (col < width)){
        for(int i = 0; i < maskWidth; i++){
					for(int j = 0; j < maskWidth; j++ ){
							if((N_start_point_col + j >=0 && N_start_point_col + j < width)
							        &&(N_start_point_row + i >=0 && N_start_point_row + i < height)){
							    Pvalue += imgInput[(N_start_point_row + i)*width+(N_start_point_col + j)] * d_Mt[i*maskWidth+j];
							}
					}
		}	
		imgOutput[row * width + col] = clamp(Pvalue);
    }    
    
}

__global__ void sobelFilter(unsigned char *imgSobel, unsigned char *sobelOutputX, unsigned char *sobelOutputY, int width, int height)
{
    int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;

    if((row < height) && (col < width)){
        imgSobel[row * width + col] = __powf((__powf(sobelOutputX[row * width + col],2) + __powf(sobelOutputY[row * width + col],2)), 0.5) ;

    }  
    
}

__global__ void NoSupreMax(int width, int height, unsigned char *imgSobel,unsigned char *nosupmax){
	int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;

    if((row < height) && (col < width)){
		if((imgSobel[row * width + col-1] < imgSobel[row * width + col]) && (imgSobel[row * width + col]< imgSobel[row * width + col+1])){
			nosupmax[row * width + col] = imgSobel[row * width + col];
		}else{
			nosupmax[row * width + col] = 0;
		}
	}	
	

}

int main(int argc, char **argv)
{
    clock_t start, end;
    double cpu_time_used;

    char *imageName = argv[1];
    char h_M[] = {-1,0,1,-2,0,2,-1,0,1};
    char h_Mt[] = {-1,-2,-1,0,0,0,1,2,1};
    char h_S[] = {2,4,5,4,2,4,9,12,9,4,5,12,15,12,5,4,9,12,9,4,2,4,5,4,2};
    unsigned char *h_dataRawImage, *h_imgOutput, *h_imgSobel, *h_suavizada, *h_nosupmax;
    unsigned char *d_dataRawImage, *d_imgOutput, *d_imgSobel, *d_suavizada, *d_nosupmax, *d_sobelOutputX, *d_sobelOutputY;
    
    Mat image;
    image = imread(imageName, 1);
  
    Size img_size = image.size();

    int width = img_size.width;
    int height = img_size.height;
    int size = sizeof(unsigned char) * width * height * image.channels();
    int sizeGray = sizeof(unsigned char) * width * height;

    h_dataRawImage = (unsigned char*)malloc(size);
    h_imgOutput = (unsigned char*)malloc(sizeGray);
    h_suavizada = (unsigned char*)malloc(sizeGray);
    h_imgSobel = (unsigned char*)malloc(sizeGray);
    h_nosupmax = (unsigned char*)malloc(sizeGray);

    cudaMalloc((void**)&d_dataRawImage,size);
    cudaMalloc((void**)&d_imgOutput,sizeGray);
    cudaMalloc((void**)&d_suavizada,sizeGray);
    cudaMalloc((void**)&d_imgSobel,sizeGray);
    cudaMalloc((void**)&d_nosupmax,sizeGray);
    cudaMalloc((void**)&d_sobelOutputX,sizeGray);
    cudaMalloc((void**)&d_sobelOutputY,sizeGray);
    cudaMalloc((void**)&d_M,sizeof(char)*9);
    cudaMalloc((void**)&d_Mt,sizeof(char)*9);
    cudaMalloc((void**)&d_S,sizeof(char)*25);

    h_dataRawImage = image.data;
	
    start = clock();

    cudaMemcpy(d_dataRawImage ,h_dataRawImage ,size, cudaMemcpyHostToDevice);
    
    cudaMemcpyToSymbol(d_M,h_M,sizeof(char)*MASK_WIDTH_M*MASK_WIDTH_M);
    cudaMemcpyToSymbol(d_Mt,h_Mt,sizeof(char)*MASK_WIDTH_M*MASK_WIDTH_M);
    cudaMemcpyToSymbol(d_S,h_S,sizeof(char)*MASK_WIDTH_S*MASK_WIDTH_S);

    int blockSize = 32;
    dim3 dimBlock(blockSize,blockSize,1);
    dim3 dimGrid(ceil(width/float(blockSize)),ceil(height/float(blockSize)),1);
    
    //Escala de Grises
    img2gray<<<dimGrid,dimBlock>>>(d_imgOutput, d_dataRawImage, width, height);
    cudaDeviceSynchronize();

    //Suavizado
    gauss<<<dimGrid,dimBlock>>>(d_suavizada, MASK_WIDTH_S, d_imgOutput, width, height);

    // Gradient X
	sobelGradX<<<dimGrid,dimBlock>>>(d_sobelOutputX, MASK_WIDTH_M, d_suavizada, width, height);
		
	// Gradient Y
	sobelGradY<<<dimGrid,dimBlock>>>(d_sobelOutputY, MASK_WIDTH_M, d_suavizada, width, height);

	// Gradient Magnitude
    sobelFilter<<<dimGrid,dimBlock>>>(d_imgSobel, d_sobelOutputX, d_sobelOutputY, width, height);

	//Supresión Máxima
	NoSupreMax<<<dimGrid,dimBlock>>>(width,height,d_imgSobel,d_nosupmax);

    cudaMemcpy(h_imgOutput,d_imgOutput,sizeGray,cudaMemcpyDeviceToHost);
    cudaMemcpy(h_suavizada,d_suavizada,sizeGray,cudaMemcpyDeviceToHost);
    cudaMemcpy(h_imgSobel,d_imgSobel,sizeGray,cudaMemcpyDeviceToHost);
    cudaMemcpy(h_nosupmax,d_nosupmax,sizeGray,cudaMemcpyDeviceToHost);

    end = clock();

    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    printf("%.10f\n",cpu_time_used);
	
    Mat gray_image;
    gray_image.create(height,width,CV_8UC1);
    gray_image.data = h_imgOutput;
	
    Mat suav_image;
    suav_image.create(height,width,CV_8UC1);
    suav_image.data = h_suavizada;
    
    Mat sobel_image;
    sobel_image.create(height,width,CV_8UC1);
    sobel_image.data = h_imgSobel;
    
    Mat nosupmax_image;
    nosupmax_image.create(height,width,CV_8UC1);
    nosupmax_image.data = h_nosupmax;
    
    namedWindow(imageName, WINDOW_NORMAL);
    namedWindow("Gray Image", WINDOW_NORMAL);
    namedWindow("Gray Image Suavizada", WINDOW_NORMAL);
    namedWindow("Sobel Image", WINDOW_NORMAL);
    namedWindow("No Supesion Image", WINDOW_NORMAL);
    
    imshow(imageName,image);
    imshow("Gray Image", gray_image);
    imshow("Gray Image Suavizada", suav_image);
    imshow("Sobel Image", sobel_image);
    imshow("No Supesion Image", nosupmax_image);

    waitKey(0); 

    cudaFree(d_dataRawImage); 
    cudaFree(d_imgOutput); 
    cudaFree(d_imgSobel); 
    cudaFree(d_suavizada);
    cudaFree(d_nosupmax);
    cudaFree(d_sobelOutputX);
    cudaFree(d_sobelOutputY);
    cudaFree(d_M);
    cudaFree(d_Mt);
    cudaFree(d_S);

    return 0;
}
