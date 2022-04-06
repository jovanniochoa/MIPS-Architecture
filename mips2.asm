#load store example

.data
var1:         .word   5
var2:         .word   4
var3:         .word   1
ver4:         .word   6
result:       .word   0

.text
main: #example 1
      # load from a to b
      lw   $t1, var1
      lw   $t2, var2
      lw   $t3, var3
      lw   $t4  var4
      lw   $t5, result
      
      sub $t2, $t2, $t1
      sub $t3, $t3, $t1
      add $t5, $t2, $t3 
      sw   $t5, result
      
exit: li   $v0 , 10
      syscall
