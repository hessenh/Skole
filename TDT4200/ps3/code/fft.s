	.file	"fft.c"
	.text
	.p2align 4,,15
	.globl	my_fft
	.type	my_fft, @function
my_fft:
.LFB566:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	leal	-1(%rdx), %r10d
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edx, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	testl	%r10d, %r10d
	movq	%rsi, 16(%rsp)
	jle	.L9
	movl	%edx, %r9d
	xorl	%r8d, %r8d
	xorl	%esi, %esi
	shrl	$31, %r9d
	addl	%edx, %r9d
	xorl	%edx, %edx
	sarl	%r9d
.L8:
	cmpl	%esi, %edx
	jl	.L5
	movq	16(%rsp), %rcx
	movslq	%edx, %rax
	salq	$4, %rax
	movsd	(%rdi,%rax), %xmm1
	movsd	8(%rdi,%rax), %xmm0
	movsd	%xmm1, (%rcx,%r8)
	movsd	%xmm0, 8(%rcx,%r8)
	movsd	(%rdi,%r8), %xmm1
	movsd	8(%rdi,%r8), %xmm0
	movsd	%xmm1, (%rcx,%rax)
	movsd	%xmm0, 8(%rcx,%rax)
.L5:
	cmpl	%r9d, %edx
	movl	%r9d, %eax
	jl	.L6
	.p2align 4,,10
	.p2align 3
.L7:
	movl	%eax, %ecx
	subl	%eax, %edx
	shrl	$31, %ecx
	addl	%ecx, %eax
	sarl	%eax
	cmpl	%eax, %edx
	jge	.L7
.L6:
	addl	$1, %esi
	addl	%eax, %edx
	addq	$16, %r8
	cmpl	%r10d, %esi
	jne	.L8
.L9:
	movslq	%r14d, %rax
	movq	16(%rsp), %rdx
	subq	$1, %rax
	salq	$4, %rax
	movsd	8(%rdi,%rax), %xmm0
	movsd	(%rdi,%rax), %xmm1
	movsd	%xmm0, 8(%rdx,%rax)
	cvtsi2sd	%r14d, %xmm0
	movsd	%xmm1, (%rdx,%rax)
	call	log2
	cvttsd2si	%xmm0, %ecx
	testl	%ecx, %ecx
	movl	%ecx, 28(%rsp)
	jle	.L1
	movl	$1, 4(%rsp)
	movsd	.LC0(%rip), %xmm0
	movl	4(%rsp), %r15d
	movl	$0, 24(%rsp)
	movsd	.LC1(%rip), %xmm3
.L3:
	movslq	4(%rsp), %rdx
	addl	%r15d, %r15d
	xorl	%r13d, %r13d
	cvtsi2sd	%r15d, %xmm1
	movq	16(%rsp), %rbx
	movslq	%r15d, %rbp
	salq	$4, %rbp
	movq	%rdx, %r10
	movq	%rdx, %r12
	salq	$4, %r10
	negq	%r12
	movsd	%xmm1, 8(%rsp)
	addq	%r10, %rbx
	salq	$4, %r12
	.p2align 4,,10
	.p2align 3
.L14:
	xorpd	%xmm4, %xmm4
	mulsd	%xmm3, %xmm4
	cmpl	%r13d, %r14d
	unpcklpd	%xmm3, %xmm3
	movq	%rbx, %rax
	movl	%r13d, %ecx
	addsd	%xmm0, %xmm4
	unpcklpd	%xmm4, %xmm4
	jle	.L13
	.p2align 4,,10
	.p2align 3
.L18:
	movapd	(%rax), %xmm1
	movapd	%xmm4, %xmm0
	addl	%r15d, %ecx
	leaq	(%rax,%r12), %rsi
	mulpd	%xmm1, %xmm0
	shufpd	$1, %xmm1, %xmm1
	mulpd	%xmm3, %xmm1
	addsubpd	%xmm1, %xmm0
	movupd	(%rsi), %xmm1
	movapd	%xmm1, %xmm2
	subpd	%xmm0, %xmm2
	addpd	%xmm1, %xmm0
	movupd	%xmm2, (%rax)
	addq	%rbp, %rax
	cmpl	%ecx, %r14d
	movupd	%xmm0, (%rsi)
	jg	.L18
