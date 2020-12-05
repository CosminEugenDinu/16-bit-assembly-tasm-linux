; 16bit asm (tasm) program to sum and print numbers from array

.model small
.stack 100h

.data
    arr_size dw 10
    arr dw 9, 10, 11, 12, 60

    string_size dw 3
    string db "...", 13, 10, '$'

    divisor dw 10

.code
.startup
    mov si, arr_size
    mov di, string_size
    ; instantiate AX with 0 (sum intrinsec number)
    mov ax, 0 

loop_add_total:
    sub si, 2
    add ax, arr[si]

    cmp si, 0
    jne loop_add_total

; now AX contains the total of summing numbers from arr

loop_fill_string:
    dec di
    mov dx, 0
    div divisor
    add dl, 48 ; (convert number from dl to ascii code, same as add dl, '0')
    mov string[di], dl

    cmp ax, 0
    jne loop_fill_string

print:
    mov ah, 09h
    mov dx, offset string 
    int 21h

stop:
    mov ah, 4Ch
    int 21h

end
