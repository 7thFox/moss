

bin/moss_boot.bin: boot/moss_boot.asm
	nasm boot/moss_boot.asm -f bin -o bin/moss_boot.bin

bin/kernel_entry.o: boot/kernel_entry.asm
	nasm -f elf64 -o bin/kernel_entry.o boot/kernel_entry.asm

bin/kernel.o: kernel/main.rs
	rustc -o bin/kernel.o --emit obj --crate-type staticlib kernel/main.rs

bin/kernel.bin: bin/kernel.o bin/kernel_entry.o
	ld -o bin/kernel.bin -Ttext 0x1000 bin/kernel_entry.o bin/kernel.o --oformat binary

bin/moss.img: bin/moss_boot.bin bin/kernel.bin
	dd if=/dev/zero bs=1 count=8192 >> bin/zero.bin
	cat bin/moss_boot.bin bin/kernel.bin bin/zero.bin >> bin/moss.img
	rm bin/zero.bin

run: bin/moss.img
	qemu-system-x86_64 -drive file=bin/moss.img,format=raw,index=0,media=disk

clean:
	rm bin/*

