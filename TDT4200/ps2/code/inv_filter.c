#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#include "bmp.h"

#define ITERATIONS 1000  //Number of iterations
#define BORDER 1         //Border thickness

//Indexing macros
#define F(s,i,j) local_image[((s)%2)][((i)+BORDER)*(local_image_size[1]+2*BORDER) + ((j)+BORDER)]
#define G(i,j) local_image_orig[(i)*local_image_size[1] + (j)]

int rank,                       //My rank
    size,                       //Number of processes
    dims[2],                    //Dimensions of processor grid
    coords[2],                  //My coordinates in processor grid
    periods[2] = {0,0},         //No wrap around
    north,south,east,west,      //Neighbours in processor grid
    image_size[2] = {512,512},  //Image size. Change this if you use another image
    local_image_size[2];        //Size of local part of image

//Bluring filter
float filter[3][3] = {
    {0.111,0.111,0.111},
    {0.111,0.111,0.111},
    {0.111,0.111,0.111} };


float lambda = 0.02;

MPI_Comm cart_comm;

MPI_Datatype local_image_orig_t,
             image_t,
             border_row_t,
             border_col_t,
	     image_gather_t;


unsigned char *image,            //Glocal g
              *local_image_orig, //Local part of g
              *local_image[2];   //Local part of f, two buffers

void create_types(){
    MPI_Type_contiguous(local_image_size[0]*local_image_size[1],
            MPI_UNSIGNED_CHAR, &local_image_orig_t);
    MPI_Type_commit(&local_image_orig_t);

    MPI_Type_vector(local_image_size[0],
            local_image_size[1], image_size[1], MPI_UNSIGNED_CHAR, &image_t);
    MPI_Type_commit(&image_t);

    // Create MPI types for border exchange

    // Row borders are contiguous in memory
    MPI_Type_contiguous(local_image_size[1], MPI_UNSIGNED_CHAR, &border_row_t);
    MPI_Type_commit(&border_row_t);

    // Column borders are multiple 1-bytes with image width + border as stride
    MPI_Type_vector(local_image_size[0], 1, local_image_size[1] + (BORDER * 2), MPI_UNSIGNED_CHAR, &border_col_t);
    MPI_Type_commit(&border_col_t);

    // Create MPI types for image gather
    // This is the entire image located at F(s,y,x) without borders, so that we can send F in gather_image
    MPI_Type_vector(local_image_size[0], local_image_size[1], local_image_size[1] + (BORDER * 2), MPI_UNSIGNED_CHAR, &image_gather_t);
    MPI_Type_commit(&image_gather_t);
}

void distribute_image(){

    MPI_Request req;
    MPI_Irecv(local_image_orig, 1, local_image_orig_t, 0, 1, cart_comm, &req);

    if(rank == 0){
        int co[2];
        for(int i = 0; i < size; i++){
            MPI_Cart_coords(cart_comm, i, 2, co);
            int index = co[0]*local_image_size[0]*image_size[1] + co[1]*local_image_size[1];
            MPI_Send(&image[index], 1, image_t, i, 1, cart_comm);
        }
    }

    MPI_Wait(&req, MPI_STATUS_IGNORE);
}

void initialilze_guess(){
    // Initialize f0

    // Just copy G to F, forget about borders, since they are 0 (by calloc) anyway,
    // and those with neighbours will receive borders in time
    for (int x = 0; x <  local_image_size[1]; x++)
    for (int y = 0; y <  local_image_size[0]; y++)
    {
	F(0,y,x) = G(y,x);
    }
}

void exchange_borders(int step){
    // Exchange borders
    MPI_Request req[4];

    // Send all borders in background
    MPI_Isend(&(F(step,0,0)), 1, border_row_t, north, step, cart_comm, &req[0]);
    MPI_Isend(&(F(step,local_image_size[0]-1,0)), 1, border_row_t, south, step, cart_comm, &req[1]);
    MPI_Isend(&(F(step,0,local_image_size[1]-1)), 1, border_col_t, east, step, cart_comm, &req[2]);
    MPI_Isend(&(F(step,0,0)), 1, border_col_t, west, step, cart_comm, &req[3]);

    MPI_Status status[8];

    // Receive borders from neigbours
    MPI_Recv(&(F(step,-BORDER,0)), 1, border_row_t, north, step, cart_comm, &status[4]);
    MPI_Recv(&(F(step,local_image_size[0],0)), 1, border_row_t, south, step, cart_comm, &status[5]);
    MPI_Recv(&(F(step,0,local_image_size[1])), 1, border_col_t, east, step, cart_comm, &status[6]);
    MPI_Recv(&(F(step,0,-BORDER)), 1, border_col_t, west, step, cart_comm, &status[7]);

    // Wait for all borders to arrive
    MPI_Waitall(4, &(req[0]), &(status[0]));

    // If error, yell & exit
    for (int i = 0; i < 8; i ++) if (status[i].MPI_ERROR)
    {
	printf("Error receiving from %d @ rank %d, step %d\n", i, rank, step);
	exit(status[i].MPI_ERROR);
    }
}

