#include <cv.h>
#include <cv.h>
#include <highgui.h>
#include <time.h>
#include <cuda.h>
#include <math.h>
#include <time.h>

#define RED 2
#define GREEN 1
#define BLUE 0

#define MASK_WIDTH 3
#define TILE_SIZE 32

__constant__ char d_mask[MASK_WIDTH*MASK_WIDTH];
__constant__ char d_maskt[MASK_WIDTH*MASK_WIDTH];

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

__global__ void sobelX(unsigned char *imageGray, int width, int height, unsigned int maskWidth, unsigned char *imageSobel){
	__shared__ float N_ds[TILE_SIZE + MASK_WIDTH - 1][TILE_SIZE+ MASK_WIDTH - 1];			//se establecen la submatriz y queda en memoria compartida
																																										//el tamaño del array en memoria global debe ser mas largo que el vector normal para darle espacio a los elementos de la izquierda, centro y derecha en total es TILE_SIZE + MASK_WIDTH - 1
    int n = maskWidth/2;
    
    //------Cargar los elementos de la matriz de la matriz de entrada en memoria compartida------
    //Cargar elementos izquierda derecha
    int dest = threadIdx.y*TILE_SIZE+threadIdx.x;
	int destY = dest / (TILE_SIZE+MASK_WIDTH-1);
	int destX = dest % (TILE_SIZE+MASK_WIDTH-1);
    int srcY = blockIdx.y * TILE_SIZE + destY - n;
	int srcX = blockIdx.x * TILE_SIZE + destX - n;
    int src = (srcY * width + srcX);
	
    if (srcY >= 0 && srcY < height && srcX >= 0 && srcX < width)		//si srcY es negativo son elementos fantasmas, si srcX es negativo son elementos fantasmas
        N_ds[destY][destX] = imageGray[src];
    else
        N_ds[destY][destX] = 0;					//asigna en 0 los elementos fantasmas

    //Cargar elementos del centro
    dest = threadIdx.y * TILE_SIZE + threadIdx.x + TILE_SIZE * TILE_SIZE;
    destY = dest /(TILE_SIZE + MASK_WIDTH - 1);
	destX = dest % (TILE_SIZE + MASK_WIDTH - 1);
    srcY = blockIdx.y * TILE_SIZE + destY - n;
    srcX = blockIdx.x * TILE_SIZE + destX - n;
    src = (srcY * width + srcX);
	
    if (destY < TILE_SIZE + MASK_WIDTH - 1) {
        if (srcY >= 0 && srcY < height && srcX >= 0 && srcX < width)
            N_ds[destY][destX] = imageGray[src];
        else
            N_ds[destY][destX] = 0;
    }
    __syncthreads();
    //------Termina de cargar los elementos de la matriz de la matriz de entrada en memoria compartida------

		//-----llenamos la matriz de salida
    int accum = 0;
    int y, x;
    for (y = 0; y < maskWidth; y++)
        for (x = 0; x < maskWidth; x++)
            accum += N_ds[threadIdx.y + y][threadIdx.x + x] * d_mask[y * maskWidth + x];
    y = blockIdx.y * TILE_SIZE + threadIdx.y;
    x = blockIdx.x * TILE_SIZE + threadIdx.x;
    if (y < height && x < width)
        imageSobel[(y * width + x)] = clamp(accum);
    __syncthreads();
    //-----terminamos de llenar la matriz de salida

}

