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

print_hex_as_string:
	pusha
	
	mov cx, 0

hex_loop:
	cmp cx, 4
	je hex_loop_end
	
	mov ax, dx
	and al, 0x000f
	add al, 0x30
	cmp al, 0x39
	jle step2
	add al, 7

step2:
	mov bx, HEX_OUT + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4
	
	add cx, 1
	jmp hex_loop

hex_loop_end:
	mov bx, HEX_OUT
	call print_string
	
	popa
	ret

HEX_OUT:
	db '0x0000', 0