
.text
.global main

main:
    @ Establecer direcciones para los periféricos simulados
    MOV R0, #0x1000     @ R0 = Puntero a la dirección de entrada de la tecla (KEY_ADDRESS)
    MOV R1, #0x2000     @ R1 = Puntero a la dirección del contador en pantalla (COUNTER_ADDRESS)

    @ Cargar los códigos de las teclas que nos interesan en registros
    LDR R4, =0xE048     @ R4 = Código para Flecha Arriba
    LDR R5, =0xE050     @ R5 = Código para Flecha Abajo

main_loop:
    @ 1. Leer el valor actual de la tecla
    LDR R2, [R0]        @ R2 = valor almacenado en KEY_ADDRESS (la tecla presionada)

    @ 2. Comparar con Flecha Arriba
    CMP R2, R4          @ Compara la tecla leída (R2) con el código de Flecha Arriba (R4)
    BNE check_down_arrow @ Si no es igual (Branch if Not Equal), salta a verificar Flecha Abajo

    @ Es Flecha Arriba: Incrementar el contador
    LDR R3, [R1]        @ Carga el valor actual del contador desde COUNTER_ADDRESS en R3
    ADD R3, R3, #1      @ Incrementa el contador: R3 = R3 + 1
    STR R3, [R1]        @ Guarda el nuevo valor del contador (R3) en COUNTER_ADDRESS
    B main_loop         @ Vuelve al inicio del bucle para leer la siguiente tecla

check_down_arrow:
    @ 3. Comparar con Flecha Abajo (solo si no fue Flecha Arriba)
    CMP R2, R5          @ Compara la tecla leída (R2) con el código de Flecha Abajo (R5)
    BNE main_loop       @ Si no es igual, no es una tecla válida para nosotros.
                        @ Vuelve al inicio del bucle SIN modificar el contador.

    @ Es Flecha Abajo: Decrementar el contador
    LDR R3, [R1]        @ Carga el valor actual del contador desde COUNTER_ADDRESS en R3
    SUB R3, R3, #1      @ Decrementa el contador: R3 = R3 - 1
    STR R3, [R1]        @ Guarda el nuevo valor del contador (R3) en COUNTER_ADDRESS
    B main_loop         @ Vuelve al inicio del bucle para leer la siguiente tecla

