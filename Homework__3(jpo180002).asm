#This program gets the data from a text file and calculates the median mean and standard deviation
#it then prints out the data once it gets/ if it gets correct input from the file
	.data
inputfile: .asciiz "input.txt"
before:	.asciiz "The array before:    "
after:	.asciiz	"The array after:     "
mean:	.asciiz	"The mean is: "
median:	.asciiz	"The median is: "
staDev:	.asciiz "The standard deviation is: "
badFile: .asciiz "There is an error reading file, exiting now!"
buffer:	.space	80
array:	.word	20
	.text
	
main:
	#load file adress and buffer adress
	la $a0, inputfile
	la $a1, buffer
	jal readFile #calls function to read file
	
	beq $v0, $0, bad # checks if the user got a bad file and exits program

	#converts from string to integers
	la $a0, array
	li $a1, 20
	la $a2, buffer
	jal getNumbers
	
	move $t2, $v0 #number of numbers in file

	#prints the message the array before
	la $a0, before
	li $v0, 4
	syscall
	
	#prints the array
	la $a0, array
	move $a1, $t2
	jal print

	#sorts the numbers
	la $a0, array
	move $a1, $t2
	jal selectionSort

	#prints the message the array after
	li $v0, 4
	la $a0, after
	syscall

	#prints the array
	la $a0, array
	move $a1, $t2
	jal	print

	#prints the mean is
	la $a0, mean
	li $v0, 4
	syscall
	
	
	#prints the integers in array
	la $a0, array
	move $a1, $t2
	jal	meanInput
	li $v0, 2
	syscall
	
	#prints new line
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
        
        #prints the median
	la $a0, median
	li $v0, 4
	syscall

	#prints the median
	la $a0, array
	move $a1, $t2
	jal	medianInput
	bltz $v1, printFloat

	#prints median value
	move $a0, $v0
	li $v0, 1
	syscall
	
	j	stdDev #goes to calculate standard deviation

printFloat: #prints float
	li $v0, 2
	syscall

#calculates standard deviation
stdDev:	
	#prints new line
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
        
        #goes to prints standard deviation
	li $v0, 4
	la $a0, staDev
	syscall
	
	#prints standard deviaation
	la $a0, array
	move $a1, $t2
	jal	StandardDeviationInput #jumps to standard deviation function
	li $v0, 2
	syscall
	
#exits the program once over
exit:
	li $v0, 10
	syscall
	
#prints out error message and exits the program
bad:	
	#prints error message
	li $v0, 4
	la $a0, badFile # 
	syscall
	
	#ends the program
	li $v0, 10
	syscall
	
readFile: #start reading file
	move $t1, $a1
	
	#open file
	li $a1, 0
	li $v0, 13
	syscall

	blt $v0, $0 exitOut # if file is read wrongly return
	move $s6, $v0

	#open the file to read it
	move $a0, $s6
	move $a1, $t1
	li $a2, 80
	li $v0, 14
	syscall

	#close the file
	move $a0, $s6
	li $v0, 16
	syscall
	
	move $v0, $s6 # number of characters
	
	#leaves
exitOut:
	jr $ra

#gets numbers
getNumbers: #reads buffer
	li $s1, -1
	li $t0, 0
loop:	
	lb $t1, ($a2)
	beq $t1, 10, storeInArray
	beq $t1, $zero, goBack
	
	#ignore these digits if less than 48 or greater than 57
	blt $t1, 48, ignoreDigit
	bgt $t1, 57, ignoreDigit 
	
	
	addi $t1, $t1, -48 #makes into decimal digit
	
	#multiply by ten
	bne $s1, -1, multiplyByTen
	li $s1, 0
	
#multiplies by 10
multiplyByTen:
	li $t3, 10
	mul $s1, $s1, $t3
	add $s1, $s1, $t1
	
#ignores digit snot in range
ignoreDigit:	
	add $a2, $a2, 1
	j	loop
	
#srores the digts into array if valid
storeInArray:
	beq $s1, -1, skip
	sll $t6, $t0, 2
	add $t6, $t6, $a0
	sw $s1, 0($t6)
	li $s1, -1
	
#sgoes to next byte
skip:	
	addiu $t0, $t0, 1
	add $a2, $a2, 1
	beq $t0, 20, goBack
	j	loop
	
#leaves function
goBack:
	move $v0, $t0
	jr	$ra

