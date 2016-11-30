/*
@FILE program1.s
@AUTHOR Rury
*/
 
    .global main
    .func main
   
main:
    BL  _scanf              @ branch to scanf procedure with return
    MOV R5, R0              @ move return value R0 to argument register R1
    BL  _getchar
    MOV R10, R0
    BL  _scanf
    MOV R6, R0
    BL  _compare
    B   main               @ branch to exit procedure with no return

_scanf:
    MOV R4, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R4              @ return
   
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    CMP R10, #'+'
    BEQ _sum
    CMP R10, #'-'
    BEQ _diff
    CMP R10, #'*'
    BEQ _product
    CMP R10, #'M'
    BEQ _max
    MOV PC, R4

_sum:
    MOV R4, LR
    LDR R0, =printf_str
    ADD R1, R5, R6
    BL  printf
    MOV PC, R4

_diff:
    MOV R4, LR
    LDR R0, =printf_str
    SUB R1, R5, R6
    BL  printf
    MOV PC, R4

_max:
    MOV R4, LR
    LDR R0, =printf_str
    CMP R5, R6
    MOVGE R6, R5
    MOV R1, R6
    BL  printf
    MOV PC, R4

_product:
    MOV R4, LR
    LDR R0, =printf_str
    MUL R1, R5, R6
    BL  printf
    MOV PC, R4

.data
read_char:      .ascii      " "
format_str:     .asciz      "%d"
printf_str:     .asciz      "%d \n\n"
