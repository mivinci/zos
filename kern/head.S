#include <zos/mm.h>

  .text
  .globl _start
_start:
  // SBI brings us:
  // a0 == hartid
  // pc == 0x80200000
  // sp == 0x800xxxxx

  // disable all interrupts.
  csrw     sie,    zero
  csrw     sip,    zero

  // lets see whos lucky to boot the kernel.
  la       t0,     hart_lottery
  li       t1,     1
  amoadd.w t0,     t1,    (t0)
  bnez     t0,     wait

  // use the init_task stack for the booting
  // process.
  la       sp,     init_task + PGSIZE
  addi     sp,     sp,   -8

  // save a0 and a1 since they are used for
  // function calls.
  sw       a0,     0(sp)
  sw       a1,     4(sp)

  // set up trap vector and zero out sscratch
  // indicate that we are in kernelspace.
  la       a0,       trap_enter
  csrw     stvec,    a0
  csrw     sscratch, zero

  // set up init_task
  la       a0,   init_task
  call     setup_init_task

  // restore a0 and a1.
  lw       a1,    4(sp)
  lw       a0,    0(sp)

  // restore sp and load the address of init_task
  // to tp so that it can be accessed directly via
  // macro 'current'. then tail-call to our C main
  // function.
  addi     sp,    sp,   8
  la       tp,    init_task
  tail     main


wait:
  // TODO: how to notify other harts to wake up ??
  wfi
  j        wait


  .data
  .align   2
hart_lottery:
  .word    0


  .align   12
  .globl   init_task
init_task:
  .skip    PGSIZE