#print function
print:
	move $s6, $a0
	li $t0, 0
	
loopy:
	beq $t0, $a1, returnPrint
	
	#loads numbers and sets it up for printing
	li $v0, 1
	sll $t1, $t0, 2
	add $t1, $t1, $s6
	lw $a0, 0($t1)
	syscall
	
	#prints a space
	li $a0, 32
	li $v0, 11
	syscall
	
	#goes to next number
	add $t0, $t0, 1
	j	loopy
	
returnPrint:
	#prints a new line
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
        
         #leaves function
	jr	$ra

#selection sort
selectionSort:
	li $t0, 0
	sub $s6, $a1, 1
	
	#give back the sorted version
outerloop:
	beq $t0, $s6, givebackNeat
	move $s1, $t0
	add $t1, $t0, 1
	
#checks if there  is a swap for organizing
innerloop:
	beq $t1, $a1, isSwap
	
	sll $t6, $t1, 2
	sll $t3 $s1, 2
	
	add $t6, $t6, $a0
	add $t3, $t3, $a0
	lw $t4, 0($t6)
	lw $t5, 0($t3)
	
	blt $t4, $t5, count
	
	j nextinner

#updates the count
count:
	move $s1, $t1
	
#goes to the inner loop
nextinner:
	add $t1, $t1, 1
	j innerloop
	
#checks if there is a swap
isSwap:
	bne $s1, $t0, swap # goes to sawp
	j	nextouter

#swaps the numbers in the array 
swap:
	sll $t6, $t0, 2
	sll $t3, $s1, 2
	
	add $t6, $t6, $a0
	add $t3, $t3, $a0
	
	lw $t4, 0($t6)
	lw $t5, 0($t3)
	
	sw $t4, 0($t3)
	sw $t5, 0($t6)
	
#adds a one to register and goe sback to loop
nextouter:
	add $t0, $t0, 1
	j	outerloop
	
#leaves function
givebackNeat:
	jr	$ra

#calculates the mean
meanInput:
	li $t0, 0
	mtc1 $t0, $f12
	mtc1 $t0, $f0

#sets mean in a loop for adding the numbers up
meanInputloop:
	beq $t0, $a1, calculatedMean
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	lwc1 $f0, 0($t1)
	add.s $f12, $f12, $f0
	add $t0, $t0, 1
	j	meanInputloop
	
#returns a calculated mean back and stops function
calculatedMean:
	mtc1 $a1, $f0
	div.s $f12, $f12, $f0
	jr	$ra

#calculates the median
medianInput:
	div $t0, $a1, 2
	mfhi $t1
	beqz $t1, calculatedAverage

	sll $t6, $t0, 2
	add $t6, $t6, $a0
	lw $v0, 0($t6)

	li $v1, 0
	j	gobackMedian

#calculates the average of the numbers
calculatedAverage:
	sub $t1, $t0, 1
	
	sll $t6, $t0, 2
	sll $t3, $t1, 2
	
	add $t6, $t6, $a0
	add $t3, $t3, $a0
	
	lw $t4, 0 ($t6)
	lw $t5, 0($t3)
	
	add $t4, $t4, $t5
	mtc1 $t4, $f12
	li $t5, 2
	mtc1 $t5, $f0
	div.s $f12, $f12, $f0
	li $v1, -1

#stops function
gobackMedian:
	jr $ra

#gets standard deviation
StandardDeviationInput:
	add $sp, $sp, -4
	sw $ra, 4($sp)
	jal	meanInput
	mov.s $f0, $f12
	li $t0, 0
	mtc1 $t0, $f12
	
#sets up a loop for standard deviation for going through ints
loopStdDev:
	beq $t0, $a1, giveBackStandardDeviation
	
	sll $t1, $t0, 2
	
	add $t1, $t1, $a0
	lw $t6, 0($t1)
	mtc1 $t6, $f1
	cvt.s.w $f1, $f1
	sub.s $f2, $f1, $f0
	mul.s $f3, $f2, $f2
	
	add.s $f12, $f12, $f3
	add $t0, $t0, 1
	j	loopStdDev
	
#gives back the standard deviation
giveBackStandardDeviation:
	sub  $t6, $a1, 1
	mtc1 $t6, $f4
	cvt.s.w $f4, $f4
	div.s $f12, $f12, $f4
	sqrt.s $f12, $f12
	lw $ra, 4($sp)
	add $sp, $sp, 4
	jr $ra
