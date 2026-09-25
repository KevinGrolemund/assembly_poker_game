.cpu cortex-a53
.fpu neon-fp-armv8

.data
test: .asciz "%d\n"
cardfile: .asciz "deck.txt"
rw:  .asciz "r"
start_out: .asciz "Starting Hand:\n"
final_hand: .asciz "\nFinal Hand:\n"
hand_value: .asciz "\nYour hand value: "
newline: .asciz "\n"

.balign 4
hand: .word 0
indices: .word 0


.text
.align 2
.global main
.type main, %function

main:
   push {fp, lr}
   add fp, sp, #4
   
   bl shuffle
  
   
   ldr r0, =cardfile
   ldr r1, =rw
   bl fopen
   push {r0}  @ fileptr saved at fp-8
   ldr r0, [fp, #-8]
   
   bl deal_cards
   
   @ save starting hand into =hand
   ldr r1, =hand
   str r0, [r1]
   
   ldr r0, =start_out
   bl printf
   
   @ load hand and print it
   ldr r0, =hand
   ldr r0, [r0]
   bl print_cards
   
   @ get user input for the indices
   ldr r0, =hand
   ldr r0, [r0]
   bl user_input
   
   @ r0->fileptr, r1->hand, r2->indices, r3->ID
   ldr r1, =hand
   ldr r1, [r1]
   mov r2, r0
   ldr r0, [fp, #-8]
   mov r3, #681
   bl replace_card
   
   @ save the updated hand
   ldr r1, =hand
   str r0, [r1]
   
   ldr r0, =final_hand
   bl printf
   
   @ print the final hand
   ldr r0, =hand
   ldr r0, [r0]
   bl print_cards
   
   ldr r0, =hand_value
   bl printf
   
   @ print hand value
   ldr r0, =hand
   ldr r0, [r0]
   bl print_poker
   
   ldr r0, =newline
   bl printf
   
   @ fclose
   ldr r0, [fp, #-8]
   bl fclose
   
   sub sp, fp, #4
   pop {fp, pc}
  
  