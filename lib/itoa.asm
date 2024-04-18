global itoa

section .text

;uint itoa(int, char*)
;Clobbers rbx, rcx, rdx, rsi, rdi
itoa:
	xor		rcx, rcx				;rcx is index counter
	xor		rbx, rbx				;rbx is the length
	mov		rax, rdi				;rax is the input
	mov		rdi, 10					;rdi is 10 for div later
	test	rax, rax
	jns		itoa_noneg

	mov		byte [rsi], "-"			;if the input is negative add a sign
	inc		rsi						;increment the array ptr to after the sign
	inc 	rbx						;increment the size
	neg		rax						;make rax positive for the following loop

itoa_noneg:
	xor		rdx, rdx				;divide rax by 10
	div		rdi
	add		rdx, "0"				;convert the remainder to ascii
	mov		byte [rsi+rcx], dl		;add that char to the string
	inc 	rcx
	test	rax, rax				;continue looping until the result is zero
	jne		itoa_noneg

	mov		byte [rsi+rcx], 0		;add a null terminator
	add		rbx, rcx				;compute the final length including the sign
	dec		rcx						;back up the pointer to the last digit

itoa_rev:
	mov		dl, byte [rsi+rax]		;reverse the string
	xchg	dl, byte [rsi+rcx]
	mov		byte [rsi+rax], dl
	inc		rax
	dec		rcx
	cmp		rcx, rax
	jg		itoa_rev

	mov		rax, rbx				;return the length
	ret
