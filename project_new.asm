###############################################################################################################################################################################################
#																			Project Done By:																															   #
#																					Yousef Ghanem			1172333																									   #
#																					Mahmoud Sub Laban		1172144																									   #
###############################################################################################################################################################################################

.data
#						Messages
	Welcome : .asciiz "---------------------------------------------------------------------------------------------------------------Welcome to Perceptron---------------------------------------------------------------------------------------------------------------\n\nPlease enter the name of the training file: "
	epochM  : .asciiz "PLease enter the number of epochs: "
	lrateM	: .asciiz "Please enter the learning rate: "
	thrM	:.asciiz "Please enter threshold: "
	momM	:.asciiz"Please enter momentum: "
	inpnumM	:.asciiz "number of inputs / weights is : "
	weightM : .asciiz "Please enter weights\n"
	opm1	: .asciiz "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n"
	opm2	: .asciiz "\t\t"
	opm3	: .asciiz "\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n"
	epnum	:.asciiz "epoch : "

#						Used Variables	
	buffer  : .space 20 
	inpnum : .word 0
	epoch: .word 0
	lrate: .word 0
	thr: .word 0
	mom: .float 0.0
	inputs: .word 0:10
	out :	.word 0
	weights:	.float 0.0:10
	x:.asciiz "x"
	yd:.asciiz "Yd"
	w:.asciiz "w"
	Y:.asciiz "Y(p)"
	e:.asciiz "E"
	l:.asciiz "LRate"
	t:.asciiz "Threshold"
	m:.asciiz "Momentum"
	
	coma : .space 1
	line1 : .space 2
	
	line : .asciiz "\n"
	
.text

main:

#print a welcome message and ask for file name
 li $v0, 4
 la $a0, Welcome
 syscall
#read file name
  li $v0, 8 
  li $a1, 20
  la $a0, buffer
  syscall
 jal remove	#remove new line from the end of file name
 
 #read number of epochs
 li $v0, 4
 la $a0, epochM
 syscall
 li $v0, 5
 syscall
sw $v0,epoch

#read learning rate
 li $v0, 4
 la $a0, lrateM
 syscall
 li $v0, 6
 syscall
swc1 $f0,lrate
 
 #read Threshold
 li $v0, 4
 la $a0, thrM
 syscall
 li $v0, 6
 syscall
swc1 $f0,thr

 #read momentum
 li $v0, 4
 la $a0, momM
 syscall
 li $v0, 6
 syscall
swc1 $f0,mom

addi $s7,$zero,1	#set epoch to 1
 j operate		#read file contents
 
  #---------------------------Print in table---------------------------
 p1:
 li $v0, 4
la $a0,inpnumM
syscall  
li $v0, 4
la $a0,inpnum
syscall

 jal newline
li $v0, 4
la $a0,weightM
syscall

 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
addi $t5,$zero,0	#index 0 for weight array
weight:			#read weights
beqz $t2,p2

	 li $v0, 6
 	 syscall
 	 swc1 $f0,weights($t5)
 	 addi $t5,$t5,32		#next index for array
 	 subi $t2,$t2,1
 	 
 j weight			#loop
 p2:
 jal newline
 li $v0, 4
 la $a0, opm1
 syscall
 jal newline
 
 p3:				#print epoch num
  jal newline
 li $v0, 4
 la $a0, epnum
 syscall
  li $v0, 1
  move $a0,$s7
 syscall
 jal newline
 
 #print header
  lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 addi $t9,$zero,0
 hinp:
  beq $t9,$t2,hout
  li $v0, 4
  la $a0, x
 syscall
  li $v0, 1
  move $a0,$t9
 syscall
 addi $t9,$t9,1
 li $v0, 4
 la $a0, opm2
 syscall
j hinp

hout:
  li $v0, 4
  la $a0, yd
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
 
jal headw

hyac:
  li $v0, 4
  la $a0, Y
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
herr:
  li $v0, 4
  la $a0, e
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
 
 jal headw
 
   li $v0, 4
  la $a0, l
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
   li $v0, 4
  la $a0, t
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
    li $v0, 4
  la $a0, m
 syscall
 li $v0, 4
 la $a0, opm3
 syscall

 j read			#read inputs/outputs

p4:				#print table of all parameters and results

addi $t6,$zero,0	#index 0 for input array
 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 #print inputs
 pinp:			#print inputs
 beqz $t2,pout
 li $v0, 1
 lw $a0, inputs($t6)
 subi $a0,$a0,48
 syscall
  li $v0, 4
 la $a0, opm2
 syscall
 
