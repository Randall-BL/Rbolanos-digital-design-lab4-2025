@ --- Sección de Datos ---
.data

@ Para la demostración, cambia el valor de x_value y vuelve a ensamblar/ejecutar.
@ Valores sugeridos para X: 0, 5, 10.
x_value:
    .word 1         @ El número X para el cual calcular el factorial.
                    @ CAMBIA ESTE VALOR PARA CADA DEMOSTRACIÓN

factorial_result:
    .space 4        @ 4 bytes para almacenar el resultado del factorial (un entero de 32 bits)


@ --- Sección de Código ---
.text
.global main        @ Punto de entrada principal

main:
    @ Cargar el valor de X desde la memoria
    LDR R0, =x_value    @ R0 = dirección de x_value
    LDR R0, [R0]        @ R0 = contenido de x_value (este es nuestro X)

    @ R3 apuntará a donde guardaremos el resultado
    LDR R3, =factorial_result

    @ Caso base: Si X es 0 o 1, el factorial es 1.
    @ (Asumimos X no es negativo. Si X fuera <0, este código daría 1, lo cual es incorrecto para factorial)
    CMP R0, #1          @ Compara X con 1
    MOVLE R2, #1        @ Si X <= 1 (cubre X=0 y X=1), entonces el resultado (R2) es 1.
                        @ 'LE' significa Less than or Equal (Menor o Igual).
    BLE store_result    @ Si X <= 1, salta directamente a guardar el resultado.

    @ Si X > 1, procedemos con el cálculo iterativo.
    @ R1 será nuestro contador/multiplicador actual, empezando desde X.
    @ R2 acumulará el resultado factorial, empezando en 1.
    MOV R1, R0          @ R1 = contador_actual_n = X
    MOV R2, #1          @ R2 = resultado_factorial = 1

loop_multiply:
    @ resultado_factorial = resultado_factorial * contador_actual_n
    MUL R2, R2, R1

    @ Decrementa el contador_actual_n
    SUB R1, R1, #1

    @ Si contador_actual_n todavía es mayor que 0, continúa el bucle
    CMP R1, #0
    BNE loop_multiply   @ Branch if Not Equal (si R1 != 0)

store_result:
    @ Almacena el resultado final (en R2) en la ubicación de memoria factorial_result
    STR R2, [R3]

halt:
    @ Fin del programa, detener el simulador
    BKPT
    @ Alternativa:
    @ b halt @ Bucle infinito para detener