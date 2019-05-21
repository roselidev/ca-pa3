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

movq	%rsi, %rax
and 	$3, %rax
leaq	(%rsi, %rsi, 2), %r8
addq  %rax, %r8

pushq %r8
pushq %rdx
pushq %rsi
pushq %rcx

dec   %rdx
imulq	%rdx, %r8
addq	%r8, %rdi
movq  %rdi, %rsi
xor %rcx, %rcx
xor %r8,  %r8

.L0:
  movq  %r8, %rax
  subq  %rcx, %rax
  xor   %rdx,%rdx
  cqto
  idivq (%rsp)
  or $0, %rdx
  jz  .L2

  leaq  (%r8, %rcx), %rax
  xor   %rdx, %rdx
  idivq (%rsp)
  or $0, %rdx
  jz  .L2
.L1:
  inc   %r8
  addq  $3, %rdi
  cmpq  %r8 , 8(%rsp)
  jg    .L0
.L3:
  inc   %rcx
  cmpq  %rcx, 16(%rsp)
  jle   .L4
  subq  24(%rsp), %rsi
  movq  %rsi, %rdi
  xor   %r8, %r8
  jmp   .L0
.L2:
  movw  $0, (%rdi)
  movb  $0xff, 2(%rdi)
  jmp .L1
.L4:
  popq %rax
  popq %rax
  popq %rax
  popq %rax
  ret

