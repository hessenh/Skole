#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda.h>
#include <cuda_runtime.h>

#include <sys/time.h>

#define dT 0.2f
#define G 0.6f
#define BLOCK_SIZE 32

// Global variables
int num_planets;
int num_timesteps;

// Host arrays
float2* velocities;
float4* planets;

// Device arrays 
float2* velocities_d;
float4* planets_d;

// Parse command line arguments
void parse_args(int argc, char** argv){
    if(argc != 2){
        printf("Useage: nbody num_timesteps\n");
        exit(-1);
    }
    
    num_timesteps = strtol(argv[1], 0, 10);
}

double walltime ( void ) {
    static struct timeval t;
    gettimeofday ( &t, NULL );
    return ( t.tv_sec + 1e-6 * t.tv_usec );
}

// Reads planets from planets.txt
void read_planets(){

    FILE* file = fopen("planets.txt", "r");
    if(file == NULL){
        printf("'planets.txt' not found. Exiting\n");
        exit(-1);
    }

    char line[200];
    fgets(line, 200, file);
    sscanf(line, "%d", &num_planets);

    planets = (float4*)malloc(sizeof(float4)*num_planets);
    velocities = (float2*)malloc(sizeof(float2)*num_planets);

    for(int p = 0; p < num_planets; p++){
        fgets(line, 200, file);
        sscanf(line, "%f %f %f %f %f",
                &planets[p].x,
                &planets[p].y,
                &velocities[p].x,
                &velocities[p].y,
                &planets[p].z);
    }

    fclose(file);
}

// Writes planets to file
void write_planets(int timestep){
    char name[20];
    int n = sprintf(name, "planets_out.txt");

    FILE* file = fopen(name, "wr+");

    for(int p = 0; p < num_planets; p++){
        fprintf(file, "%f %f %f %f %f\n",
                planets[p].x,
                planets[p].y,
                velocities[p].x,
                velocities[p].y,
                planets[p].z);
    }

    fclose(file);
}

// TODO 7. Calculate the change in velocity for p, caused by the interaction with q
__device__ float2 calculate_velocity_change_planet(float4 p, float4 q){
    float2 dv;
    float2 dist;
    dist.x = q.x - p.x;
    dist.y = q.y - p.y;


    float abs_dist = sqrt(dist.x*dist.x + dist.y*dist.y);
    float dist_cubed = abs_dist*abs_dist*abs_dist;
    //printf("%f %f\n", abs_dist, dist_cubed);



    dv.x = dT*G*q.z/dist_cubed * dist.x;
    dv.y = dT*G*q.z/dist_cubed * dist.y;
    return dv;
}

// TODO 5. Calculate the change in velocity for my_planet, caused by the interactions with a block of planets
__device__ float2 calculate_velocity_change_block(float4 my_planet, float4* shared_planets){
    float2 velocityChange;
    velocityChange.x = 0;
    velocityChange.y = 0;

    for (int i = 0; i < BLOCK_SIZE; i++)
    {
        if (my_planet.x == shared_planets[i].x && my_planet.y == shared_planets[i].y) continue;
        float2 newChange = calculate_velocity_change_planet(my_planet, shared_planets[i]);
        velocityChange.x += newChange.x;
        velocityChange.y += newChange.y;
    }

    return velocityChange;
}

// TODO 4. Update the velocities by calculating the planet interactions
__global__ void update_velocities(float4* planets, float2* velocities, int num_planets){
    int tid = threadIdx.x + blockIdx.x*blockDim.x;

    __shared__ float4 shared[BLOCK_SIZE];
    float4 planet = planets[tid];
    float2 velocityChange;
    velocityChange.x = velocities[tid].x;
    velocityChange.y = velocities[tid].y;

    for (int i = 0; i < num_planets; i+=BLOCK_SIZE)
    {
        shared[threadIdx.x] = planets[threadIdx.x + i];
        __syncthreads();
        float2 vc = calculate_velocity_change_block(planet, shared);
        velocityChange.x += vc.x;
        velocityChange.y += vc.y;
        __syncthreads();
    }
    velocities[tid].x = velocityChange.x;
    velocities[tid].y = velocityChange.y;
}

