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

#---------------------------------------
#   initialize startpoint
#
# %rax	 %rcx	 %rdx	 %rsi	 %rdi	%r8
#   -     gap   h     w    ptr    -
#
#---------------------------------------

pushq   %rcx
pushq   %rdx
pushq   %rsi
        ####Stack << w | h | gap |

#get padding value at %rax
movq	%rsi, %rax	# %rax = w
andq	$0x03, %rax	# %rax : padding


#get bit length of width
leaq	(%rsi, %rsi, 2), %r8   # %r8 = 3w

#get memory address of (0,0)
subq	$0x01, %rdx	# %rdx = h-1
addq	%rax, %r8 	# ydecre = %r8 = (3w+padding) : y decrement
movq  %r8,  %rsi  # %rsi = (3w+padding)
imulq	%rdx, %rsi 	# %rsi = (h-1)*(3w+padding)
addq	%rsi, %rdi	# startp = (0,0) = (H-1,0) + %rsi
movq  $0x00, %rax # cnt = 0
