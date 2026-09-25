.cpu cortex-a53
.fpu neon-fp-armv8

.data 
.equ mask, 63
.equ cardmask, 15
.equ suitmask, 3
output: .asciz "%d. suit = %d, value = %d\n"
.balign 4
cards: .word 0
suits: .word 0

.text
.align 2
.global print_cards
.type print_cards, %function

print_cards:
     push {fp, lr}
     add fp, sp, #4
     
     push {r0}  @fp-8. r0 is the hand
     push {r4}  @ fp-12. r4 is tempcard
     push {r5}  
     push {r6}
     push {r7}
     push {r10}
     
     mov r4, #0
     mov r5, #63
     mov r6, #15
     mov r7, #3
     mov r10, #0
     
     @ set places for cards array
     sub sp, sp, #20
     ldr r0, =cards
     str sp, [r0]
   
     @ set places for suits array
     sub sp, sp, #20
     ldr r0, =suits
     str sp, [r0]
     
     ldr r0, [fp, #-8]
     set_arrays_loop_start:
         cmp r10, #5
         bge set_arrays_loop_end
         
         
         and r4, r0, r5  @ get the next bits to process from r0
         
         @ (tempcard & cardmask)
         mov r3, r4
         and r3, r3, r6
         
         @ store value in cards[i]
         ldr r1, =cards
         ldr r1, [r1]
         mov r2, r10, LSL #2
         str r3, [r1, r2]
         
         @ set suits[i]
         @ (tempcard >> 4) & suitmask
         mov r3, r4, LSR #4
 
         and r3, r3, r7
         ldr r1, =suits
         ldr r1, [r1]
         str r3, [r1, r2]
         
         @ r0 = r0 >> 6
         mov r0, r0, LSR #6
      
         
         add r10, r10, #1
         b set_arrays_loop_start
         
     set_arrays_loop_end:
            @ now that we have the arrays, print out the cards and suits
             mov r10, #0
             mov r5, #0
             print_loop_start:
               cmp r10, #5
                bge print_loop_end
                
                @ get cards[i] and suits[i] and print them
                ldr r0, =output
                add r1, r10, #1
                mov r5, r10, LSL #2
                ldr r2, =suits
                ldr r2, [r2]
                ldr r2, [r2, r5]
                ldr r3, =cards
                ldr r3, [r3]
                ldr r3, [r3, r5]
                bl printf
                
              add r10, r10, #1
              b print_loop_start
                
             
             print_loop_end:
             mov r0, r4
             ldr r4, [fp, #-12]
             ldr r5, [fp, #-16]
             ldr r6, [fp, #-20]
             ldr r7, [fp, #-24]
             ldr r10, [fp, #-28]
      
             
             sub sp, fp, #4
             pop {fp, pc}
 