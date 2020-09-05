;
; MOSS boot sector startup program
;

[org 0x7c00]

	mov bx, boot_msg

	call print_string

	jmp $

print_string:
	pusha
	mov ah, 0x0e
_print_string_loop:
	mov al, [bx]
	int 0x10
	add bx, 1
	cmp al, 0
	jne _print_string_loop
	
	popa
	ret

boot_msg:
	db 'MOSS: Booting...', 0

times 510-($-$$) db 0 ; Fill to 512 - 2 bytes

dw 0xaa55 ; OS boot sector magic string
