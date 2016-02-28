#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>

#define n 100

int llenarVector(int *vector){
	int i;
	 for(i=0;i<n;i=i+1){
	 	vector[i]=rand() % n;
	 }
	 return 0;
}
int sumarVectores(int *vector1, int *vector2, int *suma){
	int i;
	for(i=0;i<n;i=i+1){
		suma[i]=vector1[i]+vector2[i];
	}
	return 0;
}

int main ()
{
	int* vector1;
	vector1 = (int*)malloc(n*sizeof(int));
	int* vector2;
	vector2 = (int*)malloc(n*sizeof(int));
	int* total_suma;
	total_suma = (int*)malloc(n*sizeof(int));
	
	llenarVector(vector1);
	llenarVector(vector2);
	
	clock_t start = clock(); 
	sumarVectores(vector1,vector2,total_suma);
	printf("%f; ", ((double)clock() - start) / CLOCKS_PER_SEC);
	
	printf("suma total: %d",vector1[1]);
	printf("suma total: %d",vector2[1]);
	printf("suma total: %d",total_suma[1]);
	
	// trabajamos con el vector
	
	// lo liberamos
	free (vector1);
	free (vector2);
	free (total_suma);
	
	return 0;
}
