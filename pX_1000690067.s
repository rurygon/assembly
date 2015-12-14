/*
@AUTHOR: RURY GONZALEZ
@FILE: PROGRAM FINAL
*/

.global main
.func main
   
main:
    BL  _scanf
    MOV R7, R0
    CMP R8, #9
    BEQ writedone
    LDR R1, =a_array              @ get address of a
    LSL R2, R8, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    STR R7, [R2]
    ADD R11, R11, R7
    ADD R8, R8, #1
    B   main
writedone:
    MOV R0, #0
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a_array              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    MOV R0, #0
    LDR R1, =a_array        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    MOV R9, R1
    MOV R10, R1
    ADD R0, R0, #1
    BL  minmaxsum
    MOV R1, R9
    MOV R2, R10
    MOV R3, R11
    BL _printf2
    B _exit                 @ exit if done
    
minmaxsum:
    CMP R0, #10            @ check to see if we are done iterating
    MOVEQ PC, LR            @ exit loop if done
    LDR R1, =a_array              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R7, [R2]            @ read the array at address 
    CMP R9, R7
    MOVLT R9, R7
    MOVGT R10, R7 
    ADD R0, R0, #1          @ increment index
    B   minmaxsum            @ branch to next loop iteration

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf2:
    PUSH {LR}               @ store the return address
    LDR R0, =printf2_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the s
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_scanf:
    MOV R4, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R4              @ return

.data

.balign 4
a_array:        .skip       40
format_str:     .asciz      "%d"
printf_str:     .asciz      "a[%d] = %d\n"
printf2_str:     .asciz     "Max: %d\nMin: %d\nSum: %d\n"
exit_str:       .ascii      "Terminating program.\n"
