; 16bit asm (tasm) program to print a number

.model small
.stack 100h

.data
    ; [name] DW value - Define Word (2 bytes)
    num dw 65432 ; (max 2^16 = 65536)

    ; initialized with: "     \r\n$"
    num_str db 5 dup(' '), 13, 10, '$'

    ; 10 is used to devide num (remainder will be used to separate ciphers)
    divisor dw 10

.code
; marks the beginning of the program
.startup

    ; copy num in AX register
    mov ax, num 

    ; SI (Source Index register) is used as a pointer or index
    ; in this case 4 is the index of num_str to begin copying ciphers of num
    mov si, 4

; loop used to fill num_str with num ciphers
; num_str will be like ['6','5','4','3','2','\r','\n','$']
fill_num_str:

    ; clean DX by copying 0
    mov dx, 0

    ; DIV devides DX:AX by divisor
    ; returns quotient in AX and remainder in DX 
    ; in this case dividend is 65432 (in AX) and divisor is 10 (in divisor)
    div divisor
    
    ; now AX contains 6543 and DX contains 2

    ; convert number from DX to ASCII code of that number (by adding '0' character or 48)
    ; add dx, '0'
    add dx, 48

    ; write cipher from DL to num_str
    ; use DL instead of DX because place num_str[si] has 8bit (same as DL)
    mov num_str[si], dl

    ; decrement SI (index)
    dec si 

    ; loop condition
    ; compare value of AX with 0
    cmp ax, 0

    ; if ax is 0, don't jump again to fill_num_str
    ; JNE - Jump if not equal (AX != 0)
    jne fill_num_str


print:
    mov ah, 09h
    mov dx, offset num_str
    int 21h

stop:
    mov ah, 4ch
    int 21h

end