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
	move	$t0, $a0
	move	$t1, $a1

	la	$a0, keywords
	li	$a1, 52
dowhile:
	lw	$a2, ($t1)	# loop and output all argv

	move	$s0, $t0
	move	$s1, $t1

	jal	lsearch




	addiu	$t1, $t1, 4	# next argv
	sub	$t0, $t0, 1
	bnez	$t0, dowhile


	la	$a0, title
	li	$v0, 4
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall

	


	li	$a0, '\n'
	li	$v0, 11
	syscall
	li	$v0, 10		# exit
	syscall






strcmp:
	li	$t0, 0

while2:
	addu	$a0, $a0, $t0
	addu	$a1, $a1, $t0

	lb	$t1, ($a0)
	lb	$t2, ($a1)
	bne	$t1, $t2, endwhile2
	
if2:	bne	$t1, 10, endif2
	li	$v0, 0
	b	endwhile2		# branch to endwhile2
	
endif2:
	addi	$t0, $t0, 1		# i++
	b	while2			# branch to while2
	

endwhile2:
	sub	$v0, $t1, $t2
	jr	$ra







lsearch:
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)
	move	$t3, $a0

	li	$v0, 0		# index

while1:	bge	$v0, $a1, endwhile1		# maybe error

	add	$v0, $v0, $t3
	lw	$a0, ($v0)
	move	$a1, $a2
	move	$s2, $v0

	jal	strcmp


	bnez	$v0, else1
	b	endwhile1
else1:
	addi	$v0, $v0, 4
	b while1

endwhile1:


	move	$v0, $s2
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)

	jr	$ra