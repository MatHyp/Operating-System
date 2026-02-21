# Zmienne dla narzędzi
CC = gcc
AS = nasm
LD = ld

# Katalogi
SRC_DIR = src
INC_DIR = include
BUILD_DIR = build
ISO_DIR = $(BUILD_DIR)/isodir

# Flagi (-I$(INC_DIR) mówi kompilatorowi, gdzie są pliki .h)
CFLAGS = -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I$(INC_DIR)
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

# Ścieżki do plików wynikowych
KERNEL_BIN = $(BUILD_DIR)/myos.bin
OS_ISO = $(BUILD_DIR)/myos.iso

# Pliki obiektowe lądują w folderze build
OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o

# Domyślny cel
all: run

# Tworzenie folderu build, jeśli go nie ma
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Kompilacja plików C (z src do build)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Kompilacja plików ASM (z src do build)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Linkowanie w plik .bin
$(KERNEL_BIN): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Budowanie obrazu ISO za pomocą GRUB-a
$(OS_ISO): $(KERNEL_BIN)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/myos.bin
	cp grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(OS_ISO) $(ISO_DIR)

# Uruchamianie w QEMU
run: $(OS_ISO)
	qemu-system-i386 -cdrom $(OS_ISO)

# Sprzątanie (usuwa cały folder build)
clean:
	rm -rf $(BUILD_DIR)