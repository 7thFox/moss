[bits 16]
;	BX <- ADDR string
print_string:
	pusha
	mov ah, 0x0e
_print_string_loop:
	mov al, [bx]
	cmp al, 0
	je _print_string_end
	int 0x10
	add bx, 1
	jmp _print_string_loop
_print_string_end:
	popa
	ret
