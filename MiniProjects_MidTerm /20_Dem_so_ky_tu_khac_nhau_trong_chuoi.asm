.data
input_string:   .space 100      # Reserve space for input string
unique_chars:   .space 26       # One byte for each lowercase letter (a-z)
unique_count:   .word 0
prompt_string:  .asciiz "Enter a string: "
error_message:  .asciiz "Error: Invalid input string. Please enter only lowercase letters.\n"
.text
main:
    # Prompt the user to enter a string
    li $v0, 4
    la $a0, prompt_string
    syscall
    # Read the input string from the keyboard
    li $v0, 8
    la $a0, input_string
    li $a1, 100
    syscall
    # Initialize the loop counter to 0
    li $t0, 0
loop:
    # Load the current character from the input string
    lb $t1, input_string($t0)
    # Check if the character is null (end of string)
    beqz $t1, done
    # Check if the character is a lowercase letter (a-z)
    li $t2, 'a'         # Load ASCII value of 'a'
    li $t3, 'z'         # Load ASCII value of 'z'
    blt $t1, $t2, next_char   # If character is less than 'a', skip it
    bgt $t1, $t3, next_char   # If character is greater than 'z', skip it
    # Calculate the index in the unique_chars array
    sub $t2, $t1, 'a'
    # Check if the character has been seen before
    lb $t3, unique_chars($t2)
    beqz $t3, add_unique
    # Character already seen, skip adding to unique_chars
    j next_char
add_unique:
    # Mark the character as seen
    sb $t1, unique_chars($t2)
    # Increment the unique count
    lw $t4, unique_count
    addi $t4, $t4, 1
    sw $t4, unique_count
next_char:
    # Move to the next character in the input string
    addi $t0, $t0, 1
    j loop
done:
    # Load the unique count from memory
    lw $t5, unique_count
    # Print the result
    li $v0, 1
    move $a0, $t5
    syscall
    # Exit
    li $v0, 10
    syscall
