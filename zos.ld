OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS {
  . = 0x80200000;

  .text : {
    *(.text .text.*)
    . = ALIGN(8);
  }

  .rodata : {
		*(.rodata .rodata.*)
    . = ALIGN(8);
	}

  .data : {
    *(.data .data.*)
    . = ALIGN(8);
  }

  .bss : {
    *(.bss .bss.*)
    . = ALIGN(8);
  }

  . = ALIGN(0x1000);  /* Ensures the kernel is page aligned */
  _end = .;
}
