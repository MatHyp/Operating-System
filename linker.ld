ENTRY(_start)

SECTIONS
{
    /* GRUB ładuje kernel zazwyczaj od adresu 1 Megabajta wzwyż */
    . = 1M;

    /* Sekcja multiboot musi być PIERWSZA */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}