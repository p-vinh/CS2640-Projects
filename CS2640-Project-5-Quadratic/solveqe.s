	.data
# Header/Input
header:	.asciiz	"Quadratic Equation Solver v0.1 by V. Pham\n\n"
aValue:	.asciiz	"Enter value for a? " 
bValue:	.asciiz	"Enter value for b? "
cValue:	.asciiz	"Enter value for c? "
newLine:.asciiz "\n"

# Equation Output
equals:	.asciiz " = 0\n"
quadratic2:
	.asciiz	" x + "
quadratic:	
	.asciiz	" x^2 + "

# Root output
notquadratic:
	.asciiz "Not a quadratic equation."
imaginary:
	.asciiz "Roots are imaginary."
x:	.asciiz "x = "
x1:	.asciiz "x1 = "
x2:	.asciiz "x2 = "



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

				# printing output
	mov.s	$f12, $f20
	li	$v0, 2
	syscall
	la	$a0, quadratic
	li	$v0, 4
	syscall
	mov.s	$f12, $f21
	li	$v0, 2
	syscall
	la	$a0, quadratic2
	li	$v0, 4
	syscall
	mov.s	$f12, $f22
	li	$v0, 2
	syscall
	la	$a0, equals
	li	$v0, 4
	syscall
	la	$a0, newLine
	li	$v0, 4
	syscall

	mov.s	$f12, $f20
	mov.s	$f13, $f21
	mov.s	$f14, $f22
	jal	quadeq
	#test
	move	$a0, $v0
	li	$v0, 1
	syscall
	move	$v0, $a0

	bne	$v0, 0, elseif
	la	$a0, notquadratic
	li	$v0, 4
	syscall
	b	endif

elseif:
	bne	$v0, 1, elseif2
	la	$a0, x
	li	$v0, 4
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall
	b	endif
elseif2:
	bne	$v0, -1, else
	la	$a0, imaginary
	li	$v0, 4
	syscall
	b	endif
else:
	la	$a0, x1
	li	$v0, 4
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall
	la	$a0, newLine
	li	$v0, 4
	syscall
	la	$a0, x2
	li	$v0, 4
	syscall
	mov.s	$f12, $f1
	li	$v0, 2
	syscall
endif:
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
	bc1f	else1
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
	addiu	$sp, $sp, -16	# save return address and parameters
	sw	$ra, 0($sp)
	s.s	$f12, 4($sp)
	s.s	$f13, 8($sp)
	s.s	$f14, 12($sp)

	mov.s	$f12, $f7
	jal	sqrts
	mov.s	$f7, $f0
	l.s	$f14, 12($sp)	# restore parameters
	l.s	$f13, 8($sp)
	l.s	$f12, 4($sp)
				# positive quadratic
	li.s	$f6, 2.0
	neg.s	$f4, $f13
	add.s	$f4, $f7, $f4
	mul.s	$f5, $f12, $f6
	div.s	$f0, $f4, $f5	# x1

				# positive quadratic
	neg.s	$f4, $f13
	sub.s	$f4, $f4, $f7
	mul.s	$f5, $f12, $f6
	div.s	$f1, $f4, $f5	#x2


	lw	$ra, 0($sp)	# restore ra
	addiu	$sp, $sp, 16

	li	$v0, 2
	jr	$ra

#
# float sqrts(float x)
#
# parameters:
#	$f12
sqrts:
	sqrt.s	$f0, $f12
	jr	$ra
