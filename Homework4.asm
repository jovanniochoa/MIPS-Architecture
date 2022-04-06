#Homework 4
#CS 2340
#Ismail Ahmed

# width of screen in pixels
# 256 / 4 = 64
.eqv 		WIDTH 		64
# 256 / 4 = 64
# height of screen in pixels
.eqv 		HEIGHT		64

# colors
.eqv		RED 		0x00FF0000
.eqv		GREEN 		0x0000FF00
.eqv		BLUE		0x000000FF
.eqv		WHITE		0x00FFFFFF
.eqv		YELLOW		0x00FFFF00
.eqv		CYAN		0x0000FFFF
.eqv		MAGENTA		0x00FF00FF

.data
colors:		.word		MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED

.text
main:
	# set up starting position
	addi 	$a0, $0, WIDTH    	# a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   	# a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	addi 	$a2, $0, RED  		# a2 = red (ox00RRGGBB)
	la	$s0, colors
	li	$t1, 0 			# pixel limit length
	
mainLoop:
# check for input
	lw $t0, 0xffff0000  #t1 holds if input available
    	beq $t0, 0, loop1   #If no input, keep displaying
    	
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	# invalid input, ignore
	j	mainLoop
	
	# process valid input
	
up:	
	li	$s7, -1		# to know to save $ra
	addi	$a1, $a1, -1
	#move	$v0, $ra
	jal	loop1
	#addi 	$a2, $0, RED
	li	$s7, 0
	#li	$a2, 0		# black out the pixel
	#j	loop1
	j	mainLoop

down:	li	$a2, 0		# black out the pixel
	jal	loop1
	addi	$a1, $a1, 1
	addi 	$a2, $0, RED
	j	loop1
	
left:	li	$a2, 0		# black out the pixel
	jal	loop1
	addi	$a0, $a0, -1
	addi 	$a2, $0, RED
	j	loop1
	
right:	#li	$a2, 0		# black out the pixel
	#jal	loop1
	addi	$a0, $a0, 1
	#addi 	$a2, $0, RED
	j	loop1
		
exit:	li	$v0, 10
	syscall

loop1:
	#addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	
	#move $s7, $ra			# save ra if case where needed to jal here
	# s1 = address = $gp + 4*(x + y*width), address where color should go
	mul	$t9, $a1, WIDTH   	# y * WIDTH
	add	$t9, $t9, $a0	  	# add X
	mul	$t9, $t9, 4	  	# multiply by 4 to get word offset
	add	$t9, $t9, $gp	  	# add to base address
	
	beq	$a2, 0, eraseLoop1
	
	# address of color array
	sll 	$t3, $t2, 2		# word
	add 	$t3, $t3, $s0		# address of byte for a word
	lw 	$a2, ($t3)		# color element into register
	
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi 	$t1, $t1, 1 		# increment pixel counter
	#addi	$t7, $t7, 1		# increment pixel index
	addi	$a0, $a0, 1 		# increment x coord
	addi 	$t2, $t2, 1 		# increment address index
	
	jal pause			# pause between pixel writes
	
	bne 	$t2, 6, reLoop1		# if index not less than value after last element, go to label

	# reset index to starting pos if it is out of bounds
	li	$t6, 0
	move	$t2, $t6		# reset index to 0 starting pos
	
	j loop1				# restart loop to get final element w 0th color element
	
eraseLoop1:
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi 	$t1, $t1, 1 		# increment pixel counter
	addi	$a1, $a1, 1 		# increment x coord
			
reLoop1:
	blt 	$t1, 7, loop1		# only 7 pixels 
	
li	$t1, 0 # pixel limit length
loop2:
	# s1 = address = $gp + 4*(x + y*width), address where color should go
	mul	$t9, $a1, WIDTH   	# y * WIDTH
	add	$t9, $t9, $a0	  	# add X
	mul	$t9, $t9, 4	  	# multiply by 4 to get word offset
	add	$t9, $t9, $gp	  	# add to base address
	
	beq	$a2, 0, eraseLoop2
	
	# address of color array
	sll 	$t3, $t2, 2		# word
	add 	$t3, $t3, $s0		# address of byte for a word
	lw 	$a2, ($t3)		# integer to print
	
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi	$a1, $a1, 1		# increment y coord
	addi 	$t1, $t1, 1		# increment pixel counter
	addi 	$t2, $t2, 1		# increment address index
	
	jal pause			# pause between pixel writes

	bne 	$t2, 6, reLoop2		# if index not less than value after last element, go to label

	# reset index to starting pos if it is out of bounds
	li	$t6, 0
	move	$t2, $t6		# reset index to 0 starting pos
	
	j loop2				# restart loop to get final element w 0th color element
	
