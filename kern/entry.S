  .text
  .globl _start
_start:
  # Choose a hart to boot
  la       a3, lottery
  li       a2, 1
  amoadd.w a3, a2, (a3)
  bnez     a3, wait

  # Setup stack for the lucky hart
  la       a3, stack0
  li       a4, 4096
  add      sp, a3, a4

  # Jump to C
  call     main

wait:
  wfi
  j        wait

  .bss
  .align 3
lottery:
  .word  0
stack0:
  .skip 4096
