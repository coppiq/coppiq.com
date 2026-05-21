; ==================
;    ex_fibonacci
; Uses stack memory
; to print the first
; numbers in the
; fibonacci sequence
;
; Tests recursion
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 15 May 2026
; ==================

.include "cerium.s"

.text
.global _start


fibonacci:
    ldr r0, [sp + #2] ; n -> r0

    cmp r0, #1 ; if (n <= 1)
    bgt :+
    br ; return n
:
    sub r0, r0, #1
    push r0 ; fibonacci(n - 1) -> r0
    bs fibonacci
    pop r1 ; n - 1
    push r0
    
    sub r1, r1, #1
    push r1 ; fibonacci(n - 2) -> r0
    bs fibonacci
    add sp, sp, #1

    pop r2
    add r0, r0, r2

    br


write_answer:
    push fg_default "\n"
    push r0
    push fg_default ") -> " fg_magenta
    push r3
    push fg_default "fibonacci(" fg_magenta

    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    mov r2, #5
    svc

    br


exit:
    mov r7, sys_exit
    mov r0, exit_success
    svc


err_not_a_number:
    push " is not a number\n"
    push r9
    push "ex_fibonacci: error: "
    
    mov r7, sys_write
    mov r0, stderr
    mov r1, sp
    mov r2, #3
    svc
    br


get_loop_count_from_args:
    mov r3, #17
    mov r4, #18
    mov r10, #0

    ldr r0, [sp + 2]
    cmp r0, #1
    bgt :+
    br
:
    ldr r5, [sp + 3] ; argv
    mov r6, #1
arg_loop:
    cmp r6, r0 ; compare to argc
    blt arg_continue

    cmp r10, #0
    bne :+
    sub r3, r4, #1 ; -a not set, only run last number
    br
:
    mov r3, #0 ; -a set, run all numbers less than arg
    br
arg_continue:
    ldr r9, [r5 + r6] ; load from argv iterator

    ltr r7, r9, #0
    cmp r7, "-"
    bne arg_number
    ; posix-style hyphen argument
    ltr r7, r9, #1
    cmp r7, "a" ; -a (calculate all numbers)
    bne :+
    mov r10, #1
:
    add r6, r6, #1
    b arg_loop
arg_number:
    div r8, r9, #1
    cmp r9, r8
    beq :+
    bs err_not_a_number
    mov r4, #0
    br
:
    mov r4, r9

    add r6, r6, #1
    b arg_loop


_start:
    bs get_loop_count_from_args
    cmp r4, #0
    beq exit

:
    push r3 ; fibonacci(r3) -> r0
    bs fibonacci
    add sp, sp, #1

    bs write_answer

    add r3, r3, #1

    cmp r3, r4
    blt :-

    b exit