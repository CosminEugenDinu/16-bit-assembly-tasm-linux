; print max value from array

.model small
.stack 100h

.data
arr_len dw 15
arr_elemsize dw 2 
arr dw 12,13,21,54,23,23,23,56,75,29,43,46,36,32,19,72
max dw 12 

max_str_len dw 3
max_str db 3 dup(' '), 13, 10, '$'

.code
.startup

mov cx, 0
loop_find_max:

    mov ax, arr_elemsize
    mul cx
    mov si, ax 
    ; current element
    mov bx, arr[si] 

    cmp bx, max
    jl continue_loop 
    mov max, bx
    continue_loop:

    inc cx
    cmp cx, arr_len 
    jne loop_find_max


mov ax, max
mov bx, 10
mov si, 0 
mov di, max_str_len 
loop_max_to_str:
    sub di, 1
    ; clear remainder
    mov dx, 0
    div bx 
    add dx, 48
    mov max_str[di], dl
    cmp ax, 0
    jne loop_max_to_str


print_max:
    mov ah, 09h
    mov dx, offset max_str
    int 21h

stop:
    mov ah, 4Ch
    int 21h

end
