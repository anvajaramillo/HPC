#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>
#include <cuda.h>
#include<fstream>

#define row 3					//multiplos de TILE_WIDTH
#define col 3
#define TILE_WIDTH 32			//tamaño de las submatrices,

int llenarMatriz(int *matriz){
	
    int i,j;
    
    for(i=0;i<row;i=i+1){
        for(j=0;j<col;j=j+1){
            matriz[i*col+j]=rand() % row;
        }
    }

    return 0;
}
__global__ void multiplicarMatrices(int *matriz1, int *matriz2, int *mul){

	__shared__ int Mds[TILE_WIDTH][TILE_WIDTH];							//se establecen las submatrices y quedan en memoria compartida
    __shared__ int Nds[TILE_WIDTH][TILE_WIDTH];							//se establecen las submatrices y quedan en memoria compartida

    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int Row = by * TILE_WIDTH + ty;
    int Col = bx * TILE_WIDTH + tx;

    mul[Row*col+Col] = 0;
	int m,k;
    for(m = 0; m < col / TILE_WIDTH; m=m+1){
		Mds[ty][tx] = matriz1[Row*col + m*TILE_WIDTH + tx];				//se escriben los valores de memoria global a memoria compartida
		Nds[ty][tx] = matriz2[(m*TILE_WIDTH + ty) * col + Col];			//se escriben los valores de memoria global a memoria compartida
		__syncthreads();												//después de que se hayan escrito las matrices en memoria compartida, se estandariza el tiempo de los hilos para poder hacer la multiplicación

		for(k = 0; k < TILE_WIDTH; k=k+1){
			mul[Row*col+Col] = mul[Row*col+Col] + Mds[ty][k] * Nds[k][tx];//se guarda el resultado parcial de la operación de memoria compartida a memoria global
		}
		__syncthreads();												//se espera que cada uno de los hilos realiza la operación.
    }
  
    
}

int main ()
{
	//inicializar valores CPU
    int i,j;
	int* matriz1;
	int* matriz2;
    int* total_mul;
    matriz1 = (int*)malloc(row*col*sizeof(int));
    matriz2 = (int*)malloc(row*col*sizeof(int));
    total_mul = (int*)malloc(row*col*sizeof(int));
    llenarMatriz(matriz1);
    llenarMatriz(matriz2);
    
    //inicializar valores GPU
    int *d_x, *d_y, *d_z;
	cudaMalloc((void **) &d_x,row*col * sizeof(int));
	cudaMalloc((void **) &d_y,row*col * sizeof(int));
	cudaMalloc((void **) &d_z,row*col * sizeof(int));

	//inicializar valores de hilos y bloques
	float blockSize = 32.0; 													//tamaño de los bloques
	dim3 dimBlock(blockSize,blockSize,1);  										//cantidad de hilos (dimendion del bloque) 32 * 32 = 1024
	dim3 dimGrid(ceil(float(col)/blockSize),ceil(float(col)/blockSize),1);		//cantidad de bloques (dimensión de la grilla)
	
	clock_t start = clock(); 
	
	//copia de datos desde el host al device
	cudaMemcpy(d_x, matriz1, row*col * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, matriz2, row*col * sizeof(int), cudaMemcpyHostToDevice);
	
	//ejecución del kernel un bloque de n hilos
	
    multiplicarMatrices<<<dimGrid,dimBlock>>>(d_x,d_y,d_z);

	//copia de datos desde el device al host
	cudaMemcpy(total_mul, d_z, row*col * sizeof(int), cudaMemcpyDeviceToHost);
	
	printf("Tiempo transcurrido: %f", ((double)clock() - start) / CLOCKS_PER_SEC);

    // for (i=0;i<row;i=i+1)
    // {
        // printf("\n");
        // for (j=0;j<col;j=j+1)
            // printf("\t%d", matriz1[i*col+j] );
    // }

    // printf("\n");

    // for (i=0;i<row;i=i+1)
    // {
        // printf("\n");
        // for (j=0;j<col;j=j+1)
            // printf("\t%d", matriz2[i*col+j] );
    // }

    // printf("\n");

    //for (i=0;i<row;i=i+1)
    //{
        //printf("\n");
        //for (j=0;j<col;j=j+1)
            //printf("\t%d", total_mul[i*col+j] );
    //}
	
	//testValues(total_mul,d_z,col);

    //liberar espacio de memoria CPU
    free (matriz1);
    free (matriz2);
    free (total_mul);
    
    //liberar espacio de memoria GPU
	cudaFree(d_x);
	cudaFree(d_y);
	cudaFree(d_z);

    return 0;
}
