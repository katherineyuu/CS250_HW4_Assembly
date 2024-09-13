.data
str: .asciiz "Enter the value of N: "

.text
main:

#save space on stack pointer
addi $sp $sp -4
sw $ra, 0($sp)

#load first tribonacci numbers
li $t0, 1
li $t1, 1
li $t2, 2

#ask user for input
li $v0, 4
la $a0, str
syscall

#read input from console
li $v0, 5
syscall

move $t4, $v0 #user input (N) stored in $t4
jal print_start #jump to printing the first 3 numbers

li $v0, 11
li $a0, 10
syscall

#Start of trib loop code
li $t5, 4 #initalize loop counter to 4
jal tribonacci #jump to tribonacci loop

lw $ra, 0($sp)
addi $sp, $sp, 4
j $ra

tribonacci:
bgt $t5, $t4, exit #exit loop if loop counter > N
add $t6, $t0, $t1 # calc tribonacci number
add $t6, $t6, $t2 
move $a0, $t6
li $v0, 1
syscall #print current trib number

li $v0, 11
li $a0, 10 # print new line
syscall

move $t0, $t1 #move new tribonacci numbers
move $t1, $t2
move $t2, $t6
addi $t5, $t5, 1 #increment loop counter

j tribonacci

exit:
j $ra

print_start:
bgt $t4, 0, print_first #branch if N > 1
jr $ra #return if N < 1

print_first:
li $v0, 1
li $a0, 1 #load 1 into $a0
syscall

li $v0, 11
li $a0, 10
syscall

bge $t4, 2, print_second
jr $ra #return if N < 2

print_second:
li $v0, 1
li $a0, 1 #load 1 into $a0
syscall

li $v0, 11
li $a0, 10
syscall

bge $t4, 3, print_third
jr $ra #return if n < 3

print_third:
li $v0, 1
li $a0, 2
syscall

jr $ra #return after printing third





