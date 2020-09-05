;
; MOSS boot sector startup program
;

loop:
	jmp loop

times 510-($-$$) db 0 ; Fill to 512 - 2 bytes

dw 0xaa55 ; OS boot sector magic string
