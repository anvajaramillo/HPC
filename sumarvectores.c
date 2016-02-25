#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define n 100

int llenarVector(int *vector){
	 for(int i=0;i<n;i++){
	 	vector[i]=rand() % n;
	 }
	 return 0;
}
int sumarVectores(int *vector1, int *vector2, int *suma){
	
	for(int i=0;i<n;i++){
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
	sumarVectores(vector1,vector2,total_suma);
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
