global gets
%include "macros.inc"

section .text

;uint gets(char*, uint)
;Returns the number of bytes read
;Clobbers rdx, rsi, rdi
gets:
	xor		rax, rax
	mov		rdx, rsi
	mov		rsi, rdi
	mov		rdi, STDIN
	syscall

	cmp		byte [rsi+rax-1], 10
	jne		gets_return
	dec		rax
	mov		byte [rsi+rax], 0
gets_return:
	ret
