#include <stdio.h>
#include <stdlib.h>

//TODO Create complex_t struct

complex_t multiply_complex(complex_t a, complex_t b){
  //TODO Implement complex multiplication
}

void divide_complex(complex_t a, complex_t b, complex_t* r){
  //TODO Implement complex division
}

complex_t* create_random_complex_array(int size){
  //TODO Implement generation of array of random complex numbers
}

complex_t* multiply_complex_arrays(complex_t* a1, complex_t* a2, int size){
  //TODO Implement pairwise array multiplication
}

complex_t* divide_complex_arrays(complex_t* a1, complex_t* a2, int size){
  //TODO Implement pairwise array division
}


int main(int argc, char** argv){

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
}
