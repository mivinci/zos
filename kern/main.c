#include <sbi/ecall.h>
#include <zos/task.h>
#include <zos/types.h>

#include <stdio.h>

void main(int a0, usize a1) {
  printf("[%s:%d] Hello, ZOS :)\n", current->name, a0);
  sbi_shutdown();
}

void setup_init_task(struct task *p) {
  p->parent = p;
  p->name = "init";
}
