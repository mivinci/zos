#include <sbi/ecall.h>

#include <stdarg.h>
#include <stdio.h>

static char buf[1024];

int printf(const char *fmt, ...) {
  int n;
  va_list ap;

  va_start(ap, fmt);
  n = vsprintf(buf, fmt, ap);
  va_end(ap);

  sbi_console_puts(buf);
  return n;
}