.L13:
	addl	$1, %r13d
	addq	$16, %rbx
	cmpl	4(%rsp), %r13d
	jge	.L25
	cvtsi2sd	%r13d, %xmm0
	leaq	32(%rsp), %rsi
	leaq	40(%rsp), %rdi
	mulsd	.LC3(%rip), %xmm0
	divsd	8(%rsp), %xmm0
	call	sincos
	movsd	32(%rsp), %xmm0
	movsd	40(%rsp), %xmm3
	jmp	.L14
.L25:
	addl	$1, 24(%rsp)
	movl	28(%rsp), %eax
	cmpl	%eax, 24(%rsp)
	je	.L1
	leal	(%r15,%r15), %eax
	movsd	.LC1(%rip), %xmm1
	cvtsi2sd	%eax, %xmm0
	leaq	32(%rsp), %rsi
	leaq	40(%rsp), %rdi
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	call	sincos
	movsd	32(%rsp), %xmm0
	movl	%r15d, 4(%rsp)
	movsd	40(%rsp), %xmm3
	jmp	.L3
.L1:
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE566:
	.size	my_fft, .-my_fft
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	0
	.long	0
	.long	0
	.text
	.p2align 4,,15
	.globl	dft_naive
	.type	dft_naive, @function
dft_naive:
.LFB567:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movl	%edx, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	testl	%edx, %edx
	movq	%rdi, 56(%rsp)
	jle	.L26
	cvtsi2sd	%edx, %xmm0
	movq	%rsi, %r14
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	movsd	%xmm0, 48(%rsp)
	.p2align 4,,10
	.p2align 3
.L29:
	movsd	.LC4(%rip), %xmm0
	movd	%r13, %xmm4
	movd	%r13, %xmm5
	movq	56(%rsp), %rbx
	xorl	%r15d, %r15d
	movsd	%xmm0, (%r14)
	movsd	.LC4+8(%rip), %xmm0
	movsd	%xmm0, 8(%r14)
	cvtsi2sd	%r12d, %xmm0
	movsd	%xmm0, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L28:
	cvtsi2sd	%r15d, %xmm0
	movsd	%xmm4, 16(%rsp)
	addl	$1, %r15d
	leaq	64(%rsp), %rsi
	movsd	%xmm5, (%rsp)
	leaq	72(%rsp), %rdi
	mulsd	.LC3(%rip), %xmm0
	mulsd	40(%rsp), %xmm0
	divsd	48(%rsp), %xmm0
	call	sincos
	xorpd	%xmm2, %xmm2
	movsd	72(%rsp), %xmm3
	movsd	8(%rbx), %xmm1
	mulsd	%xmm3, %xmm2
	movsd	(%rbx), %xmm0
	addq	$16, %rbx
	addsd	64(%rsp), %xmm2
	call	__muldc3
	movsd	16(%rsp), %xmm4
	cmpl	%ebp, %r15d
	movsd	(%rsp), %xmm5
	addsd	%xmm0, %xmm4
	addsd	%xmm1, %xmm5
	movsd	%xmm4, (%r14)
	movsd	%xmm5, 8(%r14)
	jne	.L28
	addl	$1, %r12d
	addq	$16, %r14
	cmpl	%ebp, %r12d
	jne	.L29
.L26:
	addq	$88, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE567:
	.size	dft_naive, .-dft_naive
	.p2align 4,,15
	.globl	get_even
	.type	get_even, @function
get_even:
.LFB568:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%esi, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movslq	%esi, %rdi
	salq	$4, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	shrq	%rdi
	call	malloc
	movl	%ebp, %ecx
	shrl	$31, %ecx
	addl	%ebp, %ecx
	sarl	%ecx
	testl	%ecx, %ecx
	jle	.L39
	subl	$1, %ecx
	xorl	%edx, %edx
	addq	$1, %rcx
	salq	$4, %rcx
	.p2align 4,,10
	.p2align 3
.L36:
	movsd	(%rbx,%rdx,2), %xmm1
	movsd	8(%rbx,%rdx,2), %xmm0
	movsd	%xmm1, (%rax,%rdx)
	movsd	%xmm0, 8(%rax,%rdx)
	addq	$16, %rdx
	cmpq	%rcx, %rdx
	jne	.L36
.L39:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE568:
	.size	get_even, .-get_even
	.p2align 4,,15
	.globl	get_odd
	.type	get_odd, @function
