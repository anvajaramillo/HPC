#include <cv.h>
#include <highgui.h>
#include <math.h>
#include <stdio.h>
#include <unistd.h> 
#include <stdlib.h> 
#include <iostream>
#include <string>

using namespace cv;

#define RED 2
#define GREEN 1
#define BLUE 0

void img2gray(unsigned char *imgOutput, unsigned char *imgInput, int width, int height)
{

    for (int row = 0; row < height; row++)
    {
        for (int col = 0; col < width; col++)
        {
            imgOutput[row * width + col] = imgInput[(row * width + col) * 3 + RED] * 0.299 + imgInput[(row * width + col) * 3 + GREEN] * 0.587 + imgInput[(row * width + col) * 3 + BLUE] * 0.114;
        }
    }
}

unsigned char clamp(int value)
{
    if(value < 0)
        value = 0;
    else
        if(value > 255)
            value = 255;
    return (unsigned char)value;
}

void suavizar(unsigned char *imgOutput, int maskWidth, char *M, unsigned char *imgInput, int width, int height)
{
    int row;
    int col;
    int Pvalue;

    int N_start_point_row;
    int N_start_point_col;


    for (row = 0; row < height; row++)
    {
        for (col = 0; col < width; col++)
        {
        		Pvalue = 0;
            N_start_point_row = row - (maskWidth/2);
            N_start_point_col = col - (maskWidth/2);
            for(int i = 0; i < maskWidth; i++)
            {
								for(int j = 0; j < maskWidth; j++ )
								{
								    if((N_start_point_col + j >=0 && N_start_point_col + j < width)
								            &&(N_start_point_row + i >=0 && N_start_point_row + i < height))
								    {
								        Pvalue += imgInput[(N_start_point_row + i)*width+(N_start_point_col + j)] * M[i*maskWidth+j];
								        //printf("%d Pvalue: ",Pvalue);
								    }
								}
   					}
   					
   					imgOutput[row * width + col] = clamp(Pvalue/159);
   					//printf("Pvalue: %d", clamp(Pvalue));
        }
    }
}

void sobelGrad(unsigned char *imgOutput, int maskWidth, char *M, unsigned char *imgInput, int width, int height)
{
    int row;
    int col;
    int Pvalue;

    int N_start_point_row;
    int N_start_point_col;


    for (row = 0; row < height; row++)
    {
        for (col = 0; col < width; col++)
        {
        		Pvalue = 0;
            N_start_point_row = row - (maskWidth/2);
            N_start_point_col = col - (maskWidth/2);
            for(int i = 0; i < maskWidth; i++)
            {
								for(int j = 0; j < maskWidth; j++ )
								{
								    if((N_start_point_col + j >=0 && N_start_point_col + j < width)
								            &&(N_start_point_row + i >=0 && N_start_point_row + i < height))
								    {
										
								        Pvalue += imgInput[(N_start_point_row + i)*width+(N_start_point_col + j)] * M[i*maskWidth+j];
								        //printf("%d Pvalue: ",Pvalue);
								    }
								}
   					}
   					
   					imgOutput[row * width + col] = clamp(Pvalue);
   					//printf("Pvalue: %d", clamp(Pvalue));
        }
    }
}

void sobelFilter(unsigned char *imgSobel, unsigned char *sobelOutputX, unsigned char *sobelOutputY, int width, int height,unsigned char *edgeDir)
{
	float thisAngle;
	int newAngle;
    int row;
    int col;

	for (row = 0; row < height; row++)
    {
        for (col = 0; col < width; col++)
        {
            imgSobel[row * width + col] = (sqrt( pow(sobelOutputX[row * width + col],2) + pow(sobelOutputY[row * width + col],2)) );
			thisAngle = (atan2(sobelOutputX[row * width + col],sobelOutputY[row * width + col])/3.14159)*180.0;
        
			/* Convert actual edge direction to approximate value */
			if ( ( (thisAngle < 22.5) && (thisAngle > -22.5) ) || (thisAngle > 157.5) || (thisAngle < -157.5) )
				newAngle = 0;
			if ( ( (thisAngle > 22.5) && (thisAngle < 67.5) ) || ( (thisAngle < -112.5) && (thisAngle > -157.5) ) )
				newAngle = 45;
			if ( ( (thisAngle > 67.5) && (thisAngle < 112.5) ) || ( (thisAngle < -67.5) && (thisAngle > -112.5) ) )
				newAngle = 90;
			if ( ( (thisAngle > 112.5) && (thisAngle < 157.5) ) || ( (thisAngle < -22.5) && (thisAngle > -67.5) ) )
				newAngle = 135;
				
			edgeDir[row * width + col] = newAngle;		// Store the approximate edge direction of each pixel in one array
        }
    }
}

