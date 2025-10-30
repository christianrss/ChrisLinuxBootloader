; chris bootloader
%include "chris.h"
bits 16

global _start

section .bootloader
    _start:
    stack:
        jmp main

    str:
        db "Hello world",0x0a,0x0d,0x00

    print:
        push bp
        mov bp,sp
        mov si,[bp+4]
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
        sub sp,0x02
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

        mov ax,str
        push ax
        call print
        jmp halt
        nop

    halt:
        hlt
    .loop
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