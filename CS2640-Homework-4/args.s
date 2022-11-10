
# cpp.cos.cs.2640.04.f22.tvnguyen7 - process command line args
# QtSPIM:
#   To specify the command line, 
#	select Simulator > Run Parameters > Enter the command line args
	.data
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
# int main(int argc, char *argv[]) - argv[0] is the program name
# 	a0: argc
# 	a1: argv, address to an array of cstring

main:
	move	$s0, $a0
	move	$s1, $a1

	la	$t5, keywords

do1:	lw	$a0, ($s1)	# loop and output all argv
	lw	$a1, ($t5)
	jal	strcmp

	move	$t4, $v0
	addu	$t3, $t5, $t4
	lw	$a0, ($t3)
	li	$v0, 4
	syscall
	li	$a0, ':'
	li	$v0, 11
	syscall
	move	$a0, $t4
	li 	$v0, 1
	syscall

	addiu	$s1, $s1, 4	# next argv
	addiu	$t2, $t2, 4
	sub	$s0, $s0, 1

	bnez	$s0, do1



	li	$v0, 10
	syscall



strcmp:
	li	$t0, 0

while2:
	addu	$a0, $a0, $t0
	addu	$a1, $a1, $t0

	lb	$t1, ($a0)
	lb	$t2, ($a1)
	
	bne	$t1, 10, endif2		# t1 != '\n' => endif2
	li	$v0, 0
	b	endwhile2		# branch to endwhile2 (return)
	
endif2:
	addi	$t0, $t0, 1		# i++
	beq	$t1, $t2, while2	# t1 == t2 => while2

endwhile2:
	sub	$v0, $t1, $t2
	jr	$ra