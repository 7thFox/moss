bin:
	mkdir bin

bin/moss_boot.o: bin boot/moss_boot.asm
	nasm boot/moss_boot.asm -f elf64 -o bin/moss_boot.o

bin/multiboot_header.o: bin boot/multiboot_header.asm
	nasm boot/multiboot_header.asm -f elf64 -o bin/multiboot_header.o

bin/long_mode.o: bin boot/long_mode.asm
	nasm boot/long_mode.asm -f elf64 -o bin/long_mode.o

build: Cargo.toml
	cargo build

bin/kernel.bin: boot/linker.ld bin/moss_boot.o bin/multiboot_header.o bin/long_mode.o build
	ld -n -o bin/kernel.bin -T boot/linker.ld bin/multiboot_header.o bin/moss_boot.o bin/long_mode.o bin/x86_64-moss/debug/libmoss_kernel.a

bin/moss.iso: bin/kernel.bin boot/grub.def.cfg
	mkdir -p bin/iso/boot/grub
	cp bin/kernel.bin bin/iso/boot
	cp boot/grub.def.cfg bin/iso/boot/grub/grub.cfg
	grub-mkrescue -o bin/moss.iso bin/iso

run: bin/moss.iso
	qemu-system-x86_64 -cdrom bin/moss.iso
	
clean:
	rm -rf bin

