; ==================
;      ex_daemon
; An example of a
; background process
; running in Cerium
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 13 May 2026
; ==================

.include "cerium.s"

.text
.global _start

.define WAIT_TIME 0

_start:
    mov r7, sys_fork
    svc

    cmp r0, #0
    beq child

parent:
    mov r7, sys_exit
    mov r0, exit_success
    svc

child:
    mov r7, sys_getpid
    svc

    ldr r10, [hello_msg]
    len r10, r10
    len r11, r0
    add r10, r10, r11
    add r10, r10, #1
    str r10, [msg_len]

    str r0, [msg_arg]
:
    mov r7, sys_write
    mov r0, stdout
    adr r1, hello_msg
    mov r2, #5
    svc

    mov r7, sys_sleep
    mov r0, WAIT_TIME
    svc

    b :-

.data
    hello_msg: .string "  Hello from the daemon pid "
    msg_arg: .items 1
    .string " \e["
    msg_len: .items 1
    .string "D"