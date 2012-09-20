#include <stdio.h>
#include <stdlib.h>
#include <complex.h>
#include <fftw3.h>
#include <math.h>

#include <tmmintrin.h>

#define PI 3.14159265358979323846


#define BYTETOBINARYPATTERN "%d%d%d%d%d%d%d%d"
#define BYTETOBINARY(byte)  \
      (byte & 0x80 ? 1 : 0), \
  (byte & 0x40 ? 1 : 0), \
  (byte & 0x20 ? 1 : 0), \
  (byte & 0x10 ? 1 : 0), \
  (byte & 0x08 ? 1 : 0), \
  (byte & 0x04 ? 1 : 0), \
  (byte & 0x02 ? 1 : 0), \
  (byte & 0x01 ? 1 : 0) 

// Timing function
// rdtcs returns number of processor cycles
static unsigned long long rdtsctime() {
    unsigned int eax, edx;
    unsigned long long val;
    __asm__ __volatile__("rdtsc":"=a"(eax), "=d"(edx));
    val = edx;
    val = val << 32;
    val += eax;
    return val;
}

void my_fft(complex double * in, complex double * out, int n){
    //  Enter your FFT code here

    // Keywords: inplace, SIMD, D&C
    // Few as possible: malloc, free, function call (and recursion)

    // Wikipedia said "do bit reversal for inplace FFT", found C alg on web
    int j = 0;
    for (int i = 0; i < n-1; i++)
    {
	if (i <= j)
	{
	    out[i] = in[j];
	    out[j] = in[i];
	}
	int k = n/2;
	while (k <= j)
	{
	    j -= k;
	    k /= 2;
	}
	j += k;
    }
    // Last number ain't affected by loop, set it here
    out[n-1] = in[n-1];
    
    __m128d x,y,a;
   
    /*  /
    / * / Do FFT calculations
    /  */
    int N = 1; // There are just 1 number at base case
    int steps = log2(n);
    for (int step = 0; step < steps; step++) // Do steps
    {
	N *= 2; // Each step doubles number of numbers
	for (int k = 0; k < N/2; k++) // This is "combine"-step
	{
	    // TODO: Can do cos and sin approx. with SSSE3. Look at Taylor series
	    complex double ti = cos(-2*PI*k/N) + I * sin(-2*PI*k/N);
//	    printf("K/N: %f\n", ((float)k)/N);
	    for (int i = k; i < n; i+=N) // With emulated "recursion"-step
	    {
		int odd_i = i + N/2;
		// Complex multiply without checking for NaN (as glibc does)
		x = _mm_loaddup_pd((double*)&ti);
		y = _mm_load_pd((double*)&out[odd_i]);
		a = _mm_mul_pd(x,y);
		x = _mm_loaddup_pd(((double*)&ti)+1);
		y = _mm_shuffle_pd(y,y,1);
		y = _mm_mul_pd(x,y);
		a = _mm_addsub_pd(a,y);
		y = _mm_loadu_pd((double*)&out[i]);
		
		x = y - a;
		
		_mm_storeu_pd((double*)&out[odd_i],x);

		x = y + a;
		_mm_storeu_pd((double*)&out[i],x);
	    }
	}
    }
}

// Naive discreete Fourier transform
// Time complexity: O(n^2)
void dft_naive(complex double * in, complex double * out, int n){
    for(int k = 0; k < n; k++){
	out[k] = 0 + 0*I;
	for(int j = 0; j < n; j++){
	    complex double t = cos(-2*PI*j*k/n) + sin(-2*PI*j*k/n) * I;
	    out[k] += in[j]*t;
	}
    }
}


// Returns a new array with the elements of in with even indices
complex double* get_even(complex double* in, int N){
    complex double* out = (complex double*)malloc(sizeof(complex double) * N/2);
    for(int i = 0; i < N/2; i++){
	out[i] = in[2*i];
    }
    return out;
}


// Returns a new array with the elements of in with odd indices
complex double* get_odd(complex double* in, int N){
    complex double* out = (complex double*)malloc(sizeof(complex double) * N/2);
    for(int i = 0; i < N/2; i++){
	out[i] = in[2*i + 1];
    }
    return out;
}


