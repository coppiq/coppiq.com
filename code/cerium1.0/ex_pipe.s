; ==================
;      ex_pipe
; Tests the pipe(),
; calls in Cerium
; read(), and wait()
; system calls in
; Cerium 1.0
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 10 May 2026
; ==================

.include "cerium.s"

.text
.global _start

_start:
    mov r7, sys_pipe
    adr r0, pipe_fd
    svc

    mov r7, sys_fork
    svc

    cmp r0, #0
    beq child

parent:
    mov r8, r0
    
    ; print every character
    mov r9, #0
:
    mov r7, sys_write
    ldr r0, [pipe_fd + 1]
    adr r1, message
    add r1, r1, r9 ; manipulate pointer to get char
    mov r2, #1
    svc

    mov r7, sys_sleep
    mov r0, #0.1
    svc

    add r9, r9, #1
    cmp r9, #37
    blt :-

    mov r7, sys_close
    ldr r0, [pipe_fd + 1]
    svc

    mov r7, sys_wait
    mov r0, r8
    adr r1, error_code
    svc

    mov r7, sys_exit
    mov r0, #0
    svc

child:
:
    mov r7, sys_read
    ldr r0, [pipe_fd]
    adr r1, buffer
    mov r2, #1
    svc

    cmp r0, #0
    ble :+

    mov r7, sys_write
    mov r0, stdout
    adr r1, buffer
    svc

    b :-
:
    mov r7, sys_exit
    mov r0, #0
    svc

.data
message: .chars "Message from the " fg_red "parent" fg_default "...\n"
pipe_fd: .chars "00"
error_code: .chars "0"
buffer: .chars "0"