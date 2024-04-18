global puts
%include "macros.inc"

section .text

;void puts(char*, uint)
;Clobbers rax, rdx, rsi, rdi
puts:
	mov		rax, 1
	mov		rdx, rsi
	mov		rsi, rdi
	mov		rdi, STDOUT
	syscall
	ret
