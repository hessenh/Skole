/* Simple OpenCL example: The device receives an array of SIZE elements,
   and each thread writes its own id to one element.
   The code has excessive error checking. The kernel is defined in the
   file "hello.cl", which is loaded from disk by the program and sent a
   as a string to the OpenCL API. */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <CL/cl.h>

#define SIZE 512

int items[SIZE];

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

int main() {
	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue q;
	cl_program program;
	cl_kernel kernel;
	cl_mem buffer;
	cl_int err;
	char *source;
	int i;

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
	source = load_program_source("hello.cl");
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
	kernel = clCreateKernel(program, "hello", &err);
	if(CL_SUCCESS != err) clerror("Error creating kernel",err);
	free(source);

	buffer = clCreateBuffer(context, CL_MEM_READ_WRITE, SIZE*sizeof(float), NULL, &err);
	if(CL_SUCCESS != err) clerror("Error creating buffer",err);

	/* Create kernel arguments */
	err = clSetKernelArg(kernel, 0, sizeof(buffer), &buffer);
	if(CL_SUCCESS != err) clerror("Error setting kernel argument",err);	

	/* Run kernel */
	size_t globalws=SIZE;
	err = clEnqueueNDRangeKernel(q, kernel, 1, NULL, &globalws, NULL, 0, NULL, NULL);
	if(CL_SUCCESS != err) clerror("Error running kernel",err);

	/* Wait for kernels to finish */
	err = clFinish(q);
	if(CL_SUCCESS != err) clerror("Error waiting for kernel",err);	

	err = clEnqueueReadBuffer(q, buffer, CL_TRUE, 0, SIZE*sizeof(cl_int), items, 0, NULL, NULL);
	if(CL_SUCCESS != err) clerror("Error copying result to host",err);

	for(i=0;i<SIZE;i++) printf("%d ",items[i]);
	printf("\n");

	/* Clean up */
	clReleaseMemObject(buffer);
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseCommandQueue(q);
	clReleaseContext(context);

	return 0;
}
