; loads DH sectors to ES:BX from drive DL
disk_load:
	push dx
	
	mov ah, 0x42
	;mov al, dh
	;mov ch, 0x00
	;mov dh, 0x00
	;mov cl, 0x02
	
	push 0
	push 0
	push 0
	push 1
	push 0
	push bx
	movzx cx, dh
	push cx
	push 0x10
	mov si, sp
	int 0x13
	add sp, 16
	jc disk_error
	
	pop dx
	;cmp dh, al
	;jne disk_error
	ret

disk_error:
	mov dx, ax
	call print_hex_as_string
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

DISK_ERROR_MSG db "Disk read error!", 0