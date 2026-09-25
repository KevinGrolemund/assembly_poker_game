.cpu cortex-a53
.fpu neon-fp-armv8

.data
run_outp: .asciz "Run length: %d\n"
count_outp: .asciz "Total number of runs: %d\n"
test: .asciz "%d %d\n"
.balign 4
x: .word 0
count: .word 0
run_length: .word 1

.text
.align 2
.global count_poker_runs
.type count_run, %function
@.global main
@.type main, %function

@main:
    @push {fp, lr}
    @add fp, sp, #4
    
   @ sub sp, sp, #20
    @ldr r0, =x
   @ str sp, [r0]
   @ mov r1, #1
   @ str r1, [sp]
   @ mov r1, #2
    @str r1, [sp, #4]
    @mov r1, #2
    @str r1, [sp, #8]
    @mov r2, #4
    @str r2, [sp, #12]
    @mov r2, #8
    @str r2, [sp, #16]
    @ldr r0, =x
    @ldr r0, [r0]
   @ bl count_poker_runs
   @ mov r2, r1
    @mov r1, r0
    @ldr r0, =test
    @bl printf
    
    @sub sp, fp, #4
   @ pop {fp, pc}
    

count_poker_runs:
    push {fp, lr}
    add fp, sp, #4
    @ r0 has dice_array[0]
    push {r0}  @ fp #-8
    push {r4}  @ fp #-12
    push {r5}  @ fp #-16
    push {r10} @ fp #-20
    push {r6}
    
    ldr r4, =count
    ldr r4, [r4]      @ r4 = count
    ldr r5, =run_length
    ldr r5, [r5]      @ r5 = run_length
    
    mov r10, #0      @ i = 1
    mov r6, #0     @ r6 will track highest run length
    
    count_for_loop_start:
        cmp r10, #5
        bge count_for_loop_end
        add r10, r10, #1    @ i++
        ldr r0, [fp, #-8]   @ r0 = dice_array[0]
        mov r2, r10
        mov r2, r2, LSL #2  @ r2 = byte offset of i
        ldr r0, [r0, r2]    @ r0 = dice_array[i]
        
        sub r2, r2, #4   @ get index below dice_array[i]
        
        ldr r1, [fp, #-8]
        ldr r1, [r1, r2]
        
        cmp r0, r1
        @ if dice_array[i] == dice_array[i - 1], run_length++
        bne next_if
        add r5, r5, #1
        @ continue loop to check if run continues
        b count_for_loop_start
        
        next_if:
        @ either the run ended or there's no run
           cmp r5, #1
           @ if run_length <= 1, continue loop
           ble else
         
           @ otherwise, count++. Check if this run > r6. If so, update r6. Tracks longest run
           add r4, r4, #1
           cmp r5, r6
           ble else
           
           mov r6, r5
           
      else:
         mov r5, #1
         b count_for_loop_start
        
       
   count_for_loop_end:
   @ return count and highest run length
         mov r0, r4
         mov r1, r6
         
         pop {r6}
         pop {r10}
         pop {r5}
         pop {r4}
         
         sub sp, fp, #4
         pop {fp, pc}
 