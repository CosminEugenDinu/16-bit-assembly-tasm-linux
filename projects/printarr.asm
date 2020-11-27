; 16bit asm (TASM) program to print an array of numbers

.model small
.stack 100h

.data
    arr_size dw 5 ; size of following array
    arr dw 11, 12, 13, 14, 15

    str_size dw 15 ; excluding last 3 characters ('\r','\n','$')
    str_print db 5 dup('..,'), 13, 10, '$'

    divisor dw 10

.code
.startup
    mov si, arr_size 

loop_fill_str:
    dec si

    ; clear DX register
    mov dx, 0

    ; mov si, arr_size
    ; mov arr_size, 3

    mov ax, arr[si] 

    ; devide DX:AX by value of divisor
    ; quotient is copied in AX and remainder in DX
    div divisor

    ; convert number from DX to corresponding ASCII number (of that cipher)
    add dx, '0'

    mov si, 0
    ; mov str[si], dl
    mov str_print[3], dl


print:
    mov ah, 09h
    mov dx, offset str_print
    int 21h

stop:
    mov ah, 4ch 
    int 21h

end



