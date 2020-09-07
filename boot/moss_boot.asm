;
; MOSS boot sector startup program
;

KERNEL_OFFSET equ 0x1000

[org 0x7c00]
[bits 16]
	mov [BOOT_DRIVE], dl

	mov bp, 0x9000
	mov sp, bp

	mov bx, RD_MSG
	call print_string
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_load	

	mov bx, PM_MSG
	call print_string

	call switch_to_pm

	jmp $

BOOT_DRIVE: db 0
RD_MSG: db 'Reading in additional sectors...', 0xA, 0xD, 0
PM_MSG: db 'Booting to 32-bit protected mode...', 0xA, 0xD, 0

; Includes
%include "./boot/disk_load.asm"
%include "./boot/print_string.asm"
%include "./boot/gdt.asm"
%include "./boot/switch_to_pm.asm"

[bits 32]
BEGIN_PM:
	call KERNEL_OFFSET
;	mov al, 'X'
;	mov ah, WH_ON_BLK
;	mov [VIDEO_MEM], ax

	

	jmp $

VIDEO_MEM equ 0xb8000
WH_ON_BLK equ 0x0f

times 510-($-$$) db 0 ; Fill to 512 - 2 bytes

dw 0xaa55 ; OS boot sector magic string
; End BIOS boot sector load


