	.data
header:	.asciiz	"Quadratic Equation Solver v0.1 by V. Pham\n\n"
aValue:	.asciiz	"Enter value for a? " 
bValue:	.asciiz	"Enter value for b? "
cValue:	.asciiz	"Enter value for c? "
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

	la	$a0, bValue
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall

	la	$a0, cValue
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall

	

	