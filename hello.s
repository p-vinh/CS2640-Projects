#   Name:       Pham, Vinh
#   Homework:   #2
#   Due:        Oct 4, 2022 
#   Course:     cs-2640-04-f22
#   Description:
#       MIPS32 Hello World
#       CS 2640
#
	.data
length:	.word 5
width:	.word 10
area:	.word 0

	.text
main:
	lw	$t0, length       
	lw	$t1, width

	mul	$t1, $t1, $t0

	sw	$t1, area

	move	$a0, $t1
	li	$v0, 1
	syscall

	li	$v0,	10          # exit
	syscall
