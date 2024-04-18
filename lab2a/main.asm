global _start

extern	exit, puts, strlen, atoi, itoa
%include "macros.inc"

section .rodata
	no_args_msg	db "Missing argument", 10
	no_args_len	equ $-no_args_msg

	non_numeric_msg db "First argument must be an integer", 10
	non_numeric_len equ $-non_numeric_msg


section .bss
	align 64
	buf	times 64 db ?


section .text
_start:
	pop		rcx						;get argc
	cmp		rcx, 1					;check that we got at least one argument
	jle		no_args

	add		rsp, 8					;throw out first arg
	pop		rdi						;get pointer to second arg
	call 	strlen					;get length of second arg

	mov		rsi, rax				;convert the input to an integer
	call	atoi
	cmp		rax, ERROR				;check that atoi returned successfully
	je		non_numeric

	sub		rax, 32					;compute f to c conversion
	imul	rdi, rax, 9320676		;mult by approx 5/9
	sar		rdi, 24

	lea		rsi, [buf]				;convert back to a string
	call	itoa

	mov		byte [buf + rax], 10	;add a newline before output
	lea		rsi, [rax + 1]
	lea		rdi, [buf]
	call	puts
	xor		rdi, rdi				;return 0
	call	exit

no_args:
	lea		rdi, [no_args_msg]
	mov		rsi, no_args_len
	call	puts
	xor		rdi, rdi
	call	exit

non_numeric:
	lea		rdi, [non_numeric_msg]
	mov		rsi, non_numeric_len
	call	puts
	xor		rdi, rdi
	call	exit