// Naive fast Fourier transform
// Time complexity: O(n log n)
void fft_naive(complex double * in, complex double * out, int N){

    if(N < 1)
	return;

    if(N == 1){
	out[0] = in[0];
    }

    //divide
    complex double* even = get_even(in, N);
    complex double* odd = get_odd(in, N);

    complex double* even_out = (complex double*)malloc(sizeof(complex double)*N/2);
    complex double* odd_out = (complex double*)malloc(sizeof(complex double)*N/2);

    //conquer
    fft_naive(even, even_out, N/2);
    fft_naive(odd, odd_out, N/2);

    //combine
    for(int k = 0; k < N/2; k++){
	//	printf("K: %d N: %d K + N/2 %d\n", k, N, k + N/2);
	//	printf("Odd[k] = %f, k = %d\n", odd[k], k);

	complex double t = cos(-2*PI*k/N) + I * sin(-2*PI*k/N);
	//	printf("T: %f + %f i\n", creal(t), cimag(t));
	t = t * odd_out[k];
	//	printf("T*ODD: %f + %f i\n", creal(t), cimag(t));
	out[k] = even_out[k] + t;
	out[k + N/2] = even_out[k] - t;
    }
    /*  for (int a = 0; a < N; a++)
	printf("%f %f i\t", creal(out[a]), cimag(out[a]));
	printf("\n");
	*/
    free(even);free(odd);free(even_out);free(odd_out);
}

int main(int argc, char** argv){

    // Error message for wrong arguments
    if(argc<3) {
	puts("Usage: fft size algo\n");
	puts("size is the size of the array to transform, it must be a power of two.");
	puts("algo: select which algorithm to run.");
	puts("      1 - naive dft");
	puts("      2 - naive fft");
	puts("      3 - your code");
	puts("      4 - fftw");
	puts("Example: fft 1024 3");
	return 0;
    }

    // Parsing command line arguments
    int size=strtol(argv[1],0,10);
    int algo=strtol(argv[2],0,10);
    int log2=-1;
    for(int i=0;i<31;i++) if(size==(1<<i)) log2=i;
    if(log2==-1) {
	printf("size must be a power of two!\n");
	return 0;
    }
    if(algo<1 || algo>4) {
	puts("algo must be between 1 and 4.");
	return 0;
    }

    // Approximate number of floating point opperations for the given size
    // (Assuming fft like algorithm)
    double flop = 5*size*log2;

    // Timing variables
    unsigned long long start,stop,cycles;

    // Input/output buffers
    complex double* in = (complex double*)malloc(sizeof(complex double)*size);
    complex double* out = (complex double*)malloc(sizeof(complex double)*size);
    complex double* out_fftw = (complex double*)malloc(sizeof(complex double)*size);

    // Creating fftw plan
    fftw_plan p;
    p = fftw_plan_dft_1d(size, in, out_fftw, FFTW_FORWARD, FFTW_MEASURE);

    // Filling input array
    for(int i = 0; i < size; i++){
	in[i] = pow(2.718281828,(double)i/size)+sin(i*i) +
	    I*(pow((1+sqrt(5))/2,-(double)i/size)+cos(i*i));
    }

    // Running and timing selected algorithm
    switch(algo) {
	case 1:
	    start = rdtsctime();
	    dft_naive(in, out, size);
	    stop = rdtsctime();
	    cycles = stop - start;
	    printf ( "dft_naive took %.4f flop per 1000 cycles\n", 1000*flop / cycles );
	    break;
	case 2:
	    start = rdtsctime();
	    fft_naive(in, out, size);
	    stop = rdtsctime();
	    cycles = stop - start;
	    printf ( "fft_naive took %.4f flop per 1000 cycles\n", 1000*flop / cycles );
	    break;
	case 3:
	    start = rdtsctime();
	    my_fft(in, out, size);
	    stop = rdtsctime();
	    cycles = stop - start;
	    printf ( "my_fft took %.4f flop per 1000 cycles\n", 1000*flop / cycles );
	    break;
	case 4:
	    start = rdtsctime();
	    fftw_execute(p);
	    stop = rdtsctime();
	    cycles = stop - start;
	    printf ( "fftw took %.4f flop per 1000 cycles\n", 1000*flop / cycles );
    }

    // Comparing output with fftw to check for correctness
    if(algo!=4) {
	fftw_execute(p);

	int errors=0;
	for(int i = 0; i < size; i++){
	    complex double diff = out_fftw[i] - out[i];
	    if(fabs(creal(diff))>1e-8 || fabs(cimag(diff))>1e-8) {
		errors++;
		if(errors<10) {
		    printf("Error at %d, correct is (%f %f), my_fft returned (%f %f)\n",
			    i,creal(out_fftw[i]),cimag(out_fftw[i]),creal(out[i]),cimag(out[i]));
		} else if(errors==10) puts("...");
	    }
	}
	printf("number of errors: %d\n",errors);
    }

    free(in);
    free(out);
    free(out_fftw);

    return 0;
}
