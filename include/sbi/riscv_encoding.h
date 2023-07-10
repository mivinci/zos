#ifndef _SBI_RISCV_ENCODING_H
#define _SBI_RISCV_ENCODING_H

#include <sbi/const.h>

#if __riscv_xlen == 64
#define RISCV64
#elif __riscv_xlen == 32
#define RISCV32
#else
#error "Unexpected __riscv_xlen"
#endif

#define STATUS_SIE  (_AC(1, UL) << 1)
#define STATUE_MIE  (_AC(1, UL) << 3)
#define STATUS_SPIE (_AC(1, UL) << 5)
#define STATUS_MPIE (_AC(1, UL) << 7)  // WPRI for sstatus
#define STATUS_SPP  (_AC(1, UL) << 8)
#define STATUS_MPP  (_AC(3, UL) << 11)  // WPRI for sstatus
#define STATUS_SUM  (_AC(1, UL) << 18)

#define STATUS_FS         (_AC(3, UL) << 13)
#define STATUS_FS_OFF     _AC(0, UL)
#define STATUS_FS_INITIAL (_AC(1, UL) << 13)
#define STATUS_FS_CLEAN   (_AC(1, UL) << 14)
#define STATUS_FS_DIRTY   (_AC(3, UL) << 13)

#ifdef RISCV32
#define SATP_PPN       0x3fffff
#define SATP_MODE_SV32 0x80000000
#else
#define SATP_PPN       0xfffffffffff
#define SATP_MODE_SV39 0x8000000000000000
#endif  // RISCV32

#endif  // _SBI_RISCV_ENCODING_H
