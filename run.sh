#!/bin/bash
nasm -Wall -Ox -Ov -gdwarf -f elf main.asm #
ld -m elf_i386 main.o -o main
./main