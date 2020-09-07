

bin/moss_boot.bin: boot/moss_boot.asm
	nasm boot/moss_boot.asm -f bin -o bin/moss_boot.bin

bin/kernel_entry.o: boot/kernel_entry.asm
	nasm -f elf64 -o bin/kernel_entry.o boot/kernel_entry.asm

bin/kernel.o: kernel/main.rs
	# rustc -o bin/kernel.o --emit obj --target x86_64-unknown-linux-musl --crate-type staticlib kernel/main.rs
	cargo build --target x86_64-unknown-linux-musl --target-dir bin


bin/kernel.bin: bin/kernel.o bin/kernel_entry.o
	# ld -o bin/kernel.bin -Ttext 0x1000 bin/kernel_entry.o bin/kernel.o --oformat binary
	ld -o bin/kernel.bin -Ttext 0x1000 bin/kernel_entry.o bin/x86_64-unknown-linux-musl/debug/libkernel.a --oformat binary

bin/moss.img: bin/moss_boot.bin bin/kernel.bin
	dd if=/dev/zero bs=1 count=8192 >> bin/zero.bin
	cat bin/moss_boot.bin bin/kernel.bin bin/zero.bin >> bin/moss.img
	rm bin/zero.bin

build: bin/moss.img

run: build
	qemu-system-x86_64 -drive file=bin/moss.img,format=raw,index=0,media=disk

clean:
	rm -rf bin/*

