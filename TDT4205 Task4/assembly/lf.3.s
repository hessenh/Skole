	.file	"lf.c"
	.text
	.p2align 4,,15
.globl foo
	.type	foo, @function
foo:
	pushl	%ebp
	movl	$1, %ecx
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	xorl	%ebx, %ebx
	subl	$4, %esp
	cmpl	$1, 8(%ebp)
	jle	.L3
	movl	$1431655766, %edi
	.p2align 4,,7
	.p2align 3
.L8:
	movl	%ecx, %eax
	imull	%edi
	movl	%ecx, %eax
	sarl	$31, %eax
	leal	(%ecx,%ebx), %esi
	movl	%eax, -16(%ebp)
	subl	%eax, %edx
	leal	(%edx,%edx,2), %edx
	cmpl	%edx, %ecx
	je	.L4
	movl	$1717986919, %eax
	imull	%ecx
	sarl	%edx
	subl	-16(%ebp), %edx
	leal	(%edx,%edx,4), %edx
	cmpl	%edx, %ecx
	jne	.L5
.L4:
	movl	%esi, %ebx
.L5:
	addl	$1, %ecx
	cmpl	%ecx, 8(%ebp)
	jg	.L8
.L3:
	addl	$4, %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	foo, .-foo
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Sum is %d.\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	xorl	%ebx, %ebx
	pushl	%ecx
	subl	$24, %esp
	movl	4(%ecx), %eax
	movl	$10, 8(%esp)
	movl	$0, 4(%esp)
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	strtol
	movl	$1, %ecx
	cmpl	$1, %eax
	movl	%eax, %edi
	jle	.L13
	.p2align 4,,7
	.p2align 3
.L18:
	movl	$1431655766, %eax
	imull	%ecx
	movl	%ecx, %eax
	sarl	$31, %eax
	leal	(%ebx,%ecx), %esi
	movl	%eax, -20(%ebp)
	subl	%eax, %edx
	leal	(%edx,%edx,2), %edx
	cmpl	%edx, %ecx
	je	.L14
	movl	$1717986919, %eax
	imull	%ecx
	sarl	%edx
	subl	-20(%ebp), %edx
	leal	(%edx,%edx,4), %edx
	cmpl	%edx, %ecx
	jne	.L15
.L14:
	movl	%esi, %ebx
.L15:
	addl	$1, %ecx
	cmpl	%ecx, %edi
	jg	.L18
.L13:
	movl	%ebx, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	addl	$24, %esp
	xorl	%eax, %eax
	popl	%ecx
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (Debian 4.3.2-1.1) 4.3.2"
	.section	.note.GNU-stack,"",@progbits
