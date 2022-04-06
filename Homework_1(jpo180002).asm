#Homework 1
#Jovanni Ochoa
# This program gets the users names and three integers
# then calculates three expressions and displays the results

        .data
a:	.word	0
b:	.word	0
c:	.word	0
ans1:	.word	0
ans2:	.word	0
ans3:	.word	0
name:	.space	20
msg1:	.asciiz	"What is your name? "
msg2:	.asciiz	"Please enter an integer from 1-100: "
msg3:	.asciiz "Your answers are: "
msg4:	.asciiz " "

        .text
        
	li	$v0,	4	# what is your name
	la	$a0,	msg1
	syscall
	
	li	$v0,	8	#get string from user
	la	$a0,	name
	li	$a1,	20
	syscall
	
	li	$v0,	4	#please enter an ineger from 1-100
	la	$a0,	msg2
	syscall
	
	li	$v0,	5	#gets integer from user
	syscall
	sw	$v0,	a
	
	
	li	$v0,	4	#prints: please enter an ineger from 1-100
	la	$a0,	msg2
	syscall
	
	li	$v0,	5	#gets integer from user
	syscall
	sw	$v0,	b
	
	li	$v0,	4	#prints: please enter an ineger from 1-100
	la	$a0,	msg2
	syscall
	
	li	$v0,	5	#gets integer from user
	syscall
	sw	$v0,	c
	
	#loads variables that I need/ will rewrite
	lw	$s1,	a
	lw	$s2,	b
	lw	$s3,	c
	lw	$s4,	ans1
	lw	$s5,	ans2
	lw	$s6,	ans3
	
	#calculates (a+3)-(b-1)+(c+3)
	add	$t0, $s1, 3
	sw	$t0, ans1
	lw	$s4, ans1
	sub	$t0, $s2, 1
	sw	$t0, ans2
	lw	$s5, ans2
	add	$t0, $s3, 3
	sw	$t0, ans3
	lw	$s6, ans3
	sub	$t0, $s4, $s5
	sw	$t0, ans2
	lw	$s5, ans2
	add	$t0, $s5, $s6
	sw	$t0, ans3
	sub	$t0, $s4, $s4 #resets ans1
	sw	$t0, ans1
	sub	$t0, $s5, $s5 #resets ans2
	sw	$t0, ans2
	
	
	#calculates b-c+(a-2)
	sub	$t0, $s1, 2
	sw	$t0, ans1
	lw	$s4, ans1
	sub	$t0, $s2, $s3
	sw	$t0, ans2
	lw	$s5, ans2
	add	$t0, $s4, $s5
	sw	$t0, ans2
	sub	$t0, $s4, $s4 #resets ans1
	sw	$t0, ans1
	
	#calculates 2a-c+4
	add	$t0, $s1, $s1
	sw	$t0, ans1
	lw	$s4, ans1
	sub	$t0, $s4, $s3
	sw	$t0, ans1
	lw	$s4, ans1
	add	$t0, $s4, 4
	sw	$t0, ans1
	
	#echo data to user
	li	$v0,	4	#prints user's name
	la	$a0,	name
	syscall
	
	li	$v0,	4	#prints: Your answers are
	la	$a0,	msg3
	syscall
	
	lw	$a0,	ans1	#prints 2a-c+4 calculation
	li	$v0,	1
	syscall
	
	li	$a0,	32	# puts a space between numbers
	li	$v0,	11	
	syscall
	
	lw	$a0,	ans2	#prints b-c+(a-2) calculation
	li	$v0,	1
	syscall
	
	li	$a0,	32	# puts a space between numbers
	li	$v0,	11	
	syscall
	
	lw	$a0,	ans3	#prints (a+3)-(b-1)+(c+3) calculation
	li	$v0,	1
	syscall
	

exit:	li	$v0,	10
	syscall

#Attempt1

#What is your name? Maggie
#Please enter an integer from 1-100: 24
#Please enter an integer from 1-100: 6
#Please enter an integer from 1-100: 54
#Maggie
#Your answers are: -2 -26 79			
	
#---------------------------------------------#

#Attempt 2

#What is your name? Joe
#Please enter an integer from 1-100: 13
#Please enter an integer from 1-100: 89
#Please enter an integer from 1-100: 2
#Joe
#Your answers are: 28 98 -67
				
				