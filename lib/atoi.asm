global atoi

%include "macros.inc"

section .text

;int atoi(char*, uint)
;Clobbers rbx, rcx, rdx, rsi, rdi
atoi:
	xor		rax, rax				;rax is the result
	mov		rbx, 1					;rbx is the sign

	test	rdi, rdi				;check for nullptr
	je		atoi_error
	test	rsi, rsi				;check for zero len
	je		atoi_error

	lea		rsi, [rdi+rsi]			;compute the addr of the end

	cmp		byte [rdi], "-"			;check for negative
	jne		atoi_loop

	inc		rdi						;if neg skip the negative sign
	mov		rbx, -1					;and make note of the sign in rbx

atoi_loop:
	movsx	rcx, byte [rdi]			;check that the next char is a number
	cmp		rcx, "0"
	jl		atoi_error
	cmp		rcx, "9"
	jg		atoi_error

	lea		rax, [rax+rax*4]		;multiply by 10
	sal		rax, 1
	sub		rcx, "0"				;convert ascii char to number
	add		rax, rcx				;and add to result
	inc		rdi
	cmp		rdi, rsi
	jne		atoi_loop				;continue looping until end ptr is reached

	imul	rax, rbx				;multiply by sign before returning
	ret

atoi_error:
	mov		rax, ERROR
	ret
