.cpu cortex-a53
.fpu neon-fp-armv8

.data
test: .asciz "result = %d\n"
.balign 4
x: .word 0
.text
.align 2
.global check_flush
.type check_flush, %function

check_flush:
     push {fp, lr}
     add fp, sp, #4
     
     @ r0 = start of array
     push {r0}   @ fp-8
     push {r4}   @fp-12
     push {r10}  @fp-16
     
     ldr r4, [fp, #-8] @ r4 = suits[0]
     ldr r4, [r4]

     mov r10, #1  @ cmp array indexes 1-4 with array[0]
     mov r0, #0  @ default set to false
     flush_loop_start:
         cmp r10, #5  @ if we get to the end of the array, hand is a flush
         bge hand_is_flush
         
         @ compare everything to first suit
         mov r3, r10, LSL #2
         ldr r1, [fp, #-8]
         ldr r1, [r1, r3]
         cmp r1, r4
         bne not_flush
         
         add r10, r10, #1
         b flush_loop_start
         
       hand_is_flush:
       mov r0, #1
       
       not_flush:
       
       ldr r4, [fp, #-12]
       ldr r10, [fp, #-16]
       sub sp, fp, #4
       pop {fp, pc}
 