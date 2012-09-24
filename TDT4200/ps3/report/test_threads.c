#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>

double input;

 /* calculate n! */
double factorial_new(int n)
{
    double answer = n;
    for (int i = n-1; i > 1; i--)
        answer *= i;
    return answer;
}
/* calculate sin(x) using Taylor series expansion */
double slow_sin_new(double x, int start, int stride)
{
    double r=0; int i;
    for(i=start;i<10000;i+stride)
    {
	r += pow(x, i*2+1) / factorial_new(i*2+1);
	i++;
	r -= pow(x, i*2+1) / factorial_new(i*2+1);
    }
return r;
}

void* start_thread(void* rank)
{
    double* ans = malloc(sizeof(double));
    *ans = slow_sin_new(input, (int)rank * 2, 15);
    pthread_exit((void*)ans);
}


double factorial(int n) {
    if(n<2)
	return 1.0;
    else
	return (double)n*factorial(n-1);
}
/* calculate sin(x) using Taylor series expansion */
double slow_sin(double x) {
    double r=0; int i;
    for(i=0;i<10000;i++) {
	if(i%2==0) {
	    r += pow(x, i*2+1) / factorial(i*2+1);
	}
	else {
	    r -= pow(x, i*2+1) / factorial(i*2+1);
	}
    }
    return r;
}


int main(int argc, char** argv) {
    double r;
    if (argc == 3) {
	printf("Old\n");
	r = slow_sin(((float)atoi(argv[1]))/100);
    } else if (argc == 2) {
	printf("New\n");
	input = ((float)atoi(argv[1]))/100;
	pthread_t threads[8];
	for (int i = 0; i < 8; i++)
	    pthread_create(&threads[i], NULL, start_thread, (void*)i);
	for (int i = 0; i < 8; i++)
	{
	    double* val;
	    pthread_join(threads[i], (void*)&val);
	    r += *val;
	}
    }
    printf("Ans: %f\n", r);

}

