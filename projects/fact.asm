; calculate and print factorial of n

.model small
.stack 100h

.data
    n dw 7
    nstr db 6 dup(' '),13,10,'$'

.code
.startup
    mov ax, n 
    mov bx, n
    dec bx
    loop_factorial:
        mul bx
        dec bx
        cmp bx, 0
        jne loop_factorial

    mov bx, 10 
    mov di, 5 
    loop_fill_nstr:
        mov dx, 0
        div bx 
        add dl, 48
        mov nstr[di], dl
        dec di
        cmp ax, 0
        jne loop_fill_nstr

print:
    mov dx, offset nstr
    mov ah, 09h
    int 21h


; terminate programm
mov ah, 4ch
int 21h

end