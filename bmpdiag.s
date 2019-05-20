#--------------------------------------------------------------
# 
#  4190.308 Computer Architecture (Spring 2019)
#
#  Project #3: Drawing diagonal lines in an image
#
#  April 24, 2019.
#
#  Jin-Soo Kim (jinsoo.kim@snu.ac.kr)
#  Systems Software & Architecture Laboratory
#  Dept. of Computer Science and Engineering
#  Seoul National University
#
#--------------------------------------------------------------

.text
	.align 4
.globl bmp_diag
	.type bmp_diag,@function

bmp_diag:
	#------------------------------------------------------------
	# Use %rax, %rcx, %rdx, %rsi, %rdi, and %r8 registers only
	#	imgptr is in %rdi
	#	width  is in %rsi
	#	height is in %rdx
	#	gap    is in %rcx
	#------------------------------------------------------------

	# --> FILL HERE <--


	# Example: Initially, the %rdi register points to the first 
	# pixel in the last row of the image.  The following three 
	# instructions change its color to red.


leaq  (%rsi, %rsi, 2), %rax
addq  %rdi, %rax
movq  %rax, %r8
subq  $0x03, %r8
subq  $0x03,  %rdi

.L2:
  addq  $0x03,  %rdi
  movb  $0x00,  (%rdi)
  movb  $0x00,  1(%rdi)
  movb  $0xff,  2(%rdi)
  cmpq  %rdi, %r8
  jg    .L2

ret

