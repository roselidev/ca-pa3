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

pushq   %rdi
pushq   %rcx
pushq   %rdx
pushq   %rsi
        ####Stack << w | h | gap | (H-1,0)

#get padding value at %rax
movq	%rsi, %rax	# %rax = w
andq	$0x03, %rax	# %rax : padding

#get bit length of width
leaq	(%rsi, %rsi, 2), %r8   # %r8 = 3w

#get memory address of (0,0)
subq	$0x01, %rdx	# %rdx = h-1
addq	%rax, %r8 	# %r8 = (3w+padding) : y decrement
movq  %r8,  %rsi  # %rsi = (3w+padding)
imulq	%rdx, %rsi 	# %rsi = (h-1)*(3w+padding)
addq	%rsi, %rdi	 # ptr = (0,0) = (H-1,0) + %rsi : start point
movq  $0x00, %rax #cnt = 0

popq  %rsi
popq  %rdx
popq  %rcx
pushq %rdi
      #######Stack << (0,0) | (H-1,0) |

#------------------------------------------
#
#
# %rax   %rcx    %rdx    %rsi     %rdi    %r8
#  cnt    gap     h       w       startp   ydecre
#  
#
#------------------------------------------


.L1: #to Red
  movb  $0x00, (%rdi)
  movb  $0x00, 1(%rdi)
  movb  $0xff, 2(%rdi)
  inc   %rax  #cnt++

.L2: #Next point
  addq  $0x03,  %rdi # x = x+1
  subq  %r8,    %rdi # y = y-1
  cmpq  %rax, %rdx   #if cnt >= height
  jle    .L3         # End of line
  cmpq  %rdi, %rsi   #if cnt >= weight
  jle    .L3         # End of line
  jmp    .L1         #else, color next point


.L3:  #End of line
  cmpq  %rcx, %rsi  #if gap > weight
  jl    .L4         #return
  subq  %rcx, %rsi  #else, weight = weight - gap
  movq  $0x00,%rax  #cnt = 0
  popq  %rdi        #%rdi : start point of this line
  pushq %rcx 
  leaq  (%rcx,%rcx, 2), %rcx  # %rcx = 3 * gap
  addq  %rcx, %rdi  # %rdi : start point of new line
  popq  %rcx
  pushq %rdi        #store new start point
  jmp   .L1         #color it


.L4:
  ret
