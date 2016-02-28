#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>

#define row 3
#define col 3

int llenarMatriz(int **matriz){
	int i,j;
	
	for(i=0;i<row;i=i+1){
		for(j=0;j<col;j=j+1){
			matriz[i][j]=rand() % row;
		}
	}
	
	return 0;
}
int multiplicarMatrices(int **matriz1, int **matriz2, int **suma){
	
	int i,j,k;
	
	for (i=0;i<row; i=i+1) {
		for (j=0;j<col;j=j+1) {
			suma[i][j] = 0;
			for (k=0; k<col;k++) {
				suma[i][j]=suma[i][j]+matriz1[i][k]*matriz2[k][j];
			}
		}
	}
	
	return 0;
}

int main ()
{
	int i,j;
	
	int** matriz1;
	matriz1 = (int**)malloc(row*sizeof(int*));
	for(i=0;i<row;i=i+1){
		matriz1[i]=(int*)malloc(col*sizeof(int));
	}
	
	int** matriz2;
	matriz2 = (int**)malloc(row*sizeof(int*));
	for(i=0;i<row;i=i+1){
		matriz2[i]=(int*)malloc(col*sizeof(int));
	}
	
	int** total_suma;
	total_suma = (int**)malloc(row*sizeof(int*));
	for(i=0;i<row;i=i+1){
		total_suma[i]=(int*)malloc(col*sizeof(int));
	}
	
	llenarMatriz(matriz1);
	llenarMatriz(matriz2);
	multiplicarMatrices(matriz1,matriz2,total_suma);
	
	for (i=0;i<row;i=i+1) 
	{ 
		printf("\n"); 
		for (j=0;j<col;j=j+1) 
			printf("\t%d", matriz1[i][j] ); 
	} 
	printf("\n"); 
	for (i=0;i<row;i=i+1) 
	{ 
		printf("\n"); 
		for (j=0;j<col;j=j+1) 
			printf("\t%d", matriz2[i][j] ); 
	} 
	printf("\n"); 
	for (i=0;i<row;i=i+1) 
	{ 
		printf("\n"); 
		for (j=0;j<col;j=j+1) 
			printf("\t%d", total_suma[i][j] ); 
	} 
	
	// liberamos memoria
	free (matriz1);
	free (matriz2);
	free (total_suma);
	
	return 0;
}
