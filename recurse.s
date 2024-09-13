.data
str: .asciiz "Enter N:"

.text
main:
# save space on stack pointer
    addi $sp $sp, -4
    sw $ra, 0($sp)

    # ask user for input
    la $a0, str
    li $v0, 4
    syscall

    # read input from console
    li $v0, 5
    syscall

    move $a0, $v0 # copy user input into $a0
    jal calc_func

    move $a0, $v0 # copy returned value into $a0
    li $v0, 1
    syscall # print result of calcFunction

    lw $ra, 0($sp) # restore registers
    addi $sp $sp, 4
    jr $ra

calc_func:
    beqz $a0, base_case #branch if n == 0
    move $t0, $a0 # original value of N

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t0, 4($sp)

    addi $t0, $t0, -1 # update n to n-1
    move $a0, $t0
    jal calc_func

    lw $t0, 4($sp) # N's original value

    li $t1, 3 # store constant 3 in $t1
    mul $t2, $t0, $t1 # $t3 = n * 3

    move $t4, $v0 #t4 has returned value of f(n-1)
    add $t4, $t4, $t4 #t4 = 2 * f(n-1)

    sub $t2, $t2, $t4 #3n - 2 * f(n-1)
    addi $t2, $t2, 7 # add 7
    move $v0, $t2

    lw $ra, 0($sp)
    addi $sp, $sp, 8

    jr $ra

base_case:
    li $v0, 2
    jr $ra

