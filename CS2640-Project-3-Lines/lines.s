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

	bne	$t2, 10, enddowhile		# break if t2 contains a '\n'

	move	$a0, $t1
	jal	strdup				#strdup(inbuf)
	sw	$v0, ($t3)			# saving address of C-String to lines
	sll	$t4, $t4, 2
	addu	$t3, $t3, $t4			# lines[t3] - effective address

	
	addi	$t0, $t0, 1			# t0 ++
	bge	$t0, 8, enddowhile 
	b	dowhile
enddowhile:


	# output all the lines here
	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10				# exit
	syscall





strlen:
	li	$t0, 0			# length

while:
	lb	$t1, ($a0)
	beq	$t1, $zero, endwhile	# branch off if char is '\0' or '\n'
	beq	$t1, 10, endwhile
	

	addi	$t0, $t0, 1
	addu	$a0, $a0, 1
	b	while
endwhile:
	move	$v0, $t0
	jr	$ra





strdup:
dowhile2:
	# might have bug here. not moving parameter and justt calling strlen right away
	jal	strlen
	addi	$a0, $v0, 1
	jal	malloc

	la	$t0, $v0		# newly allocated address

	

	lb	$t6, ($a1)		# a1 = base of str1
	sb	$t6, ($a0)		# a0 = base of str2

	addu	$a0, $a0, 1		# effective address of str2 = base + 1 
	addu	$a1, $a1, 1		# effective address of str1 = base + 1 

	beq	$t6, $zero, enddowhile2	# if str1[t5] == '\0'
	b	dowhile2
enddowhile2:
	jr	$ra
	
	


malloc:					# address malloc (int size)

	