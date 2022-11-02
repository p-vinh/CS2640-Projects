# 
#  Name:	Pham, Vinh 
#  Project:	3 
#  Due:		November 3, 2022 
#  Course:	cs-2640-04-f22
# 
#  Description: 
#	This program asks for an input up to 40 characters. Then duplicates the input to allocate it to memory with the given size.
#	The strdup will return an address and stores the address into an array.
#	The output will print out all the inputs from the user through the addresses in memory stored in the array
#

	.data
MAXLINES = 8
LINELEN = 40
inbuf:	.space	LINELEN + 2			# up to LINELEN byte
title:	.asciiz	"Lines by V. Pham\n"
prompt:	.asciiz "\nEnter text? "
lines:	.word	0:MAXLINES

	.text
main:

	la	$a0, title			# print out title
	li	$v0, 4
	syscall


	li	$t0, 0				# index
	la	$t3, lines			# base address

dowhile:
	la	$a0, prompt			# prompt the user
	li	$v0, 4
	syscall

	la	$a0, inbuf
	li	$a1, LINELEN
	li	$v0, 8
	syscall



	la	$t1, inbuf
	lb	$t2, ($t1)

	beq	$t2, '\n', enddowhile		# break if t2 contains a '\n' check if user put 'enter'

	jal	strdup				# strdup(inbuf)

	sll	$t4, $t0, 2
	addu	$t3, $t3, $t4			# lines[t3] - effective address

	sw	$v0, ($t3)			# saving address of C-String to lines
	
	addi	$t0, $t0, 1			# t0 ++
	blt	$t0, 8, dowhile 
enddowhile:

	li	$a0, '\n'
	li	$v0, 11
	syscall

						# output all the lines here
	la	$t1, lines
	li	$t2, 0				# index
for:
	bge	$t2, 8, endfor
	sll	$t4, $t2, 2
	addu	$t1, $t1, $t4

	li	$a0, '\n'
	li	$v0, 11
	syscall
	lw	$a0, ($t1)			# a0 = address of c string
	beqz	$a0, endfor 			# break when array does not have address
	li	$v0, 4
	syscall

	addi	$t2, $t2, 1			# increment index
	b	for
endfor:


	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10				# exit
	syscall









# cstring strdup (cstring src)
#	Duplicates a given string and allocates memory to the new string
# parameter:
#	$a0 - cstring to duplicate
# return:
#	$v0 - the address of the cstring
strdup:
	addiu	$sp, $sp, -4		# keep return address to main
	sw	$ra, ($sp)

	move	$t8, $a0		# string to dup move to t8 to keep address
	jal	strlen
	addi	$v0, $v0, 1		# strlen + 1 for malloc
	move	$a0, $v0		# moving the return value of strlen into a0 for malloc
	jal	malloc

	move	$t6, $v0		# newly allocated address as well as the return value

while3:
	lb	$t2, ($t8)		# t8 = base of src
	beq	$t2, $zero, endwhile3	# if str1[t2] != '\0'

	sb	$t2, ($t6)		# t6 = base of dst

	addu	$t8, $t8, 1		# effective address of src = base + 1 
	addu	$t6, $t6, 1		# effective address of dst = base + 1 

	b while3

endwhile3:
	lw	$ra, ($sp)		# pop off of the stack
	addiu	$sp, $sp, 4
	jr	$ra
	

# int strlen(cstring s) - the length of the string
#
# parameter:
#	a0 - the cstring
# return:
#	v0 - the length of the cstring
strlen:
	li	$t5, 0			# length count
while2:
	lb	$t7, ($a0)
	beq	$t7, $zero, endwhile2	# branch off if char is '\0'
	

	addi	$t5, $t5, 1
	addu	$a0, $a0, 1
	b	while2
endwhile2:
	move	$v0, $t5		# returning the length of the string
	jr	$ra






# address malloc(int size) - allocate memory from the heap
#
# parameter:
#	a0 - number of bytes to allocate
# return:
#	v0 - address of the new allocated space
malloc:
					# make sure parameter is a multiple of 4
	addi	$a0, $a0, 3
	and	$a0, $a0, 0xfffc
	li	$v0, 9			# allocate space with the giving size + 1
	syscall
	jr	$ra



	