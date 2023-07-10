#ifndef _ZOS_TASK_H
#define _ZOS_TASK_H

#include <zos/trap.h>
#include <zos/types.h>

struct task {
  struct trap_info trap_info;
  unsigned long *user_pagetable;
  struct task *parent;
  const char *name;
};

static __always_inline struct task *current_task(void) {
  register struct task *tp __asm__("tp");
  return tp;
}

#define current current_task()

#endif	// _ZOS_TASK_H
