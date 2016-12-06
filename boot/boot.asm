; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl
	
	mov bp, 0x9000
	mov sp, bp
	
	mov bx, MSG_REAL_MODE
	call print_string
	
	call load_kernel
	
	call switch_to_pm
	
	jmp $

%include "print/print_string.asm"
%include "disk/disk_load.asm"
;%include "disk/disk_info.asm"
%include "pm/gdt.asm"
%include "pm/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string
	
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call print_hex_as_string
	;call disk_info
	call disk_load
	mov dx, [KERNEL_OFFSET]
	call print_hex_as_string
	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	
	call KERNEL_OFFSET
	
	jmp $
	
; Global
BOOT_DRIVE db 0x0
MSG_REAL_MODE db "16 Real", 0
MSG_PROT_MODE db "32 PM", 0
MSG_LOAD_KERNEL db "Loading kernel...", 0

times 510-($-$$) db 0
dw 0xAA55