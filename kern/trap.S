#include <sbi/riscv_asm.h>
#include <zos/trap.h>

  .align 2
  .globl trap_enter
trap_enter:
  // if comming from userspace, 
  csrrw    tp,    sscratch, tp
  bnez     tp,    save_context

restore_kernel_tpsp:
  csrr     tp,    sscratch
  REG_S    sp,    TI_kern_sp(tp)

save_context:
  REG_S    sp,    TI_user_sp(tp)  // sp -> task::user_sp
  REG_L    sp,    TI_kern_sp(tp)  // sp <- task::kern_sp

  addi     sp,    sp,    -TF_SIZE
  REG_S    x0,    TF_zero(sp)
  REG_S    x1,    TF_ra(sp)
  // we save sp later.
  REG_S    x3,    TF_gp(sp)
  // we save tp later.
  REG_S    x5,    TF_t0(sp) 
  REG_S    x6,    TF_t1(sp)
  REG_S    x7,    TF_t2(sp)
  REG_S    x8,    TF_s0(sp)
  REG_S    x9,    TF_s1(sp)
  REG_S    x10,   TF_a0(sp)
  REG_S    x11,   TF_a1(sp)
  REG_S    x12,   TF_a2(sp)
  REG_S    x13,   TF_a3(sp)
  REG_S    x14,   TF_a4(sp)
  REG_S    x15,   TF_a5(sp)
  REG_S    x16,   TF_a6(sp)
  REG_S    x17,   TF_a7(sp)
  REG_S    x18,   TF_s2(sp)
  REG_S    x19,   TF_s3(sp)
  REG_S    x20,   TF_s4(sp)
  REG_S    x21,   TF_s5(sp)
  REG_S    x22,   TF_s6(sp)
  REG_S    x23,   TF_s7(sp)
  REG_S    x24,   TF_s8(sp)
  REG_S    x25,   TF_s9(sp)
  REG_S    x26,   TF_s10(sp)
  REG_S    x27,   TF_s11(sp)
  REG_S    x28,   TF_t3(sp)
  REG_S    x29,   TF_t4(sp)
  REG_S    x30,   TF_t5(sp)
  REG_S    x31,   TF_t6(sp)

  li       t0,    STATUS_SUM | STATUS_FS
  REG_L    s0,    TI_user_sp(tp)  // s0 <- task::user_sp
  csrrc    s1,    sstatus, t0     // s1 <- sstatus
  csrr     s2,    sepc            // s2 <- sepc
  csrr     s3,    scause          // s3 <- scause
  csrr     s4,    stval           // s4 <- stval
  csrr     s5,    sscratch        // s5 <- sscratch
  REG_S    s0,    TF_sp(sp)       // save trap_frame::sp
  REG_S    s1,    TF_status(sp)   // save trap_frame::status
  REG_S    s2,    TF_epc(sp)      // save trap_frame::epc
  REG_S    s3,    TF_cause(sp)    // save trap_frame::cause
  REG_S    s4,    TF_badaddr(sp)  // save trap_frame::badaddr
  REG_S    s5,    TF_tp(sp)       // save tp

  // set the sscratch register to zero so that we know a trap
  // happens from the kernel.
  csrw     sscratch, zero
  
  // trap(struct trap_frame*);
  mv       a0,    sp
  // set the address to return to when we are done handling the trap.
  la       ra,    trap_leave
  // if the cause >= 0 indicating it is an exception, jump to 1f.
  bge      s4,    zero, 1f
  // handle interrupts
  tail     do_irq

1:
  slli     t0,    s4,    3  // t0 = s4 << 3
  la       t1,    expn_vector
  add      t0,    t0,    t1

  // now we have t0 = expn_vector + cause * 8

  la       t2,    expn_vector_end
  bgeu     t0,    t2,    1f  // if t0 >= t2, jump to 1f.
  REG_L    t0,    (t0)   // load the address to jump to.
  jr       t0

1:
  tail     do_expn_unknown


  .globl trap_leave
trap_leave:
  // jump to 1f if we were trapped in kernelspace.
  REG_L    s0,    TF_status(sp)      // s0 <- trap_frame::status
  andi     s0,    s0,    STATUS_SPP
  bnez     s0,    1f

  // we were trapped in userspace.
  addi     s0,    sp,    TF_SIZE
  REG_S    s0,    TI_kern_sp(tp)  // s0 -> task::kern_sp

  // save tp into the scratch register so we can find the kernel
  // data structure again.
  csrw     sscratch,     tp