eraseLoop2:
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi 	$t1, $t1, 1 		# increment pixel counter
	addi	$a1, $a1, 1 		# increment y coord	
	
reLoop2:
	blt 	$t1, 7, loop2		# only 7 pixels 
	
li	$t1, 0 # pixel limit length
loop3:
	# s1 = address = $gp + 4*(x + y*width), address where color should go
	mul	$t9, $a1, WIDTH   	# y * WIDTH
	add	$t9, $t9, $a0	  	# add X
	mul	$t9, $t9, 4	  	# multiply by 4 to get word offset
	add	$t9, $t9, $gp	  	# add to base address
	
	beq	$a2, 0, eraseLoop3
	
	# address of color array
	sll 	$t3, $t2, 2		# word
	add 	$t3, $t3, $s0		# address of byte for a word
	lw 	$a2, ($t3)		# integer to print
	
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi	$a0, $a0, -1		# increment x coord
	addi 	$t1, $t1, 1		# increment pixel counter
	addi 	$t2, $t2, 1		# increment address index
	
	jal pause			# pause between pixel writes

	bne 	$t2, 6, reLoop3		# if index not less than value after last element, go to label	

	# reset index to starting pos if it is out of bounds
	li	$t6, 0
	move	$t2, $t6		# reset index to 0 starting pos
	
	j loop3				# restart loop to get final element w 0th color element

eraseLoop3:
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi 	$t1, $t1, 1 		# increment pixel counter
	addi	$a0, $a0, -1 		# increment x coord

reLoop3:
	blt 	$t1, 7, loop3		# only 7 pixels 
	
li	$t1, 0 # pixel limit length
loop4:
	# s1 = address = $gp + 4*(x + y*width), address where color should go
	mul	$t9, $a1, WIDTH   	# y * WIDTH
	add	$t9, $t9, $a0	  	# add X
	mul	$t9, $t9, 4	  	# multiply by 4 to get word offset
	add	$t9, $t9, $gp	  	# add to base address
	
	beq	$a2, 0, eraseLoop4
	
	# address of color array
	sll 	$t3, $t2, 2		# word
	add 	$t3, $t3, $s0		# address of byte for a word
	lw 	$a2, ($t3)		# integer to print
	
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi	$a1, $a1, -1		# increment y coord
	addi 	$t1, $t1, 1		# increment pixel counter
	addi 	$t2, $t2, 1		# increment address index
	
	jal pause			# pause between pixel writes

	bne 	$t2, 6, reLoop4		# if index not less than value after last element, go to label

	# reset index to starting pos if it is out of bounds
	li	$t6, 0
	move	$t2, $t6		# reset index to 0 starting pos
	
	j loop4				# restart loop to get final element w 0th color element
	
eraseLoop4:
	sw	$a2, ($t9)	  	# store color at memory location
	
	# incrementations
	addi 	$t1, $t1, 1 		# increment pixel counter
	addi	$a1, $a1, -1 		# increment y coord	
	
reLoop4:
	blt 	$t1, 7, loop4		# only 7 pixels
	
	beq 	$s7, -1, newRa		# check if stack needs to be accessed
	
	li	$t1, 0 			# pixel limit length reset

	j mainLoop			# jump to mainLoop to refresh box
	
pause:
	# save to stack
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$a0, 4($sp)
	
	# pause
	li 	$v0, 32			# system call for sleep
	li 	$a0, 5			# length of time to sleep in milliseconds
	syscall				# sleep
	
	# restore from stack
	lw	$ra, ($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
	
	jr	$ra			# go back to calling function after calling line
	
newRa:
	# restore from stack
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
