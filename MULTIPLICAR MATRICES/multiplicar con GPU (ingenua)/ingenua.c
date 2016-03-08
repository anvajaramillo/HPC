#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>
#include <cuda.h>

#define row 3
#define col 3

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

	int k;
	int colum = threadIdx.x + blockDim.x * blockIdx.x;
	int filas = threadIdx.y + blockDim.y * blockIdx.y;
	mul[filas*col+colum] = 0;
	
	if((colum < col) && (filas < row )){	
		for (k=0; k<col;k=k+1) {
			mul[filas*col+colum]=mul[filas*col+colum]+matriz1[filas*col+k]*matriz2[k*col+colum];
		}
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

    //~ for (i=0;i<row;i=i+1)
    //~ {
        //~ printf("\n");
        //~ for (j=0;j<col;j=j+1)
            //~ printf("\t%d", matriz1[i*col+j] );
    //~ }

    //~ printf("\n");

    //~ for (i=0;i<row;i=i+1)
    //~ {
        //~ printf("\n");
        //~ for (j=0;j<col;j=j+1)
            //~ printf("\t%d", matriz2[i*col+j] );
    //~ }

    //~ printf("\n");

    //~ for (i=0;i<row;i=i+1)
    //~ {
        //~ printf("\n");
        //~ for (j=0;j<col;j=j+1)
            //~ printf("\t%d", total_mul[i*col+j] );
    //~ }

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
