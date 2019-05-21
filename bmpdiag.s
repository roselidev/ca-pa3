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

pushq   %rcx
pushq   %rdx
pushq   %rsi

movq	%rsi, %rax
andq	$3, %rax
leaq	(%rsi, %rsi, 2), %r8
dec   %rdx
addq	%rax, %r8
movq  %r8,  %rsi
imulq	%rdx, %rsi
addq	%rsi, %rdi
movq  $0, %rax

popq  %rsi
popq  %rdx
popq  %rcx
pushq %rdi
pushq %rdx
pushq %rsi
pushq %rcx
movq  $0, %rcx # y = 0

.L0:
  popq  %rsi
  pushq %rax
  pushq %rcx
  subq  %rcx, %rax
  movq  $0x00, %rdx
  cqto
  idivq   %rsi
  cmpq  $0x00, %rdx
  je  .L2

  popq  %rcx
  popq  %rax
  pushq %rax
  pushq %rcx
  addq  %rcx, %rax
  movq  $0, %rdx
  idivq %rsi
  cmpq  $0, %rdx
  je  .L2
  jmp .L1
.L1:
  movq  %rsi, %rdx
  popq  %rcx
  popq  %rax
  popq  %rsi
  inc   %rax
  cmpq  %rax, %rsi
  jle   .L3
  pushq %rsi
  pushq %rdx
  addq  $3, %rdi
  jmp   .L0

  
.L2:
  movw  $0, (%rdi)
  movb  $0xff, 2(%rdi)
  
  jmp .L1


.L3:
  popq  %rax
  popq  %rdi
  inc   %rcx
  cmpq  %rcx, %rax
  jle   .L4
  
  subq  %r8,  %rdi
  pushq %rdi
  pushq %rax
  pushq %rsi
  pushq %rdx
  movq  $0,  %rax
  jmp   .L0


.L4:
  ret

