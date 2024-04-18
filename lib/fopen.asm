global fopen

%include "macros.inc"

section .text

;uint fopen(char*, int flags, ... int mode)
;Clobbers rdi rsi rdx
fopen:
	mov		rax, 2
	syscall

	test	rax, rax
	mov		rdx, ERROR
	cmovs	rax, rdx
	ret
