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
dec   %rdx	      # %rdx = h-1
addq	%rax, %r8 	# ydecre = %r8 = (3w+padding) : y decrement
movq  %r8,  %rsi  # %rsi = (3w+padding)
imulq	%rdx, %rsi 	# %rsi = (h-1)*(3w+padding)
addq	%rsi, %rdi	# startp = (0,0) = (H-1,0) + %rsi
movq  $0x00, %rax # x = 0

popq  %rsi
popq  %rdx
popq  %rcx
pushq %rdi
pushq %rdx
pushq %rsi
pushq %rcx
      #######Stack << gap | w | h |(0,0)|
movq  $0x00, %rcx # y = 0


#------------------------------------------
#
#
# %rax   %rcx    %rdx    %rsi     %rdi    %r8
#  x      y        h       w       startp   ydecre
#
#
#------------------------------------------
.L0: #check modulo
  popq  %rsi        # %rsi = gap
  pushq %rax        # store x
  pushq %rcx        # store y
  subq  %rcx, %rax  # %rax = x-y
  neg   %rax  
  idivq %rsi        # divide %rax by %rsi , modulo in  %rdx
  cmpq  $0x00, %rdx # if divided
  je  .L2 #color
  jmp .L1 #next
        ####Stack <<  y | x | w | h | (0,n) |

.L1:  #next
  movq  %rsi, %rdx  # %rdx = gap
  popq  %rcx        # %rcx = y
  popq  %rax        # %rax = x
  popq  %rsi        # %rsi = w
  inc   %rax        # x = x + 1
  cmpq  %rax, %rsi  # x < width?
  jle   .L3 # if not, y increment
  pushq %rsi        # store w
  pushq %rdx        # store gap
        ####Stack << gap | w | h | (0,n) |
  addq  $0x03, %rdi #next point
  jmp   .L0

  
.L2: #color
  movb  $0x00, (%rdi)
  movb  $0x00, 1(%rdi)
  movb  $0xff, 2(%rdi)
  jmp .L1 #next


.L3: #increment y(=decrement pointer in y direction)
  popq  %rax        # %rax = h
  popq  %rdi        # %rdi = (0, n)
  inc   %rcx        # y = y+1
  cmpq  %rcx, %rax  # y < height?
  jle   .L4 #if not, return
  
  subq  %r8,  %rdi  # %rdi = (0, n+1)
  pushq %rdi        #store (0, n+1)
  pushq %rax        #store h
  pushq %rsi        #store w
  pushq %rdx        #store gap
                ####Stack << gap | w | h | (0,n+1)
  movq  $0x00,  %rax  # x = 0
  jmp   .L0


.L4:
  ret

