#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>

/* Problem size */
#define XSIZE 2560
#define YSIZE 2048

/* Divide the problem into blocks of BLOCKX x BLOCKY threads */
#define BLOCKY 128
#define BLOCKX 160

#define MAXITER 255

double xleft=-2.01;
double xright=1;
double yupper,ylower;
double ycenter=1e-6;
double step;

int host_pixel[XSIZE*YSIZE];
int device_pixel[XSIZE*YSIZE];

typedef struct {
	double real,imag;
} my_complex_t;

#define PIXEL(i,j) ((i)+(j)*XSIZE)

/********** SUBTASK1: Create kernel device_calculate *************************/

/*
 * CUDA kernel for calculation the same as host_calculate, the Mandelbrot-set
 */
__global__ void device_calculate(int *pixel, float xleft, float yupper, float step) {
    // In the CUDA-edition, we find i and j from the thread ID
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;
    /* Calculate the number of iterations until divergence for each pixel.
       If divergence never happens, return MAXITER */
    
    // Didn't get the struct to work properly, so I split it
    float cr,ci,zr,zi,tempr,tempi;
    int iter=0;
    cr = (xleft + step*i);
    ci = (yupper - step*j);
    zr = cr;
    zi = ci;
    while(zr*zr + zi*zi < 4.0) {
        tempr = zr*zr - zi*zi + cr;
        tempi = 2.0*zr*zi + ci;
        zr = tempr;
        zi = tempi;
        if(++iter==MAXITER) break;
    }
    pixel[PIXEL(i,j)]=iter;

}

/********** SUBTASK1 END *****************************************************/

void host_calculate() {
    for(int j=0;j<YSIZE;j++) {
        for(int i=0;i<XSIZE;i++) {
            /* Calculate the number of iterations until divergence for each pixel.
               If divergence never happens, return MAXITER */
            float cr,ci,zr,zi,tempr,tempi;
            int iter=0;
            cr = (xleft + step*i);
            ci = (yupper - step*j);
            zr = cr;
            zi = ci;
            while(zr*zr + zi*zi < 4.0) {
                tempr = zr*zr - zi*zi + cr;
                tempi = 2.0*zr*zi + ci;
                zr = tempr;
                zi = tempi;
                if(++iter==MAXITER) break;
            }
            host_pixel[PIXEL(i,j)]=iter;
        }
    }
}

typedef unsigned char uchar;

