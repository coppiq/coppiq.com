; ==================
;       echo
; Writes argv to stdout
;
; Blueberry Spryte
; Cerium 1.0 Core
; Dev:  @coppiq
; Date: 17 May 2026
; ==================

.include "cerium.s"

.text
.global _start

_start:
    mov r7, sys_write
    mov r0, stdout
    mov r2, #1
    ldr r8, [sp] ; argc
    ldr r9, [sp + 1]

    mov r10, #1
:
    cmp r10, r8
    bge end

    add r1, r9, r10
    svc

    push " "
    mov r1, sp
    svc
    add sp, sp, #1

    add r10, r10, #1
    b :-

end:
    push "\n"
    mov r1, sp
    svc
    add sp, sp, #1

    mov r7, sys_exit
    mov r0, exit_success
    svc