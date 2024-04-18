global fclose

%include "macros.inc"

section .text

;uint fclose(uint fd)
;Clobbers rdi
fclose:
	mov		rax, 3
	syscall

	mov		rdi, ERROR
	test	rax, rax
	cmovs	rax, rdi
	ret
