	.data
fileNa:	.asciiz	"/Users/jovanniochoa/Desktop/input.txt"
buffer:	.space	80
numCha:	.word	0
bad:	.asciiz	"There is an error. Now Exiting!"
before:	.asciiz "Before: "
after:	.asciiz	"After: "
mean:	.asciiz	"Mean: "
median:	.asciiz	"Median: "
staDev:	.asciiz "Standard Deviation: "
array:	.word	20
	.text
	
main:

file:
	#opens the file
	li $v0, 13
	la $a0, fileNa
	li $a1, 0
	li $a2, 0
	syscall
	
	 #saves file descriptor
	move $s6, $v0
	
	#reads the file
	move $a0, $s6
	la $a1, buffer
	li $a2, 80
	li $v0, 14
	syscall
	
	#displays error if bytes read is zero
	ble $v0, $zero, error
	
	#prints the file
	li  $v0, 4
	la  $a0, buffer
	syscall 
	
	#closes file
	li   $v0, 16
	move $a0, $s6
	syscall 
	
extrac:	
	la $a0, array
	li $a1, 20
	la $a2, buffer
	
	
	
	j	exit
error:	
	la	$a0, bad
	li	$v0, 4
	syscall
	j	exit
	
	
exit:	
	li $v0, 10
	syscall