/* save 24-bits bmp file, buffer must be in bmp format: upside-down */
void savebmp(char *name,uchar *buffer,int x,int y) {
    FILE *f=fopen(name,"wb");
    if(!f) {
        printf("Error writing image to disk.\n");
        return;
    }
    unsigned int size=x*y*3+54;
    uchar header[54]={'B','M',size&255,(size>>8)&255,(size>>16)&255,size>>24,0,
        0,0,0,54,0,0,0,40,0,0,0,x&255,x>>8,0,0,y&255,y>>8,0,0,1,0,24,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    fwrite(header,1,54,f);
    fwrite(buffer,1,x*y*3,f);
    fclose(f);
}

/* given iteration number, set a colour */
void fancycolour(uchar *p,int iter) {
    if(iter==MAXITER);
    else if(iter<8) { p[0]=128+iter*16; p[1]=p[2]=0; }
    else if(iter<24) { p[0]=255; p[1]=p[2]=(iter-8)*16; }
    else if(iter<160) { p[0]=p[1]=255-(iter-24)*2; p[2]=255; }
    else { p[0]=p[1]=(iter-160)*2; p[2]=255-(iter-160)*2; }
}

/*
 * Get system time to microsecond precision (ostensibly, the same as MPI_Wtime),
 * returns time in seconds
 */
double walltime ( void ) {
    static struct timeval t;
    gettimeofday ( &t, NULL );
    return ( t.tv_sec + 1e-6 * t.tv_usec );
}

int main(int argc,char **argv) {
    if(argc==1) {
        puts("Usage: MANDEL n");
        puts("n decides whether image should be written to disk (1=yes, 0=no)");
        return 0;
    }
    double start;
    double hosttime=0;
    double devicetime=0;
    double memtime=0;

    cudaDeviceProp p;
    cudaSetDevice(0);
    cudaGetDeviceProperties (&p, 0);
    printf("Device compute capability: %d.%d\n", p.major, p.minor);

    /* Calculate the range in the y-axis such that we preserve the
       aspect ratio */
    step=(xright-xleft)/XSIZE;
    yupper=ycenter+(step*YSIZE)/2;
    ylower=ycenter-(step*YSIZE)/2;

    /* Host calculates image */
    start=walltime();
    host_calculate();
    hosttime+=walltime()-start;

    /********** SUBTASK2: Set up device memory *******************************/

    // Put device pixel memory pointer on local stack
    int *dev_pixel;
    // Place for error codes
    int error;

    // Allocate device memory, and point to it from local variable
    error = cudaMalloc((void**)&dev_pixel, sizeof(int)*XSIZE*YSIZE);

    // Everything OK?
    if (error != cudaSuccess)
        printf("Malloc: %d\n", error);

    /********** SUBTASK2 END *************************************************/

    start=walltime();
    /********** SUBTASK3: Execute the kernel on the device *******************/

    // Find out how many threads and blocks we need by
    // looking at block size and space size
    dim3 threads;
    dim3 blocks;
    blocks.x = BLOCKX;
    blocks.y = BLOCKY;
    threads.x = XSIZE / BLOCKX;
    threads.y = YSIZE / BLOCKY;

    device_calculate<<<blocks,threads>>>(dev_pixel, xleft, yupper, step);
    // We print the error code from last call if things went bad
    error = cudaGetLastError();
    if (error != cudaSuccess)
        printf("CUDA Code: %d\n", error);

    // Since kernel calling is asyncronus, and we time the calculation, it would be unfare not to syncronize here
    cudaThreadSynchronize();

    /********** SUBTASK3 END *************************************************/

    devicetime+=walltime()-start;

    start=walltime();

    /********** SUBTASK4: Transfer the result from device to device_pixel[][]*/

    // We transfer memory like this
    error = cudaMemcpy(device_pixel, dev_pixel, sizeof(int)*XSIZE*YSIZE, cudaMemcpyDeviceToHost);
    // and check for errors
    if (error != cudaSuccess)
        printf("Copy to host: %d\n", error);

    /********** SUBTASK4 END *************************************************/

    memtime+=walltime()-start;

    /********** SUBTASK5: Free the device memory also ************************/

    // Finally we free the device memory
    error = cudaFree(dev_pixel);
    // and check for errors
    if (error != cudaSuccess)
        printf("Free device memory: %d\n", error);

    /********** SUBTASK5 END *************************************************/

    int errors=0;
    /* check if result is correct */
    for(int i=0;i<XSIZE;i++) {
        for(int j=0;j<YSIZE;j++) {
            int diff=host_pixel[PIXEL(i,j)]-device_pixel[PIXEL(i,j)];
            if(diff<0) diff=-diff;
            /* allow +-1 difference */
            if(diff>1) {
                if(errors<10) printf("Error on pixel %d %d: expected %d, found %d\n",
                        i,j,host_pixel[PIXEL(i,j)],device_pixel[PIXEL(i,j)]);
                else if(errors==10) puts("...");
                errors++;
            }
        }
    }
    if(errors>0) printf("Found %d errors.\n",errors);
    else puts("Device calculations are correct.");

    printf("\n");
    printf("Host time:          %7.3f ms\n",hosttime*1e3);
    printf("Device calculation: %7.3f ms\n",devicetime*1e3);
    printf("Copy result:        %7.3f ms\n",memtime*1e3);

    if(strtol(argv[1],NULL,10)!=0) {
        /* create nice image from iteration counts. take care to create it upside
           down (bmp format) */
        unsigned char *buffer=(unsigned char *)calloc(XSIZE*YSIZE*3,1);
        for(int i=0;i<XSIZE;i++) {
            for(int j=0;j<YSIZE;j++) {
                int p=((YSIZE-j-1)*XSIZE+i)*3;
                fancycolour(buffer+p,device_pixel[PIXEL(i,j)]);
            }
        }
        /* write image to disk */
        savebmp("mandel1.bmp",buffer,XSIZE,YSIZE);
    }
    return 0;
}
