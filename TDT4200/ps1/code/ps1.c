#include <stdio.h>
#include <stdlib.h>

#include <time.h> // For random seed

// Create complex_t struct
typedef struct
{
    int real, imag;
} complex_t;

complex_t multiply_complex(complex_t a, complex_t b){
    // Implement complex multiplication
    complex_t c;
    c.real = (a.real * b.real) - (a.imag * b.imag);
    c.imag = (a.imag * b.real) + (a.real * b.imag);
    return c;
}

void divide_complex(complex_t a, complex_t b, complex_t* r){
    // Implement complex division
    r->real = ((a.real * b.real) + (a.imag * b.imag))/((b.real * b.real) + (b.imag * b.imag));
    r->imag = ((a.imag * b.real) - (a.real * b.imag))/((b.real * b.real) + (b.imag * b.imag));
}

complex_t* create_random_complex_array(int size){
    // Implement generation of array of random complex numbers
    complex_t* array = (complex_t*) malloc( sizeof(complex_t) * size );
    for (int i = 0; i < size; i++)
    {
	array[i].real = rand() % 20 - 10;
	array[i].imag = rand() % 20 - 10;
    }
    return array;
}

complex_t* multiply_complex_arrays(complex_t* a1, complex_t* a2, int size){
    // Implement pairwise array multiplication
    complex_t* array = (complex_t*) malloc( sizeof(complex_t) * size);
    for (int i = 0; i < size; i++)
    {
	array[i] = multiply_complex(a1[i], a2[i]);
    }
    return array;
}

complex_t* divide_complex_arrays(complex_t* a1, complex_t* a2, int size){
    // Implement pairwise array division
    complex_t* array = (complex_t*) malloc( sizeof(complex_t) * size);
    for (int i = 0; i < size; i++)
    {
	divide_complex(a1[i], a2[i], &array[i]);
    } 
    return array;
}


int main(int argc, char** argv){

    srand( time(NULL) );

    //Creating two arrays
    complex_t* a = create_random_complex_array(100);
    complex_t* b = create_random_complex_array(100);

    //Multiplying a and b
    complex_t* c = multiply_complex_arrays(a,b,100);
    //Dividing c by b, d and a should now be equal
    complex_t* d = divide_complex_arrays(c,b,100);

    //Checking that a and d are equal
    for(int i = 0; i < 100; i++){
	if(d[i].real != a[i].real || d[i].imag != a[i].imag){
	    printf("Error at: %d\n", i);
	}
    }
    free (a);
    free (b);
    free (c);
    free (d);

}
