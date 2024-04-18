global exit

section .text

;void exit(byte)
exit:
	mov		rax, 60
	syscall
