; loads DH sectors to ES:BX from drive DL
disk_info:
	push dx
	
	mov ah, 0x08
	int 0x13
	jc disk_info_error
	
	call print_hex_as_string
	mov dx, cx
	call print_hex_as_string
	
	pop dx
	;cmp dh, al
	;jne disk_info_error
	ret

disk_info_error:
	mov bx, DISK_INFO_ERROR_MSG
	call print_string
	jmp $

DISK_INFO_ERROR_MSG db "Disk read error!", 0