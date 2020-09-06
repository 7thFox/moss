;
; MOSS boot sector startup program
;

[org 0x7c00]
main:
	mov [BOOT_DRIVE], dl	; Store boot drive for later

	mov bp, 0x8000		; Init Stack
	mov sp, bp

	mov bx, BOOT_MSG	; Boot message
	call print_string
	
	mov bx, 0x9000
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_load		; Load 5 sectors into 0x9000 (with es offset)

	mov dx, [0x9000] 	; print first word
	call print_hex

	mov dx, [0x9000 + 512] 	; print first word from second sector
	call print_hex

	jmp $

; Globals
BOOT_DRIVE:	db 0 
BOOT_MSG:	db 'MOSS: Booting...', 0x0A, 0x0D, 0

; Includes
%include "./boot/print_string.asm"
%include "./boot/print_hex.asm"
%include "./boot/disk_load.asm"

times 510-($-$$) db 0 ; Fill to 512 - 2 bytes

dw 0xaa55 ; OS boot sector magic string

; End BIOS boot sector load

times 256 dw 0xdada
times 256 dw 0xface