// TODO 7. Update the positions of the planets using the new velocities
__global__ void update_positions(float4* planets, float2* velocities, int num_planets){
    int tid = threadIdx.x + blockIdx.x*blockDim.x;
    planets[tid].x += velocities[tid].x * dT;
    planets[tid].y += velocities[tid].y * dT;
}


int main(int argc, char** argv){

    parse_args(argc, argv);
    read_planets();

    // TODO 1. Allocate device memory, and transfer data to device 
    int error;

    double start=walltime();
    
    /* Allocate device memory, and point to it from local variable */
    error = cudaMalloc((void**)&planets_d, sizeof(float4)*num_planets);
    /* Everything OK? */
    if (error != cudaSuccess)
        printf("Malloc: %d\n", error);

    error = cudaMalloc((void**)&velocities_d, sizeof(float2)*num_planets);
    /* Everything OK? */
    if (error != cudaSuccess)
        printf("Malloc: %d\n", error);
    
    double mallocTime=walltime();

    /* We transfer memory like this */
    error = cudaMemcpy(planets_d, planets, sizeof(float4)*num_planets, cudaMemcpyHostToDevice);
    /* and check for errors */
    if (error != cudaSuccess)
        printf("Copy planets to device: %d\n", error);

    error = cudaMemcpy(velocities_d, velocities, sizeof(float2)*num_planets, cudaMemcpyHostToDevice);
    /* and check for errors */
    if (error != cudaSuccess)
        printf("Copy to velocities to device: %d\n", error);

    double memTime = walltime();

    // Calculating the number of blocks
    int num_blocks = num_planets/BLOCK_SIZE + ((num_planets%BLOCK_SIZE == 0) ? 0 : 1);

    // Main loop
    for(int t = 0; t < num_timesteps; t++){
        // TODO 2. Call kernels
        update_velocities<<<num_blocks,BLOCK_SIZE>>>(planets_d, velocities_d, num_planets);
        // We print the error code from last call if things went bad
        error = cudaGetLastError();
        if (error != cudaSuccess)
            printf("update_velocities error - Step: %d CUDA Code: %d\n", t, error);
        cudaThreadSynchronize();
        update_positions<<<num_blocks,BLOCK_SIZE>>>(planets_d, velocities_d, num_planets);
        // We print the error code from last call if things went bad
        error = cudaGetLastError();
        if (error != cudaSuccess)
            printf("update_positions errror - Step: %d CUDA Code: %d\n", t, error);
        cudaThreadSynchronize();

    }
    double calcTime = walltime();

    // TODO 3. Transfer data back to host
    error = cudaMemcpy(planets, planets_d, sizeof(float4)*num_planets, cudaMemcpyDeviceToHost);
    /* and check for errors */
    if (error != cudaSuccess)
        printf("Copy to planets back to host: %d\n", error);

    error = cudaMemcpy(velocities, velocities_d, sizeof(float2)*num_planets, cudaMemcpyDeviceToHost);
    /* and check for errors */
    if (error != cudaSuccess)
        printf("Copy velocities back to host: %d\n", error);

    cudaFree(planets_d);
    cudaFree(velocities_d);

    double tranferBackTime = walltime();

    cudaDeviceSynchronize();
    printf("Malloc device time: %f\n", mallocTime - start);
    printf("Copy to device time: %f\n", memTime - mallocTime);
    printf("Calc time: %f\n", calcTime - memTime);
    printf("Copy to host time: %f\n", tranferBackTime - calcTime);
    printf("Total time: %f\n", walltime() - start);
    // Output
    write_planets(num_timesteps);
}