void perform_convolution(int step){
    // Perform convolution
    
    // For every pixel in my local image at current step
    for (int x = 0; x <  local_image_size[1]; x++)
    for (int y = 0; y <  local_image_size[0]; y++)
    {
	double value = 0;

	// Apply filter
	for (int i = -1; i < 2; i++)
	for (int j = -1; j < 2; j++)
	    value += F(step,y+i,x+j) * filter[1+i][1+j];
	
	// Check for over/under-flow
	int val = F(step,y,x) + lambda*( G(y,x) - value );
	if (val > 255) val = 255;
	if (val < 0) val = 0;

	// Apply new value to next step
	F(step+1,y,x) = val;
    }
}

void gather_image(){
    // Gather all the pieces of the image at rank 0

    MPI_Request req;

    // Send my part, I have defined a new type for delivering last F' directly
    MPI_Isend(&(F(ITERATIONS,0,0)),1,image_gather_t,0,ITERATIONS,cart_comm, &req);

    // If I'm the boss, gather all image parts from others
    if (rank == 0)
    {
	int co[2];
	// For each compute node, receive image part
	for (int i = 0; i < size; i++)
	{
	    // Oposite from distribute_image
	    MPI_Cart_coords(cart_comm, i, 2, co);
	    int index = co[0]*local_image_size[0]*image_size[1] + co[1]*local_image_size[1];
	    MPI_Status status;
	    MPI_Recv(&image[index],1,image_t,i,ITERATIONS,cart_comm,&status);
	}
    }
}



int main(int argc, char** argv){

    //Initialization
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    //Reading image
    if(rank == 0){
	image = read_bmp("Lenna_blur.bmp");
    }

#ifdef Debug
    // Trick for attaching GDB to chosen rank
    if (Debug == rank)
    {
	int i = 0;
	printf("PID %d ready for attach\n", getpid());
	fflush(stdout);
	while (i == 0)
	    sleep(2);
    }
#endif

    //Creating cartesian communicator
    MPI_Dims_create(size, 2, dims);
    MPI_Cart_create( MPI_COMM_WORLD, 2, dims, periods, 0, &cart_comm );
    MPI_Cart_coords( cart_comm, rank, 2, coords );

    MPI_Cart_shift( cart_comm, 0, 1, &north, &south );
    MPI_Cart_shift( cart_comm, 1, 1, &west, &east );

    local_image_size[0] = image_size[0]/dims[0];
    local_image_size[1] = image_size[1]/dims[1];

    //Allocating buffers
    int lsize = local_image_size[0]*local_image_size[1];
    int lsize_border = (local_image_size[0] + 2*BORDER)*(local_image_size[1] + 2*BORDER);
    local_image_orig = (unsigned char*)malloc(sizeof(unsigned char)*lsize);
    local_image[0] = (unsigned char*)calloc(lsize_border, sizeof(unsigned char));
    local_image[1] = (unsigned char*)calloc(lsize_border, sizeof(unsigned char));

    create_types();

    distribute_image();

    initialilze_guess();

    //Main loop
    for(int i = 0; i < ITERATIONS; i++){
	exchange_borders(i);
	perform_convolution(i);
    }

    gather_image();
    MPI_Barrier(cart_comm);
    printf("Rank %d done! Status %d\n", rank, MPI_Finalize());

    //Write image
    if(rank == 0){
	write_bmp(image, image_size[0], image_size[1]);
        // Free image memory
	free(image);
    }

    // Free temp-vars
    free(local_image_orig);
    free(local_image[0]);
    free(local_image[1]);

    exit(0);
}
