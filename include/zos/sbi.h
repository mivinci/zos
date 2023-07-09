#ifndef _ZOS_SBI_H
#define _ZOS_SBI_H

#define SBI_EXT_0_1_SET_TIMER              0x0
#define SBI_EXT_0_1_CONSOLE_PUTCHAR        0x1
#define SBI_EXT_0_1_CONSOLE_GETCHAR        0x2
#define SBI_EXT_0_1_CLEAR_IPI              0x3
#define SBI_EXT_0_1_SEND_IPI               0x4
#define SBI_EXT_0_1_REMOTE_FENCE_I         0x5
#define SBI_EXT_0_1_REMOTE_SFENCE_VMA      0x6
#define SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID 0x7
#define SBI_EXT_0_1_SHUTDOWN               0x8
#define SBI_EXT_BASE                       0x10
#define SBI_EXT_TIME                       0x54494D45
#define SBI_EXT_IPI                        0x735049
#define SBI_EXT_RFENCE                     0x52464E43
#define SBI_EXT_HSM                        0x48534D
#define SBI_EXT_SRST                       0x53525354
#define SBI_EXT_PMU                        0x504D55
#define SBI_EXT_DBCN                       0x4442434E
#define SBI_EXT_SUSP                       0x53555350
#define SBI_EXT_CPPC                       0x43505043

#define sbi_ecall(__eid, __fid, __a0, __a1, __a2)                              \
  ({                                                                           \
    register unsigned long a0 asm("a0") = (unsigned long)(__a0);               \
    register unsigned long a1 asm("a1") = (unsigned long)(__a1);               \
    register unsigned long a2 asm("a2") = (unsigned long)(__a2);               \
    register unsigned long a6 asm("a6") = (unsigned long)(__fid);              \
    register unsigned long a7 asm("a7") = (unsigned long)(__eid);              \
    asm volatile("ecall"                                                       \
                 : "+r"(a0)                                                    \
                 : "r"(a1), "r"(a2), "r"(a6), "r"(a7)                          \
                 : "memory");                                                  \
    a0;                                                                        \
  })

#define sbi_console_putchar(c)                                                 \
  sbi_ecall(SBI_EXT_0_1_CONSOLE_PUTCHAR, 0, (c), 0, 0)

static inline void sbi_console_puts(const char *s) {
  while (s && *s)
    sbi_console_putchar(*s++);
}

static inline void sbi_shutdown(void) {
  sbi_ecall(SBI_EXT_0_1_SHUTDOWN, 0, 0, 0, 0);
}

#endif  // _ZOS_SBI_H
