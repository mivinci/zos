CROSS_COMPILE := riscv64-elf-

NAME   := zos
IMAGE  := $(NAME).elf
LINKER := $(NAME).ld
CC     := $(CROSS_COMPILE)gcc
LD     := $(CROSS_COMPILE)ld
QEMU   := qemu-system-riscv64

K      := kern
L      := lib
I      := include

HDRS   := $(shell find $I -name "*.h")
OBJS   := \
	$K/entry.o $K/kern.o \
	$L/vsprintf.o $L/string.o \
	init/main.o


CFLAGS := \
	-fno-builtin \
  -fno-pic \
  -fno-pie \
  -fno-stack-protector \
  -fno-omit-frame-pointer \
  -nostdlib \
  -ffreestanding \
  -mcmodel=medany \
	-Wall


QFLAGS := \
  -M virt -m 256M -nographic \
	-bios bios/fw_jump.elf \
	-smp 1


ifeq ($(DEBUG), 1)
	CFLAGS += -g
	QFLAGS += -gdb tcp::1234 -S
endif

ifeq ($(OPTM), 1)
	CFLAGS += -O2
endif


all: $(IMAGE)


%.o: %.S $(HDRS)
	$(CC) $(CFLAGS) -I $I -c -o $@ $<

%.o: %.c $(HDRS)
	$(CC) $(CFLAGS) -I $I -c -o $@ $<


$(IMAGE): $(OBJS) $(LINKER)
	$(LD) -T $(LINKER) -e _start -o $@ $(OBJS)


qemu: $(IMAGE)
	$(QEMU) $(QFLAGS) -kernel $<


.PHONY: clean
clean:
	rm $(OBJS)
