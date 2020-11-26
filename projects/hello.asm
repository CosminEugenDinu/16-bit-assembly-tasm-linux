; 16bit (TASM) asm hello world program

; .MODEL memory-model
; memory-model - Required parameter that determines the size of code and data pointers.
; memory-model - one of: TINY, SMALL, COMPACT, MEDIUM, LARGE, HUGE, FLAT
.model small

; .STACK ⟦size⟧
; stack 100h reserves 100h bytes for stack (applies to exe files)
.stack 100h

; .DATA section contains constants and initialized variables
.data

    ; [variable-name] define-directive initial-value [,initial-value]...
    ; DB - Define Byte - allocates 1 byte
    ; When a string appears in a db the string is broken up into each individual
    ; character automatically and stored in successive bytes. HelloString db 'Hello World', '$' 
    ; is broken up and treated as:
    ; HelloString db 'H','e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '$'
    hello db "Hello World!$"

.code
.startup

; this is label
printing:
    ; AX processor register is composed of AH (high part) and AL (lower part) (each of 8 bits)
    ; copy in AH (high part of AX) value 9
    mov ah, 9 ; or 09h (0x09) - DOS print instruction

    ; copy in DX (Data Register) from address (offset) of hello variable
    ; OFFSET <varname> returns address of <varname>
    mov dx, offset hello

    ; INT <X> (interrupt)
    ; signals current execution interruption of type 21h (0x21 or 33 decimal)
    ; <X> takes values between 0 and 255
    int 21h

stop_program:
    ; 4ch (0x4C or 76 decimal) - instruction for DOS API
    ; kill process with exit code read from AL
    mov ah, 4ch
    int 21h

; END directive informs assambler (TASM.EXE) this is the end of code file
end
