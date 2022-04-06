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
	move $s0, $v0
	
	#reads the file
	move $a0, $s0
	la $a1, buffer
	li $a2, 80
	li $v0, 14
	syscall
	
	#closes file
	li   $v0, 16
	move $a0, $s6
	syscall 
	
	move $v0, $s0 		# number of characters read
	
	#displays error if bytes read is zero
	ble $v0, $zero, error
	j	extrac
	move $t7, $v0
	
	la $a0, array
	li $a1, 20
	la $a2, buffer
	jal	extrac
	move $t7, $v0
	
asIs:	
	li $v0, 4
	la $a0, before
	syscall
	
sorting:	
	la $a0, array
	move $a1, $t7
	jal sort
sort:	
	li $t0, 0
	sub $s0, $a1, 1
	
	
error:	
	la	$a0, bad
	li	$v0, 4
	syscall
	j	exit
	
extrac:
	li $s1, -1
	li $t0, 0
	li $a2, 80
loop:	
	lb $t1, ($a2)
	beq $t1, 10, store
	beq $t1, $zero, goNext
	blt $t1, 48, ignore
	bgt $t1, 57, ignore
	addi $t1, $t1, -48
	bne $s1, -1, multt
	li $s1, 0
multt:
	li $t3, 10
	mul $s1, $s1, $t3
	add $s1, $s1, $t1
ignore:	
	add $a2, $a2, 1
	j	loop
store:
	beq $s1, -1, skip
	sll $t2, $t0, 2
	add $t2, $t2, $a0
	sw $s1, 0($t2)
	li $s1, -1
	
skip:	
	addiu $t0, $t0, 1
	add $a2, $a2, 1
	beq $t0, 20, goNext
	j	loop
goNext:
	move $v0, $t0
	jr	$ra
	
	
	
	#prints the file
	li  $v0, 4
	la  $a0, buffer
	syscall 
	
	
exit:	
	li $v0, 10
	syscall
