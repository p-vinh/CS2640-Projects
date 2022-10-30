# 
#  Name:        Pham, Vinh 
#  Project:     1 
#  Due:         October 6, 2022 
#  Course:      cs-2640-04-f22 
# 
#  Description: 
#               Gives the amount of change you need with the amount given as an input

	.data
change:	.ascii  "Change by V. Pham\n\n"
	.asciiz "Enter the change? "
quarter:	.asciiz "Quarter: "
dime:	.asciiz "Dime: "
nickel:	.asciiz "Nickel: "
penny:	.asciiz "Penny: "


	.text
main:
	la	$a0, change	# display to ask for change
	li	$v0, 4
	syscall

	li	$v0, 5		# read input number
	syscall

	li	$t0, 25		# Loads 25 into $t0
	div	$v0, $t0		
	mflo	$t1		# How much Quarters
	mfhi	$t2		# Total Left
	
	beqz	$t1, endif
	la	$a0, quarter	# Printing out the string "Quarter: "
	li	$v0, 4
	syscall
	move	$a0, $t1		# Printing out the number needed
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall
endif:
	li	$t0, 10		# Loads 10 into $t0
	div	$t2, $t0		
	mflo	$t1		# How much Dime
	mfhi	$t2		# Total Left

	beqz	$t1, endif2
	la	$a0, dime		# Printing out the string "Dime: "
	li	$v0, 4
	syscall
	move	$a0, $t1		# Printing out the number needed
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall
endif2:
	li	$t0, 5		# Loads 5 into $t0
	div	$t2, $t0		
	mflo	$t1		# How much Nickel
	mfhi	$t2		# Total Left

	beqz	$t1, endif3
	la	$a0, nickel	# Printing out the string "Nickel: "
	li	$v0, 4
	syscall
	move	$a0, $t1		# Printing out the number needed
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall
endif3:
	li	$t0, 1		# Loads 1 into $t0
	div	$t2, $t0		
	mflo	$t1		# How much Pennies
	mfhi	$t2		# Total Left

	beqz	$t1, endif4
	la	$a0, penny	# Printing out the string "Penny: "
	li	$v0, 4
	syscall
	move	$a0, $t1		# Printing out the number needed
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall
endif4:
	li	$v0, 10		# exit
	syscall