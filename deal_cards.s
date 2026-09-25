.cpu cortex-a53
.fpu neon-fp-armv8

.data
inputs:  .asciz "%d %d"
cardfile: .asciz "deck.txt"
rw:  .asciz "r"

.text
.align 2
.global deal_cards
.type deal_cards, %function
@.global main
@.type main, %function

@main:
   @push {fp, lr}
   @add fp, sp, #4
   
   @ldr r0, =cardfile
   @ldr r1, =rw
   @bl fopen
   @bl deal_cards
   
   @sub sp, fp, #4
   @pop {fp, pc}
  
deal_cards:
    push {fp, lr}
    add fp, sp, #4
    @ r0 contains fileptr
    push {r0}  @ fp-8
    push {r4}  @ fp-12
    push {r10} @ fp-16
    
    mov r4, #0  @ stores our hand
    mov r10, #0
    
    deal_loop_start:
       cmp r10, #5  @ i < 5
       bge deal_loop_end
       
       sub sp, sp, #4
       mov r2, sp
       sub sp, sp, #4
       mov r3, sp
       ldr r1, =inputs
       ldr r0, [fp, #-8]
       
       bl fscanf
       
       @ load value into r1, suit into r2
       pop {r2}
       pop {r1}
       
       mov r3, #6
       mul r3, r3, r10  @ r3 = 6*i. 6 bits per card
       mov r1, r1, LSL r3
       orr r4, r4, r1  @ puts value in right bit location
       
       @ add 4 to get to the suit bit location
       add r3, r3, #4
       mov r2, r2, LSL r3
       orr r4, r4, r2
       
       add r10, r10, #1
       
       b deal_loop_start
       
     deal_loop_end:
     
     ldr r10, [fp, #-16]
     mov r0, r4
     ldr r4, [fp, #-12]
     
     sub sp, fp, #4
     pop {fp, pc}
 
       
       