1:
  REG_L    a0,    TF_status(sp)  // a0 <- trap_frame::status

  /*
	 * The current load reservation is effectively part of the processor's
	 * state, in the sense that load reservations cannot be shared between
	 * different hart contexts.  We can't actually save and restore a load
	 * reservation, so instead here we clear any existing reservation --
	 * it's always legal for implementations to clear load reservations at
	 * any point (as long as the forward progress guarantee is kept, but
	 * we'll ignore that here).
	 *
	 * Dangling load reservations can be the result of taking a trap in the
	 * middle of an LR/SC sequence, but can also be the result of a taken
	 * forward branch around an SC -- which is how we implement CAS.  As a
	 * result we need to clear reservations between the last CAS and the
	 * jump back to the new context.  While it is unlikely the store
	 * completes, implementations are allowed to expand reservations to be
	 * arbitrarily large.
	 */
  REG_L     a2,      TF_epc(sp)         // a2 <- trap_frame::epc
  REG_SC    zero,    a2,    TF_epc(sp)  // 

  csrw      sstatus, a0  // restore sstatus
  csrw      sepc, a2     // restore sepc

  /* restore x1 ~ x31 */
  REG_L   x0,    TF_zero(sp)
  REG_L   x1,    TF_ra(sp)
  // restore sp when we are down.
  REG_L   x3,    TF_gp(sp)
  REG_L   x4,    TF_tp(sp)
  REG_L   x5,    TF_t0(sp)
  REG_L   x6,    TF_t1(sp)
  REG_L   x7,    TF_t2(sp)
  REG_L   x8,    TF_s0(sp)
  REG_L   x9,    TF_s1(sp)
  REG_L   x10,   TF_a0(sp)
  REG_L   x11,   TF_a1(sp)
  REG_L   x12,   TF_a2(sp)
  REG_L   x13,   TF_a3(sp)
  REG_L   x14,   TF_a4(sp)
  REG_L   x15,   TF_a5(sp)
  REG_L   x16,   TF_a6(sp)
  REG_L   x17,   TF_a7(sp)
  REG_L   x18,   TF_s2(sp)
  REG_L   x19,   TF_s3(sp)
  REG_L   x20,   TF_s4(sp)
  REG_L   x21,   TF_s5(sp)
  REG_L   x22,   TF_s6(sp)
  REG_L   x23,   TF_s7(sp)
  REG_L   x24,   TF_s8(sp)
  REG_L   x25,   TF_s9(sp)
  REG_L   x26,   TF_s10(sp)
  REG_L   x27,   TF_s11(sp)
  REG_L   x28,   TF_t3(sp)
  REG_L   x29,   TF_t4(sp)
  REG_L   x30,   TF_t5(sp)
  REG_L   x31,   TF_t6(sp)

  REG_L   x2,    TF_sp(sp)

  sret


  .section ".rodata"
  .align LGREG
expn_vector:
  RISCV_PTR do_expn_insn_misaligned
  RISCV_PTR do_expn_instn_fault
  RISCV_PTR do_expn_instn_illegal
  RISCV_PTR do_expn_break
  RISCV_PTR do_expn_load_misaligned
  RISCV_PTR do_expn_load_fault
  RISCV_PTR do_expn_store_misaligned
  RISCV_PTR do_expn_store_fault
  RISCV_PTR do_expn_ecall_u  // system call
  RISCV_PTR do_expn_ecall_s
  RISCV_PTR do_expn_unknown
  RISCV_PTR do_expn_ecall_m
  RISCV_PTR do_expn_page_fault
  RISCV_PTR do_expn_page_fault  // load page fault
  RISCV_PTR do_expn_unknown
  RISCV_PTR do_expn_page_fault  // store page fault
expn_vector_end:

  .text
do_expn_insn_misaligned:
do_expn_instn_fault:
do_expn_instn_illegal:
do_expn_break:
do_expn_load_misaligned:
do_expn_load_fault:
do_expn_store_misaligned:
do_expn_store_fault:
do_expn_ecall_u:
do_expn_ecall_s:
do_expn_unknown:
do_expn_ecall_m:
do_expn_page_fault:
do_irq:
1:
  j    1b
