.text
.globl	main
main:
    li $s1,1
    li $s2,2
    li $t0,0                            #t0 == steps
    la $t1,matrix                       #t1 == matrix
loop:
    rem $t9,$t0,2                       #t9 for remainder
    beq $t9,0,loopx			#go to loop x if the number of input is even else to loopy
    j loopy
loopy: 
    li $v0,4                            #ask y for input
    la $a0,msgy
    syscall
    li $v0,5
    syscall
    move $t3,$v0                        #t3 == index position
    move $s3,$t3
    blt $t3,1,badinp			#if input is less than 1 or greater than 9 then bad input
    bgt $t3,9,badinp
    sub $t3,$t3,1			
    sll $t3,$t3,2
    add $t4,$t1,$t3                     #t4 == pointer for value at index
    lw $t5,0($t4)                       #t5 == checking validity if that position is allowed or not
    bne $t5,0,badinp
    sw $s2,0($t4)
    addi $t0,1
    j printer				#print the matrix

loopx:
    li $v0,4                            #ask x for input
    la $a0,msgx
    syscall
    li $v0,5
    syscall
    move $t3,$v0                        #t3 == index position
    move $s3,$t3
    blt $t3,1,badinp			#if input is less than 1 or greater than 9 then bad input
    bgt $t3,9,badinp
    sub $t3,$t3,1
    sll $t3,$t3,2
    add $t4,$t1,$t3                     #t4 == pointer for value at index
    lw $t5,0($t4)                       #t5 == checking validity if that position is allowed or not
    bne $t5,0,badinp
    sw $s1,0($t4)
    addi $t0,1
    j printer				#print the matrix

badinp: 
    li $v0,4                            
    la $a0, badinpstr
    syscall
    j loop
    
### PRINTER PHASE.. DON'T TOUCH t0 t1
printer:					#printing the tic tac toe
    addi $t3,$t1,0
    li $t4,0
    j three
three:
    lw $t2,0($t3)
    beq $t2,0,printspace
    beq $t2,1,printX
    j printO
printX:
    li $v0,4		
    la $a0,x
    syscall
    j counter
printO:
    li $v0,4
    la $a0,o
    syscall
    j counter
printspace:
    li $v0,4
    la $a0,spac
    syscall
    j counter
printnline:
    li $v0,4
    la $a0,newline
    syscall
    j three
counter: 
    addi $t3,$t3,4
    addi $t4,$t4,1
    beq $t4,3,printnline
    beq $t4,6,printnline
    beq $t4,9,printover
    j three
printover:
    li $v0,4
    la $a0,newline
    syscall
    j checker

checker: 
    sub $s3,$s3,1		#s3 input
    li $t8,3
    div $s3,$t8
    mflo $s4			#s4=s3/3 row number
    mfhi $s5			#s5=s3%3 column number
    sll $s4,$s4,2		#s4=s4*4
    mult $s4,$t8		#s4==s4*3
    mflo $s4
    sll $s5,$s5,2		# s4==i*3 s5==j
    j rowcheck

rowcheck: 
    add $s7,$t1,$s4		#s7 index of starting row element
    lw $t4,0($s7)		#t4=1st element of row
    lw $t5,4($s7)		#t5=2nd element of row
    bne $t4,$t5,colcheck
    lw $t4,8($s7)		#t4=3rd element of row
    bne $t4,$t5,colcheck
    beq $t4,1,winx		#if all three are equal to 1 then x win
    beq $t4,2,winy		#if all three are equal to 2 then y win
    j colcheck			#if it does not win in row then check the column

colcheck:
    add $s7,$t1,$s5		#s7 index of starting column element
    lw $t4,0($s7)		#t4=1st element of column
    lw $t5,12($s7)		#t5=2nd element of column
    bne $t4,$t5,leftdiagcheck
    lw $t4,24($s7)		#t4=3rd element of column
    bne $t4,$t5,leftdiagcheck
    beq $t4,1,winx		#if all three are equal to 1 then x win
    beq $t4,2,winy		#if all three are equal to 2 then y win
    j leftdiagcheck		#if it does not win in row then check the left diagonal

leftdiagcheck:			
    add $s7,$t1,0		#s7 index of starting matrix element
    lw $t4,0($s7)		#t4=1st element of left diagonal
    lw $t5,16($s7)		#t5=2nd element of left diagonal
    bne $t4,$t5,rightdiagcheck
    lw $t4,32($s7)		#t4=3rd element of left diagonal
    bne $t4,$t5,rightdiagcheck
    beq $t4,1,winx		#if all three are equal to 1 then x win
    beq $t4,2,winy		#if all three are equal to 2 then y win
    j rightdiagcheck		#if it does not win in row then check the right diagonal

rightdiagcheck:
    add $s7,$t1,0		#s7 index of starting matrix element
    lw $t4,8($s7)		#t4=1st element of right diagonal
    lw $t5,16($s7)		#t5=2nd element of right diagonal
    bne $t4,$t5,draw
    lw $t4,24($s7)		#t4=3rd element of right diagonal
    bne $t4,$t5,draw		
    beq $t4,1,winx		#if all three are equal to 1 then x win
    beq $t4,2,winy		#if all three are equal to 2 then y win
    j draw			#if it does not win in row then check the draw

draw:				#Draw condition
    bne $t0,9,loop		#if number of steps are equal to 9 and no one has won then match is draw
    li $v0,4
    la $a0,msgdraw
    syscall
    li $v0,10
    syscall
winx:				#printing msg of x
    li $v0,4
    la $a0,msgxwin
    syscall
    li $v0,10
    syscall
winy:
    li $v0,4			#printing msg of y
    la $a0,msgywin
    syscall
    li $v0,10
    syscall
    
.data      
matrix: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
dash: .asciiz "\n-----\n"
vdash: .asciiz "|"
badinpstr: .asciiz "\n... bad input, try again ...\n"
replayprompt: .asciiz "If you want to replay, enter 1 :  "
spac: .asciiz "."
o: .asciiz "O"
x: .asciiz "X"
msgx:	.asciiz	"Player X, Enter number (1-9) to place cross at that position:   "
msgy:	.asciiz	"Player Y, Enter number (1-9) to place cross at that position:   "
msgxwin:	.asciiz	"Player X has won !!!\n"
msgywin:	.asciiz	"Player Y has won !!!\n"
msgdraw:	.asciiz	"It's a draw!!!\n"
newline:   .asciiz	"\n"
