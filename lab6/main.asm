global _start
extern exit, puts, gets, atoi, itoa
%include "macros.inc"

section .rodata
	msg db "Please enter a series of integers, seperated by spaces. Enter -99 to stop:", 10, 10
	msglen equ $-msg

	error_msg db "Invalid input", 10
	error_msglen equ $-error_msg

	lowest_msg db 10,"Lowest: "
	lowest_msglen equ $-lowest_msg

	highest_msg db 10,"Highest: "
	highest_msglen equ $-highest_msg


%define LEN 256
section .bss
	align 64
	read_buf times LEN db ?
	data_buf times LEN db ?


section .data
	input_len dq 0
	buf_ptr	db 0
	newline	times 4 db 10


section .text
flush:
	push	rax
	push	rdi
	push	rsi
	push	rdx

	cmp		qword [input_len], LEN
	jne		flush_ret

flush_loop:
	lea		rdi, [read_buf]
	mov		rsi, LEN
	call	gets
	cmp		rax, LEN
	je		flush_loop

flush_ret:
	pop		rdx
	pop		rsi
	pop		rdi
	pop		rax
	ret


getchar:
	cmp		byte [buf_ptr], 0
	jne		getchar_next

getchar_fill_buffer:
	push	rdi
	push	rsi
	push	rdx

	lea		rdi, [read_buf]
	mov		rsi, LEN
	call	gets
	mov		qword [input_len], rax

	pop		rdx
	pop		rsi
	pop		rdi

getchar_next:
	movzx	rax, byte [buf_ptr]
	mov		al, byte [read_buf + rax]
	inc		byte [buf_ptr]

	test	al, al
	jne		getchar_exit
	mov		byte [buf_ptr], 0
getchar_exit:
	ret


_start:
	;r8 will be the smallest
	mov		r8, INT64_MAX
	;r9 will be the largest
	mov		r9, INT64_MIN

	lea		rdi, [msg]
	mov		rsi, msglen
	call	puts

find_next_num:
	call	getchar

	cmp		al, "-"
	setne	bl
	cmp		al, "0"
	setl	cl
	cmp		al, "9"
	setg	dl

	or		cl, dl
	test	cl, bl
	jne		find_next_num


	xor		rcx, rcx
read_num:
	mov		byte [data_buf + rcx], al
	inc		rcx
	call	getchar

	cmp		al, " "
	setne	bl
	test	al, al
	setne	dl

	test	bl, dl
	jne		read_num
	mov		byte [data_buf + rcx], 0

;CONVERT NUM AND CHECK
	lea		rdi, [data_buf]
	mov		rsi, rcx
	call	atoi

	cmp		rax, ERROR
	je		error

	cmp		rax, -99
	je		done_reading

	cmp		rax, r8
	cmovl	r8, rax
	cmp		rax, r9
	cmovg	r9, rax

	jmp		find_next_num

error:
	lea		rdi, [error_msg]
	mov		rsi, error_msglen
	call	puts
	mov		rdi, -1
	call	exit

done_reading:
	lea		rdi, [lowest_msg]
	mov		rsi, lowest_msglen
	call	puts

	mov		rdi, r8
	lea		rsi, [data_buf]
	call	itoa

	lea		rdi, [data_buf]
	mov		rsi, rax
	call	puts

	lea		rdi, [highest_msg]
	mov		rsi, highest_msglen
	call	puts

	mov		rdi, r9
	lea		rsi, [data_buf]
	call	itoa

	lea		rdi, [data_buf]
	mov		rsi, rax
	call	puts

	lea		rdi, [newline]
	mov		rsi, 2
	call	puts

	call	flush

	xor		rdi, rdi
	call	exit
