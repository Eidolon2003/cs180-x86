global fread
%include "macros.inc"

section .text

;uint fread(uint fd, char* buf, uint bytes)
;Returns the number of bytes read, or ERROR
;0 indicates EOF
;Clobbers rdx, rsi, rdi
fread:
	xor		rax, rax
	syscall

	mov		rdx, ERROR
	test	rax, rax
	cmovs	rax, rdx
	ret