//~ void NoSupreMax(int width, int height, unsigned char *imgSobel, unsigned char *edgeDir){
	//~ int upperThreshold = 60;	// Gradient strength nessicary to start edge
	//~ int lowerThreshold = 30;	// Minimum gradient strength to continue edge
	//~ bool edgeEnd;				// Stores whether or not the edge is at the edge of the possible image
	//~ int row,col;
	//~ /* Trace along all the edges in the image */
	//~ for (row = 0; row < height; row++) {
		//~ for (col = 0; col < width; col++) {
			//~ edgeEnd = false;
			//~ if (imgSobel[row * width + col] > upperThreshold) {		// Check to see if current pixel has a high enough gradient strength to be part of an edge
				//~ /* Switch based on current pixel's edge direction */
				//~ switch (edgeDir[row * width + col]){
					//~ case 0:
						//~ findEdge(0, 1, row, col, 0, lowerThreshold);
						//~ break;
					//~ case 45:
						//~ findEdge(1, 1, row, col, 45, lowerThreshold);
						//~ break;
					//~ case 90:
						//~ findEdge(1, 0, row, col, 90, lowerThreshold);
						//~ break;
					//~ case 135:
						//~ findEdge(1, -1, row, col, 135, lowerThreshold);
						//~ break;
				//~ }
			//~ }
		//~ }
	//~ }
//~ }

void NoSupreMax(int width, int height, unsigned char *imgSobel, unsigned char *edgeDir,unsigned char *nosupmax){
	int row,col;
	for (row = 0; row < height; row++) {
		for (col = 0; col < width; col++) {
			if((imgSobel[row * width + col-1] < imgSobel[row * width + col]) && (imgSobel[row * width + col]< imgSobel[row * width + col+1])){
				nosupmax[row * width + col] = imgSobel[row * width + col];
			}else{
				nosupmax[row * width + col] = 0;
			}
		}
	}

}

int main(int argc, char **argv)
{
    clock_t start, end;
    double cpu_time_used;

    char *imageName = argv[1];
    char M[] = {-1,0,1,-2,0,2,-1,0,1};
    char Mt[] = {-1,-2,-1,0,0,0,1,2,1};
    char S[] = {2,4,5,4,2,4,9,12,9,4,5,12,15,12,5,4,9,12,9,4,2,4,5,4,2};
    unsigned char *dataRawImage, *imgOutput;
    unsigned char *imgSobel, *sobelOutputX, *sobelOutputY, *suavizada, *edgeDir, *nosupmax;
    
    Mat image;
    image = imread(imageName, 1);
  
    Size img_size = image.size();

    int width = img_size.width;
    int height = img_size.height;
    int size = sizeof(unsigned char) * width * height * image.channels();
    int sizeGray = sizeof(unsigned char) * width * height;

    dataRawImage = (unsigned char*)malloc(size);
    imgOutput = (unsigned char*)malloc(sizeGray);
    suavizada = (unsigned char*)malloc(sizeGray);
    sobelOutputX = (unsigned char*)malloc(sizeGray);
    sobelOutputY = (unsigned char*)malloc(sizeGray);
    imgSobel = (unsigned char*)malloc(sizeGray);
    edgeDir = (unsigned char*)malloc(sizeGray);
    nosupmax = (unsigned char*)malloc(sizeGray);

    dataRawImage = image.data;

    start = clock();

    img2gray(imgOutput, dataRawImage, width, height);

    
    
    //Suavizado
    suavizar(suavizada, 5, S, imgOutput, width, height);
    
    Mat gray_image, grad_x, abs_grad_x;
    gray_image.create(height,width,CV_8UC1);
    gray_image.data = suavizada;

    // Gradient X
	sobelGrad(sobelOutputX, 3, M, suavizada, width, height);
		
	// Gradient Y
	sobelGrad(sobelOutputY, 3, Mt, suavizada, width, height);

	// Gradient Magnitude
    sobelFilter(imgSobel, sobelOutputX, sobelOutputY, width, height, edgeDir);

	//Supresión Máxima
	NoSupreMax(width,height,imgSobel,edgeDir,nosupmax);

    end = clock();

    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    printf("%.10f\n",cpu_time_used);

    
    Mat sobel_image;
    sobel_image.create(height,width,CV_8UC1);
    sobel_image.data = imgSobel;
    
    Mat nosupmax_image;
    nosupmax_image.create(height,width,CV_8UC1);
    nosupmax_image.data = nosupmax;
    
    namedWindow(imageName, WINDOW_NORMAL);
    namedWindow("Gray Image Suavizada", WINDOW_NORMAL);
    namedWindow("Sobel Image", WINDOW_NORMAL);
    namedWindow("No Supesion Image", WINDOW_NORMAL);
    imshow(imageName,image);
    imshow("Gray Image Suavizada", gray_image);
    imshow("Sobel Image", sobel_image);
    imshow("No Supesion Image", nosupmax_image);
    waitKey(0);
    

    //free(dataRawImage);
    //free(imgOutput);
    //free(sobelOutputX);
    //free(sobelOutputY);
    //free(imgSobel);  

    return 0;
}
