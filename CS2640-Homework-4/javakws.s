	.data


title:		.asciiz "Java Keywords by V. Pham"

keywords:
	.word	abstract, assert, boolean, xbreak, byte, case, catch, char
	.word	class, const, continue, default, do, double, else, enum
	.word	extends, false, final, finally, float, for, goto, if
	.word	implements, import, instanceof, int, interface, long, native, new
	.word	null, package, private, protected, public, return, short, static
	.word	strictfp, super, switch, synchronized, this, throw, throws, transient
	.word	true, try, void, volatile, while

abstract:	.asciiz	"abstract"
assert:		.asciiz	"assert"
boolean:	.asciiz	"boolean"
xbreak:		.asciiz	"break"
byte:		.asciiz	"byte"
case:		.asciiz	"case"
catch:		.asciiz	"catch"
char:		.asciiz	"char"
class:		.asciiz	"class"
const:		.asciiz	"const"
continue:	.asciiz	"continue"
default:	.asciiz	"default"
do:		.asciiz	"do"
double:		.asciiz	"double"
else:		.asciiz	"else"
enum:		.asciiz	"enum"
extends:	.asciiz	"extends"
false:		.asciiz	"false"
final:		.asciiz	"final"
finally:	.asciiz	"finally"
float:		.asciiz	"float"
for:		.asciiz	"for"
goto:		.asciiz	"goto"
if:		.asciiz	"if"
implements:	.asciiz	"implements"
import:		.asciiz	"import"
instanceof:	.asciiz	"instanceof"
int:		.asciiz	"int"
interface:	.asciiz	"interface"
long:		.asciiz	"long"
native:		.asciiz	"native"
new:		.asciiz	"new"
null:		.asciiz	"null"
package:	.asciiz	"package"
private:	.asciiz	"private"
protected:	.asciiz	"protected"
public:		.asciiz	"public"
return:		.asciiz	"return"
short:		.asciiz	"short"
static:		.asciiz	"static"
strictfp:	.asciiz	"strictfp"
super:		.asciiz	"super"
switch:		.asciiz	"switch"
synchronized:	.asciiz	"synchronized"
this:		.asciiz	"this"
throw:		.asciiz	"throw"
throws:		.asciiz	"throws"
transient:	.asciiz	"transient"
true:		.asciiz	"true"
try:		.asciiz	"try"
void:		.asciiz	"void"
volatile:	.asciiz	"volatile"
while:		.asciiz	"while"



	.text
main:
	move	$s0, $a0	# s0 = argc
	move	$s1, $a1	# s1 = argv, address to an array of cstring



	la	$a0, title
	li	$v0, 4
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall



dowhile:
	la	$a0, keywords
	li	$a1, 52
	lw	$a2, ($s1)	# loop and output all argv

	jal	lsearch

	bge	$v0, 52, endif3	

	move	$t4, $v0
	la	$t2, keywords
	sll	$t5, $v0, 2
	addu	$t3, $t2, $t5
	lw	$a0, ($t3)
	li	$v0, 4
	syscall
	li	$a0, ':'
	li	$v0, 11
	syscall
	move	$a0, $t4
	li 	$v0, 1
	syscall

endif3:
	addiu	$s1, $s1, 4	# next argv
	sub	$s0, $s0, 1
	bnez	$s0, dowhile


	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10		# exit
	syscall






lsearch:
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)
	move	$s2, $a0		# s2 = keyword array address
	move	$s3, $a1		# s3 = length

	li	$v0, 0			# index

while1:	bge	$v0, $s3, endwhile1	# maybe error index >= 52
	move	$s4, $v0

	lw	$a0, ($s2)		# address of string
	move	$a1, $a2		# address to value
	jal	strcmp

	bnez	$v0, else1
	b	endwhile1
else1:
	move	$v0, $s4
	addi	$v0, $v0, 1
	addi	$s2, $s2, 4

	b	while1

endwhile1:

	lw	$ra, ($sp)
	addiu	$sp, $sp, 4

	jr	$ra




strcmp:
	li	$t0, 0		# int i = 0

while2:
	addu	$t1, $a0, $t0
	addu	$t2, $a1, $t0

	lb	$t3, ($t1)
	lb	$t4, ($t2)
	
	bne	$t3, 10, endif2		# t3 != '\n' => endif2
	li	$v0, 0
	b	endwhile2		# branch to endwhile2 (return)
	
endif2:
	addi	$t0, $t0, 1		# i++
	beq	$t3, $t4, while2	# t3 == t4 => while2

endwhile2:
	sub	$v0, $t3, $t4
	jr	$ra