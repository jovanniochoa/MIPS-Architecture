#macros

#open file
.macro openFile (%name, %d)
    deleteNewline(%name)
    la $a0,%name
    li $a1,%d
    li $a2,0
    li $v0,13
    syscall
    move $s7,$v0
    bgtz $v0,exit
    printingOne("File Not found.\n")
    leaveProgram
exit:
.end_macro

#read file
.macro readFile (%buffer)
    move $a0,$s7
    la $a1,%buffer
    li $a2,1024
    li $v0,14
    syscall
    move $s6,$v0
.end_macro

#close file
.macro closeFile
    move $a0,$s7
    li $v0,16    
    syscall
.end_macro

#prints number
.macro printInt (%x)
    add $a0,$zero,%x
    li $v0,1
    syscall
.end_macro

#prints number from data
.macro intfromData (%label)
    lw $a0,%label
    li $v0,1
    syscall
.end_macro

#prints character
.macro charOne (%c)
    .data
chr:    
    .byte %c
    .text
    lb $a0,chr
    li $v0,11
    syscall
.end_macro

#prints character from data
.macro charTwo (%char, %count)
    addi $sp,$sp,-4    
    sw $a0,($sp)
    move $t9,%count
loop:    
    beqz $t9,exit
    move $a0,%char
    li $v0,11
    syscall
    addi $t9,$t9,-1
    j loop
exit:    
    lw $a0,($sp)
    addi $sp,$sp,4
.end_macro

#prints strings
.macro printingOne (%str)
    .data
txt:    
    .asciiz %str
    .text
    la $a0,txt
    li $v0,4
    syscall
.end_macro

#output string from data
.macro printingTwo (%label)
    .text
    la $a0,%label
    li $v0,4
    syscall
.end_macro

#output string
.macro printingThree (%r)
    .text
    move $a0,%r
    li $v0,4
    syscall
.end_macro

#gets string from user
.macro getString (%x, %d)
    .text
    la $a0,%x
    li $a1,%d
    li $v0,8
    syscall
.end_macro

#takes off new line
.macro deleteNewline (%s)
    li $s0,10
    la $a0,%s
rep:    
    lb $s2,($a0)
    beqz $s2,out
    beq $s2,$s0,out
    addi $a0,$a0,1
    j rep
out:    
    sb $zero,($a0)
.end_macro

#dynamic memory
.macro dynamicMemory (%mem_address, %space)
    li $a0,%space
    li $v0,9
    syscall
    sw $v0,%mem_address
.end_macro

#ends program
.macro leaveProgram
    li $v0,10
    syscall
.end_macro