addi $t6,$t6,4
subi $t2,$t2,1
j pinp			#loop
#print desired output
pout:			#print outputs
li $v0, 1
 lw $a0, out
 subi $a0,$a0,48
 syscall
 li $v0, 4
 la $a0, opm2
 syscall
 
 #print initial weights
 addi $t5,$zero,0	#index 0 for weight array
 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 pw1:
  beqz $t2,calculate
 li $v0, 2
 lwc1 $f12,weights($t5)
 syscall
  li $v0, 4
 la $a0, opm2
 syscall
 addi $t5,$t5,32
 subi $t2,$t2,1
 j pw1
 
 #print Actual output
 pactual:
 li $v0,1
 move $a0,$t3
 syscall 
 li $v0, 4
 la $a0, opm2
 syscall
 j error
 
 #print error
 perror:
  li $v0,1
 move $a0,$t3
 syscall 
 li $v0, 4
 la $a0, opm2
 syscall

#print final weights
 bnez  $t3,error1	#check if error != 0 to calculate final weights
 pfw:
 addi $t5,$zero,0	#index 0 for weight array
 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
  pw2:
  beqz $t2,prth_lr	#go to next line of contents
 li $v0, 2
 lwc1 $f12,weights($t5)
 syscall
  li $v0, 4
 la $a0, opm2		#space
 syscall
 addi $t5,$t5,32
 subi $t2,$t2,1
 j pw2
 
 #Print Threshold and Learning rate ,momentum
 prth_lr:
 #Print Learning rate
   li $v0,2
   lwc1 $f12,lrate
   syscall 
   
 li $v0, 4
 la $a0, opm2		#space
 syscall
 
  #Print Threshold
   li $v0,2
   lwc1 $f12,thr
   syscall 
  
 li $v0, 4
 la $a0, opm2		#space
 syscall
 
   #Print momentum
    li $v0,2
   lwc1 $f12,mom
   syscall 
  
 j nextline
 
  #---------------------------------------------------------------------------------
  #---------------------------Print weight header---------------------------
  headw:
    lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 addi $t9,$zero,0
 hweight:
   beq $t9,$t2,ret
  li $v0, 4
  la $a0, w
 syscall
  li $v0, 1
  move $a0,$t9
 syscall
 addi $t9,$t9,1
 li $v0, 4
 la $a0, opm2
 syscall
j hweight
ret:
jr $ra
  #---------------------------------------------------------------------------------
  #---------------------------Calculate---------------------------
 calculate:
 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 addi $t5,$zero,0	#index 0 for weight array
 addi $t6,$zero,0	#index 0 for input array
 mov.s $f5,$f30
 
 output:			#calculate Actual output
 beqz $t2,step
 lw $s1,inputs($t6)
 subi $s1,$s1,48
 mtc1 $s1,$f1
 cvt.s.w $f1,$f1
 lwc1 $f2,weights($t5)
 mul.s $f4,$f2,$f1
 addi $t6,$t6,4
 addi $t5,$t5,32
 subi $t2,$t2,1
 add.s $f5,$f5,$f4
 j output			#loop
 
 step:			#perform a step function on above calculations to get output
  lwc1 $f3,thr
 sub.s $f5,$f5,$f3
c.lt.s $f5,$f30		#determine the result of step function {if r<0 then result = 0 , other: then result = 1}
bc1t is0
  addi $t3,$zero,1
 j pactual
 
 is0:
  addi $t3,$zero,0
 j pactual
 
 error:			#calculating error (Ydesired - Yactual)
 lw $t1,out
 subi $t1,$t1,48
 sub $t3,$t1,$t3
 beqz $t3,perror
 addi $t7,$zero,1
 j perror
 
 error1:			#calculate final weights if error != 0
 lwc1 $f1,lrate
 lwc1 $f6,mom
 lw $t2,inpnum	#store num of inputs
 subi $t2,$t2,48		#ascii to integer
 addi $t5,$zero,0	#index 0 for weight array
 addi $t6,$zero,0	#index 0 for input array
 wloop:
  beqz $t2,pfw
 lw $s0,inputs($t6)
 subi $s0,$s0,48
 mtc1 $s0,$f2
 cvt.s.w $f2,$f2
 mul.s $f4,$f2,$f1
  mtc1 $t3,$f3
 cvt.s.w $f3,$f3
 mul.s $f4,$f4,$f3
 lwc1 $f5,weights($t5)
 mul.s $f5,$f5,$f6
 add.s $f5,$f5,$f4
 swc1 $f5,weights($t5)
  addi $t6,$t6,4
 addi $t5,$t5,32
 subi $t2,$t2,1
 j wloop			#loop
 #---------------------------------------------------------------------------------
 #---------------------------Go to next line/epoch---------------------------
 nextline:
 jal newline
 subi $s5,$s5,1
 blez $s5,nextepoch	#if remaining rows = 0 then go to next epoch
 j read
 
 nextepoch:
 beqz $t7,end			#if all errors in last epoch = 0 then end program
 addi $t7,$zero,0		#reset error flag
 li $v0,16				
 move $a0,$t0
 syscall				#close input file
 jal nrowsF			#calculate number of rows
 addi $s7,$s7,1
 lw $s6,epoch
 bgt $s7,$s6,end		#if current epoch number = number of epochs then end program
 addi $t7,$zero,0
 j read2
 #---------------------------------------------------------------------------------
 #---------------------------read file contents---------------------------
