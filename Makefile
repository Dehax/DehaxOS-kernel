C_SOURCES := $(wildcard kernel/*.c)
HEADERS := $(wildcard kernel/*.h)
INCLUDES := $(wildcard boot/utils/**/*.asm)

OBJ := $(C_SOURCES:.c=.o)

all : dehaxos.img

dehaxos.img : boot/boot.bin kernel.bin
	cat $^ > $@

kernel.bin : kernel/kernel_entry.o $(OBJ)
	ld -m elf_i386 -Ttext 0x1000 --oformat binary -o $@ $^

%.o : %.c $(HEADERS)
	gcc -m32 -masm=intel -ffreestanding -c -o $@ $^

%.o : %.asm
	nasm -f elf -o $@ $^

%.bin : %.asm $(INCLUDES)
	nasm -f bin -I./boot/utils/ -o $@ $<

clean :
	rm -fr *.bin *.o *.dis dehaxos.img
	rm -fr kernel/*.o boot/*.bin

kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