get_odd:
.LFB569:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%esi, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movslq	%esi, %rdi
	salq	$4, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	shrq	%rdi
	call	malloc
	movl	%ebp, %ecx
	shrl	$31, %ecx
	addl	%ebp, %ecx
	sarl	%ecx
	testl	%ecx, %ecx
	jle	.L46
	subl	$1, %ecx
	xorl	%edx, %edx
	addq	$1, %rcx
	salq	$4, %rcx
	.p2align 4,,10
	.p2align 3
.L43:
	movsd	16(%rbx,%rdx,2), %xmm1
	movsd	24(%rbx,%rdx,2), %xmm0
	movsd	%xmm1, (%rax,%rdx)
	movsd	%xmm0, 8(%rax,%rdx)
	addq	$16, %rdx
	cmpq	%rcx, %rdx
	jne	.L43
.L46:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE569:
	.size	get_odd, .-get_odd
	.p2align 4,,15
	.globl	fft_naive
	.type	fft_naive, @function
fft_naive:
.LFB570:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edx, %ebx
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	testl	%edx, %edx
	jle	.L48
	cmpl	$1, %edx
	movq	%rdi, %r12
	movq	%rsi, %r15
	je	.L63
	movslq	%edx, %r13
	movl	%ebx, %ebp
	salq	$4, %r13
	sarl	%ebp
	leal	-1(%rbp), %r14d
	shrq	%r13
	movq	%r13, %rdi
	salq	$5, %r14
	call	malloc
	leaq	32(%r12,%r14), %rdx
	movq	%rax, 40(%rsp)
	movq	%r12, %rax
	movq	40(%rsp), %rcx
	.p2align 4,,10
	.p2align 3
.L52:
	movsd	(%rax), %xmm1
	movsd	8(%rax), %xmm0
	addq	$32, %rax
	movsd	%xmm1, (%rcx)
	movsd	%xmm0, 8(%rcx)
	addq	$16, %rcx
	cmpq	%rdx, %rax
	jne	.L52
	movq	%r13, %rdi
	call	malloc
	leaq	48(%r12,%r14), %rdx
	movq	%rax, 16(%rsp)
	leaq	16(%r12), %rax
	movq	16(%rsp), %rcx
	.p2align 4,,10
	.p2align 3
.L54:
	movsd	(%rax), %xmm1
	movsd	8(%rax), %xmm0
	addq	$32, %rax
	movsd	%xmm1, (%rcx)
	movsd	%xmm0, 8(%rcx)
	addq	$16, %rcx
	cmpq	%rdx, %rax
	jne	.L54
	movq	%r13, %rdi
	call	malloc
	movq	%r13, %rdi
	movq	%r15, %r13
	movq	%rax, 24(%rsp)
	call	malloc
	movq	24(%rsp), %rsi
	movl	%ebp, %edx
	movq	40(%rsp), %rdi
	movq	%rax, 32(%rsp)
	call	fft_naive
	movq	32(%rsp), %rsi
	movl	%ebp, %edx
	movq	16(%rsp), %rdi
	call	fft_naive
	movq	24(%rsp), %r14
	movslq	%ebp, %r8
	cvtsi2sd	%ebx, %xmm0
	movq	32(%rsp), %rbx
	salq	$4, %r8
	leaq	(%r15,%r8), %r12
	xorl	%r15d, %r15d
	movsd	%xmm0, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L56:
	cvtsi2sd	%r15d, %xmm0
	addl	$1, %r15d
	leaq	48(%rsp), %rsi
	leaq	56(%rsp), %rdi
	mulsd	.LC3(%rip), %xmm0
	divsd	8(%rsp), %xmm0
	call	sincos
	xorpd	%xmm2, %xmm2
	movsd	56(%rsp), %xmm3
	movsd	8(%rbx), %xmm1
	mulsd	%xmm3, %xmm2
	movsd	(%rbx), %xmm0
	addq	$16, %rbx
	addsd	48(%rsp), %xmm2
	call	__muldc3
	movsd	8(%r14), %xmm2
	movsd	(%r14), %xmm3
	addsd	%xmm1, %xmm2
	addsd	%xmm0, %xmm3
	movsd	%xmm2, 8(%r13)
	movsd	%xmm3, 0(%r13)
	addq	$16, %r13
	movsd	8(%r14), %xmm2
	subsd	%xmm1, %xmm2
	movsd	(%r14), %xmm1
	addq	$16, %r14
	subsd	%xmm0, %xmm1
	movsd	%xmm2, 8(%r12)
	movsd	%xmm1, (%r12)
	addq	$16, %r12
	cmpl	%ebp, %r15d
	jne	.L56
