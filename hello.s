#   Name:       Pham, Vinh
#   Homework:   #2
#   Due:        Oct 4, 2022 
#   Course:     cs-2640-04-f22
#   Description:
#       MIPS32 Hello World
#       CS 2640
#
	.data
hello:	.ascii  "MIPS32 by V. Pham\n\n"
	.asciiz "hello world!\n"


	.text
main:
	la	$a0,	hello       # display hello
	li	$v0,	4
	syscall

	li	$v0,	10          # exit
	syscall
