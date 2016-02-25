#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>
#include <cuda.h>

#define n 100

void llenarVector(int *vector){
	 int i;
	 for(i=0;i<n;i++){
		vector[i]=rand() % n;
	 }
}

//funci�n paralelizada, (no se hace ciclos, sino que se manejan hilos
__global__ void sumarVectores(int *vector1, int *vector2, int *suma){
	int i = threadIdx.x;
	suma[i] = vector1[i] + vector2[i];
}

int main ()
{ 
	clock_t start = clock();  
	
	//inicializar valores CPU
	int *vector1, *vector2, *total_suma;
	vector1 = (int*)malloc(n*sizeof(int));
	vector2 = (int*)malloc(n*sizeof(int));
	total_suma = (int*)malloc(n*sizeof(int));
	llenarVector(vector1);
	llenarVector(vector2);
	
	//inicializar valores GPU
	int *d_x, *d_y, *d_z;
	cudaMalloc((void **) &d_x,n * sizeof(int));
	cudaMalloc((void **) &d_y,n * sizeof(int));
	cudaMalloc((void **) &d_z,n * sizeof(int));
	
	//copia de datos desde el host al device
	cudaMemcpy(d_x, vector1, n * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, vector2, n * sizeof(int), cudaMemcpyHostToDevice);
	
	//ejecuci�n del kernel un bloque de n hilos
	sumarVectores<<<1,n>>>(d_x,d_y,d_z);
	
	//copia de datos desde el device al host
	cudaMemcpy(total_suma, d_z, n * sizeof(int), cudaMemcpyDeviceToHost);
	
	//mostramos resultados
	printf("suma %d + %d = %d",vector1[0],vector2[0],total_suma[0]);
	
	//liberar espacio de memoria CPU
	free (vector1);
	free (vector2);
	free (total_suma);
	
	//liberar espacio de memoria GPU
	cudaFree(d_x);
	cudaFree(d_y);
	cudaFree(d_z);
	
	printf("Tiempo transcurrido: %f", ((double)clock() - start) / CLOCKS_PER_SEC);
	
	return 0;
}
