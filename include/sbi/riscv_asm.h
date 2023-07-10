#ifndef _SBI_RISCV_ASM_H
#define _SBI_RISCV_ASM_H

#include <sbi/const.h>
#include <sbi/riscv_encoding.h>

#ifdef RISCV32
#define __REG_SEL(a, b) __STR(b)
#else
#define __REG_SEL(a, b) __STR(a)
#endif  // RISCV32

#define REG_L  __REG_SEL(ld, lw)
#define REG_S  __REG_SEL(sd, sw)
#define REG_SC __REG_SEL(sc.d, sc.w)
#define SZREG  __REG_SEL(8, 4)
#define LGREG  __REG_SEL(3, 2)

#if __SIZEOF_POINTER__ == 8
#ifdef __ASSEMBLER__
#define RISCV_PTR   .dword
#define RISCV_SZPTR 8
#define RISCV_LGPTR 3
#else
#define RISCV_PTR   ".dword"
#define RISCV_SZPTR "8"
#define RISCV_LGPTR "3"
#endif
#elif __SIZEOF_POINTER__ == 4
#ifdef __ASSEMBLER__
#define RISCV_PTR   .word
#define RISCV_SZPTR 4
#define RISCV_LGPTR 2
#else
#define RISCV_PTR   ".word"
#define RISCV_SZPTR "4"
#define RISCV_LGPTR "2"
#endif
#else
#error "Unexpected __SIZEOF_POINTER__"
#endif  // __SIZEOF_POINTER__

#endif  // _SBI_RISCV_ASM_H
