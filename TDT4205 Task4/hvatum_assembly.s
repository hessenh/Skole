/* Data segment                                             */
/*----------------------------------------------------------*/
.data
.STRING0: .string "Sum is %d\n"

/* Declare main to the linker */
.globl main

/*----------------------------------------------------------*/
/* Text segment                                             */
.text

/* Foo-function                                             */
/*----------------------------------------------------------*/
foo:
    /* Store old base pointer on top of stack */
    pushl   %ebp

    /* Set new stack base (ebp) to old top-of-stack (esp) */
    movl    %esp, %ebp

    /* Store 0 in ecx  (loop starts at 1, but is incremented in first test) */
    movl    $0,   %ecx

    /* Store 0 on the stack, our sum value */
    pushl   $0

    /* And start loop-test */
    jmp tst_lp

lbody:
    /* Loop body */
    /* Modulo = divide and check rest-register */


    /* Check for input divisible by 3 */
    movl    %ecx, %eax
    movl    $3,   %ebx
    cdq
    idiv    %ebx
    /* edx now contains ecx mod 3 */
    cmp     $0,   %edx
    jz tst_ok /* Test true */

     /* Check for input divisible by 5 */
    movl    %ecx, %eax
    movl    $5,   %ebx
    cdq
    idiv    %ebx
    /* edx now contains ebx mod 5 */
    cmp     $0,   %edx
    jnz tst_lp /* Test false */
tst_ok:
    addl    %ecx, -4(%ebp)
    
tst_lp:
    /* Get the function argument and store in ebx */
    movl    8(%ebp), %ebx

   /* Increment and test */ 
    inc %ecx
    /* if ebx < ecx => jump to start of loop */
    cmp %ebx, %ecx
    jl lbody

    pushl -4(%ebp)
    /* Print results */
    /* sum is on top of stack */
    pushl   $.STRING0
    call    printf

    /* Clean up on stack */
    addl    $8, %esp
    /* Clean up stack frame */
    leave

    /* Return home */
    ret
/*----------------------------------------------------------*/

/* Main function                                            */
/*----------------------------------------------------------*/
main:
    /* Create a stack frame for main */
    pushl   %ebp
    movl    %esp,%ebp
    
    /* Put the argv pointer into ebx */
    movl    12(%ebp),%ebx
    
    /* The second element of argv is our command line argument; increment ebx to point to that element */
    addl    $4,%ebx

    /* atoi(argv[1]) */
    pushl   (%ebx)
    call    atoi

    /* Rewind the stack to the state it was before pushing arguments onto it */
    addl    $4,%esp

    /* Push the return value from strtol onto the stack */
    pushl   %eax

    /* Call foo(), with one argument (top of stack) */
    call    foo

    /* Tear down the stack frame */
    leave

    /* exit(0) to indicate success */
    pushl   $0
    call    exit
/*----------------------------------------------------------*/
