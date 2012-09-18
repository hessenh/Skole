#include <stdio.h>
#include <stdlib.h>

#define N 8

int a = 1;


void devide(int ** in, int count)
{
    if (count <= 1)
	*in[0] = a++;
    else
    {
	int** out1 = (int**)malloc(sizeof(int*)*count/2);
	int** out2 = (int**)malloc(sizeof(int*)*count/2);

	for (int i = 0; i < count/2; i++)
	{
	    out1[i] = in[i*2];
	    out2[i] = in[i*2+1];
	}
	devide(out1, count/2);
	devide(out2, count/2);
    }
}

int main()
{
    int** array = (int**)malloc(sizeof(int*)*N);
    for (int i = 0; i < N; i++)
    {
	array[i] = (int*)malloc(sizeof(int));
	*array[i] = i;
    }
    devide(array, N);
    for (int i = 0; i < N; i++)
	printf("%d\t", *array[i]);
}
