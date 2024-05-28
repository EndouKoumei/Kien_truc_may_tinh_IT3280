.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014
.data
    prev_key: .byte 0x00
.text
main:
    li $t1, IN_ADDRESS_HEXA_KEYBOARD
    li $t2, OUT_ADDRESS_HEXA_KEYBOARD
    la $t4, prev_key
    li $t3, 0x1
polling:
    sb $t3, 0($t1)
    lb $a0, 0($t2)
    lb $t5, 0($t4)
    beq $a0, $t5, next_row
    beqz $a0, next_row
    sb $a0, 0($t4)
    li $v0, 34
    syscall
    li $a0, 100
    li $v0, 32
    syscall
next_row:
    sll $t3, $t3, 1
    li $t6, 0x10
    beq $t3, $t6, reset_rows
    j polling
reset_rows:
    li $t3, 0x1
    j polling
exit:
    li $v0, 10
    syscall
