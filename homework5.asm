.eqv    NL    10    # \n
	.data  
myFile: .asciiz "/Volumes/My Passport/Mips Directory/hello_art.txt"      # filename for input
buffer: .space 1024
buffers: .space 1024/Volumes/My Passport/Mips Directory/hello_art.txt
fName:   .space 50
	.text

	#input from user
	li   $v0, 8       # take in input
	la   $a0, buffers  # load byte space into address
	li   $a1, 1024      # allot the byte space for string
	move $t0, $a0   # save string to t0
	syscall
	
	#Checks if user pressed <Enter>, then ends program
	lb   $t1, buffers
	beq  $t1, NL, exit

	la   $a0, buffer
	move $a0, $t0         # input file name

	# Open file for reading
	li   $v0, 13          # system call for open file
	la   $a0, buffer
	li   $a1, 0           # flag for reading
	li   $a2, 0           # mode is ignored
	syscall               # open a file 
	move $s0, $v0         # save the file descriptor  

	# reading from file just opened
	li   $v0, 14        # system call for reading from file
	move $a0, $s0       # file descriptor 
	la   $a1, buffer    # address of buffer from which to read
	li   $a2, 1024       # hardcoded buffer length
	syscall             # read from file

	# Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s0       # file descriptor 
	syscall            # close file


	# Printing File Content
	li  $v0, 4          # system Call for PRINT STRING
	la  $a0, buffer     # buffer contains the values
	syscall             # print int

exit:
	li $v0, 10      # Finish the Program
	syscall