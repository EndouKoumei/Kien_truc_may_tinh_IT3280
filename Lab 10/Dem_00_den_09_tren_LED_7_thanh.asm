.eqv SEVENSEG_LEFT 0xFFFF0011    # Dia chi cua den LED 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010   # Dia chi cua den LED 7 doan phai.
.data
seven_seg_map: .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F # 0-9
.text
main:
    li $t1, 0            # Bien dem, khoi tao tu 0
count_loop:
    move $t2, $t1        # Copy bien dem vao $t2
    div $t2, $t1, 10     # Chia $t1 cho 10
    mfhi $t3             # Lay phan du cua phep chia (cho so hang don vi)
    mflo $t4             # Lay phan nguyên cua phep chia (cho so hang chuc)
    # Hien thi chu so hang chuc tren LED trai
    la $t0, seven_seg_map
    add $t0, $t0, $t4
    lb $a0, 0($t0)
    jal SHOW_7SEG_LEFT
    # Hien thi chu so hang don vi tren LED phai
    la $t0, seven_seg_map
    add $t0, $t0, $t3
    lb $a0, 0($t0)
    jal SHOW_7SEG_RIGHT
    # Them tre 1 giây
    jal delay_1s
    addi $t1, $t1, 1     # Tang bien dem
    li $t0, 10
    bne $t1, $t0, count_loop # Neu chua dem den 10 thi lap lai
    j reset_loop
#---------------------------------------------------------------
# Hàm SHOW_7SEG_LEFT: Bat/tat den LED 7 doan trai
# param[in] $a0: gia tri can hien thi
# remark: $t0 thay doi
#---------------------------------------------------------------
SHOW_7SEG_LEFT:
    li $t0, SEVENSEG_LEFT
    sb $a0, 0($t0)       
    nop
    jr $ra
    nop
#---------------------------------------------------------------
# Hàm SHOW_7SEG_RIGHT: Bat/tat den LED 7 doan phai
# param[in] $a0: gia tri can hien thi
# remark: $t0 thay doi
#---------------------------------------------------------------
SHOW_7SEG_RIGHT:
    li $t0, SEVENSEG_RIGHT
    sb $a0, 0($t0)         
    nop
    jr $ra
    nop
#---------------------------------------------------------------
# Hàm delay_1s: Tao tre khoang 1 giay bang syscall 32
# remark: $a0, $v0 thay doi
#---------------------------------------------------------------
delay_1s:
    li $v0, 32          # Syscall 32 (sleep)
    li $a0, 1000        # Thoi gian tre 1 giây (1000 ms)
    syscall
    jr $ra
    nop
reset_loop:
    li $t1, 0
    j count_loop
