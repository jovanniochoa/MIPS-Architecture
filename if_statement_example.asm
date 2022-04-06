#branch example
#if (i == j) f=g+h else f=g-h

	.data
f:	.word	0
g:	.word	5
h:	.word	6
i:	.word	3
j:	.word	3

	.text	
	lw	$s0, f		#load data
	lw	$s1, g
	lw	$s2, h
	lw	$s3, i
	lw	$s3, j
	
	bne	$s3, $s4, else
	add	$s0, $s1, $s2
	j	Exit
Else:	sub	$s0, $s1, $s2

Exit:	li 	$v0, 10
	syscall