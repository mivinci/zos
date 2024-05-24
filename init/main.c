#include <zos/kern.h>

extern char _end[];

void main(int a0) {
  printk("ZOS - %d - 0x%x\n", a0, _end);
  shutdown();
}
