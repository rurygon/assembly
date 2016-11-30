/*
@Author: Rury Gonzalez
@File: Program 2
*/

    .global main
    .func main
   
main:
    BL  _scanf              @ branch to scanf procedure with return
    MOV R5, R0              @ move return value R0 to argument register R1
    BL  _scanf
    MOV R6, R0
    MOV R1, R5
    MOV R2, R6
    BL  _count_partition
    MOV R1, R5
    SUB R2, R2, #1
    BL  _count_partition
    MOV R1, R0
    MOV R2, R5
    MOV R3, R6
    BL  _printf
    B   main
 
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    MOV PC, R4
    
_scanf:
    MOV R4, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R4              @ return

_count_partition:
    CMP R1, #0
    ADDEQ R9, R9, #1
    MOVEQ PC, LR

    ADDLT R9, R9, #0
    MOVLT PC, LR

    CMP R2, #0
    ADDEQ R9, R9, #0
    MOVEQ PC, LR
   
    SUB R1, R1, R2
    BGT _count_partition
    MOV R0, R9
    MOV PC, LR

.data
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d\n\n"
