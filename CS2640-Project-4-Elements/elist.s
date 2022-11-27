	.data
head:	.word 0
input:	.space 64
pftname:
	.asciiz "C:\Users\vinhp\OneDrive\Documents\GitHub\CS2640\CS2640-Project-4-Elements\enames.dat"
title:
	.asciiz "Elements by V. Pham\n\n"

	.text
main:



	la	$a0, pftname
	jal	open
	move	$s0, $v0		# save fd in s0
	li	$s1, 0			# count of elements
do2:
	move	$a0, $s0		
	la	$a1, input
	jal	fgetln			# to read a string
					# string read into buf
	lb	$t0, 0($a1)
	beq	$t0, '\n', enddowhile	# break if t2 contains a '\n' check if user put 'enter'


	move	$a0, $a1
	jal	strdup


	move	$a0, $v0
	lw	$a1, head		 # maybe bug
	jal	getnode

	sw	$v0, head


	addiu	$s1, $s1, 1		 # increment count of elements
	b	do2

enddowhile:
	move	$a0, $s0
	jal	close


	lw	$a0, head
	la	$a1, print
	jal	traverse

	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10
	syscall


# a0 - string
# a1 - address list

getnode:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	li	$a0, 4			# may be a bug with allocating space - "memory out of bounds"
	jal	malloc



# a0 - address list
# a1 - address proc

traverse:
	addiu	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)

	beqz	$a0, endif
	lw	$a0, 4($a0)
	jal	traverse

	lw	$a0, 4($sp)
	lw	$a0, 0($a0)
	jalr	$a1
endif:

	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addiu	$sp, $sp, 8

	jr	$ra

# a0 - string
print:
	li	$v0, 4
	syscall
	jr	$ra

# cstring strdup (cstring src)
#	Duplicates a given string and allocates memory to the new string
# parameter:
#	$a0 - cstring to duplicate
# return:
#	$v0 - the address of the cstring
strdup:
	addiu	$sp, $sp, -4		# keep return address to main
	sw	$ra, ($sp)

	move	$t1, $a0		# string to dup move to t8 to keep address
	jal	strlen
	addi	$v0, $v0, 1		# strlen + 1 for malloc
	move	$a0, $v0		# moving the return value of strlen into a0 for malloc
	jal	malloc

	move	$t0, $v0		# newly allocated address as well as the return value

while3:
	lb	$t2, ($t1)		# t8 = base of src
	beq	$t2, $zero, endwhile3	# if str1[t2] != '\0'

	sb	$t2, ($t0)		# t6 = base of dst

	addu	$t1, $t1, 1		# effective address of src = base + 1 
	addu	$t0, $t0, 1		# effective address of dst = base + 1 

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
	li	$t0, 0			# length count
while2:
	lb	$t1, ($a0)
	beq	$t1, $zero, endwhile2	# branch off if char is '\0'
	

	addi	$t0, $t0, 1
	addu	$a0, $a0, 1
	b	while2
endwhile2:
	move	$v0, $t0		# returning the length of the string
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


# void fgetln (cstring s) - get a line of text from a file
#		(\n included, null terminated)
# parameters
# 	a0: fd (file descriptor)
# 	a1: s
fgetln:	move	$t0, $a1		# save a1
	li	$a2, 1		# 1 byte at a time
do1:	li	$v0, 14
	syscall
	lb 	$t1, ($a1)
	addiu 	$a1, $a1, 1
	bne 	$t1, '\n', do1
	sb 	$zero, ($a1)	# null byte
	move	$a1, $t0		# restore a1
	jr	$ra


# open - open file for reading
#
# parameter:
# 	a0: file name
# return:
# 	v0: fd (file descriptor)
open:	li	$a1, 0
	li	$a2, 0
	li	$v0, 13
	syscall
	jr	$ra

# close - close file
# 	a0: fd
close:
	li 	$v0, 16
	syscall
	jr	$ra
