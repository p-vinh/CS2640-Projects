# 
#  Name:	Pham, Vinh 
#  Project:	3 
#  Due:		November 3, 2022 
#  Course:	cs-2640-04-f22
# 
#  Description: 
#	
#

	.data
MAXLINES = 8
LINELEN = 40
lines:	.word	0:8
inbuf:	.space	LINELEN + 2			# up to LINELEN byte, see syscall 8 for reference
title:	.asciiz	"Lines by V. Pham\n"
prompt:	.asciiz "Enter text? "

	.text
main:

	la	$a0, title			# print out title
	li	$v0, 4
	syscall


	li	$t0, 0				# index
	la	$t3, lines			# base address
	li	$t4, 0				# offset

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

	# beq	$t2, '\n', enddowhile		# break if t2 contains a '\n' check if user put 'enter'

	move	$a0, $t1			### MIGHT NOT NEED THIS###
	jal	strdup				# strdup(inbuf)
	sw	$v0, ($t3)			# saving address of C-String to lines
	sll	$t4, $t4, 2
	addu	$t3, $t3, $t4			# lines[t3] - effective address

	
	addi	$t4, $t4, 1			# t4 ++ for offset
	addi	$t0, $t0, 1			# t0 ++
	blt	$t0, 8, dowhile 


	# output all the lines here
	la	$t1, lines
	li	$t4, 0
	li	$t2, 0				# index
for:
	bge	$t2, 8, endfor

	lw	$a0, ($t1)			# a0 = address of c string
	li	$v0, 4
	syscall

	sll	$t4, $t4, 2
	addu	$t1, $t1, $t4
	addi	$t2, $t2, 1			# increment index
	addi	$t4, $t4, 1			# increment offset
	b	for
endfor:


	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10				# exit
	syscall





strlen:
	li	$t5, 0			# length count

while2:
	lb	$t7, ($a0)
	beq	$t7, $zero, endwhile2	# branch off if char is '\0' or '\n'
	beq	$t7, '\n', endwhile2
	

	addi	$t5, $t5, 1
	addu	$a0, $a0, 1
	b	while2
endwhile2:
	move	$v0, $t5
	jr	$ra





strdup:
	move	$t8, $ra		# keep return address to main
	move	$t1, $a0		# string to dup move to t1 to keep address
	jal	strlen
	move	$a0, $v0		# moving the return value of strlen into a0 for malloc
	jal	malloc

	move	$t6, $v0		# newly allocated address

while3:
	bne	$t2, $zero, endwhile3	# if str1[t2] != '\0'
	lb	$t2, ($t1)		# t1 = base of src
	sb	$t2, ($t6)		# t6 = base of dst

	addu	$t1, $t1, 1		# effective address of src = base + 1 
	addu	$t6, $t6, 1		# effective address of dst = base + 1 

	b while3

endwhile3:
	move	$ra, $t8
	jr	$ra
	
	


malloc:					# address malloc (int size)

	# make sure parameter is a multiple of 4
	addi	$a0, $a0, 3
	and	$a0, $a0, 0xfffc
	li	$v0, 9
	syscall
	jr	$ra



	