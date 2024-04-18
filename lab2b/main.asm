global _start
extern exit, puts, gets, atoi, itoa

%include "macros.inc"
%define PEN		75			;Prices in cents
%define CALC	2595
%define NOTE	275
%define DISK	175

section .rodata
	prompt1 db "Please enter the number of "
	prompt1_len equ $-prompt1

	prompt2 db " purchased: "
	prompt2_len equ $-prompt2

	pens db "pens"
	pens_len equ $-pens
	calc db "calculators"
	calc_len equ $-calc
	note db "notebooks"
	note_len equ $-note
	disk db "disks"
	disk_len equ $-disk

	prompt3 db 10, "Please enter the percent discout: "
	prompt3_len equ $-prompt3

	subtotal db 10, 10, "Subtotal: $"
	subtotal_len equ $-subtotal

	discount db 10, "Discount: $"
	discount_len equ $-discount

	tax db 10, "Tax: $"
	tax_len equ $-tax

	total db 10, "Total: $"
	total_len equ $-total


%define buflen 64
section .bss
	align 64
	buf times buflen db ?


%macro	GETNUM 2
	lea		rdi, [prompt1]
	mov		rsi, prompt1_len
	call	puts

	lea		rdi, [%1]
	mov		rsi, %2
	call	puts

	lea		rdi, [prompt2]
	mov		rsi, prompt2_len
	call	puts

	lea		rdi, [buf]
	mov		rsi, buflen
	call	gets

	lea		rdi, [buf]
	mov		rsi, rax
	call	atoi
%endmacro

%macro	GETDIS 0
	lea		rdi, [prompt3]
	mov		rsi, prompt3_len
	call	puts

	lea		rdi, [buf]
	mov		rsi, buflen
	call 	gets

	lea		rdi, [buf]
	mov		rsi, rax
	call	atoi
%endmacro

section .text
_start:
	;Get input values for each item
	GETNUM	pens, pens_len
	mov		r8, rax
	GETNUM	calc, calc_len
	mov		r9, rax
	GETNUM	note, note_len
	mov		r10, rax
	GETNUM	disk, disk_len
	mov		r11, rax

	;Compute the cost by multiplying by the price
	imul 	r8, PEN
	imul 	r9, CALC
	imul 	r10, NOTE
	imul 	r11, DISK

	;Compute the subtotal in r12
	lea		rbx, [r8+r9]
	lea		rcx, [r10+r11]
	lea		r12, [rbx+rcx]

	;Get the discount value
	;Can't be greater than 100
	GETDIS
	mov		r13, 100
	cmp		rax, 100
	cmovb	r13, rax

	;Output the subtotal
	lea		rdi, [subtotal]
	mov		rsi, subtotal_len
	call	puts
	mov		rdi, r12
	lea		rsi, [buf]
	call	itoa
	lea		rdi, [buf]
	mov		rsi, rax
	call	add_decimal
	call	puts

	;Compute the discount based on a percentage of the subtotal
	;discount = (1/100) * percent * total
	imul	r13, r12
	imul	r13, 42949673
	shr		r13, 32

	;Display the discount
	lea		rdi, [discount]
	mov		rsi, discount_len
	call	puts
	mov		rdi, r13
	lea		rsi, [buf]
	call	itoa
	lea		rdi, [buf]
	mov		rsi, rax
	call	add_decimal
	call	puts

	;Apply the discount
	sub		r12, r13

	;Compute tax same way as discount
	;Tax is 7%
	imul	r14, r12, 300647711
	shr		r14, 32

	;Display tax
	lea		rdi, [tax]
	mov		rsi, tax_len
	call	puts
	mov		rdi, r14
	lea		rsi, [buf]
	call	itoa
	lea		rdi, [buf]
	mov		rsi, rax
	call	add_decimal
	call	puts

	;Apply the tax
	add		r12, r14

	;Display the total
	lea		rdi, [total]
	mov		rsi, total_len
	call	puts
	mov		rdi, r12
	lea		rsi, [buf]
	call	itoa
	lea		rdi, [buf]
	mov		rsi, rax
	call	add_decimal
	call	puts

	;Print a newline
	mov		byte [buf], 10
	lea		rdi, [buf]
	mov		rsi, 1
	call	puts

	;return 0
	xor		rdi, rdi
	call	exit


;uint add_decimal(char*, uint)
;Adds a decimal point before the final two chars
;Pads with zeros if there aren't enough be begin with
;Clobbers	rcx, rsi
;Returns in rax, but value is also in rsi
add_decimal:
	cmp		rsi, 3
	jae		add_decimal_body

	;Pad up to 3 with zeros
add_decimal_pad_loop:
	mov		rcx, rsi
add_decimal_shift_loop:
	mov		al, byte [rdi+rcx]
	mov		byte [rdi+rcx+1], al
	dec		rcx
	jns		add_decimal_shift_loop

	mov		byte [rdi], "0"
	inc		rsi
	cmp		rsi, 3
	jb		add_decimal_pad_loop

	;Move the last two digits over and add a decimal point
add_decimal_body:
	mov		al, byte [rdi+rsi-1]
	mov		byte [rdi+rsi], al
	mov		cl, byte [rdi+rsi-2]
	mov		byte [rdi+rsi-1], cl
	mov		byte [rdi+rsi-2], "."
	inc		rsi
	mov		byte [rdi+rsi], 0
	mov		rax, rsi
	ret

