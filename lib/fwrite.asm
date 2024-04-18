global fwrite
%include "macros.inc"

section .text

;uint fwrite(uint fd, char* buf, uint bytes)
;Returns number of bytes written, or ERROR
;Clobbers rdx, rsi, rdi
fwrite:
	mov		rax, 1
	syscall

	mov		rdx, ERROR
	test	rax, rax
	cmovs	rax, rdx
	ret
