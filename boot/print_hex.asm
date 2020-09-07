
;	DX <- 16-bit hex to print
; 	REQUIRES: print_string
print_hex:
	push ax
	push bx
	
	mov al, dh
	shr al, 4
	and al, 0x0F
	call _print_hex_make_ascii
	mov [_print_hex_data+2], al

	mov al, dh
	and al, 0x0F
	call _print_hex_make_ascii
	mov [_print_hex_data+3], al

	mov al, dl
	shr al, 4
	and al, 0x0F
	call _print_hex_make_ascii
	mov [_print_hex_data+4], al

	mov al, dl
	and al, 0x0F
	call _print_hex_make_ascii
	mov [_print_hex_data+5], al

	mov bx, _print_hex_data
	call print_string
	
	pop bx
	pop ax
	ret

_print_hex_data:
	db '0x0000', 0

_print_hex_make_ascii:
	add al, 0x30; ascii '0'
	cmp al, 0x39
	jle _print_hex_lt_A
	add al, 7; : (0x3a) => A (0x41)
_print_hex_lt_A:
	ret	
