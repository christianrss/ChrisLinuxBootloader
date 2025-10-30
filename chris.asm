; chris bootloader
%include "chris.h"
bits 16

global _start

section .bootloader
    _start:
        nop

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