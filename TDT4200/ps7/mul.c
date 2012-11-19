#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <CL/cl.h>

/* SIZE must be a multiple of BLOCK */
#define SIZE 16777216
#define BLOCK 256

void host_mul(float *C, float *A, float *B) {
	int i;
	for(i=0; i<SIZE; i++) {
		C[i] = A[i] * B[i];
	}
}

/* Given error code, return OpenCL error string */
const char *errorstr(cl_int err) {
	switch (err) {
	case CL_SUCCESS:                          return "Success!";
	case CL_DEVICE_NOT_FOUND:                 return "Device not found.";
	case CL_DEVICE_NOT_AVAILABLE:             return "Device not available";
	case CL_COMPILER_NOT_AVAILABLE:           return "Compiler not available";
	case CL_MEM_OBJECT_ALLOCATION_FAILURE:    return "Memory object allocation failure";
	case CL_OUT_OF_RESOURCES:                 return "Out of resources";
	case CL_OUT_OF_HOST_MEMORY:               return "Out of host memory";
	case CL_PROFILING_INFO_NOT_AVAILABLE:     return "Profiling information not available";
	case CL_MEM_COPY_OVERLAP:                 return "Memory copy overlap";
	case CL_IMAGE_FORMAT_MISMATCH:            return "Image format mismatch";
	case CL_IMAGE_FORMAT_NOT_SUPPORTED:       return "Image format not supported";
	case CL_BUILD_PROGRAM_FAILURE:            return "Program build failure";
	case CL_MAP_FAILURE:                      return "Map failure";
	case CL_INVALID_VALUE:                    return "Invalid value";
	case CL_INVALID_DEVICE_TYPE:              return "Invalid device type";
	case CL_INVALID_PLATFORM:                 return "Invalid platform";
	case CL_INVALID_DEVICE:                   return "Invalid device";
	case CL_INVALID_CONTEXT:                  return "Invalid context";
	case CL_INVALID_QUEUE_PROPERTIES:         return "Invalid queue properties";
	case CL_INVALID_COMMAND_QUEUE:            return "Invalid command queue";
	case CL_INVALID_HOST_PTR:                 return "Invalid host pointer";
	case CL_INVALID_MEM_OBJECT:               return "Invalid memory object";
	case CL_INVALID_IMAGE_SIZE:               return "Invalid image size";
	case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:  return "Invalid image format descriptor";
	case CL_INVALID_SAMPLER:                  return "Invalid sampler";
	case CL_INVALID_BINARY:                   return "Invalid binary";
	case CL_INVALID_BUILD_OPTIONS:            return "Invalid build options";
	case CL_INVALID_PROGRAM:                  return "Invalid program";
	case CL_INVALID_PROGRAM_EXECUTABLE:       return "Invalid program executable";
	case CL_INVALID_KERNEL_NAME:              return "Invalid kernel name";
	case CL_INVALID_KERNEL_DEFINITION:        return "Invalid kernel definition";
	case CL_INVALID_KERNEL:                   return "Invalid kernel";
	case CL_INVALID_ARG_INDEX:                return "Invalid argument index";
	case CL_INVALID_ARG_VALUE:                return "Invalid argument value";
	case CL_INVALID_ARG_SIZE:                 return "Invalid argument size";
	case CL_INVALID_KERNEL_ARGS:              return "Invalid kernel arguments";
	case CL_INVALID_WORK_DIMENSION:           return "Invalid work dimension";
	case CL_INVALID_WORK_GROUP_SIZE:          return "Invalid work group size";
	case CL_INVALID_WORK_ITEM_SIZE:           return "Invalid work item size";
	case CL_INVALID_GLOBAL_OFFSET:            return "Invalid global offset";
	case CL_INVALID_EVENT_WAIT_LIST:          return "Invalid event wait list";
	case CL_INVALID_EVENT:                    return "Invalid event";
	case CL_INVALID_OPERATION:                return "Invalid operation";
	case CL_INVALID_GL_OBJECT:                return "Invalid OpenGL object";
	case CL_INVALID_BUFFER_SIZE:              return "Invalid buffer size";
	case CL_INVALID_MIP_LEVEL:                return "Invalid mip-map level";
	default:                                  return "Unknown";
	}
}

void clerror(char *s,cl_int err) {
	printf("%s: %s\n",s,errorstr(err));
	exit(1);
}

void error(char *s) {
	puts(s);
	exit(1);
}

char *load_program_source(const char *s) {
	FILE *f;
	char *t;
	size_t len;
	if(NULL==(f=fopen(s,"r"))) error("couldn't open file");
	fseek(f,0,SEEK_END);
	len=ftell(f);
	fseek(f,0,SEEK_SET);
	t=malloc(len+1);
	fread(t,len,1,f);
	t[len]=0;
	fclose(f);
	return t;
}

/* Get system time to microsecond precision (ostensibly, the same as MPI_Wtime) */
double walltime ( void ) {
	static struct timeval t;
	gettimeofday ( &t, NULL );
	return ( t.tv_sec + 1e-6 * t.tv_usec );
}

