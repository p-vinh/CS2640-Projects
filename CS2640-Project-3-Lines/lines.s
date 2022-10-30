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
	la	$t1, lines
	li	$t2, 0				# index
for:
	bge	$t2, 8, endfor

	lw	$t3, ($t1)			# t3 = address of c string
	
	li	$v0, 11
while:						# prints the content from line
	beq	$a0, $zero, endwhile
	lb	$a0, ($t3)
	syscall

	addu	$t3, $t3, 1
	b	while
endwhile:


	sll	$t4, $t4, 2
	addu	$t1, $t1, $t4
	addi	$t2, $t2, 1			# increment
	b	for
endfor:


	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10				# exit
	syscall





strlen:
	li	$t0, 0			# length

while2:
	lb	$t1, ($a0)
	beq	$t1, $zero, endwhile2	# branch off if char is '\0' or '\n'
	beq	$t1, 10, endwhile2
	

	addi	$t0, $t0, 1
	addu	$a0, $a0, 1
	b	while2
endwhile2:
	move	$v0, $t0
	jr	$ra





strdup:
	# might have bug here. not moving parameter and justt calling strlen right away
	move	$t1, $a0
	jal	strlen
	addi	$a0, $v0, 1
	jal	malloc

	move	$t0, $v0		# newly allocated address

dowhile2:

	lb	$t2, ($t1)		# t1 = base of src
	sb	$t2, ($t0)		# t0 = base of dst

	addu	$t1, $t1, 1		# effective address of src = base + 1 
	addu	$t0, $t0, 1		# effective address of dst = base + 1 

	beq	$t2, $zero, enddowhile2	# if str1[t5] == '\0'
	b	dowhile2
enddowhile2:
	jr	$ra
	
	


malloc:					# address malloc (int size)

	# make sure parameter is a multiple of 4
	addi	$a0, $a0, 3
	and	$a0, $a0, 0xfffc
	li	$v0, 9
	syscall
	jr	$ra



	