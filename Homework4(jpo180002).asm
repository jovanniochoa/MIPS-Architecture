# Homework 4
# Jovanni Ochoa
# December 29, 2019
#
# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 8x8
#         set display dim to 256x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored

# set up some constants
# width of screen in pixels
# 256 / 4 = 32
.eqv WIDTH 64
# height of screen in pixels
.eqv HEIGHT 64
# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF

.data
colors:	.word	MAGENTA, CYAN, YELLOW, WHITE, BLUE, GREEN, RED,
.text
main:
	# set up starting position
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	#subi	$a0, $a0, 7
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	#subi	$a1, $a1, 7
	sra 	$a1, $a1, 1
	addi 	$a2, $0, RED  # a2 = red (ox00RRGGBB)
	li	$v1, 0 # counter for i 
	li	$t7, 0 # register to know where to return back to
	li	$t5, 0 #count for reset of marquee effect
northern: # sets initials, it serves as a do while function in a way
	beq	$t5, 7, reset
	li	$v0, 7
	la	$s7, colors
	lw	$s0, 0($s7)
north:	
	#makes the north part of the squre
	subi	$v0, $v0, 1
	addi	$a0, $a0, 1
	addu	$a2, $0, $s0
	jal	draw_pixel
	addi	$s7, $s7, 4
	lw	$s0, 0($s7)
	bgt	$v0, 0, north
	
	#resets functions
	addi	$t5, $t5, 1
	li	$v0, 7
	la	$s7, colors 
	lw	$s0, 0($s7)

east:
	#makes the right part of the square
	subi	$v0, $v0, 1
	addi	$a1, $a1, 1
	addu	$a2, $0, $s0
	jal	draw_pixel
	addi	$s7, $s7, 4
	lw	$s0, 0($s7)
	bgt	$v0, 0, east
	
	#resets functions
	addi	$t5, $t5, 1
	li 	$v0, 7
	la	$s7, colors
	lw	$s0, 0($s7)
	
south:
	#makes the botton part of the square
	subi	$v0, $v0, 1
	subi	$a0, $a0, 1
	addu	$a2, $0, $s0
	jal	draw_pixel
	addi	$s7, $s7, 4
	lw	$s0, 0($s7)
	bgt	$v0, 0, south
	
	# resets functions
	addi	$t5, $t5, 1
	li 	$v0, 7
	la	$s7, colors
	lw	$s0, 0($s7)
	
west:
	#makes the left sife of the square
	subi	$v0, $v0, 1
	subi	$a1, $a1, 1
	addu	$a2, $0, $s0
	jal	draw_pixel
	addi	$s7, $s7, 4
	lw	$s0, 0($s7)
	bgt	$v0, 0, west
	
	#resets functions
	addi	$t5, $t5, 1
	li 	$v0, 7
	la	$s7, colors
	lw	$s0, 0($s7)
	#serves as a do while loop if It's my 
	#first time drawing the square or not
	beqz	$v1, loop
	beq	$v1, 1, backup
	beq	$v1, 2, backdown
	beq	$v1, 3, backleft
	beq	$v1, 4, backright
	
loop:	
	# draw a pixel 
	jal 	draw_pixel
	
	# check for input
	lw $t0, 0xffff0000  #t0 holds if input available
    	beq $t0, 0, loop   #If no input, keep displaying
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	
	bne	$s1, 32, northern
	# invalid input, ignore
	j	loop
	
	# process valid input
	
	#blacks out upper part
up:	
	li	$t7, 1
	j	blacked #blacks out other function
backup1:
	#redraws top part
	addi	$a1, $a1, -1
	jal	draw_pixel
	li	$v1, 1
	li	$v0, 7
	j	northern
backup:
	j	loop

	#blacks out lower part
down:	
	li	$t7, 2
	j	blacked
backdown1:
	#redraws bottom part
	addi	$a1, $a1, 1
	jal	draw_pixel
	li	$v1, 2
	li	$v0, 7
	j	northern
backdown:
	j	loop
	
	#registers left
left:	
	li	$t7, 3
	j	blacked
backleft1:
	addi	$a0, $a0, -1
	jal	draw_pixel
	li	$v1, 3
	li	$v0, 7
	j	northern
backleft:
	j	loop
	
	#registers right
right:	
	li	$t7, 4
	j	blacked
backright1:
	addi	$a0, $a0, 1
	jal	draw_pixel
	li	$v1, 4
	li	$v0, 7
	j	northern
backright:
	j	loop
	
	#exits program
exit:	li	$v0, 10
	syscall

#################################################
# subroutine to draw a pixel
# $a0 = X
# $a1 = Y
# $a2 = color
draw_pixel:
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	sw	$a2, ($t9)	  # store color at memory location
	jr 	$ra

blacked: #blacks out functions
	li	$v0, 7
	#blacks out northern part
north1:	
	subi	$v0, $v0, 1
	addi	$a0, $a0, 1
	addi	$a2, $0, 0
	jal	draw_pixel
	bgt	$v0, 0, north1
	
	li	$v0, 7
	#blacks out right part
east1:
	subi	$v0, $v0, 1
	addi	$a1, $a1, 1
	addi	$a2, $0, 0
	jal	draw_pixel
	bgt	$v0, 0, east1
	
	li 	$v0, 7
	#blacks out bottom part
south1:
	subi	$v0, $v0, 1
	subi	$a0, $a0, 1
	addi	$a2, $0, 0
	jal	draw_pixel
	bgt	$v0, 0, south1
	
	li 	$v0, 7
	#blacks out left part
west1:
	subi	$v0, $v0, 1
	subi	$a1, $a1, 1
	addi	$a2, $0, 0
	jal	draw_pixel
	bgt	$v0, 0, west1
	
	beq	$t7, 1, backup1
	beq	$t7, 2, backdown1
	beq	$t7, 3, backleft1
	beq	$t7, 4, backright1
	#used as a reset for marquee
reset:
	li	$t5, 0
