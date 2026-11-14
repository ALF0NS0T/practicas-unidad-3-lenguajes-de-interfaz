; ============================================================
; Materia  : Lenguajes de Interfaz
; Practica : Manejo de pila manual
; Alumno   : Jesus Alfonso Soto Nieto
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; ------------------------------------------------------------
; Descripcion:
;   Pide una base y una altura, las pasa por la pila a
;   CalcularArea y muestra el area. Despues comprueba dos cosas:
;   que ESP quedo igual que antes de los PUSH y que EBX conserva
;   el valor que tenia.
; ============================================================

INCLUDE Irvine32.inc

.data
msgBase     BYTE "Escribe la base: ",0
msgAltura   BYTE "Escribe la altura: ",0
msgArea     BYTE "Area = ",0
msgEspAntes BYTE "ESP antes de los PUSH       : ",0
msgEspDesp  BYTE "ESP despues de la llamada   : ",0
msgEquil    BYTE "Pila equilibrada (ESP igual): ",0
msgEbx      BYTE "EBX conservado (00012345)   : ",0
msgSi       BYTE "SI",0
msgNo       BYTE "NO",0
numBase     DWORD ?             ; base capturada
numAltura   DWORD ?             ; altura capturada
espAntes    DWORD ?             ; ESP que tenia main antes de armar la llamada

.code
; ------------------------------------------------------------
; main: captura los datos, llama a CalcularArea y verifica
; que la pila y EBX hayan quedado como estaban
; ------------------------------------------------------------
main PROC
    mov  ebx, 12345h            ; valor de prueba: debe seguir igual despues de la llamada

    mov  edx, OFFSET msgBase
    call WriteString
    call ReadDec                ; ReadDec devuelve en EAX el entero sin signo escrito
    mov  numBase, eax

    mov  edx, OFFSET msgAltura
    call WriteString
    call ReadDec
    mov  numAltura, eax

    mov  espAntes, esp          ; punto de comparacion para saber si la pila queda equilibrada

    push numBase                ; primer argumento; dentro del procedimiento queda en [EBP+12]
    push numAltura              ; segundo argumento; queda en [EBP+8]
    call CalcularArea           ; el area vuelve en EAX y RET 8 ya retiro los argumentos

    mov  edx, OFFSET msgArea
    call WriteString
    call WriteDec               ; imprime EAX, el area
    call Crlf

    mov  edx, OFFSET msgEspAntes
    call WriteString
    mov  eax, espAntes
    call WriteHex               ; ESP guardado antes de los PUSH, en hexadecimal
    call Crlf

    mov  edx, OFFSET msgEspDesp
    call WriteString
    mov  eax, esp
    call WriteHex               ; ESP actual, despues de la llamada
    call Crlf

    mov  edx, OFFSET msgEquil
    call WriteString
    cmp  esp, espAntes          ; equilibrada = ESP igual que antes de los PUSH
    jne  PilaMal
    mov  edx, OFFSET msgSi
    jmp  MostrarPila
PilaMal:
    mov  edx, OFFSET msgNo
MostrarPila:
    call WriteString            ; imprime SI o NO segun el resultado
    call Crlf

    mov  edx, OFFSET msgEbx
    call WriteString
    cmp  ebx, 12345h            ; EBX no debio cambiar dentro del procedimiento
    jne  EbxMal
    mov  edx, OFFSET msgSi
    jmp  MostrarEbx
EbxMal:
    mov  edx, OFFSET msgNo
MostrarEbx:
    call WriteString            ; imprime SI o NO segun el resultado
    call Crlf
    exit
main ENDP

; ------------------------------------------------------------
; CalcularArea
;   Entrada: base y altura en la pila (la altura se apilo al final)
;   Salida : EAX = base * altura
;   Conserva EBX y retira sus propios argumentos con RET 8
;
;   Pila despues de PUSH EBP y PUSH EBX (de direcciones altas a bajas):
;     [EBP+12]  base
;     [EBP+8]   altura
;     [EBP+4]   direccion de retorno
;     [EBP]     EBP de main
;     [EBP-4]   EBX guardado   <- ESP
; ------------------------------------------------------------
CalcularArea PROC
    push ebp                    ; guarda el EBP de main
    mov  ebp, esp               ; EBP fija el marco; los argumentos se leen con EBP, no con ESP
    push ebx                    ; EBX se usa abajo, se guarda para devolverlo igual
    mov  eax, [ebp+12]          ; base
    mov  ebx, [ebp+8]           ; altura
    imul eax, ebx               ; EAX = base * altura
    pop  ebx                    ; restaura EBX
    pop  ebp                    ; restaura EBP; en la cima queda la direccion de retorno
    ret  8                      ; regresa a main y descarta los 8 bytes de argumentos
CalcularArea ENDP

END main
