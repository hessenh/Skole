/******* Subtask 1: Kernel **********************************************/
__kernel void mul(__global float *C, __global float *A, __global float *B) {
    /* Enter your code here */
    int id = get_global_id(0);
    C[id] = A[id] * B[id];
}
/******* End of subtask 1 ***********************************************/
