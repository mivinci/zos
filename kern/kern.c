#include <sbi/ecall.h>
#include <stdarg.h>
#include <stdio.h>
#include <zos/kern.h>

#define console_putc(c) sbi_ecall(SBI_EXT_0_1_CONSOLE_PUTCHAR, 0, (c), 0, 0)

void console_puts(const char *s) {
  while (s && *s)
    console_putc(*s++);
}

static char buf[1024];

int printk(const char *fmt, ...) {
  va_list ap;
  int n;

  va_start(ap, fmt);
  n = vsprintf(buf, fmt, ap);
  va_end(ap);
  console_puts(buf); /* TODO: remove sbi */
  return n;
}

void shutdown(void) { sbi_ecall(SBI_EXT_0_1_SHUTDOWN, 0, 0, 0, 0); }
