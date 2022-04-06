	.data
inputfile: .asciiz "/Users/jovanniochoa/Desktop/input.txt"
before:	.asciiz "Before: "
after:	.asciiz	"After: "
mean:	.asciiz	"Mean: "
median:	.asciiz	"Median: "
staDev:	.asciiz "Standard Deviation: "
badFile: .asciiz "There is an error reading file, exiting now!"
buffer:	.space	80
array:	.word	20
	.text
	
main:
	la $a0, inputfile
	la $a1, buffer
	jal readFile
	beq $v0, $0, bad

	la $a0, array
	li $a1, 20
	la $a2, buffer
	jal extractInts
	move $t7, $v0

	li $v0, 4
	la $a0, before
	syscall

	la $a0, array
	move $a1, $t7
	jal print

	la $a0, array
	move $a1, $t7
	jal selectionSort

	li $v0, 4
	la $a0, after
	syscall

	la $a0, array
	move $a1, $t7
	jal	print

	la $a0, mean
	li $v0, 4
	syscall
	la $a0, array
	move $a1, $t7
	jal	calMean
	li $v0, 2
	syscall
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
	la $a0, median
	li $v0, 4
	syscall

	la $a0, array
	move $a1, $t7
	jal	calMedian
	bltz $v1, printFloat

	move $a0, $v0
	li $v0, 1
	syscall
	j	stdDev

	printFloat:
	li $v0, 2
	syscall

stdDev:
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
	li $v0, 4
	la $a0, staDev
	syscall
	la $a0, array
	move $a1, $t7
	jal	calStdDev
	li $v0, 2
	syscall
exit:
	li $v0, 10
	syscall
	
bad:	
#prints out error message and exits the program
	li $v0, 4
	la $a0, badFile
	syscall
	
	li $v0, 10
	syscall
#########################
readFile:
	move $t1, $a1
	li $v0, 13
	li $a1, 0
	syscall

	blt $v0, $0 returnReadFile
	move $s0, $v0

	li $v0, 14
	move $a0, $s0
	move $a1, $t1
	li $a2, 80
	syscall

	li $v0, 16
	move $a0, $s0
	syscall
	move $v0, $s0
	returnReadFile:
	jr $ra

######################

extractInts:
	li $s1, -1
	li $t0, 0
loop1:	
	lb $t1, ($a2)
	beq $t1, 10, storeintoarray
	beq $t1, $zero, returnextractInts
	blt $t1, 48, ignoreNnext
	bgt $t1, 57, ignoreNnext
	addi $t1, $t1, -48
	bne $s1, -1, multiply10
	li $s1, 0
multiply10:
	li $t3, 10
	mul $s1, $s1, $t3
	add $s1, $s1, $t1
ignoreNnext:	
	add $a2, $a2, 1
	j	loop1
storeintoarray:
	beq $s1, -1, skipStoring
	sll $t2, $t0, 2
	add $t2, $t2, $a0
	sw $s1, 0($t2)
	li $s1, -1
	
skipStoring:	
	addiu $t0, $t0, 1
	add $a2, $a2, 1
	beq $t0, 20, returnextractInts
	j	loop1
returnextractInts:
	move $v0, $t0
	jr	$ra
###################################

print:
	move $s0, $a0
	li $t0, 0
	loop2:
	beq $t0, $a1, returnPrint
	li $v0, 1
	sll $t1, $t0, 2
	add $t1, $t1, $s0
	lw $a0, 0($t1)
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $t0, $t0, 1
	j	loop2
returnPrint:
	addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
	jr	$ra

############################
selectionSort:
	li $t0, 0
	sub $s0, $a1, 1
outerloop:
	beq $t0, $s0, returnSSort
	move $s1, $t0
	add $t1, $t0, 1
innerloop:
	beq $t1, $a1, check4swap
	sll $t2, $t1, 2
	sll $t3 $s1, 2
	add $t2, $t2, $a0
	add $t3, $t3, $a0
	lw $t4, 0($t2)
	lw $t5, 0($t3)
	blt $t4, $t5, updateI
	j nextinner

updateI:
	move $s1, $t1
nextinner:
	add $t1, $t1, 1
	j innerloop
check4swap:
	bne $s1, $t0, swap
	j	nextouter

swap:
	sll $t2, $t0, 2
	sll $t3, $s1, 2
	add $t2, $t2, $a0
	add $t3, $t3, $a0
	lw $t4, 0($t2)
	lw $t5, 0($t3)
	sw $t4, 0($t3)
	sw $t5, 0($t2)
nextouter:
	add $t0, $t0, 1
	j	outerloop
returnSSort:
	jr	$ra
###############
calMean:
	li $t0, 0
	mtc1 $t0, $f12
	mtc1 $t0, $f0

calMeanloop:
	beq $t0, $a1, returnCalMean
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	lwc1 $f0, 0($t1)
	add.s $f12, $f12, $f0
	add $t0, $t0, 1
	j	calMeanloop
returnCalMean:
	mtc1 $a1, $f0
	div.s $f12, $f12, $f0
	jr	$ra
###############
calMedian:
	div $t0, $a1, 2
	mfhi $t1
	beqz $t1, calaverage

	sll $t2, $t0, 2
	add $t2, $t2, $a0
	lw $v0, 0($t2)

	li $v1, 0
	j	returnCalMedian

calaverage:
	sub $t1, $t0, 1
	sll $t2, $t0, 2
	sll $t3, $t1, 2
	add $t2, $t2, $a0
	add $t3, $t3, $a0
	lw $t4, 0 ($t2)
	lw $t5, 0($t3)
	add $t4, $t4, $t5
	mtc1 $t4, $f12
	li $t5, 2
	mtc1 $t5, $f0
	div.s $f12, $f12, $f0
	li $v1, -1

returnCalMedian:
	jr $ra
########################
calStdDev:
	add $sp, $sp, -4
	sw $ra, 4($sp)
	jal	calMean
	mov.s $f0, $f12
	li $t0, 0
	mtc1 $t0, $f12
loopStdDev:
	beq $t0, $a1, returnStdDev
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	lw $t2, 0($t1)
	mtc1 $t2, $f1
	cvt.s.w $f1, $f1
	sub.s $f2, $f1, $f0
	mul.s $f3, $f2, $f2
	add.s $f12, $f12, $f3
	add $t0, $t0, 1
	j	loopStdDev
returnStdDev:
	sub  $t2, $a1, 1
	mtc1 $t2, $f4
	cvt.s.w $f4, $f4
	div.s $f12, $f12, $f4
	sqrt.s $f12, $f12
	lw $ra, 4($sp)
	add $sp, $sp, 4
	jr $ra
