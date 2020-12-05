
; denumire fisier asm: max 8 lit pentru nume si 3 lit pentru extensie
; ex: abcdefgh.asm

; directiva .MODEL <model-memorie>
; parametrul <model-memorie> determina dimensiunea segmentului code si a pointerului de date
; <model-memorie> ia una dintre valorile: TINY, SMALL, COMPACT, MEDIUM, LARGE, HUGE, FLAT
.model small

; directiva .STACK [<nr-octeti>]
; cand este folosita impreuna cu directiva .MODEL defineste segmentul stiva (stack)
; si aloca un numar de octeti, in acest caz 100h (hexazecimal), reprezentand 256 octeti
; .stack 100h se foloseste cand destinatia programului este un fisier tip .exe
.stack 100h

; directiva .DATA [<segmentItem>]
; cand este folosita impreuna cu directiva .MODEL defineste un segment de date
; in acest segment de date se pot initializa variabile, etc. 
.data

    ; [<numeVariabila>] DB <valoare>, [<alti initializatori>]
    ; student_name - numele variabilei
    ; DB (Define Bytes) - defineste octeti care vor primi ca valor argumente separate de ','
    ; "Dinu Eugen Cosmin" - fiecarui caracter din sir i se va aloca corespondentul nr. ASCII
    ; 0Dh - numar hexazecimal <=> 13 (decimal) - reprezinta "carriage return ('\r')" in ASCII
    ; (\r - muta cursorul la inceputul randului)
    ; 0Ah - numar hexazecima <=> 10 (decimal) - reprezinta "linefeed ('\n')" in ASCII
    ; (\n - muta cursorul la urmatorul rand)
    ; $ - marcheaza sfarsitul unui sir ASCII
    student_name db "Dinu Eugen Cosmin", 0Dh, 0Ah, "$"

    ; <numeVariabila> DW <valoare>, [<alti initializatori>]
    ; DW (Define Word - 2 bytes) - defineste cuvant (2 octeti)
    D dw 68
    i dw 105
    n dw 110
    u dw 117

    ; operatorul <numar> DUP(<valoare>)
    ; numar - de cate ori va fi multiplicata valoarea din paranteza
    ; variabila result_str va contine un sir cu 6 spatii ' '
    result_str db 6 dup(' ')

    divisor dw 10

; directiva .CODE [<nume>] indica startul unui segment de code
.code

; indica codul de pornire al programului si marcheaza inceputul programului
.startup

    ; registrul SI (Source Index) este folosit ca index petru siruri
    ; il initializam cu valoarea 5, corespunzator ultimului index al result_str
    mov si, 5

    ; copiem terminatorul de sir ('$') la ultimul index
    mov result_str[si], '$'

    ; instructiunea DEC <dest>
    ; decrementeaza cu 1 <dest>, ceva de genul: dest = dest - 1
    ; decrementam SI aducandu-l la valoarea 4
    dec si

    ; '\n' la indexul 4
    mov result_str[si], 10
    dec si
    ; '\r' la indexul 3
    mov result_str[si], 13
    dec si
    ; in acest moment SI are valoarea 2 (de la acest i incepe scrierea cifrelor [0][1][2])

; eticheta (<label>:)
add_name:

    ; instructiunea MOV <destinatie>, <sursa>
    ; copiaza valoarea <sursa> in <destinatie>
    ; in acest caz copiaza valoarea variabilei d in registrul AX (accumulator register)
    mov ax, D

    ; instructiunea ADD <destinatie>, <sursa>
    ; aduna valoarea <sursa> la valoare <destinatie> si stocheaza rezultatul in <destinatie>
    add ax, i
    add ax, n 
    add ax, u 
    ; AX contine in acest moment suma d+i+n+u (68+105+110+117)

; aici incepe bucla care imparte valoarea din AX (suma ASCII a literelor din nume)
; la 10 cu fiecare iteratie, pentru a extrage cifrele si a le copia in result_str
loop_result:

    ; copiaza 0 in DX (data register);
    ; DX este format din 2 parti: DH (high) si DL (low), fiecare de 8 biti
    ; DX:AX formeaza deimpartitul pentru DIV
    ; dupa impartire DX va contine restul
    ; intr-o impartire repetata DX trebuie "sters" cu val. 0 (mov dx, 0)
    mov dx, 0

    ; instructiunea DIV <divizor>
    ; imparte DX:AX la divizor si returneaza catul in AX si restul in DX
    ; divisor este 10, deci DX (DL) va contine 0..9
    div divisor

    ; aduna la numarul din DL (care e 0..9) numarul ASCII al caracterului '0' (48)
    ; numarul (cifra) din DL devine caracterul cifra ASCII corespunzator
    ; ex: 3 -> '3' ( 3 +  48 = 51); codul ASCII pentru numarul 3 este 51
    add dl, '0'

    ; copiem valoarea in DX (din DL) in result_str la indexul din SI
    mov result_str[si], dl

    ; decrementam SI
    dec si

    ; instructiunea CMP <dest>, <src>
    ; compara <dest> cu <src> (compara valori numerice)
    ; in acest caz verificam daca catul din AX este 0 (ax == 0)
    cmp ax, 0

    ; instructiunea JNE <label> (Jump not Equal)
    ; rularea codului e transferata la punctul definit de <label>
    ; in acest caz: "sare" la "loop_result" data ax != 0
    jne loop_result

; aici urmeaza instructiuni care printeaza in consola
; cele 2 siruri student_name si result_str
printing:
    
    ; copiaza in AH (partea high a registrului AX) functia 09h
    ; instructiunea 09h: (WRITE STRING TO STANDARD OUTPUT) instructiune de print string
    mov ah, 09h

    ; copiaza in DX de la adresa variabilei student_name
    ; instructiunea OFFSET <varname> returneaza adresa variabilei <varname>
    ; copiem in DX valoarea de la adresa variabilei student_name
    mov dx, offset student_name

    ; instructiunea INT <X> (interrupt)
    ; genereaza intreruperea executiei curente in functie de codul <X>
    ; argumentul <X> poate lua valori intre 0..255
    ; 21h (0x21) (33 zecimal) genereaza software interrupt (instructiune recunoscuta de DOS API)
    int 21h

    mov ah, 09h
    mov dx, offset result_str
    int 21h

stop_program:
    ; prin copierea numarului 4Ch (0x4C hexazecimal, 76 zecimal) in registrul AH
    ; 4Ch - instructiune pentru API-ul DOS: determina terminarea procesului
    ; si exit cu codul citit din registrul AL
    mov ah, 4Ch
    int 21h

; directiva END informeaza assembler-ul(TASM.EXE) ca aici se termina codul sursa
end

