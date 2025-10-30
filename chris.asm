; chris bootloader
bits 16

global _start

section .bootloader
    _start:
        nop

section .ptable
    tmp     times 64 db 0x00

section .sign
    ; Valid bootsector signature bytes
    signature dw 0xaa55