.L51:
	movq	40(%rsp), %rdi
	call	free
	movq	16(%rsp), %rdi
	call	free
	movq	24(%rsp), %rdi
	call	free
	movq	32(%rsp), %rdi
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	free
	.p2align 4,,10
	.p2align 3
.L63:
	.cfi_restore_state
	movsd	(%rdi), %xmm1
	movsd	8(%rdi), %xmm0
	movl	$8, %edi
	movsd	%xmm1, (%rsi)
	movsd	%xmm0, 8(%rsi)
	call	malloc
	movl	$8, %edi
	movq	%rax, 40(%rsp)
	call	malloc
	movl	$8, %edi
	movq	%rax, 16(%rsp)
	call	malloc
	movl	$8, %edi
	movq	%rax, 24(%rsp)
	call	malloc
	movq	24(%rsp), %rsi
	xorl	%edx, %edx
	movq	40(%rsp), %rdi
	movq	%rax, 32(%rsp)
	call	fft_naive
	movq	32(%rsp), %rsi
	xorl	%edx, %edx
	movq	16(%rsp), %rdi
	call	fft_naive
	jmp	.L51
	.p2align 4,,10
	.p2align 3
.L48:
	addq	$72, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE570:
	.size	fft_naive, .-fft_naive
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC5:
	.string	"Usage: fft size algo\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC6:
	.string	"size is the size of the array to transform, it must be a power of two."
	.align 8
.LC7:
	.string	"algo: select which algorithm to run."
	.section	.rodata.str1.1
.LC8:
	.string	"      1 - naive dft"
.LC9:
	.string	"      2 - naive fft"
.LC10:
	.string	"      3 - your code"
.LC11:
	.string	"      4 - fftw"
.LC12:
	.string	"Example: fft 1024 3"
.LC13:
	.string	"size must be a power of two!"
.LC14:
	.string	"algo must be between 1 and 4."
	.section	.rodata.str1.8
	.align 8
.LC19:
	.string	"dft_naive took %.4f flop per 1000 cycles\n"
	.align 8
.LC20:
	.string	"fft_naive took %.4f flop per 1000 cycles\n"
	.align 8
.LC21:
	.string	"my_fft took %.4f flop per 1000 cycles\n"
	.align 8
.LC22:
	.string	"fftw took %.4f flop per 1000 cycles\n"
	.align 8
.LC25:
	.string	"Error at %d, correct is (%f %f), my_fft returned (%f %f)\n"
	.section	.rodata.str1.1
.LC26:
	.string	"..."
.LC27:
	.string	"number of errors: %d\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB571:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	cmpl	$2, %edi
	jle	.L107
	movq	8(%rsi), %rdi
	movq	%rsi, %rbx
	movl	$10, %edx
	xorl	%esi, %esi
	call	strtol
	movq	16(%rbx), %rdi
	xorl	%esi, %esi
	movl	$10, %edx
	movq	%rax, %rbp
	movl	%eax, %r13d
	call	strtol
	xorl	%ecx, %ecx
	movl	$1, %esi
	movq	%rax, %r15
	orl	$-1, %eax
	.p2align 4,,10
	.p2align 3
.L69:
	movl	%esi, %edx
	sall	%cl, %edx
	cmpl	%edx, %r13d
	cmove	%ecx, %eax
	addl	$1, %ecx
	cmpl	$31, %ecx
	jne	.L69
	cmpl	$-1, %eax
	je	.L108
	leal	-1(%r15), %edx
	cmpl	$3, %edx
	ja	.L109
	leal	0(%r13,%r13,4), %edx
	movslq	%r13d, %r12
	imull	%edx, %eax
	salq	$4, %r12
	movq	%r12, %rdi
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, 80(%rsp)
	call	malloc
	movq	%r12, %rdi
	movq	%rax, %rbx
	call	malloc
	movq	%r12, %rdi
	movq	%rax, 72(%rsp)
	call	malloc
	xorl	%r8d, %r8d
	orl	$-1, %ecx
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movl	%r13d, %edi
	movq	%rax, 64(%rsp)
	call	fftw_plan_dft_1d
	testl	%r13d, %r13d
	movq	%rax, 88(%rsp)
	jle	.L80
	cvtsi2sd	%r13d, %xmm0
	movq	%rbx, %r14
	xorl	%r12d, %r12d
	movsd	%xmm0, 48(%rsp)
	.p2align 4,,10
	.p2align 3
