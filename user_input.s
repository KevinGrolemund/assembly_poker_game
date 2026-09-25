.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "Select a card to replace, or enter 0 to stop: "
input: .asciz "%d"

.text
.align 2
.global user_input
.type user_input, %function

user_input:
     push {fp, lr}
     add fp, sp, #4
     
     push {r10} @ fp-8. r10 is i
     push {r4} @ fp-12. r4 is the register that will store the user input
     mov r10, #0
     mov r4, #0
     
     get_indices_loop_start:
           cmp r10, #5
           bge get_indices_loop_end
           
           ldr r0, =prompt
           bl printf
           ldr r0, =input
           sub sp, sp, #4
           mov r1, sp
           bl scanf
           
           pop {r0}
           cmp r0, #0
           beq get_indices_loop_end
           
           mov r2, #3
           mul r2, r2, r10
           mov r0, r0, LSL r2
           orr r4, r4, r0
           
           add r10, r10, #1
           b get_indices_loop_start
           
           
     get_indices_loop_end:
     
     mov r0, r4
     ldr r10, [fp, #-8]
     ldr r4, [fp, #-12]
     
     sub sp, fp, #4
     pop {fp, pc}  
     