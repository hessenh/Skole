#include <stdio.h>
#include <stdlib.h>
#include <complex.h>
#include <fftw3.h>
#include <math.h>

//#include <sys/time.h>

#include <tmmintrin.h>

#define PI  3.14159265358979323846
//#define DPI 6.28318530717958647692


/*
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
*/
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

/*
 * This is an example algo. given by Intel for multiplying complex numbers
 * with each part stored in separate arrays,
 * modified to work with C99 Complex Numbers
 */
complex double cmul_instrics(complex double a, complex double b)
{
    __m128d num1, num2, num3;
    // Duplicates lower vector element into upper vector element.
    // //
    // num1: [x.real, x.real]
     num1 = _mm_loaddup_pd((double*)&a);
    // // Move y elements into a vector
    // //
    // num2: [y.img, y.real]
     num2 = _mm_set_pd(cimag(b),creal(b));
    // // Multiplies vector elements
    // //
    // num3: [(x.real*y.img), (x.real*y.real)]
     num3 = _mm_mul_pd(num2, num1);
    // //
    // num1: [x.img, x.img]
     num1 = _mm_loaddup_pd((double*)&a+1);
    // // Swaps the vector elements
    // //
    // num2: [y.real, y.img]
     num2 = _mm_shuffle_pd(num2, num2, 1);
    // //
    // 12
    // num2: [(x.img*y.real), (x.img*y.img)]
    //
    num2 = _mm_mul_pd(num2, num1);
    // Adds upper vector element while subtracting lower vector element
    // //
    // num3: [((x.real *y.img)+(x.img*y.real)),
    // //
    // ((x.real*y.real)-(x.img*y.img))]
     num3 = _mm_addsub_pd(num3, num2);
    // // Stores the elements of num3 into z
    complex double z;
     _mm_storeu_pd((double *)&z, num3);
    //
    return z;
}

complex double cmul_c(complex double a, complex double b)
{
    return (creal(a) * creal(b) - cimag(a) * cimag(b))  + (cimag(a) * creal(b)  + creal(a) * cimag(b)) * I;
}

void my_fft(complex double * in, complex double * out, int n)
{
    // How often we must align cos and sine depends on input size
    int filter;
    if (n < 32768)
        filter = 0x7fff;
    else if (n < 65536)
        filter = 0x7fff;
    else if (n < 131072)
        filter = 0x1fff;
    else if (n < 262144)
        filter = 0xfff;
    else
        filter = 0x3ff;

    // Keywords: inplace, SIMD, D&C
    // Few as possible: malloc, free, function call (and recursion)

    // The implemented algorithm is Cooley-Tukey, which can be implemented in-place
    // Wikipedia said "do bit reversal for Cooley-Tukey inplace FFT", and we got
    // a paper on Elster's algorithm, so I implemented it in C, modified to this task:
//    printf("Starting bit reversal\n");
//    struct timeval  tv, tv2, tv3;
//    gettimeofday(&tv, NULL);
    int N = n;
    int* indexes = (int*) malloc(sizeof(int)*n);
    for (int i = 0; i < n; i++)
        indexes[i] = i;
    int L = n/2;
    out[0] = in[0];
    for (int q = 0; q < n; q++)
    {
        for (int j = L/2; j <= L; j += 2)
        {
            indexes[j] = indexes[j/2] << 1;
            L /= 2;
//            out[L+j] = in[j + N];

        }
    }
    for (int i = 0; i < n; i++)
        printf("%d became %d\n", i, indexes[i]);

/*
    int j = 0;
    for (int i = 0; i < n-1; i++)
    {
	if (i <= j)
	{
	    out[i] = in[j];
	    out[j] = in[i];

	}
	int k = n >> 1;
	while (k <= j)
	{
	    j -= k;
	    k >>= 1;
	}
	j += k;
    }
    */
  //  gettimeofday(&tv2, NULL);
 //   printf("%d.%d Time on bit reversal\n", tv2.tv_sec - tv.tv_sec, tv2.tv_usec - tv.tv_usec);
    // Last number ain't affected by loop, so we set it here
    out[n-1] = in[n-1];
    
    __m128d tr,ti,x,y,a;
   
    /*  /
    / * / Do THE FFT calculations
    /  */
    N = 1; // There are just 1 number at base case
    int Nh;
    int steps = log2(n) + 1;
    while (--steps) // Do steps
    {
	Nh = N;
	N <<= 1; // Each step doubles number of numbers
        complex double t_base = cos(-2*PI/N) + I * sin(-2*PI/N);
	complex double t = 1;
	

	double num = 0;
	for (int k = 0; k < Nh; ++k) // This is "combine"-step
	{

	    tr = _mm_loaddup_pd((double*)&t);     // Load real(t) in both sides of register TR
	    ti = _mm_loaddup_pd(((double*)&t)+1); // Load imag(t) in both sides of register TI

	    // Calculate next input for sine and cosine
	    num -= 2*PI/N;
	    for (int i = k; i < n; i+=N) // With emulated "recursion"-step
	    {
		int odd_i = i + Nh;  // Index of odd array start
		// Complex multiply without any checking for NaN or other __slow__ stuff (as glibc does)
		// This algorithm is a slightly modified version of the SSSE3 complex multiply algo. from
                // the Intel SSSE3 example document
		y = _mm_load_pd((double*)&out[odd_i]);
		a = _mm_mul_pd(tr,y);
		y = _mm_shuffle_pd(y,y,1);  // Switch pos of imag and real for Y
		y = _mm_mul_pd(ti,y);
		a = _mm_addsub_pd(a,y);
		y = _mm_loadu_pd((double*)&out[i]);

		x = y - a;
		_mm_storeu_pd((double*)&out[odd_i],x);

		x = y + a;
		_mm_storeu_pd((double*)&out[i],x);
	    }
            // Sometimes the many multiplies of floats makes the algo. inaccurate,
            // so we need to align it.
            if ((k & filter))
            {
                // Seems like the C-based version is faster then the instrics-version in this case
                t = cmul_c(t, t_base);
            }
            else
            {
                t = cos(-2*PI*(k+1)/N) + I * sin(-2*PI*(k+1)/N);
//                t = cmul_c(t, t_base);
//                t = polar(1,-2*PI*(k+1)/N);
            }
	}
    }
   // gettimeofday(&tv3, NULL);
   // printf("%d.%d Time on algo\n", tv3.tv_sec - tv2.tv_sec, tv3.tv_usec - tv2.tv_usec); 
   // printf("%d.%d Time on total\n", tv.tv_sec - tv2.tv_sec,tv.tv_usec - tv2.tv_usec); 

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
    fft_naive(even, even_out, N/2 );
    fft_naive(odd, odd_out, N/2 );

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
