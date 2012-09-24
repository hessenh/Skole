#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <tmmintrin.h>

/* calculate n! */
double factorial_new(int n)
{
    double answer = n;
    for (int i = n-1; i > 1; i--)
        answer *= i;
    return answer;
}
/* calculate sin(x) using Taylor series expansion */
double slow_sin_new(double x)
{
    int i; double r = 0;
    __m128d factor, res, part, cx, nx;
    double xarr[2];
    res = _mm_set_pd(0,0);

    for(i=0;i<10000;i+=2)
    {
	factor = _mm_set_pd(factorial_new(i*2+1), factorial_new(i+2+3));
	part = _mm_set_pd(pow(x, i*2+1), pow(x, i+2+3));
	res = _mm_addsub_pd(res, part);
    }
    _mm_storeu_pd(xarr, res);
    return xarr[0] + xarr[1];
return r;
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
//	printf("%d R=%f\n", i, r);
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
	r = slow_sin_new(((float)atoi(argv[1]))/100);
    }
    printf("Ans: %f\n", r);

}