.L79:
	cvtsi2sd	%r12d, %xmm3
	movsd	.LC16(%rip), %xmm0
	movapd	%xmm3, %xmm1
	movsd	%xmm3, 16(%rsp)
	xorpd	.LC15(%rip), %xmm1
	divsd	48(%rsp), %xmm1
	call	pow
	leaq	96(%rsp), %rsi
	movl	%r12d, %ecx
	movapd	%xmm0, %xmm2
	imull	%r12d, %ecx
	leaq	104(%rsp), %rdi
	movsd	%xmm2, (%rsp)
	addl	$1, %r12d
	cvtsi2sd	%ecx, %xmm0
	call	sincos
	movsd	(%rsp), %xmm2
	movsd	104(%rsp), %xmm0
	addsd	96(%rsp), %xmm2
	movsd	16(%rsp), %xmm3
	movsd	%xmm0, 56(%rsp)
	movsd	.LC17(%rip), %xmm0
	movapd	%xmm3, %xmm1
	movsd	%xmm2, (%rsp)
	divsd	48(%rsp), %xmm1
	call	pow
	movsd	(%rsp), %xmm2
	xorpd	%xmm1, %xmm1
	addsd	56(%rsp), %xmm0
	mulsd	%xmm2, %xmm1
	movsd	%xmm2, 8(%r14)
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%r14)
	addq	$16, %r14
	cmpl	%r12d, %r13d
	jg	.L79
.L80:
	cmpl	$2, %r15d
	je	.L75
	jle	.L110
	cmpl	$3, %r15d
	.p2align 4,,3
	je	.L76
	cmpl	$4, %r15d
	.p2align 4,,3
	je	.L111
.L97:
	movq	88(%rsp), %rdi
	call	fftw_execute
	testl	%r13d, %r13d
	jle	.L98
	leal	-1(%rbp), %r8d
	movq	64(%rsp), %r15
	xorl	%ebp, %ebp
	addq	$1, %r8
	movq	72(%rsp), %r14
	xorl	%r12d, %r12d
	salq	$4, %r8
	xorl	%r13d, %r13d
	movsd	.LC23(%rip), %xmm6
	movsd	.LC24(%rip), %xmm5
	jmp	.L96
	.p2align 4,,10
	.p2align 3
.L95:
	cmpl	$10, %r13d
	je	.L112
.L93:
	addq	$16, %rbp
	addl	$1, %r12d
	addq	$16, %r15
	addq	$16, %r14
	cmpq	%r8, %rbp
	je	.L91
.L96:
	movsd	(%r15), %xmm0
	movsd	(%r14), %xmm2
	movapd	%xmm0, %xmm4
	movsd	8(%r15), %xmm1
	subsd	%xmm2, %xmm4
	movsd	8(%r14), %xmm3
	andpd	%xmm6, %xmm4
	ucomisd	%xmm5, %xmm4
	ja	.L92
	movapd	%xmm1, %xmm4
	subsd	%xmm3, %xmm4
	andpd	%xmm6, %xmm4
	ucomisd	%xmm5, %xmm4
	jbe	.L93
.L92:
	addl	$1, %r13d
	cmpl	$9, %r13d
	jg	.L95
	movl	%r12d, %esi
	movl	$.LC25, %edi
	movl	$4, %eax
	movsd	%xmm5, (%rsp)
	movapd	%xmm6, 16(%rsp)
	movq	%r8, 40(%rsp)
	call	printf
	movsd	(%rsp), %xmm5
	movapd	16(%rsp), %xmm6
	movq	40(%rsp), %r8
	jmp	.L93
.L109:
	movl	$.LC14, %edi
	call	puts
.L66:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L107:
	.cfi_restore_state
	movl	$.LC5, %edi
	call	puts
	movl	$.LC6, %edi
	call	puts
	movl	$.LC7, %edi
	call	puts
	movl	$.LC8, %edi
	call	puts
	movl	$.LC9, %edi
	call	puts
	movl	$.LC10, %edi
	call	puts
	movl	$.LC11, %edi
	call	puts
	movl	$.LC12, %edi
	call	puts
	jmp	.L66
.L110:
	cmpl	$1, %r15d
	je	.L113
	cmpl	$4, %r15d
	.p2align 4,,3
	jne	.L97
