	.data
head:	.word 0
input:	.space 64
pftname:
	.asciiz "C:\Users\vinhp\OneDrive\Documents\GitHub\CS2640\CS2640-Project-4-Elements\enames.dat"
title:
	.asciiz "Elements by V. Pham\n\n"
elements:
	.asciiz " elements\n\n"


	.text
main:

	la	$a0, title
	li	$v0, 4
	syscall

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
	lw	$a1, head
	jal	getnode
	sw	$v0, head


	addiu	$s1, $s1, 1		 # increment count of elements
	b	do2

enddowhile:
	move	$a0, $s0
	jal	close

	move	$a0, $s1		# prints number of elements
	li	$v0, 1
	syscall
	la	$a0, elements
	li	$v0, 4
	syscall


	lw	$a0, head
	la	$a1, print
	jal	traverse

	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10
	syscall


# node-address getnode(cstring s, address list)
#	returns the address of a new node and it is initialized with data and next
# parameters:
# 	$a0 - string
# 	$a1 - address list
# return:
#	$v0 - address of node
getnode:
	addiu	$sp, $sp, -12		# save registers
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)

	li	$a0, 8
	jal	malloc			# allocate 8 bytes in heap for the node

	lw	$a0, 4($sp)		# restore string and address list
	lw	$a1, 8($sp)

	sw	$a0, 0($v0)		# node.data = address of string
	sw	$a1, 4($v0)		# node.next = address list

	lw	$ra, 0($sp)		# restore return address
	addiu	$sp, $sp, 12
	jr	$ra


# void traverse(address list, address proc)
#	traverses the address list and calls address proc passing the data of the node to proc
# parameters:
# 	a0 - address list
# 	a1 - address proc
# return:
#	None
traverse:
	beqz	$a0, endif		# if (address list != 0)
	
	addiu	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)

	lw	$a0, 4($a0)
	jal	traverse

	lw	$a0, 4($sp)		# restore $a0
	lw	$a0, 0($a0)		# a0 - list.data
	jalr	$a1

	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addiu	$sp, $sp, 8
endif:
	jr	$ra


# void print (cstring string)
#	Prints the given string
# parameter:
# 	$a0 - string
# return:
#	None
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
	addiu	$sp, $sp, -8		# keep return address to main
	sw	$ra, ($sp)
	sw	$s0, 4($sp)

	move	$s0, $a0		# string to dup move to t8 to keep address
	jal	strlen
	addi	$a0, $v0, 1		# strlen + 1 for malloc
	jal	malloc

	move	$t0, $v0		# newly allocated address as well as the return value

while3:
	lb	$t2, ($s0)		# t8 = base of src
	beqz	$t2, endwhile3		# if str1[t2] != '\0'

	sb	$t2, ($t0)		# t6 = base of dst

	addiu	$s0, $s0, 1		# effective address of src = base + 1 
	addiu	$t0, $t0, 1		# effective address of dst = base + 1 

	b while3

endwhile3:
	lw	$s0, 4($sp)
	lw	$ra, ($sp)		# pop off of the stack
	addiu	$sp, $sp, 8
	jr	$ra
	

# int strlen(cstring s) - the length of the string
#
# parameter:
#	a0 - the cstring
# return:
#	v0 - the length of the cstring
strlen:
	move	$v0, $a0
while2:
	lb	$t0, ($v0)
	beqz	$t0, endwhile2		# branch off if char is '\0'

	addi	$v0, $v0, 1
	b	while2
endwhile2:
	sub	$v0, $v0, $a0		# length = source[end] - source[start]
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
	li	$a2, 1			# 1 byte at a time
do1:	li	$v0, 14
	syscall
	lb 	$t1, ($a1)
	addiu 	$a1, $a1, 1
	bne 	$t1, '\n', do1
	sb 	$zero, ($a1)		# null byte
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
