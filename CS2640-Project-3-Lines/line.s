# 
#  Name:	Pham, Vinh 
#  Homework:	3 
#  Due:		November 1, 2022 
#  Course:	cs-2640-04-f22
# 
#  Description: 
#	This program takes in a string input of 40 characters into str1
#	and copies it into str2. The output is the length of str2 and the
#	copied contents of str2.
#

	.data
LEN = 42
str1:	.space	LEN
str2:	.space	LEN
name:	.asciiz	"String by V. Pham\n\n"
prompt:	.asciiz "Enter text? "


	.text
main:
	la	$a0, name		# print out title
	li	$v0, 4
	syscall


	la	$a0, prompt		# prompt the user
	li	$v0, 4
	syscall

	la	$a0, str1		# buffer = str, the length is 41 to include '\0' if user uses up all 40 spaces
	li	$a1, 41
	li	$v0, 8
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall



	la	$a0, str2
	la	$a1, str1
	jal	strdup			# jump to strdup(dest: a0, src: a1)
	
	la	$a0, str2
	jal	strlen			# jump to strlen(src: a0)

	move	$a0, $v0		# print the length of str2
	li	$v0, 1
	syscall
	li	$a0, ':'
	li	$v0, 11
	syscall



	la	$t0, str2
	li	$v0, 11

while:					# prints the content from str2
	beq	$a0, $zero, endwhile
	lb	$a0, ($t0)
	syscall

	addu	$t0, $t0, 1
	b	while
endwhile:


	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10			# exit
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
dowhile:
	lb	$t6, ($a1)		# a1 = base of str1
	sb	$t6, ($a0)		# a0 = base of str2

	addu	$a0, $a0, 1		# effective address of str2 = base + 1 
	addu	$a1, $a1, 1		# effective address of str1 = base + 1 

	beq	$t6, $zero, enddowhile	# if str1[t5] == '\0'
	b	dowhile
enddowhile:
	jr	$ra
	
	