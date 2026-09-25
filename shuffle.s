.cpu cortex-a53
.fpu neon-fp-armv8

.data
cardfile:  .asciz "deck.txt"
wr:   .asciz "w"
output:  .asciz "%d %d\n"

.text
.align 2
.global shuffle
.type shuffle, %function
     
     
shuffle:
     push {fp, lr}
     add fp, sp, #4
     
     @ shuffle() -> deck.txt
     @ fileptr = fopen("deck.txt", "w")
     ldr r0, =cardfile
     ldr r1, =wr
     bl fopen
     
     push {r0}
     
     sub sp, sp, #8  @ allocate 2 stack memory to mark card in file
     
     mov r3, #0
     str r3, [sp]
     str r3, [sp, #4]
     
     push {r4} @ save r4 so we can use it
     add r4, sp, #4
     
     push {r10}
     mov r10, #52
     mov r0, #0
     bl time
     bl srand
     
     shuffle_loop_start:
          cmp r10, #0
          ble shuffle_loop_end
          
          @ generate a card
          bl rand
          mov r1, #13
          bl mod
          add r0, r0, #1
          push {r0}  @ gen and save card value
          bl rand
          mov r1, #4
          bl mod  @ gen and save suit
          push {r0}
          
          @ check if card is in file
          ldr r1, [fp, #-32]  @ ldr suit to r1
          mov r2, r1, LSR #1  @ r2 = r1 / 2
          mov r5, r2, LSL #2  @ calculate location of flag based on its suit
          mov r0, r1
          mov r1, #2
          bl mod   @ r0 = suit % 2 aka even or odd
          mov r3, #13
          mul r3, r3, r0
          sub r3, r3, #1
          ldr r1, [fp, #-28]    @ r1 = value of card. 
          add r3, r3, r1  @ card value + bit offset if it's in the 2nd half of the register
          
          @ check bit value
          ldr r0, [r4, r5]
          
          @ r3 -> bit location
          mov r6, r3
          mov r0, r0, LSR r3  @ shifting the bit location to the front. location % 2 gives us 1 if it's flagged
          mov r1, #2
          bl mod  @ r0 = 0 or 1
          mov r3, r6
          cmp r0, #0
          bne already_in_deck
          
          @ card is not in file
          push {r5} @ which flag line
          push {r3} @ # of bits to shift
          ldr r0, [fp, #-8]  @ load fileptr
          ldr r1, =output
          ldr r2, [fp, #-28]
          ldr r3, [fp, #-32]
          
          bl fprintf
          
          sub r10, r10, #1  @ decrement # of cards left
          
          @ set flag to 1 to indicate card is in file
          mov r1, #1
          pop {r3}
          mov r1, r1, LSL r3
          pop {r2}
          mov r5, r2
          ldr r2, [r4, r2]
          orr r1, r1, r2
          @ update register
          str r1, [r4, r5]
          
          already_in_deck:
              pop {r3}
              pop {r2}
              
              b shuffle_loop_start
              
              
      shuffle_loop_end:
      
      ldr r10, [sp, #16]
      ldr r4, [sp, #20]
      
      ldr r0, [fp, #-8]
      bl fclose
      
      sub sp, fp, #4
      pop {fp, pc}
      
          
          