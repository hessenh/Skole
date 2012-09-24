/*
 * Written by Stian Hvatum, 6. sept. 2012
 * 
 * This file is an implementation of Amdahl's law as an optimization problem.
 * Parameters are given as statet in Task 2, Problem Set 2, TDT4200 Fall 2012.
 *
 */


#include <stdio.h>
#include <math.h>

float speedup(float f,int n,int r,float (*perf)(int))
{
    return (1 / (((1-f)/(*perf)(r)) + f/((*perf)(r)+n-r)));
}

float perfA(int r)
{
    return sqrt(r);
}

float perfB(int r)
{
    return pow(r,1.0f/3.0f);
}

int main()
{
    float res[4];
    float max[4];
    int ind[4];

    int i = 0;
    int j = 0;

    for (i = 0; i < 4; i++)
    {
	res[i] = 0;
	max[i] = 0;
	ind[i] = 0;
    }

    for (i = 0; i < 1024; i++)
    {
      res[0] = speedup(0.8, 1024, i, &perfA);
      res[1] = speedup(0.5, 1024, i, &perfA);
      res[2] = speedup(0.8, 1024, i, &perfB);
      res[3] = speedup(0.5, 1024, i, &perfB);

      for (j = 0; j < 4; j++)
      {
	if (res[j] > max[j])
	{
	    max[j] = res[j];
	    ind[j] = i;
	}
      }
    }

    for (i = 0; i < 4; i++)
    {
	printf("Result %d: Max. perf. @ R=%d, speedup is %f\n", i, ind[i], max[i]);
    }
}
