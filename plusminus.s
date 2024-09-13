.data
    newline: .asciiz "\n"
    space: .asciiz " "
    player: .asciiz "Please input player last name:"
    teamscore: .asciiz "Please input team score:"
    oppscore: .asciiz "Please input opponent score:"
    donetext: .asciiz "DONE"

.text
main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 0 #t1 holds current node
    li $t1, 0 #t2 holds next permahead node

main_loop:
    la, $a0, player
    li $v0, 4
    syscall

    li $a0, 64
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal allocate_mem
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8


    move $a0, $v0
    li $a1, 12
    li $v0, 8
    syscall

    move $s0, $a0 #s0 holds addr of name string
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal remove_newline
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8

    move $a0, $s0
    la $a1, donetext
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal strcmp
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    beqz $v0, main_exit

    la $a0, teamscore
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s1, $v0 #s1 holds the team score

    la $a0, oppscore
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s2, $v0 #s2 holds the opp score

    sub $s3, $s1, $s2

    li $a0, 12
    jal allocate_mem

    move $t2, $v0
    sw $s0, 0($t2)
    sw $s3, 4($t2)
    sw $zero, 8($t2)

    beqz $t1, create_head_node
    b create_node

create_head_node:
    move $t1, $t2
    move $t0, $t2

    j main_loop

create_node:
    sw $t2, 8($t0)
    move $t0, $t2

    j main_loop

main_exit:
    move $a0, $t1
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal bubblesort_start
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    move $a0, $v0
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal print_linked_list_start
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

strcmp:
    li $v0, 0
    lb $t0, 0($a0)
    lb $t1, 0($a1)

    beqz $t0, strcmp_exit
    beqz $t1, strcmp_exit

    sub $v0, $t0, $t1
    bnez $v0, strcmp_exit

    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j strcmp
strcmp_exit:
    jr $ra

remove_newline:
    lb $t0, 0($a0)
    li $t1, 0x00a

    beqz $t0, remove_newline_done

    beq  $t0, $t1, remove

    addi $a0, $a0, 1
    j remove_newline
remove:
    sb $zero, 0($a0)
remove_newline_done:
    jr $ra

allocate_mem:
    li $v0, 9
    syscall
    jr $ra

print_linked_list_start:
    move $t0, $a0

print_linked_list:
    beqz $t0, print_linked_list_exit

    lw $a0, 0($t0)
    li $v0, 4
    syscall

    la $a0, space
    li $v0, 4
    syscall

    lw $a0, 4($t0)
    li $v0, 1
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    lw $t0, 8($t0)

    j print_linked_list

print_linked_list_exit:
    jr $ra

bubblesort_start:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $t0, 1 #sorted bool

    move $t1, $a0 #previous node
    move $t2, $a0 #current node
    lw $t3, 8($t2) #next node
    move $t4, $a0 #permanent head node

bubblesort_outer_loop:
    beqz $t0, bubblesort_exit
    li $t0, 0

    move $t1, $t4
    move $t2, $t4
    lw $t3, 8($t2)

bubblesort_inner_loop:
    beqz $t3, bubblesort_outer_loop

    lw $s0, 4($t2) #pm val of current player
    lw $s1, 4($t3) #pm val of next player

    bgt $s1, $s0, bubblesort_switch

    beq $s0, $s1, bubblesort_alphabetic

    move $t1, $t2
    move $t2, $t3
    lw $t3, 8($t2)

    j bubblesort_inner_loop

bubblesort_alphabetic:
    lw $a0, 0($t2) #name of current player
    lw $a1, 0($t3) #name val of next player
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal strcmp
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    bgtz $v0, bubblesort_switch

    move $t1, $t2
    move $t2, $t3
    lw $t3, 8($t2)

    j bubblesort_inner_loop

bubblesort_switch:
    li $t0, 1
    beq $t1, $t2, bubblesort_switch_first
    move $a0, $t1
    move $a1, $t2
    move $a2, $t3
    jal switch_nodes
    move $t1, $v0
    move $t2, $v1
    lw $t3, 8($t2)
    j bubblesort_inner_loop

bubblesort_switch_first:
    move $t4, $t3
    move $a0, $t1
    move $a1, $t2
    move $a2, $t3
    jal switch_nodes
    move $t1, $v0
    move $t2, $v1
    lw $t3, 8($t2)
    j bubblesort_inner_loop

bubblesort_exit:
    move $v0, $t4
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

switch_nodes:
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    lw $s3, 8($s2)
    
    beq $s0, $s1, switch_first_node

    sw $s3, 8($s1)
    sw $s1, 8($s2)
    sw $s2, 8($s0)

    move $v0, $s2
    move $v1, $s1

    j switch_nodes_exit
    
switch_first_node:
    sw $s3, 8($s1)
    sw $s1, 8($s2)

    move $v0, $s2
    move $v1, $s1

    j switch_nodes_exit
    
switch_nodes_exit:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16
    jr $ra
