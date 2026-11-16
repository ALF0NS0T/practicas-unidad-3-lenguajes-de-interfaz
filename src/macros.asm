; Materia:   Lenguajes de Interfaz
; Practica:  Macros
; Alumno:    Jesus Alfonso Soto Nieto
; Horario:   10:00 a 11:00 am
; Docente:   Dr. Jose Luis Medina Jimenez
; Escuela:   Instituto Tecnologico de Culiacan (TecNM)
;
; Este programa imprime dos mensajes de dos formas distintas: con una
; macro y repitiendo las instrucciones a mano. La salida es la misma,
; pero con la macro el codigo se escribe una sola vez.

INCLUDE Irvine32.inc           

; Macro para imprimir una cadena y pasar a la linea siguiente.
; "texto" se reemplaza por el nombre de la cadena al invocarla.
MostrarMensaje MACRO texto
    mov  edx, OFFSET texto      ; WriteString lee la direccion desde EDX
    call WriteString            ; Escribe los caracteres hasta encontrar el 0
    call Crlf                   ; Baja el cursor a la linea siguiente
ENDM

.data
    ; El 0 del final marca donde termina cada cadena
    MensajeInicio BYTE "BUENOS DIAS MUCHACHOS, ESAU COMO VAMOS?", 0
    MensajeFin    BYTE "QUE VIMOS EL DIA DE AYER?", 0

.code
main PROC
    ; Con la macro: una linea por mensaje
    MostrarMensaje MensajeInicio
    MostrarMensaje MensajeFin

    ; Sin la macro: las mismas tres instrucciones, escritas dos veces
    mov  edx, OFFSET MensajeInicio
    call WriteString
    call Crlf

    mov  edx, OFFSET MensajeFin
    call WriteString
    call Crlf

    exit                        ; Regresa el control a Windows
main ENDP

END main
