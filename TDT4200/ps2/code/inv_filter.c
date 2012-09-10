#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#include "bmp.h"

#define ITERATIONS 1  //Number of iterations
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
             border_col_t;


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
    MPI_Type_contiguous(local_image_size[1], MPI_UNSIGNED_CHAR, &border_row_t);
    MPI_Type_commit(&border_row_t);
    int error = MPI_Type_vector(local_image_size[0], 1, local_image_size[1] + (BORDER * 2), MPI_UNSIGNED_CHAR, &border_col_t);
    printf("Error vector defined: %d\n", error);
    error = MPI_Type_commit(&border_col_t);
    printf("Error commit: %d\n", error);
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
    for (int x = 0; x <  local_image_size[1]; x++)
    for (int y = 0; y <  local_image_size[0]; y++)
    {
//	if (rank == 1)
//	    printf("Reading %x which is %d,%d into %x\n", &G(x,y), x,y, &F(0,x,y));
	F(0,y,x) = G(y,x);
    }
}

void exchange_borders(int step){
    //TODO: Exchange borders
    MPI_Request req;

    // Neighbours are in 1:north, 2:south, 3:east and 4:west
    
    unsigned char *border[4];
    border[0] = (unsigned char*)malloc(sizeof(unsigned char)*local_image_size[1] *BORDER);
    border[1] = (unsigned char*)malloc(sizeof(unsigned char)*local_image_size[1] *BORDER);
    border[2] = (unsigned char*)malloc(sizeof(unsigned char)*local_image_size[0] *BORDER);
    border[3] = (unsigned char*)malloc(sizeof(unsigned char)*local_image_size[0] *BORDER);
    
    MPI_Irecv(border[0], 1, border_row_t, north, step, cart_comm, &req);
    MPI_Irecv(border[1], 1, border_row_t, south, step, cart_comm, &req);
    MPI_Irecv(border[2], 1, border_col_t, east, step, cart_comm, &req);
    MPI_Irecv(border[3], 1, border_col_t, west, step, cart_comm, &req);
    
    MPI_Send(&(F(step,0,0)), 1, border_row_t, north, step, cart_comm);
    MPI_Send(&(F(step,local_image_size[0],0)), 1, border_row_t, south, step, cart_comm);
    MPI_Send(&(F(step,0,local_image_size[1])), 1, border_col_t, east, step, cart_comm);
    MPI_Send(&(F(step,0,0)), 1, border_col_t, west, step, cart_comm);

    MPI_Wait(&req, MPI_STATUS_IGNORE);
//    printf("Rank %d across wait\n", rank);

    // Apply northern border
    int y;
    int x;
    if (north != -2)
    {
	for (y = -BORDER; y < 0; y++)
	    for (x = 0; x < local_image_size[1]; x++)
	    {
//		if (rank == 0) printf("North S:%d X:%d Y:%d LX: %d LY: %d\n", step, x, y, local_image_size[1], local_image_size[0]);
		F(step,y,x) = border[0][x];
	    }
//	free(border[0]);
    }
    
    // Apply southern border
    if (south != -2)
    {
	for (y = local_image_size[0]; y < local_image_size[0] + BORDER; y++)
	    for (x = 0; x < local_image_size[1]; x++)
	    {
//		if (rank == 0) printf("South S:%d X:%d Y:%d LX: %d LY: %d\n", step, x, y, local_image_size[1], local_image_size[0]);
		F(step,y,x) = border[1][x];
	    }
//        free(border[1]);
    }

    // Apply eastern border
    if (east != -2)
    {
	for (y = 0; y < local_image_size[0]; y++)
	    for (x = local_image_size[1]; x < local_image_size[1] + BORDER; x++)
	    {
		F(step,y,x) = border[2][y];
	    }
//	free(border[2]);
    }

    // Apply western border
    if (west != -2)
    {
	for (y = 0; y < local_image_size[0]; y++)
	    for (x = -BORDER; x < 0; x++)
	    {
		F(step,y,x) = border[3][y];
	    }
//	free(border[3]);
    }

}

void perform_convolution(int step){
    //TODO: Perform convolution
}

void gather_image(){
    //TODO: Gather all the pieces of the image at rank 0
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
    if (Debug == rank)
    {
	int i = 0;
	printf("PID %d ready for attach\n", getpid());
	fflush(stdout);
	while (i == 0)
	    sleep(5);
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

    printf("I am %d, N:%d, S:%d, E:%d, W:%d\n", rank, north, south, east, west);

    create_types();

    distribute_image();

    initialilze_guess();

    //Main loop
    for(int i = 0; i < ITERATIONS; i++){
	exchange_borders(i);
	//perform_convolution(i);
    }

    printf("Rank %d sleeping!\n", rank); 
    sleep(5);
    //gather_image();
    printf("Rank %d done! Status %d\n", rank, MPI_Finalize());
    
    //Write image
    if(rank==0){
	write_bmp(image, image_size[0], image_size[1]);
    }

    exit(0);
}
