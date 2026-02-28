#include "gdt.h"

void kernel_main(void) {
    gdt_install();

    volatile char *video_memory = (volatile char*)0xB8000;

    const char *message = "Witaj w naszym wlasnym OS!";
    
    int i = 0; 
    int j = 0; // indeks znaku w wiadomości

    // Pętla wpisująca znaki na ekran
    while (message[j] != '\0') {
        video_memory[i] = message[j];     // 1 bajt: kod znaku (ASCII)
        video_memory[i+1] = 0x0A;         // 2 bajt: atrybut koloru (0x0A to jasny zielony na czarnym tle)
        j++;
        i += 2; // Pamięć wideo używa 2 bajtów na jeden znak na ekranie
    }

}