int main() {
	cl_int err;
	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue q;
	cl_program program;
	cl_kernel kernel;
	char *source;
	double devtime=0, hosttime=0, memtime=0, overheadtime=0;
	int i;

	float *A,*B,*C;  /* host arrays */
	float *resC;     /* result from device */

	overheadtime -= walltime();
	/* Get any GPU device on the first platform */
	err = clGetPlatformIDs(1, &platform, NULL);
	if(CL_SUCCESS != err) clerror("Couldn't get platform ID", err);
	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if(CL_SUCCESS != err) clerror("Couldn't get device ID", err);

	/* Create context on device */
	context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
	if(CL_SUCCESS != err) clerror("Couldn't get context", err);

	/* Create command queue on device */
	q = clCreateCommandQueue(context, device, 0, &err);
	if(CL_SUCCESS != err) clerror("Couldn't create command queue", err);

	/* Create a program object */
	source = load_program_source("mul.cl");
	program = clCreateProgramWithSource(context, 1, (const char **)&source, NULL, &err);
	if(CL_SUCCESS != err) clerror("Error creating program",err);

	/* Build a program associated with a program object */
	err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
	if(CL_SUCCESS != err) {
		/* Show build log (aka compile errors) */
		static char s[1048576];
		size_t len;
		printf("Error building program: %s\n", errorstr(err));
		clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, sizeof(s), s, &len);
		printf("Build log:\n%s\n", s);
		return 1;
	}

	/* Create kernel from built program */
	kernel = clCreateKernel(program, "mul", &err);
	if(CL_SUCCESS != err) clerror("Error creating kernel",err);
	free(source);
	overheadtime += walltime();

	/* Create A and B arrays */
	A = malloc(SIZE * sizeof(float));
	B = malloc(SIZE * sizeof(float));
	C = malloc(SIZE * sizeof(float));
	resC = malloc(SIZE * sizeof(float));
	for(i=0; i<SIZE; i++) {
		A[i] = 1e3*exp(10.0/(i+1));
		B[i] = 1e3*sin((i+1)/1000.0);
	}

	/* Perform host calculation */
	hosttime -= walltime();
	host_mul(C, A, B);
	hosttime += walltime();

	memtime -= walltime();
	/******* Subtask 2: Create device memory buffers and copy A,B to device */
	/* Enter your code here */
        cl_mem dev_A = clCreateBuffer(context, CL_MEM_READ_WRITE, SIZE * sizeof(float), NULL, &err);
        if (CL_SUCCESS != err) clerror("Error creating buffer for A",err);
        cl_mem dev_B = clCreateBuffer(context, CL_MEM_READ_WRITE, SIZE * sizeof(float), NULL, &err);
        if (CL_SUCCESS != err) clerror("Error creating buffer for B",err);
        cl_mem dev_C = clCreateBuffer(context, CL_MEM_READ_WRITE, SIZE * sizeof(float), NULL, &err);
        if (CL_SUCCESS != err) clerror("Error creating buffer for C",err);

        err = clEnqueueWriteBuffer(q, dev_A, CL_TRUE, 0, SIZE*sizeof(cl_float), A, 0, NULL, NULL);
        if (CL_SUCCESS != err) clerror("Error writing buffer for A",err);
        err = clEnqueueWriteBuffer(q, dev_B, CL_TRUE, 0, SIZE*sizeof(cl_float), B, 0, NULL, NULL);
        if (CL_SUCCESS != err) clerror("Error writing buffer for B",err);
        
	/******* End of subtask 2 ***********************************************/
	memtime += walltime();

	devtime -= walltime();
	/******* Subtask 3: Launch kernel ***************************************/
	/* Enter your code here */

        err = clSetKernelArg(kernel,0,sizeof(dev_C), &dev_C);
        if (CL_SUCCESS != err) clerror("Error setting kernel arg 0",err);

        err = clSetKernelArg(kernel,1,sizeof(dev_A), &dev_A);
        if (CL_SUCCESS != err) clerror("Error setting kernel arg 1",err);

        err = clSetKernelArg(kernel,2,sizeof(dev_B), &dev_B);
        if (CL_SUCCESS != err) clerror("Error setting kernel arg 2",err);

        size_t globalws = SIZE;
        err = clEnqueueNDRangeKernel(q, kernel, 1, NULL, &globalws, NULL, 0, NULL, NULL);
        if (CL_SUCCESS != err) clerror("Error launcing kernel",err);

	/******* End of subtask 3 ***********************************************/

	/* Wait for kernels to finish */
	err = clFinish(q);
	if(CL_SUCCESS != err) clerror("Error waiting for kernel",err);
	devtime += walltime();

	memtime -= walltime();
	/******* Subtask 4: Copy result to host *********************************/
	/* Enter your code here */
	
        err = clEnqueueReadBuffer(q, dev_C, CL_TRUE, 0, SIZE*sizeof(cl_float), resC, 0, NULL, NULL);
	if(CL_SUCCESS != err) clerror("Error reading buffer from device",err);

        /******* End of subtask 4 ***********************************************/
	memtime += walltime();
	
	overheadtime -= walltime();
	/******* Subtask 5: Free device memory **********************************/
	/* Enter your code here */
	
        clReleaseMemObject(dev_A);
        clReleaseMemObject(dev_B);
        clReleaseMemObject(dev_C);
        
        /******* End of subtask 5 ***********************************************/
	overheadtime += walltime();

	/* Free the remaining OpenCL resources */
	overheadtime -= walltime();
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseCommandQueue(q);
	clReleaseContext(context);
	overheadtime += walltime();

	/* Check result */
	{
		float worst=0, diff;
		int errors=0;
		for(i=0; i<SIZE; i++) {
			diff=fabs(C[i]-resC[i]);
			if(diff>1e-6) errors++;
			if(worst<diff) worst=diff;
		}
		printf("%d errors found, largest difference was %e.\n\n", errors, diff);
	}

	/* Clean up and go home */
	free(A); free(B); free(C); free(resC);

	printf("Host calculation time   : %7.3f\n", hosttime);
	printf("Device calculation time : %7.3f\n", devtime);
	printf("Memory transfer time    : %7.3f\n", memtime);
	printf("Other OpenCL overhead   : %7.3f\n", overheadtime);

	return 0;
}
