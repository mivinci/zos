#ifndef _ZOS_TYPES_H
#define _ZOS_TYPES_H

#include <stddef.h>
#include <stdint.h>

struct atomic {
  int counter;
};

/* Type Aliases */

typedef struct atomic atomic_t;
typedef size_t usize;
typedef uint64_t u64;
typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;

/* clang-format off */

#define ATOMIC_INIT(c) { (c) }

/* clang-format on */

#define __packed        __attribute__((packed))
#define __noreturn      __attribute__((noreturn))
#define __aligned(x)    __attribute__((aligned(x)))
#define __always_inline inline __attribute__((always_inline))

#define likely(x)   __builtin_expect((x), 1)
#define unlikely(x) __builtin_expect((x), 0)

#endif  // _ZOS_TYPES_H
