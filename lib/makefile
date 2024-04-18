runme:
	for line in *.asm; do nasm -felf64 $$line; done
	ar r mylib.a *.o

clean:
	rm mylib.a *.o

