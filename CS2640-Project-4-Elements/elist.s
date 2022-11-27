	.data
head:	.word 0
input:	.space 64
pftname:
	.asciiz "C:\Users\vinhp\OneDrive\Documents\GitHub\CS2640\CS2640-Project-4-Elements\enames.dat"

	.text
main:
	la	$a0, pftname
	jal	open
	move	$s0, $v0		# save fd in s0
					# to read a string
	move	$a0, $s0
	la	$a1, buf
	jal	fgetln
					# string read into buf
	

			
	move	$a0, $s0
	jal	close

	li	'\n', 11
	syscall
	li	$v0, 10
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
