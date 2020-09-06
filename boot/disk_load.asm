;	DH <- # sectors
;	DL <- drive
;	BX <- ES:address
;	REQUIRES: print_string
disk_load:
	push dx
	mov ah, 0x02	; read sector function
	mov al, dh	; # sectors
	mov ch, 0x00	; Cylinder 0
	mov dh, 0x00	; Head 0
	mov cl, 0x02	; 2nd sector (after boot sector)
	
	int 0x13	
	mov bx, DISK_ERROR_MSG
	jc _disk_load_error
	pop dx
	cmp dh, al
	mov bx, NUMBER_SECTORS_ERROR
	jne _disk_load_error
	ret

NUMBER_SECTORS_ERROR:	db 'Disk read error: Number of sectors read mismatch!', 0
DISK_ERROR_MSG:		db 'Disk read error!', 0
_disk_load_error:
	call print_string
	jmp $
