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

#---------------------------------------
#   initialize startpoint
#
# %rax	 %rcx	 %rdx	 %rsi	 %rdi	%r8
#   -     gap      h       w      ptr    -
#
#---------------------------------------

pushq   %rdi
movq	%rsi, %rax	# %rax = w
andq	$0x03, %rax	# %rax : padding
leaq	(%rsi, %rsi, 2), %rsi   # %rsi = 3w
movq	%rsi, %r8	# %r8 = 3w


subq	$0x01, %rdx	# %rdx = h-1
addq	%rax, %rsi	# %rsi = (3w+padding)
imulq	%rdx, %rsi	# %rsi = (h-1)*(3w+padding)
addq	%rsi, %rdi	#initialize ptr to (0,0) %rdi = ptr + (h-1)(3w+padding)
addq	%rax, %r8	# %r8 = 3w+padding
subq	$0x03, %rdi
addq    %r8,    %rdi
popq    %rax
#------------------------------------------
#
#
# %rax   %rcx    %rdx    %rsi               %rdi    %r8
#
#  ptr    gap     h-1   (h-1)(3w+padding)   ptr+%rsi 3w+padding
#
#------------------------------------------


.L2:
  addq  $0x03,  %rdi # x = x+1
  subq  %r8,    %rdi # y = y-1
  cmpq  %rdi, %rax
  jg    .L3
  movb  $0x00,  (%rdi)
  movb  $0x00,  1(%rdi)
  movb  $0xff,  2(%rdi)
  cmpq  %rdi, %rax
  jl    .L2



.L3:
ret

