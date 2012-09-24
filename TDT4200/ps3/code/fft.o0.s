	.file	"fft.c"
	.text
	.type	rdtsctime, @function
rdtsctime:
.LFB537:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -24
	.cfi_offset 3, -32
#APP
# 28 "fft.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movl	%edx, %ebx
	movl	%eax, %r12d
	movl	%r12d, -20(%rbp)
	movl	%ebx, -24(%rbp)
	movl	-24(%rbp), %eax
	movq	%rax, -32(%rbp)
	salq	$32, -32(%rbp)
	movl	-20(%rbp), %eax
	addq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE537:
	.size	rdtsctime, .-rdtsctime
	.globl	my_fft
	.type	my_fft, @function
my_fft:
.LFB538:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$424, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -408(%rbp)
	movq	%rsi, -416(%rbp)
	movl	%edx, -420(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L4
.L8:
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jg	.L5
	movl	-24(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-408(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-24(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-408(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
.L5:
	movl	-420(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -28(%rbp)
	jmp	.L6
.L7:
	movl	-28(%rbp), %eax
	subl	%eax, -20(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -28(%rbp)
.L6:
	movl	-28(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L7
	movl	-28(%rbp), %eax
	addl	%eax, -20(%rbp)
	addl	$1, -24(%rbp)
.L4:
	movl	-420(%rbp), %eax
	subl	$1, %eax
	cmpl	-24(%rbp), %eax
	jg	.L8
	movl	-420(%rbp), %eax
	cltq
	subq	$1, %rax
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-420(%rbp), %eax
	cltq
	subq	$1, %rax
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-408(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	movl	$1, -32(%rbp)
	cvtsi2sd	-420(%rbp), %xmm0
	movd	%xmm0, %rax
	movd	%rax, %xmm0
	call	log2
	movd	%xmm0, %rax
	movd	%rax, %xmm1
	cvttsd2si	%xmm1, %eax
	movl	%eax, -48(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L9
.L25:
	sall	-32(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L10
.L24:
	cvtsi2sd	-40(%rbp), %xmm0
	movabsq	$-4604611780675359464, %rax
	movd	%rax, %xmm1
	mulsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	cvtsi2sd	-32(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movd	%rax, %xmm0
	call	sin
	movd	%xmm0, %rbx
	movq	-56(%rbp), %rax
	movd	%rax, %xmm0
	call	cos
	movd	%xmm0, %rdx
	movl	$0, %eax
	movd	%rbx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%rdx, %xmm1
	addsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movq	%rax, %rdx
	movq	%rbx, %rax
	movq	%rdx, -400(%rbp)
	movq	%rax, -392(%rbp)
	leaq	-400(%rbp), %rax
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	%rax, -176(%rbp)
	movq	-176(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movddup	-184(%rbp), %xmm0
	movapd	%xmm0, -80(%rbp)
	leaq	-400(%rbp), %rax
	addq	$8, %rax
	movq	%rax, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movddup	-208(%rbp), %xmm0
	movapd	%xmm0, -96(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
	jmp	.L17
.L23:
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -216(%rbp)
	movq	-216(%rbp), %rax
	movapd	(%rax), %xmm0
	movapd	%xmm0, -128(%rbp)
	movapd	-80(%rbp), %xmm0
	movapd	%xmm0, -240(%rbp)
	movapd	-128(%rbp), %xmm0
	movapd	%xmm0, -256(%rbp)
	movapd	-256(%rbp), %xmm0
	movapd	-240(%rbp), %xmm1
	mulpd	%xmm1, %xmm0
	movapd	%xmm0, -144(%rbp)
	movapd	-128(%rbp), %xmm0
	movapd	-128(%rbp), %xmm1
	shufpd	$1, %xmm1, %xmm0
	movapd	%xmm0, -128(%rbp)
	movapd	-96(%rbp), %xmm0
	movapd	%xmm0, -272(%rbp)
	movapd	-128(%rbp), %xmm0
	movapd	%xmm0, -288(%rbp)
	movapd	-288(%rbp), %xmm0
	movapd	-272(%rbp), %xmm1
	mulpd	%xmm1, %xmm0
	movapd	%xmm0, -128(%rbp)
	movapd	-144(%rbp), %xmm0
	movapd	%xmm0, -304(%rbp)
	movapd	-128(%rbp), %xmm0
	movapd	%xmm0, -320(%rbp)
	movapd	-304(%rbp), %xmm0
	addsubpd	-320(%rbp), %xmm0
	movapd	%xmm0, -144(%rbp)
	movl	-44(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -328(%rbp)
	movq	-328(%rbp), %rax
	movupd	(%rax), %xmm0
	movapd	%xmm0, -128(%rbp)
	movapd	-144(%rbp), %xmm1
	movapd	-128(%rbp), %xmm0
	subpd	%xmm1, %xmm0
	movapd	%xmm0, -160(%rbp)
	movl	-100(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -336(%rbp)
	movapd	-160(%rbp), %xmm0
	movapd	%xmm0, -352(%rbp)
	movq	-336(%rbp), %rax
	movapd	-352(%rbp), %xmm0
	movupd	%xmm0, (%rax)
	movapd	-144(%rbp), %xmm0
	movapd	-128(%rbp), %xmm1
	addpd	%xmm1, %xmm0
	movapd	%xmm0, -160(%rbp)
	movl	-44(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-416(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -360(%rbp)
	movapd	-160(%rbp), %xmm0
	movapd	%xmm0, -384(%rbp)
	movq	-360(%rbp), %rax
	movapd	-384(%rbp), %xmm0
	movupd	%xmm0, (%rax)
	movl	-32(%rbp), %eax
	addl	%eax, -44(%rbp)
.L17:
	movl	-44(%rbp), %eax
	cmpl	-420(%rbp), %eax
	jl	.L23
	addl	$1, -40(%rbp)
.L10:
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	-40(%rbp), %eax
	jg	.L24
	addl	$1, -36(%rbp)
.L9:
	movl	-36(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl	.L25
	addq	$424, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE538:
	.size	my_fft, .-my_fft
	.section	.rodata
	.align 8
.LC2:
	.long	0
	.long	0
	.long	0
	.long	0
	.text
	.globl	dft_naive
	.type	dft_naive, @function
dft_naive:
.LFB539:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movl	%edx, -100(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L27
.L30:
	movl	-36(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	addq	%rax, %rdx
	movq	.LC2(%rip), %rax
	movq	%rax, (%rdx)
	movq	.LC2+8(%rip), %rax
	movq	%rax, 8(%rdx)
	movl	$0, -40(%rbp)
	jmp	.L28
.L29:
	cvtsi2sd	-40(%rbp), %xmm0
	movabsq	$-4604611780675359464, %rax
	movd	%rax, %xmm1
	mulsd	%xmm0, %xmm1
	cvtsi2sd	-36(%rbp), %xmm0
	movapd	%xmm1, %xmm2
	mulsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	cvtsi2sd	-100(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movd	%rax, %xmm0
	call	sin
	movd	%xmm0, %rax
	movq	%rax, -48(%rbp)
	cvtsi2sd	-40(%rbp), %xmm0
	movabsq	$-4604611780675359464, %rax
	movd	%rax, %xmm1
	mulsd	%xmm0, %xmm1
	cvtsi2sd	-36(%rbp), %xmm0
	movapd	%xmm1, %xmm2
	mulsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	cvtsi2sd	-100(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movd	%rax, %xmm0
	call	cos
	movd	%xmm0, %rcx
	movq	-48(%rbp), %rdx
	movl	$0, %eax
	movd	%rdx, %xmm0
	movd	%rax, %xmm2
	mulsd	%xmm2, %xmm0
	movd	%rcx, %xmm1
	addsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -64(%rbp)
	movl	-36(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	leaq	(%rdx,%rax), %r13
	movl	-36(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %r12
	movq	8(%rax), %rbx
	movl	-40(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-88(%rbp), %rax
	addq	%rax, %rdx
	movq	(%rdx), %rax
	movq	8(%rdx), %rdx
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rcx
	movd	%rsi, %xmm3
	movd	%rcx, %xmm2
	movd	%rdx, %xmm1
	movd	%rax, %xmm0
	call	__muldc3
	movd	%xmm0, %rax
	movd	%xmm1, %rcx
	movq	%rax, %rdx
	movq	%rcx, %rax
	movd	%r12, %xmm2
	movd	%rdx, %xmm0
	addsd	%xmm0, %xmm2
	movd	%xmm2, %rdx
	movd	%rbx, %xmm1
	movd	%rax, %xmm2
	addsd	%xmm2, %xmm1
	movd	%xmm1, %rax
	movq	%rdx, 0(%r13)
	movq	%rax, 8(%r13)
	addl	$1, -40(%rbp)
.L28:
	movl	-40(%rbp), %eax
	cmpl	-100(%rbp), %eax
	jl	.L29
	addl	$1, -36(%rbp)
.L27:
	movl	-36(%rbp), %eax
	cmpl	-100(%rbp), %eax
	jl	.L30
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE539:
	.size	dft_naive, .-dft_naive
	.globl	get_even
	.type	get_even, @function
get_even:
.LFB540:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %eax
	cltq
	salq	$4, %rax
	shrq	%rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -16(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L32
.L33:
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-16(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$5, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	addl	$1, -4(%rbp)
.L32:
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	-4(%rbp), %eax
	jg	.L33
	movq	-16(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE540:
	.size	get_even, .-get_even
	.globl	get_odd
	.type	get_odd, @function
get_odd:
.LFB541:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %eax
	cltq
	salq	$4, %rax
	shrq	%rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -16(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L36
.L37:
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-16(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	salq	$5, %rax
	leaq	16(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	addl	$1, -4(%rbp)
.L36:
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	-4(%rbp), %eax
	jg	.L37
	movq	-16(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE541:
	.size	get_odd, .-get_odd
	.globl	fft_naive
	.type	fft_naive, @function
fft_naive:
.LFB542:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movl	%edx, -100(%rbp)
	cmpl	$0, -100(%rbp)
	jle	.L45
.L40:
	cmpl	$1, -100(%rbp)
	jne	.L42
	movq	-88(%rbp), %rax
	movq	(%rax), %rdx
	movq	-88(%rbp), %rax
	movq	8(%rax), %rax
	movq	-96(%rbp), %rcx
	movq	%rdx, (%rcx)
	movq	-96(%rbp), %rdx
	movq	%rax, 8(%rdx)
.L42:
	movl	-100(%rbp), %edx
	movq	-88(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	get_even
	movq	%rax, -16(%rbp)
	movl	-100(%rbp), %edx
	movq	-88(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	get_odd
	movq	%rax, -24(%rbp)
	movl	-100(%rbp), %eax
	cltq
	salq	$4, %rax
	shrq	%rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -32(%rbp)
	movl	-100(%rbp), %eax
	cltq
	salq	$4, %rax
	shrq	%rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -40(%rbp)
	movl	-100(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movq	-32(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fft_naive
	movl	-100(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movq	-40(%rbp), %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fft_naive
	movl	$0, -4(%rbp)
	jmp	.L43
.L44:
	cvtsi2sd	-4(%rbp), %xmm0
	movabsq	$-4604611780675359464, %rax
	movd	%rax, %xmm1
	mulsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	cvtsi2sd	-100(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movd	%rax, %xmm0
	call	sin
	movd	%xmm0, %rax
	movq	%rax, -48(%rbp)
	cvtsi2sd	-4(%rbp), %xmm0
	movabsq	$-4604611780675359464, %rax
	movd	%rax, %xmm1
	mulsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	cvtsi2sd	-100(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movd	%rax, %xmm0
	call	cos
	movd	%xmm0, %rcx
	movq	-48(%rbp), %rdx
	movl	$0, %eax
	movd	%rdx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%rcx, %xmm1
	addsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -64(%rbp)
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	(%rdx), %rax
	movq	8(%rdx), %rdx
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rcx
	movd	%rsi, %xmm3
	movd	%rcx, %xmm2
	movd	%rdx, %xmm1
	movd	%rax, %xmm0
	call	__muldc3
	movd	%xmm0, %rax
	movd	%xmm1, %rdx
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movd	%rdx, %xmm0
	addsd	-56(%rbp), %xmm0
	movd	%xmm0, %rdx
	movd	%rax, %xmm1
	addsd	-48(%rbp), %xmm1
	movd	%xmm1, %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	movl	-100(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movd	%rdx, %xmm0
	subsd	-56(%rbp), %xmm0
	movd	%xmm0, %rdx
	movd	%rax, %xmm1
	subsd	-48(%rbp), %xmm1
	movd	%xmm1, %rax
	movq	%rdx, (%rcx)
	movq	%rax, 8(%rcx)
	addl	$1, -4(%rbp)
.L43:
	movl	-100(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	-4(%rbp), %eax
	jg	.L44
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free
	jmp	.L39
.L45:
	nop
.L39:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE542:
	.size	fft_naive, .-fft_naive
	.section	.rodata
.LC3:
	.string	"Usage: fft size algo\n"
	.align 8
.LC4:
	.string	"size is the size of the array to transform, it must be a power of two."
	.align 8
.LC5:
	.string	"algo: select which algorithm to run."
.LC6:
	.string	"      1 - naive dft"
.LC7:
	.string	"      2 - naive fft"
.LC8:
	.string	"      3 - your code"
.LC9:
	.string	"      4 - fftw"
.LC10:
	.string	"Example: fft 1024 3"
.LC11:
	.string	"size must be a power of two!"
.LC12:
	.string	"algo must be between 1 and 4."
	.align 8
.LC17:
	.string	"dft_naive took %.4f flop per 1000 cycles\n"
	.align 8
.LC18:
	.string	"fft_naive took %.4f flop per 1000 cycles\n"
	.align 8
.LC19:
	.string	"my_fft took %.4f flop per 1000 cycles\n"
	.align 8
.LC20:
	.string	"fftw took %.4f flop per 1000 cycles\n"
	.align 8
.LC23:
	.string	"Error at %d, correct is (%f %f), my_fft returned (%f %f)\n"
.LC24:
	.string	"..."
.LC25:
	.string	"number of errors: %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB543:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movl	%edi, -164(%rbp)
	movq	%rsi, -176(%rbp)
	cmpl	$2, -164(%rbp)
	jg	.L47
	movl	$.LC3, %edi
	call	puts
	movl	$.LC4, %edi
	call	puts
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
	movl	$0, %eax
	jmp	.L48
.L47:
	movq	-176(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$10, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	strtol
	movl	%eax, -56(%rbp)
	movq	-176(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movl	$10, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	strtol
	movl	%eax, -60(%rbp)
	movl	$-1, -36(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L49
.L51:
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%edx, %ebx
	movl	%eax, %ecx
	sall	%cl, %ebx
	movl	%ebx, %eax
	cmpl	-56(%rbp), %eax
	jne	.L50
	movl	-40(%rbp), %eax
	movl	%eax, -36(%rbp)
.L50:
	addl	$1, -40(%rbp)
.L49:
	cmpl	$30, -40(%rbp)
	jle	.L51
	cmpl	$-1, -36(%rbp)
	jne	.L52
	movl	$.LC11, %edi
	call	puts
	movl	$0, %eax
	jmp	.L48
.L52:
	cmpl	$0, -60(%rbp)
	jle	.L53
	cmpl	$4, -60(%rbp)
	jle	.L54
.L53:
	movl	$.LC12, %edi
	call	puts
	movl	$0, %eax
	jmp	.L48
.L54:
	movl	-56(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	imull	-36(%rbp), %eax
	cvtsi2sd	%eax, %xmm0
	movd	%xmm0, %rax
	movq	%rax, -72(%rbp)
	movl	-56(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -80(%rbp)
	movl	-56(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -88(%rbp)
	movl	-56(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rdx
	movq	-80(%rbp), %rsi
	movl	-56(%rbp), %eax
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	%eax, %edi
	call	fftw_plan_dft_1d
	movq	%rax, -104(%rbp)
	movl	$0, -44(%rbp)
	jmp	.L55
.L56:
	cvtsi2sd	-44(%rbp), %xmm1
	movd	%xmm1, %rax
	movsd	.LC13(%rip), %xmm0
	btcq	$63, %rax
	cvtsi2sd	-56(%rbp), %xmm0
	movd	%rax, %xmm2
	divsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movabsq	$4609965796441453736, %rdx
	movd	%rax, %xmm1
	movd	%rdx, %xmm0
	call	pow
	movd	%xmm0, %rbx
	movl	-44(%rbp), %eax
	imull	-44(%rbp), %eax
	cvtsi2sd	%eax, %xmm0
	movd	%xmm0, %rax
	movd	%rax, %xmm0
	call	cos
	movd	%xmm0, %rax
	movd	%rbx, %xmm1
	movd	%rax, %xmm2
	addsd	%xmm2, %xmm1
	movd	%xmm1, %rbx
	movl	-44(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-80(%rbp), %rax
	leaq	(%rdx,%rax), %r13
	cvtsi2sd	-44(%rbp), %xmm0
	movd	%xmm0, %rax
	cvtsi2sd	-56(%rbp), %xmm0
	movd	%rax, %xmm1
	divsd	%xmm0, %xmm1
	movd	%xmm1, %rax
	movabsq	$4613303445313851803, %rdx
	movd	%rax, %xmm1
	movd	%rdx, %xmm0
	call	pow
	movd	%xmm0, %r12
	movl	-44(%rbp), %eax
	imull	-44(%rbp), %eax
	cvtsi2sd	%eax, %xmm2
	movd	%xmm2, %rax
	movd	%rax, %xmm0
	call	sin
	movd	%xmm0, %rax
	movd	%r12, %xmm1
	movd	%rax, %xmm0
	addsd	%xmm0, %xmm1
	movl	$0, %eax
	movd	%rbx, %xmm0
	movd	%rax, %xmm2
	mulsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	addsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movq	%rax, 0(%r13)
	movq	%rbx, 8(%r13)
	addl	$1, -44(%rbp)
.L55:
	movl	-44(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L56
	movl	-60(%rbp), %eax
	cmpl	$2, %eax
	je	.L59
	cmpl	$2, %eax
	jg	.L62
	cmpl	$1, %eax
	je	.L58
	jmp	.L57
.L62:
	cmpl	$3, %eax
	je	.L60
	cmpl	$4, %eax
	je	.L61
	jmp	.L57
.L58:
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -112(%rbp)
	movl	-56(%rbp), %edx
	movq	-88(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	dft_naive
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -120(%rbp)
	movq	-112(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rdx, %rcx
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, -128(%rbp)
	movq	-72(%rbp), %rdx
	movabsq	$4652007308841189376, %rax
	movd	%rdx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%xmm0, %rcx
	movq	-128(%rbp), %rax
	testq	%rax, %rax
	js	.L63
	cvtsi2sdq	%rax, %xmm0
	jmp	.L64
.L63:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L64:
	movd	%rcx, %xmm2
	divsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movd	%rax, %xmm0
	movl	$.LC17, %edi
	movl	$1, %eax
	call	printf
	jmp	.L57
.L59:
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -112(%rbp)
	movl	-56(%rbp), %edx
	movq	-88(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fft_naive
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -120(%rbp)
	movq	-112(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rdx, %rcx
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, -128(%rbp)
	movq	-72(%rbp), %rdx
	movabsq	$4652007308841189376, %rax
	movd	%rdx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%xmm0, %rcx
	movq	-128(%rbp), %rax
	testq	%rax, %rax
	js	.L65
	cvtsi2sdq	%rax, %xmm0
	jmp	.L66
.L65:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L66:
	movd	%rcx, %xmm2
	divsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movd	%rax, %xmm0
	movl	$.LC18, %edi
	movl	$1, %eax
	call	printf
	jmp	.L57
.L60:
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -112(%rbp)
	movl	-56(%rbp), %edx
	movq	-88(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	my_fft
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -120(%rbp)
	movq	-112(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rdx, %rcx
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, -128(%rbp)
	movq	-72(%rbp), %rdx
	movabsq	$4652007308841189376, %rax
	movd	%rdx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%xmm0, %rcx
	movq	-128(%rbp), %rax
	testq	%rax, %rax
	js	.L67
	cvtsi2sdq	%rax, %xmm0
	jmp	.L68
.L67:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L68:
	movd	%rcx, %xmm2
	divsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movd	%rax, %xmm0
	movl	$.LC19, %edi
	movl	$1, %eax
	call	printf
	jmp	.L57
.L61:
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -112(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_execute
	movl	$0, %eax
	call	rdtsctime
	movq	%rax, -120(%rbp)
	movq	-112(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rdx, %rcx
	subq	%rax, %rcx
	movq	%rcx, %rax
	movq	%rax, -128(%rbp)
	movq	-72(%rbp), %rdx
	movabsq	$4652007308841189376, %rax
	movd	%rdx, %xmm0
	movd	%rax, %xmm1
	mulsd	%xmm1, %xmm0
	movd	%xmm0, %rcx
	movq	-128(%rbp), %rax
	testq	%rax, %rax
	js	.L69
	cvtsi2sdq	%rax, %xmm0
	jmp	.L70
.L69:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L70:
	movd	%rcx, %xmm2
	divsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movd	%rax, %xmm0
	movl	$.LC20, %edi
	movl	$1, %eax
	call	printf
.L57:
	cmpl	$4, -60(%rbp)
	je	.L71
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_execute
	movl	$0, -48(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L72
.L77:
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movl	-52(%rbp), %ecx
	movslq	%ecx, %rcx
	movq	%rcx, %rsi
	salq	$4, %rsi
	movq	-88(%rbp), %rcx
	addq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	8(%rcx), %rcx
	movd	%rdx, %xmm0
	movd	%rsi, %xmm1
	subsd	%xmm1, %xmm0
	movd	%xmm0, %rdx
	movq	%rdx, -152(%rbp)
	movd	%rax, %xmm2
	movd	%rcx, %xmm0
	subsd	%xmm0, %xmm2
	movd	%xmm2, %rax
	movq	%rax, -160(%rbp)
	movq	-152(%rbp), %rax
	movq	%rax, -144(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, -136(%rbp)
	movq	-152(%rbp), %rax
	movsd	.LC21(%rip), %xmm0
	btrq	$63, %rax
	movd	%rax, %xmm1
	ucomisd	.LC22(%rip), %xmm1
	ja	.L73
	movq	-160(%rbp), %rax
	movsd	.LC21(%rip), %xmm0
	btrq	$63, %rax
	movd	%rax, %xmm2
	ucomisd	.LC22(%rip), %xmm2
	jbe	.L74
.L73:
	addl	$1, -48(%rbp)
	cmpl	$9, -48(%rbp)
	jg	.L76
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	8(%rax), %rsi
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, %rdx
	salq	$4, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, %rdi
	salq	$4, %rdi
	movq	-96(%rbp), %rax
	addq	%rdi, %rax
	movq	(%rax), %rax
	movl	-52(%rbp), %edi
	movd	%rsi, %xmm3
	movd	%rcx, %xmm2
	movd	%rdx, %xmm1
	movd	%rax, %xmm0
	movl	%edi, %esi
	movl	$.LC23, %edi
	movl	$4, %eax
	call	printf
	jmp	.L74
.L76:
	cmpl	$10, -48(%rbp)
	jne	.L74
	movl	$.LC24, %edi
	call	puts
.L74:
	addl	$1, -52(%rbp)
.L72:
	movl	-52(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L77
	movl	-48(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC25, %edi
	movl	$0, %eax
	call	printf
.L71:
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movl	$0, %eax
.L48:
	addq	$152, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE543:
	.size	main, .-main
	.section	.rodata
	.align 16
.LC13:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 16
.LC21:
	.long	4294967295
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC22:
	.long	3794832442
	.long	1044740494
	.ident	"GCC: (Debian 4.7.1-7) 4.7.1"
	.section	.note.GNU-stack,"",@progbits
