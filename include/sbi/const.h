/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2019 Western Digital Corporation or its affiliates.
 *
 * Authors:
 *   Anup Patel <anup.patel@wdc.com>
 */

#ifndef __SBI_CONST_H__
#define __SBI_CONST_H__

/*
 * Some constant macros are used in both assembler and
 * C code.  Therefore we cannot annotate them always with
 * 'UL' and other type specifiers unilaterally.  We
 * use the following macros to deal with this.
 *
 * Similarly, _AT() will cast an expression with a type in C, but
 * leave it unchanged in asm.
 */

#ifdef __ASSEMBLER__
#define _AC(x, y) x
#define _AT(t, x) x
#else
#define _AC(x, y) (x##y)
#define _AT(t, x) ((t)(x))
#endif

#define _UL(x)  (_AC(x, UL))
#define _ULL(x) (_AC(x, ULL))

#define _BITUL(x)  (_UL(1) << (x))
#define _BITULL(x) (_ULL(1) << (x))

#ifdef __ASSEMBLER__
#define __STR(s) s
#else
#define __STR(s) #s
#endif

#endif
