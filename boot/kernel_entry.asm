[bits 32]
global _start
_start:
	call main
	jmp $
[extern main]