operate:
# Open (for reading) a file
  li $v0, 13       # system call for open file
  la $a0,buffer
  li $a1, 0        # flags
  li $a2, 0        # mode is ignored
  syscall          # open a file (file descriptor returned in $v0)

  move $t0, $v0    # save file descriptor in $t0
  
  # Read input num 
  li $v0, 14       # system call for read to file
  la $a1, inpnum       # address of buffer from which to write
  li $a2, 1        # hardcoded buffer length
  move $a0, $t0    # put the file descriptor in $a0
  syscall          # write to file
  
  jal nrowsF	#calculate number of rows
j p1

read:
lw $t2,inpnum		#store num of inputs
subi $t2,$t2,48	#from ascii to integer
addi $t6,$zero,0	#index 0 for input array

  # remove new line  
  li $v0, 14       # system call for read to file
  la $a1, line1       # address of buffer from which to write
  li $a2, 2        # hardcoded buffer length
  move $a0, $t0    # put the file descriptor in $a0
  syscall          # write to file
readinp:	#reading inputs
	beqz $t2,readout

 	 li $v0, 14       # system call for read to file
 	 la $a1, inputs($t6)       # address of buffer from which to write
	 li $a2, 1        # hardcoded buffer length
	 move $a0, $t0    # put the file descriptor in $a0
  	 syscall          # write to file
	addi $t6,$t6,4	#next index for array
	subi $t2,$t2,1
	
	   # remove coma 
 	 li $v0, 14       # system call for read to file
 	 la $a1, coma       # address of buffer from which to write
 	 li $a2, 1        # hardcoded buffer length
 	 move $a0, $t0    # put the file descriptor in $a0
	 syscall          # write to file
	
	j readinp
readout:
	 li $v0, 14       # system call for read to file
 	 la $a1, out      # address of buffer from which to write
	 li $a2, 1        # hardcoded buffer length
	 move $a0, $t0    # put the file descriptor in $a0
  	 syscall          # write to file

	j p4
  #---------------------------------------------------------------------------------
   #---------------------------read file second time---------------------------
   read2:			#reading the file every epoch with no need to get num of inputs
   # Open (for reading) a file
  li $v0, 13       # system call for open file
  la $a0,buffer
  li $a1, 0        # flags
  li $a2, 0        # mode is ignored
  syscall          # open a file (file descriptor returned in $v0)

  move $t0, $v0    # save file descriptor in $t0
   
  # Read input num 
  li $v0, 14       # system call for read to file
  la $a1, coma       # address of buffer from which to write
  li $a2, 1        # hardcoded buffer length
  move $a0, $t0    # put the file descriptor in $a0
  syscall          # write to file
  
  j p3
   #---------------------------------------------------------------------------------
#---------------------------print new line---------------------------
 newline:
 move $zero,$v0
 li $v0, 4
 la $a0, line
 syscall
 move $v0,$zero
 li $zero,0
 jr $ra	  	   #return
#---------------------------------------------------------------------------------
#---------------------------remove new line from input---------------------------
remove:
    lb $a3,buffer($s0)    # Load character at index
    addi $s0,$s0,1        # Increment index
    bnez $a3,remove       # Loop until the end of string is reached
    beq $a1,$s0,skip      # Do not remove \n when string = maxlength
    subiu $s0,$s0,2       # If above not true, Backtrack index to '\n'
    sb $0, buffer($s0)    # Add the terminating character in its place
    jr $ra		  #return
skip:
#---------------------------------------------------------------------------------
#---------------------------calculate number of rows---------------------------
nrowsF:
addi $s5,$zero,1
lw $t2,inpnum
subi $t2,$t2,48
powerof2:
beqz $t2,return
mul $s5,$s5,2
subi $t2,$t2,1
j powerof2
return:
jr $ra
#---------------------------------------------------------------------------------
   #---------------------------end program---------------------------
end:
  li $v0, 10
  syscall 
#---------------------------------------------------------------------------------

