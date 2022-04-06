# RLE Compression/Decompresseion

.include    "macros.asm"
.eqv    NINE    9    #9
.eqv    UPPER    57    # ASCII 9
.eqv    LOWER    48    # ASCII 0
.eqv    NL    10    #\n

             .data
buffer:      .space 1024
userInput:   .space 50
size:        .word 0
heap:        .word 0
sizing:      .word 0
             .text
main:
    #into heap
    dynamicMemory(heap, 1024)
    
    #prompts the user for file
    printingOne("Enter file name to compress or <Enter> to exit: ")
    getString(userInput,50)
    charOne(NL)
    
    #checks for enter
    lb $t0,userInput
    beq $t0,NL,end
    
    #opens file and reads to buffer
    openFile(userInput,0)
    readFile(buffer)
    sw $s6,size 
    
    #add to buffer
    la $t0,buffer
    add $s6,$s6,$t0
    sb $zero,($s6)
    
    #closes file
    closeFile
    
    #prints original data
    printingOne("Original data:\n")
    printingTwo(buffer)
    charOne(NL)
    
    #prints compressed data
    printingOne("Compressed data:\n")
    la $a0,buffer
    lw $a1,size
    lw $a2,heap
    jal compRLE
    
    #prints heap
    lw $t0,heap
    printingThree($t0)
    charOne(NL)
    
    #prints uncompressed data
    printingOne("Uncompressed data:\n")
    
    #decompresses
    lw $a0,heap
    lw $a1,size
    jal decompile
    
    #prints sizes and loops back
    charOne(NL)
    printingOne("Original file size: ")
    intfromData(size)
    charOne(NL)
    printingOne("Compressed file size: ")
    intfromData(sizing)
    charOne(NL) 
    j main

#jumps back
goback:    
    jr $ra

#change size and put i to 0
compRLE:
    addi $s0,$a1,-1
    li $t0,0
    li $s7,0
    
#check if i < n. add to count
for:    
    bge $t0,$a1,compressBack
    li $t1,1
    
#used to check similarities between string[i] and string[i+1]
while:    
    add $t2,$a0,$t0
    lb $s1,($t2)        	# string[i]
    addi $t3,$t0,1
    add $t3,$a0,$t3
    
    lb $s2,($t3)        	# string[i+1]
    bge $t0,$s0,save    	# i < size - 1
    bne $s1,$s2,save    	# string[i] == string[i+1]
    addi $t1,$t1,1
    addi $t0,$t0,1
    j while
    
getDigits:    
    li $t8,10
    
    div $t1,$t8
    mflo $t4
    
    addi $t4,$t4,48        	#first digit in ACSCII
    
    sb $t4,($a2)        	#stores ^
    addi $a2,$a2,1        	#into heap
    addi $s7,$s7,1        	#compresses size
    mfhi $t5        		#gets next digit
    addi $t5,$t5,48
    sb $t5,($a2)

    addi $t0,$t0,1        	# i++
    addi $a2,$a2,1        	# Next heap location
    
    j for
    
#stores the next string into array
save:    
    sb $s1,($a2)        	# Store string[i]
    addi $a2,$a2,1        	# Next heap location
    addi $s7,$s7,1
    bgt $t1,NINE,getDigits   	# Two digit count
    addi $t1,$t1,48
    sb $t1,($a2)     		#gets count
    
    addi $t0,$t0,1     		# i++
    addi $s7,$s7,1
    addi $a2,$a2,1
    j for
    
#saves compression
compressBack:    
    sw $s7,sizing        	#saves compression
    jr $ra    
    
#decompiles
decompile:
    li $s0,10			#loads 10
    
loadingCharacters:    
    lb $t0,($a0)        	#load characters
    lb $t1,1($a0)
    lb $t2,2($a0)
    
    beqz $a1,goback        	#checks if size is 0
    
    blt $t2,LOWER,chars    	#checks if count is multiple digits
    
    ble $t2,UPPER,chars2
    
#prints the next character and changes size
chars:    
    addi $t1,$t1,-48
    charTwo($t0,$t1)    	#prints next char
    sub $a1,$a1,$t1        	#decreases size
    addi $a0,$a0,2        	#gets next char
    j loadingCharacters

#claculates intigers and prints out char sequence
chars2:  
    addi $t2,$t2,-48  
    addi $t1,$t1,-48     
    mul $t1,$t1,$s0
    add $t1,$t1,$t2        	#gets int
    charTwo($t0,$t1)   		#outputs char
    sub $a1,$a1,$t1
    addi $a0,$a0,3        	#points to next char
    j loadingCharacters
    
#ends program
end:    
    leaveProgram