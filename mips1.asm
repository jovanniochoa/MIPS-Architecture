#load store example

.data
a:         .word   3
b:         .word   4
c:         .word   9
d:         .word   9

.text
main: #example 1
      # load from a to b
      lw   $t1, a
      lw   $t2, b
      #store to c and d
      sw   $t1, b
      sw   $t2, a
      
exit: li   $v0 , 10
      syscall