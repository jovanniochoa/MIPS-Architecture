#calculate b^2-4ac
#assume products <= 32 bits

	.data
a:	.word	10
b:	.word	15
c:	.word	3
result:	.word	0

	.text
main:
	#load a, b, c
	lw	$s1, a
	lw	$s2, b
	lw	$s3, c
	li	$t0, 2
	
	div	$s2, $t0	#b/2
	mflo	$t1
	
	add	$s3, $s1, $t1	#a+b/2
	
	#exits program
exit:	li 	$v0, 10
	syscall
