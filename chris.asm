; chris bootloader
%include "chris.h"
bits 16

global _start

section .bootloader
    _start:
    stack:
        jmp main

    msg1:
        db "Relocating...",0x0a,0x0d,0x00
    msg2:
        db "Relocation successful",0x0a,0x0d,0x00

    print:
        push bp
        mov bp,sp
        mov si,[bp+4]

        cmp dl,0x80
        je .off
        jmp .nooff
    .off:
        add si,0x0400
    
    .nooff:
        mov ax,0x0e00
        xor bx,bx

    .loop:
        lodsb
        or al, al
        jz .end
        int 0x10
        jmp .loop
    .end:
        mov sp,bp
        pop bp
        ret

    main:
        cli
        mov ax,cs
        mov ss,ax
        mov ds,ax
        mov es,ax
        mov ax,stack
        sub ax,0x02
        mov sp,ax
        sti

        cmp byte dl,0x80
        je relocation
        jmp successful

    relocation:
        mov ax,msg1
        push ax
        call print
        sub sp,0x02

        mov si,0x7c00
        mov di,0x7800
        mov cx,0x0200
        rep movsb

        mov byte dl,0x90
        jmp 0:0x7800
        jmp halt
        
    successful:
        mov ax,msg2
        push ax
        call print
        sub sp,0x02
        jmp halt
        nop

    halt:
        hlt
    .loop:
        nop
        jmp .loop

section .ptable
    first:
        istruc partition
            at partition,   times 16 db 0x01
        iend
    second:
        istruc partition
            at partition,   times 16 db 0x02
        iend
    third:
        istruc partition
            at partition,   times 16 db 0x03
        iend
    fourth:
        istruc partition
            at partition,   times 16 db 0x04
        iend

section .sign
    ; Valid bootsector signature bytes
    signature dw 0xaa55