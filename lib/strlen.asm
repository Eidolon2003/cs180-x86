global strlen

section .text

;uint strlen(char*)
;Clobbers none
strlen:
	mov		rax, -1
strlen_loop:
	inc		rax						;count chars in rax
	test	byte [rdi+rax], 0xFF	;check for null terminator
	jne		strlen_loop				;continue looping until found
	ret
