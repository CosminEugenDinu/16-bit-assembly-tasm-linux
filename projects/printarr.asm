; 16bit asm (TASM) program to print an array of numbers

.model small
.stack 100h

.data
    ; size of following array (in bytes)
    arr_size dw 12 

    ; new array contains 6 items, each of 2 bytes (dw)
    ; at index 0 -> 10, at index 2 -> 11, so on ...
    arr dw 10, 11, 12, 13, 14, 15

    str_size dw 18 ; excluding last 3 characters ('\r','\n','$')
    ; 6 is the num of items from arr
    str_print db 6 dup('..,'), 13, 10, '$'

    divisor dw 10

.code
.startup
    ; SI (Source Index register)
    mov si, arr_size 
    ; DI (Destination Index register)
    mov di, str_size
    
    dec di ; DI is now 14 (str_print[di] points to last ',')

loop_fill_str:
    ; decrement SI with 2 => at first run SI is 10 (index 10)
    sub si, 2
    ; copy array item in AX
    mov ax, arr[si]

    loop_copy_ciphers:
        ; decrement index of arr_print
        dec di 
        mov dx, 0
        div divisor
        add dl, '0'
        mov str_print[di], dl

        cmp ax, 0
        jne loop_copy_ciphers
    
    ; jump over char ',' from str_print 
    dec di

    ; when SI is 0 (corresponding to index 0 of arr) exit loop (does not jump)
    cmp si, 0
    jne loop_fill_str

print:
    mov ah, 09h
    mov dx, offset str_print
    int 21h

stop:
    mov ah, 4ch 
    int 21h

end



