.eqv SEVENSEG_LEFT 0xFFFF0011    # ??a ch? c?a ?èn LED 7 ?o?n trái.
.eqv SEVENSEG_RIGHT 0xFFFF0010   # ??a ch? c?a ?èn LED 7 ?o?n ph?i.
.data
seven_seg_map: .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F # 0-9
.text
main:
    li $t1, 0            # Bi?n ??m, kh?i t?o t? 0
count_loop:
    move $t2, $t1        # Copy bi?n ??m vào $t2
    div $t2, $t1, 10     # Chia $t1 cho 10
    mfhi $t3             # L?y ph?n d? c?a phép chia (ch? s? hàng ??n v?)
    mflo $t4             # L?y ph?n nguyên c?a phép chia (ch? s? hàng ch?c)
    # Hi?n th? ch? s? hàng ch?c trên LED trái
    la $t0, seven_seg_map
    add $t0, $t0, $t4
    lb $a0, 0($t0)
    jal SHOW_7SEG_LEFT
    # Hi?n th? ch? s? hàng ??n v? trên LED ph?i
    la $t0, seven_seg_map
    add $t0, $t0, $t3
    lb $a0, 0($t0)
    jal SHOW_7SEG_RIGHT
    # Thêm tr? 1 giây
    jal delay_1s
    addi $t1, $t1, 1     # T?ng bi?n ??m
    li $t0, 10
    bne $t1, $t0, count_loop # N?u ch?a ??m ??n 10 thì l?p l?i
    j reset_loop
#---------------------------------------------------------------
# Hàm SHOW_7SEG_LEFT: B?t/t?t ?èn LED 7 ?o?n trái
# param[in] $a0: giá tr? c?n hi?n th?
# remark: $t0 thay ??i
#---------------------------------------------------------------
SHOW_7SEG_LEFT:
    li $t0, SEVENSEG_LEFT
    sb $a0, 0($t0)       
    nop
    jr $ra
    nop
#---------------------------------------------------------------
# Hàm SHOW_7SEG_RIGHT: B?t/t?t ?èn LED 7 ?o?n ph?i
# param[in] $a0: giá tr? c?n hi?n th?
# remark: $t0 thay ??i
#---------------------------------------------------------------
SHOW_7SEG_RIGHT:
    li $t0, SEVENSEG_RIGHT
    sb $a0, 0($t0)         
    nop
    jr $ra
    nop
#---------------------------------------------------------------
# Hàm delay_1s: T?o tr? kho?ng 1 giây b?ng syscall 32
# remark: $a0, $v0 thay ??i
#---------------------------------------------------------------
delay_1s:
    li $v0, 32          # Syscall 32 (sleep)
    li $a0, 1000        # Th?i gian tr? 1 giây (1000 ms)
    syscall
    jr $ra
    nop
reset_loop:
    li $t1, 0
    j count_loop