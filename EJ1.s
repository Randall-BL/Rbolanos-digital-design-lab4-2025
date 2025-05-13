@ --- Sección de Datos ---
.data

@ Definición del arreglo (vamos a llamarlo 'data_array')
@ Debe tener 11 elementos para que el bucle i=0 hasta i=10 sea válido.
data_array:
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11  @ 11 valores de ejemplo.
                                            @ Puedes cambiar estos valores iniciales.
    @ Alternativamente, para reservar espacio sin inicializar:
    @ .space 44  @ 11 enteros * 4 bytes/entero = 44 bytes

@ Definición de la constante 'y' (vamos a llamarla 'y_val')
y_val:
    .word 5     @ Valor de ejemplo para y. Puedes cambiar este valor.


@ --- Sección de Código ---
.text
.global main  @ Hace la etiqueta 'main' visible como punto de entrada

@ Punto de entrada principal del programa
main:
    @ Cargar la dirección base del arreglo 'data_array' en R0
    LDR R0, =data_array

    @ Cargar el valor de la constante 'y_val' en R1
    LDR R1, =y_val      @ R1 ahora apunta a la etiqueta y_val
    LDR R1, [R1]        @ R1 ahora contiene el valor almacenado en y_val (ej: 5)

    @ Inicializar el contador del bucle 'i' (usaremos el registro R2 para 'i')
    MOV R2, #0          @ i = 0

loop_start:             @ Etiqueta de inicio del bucle
    @ Condición del bucle: iterar para i = 0, 1, ..., 10
    CMP R2, #10         @ Compara i (R2) con 10
    BGT loop_end        @ Si i > 10 (es decir, cuando R2 se convierte en 11), salta a loop_end.
                        @ Esto asegura 11 iteraciones (0, 1, 2, ..., 10).

    @ Calcular la dirección de data_array[i]
    @ Dirección = DirecciónBase(R0) + (Índice(R2) * 4 bytes_por_entero)
    LSL R3, R2, #2      @ R3 = i * 4 (calcula el desplazamiento en bytes)
    ADD R3, R0, R3      @ R3 = dirección base de data_array + desplazamiento.
                        @ Ahora R3 contiene la dirección de data_array[i].

    @ Cargar el valor de data_array[i] en R4
    LDR R4, [R3]        @ R4 = valor contenido en data_array[i]

    @ Comprobar la condición del pseudocódigo: if data_array[i] >= y_val
    CMP R4, R1          @ Compara data_array[i] (R4) con y_val (R1)
    BGE if_greater_or_equal @ Si data_array[i] >= y_val, salta a la sección de multiplicación.
                            @ BGE significa "Branch if Greater or Equal".

    @ Rama 'else' del pseudocódigo (esto se ejecuta si data_array[i] < y_val)
    ADD R5, R4, R1      @ R5 = data_array[i] (R4) + y_val (R1)
    STR R5, [R3]        @ Almacena el nuevo valor (R5) de vuelta en data_array[i]
    B loop_increment    @ Salta incondicionalmente a la sección de incremento del bucle

if_greater_or_equal:
    @ Rama 'then' del pseudocódigo (esto se ejecuta si data_array[i] >= y_val)
    MUL R5, R4, R1      @ R5 = data_array[i] (R4) * y_val (R1)
    STR R5, [R3]        @ Almacena el nuevo valor (R5) de vuelta en data_array[i]
    @ El flujo continúa naturalmente hacia loop_increment si está justo después

loop_increment:
    ADD R2, R2, #1      @ i = i + 1 (incrementa el contador del bucle)
    B loop_start        @ Vuelve al inicio del bucle para la siguiente iteración

loop_end:
    @ El programa ha terminado de procesar el arreglo.
    @ Usamos BKPT para detener el simulador y poder inspeccionar los resultados.
    BKPT
