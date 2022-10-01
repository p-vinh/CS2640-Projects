# 
#  Name:        Pham, Vinh 
#  Project:     1 
#  Due:         October 5, 2022 
#  Course:      cs-2640-04-f22 
# 
#  Description: 
#               Gives the amount of change you need with the amount given 

        .data
change: .ascii  "Change by V. Pham\n\n"
        .asciiz "Enter the change? "
quarter:.asciiz "Quarter: "
dime:   .asciiz "Dime: "
nickel: .asciiz "Nickel: "
penny:  .asciiz "Penny: "
newline:.asciiz "\n"

        .text
main:   
        la      $a0, change             # display to ask for change
        li      $v0, 4
        syscall

        li      $v0, 5                  # read input number
        syscall
        move    $a0, $v0                # Moves input number into $a0
        
        li      $t0, 25                 # Loads 25 into $t0
        div	$a0, $t0                # $a0 / $t0
        mflo	$t1		        # $t1 = floor($a0 / $t0) How much Quarters
        mfhi	$t2		        # $t2 = $a0 mod $t0 Total Left
        
        beqz    $t1, endif
        la      $a0, quarter            # Printing out the string "Quarter: "
        li      $v0, 4
        syscall
        move    $a0, $t1                # Printing out the number needed
        li      $v0, 1
        syscall
        li      $a0, '\n'
        li      $v0, 11
        syscall
endif:
        
        li      $t0, 10                 # Loads immediate 10 into $t0
        div     $t2, $t0                # $t2 / $t0
        mflo	$t1			# $t1 = floor($t2 / $t0) How much Dime
        mfhi	$t2                     # $t2 = $t2 mod $t0 Total Left

        beqz    $t1, endif2
        la      $a0, dime               # Printing out the string "Dime: "
        li      $v0, 4
        syscall
        move    $a0, $t1                # Printing out the number needed
        li      $v0, 1
        syscall
        li      $a0, '\n'
        li      $v0, 11
        syscall
endif2:

        li      $t0, 5                  # Loads immediate 5 into $t0
        div     $t2, $t0                # $t2 / $t0
        mflo	$t1			# $t1 = floor($t2 / $t0) How much Nickel
        mfhi	$t2                     # $t2 = $t2 mod $t0 Total Left

        beqz    $t1, endif3
        la      $a0, nickel             # Printing out the string "Nickel: "
        li      $v0, 4
        syscall
        move    $a0, $t1                # Printing out the number needed
        li      $v0, 1
        syscall
        li      $a0, '\n'
        li      $v0, 11
        syscall
endif3:

        li      $t0, 1                  # Loads immediate 1 into $t0
        div     $t2, $t0                # $t2 / $t0
        mflo	$t1			# $t1 = floor($t2 / $t0) How much Penny
        mfhi	$t2                     # $t2 = $t2 mod $t0 Total Left

        beqz    $t1, endif4
        la      $a0, penny              # Printing out the string "Penny: "
        li      $v0, 4
        syscall
        move    $a0, $t1                # Printing out the number needed
        li      $v0, 1
        syscall
        li      $a0, '\n'
        li      $v0, 11
        syscall
endif4:
        li      $v0, 10                 # exit
        syscall