#include <zos/sbi.h>
#include <zos/types.h>

// for now we simply output an string and shutdown it down :)

void main(int a0, usize a1) {
  sbi_console_puts("Hello, ZOS\n");
  sbi_shutdown();
}