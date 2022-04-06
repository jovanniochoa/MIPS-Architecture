# MARS sysrecall 

.data

msg1:	.asciiz	"Enter some Text: "
msg2:	.asciiz " "

.text
main:
	#prompt user for age
	la	$a0,	msg1	#prompts user msg 1	
	la	$a1,	msg2
	li	$a2,	32	#32 chars max
	li	$v0,	54
	syscall
	sw	$v1,	msg2
	
	#echo data to user
	la	$a0,	msg2
	li	$v0,	4
	syscall

exit:	li	$v0,	10
	syscall
