# chris.ld

OUTPUT_FORMAT(elf32-i386)

MEMORY {
    # flags rx: executable, a: allocated, i: initialized.
    # Size 440 bits
    bootloader (rxai) : ORIGIN = 0x7c00, LENGTH = 0x1B8
    # Size: 64 bits
    ptable (rai) : ORIGIN = 0x7dbe, LENGTH = 0x40
    # Size: 2 bits
    sign (rai) : ORIGIN = 0x7dfe, LENGTH = 0x02
}

SECTIONS {
    bootloader : {
        *(.bootloader)
    } > bootloader
    ptable : {
        *(.ptable)
    } > ptable
    sign : {
        *(.sign)
    } > sign
}