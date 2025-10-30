flags:= -f elf
ldflags := -m elf_i386 -T chris.ld
NASMENV=-i include/
export NASMENV

.PHONY: clean run

all: bin/boot.img

bin:
	mkdir -p bin

bin/boot.img: bin/chris.elf | bin
	objcopy -I elf32-i386 -O binary $^ bin/chris.bin
	truncate -s %512 bin/chris.bin
	mv -f bin/chris.bin $@
	chmod 644 $@

bin/chris.elf: bin/chris.o | bin
	ld $(ldflags) $^ -o $@
	chmod 644 bin/chris.elf

bin/chris.o: chris.asm | bin
	nasm $(flags) $^ -o $@

clean:
	rm -f bin/*.o bin/*.img bin/*.elf

run: bin/boot.img
	qemu-system-i386 -hda $< -m 512
