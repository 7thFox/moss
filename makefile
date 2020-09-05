

build-boot: moss_boot.asm
	nasm moss_boot.asm -f bin -o moss_boot.bin

run: build-boot
	qemu-system-x86_64 -drive file=moss_boot.bin,format=raw,index=0,media=disk
