include .config


# Directory Aliases

K = kern
U = user
L = lib
I = include


# Compiler & Linker

CROSS_COMPILE = riscv$(XLEN)-unknown-elf-
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
         -O


# Simulator

QEMU = qemu-system-riscv$(XLEN)

QFLAGS = -M virt \
         -smp $(SMP) \
				 -bios tools/fw_jump.elf \
				 -nographic


# Custom Configuration

ifeq ($(DEBUG), 1)
CFLAGS += -g
QFLAGS += -s -S
endif
CFLAGS += -DSMP=$(SMP)


# Object Files

OBJS = $K/head.o $K/main.o $K/console.o $K/trap.o \
       $L/string.o $L/vsprintf.o


# Targets

%.o: %.S
	$(CC) -I $I -E $< | $(AS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -I $I -c -o $@ $<

vmzos: vmzos.ld $(OBJS)
	$(LD) -T vmzos.ld -o $@ $(OBJS)

qemu: vmzos
	$(QEMU) $(QFLAGS) -kernel $<

clean:
	rm $K/*.o
	rm vmzos
