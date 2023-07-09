OUTPUT_ARCH(riscv)
ENTRY(_start)

KLINK_ADDR = 0x80200000;

SECTIONS {
  . = KLINK_ADDR;

  .text : {
    *(.text)
  }
}
