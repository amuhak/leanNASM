#!/bin/bash
nasm -Wall -Ox -Ov -gdwarf -f elf main.asm #
ld -m elf_i386 main.o -o main
./main 1 2 3 4 5 6 7 8 9 10