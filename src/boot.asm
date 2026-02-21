; Deklaracja stałych dla nagłówka Multiboot
MBALIGN  equ  1 << 0            ; Wyrównanie modułów
MEMINFO  equ  1 << 1            ; Prośba o mapę pamięci RAM od GRUBa
FLAGS    equ  MBALIGN | MEMINFO ; Flagi Multiboot
MAGIC    equ  0x1BADB002        ; Magiczna liczba (sygnatura Multiboot 1)
CHECKSUM equ -(MAGIC + FLAGS)   ; Suma kontrolna

; Sekcja nagłówka (musi być na początku pliku binarnego)
section .multiboot
align 4
dd MAGIC
dd FLAGS
dd CHECKSUM

; Zarezerwowanie miejsca na stos (Stack) - bez tego C nie zadziała
section .bss
align 16
stack_bottom:
resb 16384 ; 16 KB stosu
stack_top:

; Główny kod startowy
section .text
global _start
extern kernel_main ; Szukaj tej funkcji w kodzie C

_start:
    ; Ustawienie wskaźnika stosu
    mov esp, stack_top

    ; Skok do Waszego systemu!
    call kernel_main

    ; Jeśli kernel z jakiegoś powodu zakończy działanie (wyjdzie z funkcji),
    ; wyłączamy przerwania (cli) i zatrzymujemy procesor (hlt) w nieskończonej pętli.
    cli
.hang:
    hlt
    jmp .hang