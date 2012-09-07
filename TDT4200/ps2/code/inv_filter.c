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
    MPI_Type_vector(1, local_image_size[1], 0, MPI_UNSIGNED_CHAR, &border_row_t);
    MPI_Type_commit(&border_row_t);
    MPI_Type_vector(local_image_size[1], local_image_size[1], local_image_size[0], MPI_UNSIGNED_CHAR, &border_col_t);
    MPI_Type_commit(&border_col_t);
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
    //TODO: Initialize f0
    // Find Cart-cords and init F(0,x,y) with values from G(x,y) according to cords.
}

void exchange_borders(int step){
    //TODO: Exchange borders

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

    MPI_Finalize();

    //Write image
    if(rank==0){
        write_bmp(image, image_size[0], image_size[1]);
    }

    exit(0);
}
