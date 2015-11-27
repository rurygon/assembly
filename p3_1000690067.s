 
.global main
.func main
   
main:
    BL  _scanf
    MOV R7, R0
    MOV R0, #0              @ initialze index variable

writeloop:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a_array              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    ADD R8, R7, R0
    STR R8, [R2]            @ write the address of a[i] to a[i]
    ADD R2, R2, #4
    ADD R8, R8, #1
    NEG R8, R8
    STR R8, [R2]
    ADD R0, R0, #2          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #19              @ initialze index variable
    MOV R5, #0
sortloop:
    CMP R0, #0            @ check to see if we are done iterating
    BLT sortdone            @ exit loop if done
    LDR R1, =a_array              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    
    LDR R3, =b_array              @ get address of a
    LSL R4, R5, #2          @ multiply index*4 to get array offset
    ADD R4, R3, R4          @ R2 now has the element address
    STR R1, [R4]            @ store the array at address 
    ADD R5, R5, #1
    SUB R0, R0, #2
    B   sortloop
sortdone:
    MOV R0, #0
    MOV R5, #10 
sort2:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ sort2done            @ exit loop if done
    LDR R1, =a_array              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    
    LDR R3, =b_array              @ get address of a
    LSL R4, R5, #2          @ multiply index*4 to get array offset
    ADD R4, R3, R4          @ R2 now has the element address
    STR R1, [R4]            @ store the array at address 
    ADD R5, R5, #1
    ADD R0, R0, #2
    B   sort2
sort2done:
    MOV R0, #0
readloop:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =b_array              @ get address of a
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
    B _exit                 @ exit if done
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
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
a_array:        .skip       80
b_array:        .skip       80
format_str:     .asciz      "%d"
printf_str:     .asciz      "a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
