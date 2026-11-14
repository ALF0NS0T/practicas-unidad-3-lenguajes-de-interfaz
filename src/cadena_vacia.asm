; ============================================================
; Materia  : Lenguajes de Interfaz
; Practica : Manejo de cadena vacia
; Alumno   : Jesus Alfonso Soto Nieto
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; ------------------------------------------------------------
; Descripcion:
;   Pide una cadena y cuenta sus caracteres con el procedimiento
;   LongitudCadena. Si la longitud es 0 la cadena esta vacia:
;   avisa y la pide otra vez. Si es mayor que 0, muestra la
;   longitud y la cadena capturada.
; ============================================================

INCLUDE Irvine32.inc

MAXLEN EQU 80                   ; maximo de caracteres que se leen

.data
msgPedir  BYTE "Escribe una cadena: ",0
msgVacia  BYTE "La cadena esta vacia, intenta de nuevo.",0
msgLong   BYTE "Longitud de la cadena: ",0
msgTexto  BYTE "Cadena capturada: ",0
buffer    BYTE MAXLEN+1 DUP(0)  ; MAXLEN caracteres mas un byte para el nulo final

.code
; ------------------------------------------------------------
; main: lee la cadena y decide si esta vacia o se muestra
; ------------------------------------------------------------
main PROC
Pedir:                          ; se regresa aqui mientras la cadena este vacia
    mov  edx, OFFSET msgPedir
    call WriteString            ; indicacion para el usuario
    mov  edx, OFFSET buffer     ; ReadString guarda el texto en la direccion de EDX
    mov  ecx, MAXLEN            ; ECX limita cuantos caracteres acepta
    call ReadString             ; deja la cadena en buffer terminada en nulo
    mov  esi, OFFSET buffer     ; LongitudCadena recibe la direccion de la cadena en ESI
    call LongitudCadena         ; devuelve la longitud en EAX
    cmp  eax, 0                 ; longitud 0 es cadena vacia
    jne  Mostrar                ; si tiene caracteres, pasa a mostrar el resultado
    mov  edx, OFFSET msgVacia
    call WriteString            ; avisa que no se escribio nada
    call Crlf
    jmp  Pedir                  ; vuelve a pedir la cadena
Mostrar:
    mov  edx, OFFSET msgLong
    call WriteString
    call WriteDec               ; WriteDec imprime EAX, que aun trae la longitud
    call Crlf
    mov  edx, OFFSET msgTexto
    call WriteString
    mov  edx, OFFSET buffer
    call WriteString            ; imprime la cadena tal como se capturo
    call Crlf
    exit
main ENDP

; ------------------------------------------------------------
; LongitudCadena
;   Entrada: ESI = direccion de una cadena terminada en nulo
;   Salida : EAX = numero de caracteres sin contar el nulo
;   ESI queda con el mismo valor que tenia al llamar
; ------------------------------------------------------------
LongitudCadena PROC
    push esi                    ; ESI se va a recorrer, se guarda para devolverlo intacto
    mov  eax, 0                 ; contador en cero
Contar:
    cmp  BYTE PTR [esi], 0      ; el byte actual es el nulo final?
    je   Fin                    ; si, termino; en una cadena vacia pasa desde el primer byte
    inc  eax                    ; cuenta el caracter
    inc  esi                    ; avanza al siguiente
    jmp  Contar
Fin:
    pop  esi                    ; restaura ESI
    ret
LongitudCadena ENDP

END main
