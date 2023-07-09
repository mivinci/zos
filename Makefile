K = kern
U = user
L = lib
I = include

CROSS_COMPILE = riscv64-unknown-elf-

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

CFLAGS = -fno-builtin \
         -fno-pic \
         -fno-pie \
         -fno-stack-protector \
         -fno-omit-frame-pointer \
         -nostdlib \
         -ffreestanding \
         -mcmodel=medany \
         -Wall \
         -O \
         -g

LDFLAGS =

QFLAGS = -M virt \
         -smp 3 \
				 -bios tools/fw_jump.elf \
				 -nographic

OBJS = $K/head.o \
			 $K/main.o

%.o: %.S
	$(CC) -I $I -E $< | $(AS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -I $I -c -o $@ $<

vmzos: zos.ld $(OBJS)
	$(LD) $(LDFLAGS) -T zos.ld -o $@ $(OBJS)

qemu: vmzos
	qemu-system-riscv64 $(QFLAGS) -kernel $<

qemu-gdb: vmzos
	qemu-system-riscv64 $(QFLAGS) -s -S -kernel $<

clean:
	rm $K/*.o
	rm vmzos