.L90:
	movq	%rbx, %rdi
	call	free
	movq	72(%rsp), %rdi
	call	free
	movq	64(%rsp), %rdi
	call	free
	jmp	.L66
.L98:
	xorl	%r13d, %r13d
.L91:
	movl	%r13d, %esi
	movl	$.LC27, %edi
	xorl	%eax, %eax
	call	printf
	jmp	.L90
.L112:
	movl	$.LC26, %edi
	movsd	%xmm5, (%rsp)
	movapd	%xmm6, 16(%rsp)
	movq	%r8, 40(%rsp)
	call	puts
	movq	40(%rsp), %r8
	movapd	16(%rsp), %xmm6
	movsd	(%rsp), %xmm5
	jmp	.L93
.L113:
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	72(%rsp), %rsi
	movl	%edx, %r15d
	movq	%rbx, %rdi
	movl	%r13d, %edx
	movl	%eax, %r12d
	call	dft_naive
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%r12d, %ecx
	movl	%eax, %eax
	subq	%rcx, %rdx
	movsd	80(%rsp), %xmm0
	salq	$32, %r15
	addq	%rax, %rdx
	mulsd	.LC18(%rip), %xmm0
	subq	%r15, %rdx
	js	.L81
	cvtsi2sdq	%rdx, %xmm1
.L82:
	divsd	%xmm1, %xmm0
	movl	$.LC19, %edi
	movl	$1, %eax
	call	printf
	jmp	.L97
.L75:
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	72(%rsp), %rsi
	movl	%edx, %r15d
	movq	%rbx, %rdi
	movl	%r13d, %edx
	movl	%eax, %r12d
	call	fft_naive
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%r12d, %ecx
	movl	%eax, %eax
	subq	%rcx, %rdx
	movsd	80(%rsp), %xmm0
	salq	$32, %r15
	addq	%rax, %rdx
	mulsd	.LC18(%rip), %xmm0
	subq	%r15, %rdx
	js	.L84
	cvtsi2sdq	%rdx, %xmm1
.L85:
	divsd	%xmm1, %xmm0
	movl	$.LC20, %edi
	movl	$1, %eax
	call	printf
	jmp	.L97
.L111:
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	88(%rsp), %rdi
	movl	%eax, %r15d
	movl	%edx, %ebp
	call	fftw_execute
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%eax, %eax
	movsd	80(%rsp), %xmm0
	subq	%r15, %rdx
	salq	$32, %rbp
	mulsd	.LC18(%rip), %xmm0
	addq	%rax, %rdx
	subq	%rbp, %rdx
	js	.L88
	cvtsi2sdq	%rdx, %xmm1
.L89:
	divsd	%xmm1, %xmm0
	movl	$.LC22, %edi
	movl	$1, %eax
	call	printf
	jmp	.L90
.L76:
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	72(%rsp), %rsi
	movl	%edx, %r15d
	movq	%rbx, %rdi
	movl	%r13d, %edx
	movl	%eax, %r12d
	call	my_fft
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%r12d, %ecx
	movl	%eax, %eax
	subq	%rcx, %rdx
	movsd	80(%rsp), %xmm0
	salq	$32, %r15
	addq	%rax, %rdx
	mulsd	.LC18(%rip), %xmm0
	subq	%r15, %rdx
	js	.L86
	cvtsi2sdq	%rdx, %xmm1
.L87:
	divsd	%xmm1, %xmm0
	movl	$.LC21, %edi
	movl	$1, %eax
	call	printf
	jmp	.L97
.L108:
	movl	$.LC13, %edi
	call	puts
	.p2align 4,,3
	jmp	.L66
.L86:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L87
.L88:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L89
.L84:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L85
.L81:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L82
	.cfi_endproc
.LFE571:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
	.long	0
	.long	-2147483648
	.align 8
.LC3:
	.long	1413754136
	.long	-1072094725
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC15:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC16:
	.long	2610427048
	.long	1073341303
	.align 8
.LC17:
	.long	2332332443
	.long	1074118410
	.align 8
.LC18:
	.long	0
	.long	1083129856
	.section	.rodata.cst16
	.align 16
.LC23:
	.long	4294967295
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC24:
	.long	3794832442
	.long	1044740494
	.ident	"GCC: (Debian 4.7.1-7) 4.7.1"
	.section	.note.GNU-stack,"",@progbits
