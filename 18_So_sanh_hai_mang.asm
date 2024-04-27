.data
result_similar: .asciiz "The arrays are similar."
result_not_similar: .asciiz "The arrays are not similar."
prompt_size: .asciiz "Enter the size of arrays: "
prompt_a: .asciiz "Input the array a: "
prompt_b: .asciiz "Input the array b: "
array_a: .word 0:100
array_b: .word 0:100
.text
main:
#Print the arrays' size message
	li $v0, 4
	la $a0, prompt_size
	syscall
#Read the number of elements
	li $v0, 5
	syscall
	move $s0, $v0 		#s0 = n
	la $t0, array_a		#Store address of a to t0
	la $t1, array_b 	#Store address of b to t1
	add $t3, $0, $0 	#i = t3 = 0
Input_a:
	li $v0, 4		#Print message prompt_a
	la $a0, prompt_a
	syscall
	li $v0, 5		#Read the elements of array a
	syscall
	sw $v0, ($t0)		#Store to address of array a
	addi $t0, $t0, 4	#Point to next address to store next elements	
	addi $t3, $t3, 1	#Move to next elements
	blt $t3, $s0, Input_a	#If i < n then loop, continue to input array a
Reset_a:
	add $t3, $0, $0		#Reset i to 0	
	la $t0, array_a		#Reset t0 point to the address of array a
Input_b: 
	li $v0, 4		#Print message prompt_b
	la $a0, prompt_b
	syscall
	li $v0, 5		#Read the elements of array b
	syscall
	sw $v0, ($t1)		#Store the address of array b 
	addi $t1, $t1, 4	#Point to the next address to store the next elements
	addi $t3, $t3, 1	#Move to next elements
	blt $t3, $s0, Input_b	#If i < n then loop, continue to input array b
Reset_b:
	add $t3, $0, $0		#Reset i to 0
	la $t1, array_b		#Reser t1 point to the address of array b
#Check if a and b are similar or not
areSimilar:
	add $s1, $0, $0 	#s1 = diffCount = 0
	addi $s2, $0, -1	#s2 = firstDiff = -1
	addi $s3, $0, -1	#s3 = secondDiff = -1
	addi $t4, $0, -1	#t4 = const = -1
	addi $t5, $0, 2		#t5 = const = 2
loop:
	lw $s4, ($t0)	#s4 = a[i]
	lw $s5, ($t1)	#s5 = b[i]
	bne $s4, $s5, handle
move_up:
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	addi $t3, $t3, 1	#i++
	blt $t3, $s0, loop
	j quit_loop

handle: 
	addi $s1, $s1, 1	#diffCount++
	bne $t4, $s2, else	#firstDiff != -1 then else
	add $s2, $t3, $0 	#firstDiff = i
	j move_up
else:
	add $s3, $t3, $0	#secondDiff = i
	j move_up
quit_loop:
	add $t3, $0, $0		#Reset i = 0
	la $t0, array_a		#Reser t0 point to the 1st element of array a
	la $t1, array_b		#Reset t1 point to the 1st element of array b
check:
	beq $s1, $0, result_true
	bne $s1, $t5, result_false
	sll $s2, $s2, 2		#firstDiff = firstDiff * 4
	sll $s3, $s3, 2		#secondDiff = secondDiff * 4
	add $t6, $t0, $s2	#address of a[firstDiff]
	add $s6, $t0, $s3	#address of a[secondDiff]
	add $t7, $t1, $s2	#address of b[firstDiff]
	add $s7, $t1, $s3	#address of b[secondDiff]
	lw $t6, ($t6)		#t6 = a[firstDiff]
	lw $s6, ($s6)		#s6 = a[secondDiff]
	lw $t7, ($t7)		#t7 = b[firstDiff]
	lw $s7, ($s7)		#s7 = b[secondDiff]
	bne $t6, $s7, result_false
	bne $s6, $t7, result_false
	j result_true
result_true:
	li $v0, 4
	la $a0, result_similar
	syscall
	j end
result_false:
	li $v0, 4
	la $a0, result_not_similar
	syscall
end: 
	li $v0, 10
	syscall