__global__ void sobelY(unsigned char *imageGray, int width, int height, unsigned int maskWidth, unsigned char *imageSobel){
	__shared__ float N_ds[TILE_SIZE + MASK_WIDTH - 1][TILE_SIZE+ MASK_WIDTH - 1];			//se establecen la submatriz y queda en memoria compartida
																																										//el tamaño del array en memoria global debe ser mas largo que el vector normal para darle espacio a los elementos de la izquierda, centro y derecha en total es TILE_SIZE + MASK_WIDTH - 1
    int n = maskWidth/2;
    
    //------Cargar los elementos de la matriz de la matriz de entrada en memoria compartida------
    //Cargar elementos izquierda derecha
    int dest = threadIdx.y*TILE_SIZE+threadIdx.x;
	int destY = dest / (TILE_SIZE+MASK_WIDTH-1);
	int destX = dest % (TILE_SIZE+MASK_WIDTH-1);
    int srcY = blockIdx.y * TILE_SIZE + destY - n;
	int srcX = blockIdx.x * TILE_SIZE + destX - n;
    int src = (srcY * width + srcX);
	
    if (srcY >= 0 && srcY < height && srcX >= 0 && srcX < width)		//si srcY es negativo son elementos fantasmas, si srcX es negativo son elementos fantasmas
        N_ds[destY][destX] = imageGray[src];
    else
        N_ds[destY][destX] = 0;					//asigna en 0 los elementos fantasmas

    //Cargar elementos del centro
    dest = threadIdx.y * TILE_SIZE + threadIdx.x + TILE_SIZE * TILE_SIZE;
    destY = dest /(TILE_SIZE + MASK_WIDTH - 1);
	destX = dest % (TILE_SIZE + MASK_WIDTH - 1);
    srcY = blockIdx.y * TILE_SIZE + destY - n;
    srcX = blockIdx.x * TILE_SIZE + destX - n;
    src = (srcY * width + srcX);
	
    if (destY < TILE_SIZE + MASK_WIDTH - 1) {
        if (srcY >= 0 && srcY < height && srcX >= 0 && srcX < width)
            N_ds[destY][destX] = imageGray[src];
        else
            N_ds[destY][destX] = 0;
    }
    __syncthreads();
    //------Termina de cargar los elementos de la matriz de la matriz de entrada en memoria compartida------

		//-----llenamos la matriz de salida
    int accum = 0;
    int y, x;
    for (y = 0; y < maskWidth; y++)
        for (x = 0; x < maskWidth; x++)
            accum += N_ds[threadIdx.y + y][threadIdx.x + x] * d_maskt[y * maskWidth + x];
    y = blockIdx.y * TILE_SIZE + threadIdx.y;
    x = blockIdx.x * TILE_SIZE + threadIdx.x;
    if (y < height && x < width)
        imageSobel[(y * width + x)] = clamp(accum);
    __syncthreads();
    //-----terminamos de llenar la matriz de salida

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

	h_imageNormal = image.data;
	
	clock_t start = clock(); 

	cudaMemcpy(d_imageNormal,h_imageNormal,size, cudaMemcpyHostToDevice);
	
	cudaMemcpyToSymbol(d_mask,h_mask,sizeof(char)*MASK_WIDTH*MASK_WIDTH);
	cudaMemcpyToSymbol(d_maskt,h_maskt,sizeof(char)*MASK_WIDTH*MASK_WIDTH);
	

	int blockSize = 32;
	dim3 dimBlock(blockSize,blockSize,1);
	dim3 dimGrid(ceil(width/float(blockSize)),ceil(height/float(blockSize)),1);

	gray<<<dimGrid,dimBlock>>>(d_imageNormal,width,height,d_imageGray);
	cudaDeviceSynchronize();
	sobelX<<<dimGrid,dimBlock>>>(d_imageGray,width,height,MASK_WIDTH,d_imageSobelX);
	sobelY<<<dimGrid,dimBlock>>>(d_imageGray,width,height,MASK_WIDTH,d_imageSobelY);
	sobel<<<dimGrid,dimBlock>>>(d_imageSobelX,d_imageSobelY,width,height,d_imageSobel);
	
	cudaMemcpy(h_imageGray,d_imageGray,sizeGray,cudaMemcpyDeviceToHost);
	cudaMemcpy(h_imageSobel,d_imageSobel,sizeGray,cudaMemcpyDeviceToHost);

	printf("%f;\n", ((double)clock() - start) / CLOCKS_PER_SEC);

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

    //free(h_imageNormal);
    //free(h_imageGray);
    //free(h_imageSobel);

    return 0;
}
