#ifndef _ZOS_TRAP_H
#define _ZOS_TRAP_H

#define offset(i) ((i)*__SIZEOF_POINTER__)

#define TF_epc       offset(0)
#define TF_status    offset(1)
#define TF_cause     offset(2)
#define TF_badaddr   offset(3)
#define TF_origin_a0 offset(4)
#define TF_zero      offset(5)
#define TF_ra        offset(6)
#define TF_sp        offset(7)
#define TF_gp        offset(8)
#define TF_tp        offset(9)
#define TF_t0        offset(10)
#define TF_t1        offset(11)
#define TF_t2        offset(12)
#define TF_s0        offset(13)
#define TF_s1        offset(14)
#define TF_a0        offset(15)
#define TF_a1        offset(16)
#define TF_a2        offset(17)
#define TF_a3        offset(18)
#define TF_a4        offset(19)
#define TF_a5        offset(20)
#define TF_a6        offset(21)
#define TF_a7        offset(22)
#define TF_s2        offset(23)
#define TF_s3        offset(24)
#define TF_s4        offset(25)
#define TF_s5        offset(26)
#define TF_s6        offset(27)
#define TF_s7        offset(28)
#define TF_s8        offset(29)
#define TF_s9        offset(30)
#define TF_s10       offset(31)
#define TF_s11       offset(31)
#define TF_t3        offset(32)
#define TF_t4        offset(33)
#define TF_t5        offset(34)
#define TF_t6        offset(35)
#define TF_end       offset(36)

#define TI_kern_sp offset(0)
#define TI_user_sp offset(1)
#define TI_end     offset(2)

#define TF_SIZE TF_end
#define TI_SIZE TI_end

#ifndef __ASSEMBLER__

struct trap_frame {
  unsigned long epc;
  unsigned long status;
  unsigned long cause;
  unsigned long badaddr;
  unsigned long origin_a0;
  unsigned long x[32];
};

struct trap_info {
  unsigned long kern_sp;
  unsigned long user_sp;
};

#endif  // __ASSEMBLER__

#endif  // _ZOS_TRAP_H
