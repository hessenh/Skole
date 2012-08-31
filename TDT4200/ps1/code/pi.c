#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define ITER 1000

int main(int argc, char **argv) {
	int rank, size;
	int i;

	double local_result;
	double result = 0;

	/* Insert appropriate code for MPI initialization here, as well as:
	   - obtaining the rank (process ID) which should be put in the variable
	     rank
	   - obtaining the number of processes, which should be put in the
	     variable size.
	*/
	MPI_Status status;

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	/* Each program instance calculates part of the approximation of pi
	   using the formula pi/4 = 1 - 1/3 + 1/5 - 1/7 + 1/9 - ... */
	/* Rank 0 calculates the elements 0 - (ITER-1) of the sum,
	   rank 1 calculates the elements ITER - (2*ITER-1) of the sum etc. */
	local_result = 0;
	for(i=rank*ITER; i<rank*ITER+ITER; i++) {
		if(i & 1)
			local_result -= 1.0 / (i*2+1);
		else
			local_result += 1.0 / (i*2+1);
	}

	/* Insert your own code here. Here you should use MPI functions
	   (send and receive) to collect the result in the process with
	   rank 0. */


	if(rank==0){
	    result += local_result;
	    double recv = .0;
	    for(int i = 1; i < size; i++){
		MPI_Recv(&recv, 1, MPI_DOUBLE, i, 1, MPI_COMM_WORLD, &status);
		result += recv;
	    }

	    printf("pi is approximately equal to %f\n", 4 * result);
	} else {
	    for(int i = 1; i < size; i++){
		MPI_Send(&local_result, 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);
	    }

	}

	/*	Insert appropriate code here for de-initializing MPI */
	MPI_Finalize();

	return 0;
}
