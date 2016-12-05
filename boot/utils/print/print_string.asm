; Prints string with BIOS TTY teletype mode
print_string:
	mov ah, 0x0e
	mov si, bx
print_string_loop:
	mov al, [si]
	cmp al, 0
	je print_string_end
	int 0x10
	inc si
	jmp print_string_loop

print_string_end:
	mov al, 13
	int 0x10
	mov al, 10
	int 0x10
	ret