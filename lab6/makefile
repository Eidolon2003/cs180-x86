runme: main.o
	ld main.o ~/nasm/lib/mylib.a

main.o: main.asm
	nasm -felf64 -i/home/julian/nasm/lib/ main.asm

clean:
	rm a.out *.o
