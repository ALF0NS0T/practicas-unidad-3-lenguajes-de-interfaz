# Unidad 3. Modularización en ensamblador

Esta práctica reúne cuatro programas en MASM para x86 que usan la biblioteca Irvine32. Cada uno trabaja un tema de la unidad: llamadas entre procedimientos, el caso de una cadena vacía, el paso de parámetros por la pila y el uso de macros.

## Datos del curso

- Alumno: Jesús Alfonso Soto Nieto
- Materia: Lenguajes de Interfaz
- Docente: Dr. José Luis Medina Jiménez
- Horario: 10:00 a 11:00 am
- Institución: Instituto Tecnológico de Culiacán

## Archivos

- Procedimientos anidados: [`src/procedimientos_anidados.asm`](src/procedimientos_anidados.asm)
- Cadena vacía: [`src/cadena_vacia.asm`](src/cadena_vacia.asm)
- Pila manual: [`src/pila_manual.asm`](src/pila_manual.asm)
- Macros: [`src/macros.asm`](src/macros.asm)

---

## 1. Procedimientos anidados

### Descripción

El programa principal llama a `MostrarReporte`. Este llama a `MostrarEncabezado`, y `MostrarEncabezado` llama a `MostrarSeparador`, que es el nivel más profundo y no llama a nadie. Cada procedimiento imprime un aviso con su nombre al entrar y otro al salir, así que la pantalla deja ver el recorrido completo de las llamadas.

### Uso de la pila

Cada `CALL` guarda en la pila la dirección a la que se debe volver y cada `RET` toma esa dirección de la cima. Como las llamadas se apilan una encima de otra, los retornos se resuelven al revés: `MostrarSeparador` vuelve a `MostrarEncabezado`, este a `MostrarReporte` y por último `MostrarReporte` a `main`.

### Pruebas

El programa no pide datos, así que bastó con ejecutarlo. En pantalla aparecieron primero los tres avisos de entrada, uno por nivel y de afuera hacia adentro. Enseguida salió la línea de guiones, seguida del aviso de salida del separador. Después se imprimió el título "REPORTE DE PRUEBA" y el aviso de salida del encabezado. Cerraron el cuerpo del reporte, el aviso de salida de `MostrarReporte` y el mensaje "Fin del programa".

Los avisos de salida salieron en el orden inverso al de entrada, como se espera de una pila. Que `main` alcanzara a imprimir el mensaje final indica que el último `RET` regresó a la dirección correcta, y que el programa terminara sin errores indica que la pila quedó equilibrada.

---

## 2. Cadena vacía

### Descripción

Se le pide al usuario una cadena de hasta 80 caracteres y se envía a `LongitudCadena`. Este procedimiento recorre los bytes desde la dirección que recibe en `ESI` hasta encontrar el terminador nulo y devuelve la cuenta en `EAX`. Si el resultado es 0 se avisa que la cadena está vacía y se vuelve a pedir. Si es mayor que 0 se imprimen la longitud y la cadena capturada.

### Pruebas

Se probaron cuatro entradas.

Al presionar solo Enter, el programa mostró "La cadena esta vacia, intenta de nuevo." y volvió a pedir la cadena. Esto ocurre porque `ReadString` deja el nulo en el primer byte del buffer, y `LongitudCadena` lo encuentra de inmediato y devuelve 0. Al presionar Enter dos veces seguidas el aviso apareció dos veces y el programa siguió esperando.

Al escribir `hola`, la longitud mostrada fue 4 y se imprimió la cadena capturada. Con tres espacios la longitud fue 3: los espacios son caracteres como cualquier otro, de modo que una cadena formada solo por espacios no cuenta como vacía.

Dentro de `LongitudCadena`, `ESI` se guarda con `PUSH` al entrar y se recupera con `POP` antes del `RET`. Por eso `main` encuentra el registro con el mismo valor después de la llamada.

---

## 3. Pila manual

### Descripción

El programa pide una base y una altura, ambas enteros sin signo, y las coloca en la pila con `PUSH`, la base primero y la altura al final. Después llama a `CalcularArea`. El procedimiento fija un marco con `EBP`, lee la base en `[EBP+12]` y la altura en `[EBP+8]`, las multiplica y deja el área en `EAX`. Guarda `EBX` al empezar y lo restaura antes de salir. Termina con `RET 8`, que además de volver a `main` descarta los dos argumentos.

Al regresar, `main` imprime el área y hace dos comprobaciones: que `ESP` valga lo mismo que antes de los `PUSH` y que `EBX` conserve el valor de prueba `12345h`.

Contenido de la pila dentro de `CalcularArea`, con las direcciones más altas arriba:

| Posición | Contenido |
|---|---|
| `[EBP+12]` | base |
| `[EBP+8]` | altura |
| `[EBP+4]` | dirección de retorno a `main` |
| `[EBP]` | `EBP` de `main` |
| `[EBP-4]` | `EBX` guardado (cima de la pila) |

### Pruebas

Con base 5 y altura 3 el programa mostró `Area = 15`. Con 7 y 7 mostró 49, y con base 0 y altura 9 mostró 0.

En cada ejecución se imprimieron los dos valores de `ESP` y las respuestas de las comprobaciones. En una de ellas ambos valores fueron `0019FF74`. La dirección cambia de una ejecución a otra, y lo que cuenta es que los dos valores coincidan. Las dos respuestas fueron "SI": la pila quedó equilibrada y `EBX` siguió valiendo `12345h`.

La pila se equilibra porque los dos `PUSH` de los argumentos se compensan con el `RET 8`, y los pares `PUSH`/`POP` de `EBP` y de `EBX` dentro del procedimiento también quedan parejos. `EBX` se conserva por el `PUSH EBX` y el `POP EBX` del procedimiento.

---

## 4. Macros

### Descripción

El programa imprime dos mensajes de la cafetería, uno de bienvenida y otro de despedida, y lo hace de dos maneras. Primero usa la macro `MostrarMensaje`, que recibe como parámetro el nombre de una cadena y agrupa tres instrucciones: cargar su dirección en `EDX`, llamar a `WriteString` y llamar a `Crlf` para bajar a la línea siguiente. Después repite esas mismas tres instrucciones a mano para cada mensaje.

### Macro y procedimiento

Una macro y un procedimiento sirven para no repetir código, pero funcionan distinto. El ensamblador sustituye cada invocación de la macro por sus instrucciones antes de generar el programa, y por eso no hay `CALL` ni `RET` ni uso de la pila para llegar a ella. Un procedimiento, en cambio, existe una sola vez en memoria y se llega a él con `CALL`, como en las prácticas anteriores. En la macro, `texto` es un nombre que se reemplaza por la cadena que se escriba al invocarla.

### Pruebas

El programa no pide datos. Al ejecutarlo, la pantalla muestra cuatro líneas: el mensaje de bienvenida, el de despedida y después esos mismos dos mensajes otra vez.

Las dos primeras líneas salen de las invocaciones de la macro, cada una con una sola línea de código. Las dos últimas salen de las instrucciones escritas a mano. Como las cuatro líneas son idénticas por pares, queda claro que la macro hace lo mismo que el código repetido y que con ella cada mensaje cuesta una línea en el programa fuente.
