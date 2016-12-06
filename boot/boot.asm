; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000
	mov [BOOT_DRIVE], dl
	mov bp, 0x9000
	mov sp, bp
	
	xor ax, ax
	mov bx, ax
	mov cx, ax
	mov dx, ax
	;mov cs, ax
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov si, ax
	mov di, ax
	
	mov bx, MSG_BOOTING
	call print_string
	
	call load_kernel
	
	call switch_to_pm
	
	jmp $

%include "print/print_string.asm"
%include "disk/disk_load.asm"
;%include "disk/disk_info.asm"
;%include "keyboard/keyboard.asm"
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
	call disk_load
	ret

[bits 32]
BEGIN_PM:
	call KERNEL_OFFSET
	
	jmp $
	
; Global
BOOT_DRIVE db 0
MSG_BOOTING db "Start booting DehaxOS...", 0
MSG_LOAD_KERNEL db "Loading kernel...", 0

times 446-($-$$) db 0
; Partition table
db 0x80
db 0xFE
db 0xFF
db 0xFF
db 0x0C
db 0xFE
db 0xFF
db 0xFF
dd 0x40
dd 0x01DD3FBF
times 12 dd 0

dw 0xAA55