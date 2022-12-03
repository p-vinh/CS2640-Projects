	.data
header:	.asciiz	"Quadratic Equation Solver v0.1 by V. Pham\n\n"
aValue:	.asciiz	"Enter value for a? " 
bValue:	.asciiz	"Enter value for b? "
cValue:	.asciiz	"Enter value for c? "
newLine:
	.asciiz "\n"

	.text
main:
	la	$a0, header
	li	$v0, 4
	syscall

	la	$a0, aValue
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	mov.s	$f20, $f0

	la	$a0, bValue
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	mov.s	$f21, $f0

	la	$a0, cValue
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	mov.s	$f22, $f0

	la	$a0, newLine
	li	$v0, 4
	syscall





	li	$v0, 10		# exit
	syscall


#
# int quadeq(float a, float b, float c)
#	
# parameters:
#	$f12 - input a
#	$f13 - input b
#	$f14 - input c
quadeq:
	li	$v0, 0
	li.s	$f4, 0.0
	c.eq.s	$f12, $f4
	bc1t	else1
	c.eq.s	$f13, $f4
	bc1f	else2
	jr	$ra		# returning since v0 already has 0
else2:
	neg.s	$f5, $f14
	div.s	$f0, $f5, $f13
	li	$v0, 1
	jr	$ra
else1:
				# d = b^2 - 4ac
	mul.s	$f5, $f13, $f13
	mul.s	$f6, $f12, $f14
	li.s	$f7, 4.0
	mul.s	$f7, $f6, $f7
	sub.s	$f7, $f5, $f7

	c.lt.s	$f7, $f4
	bc1f	else3

	li	$v0, -1
	jr	$ra

else3:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	mov.s	$f12, $f7
	jal	sqrts
	

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

#
# float sqrts(float x)
#
#
#
sqrts:

