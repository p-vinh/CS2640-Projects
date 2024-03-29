	.data
LINELEN = 40
pftname:
	.asciiz "C:\Users\vinhp\OneDrive\Documents\GitHub\CS2640\CS2640-Project-4-Elements\enames.dat"
buf:	.space	LINELEN + 2			# up to LINELEN byte
	.text
main:
	la	$a0, pftname
	jal	open
	move	$s0, $v0		# save fd in s0
do2:
	move	$a0, $s0		
	la	$a1, buf
	jal	fgetln			# to read a string
					# string read into buf
	lb	$t0, 0($a1)
	beq	$t0, '\n', enddowhile		# break if t2 contains a '\n' check if user put 'enter'

	move	$a0, $a1
	li	$v0, 4
	syscall

	b	do2

enddowhile:
	move	$a0, $s0
	jal	close


	li	$a0, '\n'
	li	$v0, 11
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
