#
exe= main
src= main.asm
assembler= nasm

#
obj= $(patsubst %.asm,%.o,$(src))

default: main

.PHONY: main   
main:
	nasm -f elf -i main.o main.asm && gcc -m32 -o main main.o

.PHONY: clean
clean:
	rm -f *.o *.lst $(exe) *~ .*.gdb
