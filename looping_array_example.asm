#looping through an array
#while (arr[i] != 1 ) i++;

	.data
arr:	.word	3, 8, 12, 1

	.text	
	li	$s3, 0		#$s3 = i = 0
	la	$s6, arr	#$s6 = arr[0] address
	li	$s5, -1		#$s5 = sentinal
		
loop:	sll	$t1, $t3, 2	#i = i * 4
	add	$t1, $t1, $s6	#adress = arr[0] + i*4
	lw	$t0, ($t1)	#get next array element
	beq	$t0, $s5, Exit	#stop if i == -1
	addi	$s3, $s3, 1	#i++
	j	loop

Exit:	li 	$v0, 10
	syscall
