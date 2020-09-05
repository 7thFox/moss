

build-boot: boot/moss_boot.asm
	nasm boot/moss_boot.asm -f bin -o bin/moss_boot.bin

run: build-boot
	qemu-system-x86_64 -drive file=bin/moss_boot.bin,format=raw,index=0,media=disk

clean:
	rm bin/*

