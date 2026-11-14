; ============================================================
; Materia  : Lenguajes de Interfaz
; Practica : Procedimientos anidados
; Alumno   : Jesus Alfonso Soto Nieto
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; ------------------------------------------------------------
; Descripcion:
;   main llama a MostrarReporte, este llama a MostrarEncabezado
;   y este a MostrarSeparador. Cada procedimiento imprime un
;   mensaje al entrar y otro al salir, de modo que la pantalla
;   muestra el orden de las llamadas y el orden de los regresos.
; ============================================================

INCLUDE Irvine32.inc

.data
; Avisos de entrada y salida de cada procedimiento
msgEntraReporte BYTE "Entra a MostrarReporte",0
msgEntraEnc     BYTE "Entra a MostrarEncabezado",0
msgEntraSep     BYTE "Entra a MostrarSeparador",0
msgSaleSep      BYTE "Sale de MostrarSeparador",0
msgSaleEnc      BYTE "Sale de MostrarEncabezado",0
msgSaleReporte  BYTE "Sale de MostrarReporte",0
; Texto que imprime cada nivel
linea           BYTE "----------------------",0
titulo          BYTE "REPORTE DE PRUEBA",0
cuerpo          BYTE "Cuerpo del reporte",0
msgFin          BYTE "Fin del programa",0

.code
; ------------------------------------------------------------
; main: llama al primer nivel y cierra el programa
; ------------------------------------------------------------
main PROC
    call MostrarReporte         ; CALL deja en la pila la direccion de retorno a main
    mov  edx, OFFSET msgFin     ; al volver, main sigue desde esta instruccion
    call WriteString            ; imprime el mensaje final
    call Crlf
    exit
main ENDP

; ------------------------------------------------------------
; Nivel 1: avisa que entra, llama al encabezado, imprime el
; cuerpo y avisa que sale
; ------------------------------------------------------------
MostrarReporte PROC
    mov  edx, OFFSET msgEntraReporte
    call WriteString            ; aviso de entrada
    call Crlf
    call MostrarEncabezado      ; se apila otra direccion de retorno encima de la de main
    mov  edx, OFFSET cuerpo
    call WriteString            ; el cuerpo sale hasta que el encabezado termino
    call Crlf
    mov  edx, OFFSET msgSaleReporte
    call WriteString            ; aviso de salida
    call Crlf
    ret                         ; saca de la cima la direccion de retorno a main
MostrarReporte ENDP

; ------------------------------------------------------------
; Nivel 2: avisa que entra, llama al separador, imprime el
; titulo y avisa que sale
; ------------------------------------------------------------
MostrarEncabezado PROC
    mov  edx, OFFSET msgEntraEnc
    call WriteString            ; aviso de entrada
    call Crlf
    call MostrarSeparador       ; en la pila ya hay dos retornos, este es el tercero
    mov  edx, OFFSET titulo
    call WriteString            ; el titulo sale despues de la linea de guiones
    call Crlf
    mov  edx, OFFSET msgSaleEnc
    call WriteString            ; aviso de salida
    call Crlf
    ret                         ; saca de la cima la direccion de retorno a MostrarReporte
MostrarEncabezado ENDP

; ------------------------------------------------------------
; Nivel 3: avisa que entra, imprime la linea de guiones y
; avisa que sale. No llama a nadie mas.
; ------------------------------------------------------------
MostrarSeparador PROC
    mov  edx, OFFSET msgEntraSep
    call WriteString            ; aviso de entrada
    call Crlf
    mov  edx, OFFSET linea
    call WriteString            ; linea de guiones
    call Crlf
    mov  edx, OFFSET msgSaleSep
    call WriteString            ; aviso de salida
    call Crlf
    ret                         ; saca de la cima la direccion de retorno a MostrarEncabezado
MostrarSeparador ENDP

END main
