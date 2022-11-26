	.data
head:	.word 0
input:	.space 64
pftname:.asciiz "C:\Users\vinhp\OneDrive\Documents\GitHub\CS2640\CS2640-Project-4-Elements\enames.dat"

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
