	.file	"lf.c"
	.text
.globl foo
	.type	foo, @function
foo:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$32, %esp
	movl	$0, -12(%ebp)
	movl	$1, -8(%ebp)
	jmp	.L2
.L5:
	movl	-8(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	$1431655766, -36(%ebp)
	movl	-36(%ebp), %eax
	imull	-32(%ebp)
	movl	%edx, %ecx
	movl	-32(%ebp), %eax
	sarl	$31, %eax
	movl	%ecx, %ebx
	subl	%eax, %ebx
	movl	%ebx, -28(%ebp)
	movl	-28(%ebp), %eax
	addl	%eax, %eax
	addl	-28(%ebp), %eax
	movl	-32(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, -28(%ebp)
	cmpl	$0, -28(%ebp)
	je	.L3
	movl	-8(%ebp), %ecx
	movl	$1717986919, -36(%ebp)
	movl	-36(%ebp), %eax
	imull	%ecx
	sarl	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	movl	%edx, %ebx
	subl	%eax, %ebx
	movl	%ebx, -24(%ebp)
	movl	-24(%ebp), %eax
	sall	$2, %eax
	addl	-24(%ebp), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%edx, -24(%ebp)
	cmpl	$0, -24(%ebp)
	jne	.L4
.L3:
	movl	-8(%ebp), %eax
	addl	%eax, -12(%ebp)
.L4:
	addl	$1, -8(%ebp)
.L2:
	movl	-8(%ebp), %eax
	cmpl	8(%ebp), %eax
	jl	.L5
	movl	-12(%ebp), %eax
	addl	$32, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	foo, .-foo
	.section	.rodata
.LC0:
	.string	"Sum is %d.\n"
	.text
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$36, %esp
	movl	4(%ecx), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	foo
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	movl	$0, %eax
	addl	$36, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (Debian 4.3.2-1.1) 4.3.2"
	.section	.note.GNU-stack,"",@progbits
