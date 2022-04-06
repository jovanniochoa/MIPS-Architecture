#Homework 2
#Jovanni Ochoa
#This program prompts the user to enter some text
#it then calculates the number of words and characters and displays it

.data

msg1:	.asciiz	"Enter some Text: "
exits:	.asciiz	"Exit: "
bye:	.asciiz "Goodbye!"
text1:	.asciiz	" words "
text2:	.asciiz	" characters"
user:	.space	100
words:	.word	0
chars:	.word	0


.text
main:
	#prompt user for age
	la	$a0, msg1	#prompts user msg 1	
	la	$a1, user
	li	$a2, 100	#100 chars max
	li	$v0, 54
	syscall
	
	li	$v0, 0		#i=0
	addi	$s1, $0, 32	#s1 has ascii 32 (space)/ ' '
	la	$t0, user
	
	#loops for counting characters
loop:
   	lb   $a0, 0($t0)
   	beqz $a0, done		#if a0 contains nothing, leave
   	beq  $a0, $s1, spaces	#if a0 contains a space, jump to spaces
   	addi $t0, $t0,1		#i++
   	addi $v0, $v0,1		#add to num of characters
   	j     loop
   	
   	#counts num of spaces then jumps back
spaces:	
	addi $v1, $v1, 1	#save num of words in v1
	addi $t0, $t0,1		#i++
   	addi $v0, $v0,1		#add num of characters
	j	loop
	
	#prints out text, words, and characters.
done:
	#save contents of v0 and v1 to char and words
	sw	$v0, chars
	sw	$v1, words
	
	beqz	$v0, exit	#if user prints nothing or cancels, return nothing/leave
	
	#echo user input
	la	$a0, user
	li	$v0, 4
	syscall
	
	#display number of words
	lw	$a0, words
	addi	$a0, $a0, 1
	li	$v0, 1
	syscall
	
	#prints " words "
	la	$a0, text1
	li	$v0, 4
	syscall
	
	#display number of characters
	lw	$a0, chars
	subi	$a0, $a0, 1
	li	$v0, 1
	syscall
	
	#prints " characters"
	la	$a0, text2
	li	$v0, 4
	syscall
	
	#Goodbye
	la	$a0, exits
	la	$a1, bye
	li	$v0, 59
	syscall

exit:	li	$v0, 10
	syscall
