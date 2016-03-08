#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>

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
int multiplicarMatrices(int *matriz1, int *matriz2, int *mul){

    int i,j,k;

    for(i=0;i<row;i=i+1){
        for(j=0;j<col;j=j+1){
            mul[i*col+j] = 0;
            for (k=0; k<col;k++) {
                mul[i*col+j]=mul[i*col+j]+matriz1[i*col+k]*matriz2[k*col+j];
            }
        }
    }

    return 0;
}

int main ()
{
    int i,j;
	int* matriz1;
	int* matriz2;
    int* total_mul;

    matriz1 = (int*)malloc(row*col*sizeof(int));
    matriz2 = (int*)malloc(row*col*sizeof(int));
    total_mul = (int*)malloc(row*col*sizeof(int));

    llenarMatriz(matriz1);
    llenarMatriz(matriz2);
    
    clock_t start = clock();
    multiplicarMatrices(matriz1,matriz2,total_mul);
    printf("Tiempo transcurrido: %f", ((double)clock() - start) / CLOCKS_PER_SEC);

    //for (i=0;i<row;i=i+1)
    //{
    //    printf("\n");
    //    for (j=0;j<col;j=j+1)
    //        printf("\t%d", matriz1[i*col+j] );
    //}

    //printf("\n");

    //for (i=0;i<row;i=i+1)
    //{
    //    printf("\n");
    //    for (j=0;j<col;j=j+1)
    //        printf("\t%d", matriz2[i*col+j] );
    //}

    //printf("\n");

    //for (i=0;i<row;i=i+1)
    //{
    //    printf("\n");
    //    for (j=0;j<col;j=j+1)
    //        printf("\t%d", total_mul[i*col+j] );
    //}

    // liberamos memoria
    free (matriz1);
    free (matriz2);
    free (total_mul);

    return 0;
}
