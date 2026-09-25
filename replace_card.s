.cpu cortex-a53
.fpu neon-fp-armv8
.equ mask, 7
.equ card_mask, 63
.equ bits_per_card, 6
.data

test_index: .asciz "index = %d\n"
test_card: .asciz "suit = %d, value = %d\n"
inputs: .asciz "%d %d"

.text
.align 2
.global replace_card
.type replace_card, %function

replace_card:
      push {fp, lr}
      add fp, sp, #4
      
      push {r0} @ fileptr at fp-8
      push {r5} @ fp-12
      push {r4} @ fp-16
      push {r10} @fp-20
      push {r6}  @ fp-24
      push {r7}
      
      mov r4, r1  @ hand at r4
      mov r5, r2  @ indices at r5
      mov r10, #0
      
      replace_loop_begin:
           cmp r5, #0
           ble replace_loop_end
           
           @ extract the next index # to be replaced
           mov r1, #mask  @ indices mask
           and r1, r1, r5
           
           mov r5, r5, LSR #3 @ update indices register
           mov r6, r1  @ r6 stores the single index
       
           @ create the opening at the proper index, so that it's 0's
            mov r0, #63   @ mask
            mov r3, #6    @ bits per hand
            sub r1, r6, #1
            mul r7, r3, r1  @ find right index location
            mov r0, r0, LSL r7
            mvn r0, r0  @ flip the bits to create the gap at the proper index
            and r4, r0, r4

            @ get next card from deck
            sub sp, sp, #4
       	    mov r2, sp
            sub sp, sp, #4
            mov r3, sp
            ldr r1, =inputs
            ldr r0, [fp, #-8]
       
            bl fscanf 
            pop {r1}
            pop {r2} 
            
            @ now we've created the opening. Set card value/suit and store it in that index
   
            mov r1, r1, LSL #4
            orr r2, r1, r2
            mov r2, r2, LSL r7
            orr r4, r4, r2
           
           add r10, r10, #1
           b replace_loop_begin
           
      replace_loop_end:
      @ return the updated hand
      mov r0, r4
      ldr r5, [fp, #-12]
      ldr r4, [fp, #-16]
      ldr r10, [fp, #-20]
      ldr r6, [fp, #-24]
      ldr r7, [fp, #-28]
      
      sub sp, fp, #4
      pop {fp, pc}
