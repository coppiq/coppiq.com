; ==================
;     ex_hq9plus
; An HQ9+ interpreter,
; as every system needs
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 12 May 2026
; ==================

.include "cerium.s"

.text
.global _start


verify_chars:
    mov r8, #0
verify_chars_loop:
    cmp r8, r0
    bge verify_chars_end
    ldr r9, [sp + r8]

    cmp r9, "H"
    beq :+
    cmp r9, "Q"
    beq :+
    cmp r9, "9"
    beq :+
    cmp r9, "+"
    beq :+
    cmp r9, "e"
    beq :+
    
    b verify_chars_invalid
:
    add r8, r8, #1
    b verify_chars_loop

verify_chars_invalid:
    push "'\n"
    push r9
    push "hq9+: invalid statement '"

    mov r7, sys_write
    mov r0, stderr
    mov r1, sp
    mov r2, #3
    svc
    add sp, sp, #3

    mov r0, #0
    mov pc, lr

verify_chars_end:
    mov r0, #1
    mov pc, lr


write_prompt:
    push fg_magenta ">>> " fg_default
    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    mov r2, #1
    svc
    
    add sp, sp, #1
    mov pc, lr


nine:
    push " bottles of beer on the wall.\n\n"
    push ""
    push " bottles of beer.\nTake one down, pass it around, "
    push ""
    push " bottles of beer on the wall, "
    push ""

    mov r7, sys_write
    mov r0, stdout
    mov r2, #6

    mov r3, #99
nine_loop:
    cmp r3, #3
    bge :+
    mov r4, "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down, pass it around, 1 bottle of beer on the wall.\n\n1 bottle of beer on the wall, 1 bottle of beer.\nTake it down, pass it around, no more bottles of beer on the wall.\n\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    str r4, [sp]
    mov r2, #1
    mov r1, sp
    svc
    br
:
    str r3, [sp]
    str r3, [sp + 2]
    sub r4, r3, #1
    str r4, [sp + 4]
    mov r1, sp
    svc

    sub r3, r3, #1
    b nine_loop


_start:
    mov r11, #0 ; god-intended accumulator

    sub sp, sp, #256
    
main_loop:
    bl write_prompt

    mov r7, sys_read
    mov r0, stdin
    mov r1, sp
    mov r2, #256
    svc
    sub r0, r0, #1
    mov r10, r0

    bl verify_chars
    cmp r0, #0
    beq main_loop

    mov r8, #0
char_loop:
    cmp r8, r10
    bge main_loop

    ldr r9, [sp + r8]
    cmp r9, "H"
    bne :+
    ; H - print "Hello, World!"
    push "Hello, World!\n"
    
    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    mov r2, #1
    svc
    add sp, sp, #1
    b char_loop_end
:
    cmp r9, "Q"
    bne :+
    ; Q - Print the source code of the command
    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    add r2, r10, #1
    svc
    b char_loop_end
:
    ; 9 - Writes the 99 bottles of beer song
    cmp r9, "9"
    bne :+
    bs nine
    b char_loop_end
:
    ; + - Increments the accumulator
    cmp r9, "+"
    bne :+
    add r11, r11, #1
:
    ; e - Exits the program,
    ; while technically not official hq9+,
    ; i feel this is necessary for a proper
    ; coding experience
    cmp r9, "e"
    bne :+
    b exit
:
char_loop_end:
    add r8, r8, #1
    b char_loop
    
exit:
    mov r7, sys_exit
    mov r0, exit_success
    svc