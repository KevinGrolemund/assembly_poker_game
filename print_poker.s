.cpu cortex-a53
.fpu neon-fp-armv8

.data
royal: .asciz "Royal Flush"
s_flush: .asciz "Straight Flush"
flush: .asciz "Flush"
straight: .asciz "Straight"
four_of_kind: .asciz "Four of a Kind"
full_house: .asciz "Full House"
three_of_kind: .asciz "Three of a Kind"
two_pair: .asciz "Two Pair"
pair: .asciz "Pair"
nothing: .asciz "nothing"
.balign 4
cards: .word 0
suits: .word 0

.text
.align 2
.global print_poker
.type print_poker, %function

print_poker:
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
        @ suits and cards arrays are set: now sort them
        ldr r0, =suits
        ldr r0, [r0]
        mov r1, #5
        bl sort
        
        ldr r0, =cards
        ldr r0, [r0]
        mov r1, #5
        bl sort
        
        @ start with looking for a flush
        ldr r0, =suits
        ldr r0, [r0]
        bl check_flush
        @ return 1 for flush, 0 for false
        cmp r0, #0
        beq not_flush
        
        @ is flush. Check if there's an ace, for potential royal flush
        ldr r0, =cards
        ldr r0, [r0]
        ldr r0, [r0]
        cmp r0, #1
        bne other_flush_type
        @ has ace. Check for cards 10-13
        ldr r0, =cards
        ldr r0, [r0]
        ldr r0, [r0, #4]  @ get cards[1]. Check if the 4 cards are a straight
        mov r1, #4        @ want to check 4 cards
        bl check_straight
        @ returns 1 for true, 0 for false
        cmp r0, #0
        beq other_flush_type
        @ else; it's a Royal Flush
        ldr r0, =royal
        bl printf
        b end_function
        
        other_flush_type:
        @ check if it's a straight flush
        ldr r0, =cards
        ldr r0, [r0]
        mov r1, #5
        bl check_straight
        cmp r0, #0
        beq regular_flush
        @ else; it's a straight flush
        ldr r0, =s_flush
        bl printf
        b end_function
        
        
        regular_flush:
        ldr r0, =flush
        bl printf
        b end_function
        
        
        not_flush:
        @ check straight first
        ldr r0, =cards
        ldr r0, [r0]
        mov r1, #5 
        bl check_straight
        cmp r0, #0
        beq not_flush_or_straight
        @ have a standard straight
        ldr r0, =straight
        bl printf
        b end_function
        
        not_flush_or_straight:
        @ call to count_poker_runs.. Returns->num runs to r0. Returns longest run to r1
        ldr r0, =cards
        ldr r0, [r0]
        bl count_poker_runs
        
        @ check for 4 of a kind, work our way down
        cmp r1, #4
        bne three_or_less
        @ have 4 of a kind
        ldr r0, =four_of_kind
        bl printf
        b end_function
        
        
        three_or_less:
        @ check if there's 3 of 1 kind
        ldr r0, =cards
        ldr r0, [r0]
        bl count_poker_runs
        cmp r1, #3
        bne two_or_less
        
        @ either have full house OR three of a kind
        ldr r0, =cards
        ldr r0, [r0]
        bl count_poker_runs
        cmp r0, #2  @ full house has highest run at 3 (r1), num runs at 2 (r0)
        bne just_three
        @ have full house
        ldr r0, =full_house
        bl printf
        b end_function
        
        
        just_three:
        ldr r0, =three_of_kind
        bl printf
        b end_function
        
        two_or_less:
        ldr r0, =cards
        ldr r0, [r0]
        bl count_poker_runs
        
        cmp r0, #2
        bne pair_or_less
        @ otherwise, have 2 pair
        ldr r0, =two_pair
        bl printf
        b end_function
        
        
        pair_or_less:
        ldr r0, =cards
        ldr r0, [r0]
        bl count_poker_runs
        cmp r0, #1
        bne no_value
        @ otherwise, have 1 pair
        ldr r0, =pair
        bl printf
        b end_function
        
        no_value:
        ldr r0, =nothing
        bl printf
        
        end_function:
        
        ldr r4, [fp, #-12]
        ldr r5, [fp, #-16]
        ldr r6, [fp, #-20]
        ldr r7, [fp, #-24]
        ldr r10, [fp, #-28]
      
             
        sub sp, fp, #4
        pop {fp, pc}
