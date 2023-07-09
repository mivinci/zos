#include <zos/zos.h>

  .text
  .globl _start
_start:
  // SBI brings us to
  // a0 == hartid
  // pc == 0x80200000
  // sp == 0x800xxxxx

  // set up boot stack for each hart.
  // sp = bootstack + PGSIZE * (hartid + 1)
  add t0, a0, 1
  li  t1, PGSIZE
  mul t0, t0, t1
  la  sp, bootstack
  add sp, sp, t0

  // disable and clear all interrupts for now.
  csrw sie, zero
  csrw sip, zero

  // set up exception vectors
  la a3, spin
  csrw stvec, a3

  // call our kernel's main function.
  jal main


spin:
  wfi
  j spin

  .bss
  .align 4  // RISC-V stack has to be 16 bytes aligned.
  .globl bootstack
bootstack:
  .skip PGSIZE * NCPU
