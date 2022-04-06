	.data
a:	.word	0
b:	.word	0
c:	.word	0

	.text
	
main:
	lw	$s1, a
	lw	$s2, b
	lw	$s3, c
	
	li	$v0, 5
	syscall
	sw	$v0, a
	
	li	$v0, 5
	syscall
	sw	$v0, b
	
	li	$v0, 5
	syscall
	sw	$v0, c
	
	#calculations
	
	#c=a+b/2
	
	
	#a*(b-c)

exit:	li	$v0, 10
	syscall