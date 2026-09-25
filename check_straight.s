.cpu cortex-a53
.fpu neon-fp-armv8

.data
test: .asciz "%d\n"
.balign 4
x: .word 0
.text
.align 2
.global check_straight
.type check_straight, %function
@.global main
@.type main, %function

@main:
   @push {fp, lr}
   @add fp, sp, #4
   
  @ sub sp, sp, #20
    @ldr r0, =x
    @str sp, [r0]
   @ mov r1, #1
   @ str r1, [sp]
   @ mov r1, #2
   @ str r1, [sp, #4]
    @mov r1, #3
   @ str r1, [sp, #8]
    @mov r1, #4
    @str r1, [sp, #12]
    @mov r1, #5
   @ str r1, [sp, #16]
    @ldr r0, =x
    @ldr r0, [r0]
    
   @mov r1, #4
   @ldr r0, =x
    @ldr r0, [r0]
   @ bl check_straight
    
   @mov r1, r0
   @ldr r0, =test
   @ bl printf
   
   @ldr r0, [sp]
   @ldr r0, [r0]
   @mov r1, #5
   @bl print_array
   
  @ sub sp, fp, #4
  @ pop {fp, pc}
   
check_straight:
   push {fp, lr}
   add fp, sp, #4
   
   @ assumes the cards array is sorted
   push {r0} @ array at fp-8
   push {r10}  @ i
   push {r4}   @ bool value to be returned
   push {r5}
   mov r4, #0   @ default set to false
   mov r5, r1   @ r5 has size of array
   
   mov r10, #1
   
   @ start comp at beginning. Update it each loop so that it trails
   ldr r0, [fp, #-8]
   ldr r0, [r0]
   
   straight_loop_start:
         cmp r10, r5
         bge is_straight
         
         @ if (cards[i] - 1 != comp) return false
         ldr r1, [fp, #-8]
         mov r2, r10, LSL #2
         ldr r1, [r1, r2]
         sub r3, r1, #1
         cmp r0, r3
         bne not_straight
         
         @ still potential straight, update comp to cards[i] for the next loop
         mov r0, r1
         add r10, r10, #1
         b straight_loop_start 
         
         
         is_straight:
         mov r4, #1
  
         
   not_straight:
        mov r0, r4
        ldr r10, [fp, #-12]
        ldr r4, [fp, #-16]
        ldr r5, [fp, #20]
        sub sp, fp, #4
        pop {fp, pc}
 