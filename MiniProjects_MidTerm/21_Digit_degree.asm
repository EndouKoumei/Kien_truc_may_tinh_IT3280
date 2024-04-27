.data
n: .word 91   # Change the value of n here

    .text
    .globl main

# Function to calculate the sum of digits of a number
sumOfDigits:
    addi $sp, $sp, -12      # Allocate space on the stack
    sw $ra, 8($sp)          # Save return address
    sw $a0, 4($sp)          # Save argument n
    
    li $t0, 0               # Initialize sum to 0
    
    loop:
        beq $a0, $zero, endLoop # If n == 0, end loop
        
        div $a0, $zero, 10    # Divide n by 10
        mfhi $t1              # Get the remainder (last digit)
        add $t0, $t0, $t1    # Add the last digit to sum
        
        div $a0, $a0, 10      # Divide n by 10
        mflo $a0              # Get the quotient (n without last digit)
        j loop                # Repeat the loop
        
    endLoop:
        move $v0, $t0         # Move sum to return value
        
        lw $a0, 4($sp)        # Restore argument n
        lw $ra, 8($sp)        # Restore return address
        addi $sp, $sp, 12     # Restore stack pointer
        jr $ra                # Return

# Function to find the digit degree of a number
digitDegree:
    addi $sp, $sp, -12      # Allocate space on the stack
    sw $ra, 8($sp)          # Save return address
    sw $s0, 4($sp)          # Save $s0
    
    move $s0, $a0           # Load argument n into $s0
    li $t0, 0               # Initialize degree to 0
    
    degreeLoop:
        beq $s0, 0, endDegree # If n == 0, end loop
        
        beq $s0, 10, endDegree # If n is a single digit, end loop
        
        jal sumOfDigits       # Call sumOfDigits to calculate sum of digits
        move $s0, $v0         # Update n with the sum of digits
        addi $t0, $t0, 1      # Increment degree
        
        j degreeLoop          # Repeat the loop
    
    endDegree:
        move $v0, $t0         # Move degree to return value
        
        lw $s0, 4($sp)        # Restore $s0
        lw $ra, 8($sp)        # Restore return address
        addi $sp, $sp, 12     # Restore stack pointer
        jr $ra                # Return

main:
    lw $a0, n               # Load n
    jal digitDegree         # Call digitDegree function
    
    # Print result
    move $a0, $v0
    li $v0, 1
    syscall
    
    # Exit program
    li $v0, 10
    syscall
